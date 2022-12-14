#include <defs.h>
#include <x86.h>
#include <stdio.h>
#include <string.h>
#include <swap.h>
#include <swap_enhanced_clock.h>
#include <list.h>

#define PTE_CLOCK_D     0x200

list_entry_t pra_list_head, *clock;

void
_enhanced_clock_print(struct mm_struct *mm, bool select)
{
    list_entry_t *head = mm->sm_priv;
    uint32_t count = 0;
    for (list_entry_t *now = list_next(head); 
        now != head; 
        now = list_next(now), count++)
    {
        struct Page* page = le2page(now, pra_page_link);
        pte_t *ptep = get_pte(mm->pgdir, page->pra_vaddr, 0);
        if (select == 1)
        {
            if (now == clock)
                cprintf("#%d vaddr: 0x%08x %c%c <-clock at\n", 
                    count, 
                    page->pra_vaddr, 
                    (*ptep & PTE_A) ? 'A' : '-', 
                    (*ptep & PTE_CLOCK_D) ? 'D' : '-');
            else
                cprintf("#%d vaddr: 0x%08x %c%c\n", 
                    count, 
                    page->pra_vaddr, 
                    (*ptep & PTE_A) ? 'A' : '-', 
                    (*ptep & PTE_CLOCK_D) ? 'D' : '-');
        }
        else
        {
            if (now == clock)
                cprintf("#%d vaddr: 0x%08x %c%c <-clock at\n", 
                    count, 
                    page->pra_vaddr, 
                    (*ptep & PTE_A) ? 'A' : '-', 
                    (*ptep & PTE_D) ? 'D' : '-');
            else
                cprintf("#%d vaddr: 0x%08x %c%c\n", 
                    count, 
                    page->pra_vaddr, 
                    (*ptep & PTE_A) ? 'A' : '-', 
                    (*ptep & PTE_D) ? 'D' : '-');
        }
    }
}

static int
_enhanced_clock_init_mm(struct mm_struct *mm)
{
    list_init(&pra_list_head);
    mm->sm_priv = &pra_list_head;
    clock = &pra_list_head;

    cprintf(" mm->sm_priv %x in enhanced_clock_init_mm\n",mm->sm_priv);
    return 0;
}

static int
_enhanced_clock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
    list_entry_t *head = (list_entry_t*) mm->sm_priv;
    list_entry_t *entry = &(page->pra_page_link);
    assert(entry != NULL && head != NULL);

    list_add_before(clock, entry);
    struct Page *ptr = le2page(entry, pra_page_link);
    pte_t *pte = get_pte(mm -> pgdir, ptr -> pra_vaddr, 0);
    *pte &= ~(PTE_D|PTE_A);

    _enhanced_clock_print(mm, 0);

    return 0;
}

static int
_enhanced_clock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
    assert(head != NULL);
    assert(in_tick == 0);

    if (clock == head)
        clock = list_next(clock);

    cprintf("------before select------\n");
    _enhanced_clock_print(mm, 0);

    list_entry_t *p = list_next(head);
    struct Page* page;
    uintptr_t va;
    pte_t *ptep;
    while (p != head)
    {
        page = le2page(p, pra_page_link);
        va = page->pra_vaddr;
        ptep = get_pte(mm->pgdir, va, 0);
        assert(*ptep & PTE_P);

        if (*ptep & PTE_D)
        {
            //cprintf("copy 1\n");
            *ptep |= PTE_CLOCK_D;
        }
        else
        {
            //cprintf("copy 0\n");
            *ptep &= ~PTE_CLOCK_D;
        }

        p = list_next(p);
    }

    while (1)
    {
        if (clock == head)
            clock = list_next(clock);

        page = le2page(clock, pra_page_link);
        va = page->pra_vaddr;
        ptep = get_pte(mm->pgdir, va, 0);
        assert(*ptep & PTE_P);
        
        cprintf("visit vaddr: 0x%08x %c%c\n", 
            va, 
            (*ptep & PTE_A) ? 'A' : '-', 
            (*ptep & PTE_CLOCK_D) ? 'D' : '-');

        if ((*ptep & PTE_A) == 0 && (*ptep & PTE_CLOCK_D) == 0) // 00, select this page
        {
            cprintf("select victim page vaddr 0x%08x\n", va);
            p = clock;
            clock = list_next(clock);
            list_del(p);
            *ptr_page = page;
            break;
        }
        else if((*ptep & PTE_A) == 0) // 01 -> 00
        {
            //swapfs_write((va / PGSIZE + 1) << 8, page);
            //cprintf("write page vaddr 0x%x to swap %d\n", va, va / PGSIZE + 1);
            *ptep &= ~PTE_CLOCK_D;
            cprintf("page vaddr 0x%08x -D -> --\n", va);
        }
        else if((*ptep & PTE_CLOCK_D) == 0) // 10 -> 00
        {
            *ptep &= ~PTE_A;
            cprintf("page vaddr 0x%08x A- -> --\n", va);
        }    
        else // 11 -> 01
        {
            *ptep &= ~PTE_A;
            cprintf("page vaddr 0x%08x AD -> -D\n", va);
        }
        tlb_invalidate(mm->pgdir, va);

        clock = list_next(clock);
    }

    cprintf("------after select------\n");
    _enhanced_clock_print(mm, 1);

    return 0;
}

