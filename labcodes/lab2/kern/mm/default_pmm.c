#include <pmm.h>
#include <list.h>
#include <string.h>
#include <default_pmm.h>

/*  In the First Fit algorithm, the allocator keeps a list of free blocks
 * (known as the free list). Once receiving a allocation request for memory,
 * it scans along the list for the first block that is large enough to satisfy
 * the request. If the chosen block is significantly larger than requested, it
 * is usually splitted, and the remainder will be added into the list as
 * another free block.
 *  Please refer to Page 196~198, Section 8.2 of Yan Wei Min's Chinese book
 * "Data Structure -- C programming language".
*/
// LAB2 EXERCISE 1: YOUR CODE
// you should rewrite functions: `default_init`, `default_init_memmap`,
// `default_alloc_pages`, `default_free_pages`.
/*
 * Details of FFMA
 * (1) Preparation:
 *  In order to implement the First-Fit Memory Allocation (FFMA), we should
 * manage the free memory blocks using a list. The struct `free_area_t` is used
 * for the management of free memory blocks.
 *  First, you should get familiar with the struct `list` in list.h. Struct
 * `list` is a simple doubly linked list implementation. You should know how to
 * USE `list_init`, `list_add`(`list_add_after`), `list_add_before`, `list_del`,
 * `list_next`, `list_prev`.
 *  There's a tricky method that is to transform a general `list` struct to a
 * special struct (such as struct `page`), using the following MACROs: `le2page`
 * (in memlayout.h), (and in future labs: `le2vma` (in vmm.h), `le2proc` (in
 * proc.h), etc).
 * (2) `default_init`:
 *  You can reuse the demo `default_init` function to initialize the `free_list`
 * and set `nr_free` to 0. `free_list` is used to record the free memory blocks.
 * `nr_free` is the total number of the free memory blocks.
 * (3) `default_init_memmap`:
 *  CALL GRAPH: `kern_init` --> `pmm_init` --> `page_init` --> `init_memmap` -->
 * `pmm_manager` --> `init_memmap`.
 *  This function is used to initialize a free block (with parameter `addr_base`,
 * `page_number`). In order to initialize a free block, firstly, you should
 * initialize each page (defined in memlayout.h) in this free block. This
 * procedure includes:
 *  - Setting the bit `PG_property` of `p->flags`, which means this page is
 * valid. P.S. In function `pmm_init` (in pmm.c), the bit `PG_reserved` of
 * `p->flags` is already set.
 *  - If this page is free and is not the first page of a free block,
 * `p->property` should be set to 0.
 *  - If this page is free and is the first page of a free block, `p->property`
 * should be set to be the total number of pages in the block.
 *  - `p->ref` should be 0, because now `p` is free and has no reference.
 *  After that, We can use `p->page_link` to link this page into `free_list`.
 * (e.g.: `list_add_before(&free_list, &(p->page_link));` )
 *  Finally, we should update the sum of the free memory blocks: `nr_free += n`.
 * (4) `default_alloc_pages`:
 *  Search for the first free block (block size >= n) in the free list and reszie
 * the block found, returning the address of this block as the address required by
 * `malloc`.
 *  (4.1)
 *      So you should search the free list like this:
 *          list_entry_t le = &free_list;
 *          while((le=list_next(le)) != &free_list) {
 *          ...
 *      (4.1.1)
 *          In the while loop, get the struct `page` and check if `p->property`
 *      (recording the num of free pages in this block) >= n.
 *              struct Page *p = le2page(le, page_link);
 *              if(p->property >= n){ ...
 *      (4.1.2)
 *          If we find this `p`, it means we've found a free block with its size
 *      >= n, whose first `n` pages can be malloced. Some flag bits of this page
 *      should be set as the following: `PG_reserved = 1`, `PG_property = 0`.
 *      Then, unlink the pages from `free_list`.
 *          (4.1.2.1)
 *              If `p->property > n`, we should re-calculate number of the rest
 *          pages of this free block. (e.g.: `le2page(le,page_link))->property
 *          = p->property - n;`)
 *          (4.1.3)
 *              Re-caluclate `nr_free` (number of the the rest of all free block).
 *          (4.1.4)
 *              return `p`.
 *      (4.2)
 *          If we can not find a free block with its size >=n, then return NULL.
 * (5) `default_free_pages`:
 *  re-link the pages into the free list, and may merge small free blocks into
 * the big ones.
 *  (5.1)
 *      According to the base address of the withdrawed blocks, search the free
 *  list for its correct position (with address from low to high), and insert
 *  the pages. (May use `list_next`, `le2page`, `list_add_before`)
 *  (5.2)
 *      Reset the fields of the pages, such as `p->ref` and `p->flags` (PageProperty)
 *  (5.3)
 *      Try to merge blocks at lower or higher addresses. Notice: This should
 *  change some pages' `p->property` correctly.
 */
