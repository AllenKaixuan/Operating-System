#include <defs.h>
#include <x86.h>
#include <elf.h>

/* *********************************************************************
 *  a dirt simple boot loader
 *  boot an ELF kernel image from the 1st IDE hard disk.
 *
 *  DISK LAYOUT
 *  *   the 1st sector: store the bootloader(bootasm.S and bootmain.c)
 *  *   The 2nd sector: holds the kernel image(ELF format).
 *
 * BOOT UP STEPS
 *  * when the CPU boots it loads the BIOS into memory and executes it
 *
 *  * the BIOS intializes devices, sets of the interrupt routines, and
 *    reads the first sector of the boot device(e.g., hard-drive)
 *    into memory and jumps to it.
 *
 *  * Assuming this boot loader is stored in the first sector of the
 *    hard-drive, this code takes over...
 *
 *  * control starts in bootasm.S -- which sets up protected mode,
 *    and a stack so C code then run, then calls bootmain()
 *
 *  * bootmain() in this file takes over, reads in the kernel and jumps to it.
 * */

#define SECTSIZE        512
#define ELFHDR          ((struct elfhdr *)0x10000)      // scratch space

/*  waitdisk
 *  do
 *      wait for disk ready
 */
static void
waitdisk(void) {
    while ((inb(0x1F7) & 0xC0) != 0x40)
        /* do nothing */;
}

/* readsect
 * do
 *      read a single sector at @secno into @dst 
 */
static void
readsect(void *dst, uint32_t secno) {
    // wait for disk to be ready
    waitdisk();
    // 往0X1F2地址中写入要读取的扇区数，由于此处需要读一个扇区，因此参数为1
    outb(0x1F2, 1);                         // count = 1
    // 输入LBA参数的0...7位；
    outb(0x1F3, secno & 0xFF);
    // 输入LBA参数的8-15位；
    outb(0x1F4, (secno >> 8) & 0xFF);
    // 输入LBA参数的16-23位；
    outb(0x1F5, (secno >> 16) & 0xFF);
    // 输入LBA参数的24-27位（对应到0-3位），第四位为0表示从主盘读取，其余位被强制置为1；
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
    // 向磁盘发出读命令0x20
    outb(0x1F7, 0x20);                      // cmd 0x20 - read sectors

    // wait for disk to be ready
    waitdisk();

    // read a sector
    insl(0x1F0, dst, SECTSIZE / 4);
}

/*  readseg
 *  do
 *      read @count bytes at @offset from kernel into virtual address @va, might copy more than asked.
 */
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    uintptr_t end_va = va + count;

    // round down to sector boundary
    va -= offset % SECTSIZE;

    // translate from bytes to sectors; kernel starts at sector 1
    uint32_t secno = (offset / SECTSIZE) + 1;

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
        readsect((void *)va, secno);
    }
}

/*  bootmain
 *  the entry of bootloader
 */
void
bootmain(void) {
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC) {
        goto bad;
    }

    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    for (; ph < eph; ph ++) {
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    }

    // call the entry point from the ELF header
    // note: does not return
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();

bad:
    outw(0x8A00, 0x8A00);
    outw(0x8A00, 0x8E00);

    /* do nothing */
    while (1);
}