static int
_enhanced_clock_check_swap(void)
{
    pde_t *pgdir = KADDR((pde_t*) rcr3());
    for (int i = 1; i <= 4; ++i) {
        pte_t *ptep = get_pte(pgdir, i * 0x1000, 0);
        swapfs_write((i * 0x1000 / PGSIZE + 1) << 8, pte2page(*ptep));
        *ptep &= ~(PTE_A | PTE_D);
        tlb_invalidate(pgdir, i * 0x1000);
    }
    assert(pgfault_num == 4);

    cprintf("read Virt Page c in enhanced_clock_check_swap\n");
    assert(*(unsigned char *)0x3000 == 0x0c);
    assert(pgfault_num == 4);

    cprintf("write Virt Page a in enhanced_clock_check_swap\n");
    assert(*(unsigned char *)0x1000 == 0x0a);
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num == 4);

    cprintf("read Virt Page d in enhanced_clock_check_swap\n");
    assert(*(unsigned char *)0x4000 == 0x0d);
    assert(pgfault_num == 4);

    cprintf("write Virt Page b in enhanced_clock_check_swap\n");
    assert(*(unsigned char *)0x2000 == 0x0b);
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num == 4);

    cprintf("read Virt Page e in enhanced_clock_check_swap\n");
    unsigned e = *(unsigned char *)0x5000;
    cprintf("e = 0x%04x\n", e);
    assert(pgfault_num == 5);
    
    cprintf("read Virt Page b in enhanced_clock_check_swap\n");
    assert(*(unsigned char *)0x2000 == 0x0b);
    assert(pgfault_num == 5);
    cprintf("write Virt Page a in enhanced_clock_check_swap\n");
    assert(*(unsigned char *)0x1000 == 0x0a);
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num == 5);

    cprintf("read Virt Page b in enhanced_clock_check_swap\n");
    assert(*(unsigned char *)0x2000 == 0x0b);
    assert(pgfault_num == 5);

    cprintf("read Virt Page c in enhanced_clock_check_swap\n");
    assert(*(unsigned char *)0x3000 == 0x0c);
    assert(pgfault_num == 6);

    cprintf("read Virt Page d in enhanced_clock_check_swap\n");
    assert(*(unsigned char *)0x4000 == 0x0d);
    assert(pgfault_num == 7);

    return 0;
}


static int
_enhanced_clock_init(void)
{
    return 0;
}

static int
_enhanced_clock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}

static int
_enhanced_clock_tick_event(struct mm_struct *mm)
{
    return 0;
}

struct swap_manager swap_manager_enhanced_clock =
{
     .name            = "enhanced_clock swap manager",
     .init            = &_enhanced_clock_init,
     .init_mm         = &_enhanced_clock_init_mm,
     .tick_event      = &_enhanced_clock_tick_event,
     .map_swappable   = &_enhanced_clock_map_swappable,
     .set_unswappable = &_enhanced_clock_set_unswappable,
     .swap_out_victim = &_enhanced_clock_swap_out_victim,
     .check_swap      = &_enhanced_clock_check_swap,
};