free_area_t free_area;

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

// 初始化空闲内存*块*链表
static void
default_init(void) {
    // 对空闲内存块链表初始化
    list_init(&free_list);
    // 将总空闲数目置零
    nr_free = 0;
}

// 初始化*块*, 对其每一*页*进行初始化
static void
default_init_memmap(struct Page *base, size_t n) {
    // 检查: 参数合法性
    assert(n > 0);
    // 初始化: 所有*页*
    // 遍历所有*页*
    struct Page *p = base;
    for (; p != base + n; p ++) {
        // 检查当前页是否是保留的
        assert(PageReserved(p));
        // 标记位清空
        p->flags = 0;
        // 空闲块数置零(即无效)
        p->property = 0;
        // 清空引用计数
        set_page_ref(p, 0);
        // 启用property属性(即, 将页设为空闲)
        SetPageProperty(p);
    }
    // 初始化: 第一*页*
    // 当前块的空闲页数置为n(即, 设置当前块的大小为n, 单位为页)
    base->property = n;
    // 更新总空页数
    nr_free += n;
    // 将这个空闲*块*插入到空闲内存*块*链表的最后
    list_add_before(&free_list, &(base->page_link));
}

// 分配指定页数的连续空闲物理空间, 并且返回分配到的首页指针
static struct Page *
default_alloc_pages(size_t n) {
    // 检查: 参数合法性
    assert(n > 0);
    // 检查: 总的空闲物理页数目是否足够, 不够则返回NULL(分配失败)
    if (n > nr_free) {
        return NULL;
    }
    // 查找: 符合的块
    struct Page *page = NULL;
    list_entry_t *le = list_next(&free_list);
    // 按照物理地址的从小到大顺序遍历空闲内存*块*链表
    while (le != &free_list) {
        struct Page *p = le2page(le, page_link);
        // 如果找到第一个不小于需要的大小连续内存块, 则成功分配
        if (p->property >= n) {
            page = p;
            break;
        }
        le = list_next(le);
    }
    // 处理:
    if (page != NULL) {
        // 该内存块的大小大于需要的内存大小, 将空闲内存块分裂成两块
        if (page->property > n) {
            // 放回 物理地址较大的块
            struct Page *p = page + n;
            // 重新进行初始化
            p->property = page->property - n;
            // 插入到原块之后
            list_add_after(&(page->page_link), &(p->page_link));
        }
        // 取用 取到的块 或 分裂出来物理地址较小的块
        // 设为非空闲
        for (struct Page *p = page; p != page + n; p++) {
            ClearPageProperty(p);
        }
        // 从链表中取出
        list_del(&(page->page_link));
        page->property = 0;
        // 更新总空页数
        nr_free -= n;
    }
    //返回: 分配到的页指针
    return page;
}

// 释放指定的某一物理页开始的若干个连续物理页，并完成first-fit算法中需要信息的维护
static void
default_free_pages(struct Page *base, size_t n) {
    // 检查: 参数合法性
    assert(n > 0);
    // 检查: 所有页 是否是保留的 或 原本就是空闲的
    struct Page *p = base, *p_next = NULL;
    for (; p != base + n; p++) {
        assert(!PageReserved(p) && !PageProperty(p));
        // 清空标志位
        p->flags = 0;
        // 恢复为空闲状态
        SetPageProperty(p);
        // 清空引用计数
        set_page_ref(p, 0);
        p->property = 0;
    }
    // 恢复:
    // 标记该空闲块大小
    base->property = n;
    // 顺序遍历. 找到恰好大于该块位置的空块
    list_entry_t *le = list_next(&free_list);
    while(le != &free_list && le < &(base->page_link)){
        le = list_next(le);
    }
    // 插入到块链表中
    list_add_before(le,&(base->page_link));
    // 更新总空页数
    nr_free += n;
    // 合并:
    // 不是最后一个块, 向后合并
    for(le = list_next(&(base->page_link));
        le != &free_list;
        le = list_next(&(base->page_link))){
        p = le2page(le, page_link);
        // 后一个空闲块 不相邻就退出, 相邻就继续合并
        if(base + base->property != p)
            break;
        base->property += p->property;
        p->property = 0;
        list_del(le);
    }
    // 不是第一个块, 向前合并
    for(le = list_prev(&(base->page_link));
        le != &free_list;
        le = list_prev(le)){
        p = le2page(le, page_link);
        p_next = le2page(list_next(le), page_link);
        // 前一个空闲块 不相邻就退出, 相邻就继续合并
        if(p + p->property != p_next)
            break;
        p->property += p_next->property;
        p_next->property = 0;
        list_del(&(p_next->page_link));
    }
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}

static void
basic_check(void) {
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
    assert((p0 = alloc_page()) != NULL);
    assert((p1 = alloc_page()) != NULL);
    assert((p2 = alloc_page()) != NULL);

    assert(p0 != p1 && p0 != p2 && p1 != p2);
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);

    assert(page2pa(p0) < npage * PGSIZE);
    assert(page2pa(p1) < npage * PGSIZE);
    assert(page2pa(p2) < npage * PGSIZE);

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    assert(alloc_page() == NULL);

    free_page(p0);
    free_page(p1);
    free_page(p2);
    assert(nr_free == 3);

    assert((p0 = alloc_page()) != NULL);
    assert((p1 = alloc_page()) != NULL);
    assert((p2 = alloc_page()) != NULL);

    assert(alloc_page() == NULL);

    free_page(p0);
    assert(!list_empty(&free_list));

    struct Page *p;
    assert((p = alloc_page()) == p0);
    assert(alloc_page() == NULL);

    assert(nr_free == 0);
    free_list = free_list_store;
    nr_free = nr_free_store;

    free_page(p);
    free_page(p1);
    free_page(p2);
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
    assert(p0 != NULL);
    assert(!PageProperty(p0));

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
    assert(alloc_pages(4) == NULL);
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
    assert((p1 = alloc_pages(3)) != NULL);
    assert(alloc_page() == NULL);
    assert(p0 + 2 == p1);

    p2 = p0 + 1;
    free_page(p0);
    free_pages(p1, 3);
    assert(PageProperty(p0) && p0->property == 1);
    assert(PageProperty(p1) && p1->property == 3);

    assert((p0 = alloc_page()) == p2 - 1);
    free_page(p0);
    assert((p0 = alloc_pages(2)) == p2 + 1);

    free_pages(p0, 2);
    free_page(p2);

    assert((p0 = alloc_pages(5)) != NULL);
    assert(alloc_page() == NULL);

    assert(nr_free == 0);
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        assert(le->next->prev == le && le->prev->next == le);
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
    assert(total == 0);
}

const struct pmm_manager default_pmm_manager = {
    .name = "default_pmm_manager",
    .init = default_init,
    .init_memmap = default_init_memmap,
    .alloc_pages = default_alloc_pages,
    .free_pages = default_free_pages,
    .nr_free_pages = default_nr_free_pages,
    .check = default_check,
};

