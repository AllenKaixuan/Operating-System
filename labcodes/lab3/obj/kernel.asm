
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 40 12 00       	mov    $0x124000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 40 12 c0       	mov    %eax,0xc0124000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 30 12 c0       	mov    $0xc0123000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	b8 14 71 12 c0       	mov    $0xc0127114,%eax
c0100041:	2d 00 60 12 c0       	sub    $0xc0126000,%eax
c0100046:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100051:	00 
c0100052:	c7 04 24 00 60 12 c0 	movl   $0xc0126000,(%esp)
c0100059:	e8 97 8c 00 00       	call   c0108cf5 <memset>

    cons_init();                // init the console
c010005e:	e8 00 16 00 00       	call   c0101663 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100063:	c7 45 f4 a0 8e 10 c0 	movl   $0xc0108ea0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010006d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100071:	c7 04 24 bc 8e 10 c0 	movl   $0xc0108ebc,(%esp)
c0100078:	e8 e8 02 00 00       	call   c0100365 <cprintf>

    print_kerninfo();
c010007d:	e8 06 08 00 00       	call   c0100888 <print_kerninfo>

    grade_backtrace();
c0100082:	e8 9f 00 00 00       	call   c0100126 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100087:	e8 2f 4e 00 00       	call   c0104ebb <pmm_init>

    pic_init();                 // init interrupt controller
c010008c:	e8 b0 1f 00 00       	call   c0102041 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100091:	e8 37 21 00 00       	call   c01021cd <idt_init>

    vmm_init();                 // init virtual memory management
c0100096:	e8 aa 76 00 00       	call   c0107745 <vmm_init>

    ide_init();                 // init ide devices
c010009b:	e8 fd 16 00 00       	call   c010179d <ide_init>
    swap_init();                // init swap
c01000a0:	e8 ba 61 00 00       	call   c010625f <swap_init>

    clock_init();               // init clock interrupt
c01000a5:	e8 18 0d 00 00       	call   c0100dc2 <clock_init>
    intr_enable();              // enable irq interrupt
c01000aa:	e8 f0 1e 00 00       	call   c0101f9f <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000af:	eb fe                	jmp    c01000af <kern_init+0x79>

c01000b1 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000b1:	55                   	push   %ebp
c01000b2:	89 e5                	mov    %esp,%ebp
c01000b4:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000be:	00 
c01000bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000c6:	00 
c01000c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000ce:	e8 0a 0c 00 00       	call   c0100cdd <mon_backtrace>
}
c01000d3:	90                   	nop
c01000d4:	89 ec                	mov    %ebp,%esp
c01000d6:	5d                   	pop    %ebp
c01000d7:	c3                   	ret    

c01000d8 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d8:	55                   	push   %ebp
c01000d9:	89 e5                	mov    %esp,%ebp
c01000db:	83 ec 18             	sub    $0x18,%esp
c01000de:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000e1:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000e4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000e7:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01000ed:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000f1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000f9:	89 04 24             	mov    %eax,(%esp)
c01000fc:	e8 b0 ff ff ff       	call   c01000b1 <grade_backtrace2>
}
c0100101:	90                   	nop
c0100102:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100105:	89 ec                	mov    %ebp,%esp
c0100107:	5d                   	pop    %ebp
c0100108:	c3                   	ret    

c0100109 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100109:	55                   	push   %ebp
c010010a:	89 e5                	mov    %esp,%ebp
c010010c:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c010010f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100112:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100116:	8b 45 08             	mov    0x8(%ebp),%eax
c0100119:	89 04 24             	mov    %eax,(%esp)
c010011c:	e8 b7 ff ff ff       	call   c01000d8 <grade_backtrace1>
}
c0100121:	90                   	nop
c0100122:	89 ec                	mov    %ebp,%esp
c0100124:	5d                   	pop    %ebp
c0100125:	c3                   	ret    

c0100126 <grade_backtrace>:

void
grade_backtrace(void) {
c0100126:	55                   	push   %ebp
c0100127:	89 e5                	mov    %esp,%ebp
c0100129:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010012c:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100131:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100138:	ff 
c0100139:	89 44 24 04          	mov    %eax,0x4(%esp)
c010013d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100144:	e8 c0 ff ff ff       	call   c0100109 <grade_backtrace0>
}
c0100149:	90                   	nop
c010014a:	89 ec                	mov    %ebp,%esp
c010014c:	5d                   	pop    %ebp
c010014d:	c3                   	ret    

c010014e <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010014e:	55                   	push   %ebp
c010014f:	89 e5                	mov    %esp,%ebp
c0100151:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100154:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100157:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010015a:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010015d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100160:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100164:	83 e0 03             	and    $0x3,%eax
c0100167:	89 c2                	mov    %eax,%edx
c0100169:	a1 00 60 12 c0       	mov    0xc0126000,%eax
c010016e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100172:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100176:	c7 04 24 c1 8e 10 c0 	movl   $0xc0108ec1,(%esp)
c010017d:	e8 e3 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100182:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100186:	89 c2                	mov    %eax,%edx
c0100188:	a1 00 60 12 c0       	mov    0xc0126000,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 cf 8e 10 c0 	movl   $0xc0108ecf,(%esp)
c010019c:	e8 c4 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c01001a1:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001a5:	89 c2                	mov    %eax,%edx
c01001a7:	a1 00 60 12 c0       	mov    0xc0126000,%eax
c01001ac:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b4:	c7 04 24 dd 8e 10 c0 	movl   $0xc0108edd,(%esp)
c01001bb:	e8 a5 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001c0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001c4:	89 c2                	mov    %eax,%edx
c01001c6:	a1 00 60 12 c0       	mov    0xc0126000,%eax
c01001cb:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d3:	c7 04 24 eb 8e 10 c0 	movl   $0xc0108eeb,(%esp)
c01001da:	e8 86 01 00 00       	call   c0100365 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001df:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001e3:	89 c2                	mov    %eax,%edx
c01001e5:	a1 00 60 12 c0       	mov    0xc0126000,%eax
c01001ea:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001f2:	c7 04 24 f9 8e 10 c0 	movl   $0xc0108ef9,(%esp)
c01001f9:	e8 67 01 00 00       	call   c0100365 <cprintf>
    round ++;
c01001fe:	a1 00 60 12 c0       	mov    0xc0126000,%eax
c0100203:	40                   	inc    %eax
c0100204:	a3 00 60 12 c0       	mov    %eax,0xc0126000
}
c0100209:	90                   	nop
c010020a:	89 ec                	mov    %ebp,%esp
c010020c:	5d                   	pop    %ebp
c010020d:	c3                   	ret    

c010020e <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c010020e:	55                   	push   %ebp
c010020f:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c0100211:	90                   	nop
c0100212:	5d                   	pop    %ebp
c0100213:	c3                   	ret    

c0100214 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100214:	55                   	push   %ebp
c0100215:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100217:	90                   	nop
c0100218:	5d                   	pop    %ebp
c0100219:	c3                   	ret    

c010021a <lab1_switch_test>:

static void
lab1_switch_test(void) {
c010021a:	55                   	push   %ebp
c010021b:	89 e5                	mov    %esp,%ebp
c010021d:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100220:	e8 29 ff ff ff       	call   c010014e <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100225:	c7 04 24 08 8f 10 c0 	movl   $0xc0108f08,(%esp)
c010022c:	e8 34 01 00 00       	call   c0100365 <cprintf>
    lab1_switch_to_user();
c0100231:	e8 d8 ff ff ff       	call   c010020e <lab1_switch_to_user>
    lab1_print_cur_status();
c0100236:	e8 13 ff ff ff       	call   c010014e <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010023b:	c7 04 24 28 8f 10 c0 	movl   $0xc0108f28,(%esp)
c0100242:	e8 1e 01 00 00       	call   c0100365 <cprintf>
    lab1_switch_to_kernel();
c0100247:	e8 c8 ff ff ff       	call   c0100214 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010024c:	e8 fd fe ff ff       	call   c010014e <lab1_print_cur_status>
}
c0100251:	90                   	nop
c0100252:	89 ec                	mov    %ebp,%esp
c0100254:	5d                   	pop    %ebp
c0100255:	c3                   	ret    

c0100256 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100256:	55                   	push   %ebp
c0100257:	89 e5                	mov    %esp,%ebp
c0100259:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c010025c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100260:	74 13                	je     c0100275 <readline+0x1f>
        cprintf("%s", prompt);
c0100262:	8b 45 08             	mov    0x8(%ebp),%eax
c0100265:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100269:	c7 04 24 47 8f 10 c0 	movl   $0xc0108f47,(%esp)
c0100270:	e8 f0 00 00 00       	call   c0100365 <cprintf>
    }
    int i = 0, c;
c0100275:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c010027c:	e8 73 01 00 00       	call   c01003f4 <getchar>
c0100281:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100284:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100288:	79 07                	jns    c0100291 <readline+0x3b>
            return NULL;
c010028a:	b8 00 00 00 00       	mov    $0x0,%eax
c010028f:	eb 78                	jmp    c0100309 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100291:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100295:	7e 28                	jle    c01002bf <readline+0x69>
c0100297:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010029e:	7f 1f                	jg     c01002bf <readline+0x69>
            cputchar(c);
c01002a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002a3:	89 04 24             	mov    %eax,(%esp)
c01002a6:	e8 e2 00 00 00       	call   c010038d <cputchar>
            buf[i ++] = c;
c01002ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002ae:	8d 50 01             	lea    0x1(%eax),%edx
c01002b1:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002b7:	88 90 20 60 12 c0    	mov    %dl,-0x3fed9fe0(%eax)
c01002bd:	eb 45                	jmp    c0100304 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
c01002bf:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002c3:	75 16                	jne    c01002db <readline+0x85>
c01002c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002c9:	7e 10                	jle    c01002db <readline+0x85>
            cputchar(c);
c01002cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ce:	89 04 24             	mov    %eax,(%esp)
c01002d1:	e8 b7 00 00 00       	call   c010038d <cputchar>
            i --;
c01002d6:	ff 4d f4             	decl   -0xc(%ebp)
c01002d9:	eb 29                	jmp    c0100304 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
c01002db:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002df:	74 06                	je     c01002e7 <readline+0x91>
c01002e1:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002e5:	75 95                	jne    c010027c <readline+0x26>
            cputchar(c);
c01002e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ea:	89 04 24             	mov    %eax,(%esp)
c01002ed:	e8 9b 00 00 00       	call   c010038d <cputchar>
            buf[i] = '\0';
c01002f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002f5:	05 20 60 12 c0       	add    $0xc0126020,%eax
c01002fa:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002fd:	b8 20 60 12 c0       	mov    $0xc0126020,%eax
c0100302:	eb 05                	jmp    c0100309 <readline+0xb3>
        c = getchar();
c0100304:	e9 73 ff ff ff       	jmp    c010027c <readline+0x26>
        }
    }
}
c0100309:	89 ec                	mov    %ebp,%esp
c010030b:	5d                   	pop    %ebp
c010030c:	c3                   	ret    

c010030d <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010030d:	55                   	push   %ebp
c010030e:	89 e5                	mov    %esp,%ebp
c0100310:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100313:	8b 45 08             	mov    0x8(%ebp),%eax
c0100316:	89 04 24             	mov    %eax,(%esp)
c0100319:	e8 74 13 00 00       	call   c0101692 <cons_putc>
    (*cnt) ++;
c010031e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100321:	8b 00                	mov    (%eax),%eax
c0100323:	8d 50 01             	lea    0x1(%eax),%edx
c0100326:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100329:	89 10                	mov    %edx,(%eax)
}
c010032b:	90                   	nop
c010032c:	89 ec                	mov    %ebp,%esp
c010032e:	5d                   	pop    %ebp
c010032f:	c3                   	ret    

c0100330 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100330:	55                   	push   %ebp
c0100331:	89 e5                	mov    %esp,%ebp
c0100333:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100336:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010033d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100340:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100344:	8b 45 08             	mov    0x8(%ebp),%eax
c0100347:	89 44 24 08          	mov    %eax,0x8(%esp)
c010034b:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010034e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100352:	c7 04 24 0d 03 10 c0 	movl   $0xc010030d,(%esp)
c0100359:	e8 ea 80 00 00       	call   c0108448 <vprintfmt>
    return cnt;
c010035e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100361:	89 ec                	mov    %ebp,%esp
c0100363:	5d                   	pop    %ebp
c0100364:	c3                   	ret    

c0100365 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100365:	55                   	push   %ebp
c0100366:	89 e5                	mov    %esp,%ebp
c0100368:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010036b:	8d 45 0c             	lea    0xc(%ebp),%eax
c010036e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100371:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100374:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100378:	8b 45 08             	mov    0x8(%ebp),%eax
c010037b:	89 04 24             	mov    %eax,(%esp)
c010037e:	e8 ad ff ff ff       	call   c0100330 <vcprintf>
c0100383:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100386:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100389:	89 ec                	mov    %ebp,%esp
c010038b:	5d                   	pop    %ebp
c010038c:	c3                   	ret    

c010038d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010038d:	55                   	push   %ebp
c010038e:	89 e5                	mov    %esp,%ebp
c0100390:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100393:	8b 45 08             	mov    0x8(%ebp),%eax
c0100396:	89 04 24             	mov    %eax,(%esp)
c0100399:	e8 f4 12 00 00       	call   c0101692 <cons_putc>
}
c010039e:	90                   	nop
c010039f:	89 ec                	mov    %ebp,%esp
c01003a1:	5d                   	pop    %ebp
c01003a2:	c3                   	ret    

c01003a3 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01003a3:	55                   	push   %ebp
c01003a4:	89 e5                	mov    %esp,%ebp
c01003a6:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01003a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01003b0:	eb 13                	jmp    c01003c5 <cputs+0x22>
        cputch(c, &cnt);
c01003b2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01003b6:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003b9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01003bd:	89 04 24             	mov    %eax,(%esp)
c01003c0:	e8 48 ff ff ff       	call   c010030d <cputch>
    while ((c = *str ++) != '\0') {
c01003c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01003c8:	8d 50 01             	lea    0x1(%eax),%edx
c01003cb:	89 55 08             	mov    %edx,0x8(%ebp)
c01003ce:	0f b6 00             	movzbl (%eax),%eax
c01003d1:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003d4:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003d8:	75 d8                	jne    c01003b2 <cputs+0xf>
    }
    cputch('\n', &cnt);
c01003da:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003e1:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003e8:	e8 20 ff ff ff       	call   c010030d <cputch>
    return cnt;
c01003ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003f0:	89 ec                	mov    %ebp,%esp
c01003f2:	5d                   	pop    %ebp
c01003f3:	c3                   	ret    

c01003f4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003f4:	55                   	push   %ebp
c01003f5:	89 e5                	mov    %esp,%ebp
c01003f7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003fa:	90                   	nop
c01003fb:	e8 d1 12 00 00       	call   c01016d1 <cons_getc>
c0100400:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100403:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100407:	74 f2                	je     c01003fb <getchar+0x7>
        /* do nothing */;
    return c;
c0100409:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010040c:	89 ec                	mov    %ebp,%esp
c010040e:	5d                   	pop    %ebp
c010040f:	c3                   	ret    

c0100410 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c0100410:	55                   	push   %ebp
c0100411:	89 e5                	mov    %esp,%ebp
c0100413:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100416:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100419:	8b 00                	mov    (%eax),%eax
c010041b:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010041e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100421:	8b 00                	mov    (%eax),%eax
c0100423:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100426:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c010042d:	e9 ca 00 00 00       	jmp    c01004fc <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
c0100432:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100435:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	89 c2                	mov    %eax,%edx
c010043c:	c1 ea 1f             	shr    $0x1f,%edx
c010043f:	01 d0                	add    %edx,%eax
c0100441:	d1 f8                	sar    %eax
c0100443:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100446:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100449:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010044c:	eb 03                	jmp    c0100451 <stab_binsearch+0x41>
            m --;
c010044e:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100451:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100454:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100457:	7c 1f                	jl     c0100478 <stab_binsearch+0x68>
c0100459:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010045c:	89 d0                	mov    %edx,%eax
c010045e:	01 c0                	add    %eax,%eax
c0100460:	01 d0                	add    %edx,%eax
c0100462:	c1 e0 02             	shl    $0x2,%eax
c0100465:	89 c2                	mov    %eax,%edx
c0100467:	8b 45 08             	mov    0x8(%ebp),%eax
c010046a:	01 d0                	add    %edx,%eax
c010046c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100470:	0f b6 c0             	movzbl %al,%eax
c0100473:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100476:	75 d6                	jne    c010044e <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c0100478:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010047b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010047e:	7d 09                	jge    c0100489 <stab_binsearch+0x79>
            l = true_m + 1;
c0100480:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100483:	40                   	inc    %eax
c0100484:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100487:	eb 73                	jmp    c01004fc <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
c0100489:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100490:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100493:	89 d0                	mov    %edx,%eax
c0100495:	01 c0                	add    %eax,%eax
c0100497:	01 d0                	add    %edx,%eax
c0100499:	c1 e0 02             	shl    $0x2,%eax
c010049c:	89 c2                	mov    %eax,%edx
c010049e:	8b 45 08             	mov    0x8(%ebp),%eax
c01004a1:	01 d0                	add    %edx,%eax
c01004a3:	8b 40 08             	mov    0x8(%eax),%eax
c01004a6:	39 45 18             	cmp    %eax,0x18(%ebp)
c01004a9:	76 11                	jbe    c01004bc <stab_binsearch+0xac>
            *region_left = m;
c01004ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004b1:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c01004b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004b6:	40                   	inc    %eax
c01004b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004ba:	eb 40                	jmp    c01004fc <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
c01004bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004bf:	89 d0                	mov    %edx,%eax
c01004c1:	01 c0                	add    %eax,%eax
c01004c3:	01 d0                	add    %edx,%eax
c01004c5:	c1 e0 02             	shl    $0x2,%eax
c01004c8:	89 c2                	mov    %eax,%edx
c01004ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01004cd:	01 d0                	add    %edx,%eax
c01004cf:	8b 40 08             	mov    0x8(%eax),%eax
c01004d2:	39 45 18             	cmp    %eax,0x18(%ebp)
c01004d5:	73 14                	jae    c01004eb <stab_binsearch+0xdb>
            *region_right = m - 1;
c01004d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004da:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004dd:	8b 45 10             	mov    0x10(%ebp),%eax
c01004e0:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e5:	48                   	dec    %eax
c01004e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004e9:	eb 11                	jmp    c01004fc <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004f1:	89 10                	mov    %edx,(%eax)
            l = m;
c01004f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004f9:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01004fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004ff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0100502:	0f 8e 2a ff ff ff    	jle    c0100432 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c0100508:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010050c:	75 0f                	jne    c010051d <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
c010050e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100511:	8b 00                	mov    (%eax),%eax
c0100513:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100516:	8b 45 10             	mov    0x10(%ebp),%eax
c0100519:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c010051b:	eb 3e                	jmp    c010055b <stab_binsearch+0x14b>
        l = *region_right;
c010051d:	8b 45 10             	mov    0x10(%ebp),%eax
c0100520:	8b 00                	mov    (%eax),%eax
c0100522:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100525:	eb 03                	jmp    c010052a <stab_binsearch+0x11a>
c0100527:	ff 4d fc             	decl   -0x4(%ebp)
c010052a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052d:	8b 00                	mov    (%eax),%eax
c010052f:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c0100532:	7e 1f                	jle    c0100553 <stab_binsearch+0x143>
c0100534:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100537:	89 d0                	mov    %edx,%eax
c0100539:	01 c0                	add    %eax,%eax
c010053b:	01 d0                	add    %edx,%eax
c010053d:	c1 e0 02             	shl    $0x2,%eax
c0100540:	89 c2                	mov    %eax,%edx
c0100542:	8b 45 08             	mov    0x8(%ebp),%eax
c0100545:	01 d0                	add    %edx,%eax
c0100547:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010054b:	0f b6 c0             	movzbl %al,%eax
c010054e:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100551:	75 d4                	jne    c0100527 <stab_binsearch+0x117>
        *region_left = l;
c0100553:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100556:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100559:	89 10                	mov    %edx,(%eax)
}
c010055b:	90                   	nop
c010055c:	89 ec                	mov    %ebp,%esp
c010055e:	5d                   	pop    %ebp
c010055f:	c3                   	ret    

c0100560 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100560:	55                   	push   %ebp
c0100561:	89 e5                	mov    %esp,%ebp
c0100563:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100566:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100569:	c7 00 4c 8f 10 c0    	movl   $0xc0108f4c,(%eax)
    info->eip_line = 0;
c010056f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100572:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100579:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057c:	c7 40 08 4c 8f 10 c0 	movl   $0xc0108f4c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100583:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100586:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010058d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100590:	8b 55 08             	mov    0x8(%ebp),%edx
c0100593:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100596:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100599:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c01005a0:	c7 45 f4 20 af 10 c0 	movl   $0xc010af20,-0xc(%ebp)
    stab_end = __STAB_END__;
c01005a7:	c7 45 f0 58 b2 11 c0 	movl   $0xc011b258,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01005ae:	c7 45 ec 59 b2 11 c0 	movl   $0xc011b259,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01005b5:	c7 45 e8 0b 01 12 c0 	movl   $0xc012010b,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01005bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005bf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005c2:	76 0b                	jbe    c01005cf <debuginfo_eip+0x6f>
c01005c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005c7:	48                   	dec    %eax
c01005c8:	0f b6 00             	movzbl (%eax),%eax
c01005cb:	84 c0                	test   %al,%al
c01005cd:	74 0a                	je     c01005d9 <debuginfo_eip+0x79>
        return -1;
c01005cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005d4:	e9 ab 02 00 00       	jmp    c0100884 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005d9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005e3:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01005e6:	c1 f8 02             	sar    $0x2,%eax
c01005e9:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005ef:	48                   	dec    %eax
c01005f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01005f6:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005fa:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c0100601:	00 
c0100602:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0100605:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100609:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c010060c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100610:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100613:	89 04 24             	mov    %eax,(%esp)
c0100616:	e8 f5 fd ff ff       	call   c0100410 <stab_binsearch>
    if (lfile == 0)
c010061b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010061e:	85 c0                	test   %eax,%eax
c0100620:	75 0a                	jne    c010062c <debuginfo_eip+0xcc>
        return -1;
c0100622:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100627:	e9 58 02 00 00       	jmp    c0100884 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010062c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010062f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100632:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100635:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100638:	8b 45 08             	mov    0x8(%ebp),%eax
c010063b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010063f:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100646:	00 
c0100647:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010064a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010064e:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100651:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	89 04 24             	mov    %eax,(%esp)
c010065b:	e8 b0 fd ff ff       	call   c0100410 <stab_binsearch>

    if (lfun <= rfun) {
c0100660:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100663:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	7f 78                	jg     c01006e2 <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100684:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100687:	39 c2                	cmp    %eax,%edx
c0100689:	73 22                	jae    c01006ad <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010068b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068e:	89 c2                	mov    %eax,%edx
c0100690:	89 d0                	mov    %edx,%eax
c0100692:	01 c0                	add    %eax,%eax
c0100694:	01 d0                	add    %edx,%eax
c0100696:	c1 e0 02             	shl    $0x2,%eax
c0100699:	89 c2                	mov    %eax,%edx
c010069b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069e:	01 d0                	add    %edx,%eax
c01006a0:	8b 10                	mov    (%eax),%edx
c01006a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01006a5:	01 c2                	add    %eax,%edx
c01006a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006aa:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01006ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b0:	89 c2                	mov    %eax,%edx
c01006b2:	89 d0                	mov    %edx,%eax
c01006b4:	01 c0                	add    %eax,%eax
c01006b6:	01 d0                	add    %edx,%eax
c01006b8:	c1 e0 02             	shl    $0x2,%eax
c01006bb:	89 c2                	mov    %eax,%edx
c01006bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006c0:	01 d0                	add    %edx,%eax
c01006c2:	8b 50 08             	mov    0x8(%eax),%edx
c01006c5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c8:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ce:	8b 40 10             	mov    0x10(%eax),%eax
c01006d1:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006da:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006e0:	eb 15                	jmp    c01006f7 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e5:	8b 55 08             	mov    0x8(%ebp),%edx
c01006e8:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006fa:	8b 40 08             	mov    0x8(%eax),%eax
c01006fd:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c0100704:	00 
c0100705:	89 04 24             	mov    %eax,(%esp)
c0100708:	e8 60 84 00 00       	call   c0108b6d <strfind>
c010070d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100710:	8b 4a 08             	mov    0x8(%edx),%ecx
c0100713:	29 c8                	sub    %ecx,%eax
c0100715:	89 c2                	mov    %eax,%edx
c0100717:	8b 45 0c             	mov    0xc(%ebp),%eax
c010071a:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010071d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100720:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100724:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010072b:	00 
c010072c:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010072f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100733:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100736:	89 44 24 04          	mov    %eax,0x4(%esp)
c010073a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010073d:	89 04 24             	mov    %eax,(%esp)
c0100740:	e8 cb fc ff ff       	call   c0100410 <stab_binsearch>
    if (lline <= rline) {
c0100745:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100748:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010074b:	39 c2                	cmp    %eax,%edx
c010074d:	7f 23                	jg     c0100772 <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
c010074f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100752:	89 c2                	mov    %eax,%edx
c0100754:	89 d0                	mov    %edx,%eax
c0100756:	01 c0                	add    %eax,%eax
c0100758:	01 d0                	add    %edx,%eax
c010075a:	c1 e0 02             	shl    $0x2,%eax
c010075d:	89 c2                	mov    %eax,%edx
c010075f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100762:	01 d0                	add    %edx,%eax
c0100764:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100768:	89 c2                	mov    %eax,%edx
c010076a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010076d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100770:	eb 11                	jmp    c0100783 <debuginfo_eip+0x223>
        return -1;
c0100772:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100777:	e9 08 01 00 00       	jmp    c0100884 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010077c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077f:	48                   	dec    %eax
c0100780:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100783:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100789:	39 c2                	cmp    %eax,%edx
c010078b:	7c 56                	jl     c01007e3 <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
c010078d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100790:	89 c2                	mov    %eax,%edx
c0100792:	89 d0                	mov    %edx,%eax
c0100794:	01 c0                	add    %eax,%eax
c0100796:	01 d0                	add    %edx,%eax
c0100798:	c1 e0 02             	shl    $0x2,%eax
c010079b:	89 c2                	mov    %eax,%edx
c010079d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007a0:	01 d0                	add    %edx,%eax
c01007a2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a6:	3c 84                	cmp    $0x84,%al
c01007a8:	74 39                	je     c01007e3 <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01007aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ad:	89 c2                	mov    %eax,%edx
c01007af:	89 d0                	mov    %edx,%eax
c01007b1:	01 c0                	add    %eax,%eax
c01007b3:	01 d0                	add    %edx,%eax
c01007b5:	c1 e0 02             	shl    $0x2,%eax
c01007b8:	89 c2                	mov    %eax,%edx
c01007ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bd:	01 d0                	add    %edx,%eax
c01007bf:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007c3:	3c 64                	cmp    $0x64,%al
c01007c5:	75 b5                	jne    c010077c <debuginfo_eip+0x21c>
c01007c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ca:	89 c2                	mov    %eax,%edx
c01007cc:	89 d0                	mov    %edx,%eax
c01007ce:	01 c0                	add    %eax,%eax
c01007d0:	01 d0                	add    %edx,%eax
c01007d2:	c1 e0 02             	shl    $0x2,%eax
c01007d5:	89 c2                	mov    %eax,%edx
c01007d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007da:	01 d0                	add    %edx,%eax
c01007dc:	8b 40 08             	mov    0x8(%eax),%eax
c01007df:	85 c0                	test   %eax,%eax
c01007e1:	74 99                	je     c010077c <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007e3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007e9:	39 c2                	cmp    %eax,%edx
c01007eb:	7c 42                	jl     c010082f <debuginfo_eip+0x2cf>
c01007ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f0:	89 c2                	mov    %eax,%edx
c01007f2:	89 d0                	mov    %edx,%eax
c01007f4:	01 c0                	add    %eax,%eax
c01007f6:	01 d0                	add    %edx,%eax
c01007f8:	c1 e0 02             	shl    $0x2,%eax
c01007fb:	89 c2                	mov    %eax,%edx
c01007fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100800:	01 d0                	add    %edx,%eax
c0100802:	8b 10                	mov    (%eax),%edx
c0100804:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100807:	2b 45 ec             	sub    -0x14(%ebp),%eax
c010080a:	39 c2                	cmp    %eax,%edx
c010080c:	73 21                	jae    c010082f <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
c010080e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100811:	89 c2                	mov    %eax,%edx
c0100813:	89 d0                	mov    %edx,%eax
c0100815:	01 c0                	add    %eax,%eax
c0100817:	01 d0                	add    %edx,%eax
c0100819:	c1 e0 02             	shl    $0x2,%eax
c010081c:	89 c2                	mov    %eax,%edx
c010081e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100821:	01 d0                	add    %edx,%eax
c0100823:	8b 10                	mov    (%eax),%edx
c0100825:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100828:	01 c2                	add    %eax,%edx
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c010082f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100832:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100835:	39 c2                	cmp    %eax,%edx
c0100837:	7d 46                	jge    c010087f <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
c0100839:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010083c:	40                   	inc    %eax
c010083d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100840:	eb 16                	jmp    c0100858 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100842:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100845:	8b 40 14             	mov    0x14(%eax),%eax
c0100848:	8d 50 01             	lea    0x1(%eax),%edx
c010084b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010084e:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100851:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100854:	40                   	inc    %eax
c0100855:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100858:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010085b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010085e:	39 c2                	cmp    %eax,%edx
c0100860:	7d 1d                	jge    c010087f <debuginfo_eip+0x31f>
c0100862:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100865:	89 c2                	mov    %eax,%edx
c0100867:	89 d0                	mov    %edx,%eax
c0100869:	01 c0                	add    %eax,%eax
c010086b:	01 d0                	add    %edx,%eax
c010086d:	c1 e0 02             	shl    $0x2,%eax
c0100870:	89 c2                	mov    %eax,%edx
c0100872:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100875:	01 d0                	add    %edx,%eax
c0100877:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010087b:	3c a0                	cmp    $0xa0,%al
c010087d:	74 c3                	je     c0100842 <debuginfo_eip+0x2e2>
        }
    }
    return 0;
c010087f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100884:	89 ec                	mov    %ebp,%esp
c0100886:	5d                   	pop    %ebp
c0100887:	c3                   	ret    

c0100888 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100888:	55                   	push   %ebp
c0100889:	89 e5                	mov    %esp,%ebp
c010088b:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010088e:	c7 04 24 56 8f 10 c0 	movl   $0xc0108f56,(%esp)
c0100895:	e8 cb fa ff ff       	call   c0100365 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010089a:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c01008a1:	c0 
c01008a2:	c7 04 24 6f 8f 10 c0 	movl   $0xc0108f6f,(%esp)
c01008a9:	e8 b7 fa ff ff       	call   c0100365 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008ae:	c7 44 24 04 81 8e 10 	movl   $0xc0108e81,0x4(%esp)
c01008b5:	c0 
c01008b6:	c7 04 24 87 8f 10 c0 	movl   $0xc0108f87,(%esp)
c01008bd:	e8 a3 fa ff ff       	call   c0100365 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008c2:	c7 44 24 04 00 60 12 	movl   $0xc0126000,0x4(%esp)
c01008c9:	c0 
c01008ca:	c7 04 24 9f 8f 10 c0 	movl   $0xc0108f9f,(%esp)
c01008d1:	e8 8f fa ff ff       	call   c0100365 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008d6:	c7 44 24 04 14 71 12 	movl   $0xc0127114,0x4(%esp)
c01008dd:	c0 
c01008de:	c7 04 24 b7 8f 10 c0 	movl   $0xc0108fb7,(%esp)
c01008e5:	e8 7b fa ff ff       	call   c0100365 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008ea:	b8 14 71 12 c0       	mov    $0xc0127114,%eax
c01008ef:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01008f4:	05 ff 03 00 00       	add    $0x3ff,%eax
c01008f9:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ff:	85 c0                	test   %eax,%eax
c0100901:	0f 48 c2             	cmovs  %edx,%eax
c0100904:	c1 f8 0a             	sar    $0xa,%eax
c0100907:	89 44 24 04          	mov    %eax,0x4(%esp)
c010090b:	c7 04 24 d0 8f 10 c0 	movl   $0xc0108fd0,(%esp)
c0100912:	e8 4e fa ff ff       	call   c0100365 <cprintf>
}
c0100917:	90                   	nop
c0100918:	89 ec                	mov    %ebp,%esp
c010091a:	5d                   	pop    %ebp
c010091b:	c3                   	ret    

c010091c <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c010091c:	55                   	push   %ebp
c010091d:	89 e5                	mov    %esp,%ebp
c010091f:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100925:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	8b 45 08             	mov    0x8(%ebp),%eax
c010092f:	89 04 24             	mov    %eax,(%esp)
c0100932:	e8 29 fc ff ff       	call   c0100560 <debuginfo_eip>
c0100937:	85 c0                	test   %eax,%eax
c0100939:	74 15                	je     c0100950 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c010093b:	8b 45 08             	mov    0x8(%ebp),%eax
c010093e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100942:	c7 04 24 fa 8f 10 c0 	movl   $0xc0108ffa,(%esp)
c0100949:	e8 17 fa ff ff       	call   c0100365 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c010094e:	eb 6c                	jmp    c01009bc <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100950:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100957:	eb 1b                	jmp    c0100974 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
c0100959:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010095c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010095f:	01 d0                	add    %edx,%eax
c0100961:	0f b6 10             	movzbl (%eax),%edx
c0100964:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010096a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010096d:	01 c8                	add    %ecx,%eax
c010096f:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100971:	ff 45 f4             	incl   -0xc(%ebp)
c0100974:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100977:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010097a:	7c dd                	jl     c0100959 <print_debuginfo+0x3d>
        fnname[j] = '\0';
c010097c:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100982:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100985:	01 d0                	add    %edx,%eax
c0100987:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c010098a:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c010098d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100990:	29 d0                	sub    %edx,%eax
c0100992:	89 c1                	mov    %eax,%ecx
c0100994:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100997:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010099a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010099e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009a4:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009a8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009b0:	c7 04 24 16 90 10 c0 	movl   $0xc0109016,(%esp)
c01009b7:	e8 a9 f9 ff ff       	call   c0100365 <cprintf>
}
c01009bc:	90                   	nop
c01009bd:	89 ec                	mov    %ebp,%esp
c01009bf:	5d                   	pop    %ebp
c01009c0:	c3                   	ret    

c01009c1 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009c1:	55                   	push   %ebp
c01009c2:	89 e5                	mov    %esp,%ebp
c01009c4:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009c7:	8b 45 04             	mov    0x4(%ebp),%eax
c01009ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009d0:	89 ec                	mov    %ebp,%esp
c01009d2:	5d                   	pop    %ebp
c01009d3:	c3                   	ret    

c01009d4 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009d4:	55                   	push   %ebp
c01009d5:	89 e5                	mov    %esp,%ebp
c01009d7:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009da:	89 e8                	mov    %ebp,%eax
c01009dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009df:	8b 45 e0             	mov    -0x20(%ebp),%eax
      */
    // ebp是第一个被调用函数的栈帧的base pointer，
    // eip是在该栈帧对应函数中调用下一个栈帧对应函数的指令的下一条指令的地址（return address）
    // args是传递给这第一个被调用的函数的参数
    // get ebp and eip
    uint32_t ebp = read_ebp(), eip = read_eip();
c01009e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009e5:	e8 d7 ff ff ff       	call   c01009c1 <read_eip>
c01009ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // traverse all
    for(int i=0,j=0; ebp!=0 && i<STACKFRAME_DEPTH;i++){
c01009ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009f4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c01009fb:	e9 84 00 00 00       	jmp    c0100a84 <print_stackframe+0xb0>
        //print ebp & eip
        cprintf("ebp:0x%08x eip:0x%08x args:",ebp,eip);
c0100a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a03:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a0a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a0e:	c7 04 24 28 90 10 c0 	movl   $0xc0109028,(%esp)
c0100a15:	e8 4b f9 ff ff       	call   c0100365 <cprintf>
        //print args
        // +1 -> 返回地址
        // +2 -> 参数
        uint32_t *args =(uint32_t*)ebp+2;
c0100a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a1d:	83 c0 08             	add    $0x8,%eax
c0100a20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for(j=0;j<4;j++){
c0100a23:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a2a:	eb 24                	jmp    c0100a50 <print_stackframe+0x7c>
            cprintf("0x%08x ",args[j]);
c0100a2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a2f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a39:	01 d0                	add    %edx,%eax
c0100a3b:	8b 00                	mov    (%eax),%eax
c0100a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a41:	c7 04 24 44 90 10 c0 	movl   $0xc0109044,(%esp)
c0100a48:	e8 18 f9 ff ff       	call   c0100365 <cprintf>
        for(j=0;j<4;j++){
c0100a4d:	ff 45 e8             	incl   -0x18(%ebp)
c0100a50:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a54:	7e d6                	jle    c0100a2c <print_stackframe+0x58>
        }
        cprintf("\n");
c0100a56:	c7 04 24 4c 90 10 c0 	movl   $0xc010904c,(%esp)
c0100a5d:	e8 03 f9 ff ff       	call   c0100365 <cprintf>
        // print the C calling function name and line number, etc
        print_debuginfo(eip - 1);
c0100a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a65:	48                   	dec    %eax
c0100a66:	89 04 24             	mov    %eax,(%esp)
c0100a69:	e8 ae fe ff ff       	call   c010091c <print_debuginfo>
        // get next func call
        // popup a calling stackframe
        // the calling funciton's return addr eip  = ss:[ebp+4]
        // the calling funciton's ebp = ss:[ebp]
        eip = ((uint32_t *)ebp)[1];
c0100a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a71:	83 c0 04             	add    $0x4,%eax
c0100a74:	8b 00                	mov    (%eax),%eax
c0100a76:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a7c:	8b 00                	mov    (%eax),%eax
c0100a7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(int i=0,j=0; ebp!=0 && i<STACKFRAME_DEPTH;i++){
c0100a81:	ff 45 ec             	incl   -0x14(%ebp)
c0100a84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a88:	74 0a                	je     c0100a94 <print_stackframe+0xc0>
c0100a8a:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a8e:	0f 8e 6c ff ff ff    	jle    c0100a00 <print_stackframe+0x2c>
    }
}
c0100a94:	90                   	nop
c0100a95:	89 ec                	mov    %ebp,%esp
c0100a97:	5d                   	pop    %ebp
c0100a98:	c3                   	ret    

c0100a99 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a99:	55                   	push   %ebp
c0100a9a:	89 e5                	mov    %esp,%ebp
c0100a9c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aa6:	eb 0c                	jmp    c0100ab4 <parse+0x1b>
            *buf ++ = '\0';
c0100aa8:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aab:	8d 50 01             	lea    0x1(%eax),%edx
c0100aae:	89 55 08             	mov    %edx,0x8(%ebp)
c0100ab1:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ab4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab7:	0f b6 00             	movzbl (%eax),%eax
c0100aba:	84 c0                	test   %al,%al
c0100abc:	74 1d                	je     c0100adb <parse+0x42>
c0100abe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac1:	0f b6 00             	movzbl (%eax),%eax
c0100ac4:	0f be c0             	movsbl %al,%eax
c0100ac7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100acb:	c7 04 24 d0 90 10 c0 	movl   $0xc01090d0,(%esp)
c0100ad2:	e8 62 80 00 00       	call   c0108b39 <strchr>
c0100ad7:	85 c0                	test   %eax,%eax
c0100ad9:	75 cd                	jne    c0100aa8 <parse+0xf>
        }
        if (*buf == '\0') {
c0100adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ade:	0f b6 00             	movzbl (%eax),%eax
c0100ae1:	84 c0                	test   %al,%al
c0100ae3:	74 65                	je     c0100b4a <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ae5:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ae9:	75 14                	jne    c0100aff <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100aeb:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100af2:	00 
c0100af3:	c7 04 24 d5 90 10 c0 	movl   $0xc01090d5,(%esp)
c0100afa:	e8 66 f8 ff ff       	call   c0100365 <cprintf>
        }
        argv[argc ++] = buf;
c0100aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b02:	8d 50 01             	lea    0x1(%eax),%edx
c0100b05:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b12:	01 c2                	add    %eax,%edx
c0100b14:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b17:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b19:	eb 03                	jmp    c0100b1e <parse+0x85>
            buf ++;
c0100b1b:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b21:	0f b6 00             	movzbl (%eax),%eax
c0100b24:	84 c0                	test   %al,%al
c0100b26:	74 8c                	je     c0100ab4 <parse+0x1b>
c0100b28:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b2b:	0f b6 00             	movzbl (%eax),%eax
c0100b2e:	0f be c0             	movsbl %al,%eax
c0100b31:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b35:	c7 04 24 d0 90 10 c0 	movl   $0xc01090d0,(%esp)
c0100b3c:	e8 f8 7f 00 00       	call   c0108b39 <strchr>
c0100b41:	85 c0                	test   %eax,%eax
c0100b43:	74 d6                	je     c0100b1b <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b45:	e9 6a ff ff ff       	jmp    c0100ab4 <parse+0x1b>
            break;
c0100b4a:	90                   	nop
        }
    }
    return argc;
c0100b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b4e:	89 ec                	mov    %ebp,%esp
c0100b50:	5d                   	pop    %ebp
c0100b51:	c3                   	ret    

c0100b52 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b52:	55                   	push   %ebp
c0100b53:	89 e5                	mov    %esp,%ebp
c0100b55:	83 ec 68             	sub    $0x68,%esp
c0100b58:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b5b:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b5e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b62:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b65:	89 04 24             	mov    %eax,(%esp)
c0100b68:	e8 2c ff ff ff       	call   c0100a99 <parse>
c0100b6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b74:	75 0a                	jne    c0100b80 <runcmd+0x2e>
        return 0;
c0100b76:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b7b:	e9 83 00 00 00       	jmp    c0100c03 <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b87:	eb 5a                	jmp    c0100be3 <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b89:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0100b8c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100b8f:	89 c8                	mov    %ecx,%eax
c0100b91:	01 c0                	add    %eax,%eax
c0100b93:	01 c8                	add    %ecx,%eax
c0100b95:	c1 e0 02             	shl    $0x2,%eax
c0100b98:	05 00 30 12 c0       	add    $0xc0123000,%eax
c0100b9d:	8b 00                	mov    (%eax),%eax
c0100b9f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100ba3:	89 04 24             	mov    %eax,(%esp)
c0100ba6:	e8 f2 7e 00 00       	call   c0108a9d <strcmp>
c0100bab:	85 c0                	test   %eax,%eax
c0100bad:	75 31                	jne    c0100be0 <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100baf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bb2:	89 d0                	mov    %edx,%eax
c0100bb4:	01 c0                	add    %eax,%eax
c0100bb6:	01 d0                	add    %edx,%eax
c0100bb8:	c1 e0 02             	shl    $0x2,%eax
c0100bbb:	05 08 30 12 c0       	add    $0xc0123008,%eax
c0100bc0:	8b 10                	mov    (%eax),%edx
c0100bc2:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bc5:	83 c0 04             	add    $0x4,%eax
c0100bc8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100bcb:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100bce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100bd1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd9:	89 1c 24             	mov    %ebx,(%esp)
c0100bdc:	ff d2                	call   *%edx
c0100bde:	eb 23                	jmp    c0100c03 <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100be0:	ff 45 f4             	incl   -0xc(%ebp)
c0100be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100be6:	83 f8 02             	cmp    $0x2,%eax
c0100be9:	76 9e                	jbe    c0100b89 <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100beb:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bee:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bf2:	c7 04 24 f3 90 10 c0 	movl   $0xc01090f3,(%esp)
c0100bf9:	e8 67 f7 ff ff       	call   c0100365 <cprintf>
    return 0;
c0100bfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100c06:	89 ec                	mov    %ebp,%esp
c0100c08:	5d                   	pop    %ebp
c0100c09:	c3                   	ret    

c0100c0a <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c0a:	55                   	push   %ebp
c0100c0b:	89 e5                	mov    %esp,%ebp
c0100c0d:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c10:	c7 04 24 0c 91 10 c0 	movl   $0xc010910c,(%esp)
c0100c17:	e8 49 f7 ff ff       	call   c0100365 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c1c:	c7 04 24 34 91 10 c0 	movl   $0xc0109134,(%esp)
c0100c23:	e8 3d f7 ff ff       	call   c0100365 <cprintf>

    if (tf != NULL) {
c0100c28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c2c:	74 0b                	je     c0100c39 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c31:	89 04 24             	mov    %eax,(%esp)
c0100c34:	e8 d0 17 00 00       	call   c0102409 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c39:	c7 04 24 59 91 10 c0 	movl   $0xc0109159,(%esp)
c0100c40:	e8 11 f6 ff ff       	call   c0100256 <readline>
c0100c45:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c4c:	74 eb                	je     c0100c39 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
c0100c4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c51:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c58:	89 04 24             	mov    %eax,(%esp)
c0100c5b:	e8 f2 fe ff ff       	call   c0100b52 <runcmd>
c0100c60:	85 c0                	test   %eax,%eax
c0100c62:	78 02                	js     c0100c66 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
c0100c64:	eb d3                	jmp    c0100c39 <kmonitor+0x2f>
                break;
c0100c66:	90                   	nop
            }
        }
    }
}
c0100c67:	90                   	nop
c0100c68:	89 ec                	mov    %ebp,%esp
c0100c6a:	5d                   	pop    %ebp
c0100c6b:	c3                   	ret    

c0100c6c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c6c:	55                   	push   %ebp
c0100c6d:	89 e5                	mov    %esp,%ebp
c0100c6f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c79:	eb 3d                	jmp    c0100cb8 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c7e:	89 d0                	mov    %edx,%eax
c0100c80:	01 c0                	add    %eax,%eax
c0100c82:	01 d0                	add    %edx,%eax
c0100c84:	c1 e0 02             	shl    $0x2,%eax
c0100c87:	05 04 30 12 c0       	add    $0xc0123004,%eax
c0100c8c:	8b 10                	mov    (%eax),%edx
c0100c8e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100c91:	89 c8                	mov    %ecx,%eax
c0100c93:	01 c0                	add    %eax,%eax
c0100c95:	01 c8                	add    %ecx,%eax
c0100c97:	c1 e0 02             	shl    $0x2,%eax
c0100c9a:	05 00 30 12 c0       	add    $0xc0123000,%eax
c0100c9f:	8b 00                	mov    (%eax),%eax
c0100ca1:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100ca5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ca9:	c7 04 24 5d 91 10 c0 	movl   $0xc010915d,(%esp)
c0100cb0:	e8 b0 f6 ff ff       	call   c0100365 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cb5:	ff 45 f4             	incl   -0xc(%ebp)
c0100cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cbb:	83 f8 02             	cmp    $0x2,%eax
c0100cbe:	76 bb                	jbe    c0100c7b <mon_help+0xf>
    }
    return 0;
c0100cc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc5:	89 ec                	mov    %ebp,%esp
c0100cc7:	5d                   	pop    %ebp
c0100cc8:	c3                   	ret    

c0100cc9 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cc9:	55                   	push   %ebp
c0100cca:	89 e5                	mov    %esp,%ebp
c0100ccc:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100ccf:	e8 b4 fb ff ff       	call   c0100888 <print_kerninfo>
    return 0;
c0100cd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cd9:	89 ec                	mov    %ebp,%esp
c0100cdb:	5d                   	pop    %ebp
c0100cdc:	c3                   	ret    

c0100cdd <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cdd:	55                   	push   %ebp
c0100cde:	89 e5                	mov    %esp,%ebp
c0100ce0:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100ce3:	e8 ec fc ff ff       	call   c01009d4 <print_stackframe>
    return 0;
c0100ce8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ced:	89 ec                	mov    %ebp,%esp
c0100cef:	5d                   	pop    %ebp
c0100cf0:	c3                   	ret    

c0100cf1 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cf1:	55                   	push   %ebp
c0100cf2:	89 e5                	mov    %esp,%ebp
c0100cf4:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cf7:	a1 20 64 12 c0       	mov    0xc0126420,%eax
c0100cfc:	85 c0                	test   %eax,%eax
c0100cfe:	75 5b                	jne    c0100d5b <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c0100d00:	c7 05 20 64 12 c0 01 	movl   $0x1,0xc0126420
c0100d07:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100d0a:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100d10:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d13:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d17:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d1a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d1e:	c7 04 24 66 91 10 c0 	movl   $0xc0109166,(%esp)
c0100d25:	e8 3b f6 ff ff       	call   c0100365 <cprintf>
    vcprintf(fmt, ap);
c0100d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d2d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d31:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d34:	89 04 24             	mov    %eax,(%esp)
c0100d37:	e8 f4 f5 ff ff       	call   c0100330 <vcprintf>
    cprintf("\n");
c0100d3c:	c7 04 24 82 91 10 c0 	movl   $0xc0109182,(%esp)
c0100d43:	e8 1d f6 ff ff       	call   c0100365 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d48:	c7 04 24 84 91 10 c0 	movl   $0xc0109184,(%esp)
c0100d4f:	e8 11 f6 ff ff       	call   c0100365 <cprintf>
    print_stackframe();
c0100d54:	e8 7b fc ff ff       	call   c01009d4 <print_stackframe>
c0100d59:	eb 01                	jmp    c0100d5c <__panic+0x6b>
        goto panic_dead;
c0100d5b:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100d5c:	e8 46 12 00 00       	call   c0101fa7 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d61:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d68:	e8 9d fe ff ff       	call   c0100c0a <kmonitor>
c0100d6d:	eb f2                	jmp    c0100d61 <__panic+0x70>

c0100d6f <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d6f:	55                   	push   %ebp
c0100d70:	89 e5                	mov    %esp,%ebp
c0100d72:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d75:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d78:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d7e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d82:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d85:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d89:	c7 04 24 96 91 10 c0 	movl   $0xc0109196,(%esp)
c0100d90:	e8 d0 f5 ff ff       	call   c0100365 <cprintf>
    vcprintf(fmt, ap);
c0100d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d98:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d9c:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d9f:	89 04 24             	mov    %eax,(%esp)
c0100da2:	e8 89 f5 ff ff       	call   c0100330 <vcprintf>
    cprintf("\n");
c0100da7:	c7 04 24 82 91 10 c0 	movl   $0xc0109182,(%esp)
c0100dae:	e8 b2 f5 ff ff       	call   c0100365 <cprintf>
    va_end(ap);
}
c0100db3:	90                   	nop
c0100db4:	89 ec                	mov    %ebp,%esp
c0100db6:	5d                   	pop    %ebp
c0100db7:	c3                   	ret    

c0100db8 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100db8:	55                   	push   %ebp
c0100db9:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100dbb:	a1 20 64 12 c0       	mov    0xc0126420,%eax
}
c0100dc0:	5d                   	pop    %ebp
c0100dc1:	c3                   	ret    

c0100dc2 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100dc2:	55                   	push   %ebp
c0100dc3:	89 e5                	mov    %esp,%ebp
c0100dc5:	83 ec 28             	sub    $0x28,%esp
c0100dc8:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100dce:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100dd2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dd6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dda:	ee                   	out    %al,(%dx)
}
c0100ddb:	90                   	nop
c0100ddc:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100de2:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100de6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dea:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dee:	ee                   	out    %al,(%dx)
}
c0100def:	90                   	nop
c0100df0:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100df6:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100dfa:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dfe:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100e02:	ee                   	out    %al,(%dx)
}
c0100e03:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100e04:	c7 05 24 64 12 c0 00 	movl   $0x0,0xc0126424
c0100e0b:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e0e:	c7 04 24 b4 91 10 c0 	movl   $0xc01091b4,(%esp)
c0100e15:	e8 4b f5 ff ff       	call   c0100365 <cprintf>
    pic_enable(IRQ_TIMER);
c0100e1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e21:	e8 e6 11 00 00       	call   c010200c <pic_enable>
}
c0100e26:	90                   	nop
c0100e27:	89 ec                	mov    %ebp,%esp
c0100e29:	5d                   	pop    %ebp
c0100e2a:	c3                   	ret    

c0100e2b <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e2b:	55                   	push   %ebp
c0100e2c:	89 e5                	mov    %esp,%ebp
c0100e2e:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e31:	9c                   	pushf  
c0100e32:	58                   	pop    %eax
c0100e33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e39:	25 00 02 00 00       	and    $0x200,%eax
c0100e3e:	85 c0                	test   %eax,%eax
c0100e40:	74 0c                	je     c0100e4e <__intr_save+0x23>
        intr_disable();
c0100e42:	e8 60 11 00 00       	call   c0101fa7 <intr_disable>
        return 1;
c0100e47:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e4c:	eb 05                	jmp    c0100e53 <__intr_save+0x28>
    }
    return 0;
c0100e4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e53:	89 ec                	mov    %ebp,%esp
c0100e55:	5d                   	pop    %ebp
c0100e56:	c3                   	ret    

c0100e57 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e57:	55                   	push   %ebp
c0100e58:	89 e5                	mov    %esp,%ebp
c0100e5a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e61:	74 05                	je     c0100e68 <__intr_restore+0x11>
        intr_enable();
c0100e63:	e8 37 11 00 00       	call   c0101f9f <intr_enable>
    }
}
c0100e68:	90                   	nop
c0100e69:	89 ec                	mov    %ebp,%esp
c0100e6b:	5d                   	pop    %ebp
c0100e6c:	c3                   	ret    

c0100e6d <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e6d:	55                   	push   %ebp
c0100e6e:	89 e5                	mov    %esp,%ebp
c0100e70:	83 ec 10             	sub    $0x10,%esp
c0100e73:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e79:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e7d:	89 c2                	mov    %eax,%edx
c0100e7f:	ec                   	in     (%dx),%al
c0100e80:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100e83:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e89:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e8d:	89 c2                	mov    %eax,%edx
c0100e8f:	ec                   	in     (%dx),%al
c0100e90:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e93:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e99:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e9d:	89 c2                	mov    %eax,%edx
c0100e9f:	ec                   	in     (%dx),%al
c0100ea0:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100ea3:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100ea9:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100ead:	89 c2                	mov    %eax,%edx
c0100eaf:	ec                   	in     (%dx),%al
c0100eb0:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100eb3:	90                   	nop
c0100eb4:	89 ec                	mov    %ebp,%esp
c0100eb6:	5d                   	pop    %ebp
c0100eb7:	c3                   	ret    

c0100eb8 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100eb8:	55                   	push   %ebp
c0100eb9:	89 e5                	mov    %esp,%ebp
c0100ebb:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100ebe:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100ec5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec8:	0f b7 00             	movzwl (%eax),%eax
c0100ecb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ed2:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eda:	0f b7 00             	movzwl (%eax),%eax
c0100edd:	0f b7 c0             	movzwl %ax,%eax
c0100ee0:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100ee5:	74 12                	je     c0100ef9 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ee7:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eee:	66 c7 05 46 64 12 c0 	movw   $0x3b4,0xc0126446
c0100ef5:	b4 03 
c0100ef7:	eb 13                	jmp    c0100f0c <cga_init+0x54>
    } else {
        *cp = was;
c0100ef9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100efc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100f00:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100f03:	66 c7 05 46 64 12 c0 	movw   $0x3d4,0xc0126446
c0100f0a:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100f0c:	0f b7 05 46 64 12 c0 	movzwl 0xc0126446,%eax
c0100f13:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f17:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f1b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f1f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f23:	ee                   	out    %al,(%dx)
}
c0100f24:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f25:	0f b7 05 46 64 12 c0 	movzwl 0xc0126446,%eax
c0100f2c:	40                   	inc    %eax
c0100f2d:	0f b7 c0             	movzwl %ax,%eax
c0100f30:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f34:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f38:	89 c2                	mov    %eax,%edx
c0100f3a:	ec                   	in     (%dx),%al
c0100f3b:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100f3e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f42:	0f b6 c0             	movzbl %al,%eax
c0100f45:	c1 e0 08             	shl    $0x8,%eax
c0100f48:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f4b:	0f b7 05 46 64 12 c0 	movzwl 0xc0126446,%eax
c0100f52:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f56:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f5a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f5e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f62:	ee                   	out    %al,(%dx)
}
c0100f63:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f64:	0f b7 05 46 64 12 c0 	movzwl 0xc0126446,%eax
c0100f6b:	40                   	inc    %eax
c0100f6c:	0f b7 c0             	movzwl %ax,%eax
c0100f6f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f73:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f77:	89 c2                	mov    %eax,%edx
c0100f79:	ec                   	in     (%dx),%al
c0100f7a:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100f7d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f81:	0f b6 c0             	movzbl %al,%eax
c0100f84:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f87:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f8a:	a3 40 64 12 c0       	mov    %eax,0xc0126440
    crt_pos = pos;
c0100f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f92:	0f b7 c0             	movzwl %ax,%eax
c0100f95:	66 a3 44 64 12 c0    	mov    %ax,0xc0126444
}
c0100f9b:	90                   	nop
c0100f9c:	89 ec                	mov    %ebp,%esp
c0100f9e:	5d                   	pop    %ebp
c0100f9f:	c3                   	ret    

c0100fa0 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100fa0:	55                   	push   %ebp
c0100fa1:	89 e5                	mov    %esp,%ebp
c0100fa3:	83 ec 48             	sub    $0x48,%esp
c0100fa6:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100fac:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fb0:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100fb4:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100fb8:	ee                   	out    %al,(%dx)
}
c0100fb9:	90                   	nop
c0100fba:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100fc0:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fc4:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100fc8:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100fcc:	ee                   	out    %al,(%dx)
}
c0100fcd:	90                   	nop
c0100fce:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100fd4:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fd8:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100fdc:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100fe0:	ee                   	out    %al,(%dx)
}
c0100fe1:	90                   	nop
c0100fe2:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fe8:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fec:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100ff0:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100ff4:	ee                   	out    %al,(%dx)
}
c0100ff5:	90                   	nop
c0100ff6:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0100ffc:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101000:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101004:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101008:	ee                   	out    %al,(%dx)
}
c0101009:	90                   	nop
c010100a:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0101010:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101014:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101018:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010101c:	ee                   	out    %al,(%dx)
}
c010101d:	90                   	nop
c010101e:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0101024:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101028:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010102c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101030:	ee                   	out    %al,(%dx)
}
c0101031:	90                   	nop
c0101032:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101038:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c010103c:	89 c2                	mov    %eax,%edx
c010103e:	ec                   	in     (%dx),%al
c010103f:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0101042:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101046:	3c ff                	cmp    $0xff,%al
c0101048:	0f 95 c0             	setne  %al
c010104b:	0f b6 c0             	movzbl %al,%eax
c010104e:	a3 48 64 12 c0       	mov    %eax,0xc0126448
c0101053:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101059:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010105d:	89 c2                	mov    %eax,%edx
c010105f:	ec                   	in     (%dx),%al
c0101060:	88 45 f1             	mov    %al,-0xf(%ebp)
c0101063:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101069:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010106d:	89 c2                	mov    %eax,%edx
c010106f:	ec                   	in     (%dx),%al
c0101070:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101073:	a1 48 64 12 c0       	mov    0xc0126448,%eax
c0101078:	85 c0                	test   %eax,%eax
c010107a:	74 0c                	je     c0101088 <serial_init+0xe8>
        pic_enable(IRQ_COM1);
c010107c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101083:	e8 84 0f 00 00       	call   c010200c <pic_enable>
    }
}
c0101088:	90                   	nop
c0101089:	89 ec                	mov    %ebp,%esp
c010108b:	5d                   	pop    %ebp
c010108c:	c3                   	ret    

c010108d <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010108d:	55                   	push   %ebp
c010108e:	89 e5                	mov    %esp,%ebp
c0101090:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101093:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010109a:	eb 08                	jmp    c01010a4 <lpt_putc_sub+0x17>
        delay();
c010109c:	e8 cc fd ff ff       	call   c0100e6d <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010a1:	ff 45 fc             	incl   -0x4(%ebp)
c01010a4:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c01010aa:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01010ae:	89 c2                	mov    %eax,%edx
c01010b0:	ec                   	in     (%dx),%al
c01010b1:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01010b4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01010b8:	84 c0                	test   %al,%al
c01010ba:	78 09                	js     c01010c5 <lpt_putc_sub+0x38>
c01010bc:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01010c3:	7e d7                	jle    c010109c <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c01010c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01010c8:	0f b6 c0             	movzbl %al,%eax
c01010cb:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c01010d1:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010d4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010d8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010dc:	ee                   	out    %al,(%dx)
}
c01010dd:	90                   	nop
c01010de:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010e4:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010e8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010ec:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010f0:	ee                   	out    %al,(%dx)
}
c01010f1:	90                   	nop
c01010f2:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c01010f8:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010fc:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101100:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101104:	ee                   	out    %al,(%dx)
}
c0101105:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101106:	90                   	nop
c0101107:	89 ec                	mov    %ebp,%esp
c0101109:	5d                   	pop    %ebp
c010110a:	c3                   	ret    

c010110b <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c010110b:	55                   	push   %ebp
c010110c:	89 e5                	mov    %esp,%ebp
c010110e:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101111:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101115:	74 0d                	je     c0101124 <lpt_putc+0x19>
        lpt_putc_sub(c);
c0101117:	8b 45 08             	mov    0x8(%ebp),%eax
c010111a:	89 04 24             	mov    %eax,(%esp)
c010111d:	e8 6b ff ff ff       	call   c010108d <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c0101122:	eb 24                	jmp    c0101148 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
c0101124:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010112b:	e8 5d ff ff ff       	call   c010108d <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101130:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101137:	e8 51 ff ff ff       	call   c010108d <lpt_putc_sub>
        lpt_putc_sub('\b');
c010113c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101143:	e8 45 ff ff ff       	call   c010108d <lpt_putc_sub>
}
c0101148:	90                   	nop
c0101149:	89 ec                	mov    %ebp,%esp
c010114b:	5d                   	pop    %ebp
c010114c:	c3                   	ret    

c010114d <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c010114d:	55                   	push   %ebp
c010114e:	89 e5                	mov    %esp,%ebp
c0101150:	83 ec 38             	sub    $0x38,%esp
c0101153:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
c0101156:	8b 45 08             	mov    0x8(%ebp),%eax
c0101159:	25 00 ff ff ff       	and    $0xffffff00,%eax
c010115e:	85 c0                	test   %eax,%eax
c0101160:	75 07                	jne    c0101169 <cga_putc+0x1c>
        c |= 0x0700;
c0101162:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101169:	8b 45 08             	mov    0x8(%ebp),%eax
c010116c:	0f b6 c0             	movzbl %al,%eax
c010116f:	83 f8 0d             	cmp    $0xd,%eax
c0101172:	74 72                	je     c01011e6 <cga_putc+0x99>
c0101174:	83 f8 0d             	cmp    $0xd,%eax
c0101177:	0f 8f a3 00 00 00    	jg     c0101220 <cga_putc+0xd3>
c010117d:	83 f8 08             	cmp    $0x8,%eax
c0101180:	74 0a                	je     c010118c <cga_putc+0x3f>
c0101182:	83 f8 0a             	cmp    $0xa,%eax
c0101185:	74 4c                	je     c01011d3 <cga_putc+0x86>
c0101187:	e9 94 00 00 00       	jmp    c0101220 <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
c010118c:	0f b7 05 44 64 12 c0 	movzwl 0xc0126444,%eax
c0101193:	85 c0                	test   %eax,%eax
c0101195:	0f 84 af 00 00 00    	je     c010124a <cga_putc+0xfd>
            crt_pos --;
c010119b:	0f b7 05 44 64 12 c0 	movzwl 0xc0126444,%eax
c01011a2:	48                   	dec    %eax
c01011a3:	0f b7 c0             	movzwl %ax,%eax
c01011a6:	66 a3 44 64 12 c0    	mov    %ax,0xc0126444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01011af:	98                   	cwtl   
c01011b0:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01011b5:	98                   	cwtl   
c01011b6:	83 c8 20             	or     $0x20,%eax
c01011b9:	98                   	cwtl   
c01011ba:	8b 0d 40 64 12 c0    	mov    0xc0126440,%ecx
c01011c0:	0f b7 15 44 64 12 c0 	movzwl 0xc0126444,%edx
c01011c7:	01 d2                	add    %edx,%edx
c01011c9:	01 ca                	add    %ecx,%edx
c01011cb:	0f b7 c0             	movzwl %ax,%eax
c01011ce:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01011d1:	eb 77                	jmp    c010124a <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
c01011d3:	0f b7 05 44 64 12 c0 	movzwl 0xc0126444,%eax
c01011da:	83 c0 50             	add    $0x50,%eax
c01011dd:	0f b7 c0             	movzwl %ax,%eax
c01011e0:	66 a3 44 64 12 c0    	mov    %ax,0xc0126444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01011e6:	0f b7 1d 44 64 12 c0 	movzwl 0xc0126444,%ebx
c01011ed:	0f b7 0d 44 64 12 c0 	movzwl 0xc0126444,%ecx
c01011f4:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c01011f9:	89 c8                	mov    %ecx,%eax
c01011fb:	f7 e2                	mul    %edx
c01011fd:	c1 ea 06             	shr    $0x6,%edx
c0101200:	89 d0                	mov    %edx,%eax
c0101202:	c1 e0 02             	shl    $0x2,%eax
c0101205:	01 d0                	add    %edx,%eax
c0101207:	c1 e0 04             	shl    $0x4,%eax
c010120a:	29 c1                	sub    %eax,%ecx
c010120c:	89 ca                	mov    %ecx,%edx
c010120e:	0f b7 d2             	movzwl %dx,%edx
c0101211:	89 d8                	mov    %ebx,%eax
c0101213:	29 d0                	sub    %edx,%eax
c0101215:	0f b7 c0             	movzwl %ax,%eax
c0101218:	66 a3 44 64 12 c0    	mov    %ax,0xc0126444
        break;
c010121e:	eb 2b                	jmp    c010124b <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101220:	8b 0d 40 64 12 c0    	mov    0xc0126440,%ecx
c0101226:	0f b7 05 44 64 12 c0 	movzwl 0xc0126444,%eax
c010122d:	8d 50 01             	lea    0x1(%eax),%edx
c0101230:	0f b7 d2             	movzwl %dx,%edx
c0101233:	66 89 15 44 64 12 c0 	mov    %dx,0xc0126444
c010123a:	01 c0                	add    %eax,%eax
c010123c:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c010123f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101242:	0f b7 c0             	movzwl %ax,%eax
c0101245:	66 89 02             	mov    %ax,(%edx)
        break;
c0101248:	eb 01                	jmp    c010124b <cga_putc+0xfe>
        break;
c010124a:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c010124b:	0f b7 05 44 64 12 c0 	movzwl 0xc0126444,%eax
c0101252:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101257:	76 5e                	jbe    c01012b7 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101259:	a1 40 64 12 c0       	mov    0xc0126440,%eax
c010125e:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101264:	a1 40 64 12 c0       	mov    0xc0126440,%eax
c0101269:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101270:	00 
c0101271:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101275:	89 04 24             	mov    %eax,(%esp)
c0101278:	e8 ba 7a 00 00       	call   c0108d37 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010127d:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101284:	eb 15                	jmp    c010129b <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
c0101286:	8b 15 40 64 12 c0    	mov    0xc0126440,%edx
c010128c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010128f:	01 c0                	add    %eax,%eax
c0101291:	01 d0                	add    %edx,%eax
c0101293:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101298:	ff 45 f4             	incl   -0xc(%ebp)
c010129b:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01012a2:	7e e2                	jle    c0101286 <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
c01012a4:	0f b7 05 44 64 12 c0 	movzwl 0xc0126444,%eax
c01012ab:	83 e8 50             	sub    $0x50,%eax
c01012ae:	0f b7 c0             	movzwl %ax,%eax
c01012b1:	66 a3 44 64 12 c0    	mov    %ax,0xc0126444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012b7:	0f b7 05 46 64 12 c0 	movzwl 0xc0126446,%eax
c01012be:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c01012c2:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012c6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012ca:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012ce:	ee                   	out    %al,(%dx)
}
c01012cf:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c01012d0:	0f b7 05 44 64 12 c0 	movzwl 0xc0126444,%eax
c01012d7:	c1 e8 08             	shr    $0x8,%eax
c01012da:	0f b7 c0             	movzwl %ax,%eax
c01012dd:	0f b6 c0             	movzbl %al,%eax
c01012e0:	0f b7 15 46 64 12 c0 	movzwl 0xc0126446,%edx
c01012e7:	42                   	inc    %edx
c01012e8:	0f b7 d2             	movzwl %dx,%edx
c01012eb:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c01012ef:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012f2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012f6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012fa:	ee                   	out    %al,(%dx)
}
c01012fb:	90                   	nop
    outb(addr_6845, 15);
c01012fc:	0f b7 05 46 64 12 c0 	movzwl 0xc0126446,%eax
c0101303:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101307:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010130b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010130f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101313:	ee                   	out    %al,(%dx)
}
c0101314:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c0101315:	0f b7 05 44 64 12 c0 	movzwl 0xc0126444,%eax
c010131c:	0f b6 c0             	movzbl %al,%eax
c010131f:	0f b7 15 46 64 12 c0 	movzwl 0xc0126446,%edx
c0101326:	42                   	inc    %edx
c0101327:	0f b7 d2             	movzwl %dx,%edx
c010132a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c010132e:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101331:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101335:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101339:	ee                   	out    %al,(%dx)
}
c010133a:	90                   	nop
}
c010133b:	90                   	nop
c010133c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010133f:	89 ec                	mov    %ebp,%esp
c0101341:	5d                   	pop    %ebp
c0101342:	c3                   	ret    

c0101343 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101343:	55                   	push   %ebp
c0101344:	89 e5                	mov    %esp,%ebp
c0101346:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101349:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101350:	eb 08                	jmp    c010135a <serial_putc_sub+0x17>
        delay();
c0101352:	e8 16 fb ff ff       	call   c0100e6d <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101357:	ff 45 fc             	incl   -0x4(%ebp)
c010135a:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101360:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101364:	89 c2                	mov    %eax,%edx
c0101366:	ec                   	in     (%dx),%al
c0101367:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010136a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010136e:	0f b6 c0             	movzbl %al,%eax
c0101371:	83 e0 20             	and    $0x20,%eax
c0101374:	85 c0                	test   %eax,%eax
c0101376:	75 09                	jne    c0101381 <serial_putc_sub+0x3e>
c0101378:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010137f:	7e d1                	jle    c0101352 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c0101381:	8b 45 08             	mov    0x8(%ebp),%eax
c0101384:	0f b6 c0             	movzbl %al,%eax
c0101387:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010138d:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101390:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101394:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101398:	ee                   	out    %al,(%dx)
}
c0101399:	90                   	nop
}
c010139a:	90                   	nop
c010139b:	89 ec                	mov    %ebp,%esp
c010139d:	5d                   	pop    %ebp
c010139e:	c3                   	ret    

c010139f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010139f:	55                   	push   %ebp
c01013a0:	89 e5                	mov    %esp,%ebp
c01013a2:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01013a5:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01013a9:	74 0d                	je     c01013b8 <serial_putc+0x19>
        serial_putc_sub(c);
c01013ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01013ae:	89 04 24             	mov    %eax,(%esp)
c01013b1:	e8 8d ff ff ff       	call   c0101343 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c01013b6:	eb 24                	jmp    c01013dc <serial_putc+0x3d>
        serial_putc_sub('\b');
c01013b8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013bf:	e8 7f ff ff ff       	call   c0101343 <serial_putc_sub>
        serial_putc_sub(' ');
c01013c4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01013cb:	e8 73 ff ff ff       	call   c0101343 <serial_putc_sub>
        serial_putc_sub('\b');
c01013d0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013d7:	e8 67 ff ff ff       	call   c0101343 <serial_putc_sub>
}
c01013dc:	90                   	nop
c01013dd:	89 ec                	mov    %ebp,%esp
c01013df:	5d                   	pop    %ebp
c01013e0:	c3                   	ret    

c01013e1 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c01013e1:	55                   	push   %ebp
c01013e2:	89 e5                	mov    %esp,%ebp
c01013e4:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c01013e7:	eb 33                	jmp    c010141c <cons_intr+0x3b>
        if (c != 0) {
c01013e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01013ed:	74 2d                	je     c010141c <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c01013ef:	a1 64 66 12 c0       	mov    0xc0126664,%eax
c01013f4:	8d 50 01             	lea    0x1(%eax),%edx
c01013f7:	89 15 64 66 12 c0    	mov    %edx,0xc0126664
c01013fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101400:	88 90 60 64 12 c0    	mov    %dl,-0x3fed9ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101406:	a1 64 66 12 c0       	mov    0xc0126664,%eax
c010140b:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101410:	75 0a                	jne    c010141c <cons_intr+0x3b>
                cons.wpos = 0;
c0101412:	c7 05 64 66 12 c0 00 	movl   $0x0,0xc0126664
c0101419:	00 00 00 
    while ((c = (*proc)()) != -1) {
c010141c:	8b 45 08             	mov    0x8(%ebp),%eax
c010141f:	ff d0                	call   *%eax
c0101421:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101424:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101428:	75 bf                	jne    c01013e9 <cons_intr+0x8>
            }
        }
    }
}
c010142a:	90                   	nop
c010142b:	90                   	nop
c010142c:	89 ec                	mov    %ebp,%esp
c010142e:	5d                   	pop    %ebp
c010142f:	c3                   	ret    

c0101430 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101430:	55                   	push   %ebp
c0101431:	89 e5                	mov    %esp,%ebp
c0101433:	83 ec 10             	sub    $0x10,%esp
c0101436:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010143c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101440:	89 c2                	mov    %eax,%edx
c0101442:	ec                   	in     (%dx),%al
c0101443:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101446:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c010144a:	0f b6 c0             	movzbl %al,%eax
c010144d:	83 e0 01             	and    $0x1,%eax
c0101450:	85 c0                	test   %eax,%eax
c0101452:	75 07                	jne    c010145b <serial_proc_data+0x2b>
        return -1;
c0101454:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101459:	eb 2a                	jmp    c0101485 <serial_proc_data+0x55>
c010145b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101461:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101465:	89 c2                	mov    %eax,%edx
c0101467:	ec                   	in     (%dx),%al
c0101468:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c010146b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c010146f:	0f b6 c0             	movzbl %al,%eax
c0101472:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101475:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101479:	75 07                	jne    c0101482 <serial_proc_data+0x52>
        c = '\b';
c010147b:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101482:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101485:	89 ec                	mov    %ebp,%esp
c0101487:	5d                   	pop    %ebp
c0101488:	c3                   	ret    

c0101489 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101489:	55                   	push   %ebp
c010148a:	89 e5                	mov    %esp,%ebp
c010148c:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010148f:	a1 48 64 12 c0       	mov    0xc0126448,%eax
c0101494:	85 c0                	test   %eax,%eax
c0101496:	74 0c                	je     c01014a4 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101498:	c7 04 24 30 14 10 c0 	movl   $0xc0101430,(%esp)
c010149f:	e8 3d ff ff ff       	call   c01013e1 <cons_intr>
    }
}
c01014a4:	90                   	nop
c01014a5:	89 ec                	mov    %ebp,%esp
c01014a7:	5d                   	pop    %ebp
c01014a8:	c3                   	ret    

c01014a9 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01014a9:	55                   	push   %ebp
c01014aa:	89 e5                	mov    %esp,%ebp
c01014ac:	83 ec 38             	sub    $0x38,%esp
c01014af:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01014b8:	89 c2                	mov    %eax,%edx
c01014ba:	ec                   	in     (%dx),%al
c01014bb:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c01014be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c01014c2:	0f b6 c0             	movzbl %al,%eax
c01014c5:	83 e0 01             	and    $0x1,%eax
c01014c8:	85 c0                	test   %eax,%eax
c01014ca:	75 0a                	jne    c01014d6 <kbd_proc_data+0x2d>
        return -1;
c01014cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014d1:	e9 56 01 00 00       	jmp    c010162c <kbd_proc_data+0x183>
c01014d6:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01014df:	89 c2                	mov    %eax,%edx
c01014e1:	ec                   	in     (%dx),%al
c01014e2:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c01014e5:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c01014e9:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c01014ec:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c01014f0:	75 17                	jne    c0101509 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
c01014f2:	a1 68 66 12 c0       	mov    0xc0126668,%eax
c01014f7:	83 c8 40             	or     $0x40,%eax
c01014fa:	a3 68 66 12 c0       	mov    %eax,0xc0126668
        return 0;
c01014ff:	b8 00 00 00 00       	mov    $0x0,%eax
c0101504:	e9 23 01 00 00       	jmp    c010162c <kbd_proc_data+0x183>
    } else if (data & 0x80) {
c0101509:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010150d:	84 c0                	test   %al,%al
c010150f:	79 45                	jns    c0101556 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101511:	a1 68 66 12 c0       	mov    0xc0126668,%eax
c0101516:	83 e0 40             	and    $0x40,%eax
c0101519:	85 c0                	test   %eax,%eax
c010151b:	75 08                	jne    c0101525 <kbd_proc_data+0x7c>
c010151d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101521:	24 7f                	and    $0x7f,%al
c0101523:	eb 04                	jmp    c0101529 <kbd_proc_data+0x80>
c0101525:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101529:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c010152c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101530:	0f b6 80 40 30 12 c0 	movzbl -0x3fedcfc0(%eax),%eax
c0101537:	0c 40                	or     $0x40,%al
c0101539:	0f b6 c0             	movzbl %al,%eax
c010153c:	f7 d0                	not    %eax
c010153e:	89 c2                	mov    %eax,%edx
c0101540:	a1 68 66 12 c0       	mov    0xc0126668,%eax
c0101545:	21 d0                	and    %edx,%eax
c0101547:	a3 68 66 12 c0       	mov    %eax,0xc0126668
        return 0;
c010154c:	b8 00 00 00 00       	mov    $0x0,%eax
c0101551:	e9 d6 00 00 00       	jmp    c010162c <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
c0101556:	a1 68 66 12 c0       	mov    0xc0126668,%eax
c010155b:	83 e0 40             	and    $0x40,%eax
c010155e:	85 c0                	test   %eax,%eax
c0101560:	74 11                	je     c0101573 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101562:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101566:	a1 68 66 12 c0       	mov    0xc0126668,%eax
c010156b:	83 e0 bf             	and    $0xffffffbf,%eax
c010156e:	a3 68 66 12 c0       	mov    %eax,0xc0126668
    }

    shift |= shiftcode[data];
c0101573:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101577:	0f b6 80 40 30 12 c0 	movzbl -0x3fedcfc0(%eax),%eax
c010157e:	0f b6 d0             	movzbl %al,%edx
c0101581:	a1 68 66 12 c0       	mov    0xc0126668,%eax
c0101586:	09 d0                	or     %edx,%eax
c0101588:	a3 68 66 12 c0       	mov    %eax,0xc0126668
    shift ^= togglecode[data];
c010158d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101591:	0f b6 80 40 31 12 c0 	movzbl -0x3fedcec0(%eax),%eax
c0101598:	0f b6 d0             	movzbl %al,%edx
c010159b:	a1 68 66 12 c0       	mov    0xc0126668,%eax
c01015a0:	31 d0                	xor    %edx,%eax
c01015a2:	a3 68 66 12 c0       	mov    %eax,0xc0126668

    c = charcode[shift & (CTL | SHIFT)][data];
c01015a7:	a1 68 66 12 c0       	mov    0xc0126668,%eax
c01015ac:	83 e0 03             	and    $0x3,%eax
c01015af:	8b 14 85 40 35 12 c0 	mov    -0x3fedcac0(,%eax,4),%edx
c01015b6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015ba:	01 d0                	add    %edx,%eax
c01015bc:	0f b6 00             	movzbl (%eax),%eax
c01015bf:	0f b6 c0             	movzbl %al,%eax
c01015c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c01015c5:	a1 68 66 12 c0       	mov    0xc0126668,%eax
c01015ca:	83 e0 08             	and    $0x8,%eax
c01015cd:	85 c0                	test   %eax,%eax
c01015cf:	74 22                	je     c01015f3 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
c01015d1:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c01015d5:	7e 0c                	jle    c01015e3 <kbd_proc_data+0x13a>
c01015d7:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c01015db:	7f 06                	jg     c01015e3 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
c01015dd:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c01015e1:	eb 10                	jmp    c01015f3 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
c01015e3:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c01015e7:	7e 0a                	jle    c01015f3 <kbd_proc_data+0x14a>
c01015e9:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c01015ed:	7f 04                	jg     c01015f3 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
c01015ef:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c01015f3:	a1 68 66 12 c0       	mov    0xc0126668,%eax
c01015f8:	f7 d0                	not    %eax
c01015fa:	83 e0 06             	and    $0x6,%eax
c01015fd:	85 c0                	test   %eax,%eax
c01015ff:	75 28                	jne    c0101629 <kbd_proc_data+0x180>
c0101601:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101608:	75 1f                	jne    c0101629 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
c010160a:	c7 04 24 cf 91 10 c0 	movl   $0xc01091cf,(%esp)
c0101611:	e8 4f ed ff ff       	call   c0100365 <cprintf>
c0101616:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010161c:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101620:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101624:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101627:	ee                   	out    %al,(%dx)
}
c0101628:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101629:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010162c:	89 ec                	mov    %ebp,%esp
c010162e:	5d                   	pop    %ebp
c010162f:	c3                   	ret    

c0101630 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101630:	55                   	push   %ebp
c0101631:	89 e5                	mov    %esp,%ebp
c0101633:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101636:	c7 04 24 a9 14 10 c0 	movl   $0xc01014a9,(%esp)
c010163d:	e8 9f fd ff ff       	call   c01013e1 <cons_intr>
}
c0101642:	90                   	nop
c0101643:	89 ec                	mov    %ebp,%esp
c0101645:	5d                   	pop    %ebp
c0101646:	c3                   	ret    

c0101647 <kbd_init>:

static void
kbd_init(void) {
c0101647:	55                   	push   %ebp
c0101648:	89 e5                	mov    %esp,%ebp
c010164a:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c010164d:	e8 de ff ff ff       	call   c0101630 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101652:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101659:	e8 ae 09 00 00       	call   c010200c <pic_enable>
}
c010165e:	90                   	nop
c010165f:	89 ec                	mov    %ebp,%esp
c0101661:	5d                   	pop    %ebp
c0101662:	c3                   	ret    

c0101663 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101663:	55                   	push   %ebp
c0101664:	89 e5                	mov    %esp,%ebp
c0101666:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101669:	e8 4a f8 ff ff       	call   c0100eb8 <cga_init>
    serial_init();
c010166e:	e8 2d f9 ff ff       	call   c0100fa0 <serial_init>
    kbd_init();
c0101673:	e8 cf ff ff ff       	call   c0101647 <kbd_init>
    if (!serial_exists) {
c0101678:	a1 48 64 12 c0       	mov    0xc0126448,%eax
c010167d:	85 c0                	test   %eax,%eax
c010167f:	75 0c                	jne    c010168d <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101681:	c7 04 24 db 91 10 c0 	movl   $0xc01091db,(%esp)
c0101688:	e8 d8 ec ff ff       	call   c0100365 <cprintf>
    }
}
c010168d:	90                   	nop
c010168e:	89 ec                	mov    %ebp,%esp
c0101690:	5d                   	pop    %ebp
c0101691:	c3                   	ret    

c0101692 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101692:	55                   	push   %ebp
c0101693:	89 e5                	mov    %esp,%ebp
c0101695:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101698:	e8 8e f7 ff ff       	call   c0100e2b <__intr_save>
c010169d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01016a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01016a3:	89 04 24             	mov    %eax,(%esp)
c01016a6:	e8 60 fa ff ff       	call   c010110b <lpt_putc>
        cga_putc(c);
c01016ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01016ae:	89 04 24             	mov    %eax,(%esp)
c01016b1:	e8 97 fa ff ff       	call   c010114d <cga_putc>
        serial_putc(c);
c01016b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b9:	89 04 24             	mov    %eax,(%esp)
c01016bc:	e8 de fc ff ff       	call   c010139f <serial_putc>
    }
    local_intr_restore(intr_flag);
c01016c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01016c4:	89 04 24             	mov    %eax,(%esp)
c01016c7:	e8 8b f7 ff ff       	call   c0100e57 <__intr_restore>
}
c01016cc:	90                   	nop
c01016cd:	89 ec                	mov    %ebp,%esp
c01016cf:	5d                   	pop    %ebp
c01016d0:	c3                   	ret    

c01016d1 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c01016d1:	55                   	push   %ebp
c01016d2:	89 e5                	mov    %esp,%ebp
c01016d4:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c01016d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c01016de:	e8 48 f7 ff ff       	call   c0100e2b <__intr_save>
c01016e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c01016e6:	e8 9e fd ff ff       	call   c0101489 <serial_intr>
        kbd_intr();
c01016eb:	e8 40 ff ff ff       	call   c0101630 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c01016f0:	8b 15 60 66 12 c0    	mov    0xc0126660,%edx
c01016f6:	a1 64 66 12 c0       	mov    0xc0126664,%eax
c01016fb:	39 c2                	cmp    %eax,%edx
c01016fd:	74 31                	je     c0101730 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c01016ff:	a1 60 66 12 c0       	mov    0xc0126660,%eax
c0101704:	8d 50 01             	lea    0x1(%eax),%edx
c0101707:	89 15 60 66 12 c0    	mov    %edx,0xc0126660
c010170d:	0f b6 80 60 64 12 c0 	movzbl -0x3fed9ba0(%eax),%eax
c0101714:	0f b6 c0             	movzbl %al,%eax
c0101717:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010171a:	a1 60 66 12 c0       	mov    0xc0126660,%eax
c010171f:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101724:	75 0a                	jne    c0101730 <cons_getc+0x5f>
                cons.rpos = 0;
c0101726:	c7 05 60 66 12 c0 00 	movl   $0x0,0xc0126660
c010172d:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101730:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101733:	89 04 24             	mov    %eax,(%esp)
c0101736:	e8 1c f7 ff ff       	call   c0100e57 <__intr_restore>
    return c;
c010173b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010173e:	89 ec                	mov    %ebp,%esp
c0101740:	5d                   	pop    %ebp
c0101741:	c3                   	ret    

c0101742 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c0101742:	55                   	push   %ebp
c0101743:	89 e5                	mov    %esp,%ebp
c0101745:	83 ec 14             	sub    $0x14,%esp
c0101748:	8b 45 08             	mov    0x8(%ebp),%eax
c010174b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c010174f:	90                   	nop
c0101750:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101753:	83 c0 07             	add    $0x7,%eax
c0101756:	0f b7 c0             	movzwl %ax,%eax
c0101759:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010175d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101761:	89 c2                	mov    %eax,%edx
c0101763:	ec                   	in     (%dx),%al
c0101764:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101767:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010176b:	0f b6 c0             	movzbl %al,%eax
c010176e:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0101771:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101774:	25 80 00 00 00       	and    $0x80,%eax
c0101779:	85 c0                	test   %eax,%eax
c010177b:	75 d3                	jne    c0101750 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c010177d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0101781:	74 11                	je     c0101794 <ide_wait_ready+0x52>
c0101783:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101786:	83 e0 21             	and    $0x21,%eax
c0101789:	85 c0                	test   %eax,%eax
c010178b:	74 07                	je     c0101794 <ide_wait_ready+0x52>
        return -1;
c010178d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101792:	eb 05                	jmp    c0101799 <ide_wait_ready+0x57>
    }
    return 0;
c0101794:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101799:	89 ec                	mov    %ebp,%esp
c010179b:	5d                   	pop    %ebp
c010179c:	c3                   	ret    

c010179d <ide_init>:

void
ide_init(void) {
c010179d:	55                   	push   %ebp
c010179e:	89 e5                	mov    %esp,%ebp
c01017a0:	57                   	push   %edi
c01017a1:	53                   	push   %ebx
c01017a2:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01017a8:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c01017ae:	e9 bd 02 00 00       	jmp    c0101a70 <ide_init+0x2d3>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c01017b3:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01017b7:	89 d0                	mov    %edx,%eax
c01017b9:	c1 e0 03             	shl    $0x3,%eax
c01017bc:	29 d0                	sub    %edx,%eax
c01017be:	c1 e0 03             	shl    $0x3,%eax
c01017c1:	05 80 66 12 c0       	add    $0xc0126680,%eax
c01017c6:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c01017c9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01017cd:	d1 e8                	shr    %eax
c01017cf:	0f b7 c0             	movzwl %ax,%eax
c01017d2:	8b 04 85 fc 91 10 c0 	mov    -0x3fef6e04(,%eax,4),%eax
c01017d9:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c01017dd:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017e8:	00 
c01017e9:	89 04 24             	mov    %eax,(%esp)
c01017ec:	e8 51 ff ff ff       	call   c0101742 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c01017f1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01017f5:	c1 e0 04             	shl    $0x4,%eax
c01017f8:	24 10                	and    $0x10,%al
c01017fa:	0c e0                	or     $0xe0,%al
c01017fc:	0f b6 c0             	movzbl %al,%eax
c01017ff:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101803:	83 c2 06             	add    $0x6,%edx
c0101806:	0f b7 d2             	movzwl %dx,%edx
c0101809:	66 89 55 ca          	mov    %dx,-0x36(%ebp)
c010180d:	88 45 c9             	mov    %al,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101810:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101814:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101818:	ee                   	out    %al,(%dx)
}
c0101819:	90                   	nop
        ide_wait_ready(iobase, 0);
c010181a:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010181e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101825:	00 
c0101826:	89 04 24             	mov    %eax,(%esp)
c0101829:	e8 14 ff ff ff       	call   c0101742 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c010182e:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101832:	83 c0 07             	add    $0x7,%eax
c0101835:	0f b7 c0             	movzwl %ax,%eax
c0101838:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c010183c:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101840:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101844:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101848:	ee                   	out    %al,(%dx)
}
c0101849:	90                   	nop
        ide_wait_ready(iobase, 0);
c010184a:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010184e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101855:	00 
c0101856:	89 04 24             	mov    %eax,(%esp)
c0101859:	e8 e4 fe ff ff       	call   c0101742 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c010185e:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101862:	83 c0 07             	add    $0x7,%eax
c0101865:	0f b7 c0             	movzwl %ax,%eax
c0101868:	66 89 45 d2          	mov    %ax,-0x2e(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010186c:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101870:	89 c2                	mov    %eax,%edx
c0101872:	ec                   	in     (%dx),%al
c0101873:	88 45 d1             	mov    %al,-0x2f(%ebp)
    return data;
c0101876:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010187a:	84 c0                	test   %al,%al
c010187c:	0f 84 e4 01 00 00    	je     c0101a66 <ide_init+0x2c9>
c0101882:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101886:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010188d:	00 
c010188e:	89 04 24             	mov    %eax,(%esp)
c0101891:	e8 ac fe ff ff       	call   c0101742 <ide_wait_ready>
c0101896:	85 c0                	test   %eax,%eax
c0101898:	0f 85 c8 01 00 00    	jne    c0101a66 <ide_init+0x2c9>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c010189e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01018a2:	89 d0                	mov    %edx,%eax
c01018a4:	c1 e0 03             	shl    $0x3,%eax
c01018a7:	29 d0                	sub    %edx,%eax
c01018a9:	c1 e0 03             	shl    $0x3,%eax
c01018ac:	05 80 66 12 c0       	add    $0xc0126680,%eax
c01018b1:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c01018b4:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018b8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c01018bb:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c01018c1:	89 45 c0             	mov    %eax,-0x40(%ebp)
c01018c4:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
    asm volatile (
c01018cb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01018ce:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c01018d1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01018d4:	89 cb                	mov    %ecx,%ebx
c01018d6:	89 df                	mov    %ebx,%edi
c01018d8:	89 c1                	mov    %eax,%ecx
c01018da:	fc                   	cld    
c01018db:	f2 6d                	repnz insl (%dx),%es:(%edi)
c01018dd:	89 c8                	mov    %ecx,%eax
c01018df:	89 fb                	mov    %edi,%ebx
c01018e1:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c01018e4:	89 45 bc             	mov    %eax,-0x44(%ebp)
}
c01018e7:	90                   	nop

        unsigned char *ident = (unsigned char *)buffer;
c01018e8:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c01018ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c01018f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018f4:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c01018fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c01018fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101900:	25 00 00 00 04       	and    $0x4000000,%eax
c0101905:	85 c0                	test   %eax,%eax
c0101907:	74 0e                	je     c0101917 <ide_init+0x17a>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0101909:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010190c:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0101912:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101915:	eb 09                	jmp    c0101920 <ide_init+0x183>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0101917:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010191a:	8b 40 78             	mov    0x78(%eax),%eax
c010191d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0101920:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101924:	89 d0                	mov    %edx,%eax
c0101926:	c1 e0 03             	shl    $0x3,%eax
c0101929:	29 d0                	sub    %edx,%eax
c010192b:	c1 e0 03             	shl    $0x3,%eax
c010192e:	8d 90 84 66 12 c0    	lea    -0x3fed997c(%eax),%edx
c0101934:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101937:	89 02                	mov    %eax,(%edx)
        ide_devices[ideno].size = sectors;
c0101939:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010193d:	89 d0                	mov    %edx,%eax
c010193f:	c1 e0 03             	shl    $0x3,%eax
c0101942:	29 d0                	sub    %edx,%eax
c0101944:	c1 e0 03             	shl    $0x3,%eax
c0101947:	8d 90 88 66 12 c0    	lea    -0x3fed9978(%eax),%edx
c010194d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101950:	89 02                	mov    %eax,(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c0101952:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101955:	83 c0 62             	add    $0x62,%eax
c0101958:	0f b7 00             	movzwl (%eax),%eax
c010195b:	25 00 02 00 00       	and    $0x200,%eax
c0101960:	85 c0                	test   %eax,%eax
c0101962:	75 24                	jne    c0101988 <ide_init+0x1eb>
c0101964:	c7 44 24 0c 04 92 10 	movl   $0xc0109204,0xc(%esp)
c010196b:	c0 
c010196c:	c7 44 24 08 47 92 10 	movl   $0xc0109247,0x8(%esp)
c0101973:	c0 
c0101974:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c010197b:	00 
c010197c:	c7 04 24 5c 92 10 c0 	movl   $0xc010925c,(%esp)
c0101983:	e8 69 f3 ff ff       	call   c0100cf1 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101988:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010198c:	89 d0                	mov    %edx,%eax
c010198e:	c1 e0 03             	shl    $0x3,%eax
c0101991:	29 d0                	sub    %edx,%eax
c0101993:	c1 e0 03             	shl    $0x3,%eax
c0101996:	05 80 66 12 c0       	add    $0xc0126680,%eax
c010199b:	83 c0 0c             	add    $0xc,%eax
c010199e:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01019a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01019a4:	83 c0 36             	add    $0x36,%eax
c01019a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c01019aa:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c01019b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01019b8:	eb 34                	jmp    c01019ee <ide_init+0x251>
            model[i] = data[i + 1], model[i + 1] = data[i];
c01019ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019bd:	8d 50 01             	lea    0x1(%eax),%edx
c01019c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01019c3:	01 c2                	add    %eax,%edx
c01019c5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01019c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019cb:	01 c8                	add    %ecx,%eax
c01019cd:	0f b6 12             	movzbl (%edx),%edx
c01019d0:	88 10                	mov    %dl,(%eax)
c01019d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01019d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019d8:	01 c2                	add    %eax,%edx
c01019da:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019dd:	8d 48 01             	lea    0x1(%eax),%ecx
c01019e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01019e3:	01 c8                	add    %ecx,%eax
c01019e5:	0f b6 12             	movzbl (%edx),%edx
c01019e8:	88 10                	mov    %dl,(%eax)
        for (i = 0; i < length; i += 2) {
c01019ea:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c01019ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019f1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c01019f4:	72 c4                	jb     c01019ba <ide_init+0x21d>
        }
        do {
            model[i] = '\0';
c01019f6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01019f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019fc:	01 d0                	add    %edx,%eax
c01019fe:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c0101a01:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a04:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101a07:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101a0a:	85 c0                	test   %eax,%eax
c0101a0c:	74 0f                	je     c0101a1d <ide_init+0x280>
c0101a0e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a11:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a14:	01 d0                	add    %edx,%eax
c0101a16:	0f b6 00             	movzbl (%eax),%eax
c0101a19:	3c 20                	cmp    $0x20,%al
c0101a1b:	74 d9                	je     c01019f6 <ide_init+0x259>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c0101a1d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101a21:	89 d0                	mov    %edx,%eax
c0101a23:	c1 e0 03             	shl    $0x3,%eax
c0101a26:	29 d0                	sub    %edx,%eax
c0101a28:	c1 e0 03             	shl    $0x3,%eax
c0101a2b:	05 80 66 12 c0       	add    $0xc0126680,%eax
c0101a30:	8d 48 0c             	lea    0xc(%eax),%ecx
c0101a33:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101a37:	89 d0                	mov    %edx,%eax
c0101a39:	c1 e0 03             	shl    $0x3,%eax
c0101a3c:	29 d0                	sub    %edx,%eax
c0101a3e:	c1 e0 03             	shl    $0x3,%eax
c0101a41:	05 88 66 12 c0       	add    $0xc0126688,%eax
c0101a46:	8b 10                	mov    (%eax),%edx
c0101a48:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101a4c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0101a50:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101a54:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a58:	c7 04 24 6e 92 10 c0 	movl   $0xc010926e,(%esp)
c0101a5f:	e8 01 e9 ff ff       	call   c0100365 <cprintf>
c0101a64:	eb 01                	jmp    c0101a67 <ide_init+0x2ca>
            continue ;
c0101a66:	90                   	nop
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101a67:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101a6b:	40                   	inc    %eax
c0101a6c:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c0101a70:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101a74:	83 f8 03             	cmp    $0x3,%eax
c0101a77:	0f 86 36 fd ff ff    	jbe    c01017b3 <ide_init+0x16>
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101a7d:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101a84:	e8 83 05 00 00       	call   c010200c <pic_enable>
    pic_enable(IRQ_IDE2);
c0101a89:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101a90:	e8 77 05 00 00       	call   c010200c <pic_enable>
}
c0101a95:	90                   	nop
c0101a96:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101a9c:	5b                   	pop    %ebx
c0101a9d:	5f                   	pop    %edi
c0101a9e:	5d                   	pop    %ebp
c0101a9f:	c3                   	ret    

c0101aa0 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101aa0:	55                   	push   %ebp
c0101aa1:	89 e5                	mov    %esp,%ebp
c0101aa3:	83 ec 04             	sub    $0x4,%esp
c0101aa6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101aad:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101ab1:	83 f8 03             	cmp    $0x3,%eax
c0101ab4:	77 21                	ja     c0101ad7 <ide_device_valid+0x37>
c0101ab6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c0101aba:	89 d0                	mov    %edx,%eax
c0101abc:	c1 e0 03             	shl    $0x3,%eax
c0101abf:	29 d0                	sub    %edx,%eax
c0101ac1:	c1 e0 03             	shl    $0x3,%eax
c0101ac4:	05 80 66 12 c0       	add    $0xc0126680,%eax
c0101ac9:	0f b6 00             	movzbl (%eax),%eax
c0101acc:	84 c0                	test   %al,%al
c0101ace:	74 07                	je     c0101ad7 <ide_device_valid+0x37>
c0101ad0:	b8 01 00 00 00       	mov    $0x1,%eax
c0101ad5:	eb 05                	jmp    c0101adc <ide_device_valid+0x3c>
c0101ad7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101adc:	89 ec                	mov    %ebp,%esp
c0101ade:	5d                   	pop    %ebp
c0101adf:	c3                   	ret    

c0101ae0 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101ae0:	55                   	push   %ebp
c0101ae1:	89 e5                	mov    %esp,%ebp
c0101ae3:	83 ec 08             	sub    $0x8,%esp
c0101ae6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101aed:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101af1:	89 04 24             	mov    %eax,(%esp)
c0101af4:	e8 a7 ff ff ff       	call   c0101aa0 <ide_device_valid>
c0101af9:	85 c0                	test   %eax,%eax
c0101afb:	74 17                	je     c0101b14 <ide_device_size+0x34>
        return ide_devices[ideno].size;
c0101afd:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c0101b01:	89 d0                	mov    %edx,%eax
c0101b03:	c1 e0 03             	shl    $0x3,%eax
c0101b06:	29 d0                	sub    %edx,%eax
c0101b08:	c1 e0 03             	shl    $0x3,%eax
c0101b0b:	05 88 66 12 c0       	add    $0xc0126688,%eax
c0101b10:	8b 00                	mov    (%eax),%eax
c0101b12:	eb 05                	jmp    c0101b19 <ide_device_size+0x39>
    }
    return 0;
c0101b14:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101b19:	89 ec                	mov    %ebp,%esp
c0101b1b:	5d                   	pop    %ebp
c0101b1c:	c3                   	ret    

c0101b1d <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101b1d:	55                   	push   %ebp
c0101b1e:	89 e5                	mov    %esp,%ebp
c0101b20:	57                   	push   %edi
c0101b21:	53                   	push   %ebx
c0101b22:	83 ec 50             	sub    $0x50,%esp
c0101b25:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b28:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101b2c:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101b33:	77 23                	ja     c0101b58 <ide_read_secs+0x3b>
c0101b35:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b39:	83 f8 03             	cmp    $0x3,%eax
c0101b3c:	77 1a                	ja     c0101b58 <ide_read_secs+0x3b>
c0101b3e:	0f b7 55 c4          	movzwl -0x3c(%ebp),%edx
c0101b42:	89 d0                	mov    %edx,%eax
c0101b44:	c1 e0 03             	shl    $0x3,%eax
c0101b47:	29 d0                	sub    %edx,%eax
c0101b49:	c1 e0 03             	shl    $0x3,%eax
c0101b4c:	05 80 66 12 c0       	add    $0xc0126680,%eax
c0101b51:	0f b6 00             	movzbl (%eax),%eax
c0101b54:	84 c0                	test   %al,%al
c0101b56:	75 24                	jne    c0101b7c <ide_read_secs+0x5f>
c0101b58:	c7 44 24 0c 8c 92 10 	movl   $0xc010928c,0xc(%esp)
c0101b5f:	c0 
c0101b60:	c7 44 24 08 47 92 10 	movl   $0xc0109247,0x8(%esp)
c0101b67:	c0 
c0101b68:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101b6f:	00 
c0101b70:	c7 04 24 5c 92 10 c0 	movl   $0xc010925c,(%esp)
c0101b77:	e8 75 f1 ff ff       	call   c0100cf1 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101b7c:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101b83:	77 0f                	ja     c0101b94 <ide_read_secs+0x77>
c0101b85:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101b88:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b8b:	01 d0                	add    %edx,%eax
c0101b8d:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101b92:	76 24                	jbe    c0101bb8 <ide_read_secs+0x9b>
c0101b94:	c7 44 24 0c b4 92 10 	movl   $0xc01092b4,0xc(%esp)
c0101b9b:	c0 
c0101b9c:	c7 44 24 08 47 92 10 	movl   $0xc0109247,0x8(%esp)
c0101ba3:	c0 
c0101ba4:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101bab:	00 
c0101bac:	c7 04 24 5c 92 10 c0 	movl   $0xc010925c,(%esp)
c0101bb3:	e8 39 f1 ff ff       	call   c0100cf1 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101bb8:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101bbc:	d1 e8                	shr    %eax
c0101bbe:	0f b7 c0             	movzwl %ax,%eax
c0101bc1:	8b 04 85 fc 91 10 c0 	mov    -0x3fef6e04(,%eax,4),%eax
c0101bc8:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101bcc:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101bd0:	d1 e8                	shr    %eax
c0101bd2:	0f b7 c0             	movzwl %ax,%eax
c0101bd5:	0f b7 04 85 fe 91 10 	movzwl -0x3fef6e02(,%eax,4),%eax
c0101bdc:	c0 
c0101bdd:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101be1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101be5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101bec:	00 
c0101bed:	89 04 24             	mov    %eax,(%esp)
c0101bf0:	e8 4d fb ff ff       	call   c0101742 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101bf8:	83 c0 02             	add    $0x2,%eax
c0101bfb:	0f b7 c0             	movzwl %ax,%eax
c0101bfe:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101c02:	c6 45 d5 00          	movb   $0x0,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101c06:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c0a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c0e:	ee                   	out    %al,(%dx)
}
c0101c0f:	90                   	nop
    outb(iobase + ISA_SECCNT, nsecs);
c0101c10:	8b 45 14             	mov    0x14(%ebp),%eax
c0101c13:	0f b6 c0             	movzbl %al,%eax
c0101c16:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c1a:	83 c2 02             	add    $0x2,%edx
c0101c1d:	0f b7 d2             	movzwl %dx,%edx
c0101c20:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c24:	88 45 d9             	mov    %al,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101c27:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c2b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c2f:	ee                   	out    %al,(%dx)
}
c0101c30:	90                   	nop
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101c31:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c34:	0f b6 c0             	movzbl %al,%eax
c0101c37:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c3b:	83 c2 03             	add    $0x3,%edx
c0101c3e:	0f b7 d2             	movzwl %dx,%edx
c0101c41:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101c45:	88 45 dd             	mov    %al,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101c48:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c4c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c50:	ee                   	out    %al,(%dx)
}
c0101c51:	90                   	nop
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101c52:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c55:	c1 e8 08             	shr    $0x8,%eax
c0101c58:	0f b6 c0             	movzbl %al,%eax
c0101c5b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c5f:	83 c2 04             	add    $0x4,%edx
c0101c62:	0f b7 d2             	movzwl %dx,%edx
c0101c65:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101c69:	88 45 e1             	mov    %al,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101c6c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101c70:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101c74:	ee                   	out    %al,(%dx)
}
c0101c75:	90                   	nop
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101c76:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c79:	c1 e8 10             	shr    $0x10,%eax
c0101c7c:	0f b6 c0             	movzbl %al,%eax
c0101c7f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c83:	83 c2 05             	add    $0x5,%edx
c0101c86:	0f b7 d2             	movzwl %dx,%edx
c0101c89:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101c8d:	88 45 e5             	mov    %al,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101c90:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101c94:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101c98:	ee                   	out    %al,(%dx)
}
c0101c99:	90                   	nop
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101c9a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0101c9d:	c0 e0 04             	shl    $0x4,%al
c0101ca0:	24 10                	and    $0x10,%al
c0101ca2:	88 c2                	mov    %al,%dl
c0101ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101ca7:	c1 e8 18             	shr    $0x18,%eax
c0101caa:	24 0f                	and    $0xf,%al
c0101cac:	08 d0                	or     %dl,%al
c0101cae:	0c e0                	or     $0xe0,%al
c0101cb0:	0f b6 c0             	movzbl %al,%eax
c0101cb3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101cb7:	83 c2 06             	add    $0x6,%edx
c0101cba:	0f b7 d2             	movzwl %dx,%edx
c0101cbd:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101cc1:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101cc4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101cc8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101ccc:	ee                   	out    %al,(%dx)
}
c0101ccd:	90                   	nop
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101cce:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101cd2:	83 c0 07             	add    $0x7,%eax
c0101cd5:	0f b7 c0             	movzwl %ax,%eax
c0101cd8:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101cdc:	c6 45 ed 20          	movb   $0x20,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101ce0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101ce4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101ce8:	ee                   	out    %al,(%dx)
}
c0101ce9:	90                   	nop

    int ret = 0;
c0101cea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101cf1:	eb 58                	jmp    c0101d4b <ide_read_secs+0x22e>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101cf3:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101cf7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101cfe:	00 
c0101cff:	89 04 24             	mov    %eax,(%esp)
c0101d02:	e8 3b fa ff ff       	call   c0101742 <ide_wait_ready>
c0101d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101d0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101d0e:	75 43                	jne    c0101d53 <ide_read_secs+0x236>
            goto out;
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101d10:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101d14:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101d17:	8b 45 10             	mov    0x10(%ebp),%eax
c0101d1a:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101d1d:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile (
c0101d24:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101d27:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101d2a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101d2d:	89 cb                	mov    %ecx,%ebx
c0101d2f:	89 df                	mov    %ebx,%edi
c0101d31:	89 c1                	mov    %eax,%ecx
c0101d33:	fc                   	cld    
c0101d34:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101d36:	89 c8                	mov    %ecx,%eax
c0101d38:	89 fb                	mov    %edi,%ebx
c0101d3a:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101d3d:	89 45 c8             	mov    %eax,-0x38(%ebp)
}
c0101d40:	90                   	nop
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101d41:	ff 4d 14             	decl   0x14(%ebp)
c0101d44:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101d4b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101d4f:	75 a2                	jne    c0101cf3 <ide_read_secs+0x1d6>
    }

out:
c0101d51:	eb 01                	jmp    c0101d54 <ide_read_secs+0x237>
            goto out;
c0101d53:	90                   	nop
    return ret;
c0101d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101d57:	83 c4 50             	add    $0x50,%esp
c0101d5a:	5b                   	pop    %ebx
c0101d5b:	5f                   	pop    %edi
c0101d5c:	5d                   	pop    %ebp
c0101d5d:	c3                   	ret    

c0101d5e <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101d5e:	55                   	push   %ebp
c0101d5f:	89 e5                	mov    %esp,%ebp
c0101d61:	56                   	push   %esi
c0101d62:	53                   	push   %ebx
c0101d63:	83 ec 50             	sub    $0x50,%esp
c0101d66:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d69:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101d6d:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101d74:	77 23                	ja     c0101d99 <ide_write_secs+0x3b>
c0101d76:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d7a:	83 f8 03             	cmp    $0x3,%eax
c0101d7d:	77 1a                	ja     c0101d99 <ide_write_secs+0x3b>
c0101d7f:	0f b7 55 c4          	movzwl -0x3c(%ebp),%edx
c0101d83:	89 d0                	mov    %edx,%eax
c0101d85:	c1 e0 03             	shl    $0x3,%eax
c0101d88:	29 d0                	sub    %edx,%eax
c0101d8a:	c1 e0 03             	shl    $0x3,%eax
c0101d8d:	05 80 66 12 c0       	add    $0xc0126680,%eax
c0101d92:	0f b6 00             	movzbl (%eax),%eax
c0101d95:	84 c0                	test   %al,%al
c0101d97:	75 24                	jne    c0101dbd <ide_write_secs+0x5f>
c0101d99:	c7 44 24 0c 8c 92 10 	movl   $0xc010928c,0xc(%esp)
c0101da0:	c0 
c0101da1:	c7 44 24 08 47 92 10 	movl   $0xc0109247,0x8(%esp)
c0101da8:	c0 
c0101da9:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101db0:	00 
c0101db1:	c7 04 24 5c 92 10 c0 	movl   $0xc010925c,(%esp)
c0101db8:	e8 34 ef ff ff       	call   c0100cf1 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101dbd:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101dc4:	77 0f                	ja     c0101dd5 <ide_write_secs+0x77>
c0101dc6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101dc9:	8b 45 14             	mov    0x14(%ebp),%eax
c0101dcc:	01 d0                	add    %edx,%eax
c0101dce:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101dd3:	76 24                	jbe    c0101df9 <ide_write_secs+0x9b>
c0101dd5:	c7 44 24 0c b4 92 10 	movl   $0xc01092b4,0xc(%esp)
c0101ddc:	c0 
c0101ddd:	c7 44 24 08 47 92 10 	movl   $0xc0109247,0x8(%esp)
c0101de4:	c0 
c0101de5:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101dec:	00 
c0101ded:	c7 04 24 5c 92 10 c0 	movl   $0xc010925c,(%esp)
c0101df4:	e8 f8 ee ff ff       	call   c0100cf1 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101df9:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101dfd:	d1 e8                	shr    %eax
c0101dff:	0f b7 c0             	movzwl %ax,%eax
c0101e02:	8b 04 85 fc 91 10 c0 	mov    -0x3fef6e04(,%eax,4),%eax
c0101e09:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101e0d:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e11:	d1 e8                	shr    %eax
c0101e13:	0f b7 c0             	movzwl %ax,%eax
c0101e16:	0f b7 04 85 fe 91 10 	movzwl -0x3fef6e02(,%eax,4),%eax
c0101e1d:	c0 
c0101e1e:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101e22:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101e26:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101e2d:	00 
c0101e2e:	89 04 24             	mov    %eax,(%esp)
c0101e31:	e8 0c f9 ff ff       	call   c0101742 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101e39:	83 c0 02             	add    $0x2,%eax
c0101e3c:	0f b7 c0             	movzwl %ax,%eax
c0101e3f:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101e43:	c6 45 d5 00          	movb   $0x0,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101e47:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101e4b:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101e4f:	ee                   	out    %al,(%dx)
}
c0101e50:	90                   	nop
    outb(iobase + ISA_SECCNT, nsecs);
c0101e51:	8b 45 14             	mov    0x14(%ebp),%eax
c0101e54:	0f b6 c0             	movzbl %al,%eax
c0101e57:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e5b:	83 c2 02             	add    $0x2,%edx
c0101e5e:	0f b7 d2             	movzwl %dx,%edx
c0101e61:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101e65:	88 45 d9             	mov    %al,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101e68:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101e6c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101e70:	ee                   	out    %al,(%dx)
}
c0101e71:	90                   	nop
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101e72:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e75:	0f b6 c0             	movzbl %al,%eax
c0101e78:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e7c:	83 c2 03             	add    $0x3,%edx
c0101e7f:	0f b7 d2             	movzwl %dx,%edx
c0101e82:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101e86:	88 45 dd             	mov    %al,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101e89:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101e8d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101e91:	ee                   	out    %al,(%dx)
}
c0101e92:	90                   	nop
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101e93:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e96:	c1 e8 08             	shr    $0x8,%eax
c0101e99:	0f b6 c0             	movzbl %al,%eax
c0101e9c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ea0:	83 c2 04             	add    $0x4,%edx
c0101ea3:	0f b7 d2             	movzwl %dx,%edx
c0101ea6:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101eaa:	88 45 e1             	mov    %al,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101ead:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101eb1:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101eb5:	ee                   	out    %al,(%dx)
}
c0101eb6:	90                   	nop
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101eba:	c1 e8 10             	shr    $0x10,%eax
c0101ebd:	0f b6 c0             	movzbl %al,%eax
c0101ec0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ec4:	83 c2 05             	add    $0x5,%edx
c0101ec7:	0f b7 d2             	movzwl %dx,%edx
c0101eca:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101ece:	88 45 e5             	mov    %al,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101ed1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101ed5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101ed9:	ee                   	out    %al,(%dx)
}
c0101eda:	90                   	nop
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101edb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0101ede:	c0 e0 04             	shl    $0x4,%al
c0101ee1:	24 10                	and    $0x10,%al
c0101ee3:	88 c2                	mov    %al,%dl
c0101ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101ee8:	c1 e8 18             	shr    $0x18,%eax
c0101eeb:	24 0f                	and    $0xf,%al
c0101eed:	08 d0                	or     %dl,%al
c0101eef:	0c e0                	or     $0xe0,%al
c0101ef1:	0f b6 c0             	movzbl %al,%eax
c0101ef4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ef8:	83 c2 06             	add    $0x6,%edx
c0101efb:	0f b7 d2             	movzwl %dx,%edx
c0101efe:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101f02:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f05:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101f09:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101f0d:	ee                   	out    %al,(%dx)
}
c0101f0e:	90                   	nop
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101f0f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101f13:	83 c0 07             	add    $0x7,%eax
c0101f16:	0f b7 c0             	movzwl %ax,%eax
c0101f19:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101f1d:	c6 45 ed 30          	movb   $0x30,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f21:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101f25:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101f29:	ee                   	out    %al,(%dx)
}
c0101f2a:	90                   	nop

    int ret = 0;
c0101f2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f32:	eb 58                	jmp    c0101f8c <ide_write_secs+0x22e>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101f34:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101f38:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101f3f:	00 
c0101f40:	89 04 24             	mov    %eax,(%esp)
c0101f43:	e8 fa f7 ff ff       	call   c0101742 <ide_wait_ready>
c0101f48:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101f4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101f4f:	75 43                	jne    c0101f94 <ide_write_secs+0x236>
            goto out;
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101f51:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101f55:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101f58:	8b 45 10             	mov    0x10(%ebp),%eax
c0101f5b:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101f5e:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile (
c0101f65:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101f68:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101f6b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101f6e:	89 cb                	mov    %ecx,%ebx
c0101f70:	89 de                	mov    %ebx,%esi
c0101f72:	89 c1                	mov    %eax,%ecx
c0101f74:	fc                   	cld    
c0101f75:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101f77:	89 c8                	mov    %ecx,%eax
c0101f79:	89 f3                	mov    %esi,%ebx
c0101f7b:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101f7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
}
c0101f81:	90                   	nop
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f82:	ff 4d 14             	decl   0x14(%ebp)
c0101f85:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101f8c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101f90:	75 a2                	jne    c0101f34 <ide_write_secs+0x1d6>
    }

out:
c0101f92:	eb 01                	jmp    c0101f95 <ide_write_secs+0x237>
            goto out;
c0101f94:	90                   	nop
    return ret;
c0101f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f98:	83 c4 50             	add    $0x50,%esp
c0101f9b:	5b                   	pop    %ebx
c0101f9c:	5e                   	pop    %esi
c0101f9d:	5d                   	pop    %ebp
c0101f9e:	c3                   	ret    

c0101f9f <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101f9f:	55                   	push   %ebp
c0101fa0:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101fa2:	fb                   	sti    
}
c0101fa3:	90                   	nop
    sti();
}
c0101fa4:	90                   	nop
c0101fa5:	5d                   	pop    %ebp
c0101fa6:	c3                   	ret    

c0101fa7 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101fa7:	55                   	push   %ebp
c0101fa8:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c0101faa:	fa                   	cli    
}
c0101fab:	90                   	nop
    cli();
}
c0101fac:	90                   	nop
c0101fad:	5d                   	pop    %ebp
c0101fae:	c3                   	ret    

c0101faf <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101faf:	55                   	push   %ebp
c0101fb0:	89 e5                	mov    %esp,%ebp
c0101fb2:	83 ec 14             	sub    $0x14,%esp
c0101fb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fb8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101fbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101fbf:	66 a3 50 35 12 c0    	mov    %ax,0xc0123550
    if (did_init) {
c0101fc5:	a1 60 67 12 c0       	mov    0xc0126760,%eax
c0101fca:	85 c0                	test   %eax,%eax
c0101fcc:	74 39                	je     c0102007 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
c0101fce:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101fd1:	0f b6 c0             	movzbl %al,%eax
c0101fd4:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c0101fda:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101fdd:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101fe1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101fe5:	ee                   	out    %al,(%dx)
}
c0101fe6:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c0101fe7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101feb:	c1 e8 08             	shr    $0x8,%eax
c0101fee:	0f b7 c0             	movzwl %ax,%eax
c0101ff1:	0f b6 c0             	movzbl %al,%eax
c0101ff4:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c0101ffa:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101ffd:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0102001:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0102005:	ee                   	out    %al,(%dx)
}
c0102006:	90                   	nop
    }
}
c0102007:	90                   	nop
c0102008:	89 ec                	mov    %ebp,%esp
c010200a:	5d                   	pop    %ebp
c010200b:	c3                   	ret    

c010200c <pic_enable>:

void
pic_enable(unsigned int irq) {
c010200c:	55                   	push   %ebp
c010200d:	89 e5                	mov    %esp,%ebp
c010200f:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0102012:	8b 45 08             	mov    0x8(%ebp),%eax
c0102015:	ba 01 00 00 00       	mov    $0x1,%edx
c010201a:	88 c1                	mov    %al,%cl
c010201c:	d3 e2                	shl    %cl,%edx
c010201e:	89 d0                	mov    %edx,%eax
c0102020:	98                   	cwtl   
c0102021:	f7 d0                	not    %eax
c0102023:	0f bf d0             	movswl %ax,%edx
c0102026:	0f b7 05 50 35 12 c0 	movzwl 0xc0123550,%eax
c010202d:	98                   	cwtl   
c010202e:	21 d0                	and    %edx,%eax
c0102030:	98                   	cwtl   
c0102031:	0f b7 c0             	movzwl %ax,%eax
c0102034:	89 04 24             	mov    %eax,(%esp)
c0102037:	e8 73 ff ff ff       	call   c0101faf <pic_setmask>
}
c010203c:	90                   	nop
c010203d:	89 ec                	mov    %ebp,%esp
c010203f:	5d                   	pop    %ebp
c0102040:	c3                   	ret    

c0102041 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0102041:	55                   	push   %ebp
c0102042:	89 e5                	mov    %esp,%ebp
c0102044:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0102047:	c7 05 60 67 12 c0 01 	movl   $0x1,0xc0126760
c010204e:	00 00 00 
c0102051:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c0102057:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010205b:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010205f:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0102063:	ee                   	out    %al,(%dx)
}
c0102064:	90                   	nop
c0102065:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c010206b:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010206f:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0102073:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0102077:	ee                   	out    %al,(%dx)
}
c0102078:	90                   	nop
c0102079:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010207f:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0102083:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0102087:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010208b:	ee                   	out    %al,(%dx)
}
c010208c:	90                   	nop
c010208d:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0102093:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0102097:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010209b:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010209f:	ee                   	out    %al,(%dx)
}
c01020a0:	90                   	nop
c01020a1:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c01020a7:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01020ab:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01020af:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01020b3:	ee                   	out    %al,(%dx)
}
c01020b4:	90                   	nop
c01020b5:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c01020bb:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01020bf:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01020c3:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01020c7:	ee                   	out    %al,(%dx)
}
c01020c8:	90                   	nop
c01020c9:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01020cf:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01020d3:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01020d7:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01020db:	ee                   	out    %al,(%dx)
}
c01020dc:	90                   	nop
c01020dd:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01020e3:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01020e7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01020eb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01020ef:	ee                   	out    %al,(%dx)
}
c01020f0:	90                   	nop
c01020f1:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c01020f7:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01020fb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01020ff:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0102103:	ee                   	out    %al,(%dx)
}
c0102104:	90                   	nop
c0102105:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c010210b:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010210f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0102113:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102117:	ee                   	out    %al,(%dx)
}
c0102118:	90                   	nop
c0102119:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c010211f:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0102123:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102127:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010212b:	ee                   	out    %al,(%dx)
}
c010212c:	90                   	nop
c010212d:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0102133:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0102137:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010213b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010213f:	ee                   	out    %al,(%dx)
}
c0102140:	90                   	nop
c0102141:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c0102147:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010214b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010214f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0102153:	ee                   	out    %al,(%dx)
}
c0102154:	90                   	nop
c0102155:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c010215b:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010215f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0102163:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0102167:	ee                   	out    %al,(%dx)
}
c0102168:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0102169:	0f b7 05 50 35 12 c0 	movzwl 0xc0123550,%eax
c0102170:	3d ff ff 00 00       	cmp    $0xffff,%eax
c0102175:	74 0f                	je     c0102186 <pic_init+0x145>
        pic_setmask(irq_mask);
c0102177:	0f b7 05 50 35 12 c0 	movzwl 0xc0123550,%eax
c010217e:	89 04 24             	mov    %eax,(%esp)
c0102181:	e8 29 fe ff ff       	call   c0101faf <pic_setmask>
    }
}
c0102186:	90                   	nop
c0102187:	89 ec                	mov    %ebp,%esp
c0102189:	5d                   	pop    %ebp
c010218a:	c3                   	ret    

c010218b <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010218b:	55                   	push   %ebp
c010218c:	89 e5                	mov    %esp,%ebp
c010218e:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0102191:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102198:	00 
c0102199:	c7 04 24 00 93 10 c0 	movl   $0xc0109300,(%esp)
c01021a0:	e8 c0 e1 ff ff       	call   c0100365 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01021a5:	c7 04 24 0a 93 10 c0 	movl   $0xc010930a,(%esp)
c01021ac:	e8 b4 e1 ff ff       	call   c0100365 <cprintf>
    panic("EOT: kernel seems ok.");
c01021b1:	c7 44 24 08 18 93 10 	movl   $0xc0109318,0x8(%esp)
c01021b8:	c0 
c01021b9:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c01021c0:	00 
c01021c1:	c7 04 24 2e 93 10 c0 	movl   $0xc010932e,(%esp)
c01021c8:	e8 24 eb ff ff       	call   c0100cf1 <__panic>

c01021cd <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01021cd:	55                   	push   %ebp
c01021ce:	89 e5                	mov    %esp,%ebp
c01021d0:	83 ec 10             	sub    $0x10,%esp
    //然后使用lidt加载IDT即可，指令格式与LGDT类似；至此完成了中断描述符表的初始化过程；

    // entry adders of ISR(Interrupt Service Routine)
    extern uintptr_t __vectors[];
    // setup the entries of ISR in IDT(Interrupt Description Table)
    int n=sizeof(idt)/sizeof(struct gatedesc);
c01021d3:	c7 45 f8 00 01 00 00 	movl   $0x100,-0x8(%ebp)
    for(int i=0;i<n;i++){
c01021da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01021e1:	e9 c4 00 00 00       	jmp    c01022aa <idt_init+0xdd>
        trap: 1 for a trap (= exception) gate, 0 for an interrupt gate
        sel: 段选择器
        off: 偏移
        dpl: 特权级
        * */
        SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
c01021e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e9:	8b 04 85 e0 35 12 c0 	mov    -0x3fedca20(,%eax,4),%eax
c01021f0:	0f b7 d0             	movzwl %ax,%edx
c01021f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021f6:	66 89 14 c5 80 67 12 	mov    %dx,-0x3fed9880(,%eax,8)
c01021fd:	c0 
c01021fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102201:	66 c7 04 c5 82 67 12 	movw   $0x8,-0x3fed987e(,%eax,8)
c0102208:	c0 08 00 
c010220b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010220e:	0f b6 14 c5 84 67 12 	movzbl -0x3fed987c(,%eax,8),%edx
c0102215:	c0 
c0102216:	80 e2 e0             	and    $0xe0,%dl
c0102219:	88 14 c5 84 67 12 c0 	mov    %dl,-0x3fed987c(,%eax,8)
c0102220:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102223:	0f b6 14 c5 84 67 12 	movzbl -0x3fed987c(,%eax,8),%edx
c010222a:	c0 
c010222b:	80 e2 1f             	and    $0x1f,%dl
c010222e:	88 14 c5 84 67 12 c0 	mov    %dl,-0x3fed987c(,%eax,8)
c0102235:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102238:	0f b6 14 c5 85 67 12 	movzbl -0x3fed987b(,%eax,8),%edx
c010223f:	c0 
c0102240:	80 e2 f0             	and    $0xf0,%dl
c0102243:	80 ca 0e             	or     $0xe,%dl
c0102246:	88 14 c5 85 67 12 c0 	mov    %dl,-0x3fed987b(,%eax,8)
c010224d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102250:	0f b6 14 c5 85 67 12 	movzbl -0x3fed987b(,%eax,8),%edx
c0102257:	c0 
c0102258:	80 e2 ef             	and    $0xef,%dl
c010225b:	88 14 c5 85 67 12 c0 	mov    %dl,-0x3fed987b(,%eax,8)
c0102262:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102265:	0f b6 14 c5 85 67 12 	movzbl -0x3fed987b(,%eax,8),%edx
c010226c:	c0 
c010226d:	80 e2 9f             	and    $0x9f,%dl
c0102270:	88 14 c5 85 67 12 c0 	mov    %dl,-0x3fed987b(,%eax,8)
c0102277:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010227a:	0f b6 14 c5 85 67 12 	movzbl -0x3fed987b(,%eax,8),%edx
c0102281:	c0 
c0102282:	80 ca 80             	or     $0x80,%dl
c0102285:	88 14 c5 85 67 12 c0 	mov    %dl,-0x3fed987b(,%eax,8)
c010228c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010228f:	8b 04 85 e0 35 12 c0 	mov    -0x3fedca20(,%eax,4),%eax
c0102296:	c1 e8 10             	shr    $0x10,%eax
c0102299:	0f b7 d0             	movzwl %ax,%edx
c010229c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010229f:	66 89 14 c5 86 67 12 	mov    %dx,-0x3fed987a(,%eax,8)
c01022a6:	c0 
    for(int i=0;i<n;i++){
c01022a7:	ff 45 fc             	incl   -0x4(%ebp)
c01022aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022ad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01022b0:	0f 8c 30 ff ff ff    	jl     c01021e6 <idt_init+0x19>
    }
    //系统调用中断
    //而ucore的应用程序处于特权级３，需要采用｀int 0x80`指令操作（软中断）来发出系统调用请求，并要能实现从特权级３到特权级０的转换
    //所以系统调用中断(T_SYSCALL)所对应的中断门描述符中的特权级（DPL）需要设置为３。
    SETGATE(idt[T_SYSCALL],1,GD_KTEXT,__vectors[T_SYSCALL],DPL_USER);
c01022b6:	a1 e0 37 12 c0       	mov    0xc01237e0,%eax
c01022bb:	0f b7 c0             	movzwl %ax,%eax
c01022be:	66 a3 80 6b 12 c0    	mov    %ax,0xc0126b80
c01022c4:	66 c7 05 82 6b 12 c0 	movw   $0x8,0xc0126b82
c01022cb:	08 00 
c01022cd:	0f b6 05 84 6b 12 c0 	movzbl 0xc0126b84,%eax
c01022d4:	24 e0                	and    $0xe0,%al
c01022d6:	a2 84 6b 12 c0       	mov    %al,0xc0126b84
c01022db:	0f b6 05 84 6b 12 c0 	movzbl 0xc0126b84,%eax
c01022e2:	24 1f                	and    $0x1f,%al
c01022e4:	a2 84 6b 12 c0       	mov    %al,0xc0126b84
c01022e9:	0f b6 05 85 6b 12 c0 	movzbl 0xc0126b85,%eax
c01022f0:	0c 0f                	or     $0xf,%al
c01022f2:	a2 85 6b 12 c0       	mov    %al,0xc0126b85
c01022f7:	0f b6 05 85 6b 12 c0 	movzbl 0xc0126b85,%eax
c01022fe:	24 ef                	and    $0xef,%al
c0102300:	a2 85 6b 12 c0       	mov    %al,0xc0126b85
c0102305:	0f b6 05 85 6b 12 c0 	movzbl 0xc0126b85,%eax
c010230c:	0c 60                	or     $0x60,%al
c010230e:	a2 85 6b 12 c0       	mov    %al,0xc0126b85
c0102313:	0f b6 05 85 6b 12 c0 	movzbl 0xc0126b85,%eax
c010231a:	0c 80                	or     $0x80,%al
c010231c:	a2 85 6b 12 c0       	mov    %al,0xc0126b85
c0102321:	a1 e0 37 12 c0       	mov    0xc01237e0,%eax
c0102326:	c1 e8 10             	shr    $0x10,%eax
c0102329:	0f b7 c0             	movzwl %ax,%eax
c010232c:	66 a3 86 6b 12 c0    	mov    %ax,0xc0126b86
    SETGATE(idt[T_SWITCH_TOK],0,GD_KTEXT,__vectors[T_SWITCH_TOK],DPL_USER);
c0102332:	a1 c4 37 12 c0       	mov    0xc01237c4,%eax
c0102337:	0f b7 c0             	movzwl %ax,%eax
c010233a:	66 a3 48 6b 12 c0    	mov    %ax,0xc0126b48
c0102340:	66 c7 05 4a 6b 12 c0 	movw   $0x8,0xc0126b4a
c0102347:	08 00 
c0102349:	0f b6 05 4c 6b 12 c0 	movzbl 0xc0126b4c,%eax
c0102350:	24 e0                	and    $0xe0,%al
c0102352:	a2 4c 6b 12 c0       	mov    %al,0xc0126b4c
c0102357:	0f b6 05 4c 6b 12 c0 	movzbl 0xc0126b4c,%eax
c010235e:	24 1f                	and    $0x1f,%al
c0102360:	a2 4c 6b 12 c0       	mov    %al,0xc0126b4c
c0102365:	0f b6 05 4d 6b 12 c0 	movzbl 0xc0126b4d,%eax
c010236c:	24 f0                	and    $0xf0,%al
c010236e:	0c 0e                	or     $0xe,%al
c0102370:	a2 4d 6b 12 c0       	mov    %al,0xc0126b4d
c0102375:	0f b6 05 4d 6b 12 c0 	movzbl 0xc0126b4d,%eax
c010237c:	24 ef                	and    $0xef,%al
c010237e:	a2 4d 6b 12 c0       	mov    %al,0xc0126b4d
c0102383:	0f b6 05 4d 6b 12 c0 	movzbl 0xc0126b4d,%eax
c010238a:	0c 60                	or     $0x60,%al
c010238c:	a2 4d 6b 12 c0       	mov    %al,0xc0126b4d
c0102391:	0f b6 05 4d 6b 12 c0 	movzbl 0xc0126b4d,%eax
c0102398:	0c 80                	or     $0x80,%al
c010239a:	a2 4d 6b 12 c0       	mov    %al,0xc0126b4d
c010239f:	a1 c4 37 12 c0       	mov    0xc01237c4,%eax
c01023a4:	c1 e8 10             	shr    $0x10,%eax
c01023a7:	0f b7 c0             	movzwl %ax,%eax
c01023aa:	66 a3 4e 6b 12 c0    	mov    %ax,0xc0126b4e
c01023b0:	c7 45 f4 60 35 12 c0 	movl   $0xc0123560,-0xc(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01023b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023ba:	0f 01 18             	lidtl  (%eax)
}
c01023bd:	90                   	nop
    // load the IDT
    lidt(&idt_pd);
}
c01023be:	90                   	nop
c01023bf:	89 ec                	mov    %ebp,%esp
c01023c1:	5d                   	pop    %ebp
c01023c2:	c3                   	ret    

c01023c3 <trapname>:

static const char *
trapname(int trapno) {
c01023c3:	55                   	push   %ebp
c01023c4:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01023c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01023c9:	83 f8 13             	cmp    $0x13,%eax
c01023cc:	77 0c                	ja     c01023da <trapname+0x17>
        return excnames[trapno];
c01023ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01023d1:	8b 04 85 80 97 10 c0 	mov    -0x3fef6880(,%eax,4),%eax
c01023d8:	eb 18                	jmp    c01023f2 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01023da:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01023de:	7e 0d                	jle    c01023ed <trapname+0x2a>
c01023e0:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01023e4:	7f 07                	jg     c01023ed <trapname+0x2a>
        return "Hardware Interrupt";
c01023e6:	b8 3f 93 10 c0       	mov    $0xc010933f,%eax
c01023eb:	eb 05                	jmp    c01023f2 <trapname+0x2f>
    }
    return "(unknown trap)";
c01023ed:	b8 52 93 10 c0       	mov    $0xc0109352,%eax
}
c01023f2:	5d                   	pop    %ebp
c01023f3:	c3                   	ret    

c01023f4 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01023f4:	55                   	push   %ebp
c01023f5:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01023f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01023fa:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023fe:	83 f8 08             	cmp    $0x8,%eax
c0102401:	0f 94 c0             	sete   %al
c0102404:	0f b6 c0             	movzbl %al,%eax
}
c0102407:	5d                   	pop    %ebp
c0102408:	c3                   	ret    

c0102409 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0102409:	55                   	push   %ebp
c010240a:	89 e5                	mov    %esp,%ebp
c010240c:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c010240f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102412:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102416:	c7 04 24 93 93 10 c0 	movl   $0xc0109393,(%esp)
c010241d:	e8 43 df ff ff       	call   c0100365 <cprintf>
    print_regs(&tf->tf_regs);
c0102422:	8b 45 08             	mov    0x8(%ebp),%eax
c0102425:	89 04 24             	mov    %eax,(%esp)
c0102428:	e8 8f 01 00 00       	call   c01025bc <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c010242d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102430:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102434:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102438:	c7 04 24 a4 93 10 c0 	movl   $0xc01093a4,(%esp)
c010243f:	e8 21 df ff ff       	call   c0100365 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0102444:	8b 45 08             	mov    0x8(%ebp),%eax
c0102447:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c010244b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010244f:	c7 04 24 b7 93 10 c0 	movl   $0xc01093b7,(%esp)
c0102456:	e8 0a df ff ff       	call   c0100365 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c010245b:	8b 45 08             	mov    0x8(%ebp),%eax
c010245e:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0102462:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102466:	c7 04 24 ca 93 10 c0 	movl   $0xc01093ca,(%esp)
c010246d:	e8 f3 de ff ff       	call   c0100365 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0102472:	8b 45 08             	mov    0x8(%ebp),%eax
c0102475:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0102479:	89 44 24 04          	mov    %eax,0x4(%esp)
c010247d:	c7 04 24 dd 93 10 c0 	movl   $0xc01093dd,(%esp)
c0102484:	e8 dc de ff ff       	call   c0100365 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0102489:	8b 45 08             	mov    0x8(%ebp),%eax
c010248c:	8b 40 30             	mov    0x30(%eax),%eax
c010248f:	89 04 24             	mov    %eax,(%esp)
c0102492:	e8 2c ff ff ff       	call   c01023c3 <trapname>
c0102497:	8b 55 08             	mov    0x8(%ebp),%edx
c010249a:	8b 52 30             	mov    0x30(%edx),%edx
c010249d:	89 44 24 08          	mov    %eax,0x8(%esp)
c01024a1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01024a5:	c7 04 24 f0 93 10 c0 	movl   $0xc01093f0,(%esp)
c01024ac:	e8 b4 de ff ff       	call   c0100365 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c01024b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b4:	8b 40 34             	mov    0x34(%eax),%eax
c01024b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024bb:	c7 04 24 02 94 10 c0 	movl   $0xc0109402,(%esp)
c01024c2:	e8 9e de ff ff       	call   c0100365 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c01024c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ca:	8b 40 38             	mov    0x38(%eax),%eax
c01024cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024d1:	c7 04 24 11 94 10 c0 	movl   $0xc0109411,(%esp)
c01024d8:	e8 88 de ff ff       	call   c0100365 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01024dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01024e0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01024e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024e8:	c7 04 24 20 94 10 c0 	movl   $0xc0109420,(%esp)
c01024ef:	e8 71 de ff ff       	call   c0100365 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01024f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01024f7:	8b 40 40             	mov    0x40(%eax),%eax
c01024fa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024fe:	c7 04 24 33 94 10 c0 	movl   $0xc0109433,(%esp)
c0102505:	e8 5b de ff ff       	call   c0100365 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c010250a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102511:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102518:	eb 3d                	jmp    c0102557 <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c010251a:	8b 45 08             	mov    0x8(%ebp),%eax
c010251d:	8b 50 40             	mov    0x40(%eax),%edx
c0102520:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102523:	21 d0                	and    %edx,%eax
c0102525:	85 c0                	test   %eax,%eax
c0102527:	74 28                	je     c0102551 <print_trapframe+0x148>
c0102529:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010252c:	8b 04 85 80 35 12 c0 	mov    -0x3fedca80(,%eax,4),%eax
c0102533:	85 c0                	test   %eax,%eax
c0102535:	74 1a                	je     c0102551 <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
c0102537:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010253a:	8b 04 85 80 35 12 c0 	mov    -0x3fedca80(,%eax,4),%eax
c0102541:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102545:	c7 04 24 42 94 10 c0 	movl   $0xc0109442,(%esp)
c010254c:	e8 14 de ff ff       	call   c0100365 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102551:	ff 45 f4             	incl   -0xc(%ebp)
c0102554:	d1 65 f0             	shll   -0x10(%ebp)
c0102557:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010255a:	83 f8 17             	cmp    $0x17,%eax
c010255d:	76 bb                	jbe    c010251a <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c010255f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102562:	8b 40 40             	mov    0x40(%eax),%eax
c0102565:	c1 e8 0c             	shr    $0xc,%eax
c0102568:	83 e0 03             	and    $0x3,%eax
c010256b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010256f:	c7 04 24 46 94 10 c0 	movl   $0xc0109446,(%esp)
c0102576:	e8 ea dd ff ff       	call   c0100365 <cprintf>

    if (!trap_in_kernel(tf)) {
c010257b:	8b 45 08             	mov    0x8(%ebp),%eax
c010257e:	89 04 24             	mov    %eax,(%esp)
c0102581:	e8 6e fe ff ff       	call   c01023f4 <trap_in_kernel>
c0102586:	85 c0                	test   %eax,%eax
c0102588:	75 2d                	jne    c01025b7 <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c010258a:	8b 45 08             	mov    0x8(%ebp),%eax
c010258d:	8b 40 44             	mov    0x44(%eax),%eax
c0102590:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102594:	c7 04 24 4f 94 10 c0 	movl   $0xc010944f,(%esp)
c010259b:	e8 c5 dd ff ff       	call   c0100365 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c01025a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01025a3:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c01025a7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025ab:	c7 04 24 5e 94 10 c0 	movl   $0xc010945e,(%esp)
c01025b2:	e8 ae dd ff ff       	call   c0100365 <cprintf>
    }
}
c01025b7:	90                   	nop
c01025b8:	89 ec                	mov    %ebp,%esp
c01025ba:	5d                   	pop    %ebp
c01025bb:	c3                   	ret    

c01025bc <print_regs>:

void
print_regs(struct pushregs *regs) {
c01025bc:	55                   	push   %ebp
c01025bd:	89 e5                	mov    %esp,%ebp
c01025bf:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c01025c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01025c5:	8b 00                	mov    (%eax),%eax
c01025c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025cb:	c7 04 24 71 94 10 c0 	movl   $0xc0109471,(%esp)
c01025d2:	e8 8e dd ff ff       	call   c0100365 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01025d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01025da:	8b 40 04             	mov    0x4(%eax),%eax
c01025dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025e1:	c7 04 24 80 94 10 c0 	movl   $0xc0109480,(%esp)
c01025e8:	e8 78 dd ff ff       	call   c0100365 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01025ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01025f0:	8b 40 08             	mov    0x8(%eax),%eax
c01025f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025f7:	c7 04 24 8f 94 10 c0 	movl   $0xc010948f,(%esp)
c01025fe:	e8 62 dd ff ff       	call   c0100365 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0102603:	8b 45 08             	mov    0x8(%ebp),%eax
c0102606:	8b 40 0c             	mov    0xc(%eax),%eax
c0102609:	89 44 24 04          	mov    %eax,0x4(%esp)
c010260d:	c7 04 24 9e 94 10 c0 	movl   $0xc010949e,(%esp)
c0102614:	e8 4c dd ff ff       	call   c0100365 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0102619:	8b 45 08             	mov    0x8(%ebp),%eax
c010261c:	8b 40 10             	mov    0x10(%eax),%eax
c010261f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102623:	c7 04 24 ad 94 10 c0 	movl   $0xc01094ad,(%esp)
c010262a:	e8 36 dd ff ff       	call   c0100365 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c010262f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102632:	8b 40 14             	mov    0x14(%eax),%eax
c0102635:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102639:	c7 04 24 bc 94 10 c0 	movl   $0xc01094bc,(%esp)
c0102640:	e8 20 dd ff ff       	call   c0100365 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0102645:	8b 45 08             	mov    0x8(%ebp),%eax
c0102648:	8b 40 18             	mov    0x18(%eax),%eax
c010264b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010264f:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0102656:	e8 0a dd ff ff       	call   c0100365 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c010265b:	8b 45 08             	mov    0x8(%ebp),%eax
c010265e:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102661:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102665:	c7 04 24 da 94 10 c0 	movl   $0xc01094da,(%esp)
c010266c:	e8 f4 dc ff ff       	call   c0100365 <cprintf>
}
c0102671:	90                   	nop
c0102672:	89 ec                	mov    %ebp,%esp
c0102674:	5d                   	pop    %ebp
c0102675:	c3                   	ret    

c0102676 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102676:	55                   	push   %ebp
c0102677:	89 e5                	mov    %esp,%ebp
c0102679:	83 ec 38             	sub    $0x38,%esp
c010267c:	89 5d fc             	mov    %ebx,-0x4(%ebp)
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c010267f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102682:	8b 40 34             	mov    0x34(%eax),%eax
c0102685:	83 e0 01             	and    $0x1,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102688:	85 c0                	test   %eax,%eax
c010268a:	74 07                	je     c0102693 <print_pgfault+0x1d>
c010268c:	bb e9 94 10 c0       	mov    $0xc01094e9,%ebx
c0102691:	eb 05                	jmp    c0102698 <print_pgfault+0x22>
c0102693:	bb fa 94 10 c0       	mov    $0xc01094fa,%ebx
            (tf->tf_err & 2) ? 'W' : 'R',
c0102698:	8b 45 08             	mov    0x8(%ebp),%eax
c010269b:	8b 40 34             	mov    0x34(%eax),%eax
c010269e:	83 e0 02             	and    $0x2,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01026a1:	85 c0                	test   %eax,%eax
c01026a3:	74 07                	je     c01026ac <print_pgfault+0x36>
c01026a5:	b9 57 00 00 00       	mov    $0x57,%ecx
c01026aa:	eb 05                	jmp    c01026b1 <print_pgfault+0x3b>
c01026ac:	b9 52 00 00 00       	mov    $0x52,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
c01026b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01026b4:	8b 40 34             	mov    0x34(%eax),%eax
c01026b7:	83 e0 04             	and    $0x4,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01026ba:	85 c0                	test   %eax,%eax
c01026bc:	74 07                	je     c01026c5 <print_pgfault+0x4f>
c01026be:	ba 55 00 00 00       	mov    $0x55,%edx
c01026c3:	eb 05                	jmp    c01026ca <print_pgfault+0x54>
c01026c5:	ba 4b 00 00 00       	mov    $0x4b,%edx
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01026ca:	0f 20 d0             	mov    %cr2,%eax
c01026cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026d3:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c01026d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01026db:	89 54 24 08          	mov    %edx,0x8(%esp)
c01026df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026e3:	c7 04 24 08 95 10 c0 	movl   $0xc0109508,(%esp)
c01026ea:	e8 76 dc ff ff       	call   c0100365 <cprintf>
}
c01026ef:	90                   	nop
c01026f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01026f3:	89 ec                	mov    %ebp,%esp
c01026f5:	5d                   	pop    %ebp
c01026f6:	c3                   	ret    

c01026f7 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01026f7:	55                   	push   %ebp
c01026f8:	89 e5                	mov    %esp,%ebp
c01026fa:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c01026fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102700:	89 04 24             	mov    %eax,(%esp)
c0102703:	e8 6e ff ff ff       	call   c0102676 <print_pgfault>
    if (check_mm_struct != NULL) {
c0102708:	a1 0c 71 12 c0       	mov    0xc012710c,%eax
c010270d:	85 c0                	test   %eax,%eax
c010270f:	74 26                	je     c0102737 <pgfault_handler+0x40>
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102711:	0f 20 d0             	mov    %cr2,%eax
c0102714:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c0102717:	8b 4d f4             	mov    -0xc(%ebp),%ecx
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c010271a:	8b 45 08             	mov    0x8(%ebp),%eax
c010271d:	8b 50 34             	mov    0x34(%eax),%edx
c0102720:	a1 0c 71 12 c0       	mov    0xc012710c,%eax
c0102725:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0102729:	89 54 24 04          	mov    %edx,0x4(%esp)
c010272d:	89 04 24             	mov    %eax,(%esp)
c0102730:	e8 7f 57 00 00       	call   c0107eb4 <do_pgfault>
c0102735:	eb 1c                	jmp    c0102753 <pgfault_handler+0x5c>
    }
    panic("unhandled page fault.\n");
c0102737:	c7 44 24 08 2b 95 10 	movl   $0xc010952b,0x8(%esp)
c010273e:	c0 
c010273f:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0102746:	00 
c0102747:	c7 04 24 2e 93 10 c0 	movl   $0xc010932e,(%esp)
c010274e:	e8 9e e5 ff ff       	call   c0100cf1 <__panic>
}
c0102753:	89 ec                	mov    %ebp,%esp
c0102755:	5d                   	pop    %ebp
c0102756:	c3                   	ret    

c0102757 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c0102757:	55                   	push   %ebp
c0102758:	89 e5                	mov    %esp,%ebp
c010275a:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c010275d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102760:	8b 40 30             	mov    0x30(%eax),%eax
c0102763:	83 f8 2f             	cmp    $0x2f,%eax
c0102766:	77 1e                	ja     c0102786 <trap_dispatch+0x2f>
c0102768:	83 f8 0e             	cmp    $0xe,%eax
c010276b:	0f 82 1a 01 00 00    	jb     c010288b <trap_dispatch+0x134>
c0102771:	83 e8 0e             	sub    $0xe,%eax
c0102774:	83 f8 21             	cmp    $0x21,%eax
c0102777:	0f 87 0e 01 00 00    	ja     c010288b <trap_dispatch+0x134>
c010277d:	8b 04 85 ac 95 10 c0 	mov    -0x3fef6a54(,%eax,4),%eax
c0102784:	ff e0                	jmp    *%eax
c0102786:	83 e8 78             	sub    $0x78,%eax
c0102789:	83 f8 01             	cmp    $0x1,%eax
c010278c:	0f 87 f9 00 00 00    	ja     c010288b <trap_dispatch+0x134>
c0102792:	e9 d8 00 00 00       	jmp    c010286f <trap_dispatch+0x118>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c0102797:	8b 45 08             	mov    0x8(%ebp),%eax
c010279a:	89 04 24             	mov    %eax,(%esp)
c010279d:	e8 55 ff ff ff       	call   c01026f7 <pgfault_handler>
c01027a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01027a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01027a9:	0f 84 14 01 00 00    	je     c01028c3 <trap_dispatch+0x16c>
            print_trapframe(tf);
c01027af:	8b 45 08             	mov    0x8(%ebp),%eax
c01027b2:	89 04 24             	mov    %eax,(%esp)
c01027b5:	e8 4f fc ff ff       	call   c0102409 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c01027ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01027bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01027c1:	c7 44 24 08 42 95 10 	movl   $0xc0109542,0x8(%esp)
c01027c8:	c0 
c01027c9:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c01027d0:	00 
c01027d1:	c7 04 24 2e 93 10 c0 	movl   $0xc010932e,(%esp)
c01027d8:	e8 14 e5 ff ff       	call   c0100cf1 <__panic>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
c01027dd:	a1 24 64 12 c0       	mov    0xc0126424,%eax
c01027e2:	40                   	inc    %eax
c01027e3:	a3 24 64 12 c0       	mov    %eax,0xc0126424
        if(ticks%TICK_NUM==0){
c01027e8:	8b 0d 24 64 12 c0    	mov    0xc0126424,%ecx
c01027ee:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c01027f3:	89 c8                	mov    %ecx,%eax
c01027f5:	f7 e2                	mul    %edx
c01027f7:	c1 ea 05             	shr    $0x5,%edx
c01027fa:	89 d0                	mov    %edx,%eax
c01027fc:	c1 e0 02             	shl    $0x2,%eax
c01027ff:	01 d0                	add    %edx,%eax
c0102801:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0102808:	01 d0                	add    %edx,%eax
c010280a:	c1 e0 02             	shl    $0x2,%eax
c010280d:	29 c1                	sub    %eax,%ecx
c010280f:	89 ca                	mov    %ecx,%edx
c0102811:	85 d2                	test   %edx,%edx
c0102813:	0f 85 ad 00 00 00    	jne    c01028c6 <trap_dispatch+0x16f>
            //print ticks info
            print_ticks();
c0102819:	e8 6d f9 ff ff       	call   c010218b <print_ticks>
        }
        break;
c010281e:	e9 a3 00 00 00       	jmp    c01028c6 <trap_dispatch+0x16f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0102823:	e8 a9 ee ff ff       	call   c01016d1 <cons_getc>
c0102828:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c010282b:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c010282f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0102833:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102837:	89 44 24 04          	mov    %eax,0x4(%esp)
c010283b:	c7 04 24 5d 95 10 c0 	movl   $0xc010955d,(%esp)
c0102842:	e8 1e db ff ff       	call   c0100365 <cprintf>
        break;
c0102847:	eb 7e                	jmp    c01028c7 <trap_dispatch+0x170>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0102849:	e8 83 ee ff ff       	call   c01016d1 <cons_getc>
c010284e:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102851:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0102855:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0102859:	89 54 24 08          	mov    %edx,0x8(%esp)
c010285d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102861:	c7 04 24 6f 95 10 c0 	movl   $0xc010956f,(%esp)
c0102868:	e8 f8 da ff ff       	call   c0100365 <cprintf>
        break;
c010286d:	eb 58                	jmp    c01028c7 <trap_dispatch+0x170>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c010286f:	c7 44 24 08 7e 95 10 	movl   $0xc010957e,0x8(%esp)
c0102876:	c0 
c0102877:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c010287e:	00 
c010287f:	c7 04 24 2e 93 10 c0 	movl   $0xc010932e,(%esp)
c0102886:	e8 66 e4 ff ff       	call   c0100cf1 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c010288b:	8b 45 08             	mov    0x8(%ebp),%eax
c010288e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102892:	83 e0 03             	and    $0x3,%eax
c0102895:	85 c0                	test   %eax,%eax
c0102897:	75 2e                	jne    c01028c7 <trap_dispatch+0x170>
            print_trapframe(tf);
c0102899:	8b 45 08             	mov    0x8(%ebp),%eax
c010289c:	89 04 24             	mov    %eax,(%esp)
c010289f:	e8 65 fb ff ff       	call   c0102409 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c01028a4:	c7 44 24 08 8e 95 10 	movl   $0xc010958e,0x8(%esp)
c01028ab:	c0 
c01028ac:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c01028b3:	00 
c01028b4:	c7 04 24 2e 93 10 c0 	movl   $0xc010932e,(%esp)
c01028bb:	e8 31 e4 ff ff       	call   c0100cf1 <__panic>
        break;
c01028c0:	90                   	nop
c01028c1:	eb 04                	jmp    c01028c7 <trap_dispatch+0x170>
        break;
c01028c3:	90                   	nop
c01028c4:	eb 01                	jmp    c01028c7 <trap_dispatch+0x170>
        break;
c01028c6:	90                   	nop
        }
    }
}
c01028c7:	90                   	nop
c01028c8:	89 ec                	mov    %ebp,%esp
c01028ca:	5d                   	pop    %ebp
c01028cb:	c3                   	ret    

c01028cc <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c01028cc:	55                   	push   %ebp
c01028cd:	89 e5                	mov    %esp,%ebp
c01028cf:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c01028d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01028d5:	89 04 24             	mov    %eax,(%esp)
c01028d8:	e8 7a fe ff ff       	call   c0102757 <trap_dispatch>
}
c01028dd:	90                   	nop
c01028de:	89 ec                	mov    %ebp,%esp
c01028e0:	5d                   	pop    %ebp
c01028e1:	c3                   	ret    

c01028e2 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01028e2:	1e                   	push   %ds
    pushl %es
c01028e3:	06                   	push   %es
    pushl %fs
c01028e4:	0f a0                	push   %fs
    pushl %gs
c01028e6:	0f a8                	push   %gs
    pushal
c01028e8:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01028e9:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01028ee:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01028f0:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01028f2:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01028f3:	e8 d4 ff ff ff       	call   c01028cc <trap>

    # pop the pushed stack pointer
    popl %esp
c01028f8:	5c                   	pop    %esp

c01028f9 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01028f9:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01028fa:	0f a9                	pop    %gs
    popl %fs
c01028fc:	0f a1                	pop    %fs
    popl %es
c01028fe:	07                   	pop    %es
    popl %ds
c01028ff:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102900:	83 c4 08             	add    $0x8,%esp
    iret
c0102903:	cf                   	iret   

c0102904 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102904:	6a 00                	push   $0x0
  pushl $0
c0102906:	6a 00                	push   $0x0
  jmp __alltraps
c0102908:	e9 d5 ff ff ff       	jmp    c01028e2 <__alltraps>

c010290d <vector1>:
.globl vector1
vector1:
  pushl $0
c010290d:	6a 00                	push   $0x0
  pushl $1
c010290f:	6a 01                	push   $0x1
  jmp __alltraps
c0102911:	e9 cc ff ff ff       	jmp    c01028e2 <__alltraps>

c0102916 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102916:	6a 00                	push   $0x0
  pushl $2
c0102918:	6a 02                	push   $0x2
  jmp __alltraps
c010291a:	e9 c3 ff ff ff       	jmp    c01028e2 <__alltraps>

c010291f <vector3>:
.globl vector3
vector3:
  pushl $0
c010291f:	6a 00                	push   $0x0
  pushl $3
c0102921:	6a 03                	push   $0x3
  jmp __alltraps
c0102923:	e9 ba ff ff ff       	jmp    c01028e2 <__alltraps>

c0102928 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102928:	6a 00                	push   $0x0
  pushl $4
c010292a:	6a 04                	push   $0x4
  jmp __alltraps
c010292c:	e9 b1 ff ff ff       	jmp    c01028e2 <__alltraps>

c0102931 <vector5>:
.globl vector5
vector5:
  pushl $0
c0102931:	6a 00                	push   $0x0
  pushl $5
c0102933:	6a 05                	push   $0x5
  jmp __alltraps
c0102935:	e9 a8 ff ff ff       	jmp    c01028e2 <__alltraps>

c010293a <vector6>:
.globl vector6
vector6:
  pushl $0
c010293a:	6a 00                	push   $0x0
  pushl $6
c010293c:	6a 06                	push   $0x6
  jmp __alltraps
c010293e:	e9 9f ff ff ff       	jmp    c01028e2 <__alltraps>

c0102943 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102943:	6a 00                	push   $0x0
  pushl $7
c0102945:	6a 07                	push   $0x7
  jmp __alltraps
c0102947:	e9 96 ff ff ff       	jmp    c01028e2 <__alltraps>

c010294c <vector8>:
.globl vector8
vector8:
  pushl $8
c010294c:	6a 08                	push   $0x8
  jmp __alltraps
c010294e:	e9 8f ff ff ff       	jmp    c01028e2 <__alltraps>

c0102953 <vector9>:
.globl vector9
vector9:
  pushl $0
c0102953:	6a 00                	push   $0x0
  pushl $9
c0102955:	6a 09                	push   $0x9
  jmp __alltraps
c0102957:	e9 86 ff ff ff       	jmp    c01028e2 <__alltraps>

c010295c <vector10>:
.globl vector10
vector10:
  pushl $10
c010295c:	6a 0a                	push   $0xa
  jmp __alltraps
c010295e:	e9 7f ff ff ff       	jmp    c01028e2 <__alltraps>

c0102963 <vector11>:
.globl vector11
vector11:
  pushl $11
c0102963:	6a 0b                	push   $0xb
  jmp __alltraps
c0102965:	e9 78 ff ff ff       	jmp    c01028e2 <__alltraps>

c010296a <vector12>:
.globl vector12
vector12:
  pushl $12
c010296a:	6a 0c                	push   $0xc
  jmp __alltraps
c010296c:	e9 71 ff ff ff       	jmp    c01028e2 <__alltraps>

c0102971 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102971:	6a 0d                	push   $0xd
  jmp __alltraps
c0102973:	e9 6a ff ff ff       	jmp    c01028e2 <__alltraps>

c0102978 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102978:	6a 0e                	push   $0xe
  jmp __alltraps
c010297a:	e9 63 ff ff ff       	jmp    c01028e2 <__alltraps>

c010297f <vector15>:
.globl vector15
vector15:
  pushl $0
c010297f:	6a 00                	push   $0x0
  pushl $15
c0102981:	6a 0f                	push   $0xf
  jmp __alltraps
c0102983:	e9 5a ff ff ff       	jmp    c01028e2 <__alltraps>

c0102988 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102988:	6a 00                	push   $0x0
  pushl $16
c010298a:	6a 10                	push   $0x10
  jmp __alltraps
c010298c:	e9 51 ff ff ff       	jmp    c01028e2 <__alltraps>

c0102991 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102991:	6a 11                	push   $0x11
  jmp __alltraps
c0102993:	e9 4a ff ff ff       	jmp    c01028e2 <__alltraps>

c0102998 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102998:	6a 00                	push   $0x0
  pushl $18
c010299a:	6a 12                	push   $0x12
  jmp __alltraps
c010299c:	e9 41 ff ff ff       	jmp    c01028e2 <__alltraps>

c01029a1 <vector19>:
.globl vector19
vector19:
  pushl $0
c01029a1:	6a 00                	push   $0x0
  pushl $19
c01029a3:	6a 13                	push   $0x13
  jmp __alltraps
c01029a5:	e9 38 ff ff ff       	jmp    c01028e2 <__alltraps>

c01029aa <vector20>:
.globl vector20
vector20:
  pushl $0
c01029aa:	6a 00                	push   $0x0
  pushl $20
c01029ac:	6a 14                	push   $0x14
  jmp __alltraps
c01029ae:	e9 2f ff ff ff       	jmp    c01028e2 <__alltraps>

c01029b3 <vector21>:
.globl vector21
vector21:
  pushl $0
c01029b3:	6a 00                	push   $0x0
  pushl $21
c01029b5:	6a 15                	push   $0x15
  jmp __alltraps
c01029b7:	e9 26 ff ff ff       	jmp    c01028e2 <__alltraps>

c01029bc <vector22>:
.globl vector22
vector22:
  pushl $0
c01029bc:	6a 00                	push   $0x0
  pushl $22
c01029be:	6a 16                	push   $0x16
  jmp __alltraps
c01029c0:	e9 1d ff ff ff       	jmp    c01028e2 <__alltraps>

c01029c5 <vector23>:
.globl vector23
vector23:
  pushl $0
c01029c5:	6a 00                	push   $0x0
  pushl $23
c01029c7:	6a 17                	push   $0x17
  jmp __alltraps
c01029c9:	e9 14 ff ff ff       	jmp    c01028e2 <__alltraps>

c01029ce <vector24>:
.globl vector24
vector24:
  pushl $0
c01029ce:	6a 00                	push   $0x0
  pushl $24
c01029d0:	6a 18                	push   $0x18
  jmp __alltraps
c01029d2:	e9 0b ff ff ff       	jmp    c01028e2 <__alltraps>

c01029d7 <vector25>:
.globl vector25
vector25:
  pushl $0
c01029d7:	6a 00                	push   $0x0
  pushl $25
c01029d9:	6a 19                	push   $0x19
  jmp __alltraps
c01029db:	e9 02 ff ff ff       	jmp    c01028e2 <__alltraps>

c01029e0 <vector26>:
.globl vector26
vector26:
  pushl $0
c01029e0:	6a 00                	push   $0x0
  pushl $26
c01029e2:	6a 1a                	push   $0x1a
  jmp __alltraps
c01029e4:	e9 f9 fe ff ff       	jmp    c01028e2 <__alltraps>

c01029e9 <vector27>:
.globl vector27
vector27:
  pushl $0
c01029e9:	6a 00                	push   $0x0
  pushl $27
c01029eb:	6a 1b                	push   $0x1b
  jmp __alltraps
c01029ed:	e9 f0 fe ff ff       	jmp    c01028e2 <__alltraps>

c01029f2 <vector28>:
.globl vector28
vector28:
  pushl $0
c01029f2:	6a 00                	push   $0x0
  pushl $28
c01029f4:	6a 1c                	push   $0x1c
  jmp __alltraps
c01029f6:	e9 e7 fe ff ff       	jmp    c01028e2 <__alltraps>

c01029fb <vector29>:
.globl vector29
vector29:
  pushl $0
c01029fb:	6a 00                	push   $0x0
  pushl $29
c01029fd:	6a 1d                	push   $0x1d
  jmp __alltraps
c01029ff:	e9 de fe ff ff       	jmp    c01028e2 <__alltraps>

c0102a04 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102a04:	6a 00                	push   $0x0
  pushl $30
c0102a06:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102a08:	e9 d5 fe ff ff       	jmp    c01028e2 <__alltraps>

c0102a0d <vector31>:
.globl vector31
vector31:
  pushl $0
c0102a0d:	6a 00                	push   $0x0
  pushl $31
c0102a0f:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102a11:	e9 cc fe ff ff       	jmp    c01028e2 <__alltraps>

c0102a16 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102a16:	6a 00                	push   $0x0
  pushl $32
c0102a18:	6a 20                	push   $0x20
  jmp __alltraps
c0102a1a:	e9 c3 fe ff ff       	jmp    c01028e2 <__alltraps>

c0102a1f <vector33>:
.globl vector33
vector33:
  pushl $0
c0102a1f:	6a 00                	push   $0x0
  pushl $33
c0102a21:	6a 21                	push   $0x21
  jmp __alltraps
c0102a23:	e9 ba fe ff ff       	jmp    c01028e2 <__alltraps>

c0102a28 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102a28:	6a 00                	push   $0x0
  pushl $34
c0102a2a:	6a 22                	push   $0x22
  jmp __alltraps
c0102a2c:	e9 b1 fe ff ff       	jmp    c01028e2 <__alltraps>

c0102a31 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102a31:	6a 00                	push   $0x0
  pushl $35
c0102a33:	6a 23                	push   $0x23
  jmp __alltraps
c0102a35:	e9 a8 fe ff ff       	jmp    c01028e2 <__alltraps>

c0102a3a <vector36>:
.globl vector36
vector36:
  pushl $0
c0102a3a:	6a 00                	push   $0x0
  pushl $36
c0102a3c:	6a 24                	push   $0x24
  jmp __alltraps
c0102a3e:	e9 9f fe ff ff       	jmp    c01028e2 <__alltraps>

c0102a43 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102a43:	6a 00                	push   $0x0
  pushl $37
c0102a45:	6a 25                	push   $0x25
  jmp __alltraps
c0102a47:	e9 96 fe ff ff       	jmp    c01028e2 <__alltraps>

c0102a4c <vector38>:
.globl vector38
vector38:
  pushl $0
c0102a4c:	6a 00                	push   $0x0
  pushl $38
c0102a4e:	6a 26                	push   $0x26
  jmp __alltraps
c0102a50:	e9 8d fe ff ff       	jmp    c01028e2 <__alltraps>

c0102a55 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102a55:	6a 00                	push   $0x0
  pushl $39
c0102a57:	6a 27                	push   $0x27
  jmp __alltraps
c0102a59:	e9 84 fe ff ff       	jmp    c01028e2 <__alltraps>

c0102a5e <vector40>:
.globl vector40
vector40:
  pushl $0
c0102a5e:	6a 00                	push   $0x0
  pushl $40
c0102a60:	6a 28                	push   $0x28
  jmp __alltraps
c0102a62:	e9 7b fe ff ff       	jmp    c01028e2 <__alltraps>

c0102a67 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102a67:	6a 00                	push   $0x0
  pushl $41
c0102a69:	6a 29                	push   $0x29
  jmp __alltraps
c0102a6b:	e9 72 fe ff ff       	jmp    c01028e2 <__alltraps>

c0102a70 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102a70:	6a 00                	push   $0x0
  pushl $42
c0102a72:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102a74:	e9 69 fe ff ff       	jmp    c01028e2 <__alltraps>

c0102a79 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102a79:	6a 00                	push   $0x0
  pushl $43
c0102a7b:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102a7d:	e9 60 fe ff ff       	jmp    c01028e2 <__alltraps>

c0102a82 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102a82:	6a 00                	push   $0x0
  pushl $44
c0102a84:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102a86:	e9 57 fe ff ff       	jmp    c01028e2 <__alltraps>

c0102a8b <vector45>:
.globl vector45
vector45:
  pushl $0
c0102a8b:	6a 00                	push   $0x0
  pushl $45
c0102a8d:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102a8f:	e9 4e fe ff ff       	jmp    c01028e2 <__alltraps>

c0102a94 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102a94:	6a 00                	push   $0x0
  pushl $46
c0102a96:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102a98:	e9 45 fe ff ff       	jmp    c01028e2 <__alltraps>

c0102a9d <vector47>:
.globl vector47
vector47:
  pushl $0
c0102a9d:	6a 00                	push   $0x0
  pushl $47
c0102a9f:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102aa1:	e9 3c fe ff ff       	jmp    c01028e2 <__alltraps>

c0102aa6 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102aa6:	6a 00                	push   $0x0
  pushl $48
c0102aa8:	6a 30                	push   $0x30
  jmp __alltraps
c0102aaa:	e9 33 fe ff ff       	jmp    c01028e2 <__alltraps>

c0102aaf <vector49>:
.globl vector49
vector49:
  pushl $0
c0102aaf:	6a 00                	push   $0x0
  pushl $49
c0102ab1:	6a 31                	push   $0x31
  jmp __alltraps
c0102ab3:	e9 2a fe ff ff       	jmp    c01028e2 <__alltraps>

c0102ab8 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102ab8:	6a 00                	push   $0x0
  pushl $50
c0102aba:	6a 32                	push   $0x32
  jmp __alltraps
c0102abc:	e9 21 fe ff ff       	jmp    c01028e2 <__alltraps>

c0102ac1 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102ac1:	6a 00                	push   $0x0
  pushl $51
c0102ac3:	6a 33                	push   $0x33
  jmp __alltraps
c0102ac5:	e9 18 fe ff ff       	jmp    c01028e2 <__alltraps>

c0102aca <vector52>:
.globl vector52
vector52:
  pushl $0
c0102aca:	6a 00                	push   $0x0
  pushl $52
c0102acc:	6a 34                	push   $0x34
  jmp __alltraps
c0102ace:	e9 0f fe ff ff       	jmp    c01028e2 <__alltraps>

c0102ad3 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102ad3:	6a 00                	push   $0x0
  pushl $53
c0102ad5:	6a 35                	push   $0x35
  jmp __alltraps
c0102ad7:	e9 06 fe ff ff       	jmp    c01028e2 <__alltraps>

c0102adc <vector54>:
.globl vector54
vector54:
  pushl $0
c0102adc:	6a 00                	push   $0x0
  pushl $54
c0102ade:	6a 36                	push   $0x36
  jmp __alltraps
c0102ae0:	e9 fd fd ff ff       	jmp    c01028e2 <__alltraps>

c0102ae5 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102ae5:	6a 00                	push   $0x0
  pushl $55
c0102ae7:	6a 37                	push   $0x37
  jmp __alltraps
c0102ae9:	e9 f4 fd ff ff       	jmp    c01028e2 <__alltraps>

c0102aee <vector56>:
.globl vector56
vector56:
  pushl $0
c0102aee:	6a 00                	push   $0x0
  pushl $56
c0102af0:	6a 38                	push   $0x38
  jmp __alltraps
c0102af2:	e9 eb fd ff ff       	jmp    c01028e2 <__alltraps>

c0102af7 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102af7:	6a 00                	push   $0x0
  pushl $57
c0102af9:	6a 39                	push   $0x39
  jmp __alltraps
c0102afb:	e9 e2 fd ff ff       	jmp    c01028e2 <__alltraps>

c0102b00 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102b00:	6a 00                	push   $0x0
  pushl $58
c0102b02:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102b04:	e9 d9 fd ff ff       	jmp    c01028e2 <__alltraps>

c0102b09 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102b09:	6a 00                	push   $0x0
  pushl $59
c0102b0b:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102b0d:	e9 d0 fd ff ff       	jmp    c01028e2 <__alltraps>

c0102b12 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102b12:	6a 00                	push   $0x0
  pushl $60
c0102b14:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102b16:	e9 c7 fd ff ff       	jmp    c01028e2 <__alltraps>

c0102b1b <vector61>:
.globl vector61
vector61:
  pushl $0
c0102b1b:	6a 00                	push   $0x0
  pushl $61
c0102b1d:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102b1f:	e9 be fd ff ff       	jmp    c01028e2 <__alltraps>

c0102b24 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102b24:	6a 00                	push   $0x0
  pushl $62
c0102b26:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102b28:	e9 b5 fd ff ff       	jmp    c01028e2 <__alltraps>

c0102b2d <vector63>:
.globl vector63
vector63:
  pushl $0
c0102b2d:	6a 00                	push   $0x0
  pushl $63
c0102b2f:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102b31:	e9 ac fd ff ff       	jmp    c01028e2 <__alltraps>

c0102b36 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102b36:	6a 00                	push   $0x0
  pushl $64
c0102b38:	6a 40                	push   $0x40
  jmp __alltraps
c0102b3a:	e9 a3 fd ff ff       	jmp    c01028e2 <__alltraps>

c0102b3f <vector65>:
.globl vector65
vector65:
  pushl $0
c0102b3f:	6a 00                	push   $0x0
  pushl $65
c0102b41:	6a 41                	push   $0x41
  jmp __alltraps
c0102b43:	e9 9a fd ff ff       	jmp    c01028e2 <__alltraps>

c0102b48 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102b48:	6a 00                	push   $0x0
  pushl $66
c0102b4a:	6a 42                	push   $0x42
  jmp __alltraps
c0102b4c:	e9 91 fd ff ff       	jmp    c01028e2 <__alltraps>

c0102b51 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102b51:	6a 00                	push   $0x0
  pushl $67
c0102b53:	6a 43                	push   $0x43
  jmp __alltraps
c0102b55:	e9 88 fd ff ff       	jmp    c01028e2 <__alltraps>

c0102b5a <vector68>:
.globl vector68
vector68:
  pushl $0
c0102b5a:	6a 00                	push   $0x0
  pushl $68
c0102b5c:	6a 44                	push   $0x44
  jmp __alltraps
c0102b5e:	e9 7f fd ff ff       	jmp    c01028e2 <__alltraps>

c0102b63 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102b63:	6a 00                	push   $0x0
  pushl $69
c0102b65:	6a 45                	push   $0x45
  jmp __alltraps
c0102b67:	e9 76 fd ff ff       	jmp    c01028e2 <__alltraps>

c0102b6c <vector70>:
.globl vector70
vector70:
  pushl $0
c0102b6c:	6a 00                	push   $0x0
  pushl $70
c0102b6e:	6a 46                	push   $0x46
  jmp __alltraps
c0102b70:	e9 6d fd ff ff       	jmp    c01028e2 <__alltraps>

c0102b75 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102b75:	6a 00                	push   $0x0
  pushl $71
c0102b77:	6a 47                	push   $0x47
  jmp __alltraps
c0102b79:	e9 64 fd ff ff       	jmp    c01028e2 <__alltraps>

c0102b7e <vector72>:
.globl vector72
vector72:
  pushl $0
c0102b7e:	6a 00                	push   $0x0
  pushl $72
c0102b80:	6a 48                	push   $0x48
  jmp __alltraps
c0102b82:	e9 5b fd ff ff       	jmp    c01028e2 <__alltraps>

c0102b87 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102b87:	6a 00                	push   $0x0
  pushl $73
c0102b89:	6a 49                	push   $0x49
  jmp __alltraps
c0102b8b:	e9 52 fd ff ff       	jmp    c01028e2 <__alltraps>

c0102b90 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102b90:	6a 00                	push   $0x0
  pushl $74
c0102b92:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102b94:	e9 49 fd ff ff       	jmp    c01028e2 <__alltraps>

c0102b99 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102b99:	6a 00                	push   $0x0
  pushl $75
c0102b9b:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102b9d:	e9 40 fd ff ff       	jmp    c01028e2 <__alltraps>

c0102ba2 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102ba2:	6a 00                	push   $0x0
  pushl $76
c0102ba4:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102ba6:	e9 37 fd ff ff       	jmp    c01028e2 <__alltraps>

c0102bab <vector77>:
.globl vector77
vector77:
  pushl $0
c0102bab:	6a 00                	push   $0x0
  pushl $77
c0102bad:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102baf:	e9 2e fd ff ff       	jmp    c01028e2 <__alltraps>

c0102bb4 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102bb4:	6a 00                	push   $0x0
  pushl $78
c0102bb6:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102bb8:	e9 25 fd ff ff       	jmp    c01028e2 <__alltraps>

c0102bbd <vector79>:
.globl vector79
vector79:
  pushl $0
c0102bbd:	6a 00                	push   $0x0
  pushl $79
c0102bbf:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102bc1:	e9 1c fd ff ff       	jmp    c01028e2 <__alltraps>

c0102bc6 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102bc6:	6a 00                	push   $0x0
  pushl $80
c0102bc8:	6a 50                	push   $0x50
  jmp __alltraps
c0102bca:	e9 13 fd ff ff       	jmp    c01028e2 <__alltraps>

c0102bcf <vector81>:
.globl vector81
vector81:
  pushl $0
c0102bcf:	6a 00                	push   $0x0
  pushl $81
c0102bd1:	6a 51                	push   $0x51
  jmp __alltraps
c0102bd3:	e9 0a fd ff ff       	jmp    c01028e2 <__alltraps>

c0102bd8 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102bd8:	6a 00                	push   $0x0
  pushl $82
c0102bda:	6a 52                	push   $0x52
  jmp __alltraps
c0102bdc:	e9 01 fd ff ff       	jmp    c01028e2 <__alltraps>

c0102be1 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102be1:	6a 00                	push   $0x0
  pushl $83
c0102be3:	6a 53                	push   $0x53
  jmp __alltraps
c0102be5:	e9 f8 fc ff ff       	jmp    c01028e2 <__alltraps>

c0102bea <vector84>:
.globl vector84
vector84:
  pushl $0
c0102bea:	6a 00                	push   $0x0
  pushl $84
c0102bec:	6a 54                	push   $0x54
  jmp __alltraps
c0102bee:	e9 ef fc ff ff       	jmp    c01028e2 <__alltraps>

c0102bf3 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102bf3:	6a 00                	push   $0x0
  pushl $85
c0102bf5:	6a 55                	push   $0x55
  jmp __alltraps
c0102bf7:	e9 e6 fc ff ff       	jmp    c01028e2 <__alltraps>

c0102bfc <vector86>:
.globl vector86
vector86:
  pushl $0
c0102bfc:	6a 00                	push   $0x0
  pushl $86
c0102bfe:	6a 56                	push   $0x56
  jmp __alltraps
c0102c00:	e9 dd fc ff ff       	jmp    c01028e2 <__alltraps>

c0102c05 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102c05:	6a 00                	push   $0x0
  pushl $87
c0102c07:	6a 57                	push   $0x57
  jmp __alltraps
c0102c09:	e9 d4 fc ff ff       	jmp    c01028e2 <__alltraps>

c0102c0e <vector88>:
.globl vector88
vector88:
  pushl $0
c0102c0e:	6a 00                	push   $0x0
  pushl $88
c0102c10:	6a 58                	push   $0x58
  jmp __alltraps
c0102c12:	e9 cb fc ff ff       	jmp    c01028e2 <__alltraps>

c0102c17 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102c17:	6a 00                	push   $0x0
  pushl $89
c0102c19:	6a 59                	push   $0x59
  jmp __alltraps
c0102c1b:	e9 c2 fc ff ff       	jmp    c01028e2 <__alltraps>

c0102c20 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102c20:	6a 00                	push   $0x0
  pushl $90
c0102c22:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102c24:	e9 b9 fc ff ff       	jmp    c01028e2 <__alltraps>

c0102c29 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102c29:	6a 00                	push   $0x0
  pushl $91
c0102c2b:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102c2d:	e9 b0 fc ff ff       	jmp    c01028e2 <__alltraps>

c0102c32 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102c32:	6a 00                	push   $0x0
  pushl $92
c0102c34:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102c36:	e9 a7 fc ff ff       	jmp    c01028e2 <__alltraps>

c0102c3b <vector93>:
.globl vector93
vector93:
  pushl $0
c0102c3b:	6a 00                	push   $0x0
  pushl $93
c0102c3d:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102c3f:	e9 9e fc ff ff       	jmp    c01028e2 <__alltraps>

c0102c44 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102c44:	6a 00                	push   $0x0
  pushl $94
c0102c46:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102c48:	e9 95 fc ff ff       	jmp    c01028e2 <__alltraps>

c0102c4d <vector95>:
.globl vector95
vector95:
  pushl $0
c0102c4d:	6a 00                	push   $0x0
  pushl $95
c0102c4f:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102c51:	e9 8c fc ff ff       	jmp    c01028e2 <__alltraps>

c0102c56 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102c56:	6a 00                	push   $0x0
  pushl $96
c0102c58:	6a 60                	push   $0x60
  jmp __alltraps
c0102c5a:	e9 83 fc ff ff       	jmp    c01028e2 <__alltraps>

c0102c5f <vector97>:
.globl vector97
vector97:
  pushl $0
c0102c5f:	6a 00                	push   $0x0
  pushl $97
c0102c61:	6a 61                	push   $0x61
  jmp __alltraps
c0102c63:	e9 7a fc ff ff       	jmp    c01028e2 <__alltraps>

c0102c68 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102c68:	6a 00                	push   $0x0
  pushl $98
c0102c6a:	6a 62                	push   $0x62
  jmp __alltraps
c0102c6c:	e9 71 fc ff ff       	jmp    c01028e2 <__alltraps>

c0102c71 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102c71:	6a 00                	push   $0x0
  pushl $99
c0102c73:	6a 63                	push   $0x63
  jmp __alltraps
c0102c75:	e9 68 fc ff ff       	jmp    c01028e2 <__alltraps>

c0102c7a <vector100>:
.globl vector100
vector100:
  pushl $0
c0102c7a:	6a 00                	push   $0x0
  pushl $100
c0102c7c:	6a 64                	push   $0x64
  jmp __alltraps
c0102c7e:	e9 5f fc ff ff       	jmp    c01028e2 <__alltraps>

c0102c83 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102c83:	6a 00                	push   $0x0
  pushl $101
c0102c85:	6a 65                	push   $0x65
  jmp __alltraps
c0102c87:	e9 56 fc ff ff       	jmp    c01028e2 <__alltraps>

c0102c8c <vector102>:
.globl vector102
vector102:
  pushl $0
c0102c8c:	6a 00                	push   $0x0
  pushl $102
c0102c8e:	6a 66                	push   $0x66
  jmp __alltraps
c0102c90:	e9 4d fc ff ff       	jmp    c01028e2 <__alltraps>

c0102c95 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102c95:	6a 00                	push   $0x0
  pushl $103
c0102c97:	6a 67                	push   $0x67
  jmp __alltraps
c0102c99:	e9 44 fc ff ff       	jmp    c01028e2 <__alltraps>

c0102c9e <vector104>:
.globl vector104
vector104:
  pushl $0
c0102c9e:	6a 00                	push   $0x0
  pushl $104
c0102ca0:	6a 68                	push   $0x68
  jmp __alltraps
c0102ca2:	e9 3b fc ff ff       	jmp    c01028e2 <__alltraps>

c0102ca7 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102ca7:	6a 00                	push   $0x0
  pushl $105
c0102ca9:	6a 69                	push   $0x69
  jmp __alltraps
c0102cab:	e9 32 fc ff ff       	jmp    c01028e2 <__alltraps>

c0102cb0 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102cb0:	6a 00                	push   $0x0
  pushl $106
c0102cb2:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102cb4:	e9 29 fc ff ff       	jmp    c01028e2 <__alltraps>

c0102cb9 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102cb9:	6a 00                	push   $0x0
  pushl $107
c0102cbb:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102cbd:	e9 20 fc ff ff       	jmp    c01028e2 <__alltraps>

c0102cc2 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102cc2:	6a 00                	push   $0x0
  pushl $108
c0102cc4:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102cc6:	e9 17 fc ff ff       	jmp    c01028e2 <__alltraps>

c0102ccb <vector109>:
.globl vector109
vector109:
  pushl $0
c0102ccb:	6a 00                	push   $0x0
  pushl $109
c0102ccd:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102ccf:	e9 0e fc ff ff       	jmp    c01028e2 <__alltraps>

c0102cd4 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102cd4:	6a 00                	push   $0x0
  pushl $110
c0102cd6:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102cd8:	e9 05 fc ff ff       	jmp    c01028e2 <__alltraps>

c0102cdd <vector111>:
.globl vector111
vector111:
  pushl $0
c0102cdd:	6a 00                	push   $0x0
  pushl $111
c0102cdf:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102ce1:	e9 fc fb ff ff       	jmp    c01028e2 <__alltraps>

c0102ce6 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102ce6:	6a 00                	push   $0x0
  pushl $112
c0102ce8:	6a 70                	push   $0x70
  jmp __alltraps
c0102cea:	e9 f3 fb ff ff       	jmp    c01028e2 <__alltraps>

c0102cef <vector113>:
.globl vector113
vector113:
  pushl $0
c0102cef:	6a 00                	push   $0x0
  pushl $113
c0102cf1:	6a 71                	push   $0x71
  jmp __alltraps
c0102cf3:	e9 ea fb ff ff       	jmp    c01028e2 <__alltraps>

c0102cf8 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102cf8:	6a 00                	push   $0x0
  pushl $114
c0102cfa:	6a 72                	push   $0x72
  jmp __alltraps
c0102cfc:	e9 e1 fb ff ff       	jmp    c01028e2 <__alltraps>

c0102d01 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102d01:	6a 00                	push   $0x0
  pushl $115
c0102d03:	6a 73                	push   $0x73
  jmp __alltraps
c0102d05:	e9 d8 fb ff ff       	jmp    c01028e2 <__alltraps>

c0102d0a <vector116>:
.globl vector116
vector116:
  pushl $0
c0102d0a:	6a 00                	push   $0x0
  pushl $116
c0102d0c:	6a 74                	push   $0x74
  jmp __alltraps
c0102d0e:	e9 cf fb ff ff       	jmp    c01028e2 <__alltraps>

c0102d13 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102d13:	6a 00                	push   $0x0
  pushl $117
c0102d15:	6a 75                	push   $0x75
  jmp __alltraps
c0102d17:	e9 c6 fb ff ff       	jmp    c01028e2 <__alltraps>

c0102d1c <vector118>:
.globl vector118
vector118:
  pushl $0
c0102d1c:	6a 00                	push   $0x0
  pushl $118
c0102d1e:	6a 76                	push   $0x76
  jmp __alltraps
c0102d20:	e9 bd fb ff ff       	jmp    c01028e2 <__alltraps>

c0102d25 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102d25:	6a 00                	push   $0x0
  pushl $119
c0102d27:	6a 77                	push   $0x77
  jmp __alltraps
c0102d29:	e9 b4 fb ff ff       	jmp    c01028e2 <__alltraps>

c0102d2e <vector120>:
.globl vector120
vector120:
  pushl $0
c0102d2e:	6a 00                	push   $0x0
  pushl $120
c0102d30:	6a 78                	push   $0x78
  jmp __alltraps
c0102d32:	e9 ab fb ff ff       	jmp    c01028e2 <__alltraps>

c0102d37 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102d37:	6a 00                	push   $0x0
  pushl $121
c0102d39:	6a 79                	push   $0x79
  jmp __alltraps
c0102d3b:	e9 a2 fb ff ff       	jmp    c01028e2 <__alltraps>

c0102d40 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102d40:	6a 00                	push   $0x0
  pushl $122
c0102d42:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102d44:	e9 99 fb ff ff       	jmp    c01028e2 <__alltraps>

c0102d49 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102d49:	6a 00                	push   $0x0
  pushl $123
c0102d4b:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102d4d:	e9 90 fb ff ff       	jmp    c01028e2 <__alltraps>

c0102d52 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102d52:	6a 00                	push   $0x0
  pushl $124
c0102d54:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102d56:	e9 87 fb ff ff       	jmp    c01028e2 <__alltraps>

c0102d5b <vector125>:
.globl vector125
vector125:
  pushl $0
c0102d5b:	6a 00                	push   $0x0
  pushl $125
c0102d5d:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102d5f:	e9 7e fb ff ff       	jmp    c01028e2 <__alltraps>

c0102d64 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102d64:	6a 00                	push   $0x0
  pushl $126
c0102d66:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102d68:	e9 75 fb ff ff       	jmp    c01028e2 <__alltraps>

c0102d6d <vector127>:
.globl vector127
vector127:
  pushl $0
c0102d6d:	6a 00                	push   $0x0
  pushl $127
c0102d6f:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102d71:	e9 6c fb ff ff       	jmp    c01028e2 <__alltraps>

c0102d76 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102d76:	6a 00                	push   $0x0
  pushl $128
c0102d78:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102d7d:	e9 60 fb ff ff       	jmp    c01028e2 <__alltraps>

c0102d82 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102d82:	6a 00                	push   $0x0
  pushl $129
c0102d84:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102d89:	e9 54 fb ff ff       	jmp    c01028e2 <__alltraps>

c0102d8e <vector130>:
.globl vector130
vector130:
  pushl $0
c0102d8e:	6a 00                	push   $0x0
  pushl $130
c0102d90:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102d95:	e9 48 fb ff ff       	jmp    c01028e2 <__alltraps>

c0102d9a <vector131>:
.globl vector131
vector131:
  pushl $0
c0102d9a:	6a 00                	push   $0x0
  pushl $131
c0102d9c:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102da1:	e9 3c fb ff ff       	jmp    c01028e2 <__alltraps>

c0102da6 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102da6:	6a 00                	push   $0x0
  pushl $132
c0102da8:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102dad:	e9 30 fb ff ff       	jmp    c01028e2 <__alltraps>

c0102db2 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102db2:	6a 00                	push   $0x0
  pushl $133
c0102db4:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102db9:	e9 24 fb ff ff       	jmp    c01028e2 <__alltraps>

c0102dbe <vector134>:
.globl vector134
vector134:
  pushl $0
c0102dbe:	6a 00                	push   $0x0
  pushl $134
c0102dc0:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102dc5:	e9 18 fb ff ff       	jmp    c01028e2 <__alltraps>

c0102dca <vector135>:
.globl vector135
vector135:
  pushl $0
c0102dca:	6a 00                	push   $0x0
  pushl $135
c0102dcc:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102dd1:	e9 0c fb ff ff       	jmp    c01028e2 <__alltraps>

c0102dd6 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102dd6:	6a 00                	push   $0x0
  pushl $136
c0102dd8:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102ddd:	e9 00 fb ff ff       	jmp    c01028e2 <__alltraps>

c0102de2 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102de2:	6a 00                	push   $0x0
  pushl $137
c0102de4:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102de9:	e9 f4 fa ff ff       	jmp    c01028e2 <__alltraps>

c0102dee <vector138>:
.globl vector138
vector138:
  pushl $0
c0102dee:	6a 00                	push   $0x0
  pushl $138
c0102df0:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102df5:	e9 e8 fa ff ff       	jmp    c01028e2 <__alltraps>

c0102dfa <vector139>:
.globl vector139
vector139:
  pushl $0
c0102dfa:	6a 00                	push   $0x0
  pushl $139
c0102dfc:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102e01:	e9 dc fa ff ff       	jmp    c01028e2 <__alltraps>

c0102e06 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102e06:	6a 00                	push   $0x0
  pushl $140
c0102e08:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102e0d:	e9 d0 fa ff ff       	jmp    c01028e2 <__alltraps>

c0102e12 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102e12:	6a 00                	push   $0x0
  pushl $141
c0102e14:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102e19:	e9 c4 fa ff ff       	jmp    c01028e2 <__alltraps>

c0102e1e <vector142>:
.globl vector142
vector142:
  pushl $0
c0102e1e:	6a 00                	push   $0x0
  pushl $142
c0102e20:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102e25:	e9 b8 fa ff ff       	jmp    c01028e2 <__alltraps>

c0102e2a <vector143>:
.globl vector143
vector143:
  pushl $0
c0102e2a:	6a 00                	push   $0x0
  pushl $143
c0102e2c:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102e31:	e9 ac fa ff ff       	jmp    c01028e2 <__alltraps>

c0102e36 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102e36:	6a 00                	push   $0x0
  pushl $144
c0102e38:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102e3d:	e9 a0 fa ff ff       	jmp    c01028e2 <__alltraps>

c0102e42 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102e42:	6a 00                	push   $0x0
  pushl $145
c0102e44:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102e49:	e9 94 fa ff ff       	jmp    c01028e2 <__alltraps>

c0102e4e <vector146>:
.globl vector146
vector146:
  pushl $0
c0102e4e:	6a 00                	push   $0x0
  pushl $146
c0102e50:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102e55:	e9 88 fa ff ff       	jmp    c01028e2 <__alltraps>

c0102e5a <vector147>:
.globl vector147
vector147:
  pushl $0
c0102e5a:	6a 00                	push   $0x0
  pushl $147
c0102e5c:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102e61:	e9 7c fa ff ff       	jmp    c01028e2 <__alltraps>

c0102e66 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102e66:	6a 00                	push   $0x0
  pushl $148
c0102e68:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102e6d:	e9 70 fa ff ff       	jmp    c01028e2 <__alltraps>

c0102e72 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102e72:	6a 00                	push   $0x0
  pushl $149
c0102e74:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102e79:	e9 64 fa ff ff       	jmp    c01028e2 <__alltraps>

c0102e7e <vector150>:
.globl vector150
vector150:
  pushl $0
c0102e7e:	6a 00                	push   $0x0
  pushl $150
c0102e80:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102e85:	e9 58 fa ff ff       	jmp    c01028e2 <__alltraps>

c0102e8a <vector151>:
.globl vector151
vector151:
  pushl $0
c0102e8a:	6a 00                	push   $0x0
  pushl $151
c0102e8c:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102e91:	e9 4c fa ff ff       	jmp    c01028e2 <__alltraps>

c0102e96 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102e96:	6a 00                	push   $0x0
  pushl $152
c0102e98:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102e9d:	e9 40 fa ff ff       	jmp    c01028e2 <__alltraps>

c0102ea2 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102ea2:	6a 00                	push   $0x0
  pushl $153
c0102ea4:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102ea9:	e9 34 fa ff ff       	jmp    c01028e2 <__alltraps>

c0102eae <vector154>:
.globl vector154
vector154:
  pushl $0
c0102eae:	6a 00                	push   $0x0
  pushl $154
c0102eb0:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102eb5:	e9 28 fa ff ff       	jmp    c01028e2 <__alltraps>

c0102eba <vector155>:
.globl vector155
vector155:
  pushl $0
c0102eba:	6a 00                	push   $0x0
  pushl $155
c0102ebc:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102ec1:	e9 1c fa ff ff       	jmp    c01028e2 <__alltraps>

c0102ec6 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102ec6:	6a 00                	push   $0x0
  pushl $156
c0102ec8:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102ecd:	e9 10 fa ff ff       	jmp    c01028e2 <__alltraps>

c0102ed2 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102ed2:	6a 00                	push   $0x0
  pushl $157
c0102ed4:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102ed9:	e9 04 fa ff ff       	jmp    c01028e2 <__alltraps>

c0102ede <vector158>:
.globl vector158
vector158:
  pushl $0
c0102ede:	6a 00                	push   $0x0
  pushl $158
c0102ee0:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102ee5:	e9 f8 f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102eea <vector159>:
.globl vector159
vector159:
  pushl $0
c0102eea:	6a 00                	push   $0x0
  pushl $159
c0102eec:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102ef1:	e9 ec f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102ef6 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102ef6:	6a 00                	push   $0x0
  pushl $160
c0102ef8:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102efd:	e9 e0 f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102f02 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102f02:	6a 00                	push   $0x0
  pushl $161
c0102f04:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102f09:	e9 d4 f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102f0e <vector162>:
.globl vector162
vector162:
  pushl $0
c0102f0e:	6a 00                	push   $0x0
  pushl $162
c0102f10:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102f15:	e9 c8 f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102f1a <vector163>:
.globl vector163
vector163:
  pushl $0
c0102f1a:	6a 00                	push   $0x0
  pushl $163
c0102f1c:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102f21:	e9 bc f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102f26 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102f26:	6a 00                	push   $0x0
  pushl $164
c0102f28:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102f2d:	e9 b0 f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102f32 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102f32:	6a 00                	push   $0x0
  pushl $165
c0102f34:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102f39:	e9 a4 f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102f3e <vector166>:
.globl vector166
vector166:
  pushl $0
c0102f3e:	6a 00                	push   $0x0
  pushl $166
c0102f40:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102f45:	e9 98 f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102f4a <vector167>:
.globl vector167
vector167:
  pushl $0
c0102f4a:	6a 00                	push   $0x0
  pushl $167
c0102f4c:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102f51:	e9 8c f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102f56 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102f56:	6a 00                	push   $0x0
  pushl $168
c0102f58:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102f5d:	e9 80 f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102f62 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102f62:	6a 00                	push   $0x0
  pushl $169
c0102f64:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102f69:	e9 74 f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102f6e <vector170>:
.globl vector170
vector170:
  pushl $0
c0102f6e:	6a 00                	push   $0x0
  pushl $170
c0102f70:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102f75:	e9 68 f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102f7a <vector171>:
.globl vector171
vector171:
  pushl $0
c0102f7a:	6a 00                	push   $0x0
  pushl $171
c0102f7c:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102f81:	e9 5c f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102f86 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102f86:	6a 00                	push   $0x0
  pushl $172
c0102f88:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102f8d:	e9 50 f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102f92 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102f92:	6a 00                	push   $0x0
  pushl $173
c0102f94:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102f99:	e9 44 f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102f9e <vector174>:
.globl vector174
vector174:
  pushl $0
c0102f9e:	6a 00                	push   $0x0
  pushl $174
c0102fa0:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102fa5:	e9 38 f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102faa <vector175>:
.globl vector175
vector175:
  pushl $0
c0102faa:	6a 00                	push   $0x0
  pushl $175
c0102fac:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102fb1:	e9 2c f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102fb6 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102fb6:	6a 00                	push   $0x0
  pushl $176
c0102fb8:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102fbd:	e9 20 f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102fc2 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102fc2:	6a 00                	push   $0x0
  pushl $177
c0102fc4:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102fc9:	e9 14 f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102fce <vector178>:
.globl vector178
vector178:
  pushl $0
c0102fce:	6a 00                	push   $0x0
  pushl $178
c0102fd0:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102fd5:	e9 08 f9 ff ff       	jmp    c01028e2 <__alltraps>

c0102fda <vector179>:
.globl vector179
vector179:
  pushl $0
c0102fda:	6a 00                	push   $0x0
  pushl $179
c0102fdc:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102fe1:	e9 fc f8 ff ff       	jmp    c01028e2 <__alltraps>

c0102fe6 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102fe6:	6a 00                	push   $0x0
  pushl $180
c0102fe8:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102fed:	e9 f0 f8 ff ff       	jmp    c01028e2 <__alltraps>

c0102ff2 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102ff2:	6a 00                	push   $0x0
  pushl $181
c0102ff4:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102ff9:	e9 e4 f8 ff ff       	jmp    c01028e2 <__alltraps>

c0102ffe <vector182>:
.globl vector182
vector182:
  pushl $0
c0102ffe:	6a 00                	push   $0x0
  pushl $182
c0103000:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0103005:	e9 d8 f8 ff ff       	jmp    c01028e2 <__alltraps>

c010300a <vector183>:
.globl vector183
vector183:
  pushl $0
c010300a:	6a 00                	push   $0x0
  pushl $183
c010300c:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0103011:	e9 cc f8 ff ff       	jmp    c01028e2 <__alltraps>

c0103016 <vector184>:
.globl vector184
vector184:
  pushl $0
c0103016:	6a 00                	push   $0x0
  pushl $184
c0103018:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010301d:	e9 c0 f8 ff ff       	jmp    c01028e2 <__alltraps>

c0103022 <vector185>:
.globl vector185
vector185:
  pushl $0
c0103022:	6a 00                	push   $0x0
  pushl $185
c0103024:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0103029:	e9 b4 f8 ff ff       	jmp    c01028e2 <__alltraps>

c010302e <vector186>:
.globl vector186
vector186:
  pushl $0
c010302e:	6a 00                	push   $0x0
  pushl $186
c0103030:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0103035:	e9 a8 f8 ff ff       	jmp    c01028e2 <__alltraps>

c010303a <vector187>:
.globl vector187
vector187:
  pushl $0
c010303a:	6a 00                	push   $0x0
  pushl $187
c010303c:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0103041:	e9 9c f8 ff ff       	jmp    c01028e2 <__alltraps>

c0103046 <vector188>:
.globl vector188
vector188:
  pushl $0
c0103046:	6a 00                	push   $0x0
  pushl $188
c0103048:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010304d:	e9 90 f8 ff ff       	jmp    c01028e2 <__alltraps>

c0103052 <vector189>:
.globl vector189
vector189:
  pushl $0
c0103052:	6a 00                	push   $0x0
  pushl $189
c0103054:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0103059:	e9 84 f8 ff ff       	jmp    c01028e2 <__alltraps>

c010305e <vector190>:
.globl vector190
vector190:
  pushl $0
c010305e:	6a 00                	push   $0x0
  pushl $190
c0103060:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0103065:	e9 78 f8 ff ff       	jmp    c01028e2 <__alltraps>

c010306a <vector191>:
.globl vector191
vector191:
  pushl $0
c010306a:	6a 00                	push   $0x0
  pushl $191
c010306c:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0103071:	e9 6c f8 ff ff       	jmp    c01028e2 <__alltraps>

c0103076 <vector192>:
.globl vector192
vector192:
  pushl $0
c0103076:	6a 00                	push   $0x0
  pushl $192
c0103078:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010307d:	e9 60 f8 ff ff       	jmp    c01028e2 <__alltraps>

c0103082 <vector193>:
.globl vector193
vector193:
  pushl $0
c0103082:	6a 00                	push   $0x0
  pushl $193
c0103084:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0103089:	e9 54 f8 ff ff       	jmp    c01028e2 <__alltraps>

c010308e <vector194>:
.globl vector194
vector194:
  pushl $0
c010308e:	6a 00                	push   $0x0
  pushl $194
c0103090:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0103095:	e9 48 f8 ff ff       	jmp    c01028e2 <__alltraps>

c010309a <vector195>:
.globl vector195
vector195:
  pushl $0
c010309a:	6a 00                	push   $0x0
  pushl $195
c010309c:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01030a1:	e9 3c f8 ff ff       	jmp    c01028e2 <__alltraps>

c01030a6 <vector196>:
.globl vector196
vector196:
  pushl $0
c01030a6:	6a 00                	push   $0x0
  pushl $196
c01030a8:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01030ad:	e9 30 f8 ff ff       	jmp    c01028e2 <__alltraps>

c01030b2 <vector197>:
.globl vector197
vector197:
  pushl $0
c01030b2:	6a 00                	push   $0x0
  pushl $197
c01030b4:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01030b9:	e9 24 f8 ff ff       	jmp    c01028e2 <__alltraps>

c01030be <vector198>:
.globl vector198
vector198:
  pushl $0
c01030be:	6a 00                	push   $0x0
  pushl $198
c01030c0:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01030c5:	e9 18 f8 ff ff       	jmp    c01028e2 <__alltraps>

c01030ca <vector199>:
.globl vector199
vector199:
  pushl $0
c01030ca:	6a 00                	push   $0x0
  pushl $199
c01030cc:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01030d1:	e9 0c f8 ff ff       	jmp    c01028e2 <__alltraps>

c01030d6 <vector200>:
.globl vector200
vector200:
  pushl $0
c01030d6:	6a 00                	push   $0x0
  pushl $200
c01030d8:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01030dd:	e9 00 f8 ff ff       	jmp    c01028e2 <__alltraps>

c01030e2 <vector201>:
.globl vector201
vector201:
  pushl $0
c01030e2:	6a 00                	push   $0x0
  pushl $201
c01030e4:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01030e9:	e9 f4 f7 ff ff       	jmp    c01028e2 <__alltraps>

c01030ee <vector202>:
.globl vector202
vector202:
  pushl $0
c01030ee:	6a 00                	push   $0x0
  pushl $202
c01030f0:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01030f5:	e9 e8 f7 ff ff       	jmp    c01028e2 <__alltraps>

c01030fa <vector203>:
.globl vector203
vector203:
  pushl $0
c01030fa:	6a 00                	push   $0x0
  pushl $203
c01030fc:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0103101:	e9 dc f7 ff ff       	jmp    c01028e2 <__alltraps>

c0103106 <vector204>:
.globl vector204
vector204:
  pushl $0
c0103106:	6a 00                	push   $0x0
  pushl $204
c0103108:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010310d:	e9 d0 f7 ff ff       	jmp    c01028e2 <__alltraps>

c0103112 <vector205>:
.globl vector205
vector205:
  pushl $0
c0103112:	6a 00                	push   $0x0
  pushl $205
c0103114:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0103119:	e9 c4 f7 ff ff       	jmp    c01028e2 <__alltraps>

c010311e <vector206>:
.globl vector206
vector206:
  pushl $0
c010311e:	6a 00                	push   $0x0
  pushl $206
c0103120:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0103125:	e9 b8 f7 ff ff       	jmp    c01028e2 <__alltraps>

c010312a <vector207>:
.globl vector207
vector207:
  pushl $0
c010312a:	6a 00                	push   $0x0
  pushl $207
c010312c:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0103131:	e9 ac f7 ff ff       	jmp    c01028e2 <__alltraps>

c0103136 <vector208>:
.globl vector208
vector208:
  pushl $0
c0103136:	6a 00                	push   $0x0
  pushl $208
c0103138:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010313d:	e9 a0 f7 ff ff       	jmp    c01028e2 <__alltraps>

c0103142 <vector209>:
.globl vector209
vector209:
  pushl $0
c0103142:	6a 00                	push   $0x0
  pushl $209
c0103144:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0103149:	e9 94 f7 ff ff       	jmp    c01028e2 <__alltraps>

c010314e <vector210>:
.globl vector210
vector210:
  pushl $0
c010314e:	6a 00                	push   $0x0
  pushl $210
c0103150:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0103155:	e9 88 f7 ff ff       	jmp    c01028e2 <__alltraps>

c010315a <vector211>:
.globl vector211
vector211:
  pushl $0
c010315a:	6a 00                	push   $0x0
  pushl $211
c010315c:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0103161:	e9 7c f7 ff ff       	jmp    c01028e2 <__alltraps>

c0103166 <vector212>:
.globl vector212
vector212:
  pushl $0
c0103166:	6a 00                	push   $0x0
  pushl $212
c0103168:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010316d:	e9 70 f7 ff ff       	jmp    c01028e2 <__alltraps>

c0103172 <vector213>:
.globl vector213
vector213:
  pushl $0
c0103172:	6a 00                	push   $0x0
  pushl $213
c0103174:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0103179:	e9 64 f7 ff ff       	jmp    c01028e2 <__alltraps>

c010317e <vector214>:
.globl vector214
vector214:
  pushl $0
c010317e:	6a 00                	push   $0x0
  pushl $214
c0103180:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0103185:	e9 58 f7 ff ff       	jmp    c01028e2 <__alltraps>

c010318a <vector215>:
.globl vector215
vector215:
  pushl $0
c010318a:	6a 00                	push   $0x0
  pushl $215
c010318c:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0103191:	e9 4c f7 ff ff       	jmp    c01028e2 <__alltraps>

c0103196 <vector216>:
.globl vector216
vector216:
  pushl $0
c0103196:	6a 00                	push   $0x0
  pushl $216
c0103198:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010319d:	e9 40 f7 ff ff       	jmp    c01028e2 <__alltraps>

c01031a2 <vector217>:
.globl vector217
vector217:
  pushl $0
c01031a2:	6a 00                	push   $0x0
  pushl $217
c01031a4:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01031a9:	e9 34 f7 ff ff       	jmp    c01028e2 <__alltraps>

c01031ae <vector218>:
.globl vector218
vector218:
  pushl $0
c01031ae:	6a 00                	push   $0x0
  pushl $218
c01031b0:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01031b5:	e9 28 f7 ff ff       	jmp    c01028e2 <__alltraps>

c01031ba <vector219>:
.globl vector219
vector219:
  pushl $0
c01031ba:	6a 00                	push   $0x0
  pushl $219
c01031bc:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01031c1:	e9 1c f7 ff ff       	jmp    c01028e2 <__alltraps>

c01031c6 <vector220>:
.globl vector220
vector220:
  pushl $0
c01031c6:	6a 00                	push   $0x0
  pushl $220
c01031c8:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01031cd:	e9 10 f7 ff ff       	jmp    c01028e2 <__alltraps>

c01031d2 <vector221>:
.globl vector221
vector221:
  pushl $0
c01031d2:	6a 00                	push   $0x0
  pushl $221
c01031d4:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01031d9:	e9 04 f7 ff ff       	jmp    c01028e2 <__alltraps>

c01031de <vector222>:
.globl vector222
vector222:
  pushl $0
c01031de:	6a 00                	push   $0x0
  pushl $222
c01031e0:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01031e5:	e9 f8 f6 ff ff       	jmp    c01028e2 <__alltraps>

c01031ea <vector223>:
.globl vector223
vector223:
  pushl $0
c01031ea:	6a 00                	push   $0x0
  pushl $223
c01031ec:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01031f1:	e9 ec f6 ff ff       	jmp    c01028e2 <__alltraps>

c01031f6 <vector224>:
.globl vector224
vector224:
  pushl $0
c01031f6:	6a 00                	push   $0x0
  pushl $224
c01031f8:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01031fd:	e9 e0 f6 ff ff       	jmp    c01028e2 <__alltraps>

c0103202 <vector225>:
.globl vector225
vector225:
  pushl $0
c0103202:	6a 00                	push   $0x0
  pushl $225
c0103204:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0103209:	e9 d4 f6 ff ff       	jmp    c01028e2 <__alltraps>

c010320e <vector226>:
.globl vector226
vector226:
  pushl $0
c010320e:	6a 00                	push   $0x0
  pushl $226
c0103210:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0103215:	e9 c8 f6 ff ff       	jmp    c01028e2 <__alltraps>

c010321a <vector227>:
.globl vector227
vector227:
  pushl $0
c010321a:	6a 00                	push   $0x0
  pushl $227
c010321c:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0103221:	e9 bc f6 ff ff       	jmp    c01028e2 <__alltraps>

c0103226 <vector228>:
.globl vector228
vector228:
  pushl $0
c0103226:	6a 00                	push   $0x0
  pushl $228
c0103228:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010322d:	e9 b0 f6 ff ff       	jmp    c01028e2 <__alltraps>

c0103232 <vector229>:
.globl vector229
vector229:
  pushl $0
c0103232:	6a 00                	push   $0x0
  pushl $229
c0103234:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0103239:	e9 a4 f6 ff ff       	jmp    c01028e2 <__alltraps>

c010323e <vector230>:
.globl vector230
vector230:
  pushl $0
c010323e:	6a 00                	push   $0x0
  pushl $230
c0103240:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0103245:	e9 98 f6 ff ff       	jmp    c01028e2 <__alltraps>

c010324a <vector231>:
.globl vector231
vector231:
  pushl $0
c010324a:	6a 00                	push   $0x0
  pushl $231
c010324c:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0103251:	e9 8c f6 ff ff       	jmp    c01028e2 <__alltraps>

c0103256 <vector232>:
.globl vector232
vector232:
  pushl $0
c0103256:	6a 00                	push   $0x0
  pushl $232
c0103258:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010325d:	e9 80 f6 ff ff       	jmp    c01028e2 <__alltraps>

c0103262 <vector233>:
.globl vector233
vector233:
  pushl $0
c0103262:	6a 00                	push   $0x0
  pushl $233
c0103264:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0103269:	e9 74 f6 ff ff       	jmp    c01028e2 <__alltraps>

c010326e <vector234>:
.globl vector234
vector234:
  pushl $0
c010326e:	6a 00                	push   $0x0
  pushl $234
c0103270:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0103275:	e9 68 f6 ff ff       	jmp    c01028e2 <__alltraps>

c010327a <vector235>:
.globl vector235
vector235:
  pushl $0
c010327a:	6a 00                	push   $0x0
  pushl $235
c010327c:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0103281:	e9 5c f6 ff ff       	jmp    c01028e2 <__alltraps>

c0103286 <vector236>:
.globl vector236
vector236:
  pushl $0
c0103286:	6a 00                	push   $0x0
  pushl $236
c0103288:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010328d:	e9 50 f6 ff ff       	jmp    c01028e2 <__alltraps>

c0103292 <vector237>:
.globl vector237
vector237:
  pushl $0
c0103292:	6a 00                	push   $0x0
  pushl $237
c0103294:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0103299:	e9 44 f6 ff ff       	jmp    c01028e2 <__alltraps>

c010329e <vector238>:
.globl vector238
vector238:
  pushl $0
c010329e:	6a 00                	push   $0x0
  pushl $238
c01032a0:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01032a5:	e9 38 f6 ff ff       	jmp    c01028e2 <__alltraps>

c01032aa <vector239>:
.globl vector239
vector239:
  pushl $0
c01032aa:	6a 00                	push   $0x0
  pushl $239
c01032ac:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01032b1:	e9 2c f6 ff ff       	jmp    c01028e2 <__alltraps>

c01032b6 <vector240>:
.globl vector240
vector240:
  pushl $0
c01032b6:	6a 00                	push   $0x0
  pushl $240
c01032b8:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01032bd:	e9 20 f6 ff ff       	jmp    c01028e2 <__alltraps>

c01032c2 <vector241>:
.globl vector241
vector241:
  pushl $0
c01032c2:	6a 00                	push   $0x0
  pushl $241
c01032c4:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01032c9:	e9 14 f6 ff ff       	jmp    c01028e2 <__alltraps>

c01032ce <vector242>:
.globl vector242
vector242:
  pushl $0
c01032ce:	6a 00                	push   $0x0
  pushl $242
c01032d0:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01032d5:	e9 08 f6 ff ff       	jmp    c01028e2 <__alltraps>

c01032da <vector243>:
.globl vector243
vector243:
  pushl $0
c01032da:	6a 00                	push   $0x0
  pushl $243
c01032dc:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01032e1:	e9 fc f5 ff ff       	jmp    c01028e2 <__alltraps>

c01032e6 <vector244>:
.globl vector244
vector244:
  pushl $0
c01032e6:	6a 00                	push   $0x0
  pushl $244
c01032e8:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01032ed:	e9 f0 f5 ff ff       	jmp    c01028e2 <__alltraps>

c01032f2 <vector245>:
.globl vector245
vector245:
  pushl $0
c01032f2:	6a 00                	push   $0x0
  pushl $245
c01032f4:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01032f9:	e9 e4 f5 ff ff       	jmp    c01028e2 <__alltraps>

c01032fe <vector246>:
.globl vector246
vector246:
  pushl $0
c01032fe:	6a 00                	push   $0x0
  pushl $246
c0103300:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0103305:	e9 d8 f5 ff ff       	jmp    c01028e2 <__alltraps>

c010330a <vector247>:
.globl vector247
vector247:
  pushl $0
c010330a:	6a 00                	push   $0x0
  pushl $247
c010330c:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0103311:	e9 cc f5 ff ff       	jmp    c01028e2 <__alltraps>

c0103316 <vector248>:
.globl vector248
vector248:
  pushl $0
c0103316:	6a 00                	push   $0x0
  pushl $248
c0103318:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010331d:	e9 c0 f5 ff ff       	jmp    c01028e2 <__alltraps>

c0103322 <vector249>:
.globl vector249
vector249:
  pushl $0
c0103322:	6a 00                	push   $0x0
  pushl $249
c0103324:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0103329:	e9 b4 f5 ff ff       	jmp    c01028e2 <__alltraps>

c010332e <vector250>:
.globl vector250
vector250:
  pushl $0
c010332e:	6a 00                	push   $0x0
  pushl $250
c0103330:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0103335:	e9 a8 f5 ff ff       	jmp    c01028e2 <__alltraps>

c010333a <vector251>:
.globl vector251
vector251:
  pushl $0
c010333a:	6a 00                	push   $0x0
  pushl $251
c010333c:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0103341:	e9 9c f5 ff ff       	jmp    c01028e2 <__alltraps>

c0103346 <vector252>:
.globl vector252
vector252:
  pushl $0
c0103346:	6a 00                	push   $0x0
  pushl $252
c0103348:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c010334d:	e9 90 f5 ff ff       	jmp    c01028e2 <__alltraps>

c0103352 <vector253>:
.globl vector253
vector253:
  pushl $0
c0103352:	6a 00                	push   $0x0
  pushl $253
c0103354:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0103359:	e9 84 f5 ff ff       	jmp    c01028e2 <__alltraps>

c010335e <vector254>:
.globl vector254
vector254:
  pushl $0
c010335e:	6a 00                	push   $0x0
  pushl $254
c0103360:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0103365:	e9 78 f5 ff ff       	jmp    c01028e2 <__alltraps>

c010336a <vector255>:
.globl vector255
vector255:
  pushl $0
c010336a:	6a 00                	push   $0x0
  pushl $255
c010336c:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0103371:	e9 6c f5 ff ff       	jmp    c01028e2 <__alltraps>

c0103376 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103376:	55                   	push   %ebp
c0103377:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103379:	8b 15 a0 6f 12 c0    	mov    0xc0126fa0,%edx
c010337f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103382:	29 d0                	sub    %edx,%eax
c0103384:	c1 f8 05             	sar    $0x5,%eax
}
c0103387:	5d                   	pop    %ebp
c0103388:	c3                   	ret    

c0103389 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103389:	55                   	push   %ebp
c010338a:	89 e5                	mov    %esp,%ebp
c010338c:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010338f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103392:	89 04 24             	mov    %eax,(%esp)
c0103395:	e8 dc ff ff ff       	call   c0103376 <page2ppn>
c010339a:	c1 e0 0c             	shl    $0xc,%eax
}
c010339d:	89 ec                	mov    %ebp,%esp
c010339f:	5d                   	pop    %ebp
c01033a0:	c3                   	ret    

c01033a1 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01033a1:	55                   	push   %ebp
c01033a2:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01033a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01033a7:	8b 00                	mov    (%eax),%eax
}
c01033a9:	5d                   	pop    %ebp
c01033aa:	c3                   	ret    

c01033ab <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01033ab:	55                   	push   %ebp
c01033ac:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01033ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01033b1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01033b4:	89 10                	mov    %edx,(%eax)
}
c01033b6:	90                   	nop
c01033b7:	5d                   	pop    %ebp
c01033b8:	c3                   	ret    

c01033b9 <default_init>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

// 初始化空闲内存*块*链表
static void
default_init(void) {
c01033b9:	55                   	push   %ebp
c01033ba:	89 e5                	mov    %esp,%ebp
c01033bc:	83 ec 10             	sub    $0x10,%esp
c01033bf:	c7 45 fc 84 6f 12 c0 	movl   $0xc0126f84,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01033c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01033c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01033cc:	89 50 04             	mov    %edx,0x4(%eax)
c01033cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01033d2:	8b 50 04             	mov    0x4(%eax),%edx
c01033d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01033d8:	89 10                	mov    %edx,(%eax)
}
c01033da:	90                   	nop
    // 对空闲内存块链表初始化
    list_init(&free_list);
    // 将总空闲数目置零
    nr_free = 0;
c01033db:	c7 05 8c 6f 12 c0 00 	movl   $0x0,0xc0126f8c
c01033e2:	00 00 00 
}
c01033e5:	90                   	nop
c01033e6:	89 ec                	mov    %ebp,%esp
c01033e8:	5d                   	pop    %ebp
c01033e9:	c3                   	ret    

c01033ea <default_init_memmap>:

// 初始化*块*, 对其每一*页*进行初始化
static void
default_init_memmap(struct Page *base, size_t n) {
c01033ea:	55                   	push   %ebp
c01033eb:	89 e5                	mov    %esp,%ebp
c01033ed:	83 ec 48             	sub    $0x48,%esp
    // 检查: 参数合法性
    assert(n > 0);
c01033f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01033f4:	75 24                	jne    c010341a <default_init_memmap+0x30>
c01033f6:	c7 44 24 0c d0 97 10 	movl   $0xc01097d0,0xc(%esp)
c01033fd:	c0 
c01033fe:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103405:	c0 
c0103406:	c7 44 24 04 72 00 00 	movl   $0x72,0x4(%esp)
c010340d:	00 
c010340e:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103415:	e8 d7 d8 ff ff       	call   c0100cf1 <__panic>
    // 初始化: 所有*页*
    // 遍历所有*页*
    struct Page *p = base;
c010341a:	8b 45 08             	mov    0x8(%ebp),%eax
c010341d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0103420:	e9 95 00 00 00       	jmp    c01034ba <default_init_memmap+0xd0>
        // 检查当前页是否是保留的
        assert(PageReserved(p));
c0103425:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103428:	83 c0 04             	add    $0x4,%eax
c010342b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103432:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103435:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103438:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010343b:	0f a3 10             	bt     %edx,(%eax)
c010343e:	19 c0                	sbb    %eax,%eax
c0103440:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0103443:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103447:	0f 95 c0             	setne  %al
c010344a:	0f b6 c0             	movzbl %al,%eax
c010344d:	85 c0                	test   %eax,%eax
c010344f:	75 24                	jne    c0103475 <default_init_memmap+0x8b>
c0103451:	c7 44 24 0c 01 98 10 	movl   $0xc0109801,0xc(%esp)
c0103458:	c0 
c0103459:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103460:	c0 
c0103461:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
c0103468:	00 
c0103469:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103470:	e8 7c d8 ff ff       	call   c0100cf1 <__panic>
        // 标记位清空
        p->flags = 0;
c0103475:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103478:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        // 空闲块数置零(即无效)
        p->property = 0;
c010347f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103482:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        // 清空引用计数
        set_page_ref(p, 0);
c0103489:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103490:	00 
c0103491:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103494:	89 04 24             	mov    %eax,(%esp)
c0103497:	e8 0f ff ff ff       	call   c01033ab <set_page_ref>
        // 启用property属性(即, 将页设为空闲)
        SetPageProperty(p);
c010349c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010349f:	83 c0 04             	add    $0x4,%eax
c01034a2:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01034a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01034ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01034af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01034b2:	0f ab 10             	bts    %edx,(%eax)
}
c01034b5:	90                   	nop
    for (; p != base + n; p ++) {
c01034b6:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01034ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034bd:	c1 e0 05             	shl    $0x5,%eax
c01034c0:	89 c2                	mov    %eax,%edx
c01034c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01034c5:	01 d0                	add    %edx,%eax
c01034c7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01034ca:	0f 85 55 ff ff ff    	jne    c0103425 <default_init_memmap+0x3b>
    }
    // 初始化: 第一*页*
    // 当前块的空闲页数置为n(即, 设置当前块的大小为n, 单位为页)
    base->property = n;
c01034d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01034d3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01034d6:	89 50 08             	mov    %edx,0x8(%eax)
    // 更新总空页数
    nr_free += n;
c01034d9:	8b 15 8c 6f 12 c0    	mov    0xc0126f8c,%edx
c01034df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034e2:	01 d0                	add    %edx,%eax
c01034e4:	a3 8c 6f 12 c0       	mov    %eax,0xc0126f8c
    // 将这个空闲*块*插入到空闲内存*块*链表的最后
    list_add_before(&free_list, &(base->page_link));
c01034e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01034ec:	83 c0 0c             	add    $0xc,%eax
c01034ef:	c7 45 dc 84 6f 12 c0 	movl   $0xc0126f84,-0x24(%ebp)
c01034f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01034f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01034fc:	8b 00                	mov    (%eax),%eax
c01034fe:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103501:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103504:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103507:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010350a:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010350d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103510:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103513:	89 10                	mov    %edx,(%eax)
c0103515:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103518:	8b 10                	mov    (%eax),%edx
c010351a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010351d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103520:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103523:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103526:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103529:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010352c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010352f:	89 10                	mov    %edx,(%eax)
}
c0103531:	90                   	nop
}
c0103532:	90                   	nop
}
c0103533:	90                   	nop
c0103534:	89 ec                	mov    %ebp,%esp
c0103536:	5d                   	pop    %ebp
c0103537:	c3                   	ret    

c0103538 <default_alloc_pages>:

// 分配指定页数的连续空闲物理空间, 并且返回分配到的首页指针
static struct Page *
default_alloc_pages(size_t n) {
c0103538:	55                   	push   %ebp
c0103539:	89 e5                	mov    %esp,%ebp
c010353b:	83 ec 68             	sub    $0x68,%esp
    // 检查: 参数合法性
    assert(n > 0);
c010353e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103542:	75 24                	jne    c0103568 <default_alloc_pages+0x30>
c0103544:	c7 44 24 0c d0 97 10 	movl   $0xc01097d0,0xc(%esp)
c010354b:	c0 
c010354c:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103553:	c0 
c0103554:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
c010355b:	00 
c010355c:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103563:	e8 89 d7 ff ff       	call   c0100cf1 <__panic>
    // 检查: 总的空闲物理页数目是否足够, 不够则返回NULL(分配失败)
    if (n > nr_free) {
c0103568:	a1 8c 6f 12 c0       	mov    0xc0126f8c,%eax
c010356d:	39 45 08             	cmp    %eax,0x8(%ebp)
c0103570:	76 0a                	jbe    c010357c <default_alloc_pages+0x44>
        return NULL;
c0103572:	b8 00 00 00 00       	mov    $0x0,%eax
c0103577:	e9 4f 01 00 00       	jmp    c01036cb <default_alloc_pages+0x193>
    }
    // 查找: 符合的块
    struct Page *page = NULL;
c010357c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103583:	c7 45 e0 84 6f 12 c0 	movl   $0xc0126f84,-0x20(%ebp)
    return listelm->next;
c010358a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010358d:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0103590:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 按照物理地址的从小到大顺序遍历空闲内存*块*链表
    while (le != &free_list) {
c0103593:	eb 2b                	jmp    c01035c0 <default_alloc_pages+0x88>
        struct Page *p = le2page(le, page_link);
c0103595:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103598:	83 e8 0c             	sub    $0xc,%eax
c010359b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        // 如果找到第一个不小于需要的大小连续内存块, 则成功分配
        if (p->property >= n) {
c010359e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035a1:	8b 40 08             	mov    0x8(%eax),%eax
c01035a4:	39 45 08             	cmp    %eax,0x8(%ebp)
c01035a7:	77 08                	ja     c01035b1 <default_alloc_pages+0x79>
            page = p;
c01035a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c01035af:	eb 18                	jmp    c01035c9 <default_alloc_pages+0x91>
c01035b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01035b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01035ba:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le = list_next(le);
c01035bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01035c0:	81 7d f0 84 6f 12 c0 	cmpl   $0xc0126f84,-0x10(%ebp)
c01035c7:	75 cc                	jne    c0103595 <default_alloc_pages+0x5d>
    }
    // 处理:
    if (page != NULL) {
c01035c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01035cd:	0f 84 f5 00 00 00    	je     c01036c8 <default_alloc_pages+0x190>
        // 该内存块的大小大于需要的内存大小, 将空闲内存块分裂成两块
        if (page->property > n) {
c01035d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035d6:	8b 40 08             	mov    0x8(%eax),%eax
c01035d9:	39 45 08             	cmp    %eax,0x8(%ebp)
c01035dc:	73 6e                	jae    c010364c <default_alloc_pages+0x114>
            // 放回 物理地址较大的块
            struct Page *p = page + n;
c01035de:	8b 45 08             	mov    0x8(%ebp),%eax
c01035e1:	c1 e0 05             	shl    $0x5,%eax
c01035e4:	89 c2                	mov    %eax,%edx
c01035e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035e9:	01 d0                	add    %edx,%eax
c01035eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            // 重新进行初始化
            p->property = page->property - n;
c01035ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035f1:	8b 40 08             	mov    0x8(%eax),%eax
c01035f4:	2b 45 08             	sub    0x8(%ebp),%eax
c01035f7:	89 c2                	mov    %eax,%edx
c01035f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035fc:	89 50 08             	mov    %edx,0x8(%eax)
            // 插入到原块之后
            list_add_after(&(page->page_link), &(p->page_link));
c01035ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103602:	83 c0 0c             	add    $0xc,%eax
c0103605:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103608:	83 c2 0c             	add    $0xc,%edx
c010360b:	89 55 d8             	mov    %edx,-0x28(%ebp)
c010360e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c0103611:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103614:	8b 40 04             	mov    0x4(%eax),%eax
c0103617:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010361a:	89 55 d0             	mov    %edx,-0x30(%ebp)
c010361d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103620:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0103623:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c0103626:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103629:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010362c:	89 10                	mov    %edx,(%eax)
c010362e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103631:	8b 10                	mov    (%eax),%edx
c0103633:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103636:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103639:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010363c:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010363f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103642:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103645:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103648:	89 10                	mov    %edx,(%eax)
}
c010364a:	90                   	nop
}
c010364b:	90                   	nop
        }
        // 取用 取到的块 或 分裂出来物理地址较小的块
        // 设为非空闲
        for (struct Page *p = page; p != page + n; p++) {
c010364c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010364f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103652:	eb 1e                	jmp    c0103672 <default_alloc_pages+0x13a>
            ClearPageProperty(p);
c0103654:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103657:	83 c0 04             	add    $0x4,%eax
c010365a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0103661:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103664:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103667:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010366a:	0f b3 10             	btr    %edx,(%eax)
}
c010366d:	90                   	nop
        for (struct Page *p = page; p != page + n; p++) {
c010366e:	83 45 ec 20          	addl   $0x20,-0x14(%ebp)
c0103672:	8b 45 08             	mov    0x8(%ebp),%eax
c0103675:	c1 e0 05             	shl    $0x5,%eax
c0103678:	89 c2                	mov    %eax,%edx
c010367a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010367d:	01 d0                	add    %edx,%eax
c010367f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103682:	75 d0                	jne    c0103654 <default_alloc_pages+0x11c>
        }
        // 从链表中取出
        list_del(&(page->page_link));
c0103684:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103687:	83 c0 0c             	add    $0xc,%eax
c010368a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c010368d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103690:	8b 40 04             	mov    0x4(%eax),%eax
c0103693:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103696:	8b 12                	mov    (%edx),%edx
c0103698:	89 55 b8             	mov    %edx,-0x48(%ebp)
c010369b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010369e:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01036a1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01036a4:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01036a7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01036aa:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01036ad:	89 10                	mov    %edx,(%eax)
}
c01036af:	90                   	nop
}
c01036b0:	90                   	nop
        page->property = 0;
c01036b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036b4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        // 更新总空页数
        nr_free -= n;
c01036bb:	a1 8c 6f 12 c0       	mov    0xc0126f8c,%eax
c01036c0:	2b 45 08             	sub    0x8(%ebp),%eax
c01036c3:	a3 8c 6f 12 c0       	mov    %eax,0xc0126f8c
    }
    //返回: 分配到的页指针
    return page;
c01036c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01036cb:	89 ec                	mov    %ebp,%esp
c01036cd:	5d                   	pop    %ebp
c01036ce:	c3                   	ret    

c01036cf <default_free_pages>:

// 释放指定的某一物理页开始的若干个连续物理页，并完成first-fit算法中需要信息的维护
static void
default_free_pages(struct Page *base, size_t n) {
c01036cf:	55                   	push   %ebp
c01036d0:	89 e5                	mov    %esp,%ebp
c01036d2:	81 ec 98 00 00 00    	sub    $0x98,%esp
    // 检查: 参数合法性
    assert(n > 0);
c01036d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01036dc:	75 24                	jne    c0103702 <default_free_pages+0x33>
c01036de:	c7 44 24 0c d0 97 10 	movl   $0xc01097d0,0xc(%esp)
c01036e5:	c0 
c01036e6:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c01036ed:	c0 
c01036ee:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c01036f5:	00 
c01036f6:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c01036fd:	e8 ef d5 ff ff       	call   c0100cf1 <__panic>
    // 检查: 所有页 是否是保留的 或 原本就是空闲的
    struct Page *p = base, *p_next = NULL;
c0103702:	8b 45 08             	mov    0x8(%ebp),%eax
c0103705:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103708:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (; p != base + n; p++) {
c010370f:	e9 c1 00 00 00       	jmp    c01037d5 <default_free_pages+0x106>
        assert(!PageReserved(p) && !PageProperty(p));
c0103714:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103717:	83 c0 04             	add    $0x4,%eax
c010371a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0103721:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103724:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103727:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010372a:	0f a3 10             	bt     %edx,(%eax)
c010372d:	19 c0                	sbb    %eax,%eax
c010372f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c0103732:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103736:	0f 95 c0             	setne  %al
c0103739:	0f b6 c0             	movzbl %al,%eax
c010373c:	85 c0                	test   %eax,%eax
c010373e:	75 2c                	jne    c010376c <default_free_pages+0x9d>
c0103740:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103743:	83 c0 04             	add    $0x4,%eax
c0103746:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c010374d:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103750:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103753:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103756:	0f a3 10             	bt     %edx,(%eax)
c0103759:	19 c0                	sbb    %eax,%eax
c010375b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
c010375e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0103762:	0f 95 c0             	setne  %al
c0103765:	0f b6 c0             	movzbl %al,%eax
c0103768:	85 c0                	test   %eax,%eax
c010376a:	74 24                	je     c0103790 <default_free_pages+0xc1>
c010376c:	c7 44 24 0c 14 98 10 	movl   $0xc0109814,0xc(%esp)
c0103773:	c0 
c0103774:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c010377b:	c0 
c010377c:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0103783:	00 
c0103784:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c010378b:	e8 61 d5 ff ff       	call   c0100cf1 <__panic>
        // 清空标志位
        p->flags = 0;
c0103790:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103793:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        // 恢复为空闲状态
        SetPageProperty(p);
c010379a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010379d:	83 c0 04             	add    $0x4,%eax
c01037a0:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01037a7:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01037aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01037ad:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01037b0:	0f ab 10             	bts    %edx,(%eax)
}
c01037b3:	90                   	nop
        // 清空引用计数
        set_page_ref(p, 0);
c01037b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01037bb:	00 
c01037bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037bf:	89 04 24             	mov    %eax,(%esp)
c01037c2:	e8 e4 fb ff ff       	call   c01033ab <set_page_ref>
        p->property = 0;
c01037c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037ca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    for (; p != base + n; p++) {
c01037d1:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01037d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037d8:	c1 e0 05             	shl    $0x5,%eax
c01037db:	89 c2                	mov    %eax,%edx
c01037dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01037e0:	01 d0                	add    %edx,%eax
c01037e2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01037e5:	0f 85 29 ff ff ff    	jne    c0103714 <default_free_pages+0x45>
    }
    // 恢复:
    // 标记该空闲块大小
    base->property = n;
c01037eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01037ee:	8b 55 0c             	mov    0xc(%ebp),%edx
c01037f1:	89 50 08             	mov    %edx,0x8(%eax)
c01037f4:	c7 45 c8 84 6f 12 c0 	movl   $0xc0126f84,-0x38(%ebp)
    return listelm->next;
c01037fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01037fe:	8b 40 04             	mov    0x4(%eax),%eax
    // 顺序遍历. 找到恰好大于该块位置的空块
    list_entry_t *le = list_next(&free_list);
c0103801:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(le != &free_list && le < &(base->page_link)){
c0103804:	eb 0f                	jmp    c0103815 <default_free_pages+0x146>
c0103806:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103809:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010380c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010380f:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0103812:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(le != &free_list && le < &(base->page_link)){
c0103815:	81 7d f0 84 6f 12 c0 	cmpl   $0xc0126f84,-0x10(%ebp)
c010381c:	74 0b                	je     c0103829 <default_free_pages+0x15a>
c010381e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103821:	83 c0 0c             	add    $0xc,%eax
c0103824:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103827:	72 dd                	jb     c0103806 <default_free_pages+0x137>
    }
    // 插入到块链表中
    list_add_before(le,&(base->page_link));
c0103829:	8b 45 08             	mov    0x8(%ebp),%eax
c010382c:	8d 50 0c             	lea    0xc(%eax),%edx
c010382f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103832:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0103835:	89 55 b8             	mov    %edx,-0x48(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0103838:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010383b:	8b 00                	mov    (%eax),%eax
c010383d:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0103840:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c0103843:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103846:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103849:	89 45 ac             	mov    %eax,-0x54(%ebp)
    prev->next = next->prev = elm;
c010384c:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010384f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103852:	89 10                	mov    %edx,(%eax)
c0103854:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103857:	8b 10                	mov    (%eax),%edx
c0103859:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010385c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010385f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103862:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103865:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103868:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010386b:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010386e:	89 10                	mov    %edx,(%eax)
}
c0103870:	90                   	nop
}
c0103871:	90                   	nop
    // 更新总空页数
    nr_free += n;
c0103872:	8b 15 8c 6f 12 c0    	mov    0xc0126f8c,%edx
c0103878:	8b 45 0c             	mov    0xc(%ebp),%eax
c010387b:	01 d0                	add    %edx,%eax
c010387d:	a3 8c 6f 12 c0       	mov    %eax,0xc0126f8c
    // 合并:
    // 不是最后一个块, 向后合并
    for(le = list_next(&(base->page_link));
c0103882:	8b 45 08             	mov    0x8(%ebp),%eax
c0103885:	83 c0 0c             	add    $0xc,%eax
c0103888:	89 45 c0             	mov    %eax,-0x40(%ebp)
    return listelm->next;
c010388b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010388e:	8b 40 04             	mov    0x4(%eax),%eax
c0103891:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103894:	eb 78                	jmp    c010390e <default_free_pages+0x23f>
        le != &free_list;
        le = list_next(&(base->page_link))){
        p = le2page(le, page_link);
c0103896:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103899:	83 e8 0c             	sub    $0xc,%eax
c010389c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // 后一个空闲块 不相邻就退出, 相邻就继续合并
        if(base + base->property != p)
c010389f:	8b 45 08             	mov    0x8(%ebp),%eax
c01038a2:	8b 40 08             	mov    0x8(%eax),%eax
c01038a5:	c1 e0 05             	shl    $0x5,%eax
c01038a8:	89 c2                	mov    %eax,%edx
c01038aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01038ad:	01 d0                	add    %edx,%eax
c01038af:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01038b2:	75 69                	jne    c010391d <default_free_pages+0x24e>
            break;
        base->property += p->property;
c01038b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01038b7:	8b 50 08             	mov    0x8(%eax),%edx
c01038ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038bd:	8b 40 08             	mov    0x8(%eax),%eax
c01038c0:	01 c2                	add    %eax,%edx
c01038c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01038c5:	89 50 08             	mov    %edx,0x8(%eax)
        p->property = 0;
c01038c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038cb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01038d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038d5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    __list_del(listelm->prev, listelm->next);
c01038d8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01038db:	8b 40 04             	mov    0x4(%eax),%eax
c01038de:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01038e1:	8b 12                	mov    (%edx),%edx
c01038e3:	89 55 a0             	mov    %edx,-0x60(%ebp)
c01038e6:	89 45 9c             	mov    %eax,-0x64(%ebp)
    prev->next = next;
c01038e9:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01038ec:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01038ef:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01038f2:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01038f5:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01038f8:	89 10                	mov    %edx,(%eax)
}
c01038fa:	90                   	nop
}
c01038fb:	90                   	nop
        le = list_next(&(base->page_link))){
c01038fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01038ff:	83 c0 0c             	add    $0xc,%eax
c0103902:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return listelm->next;
c0103905:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103908:	8b 40 04             	mov    0x4(%eax),%eax
c010390b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        le != &free_list;
c010390e:	81 7d f0 84 6f 12 c0 	cmpl   $0xc0126f84,-0x10(%ebp)
c0103915:	0f 85 7b ff ff ff    	jne    c0103896 <default_free_pages+0x1c7>
c010391b:	eb 01                	jmp    c010391e <default_free_pages+0x24f>
            break;
c010391d:	90                   	nop
        list_del(le);
    }
    // 不是第一个块, 向前合并
    for(le = list_prev(&(base->page_link));
c010391e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103921:	83 c0 0c             	add    $0xc,%eax
c0103924:	89 45 98             	mov    %eax,-0x68(%ebp)
    return listelm->prev;
c0103927:	8b 45 98             	mov    -0x68(%ebp),%eax
c010392a:	8b 00                	mov    (%eax),%eax
c010392c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010392f:	e9 89 00 00 00       	jmp    c01039bd <default_free_pages+0x2ee>
        le != &free_list;
        le = list_prev(le)){
        p = le2page(le, page_link);
c0103934:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103937:	83 e8 0c             	sub    $0xc,%eax
c010393a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010393d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103940:	89 45 94             	mov    %eax,-0x6c(%ebp)
    return listelm->next;
c0103943:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0103946:	8b 40 04             	mov    0x4(%eax),%eax
        p_next = le2page(list_next(le), page_link);
c0103949:	83 e8 0c             	sub    $0xc,%eax
c010394c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        // 前一个空闲块 不相邻就退出, 相邻就继续合并
        if(p + p->property != p_next)
c010394f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103952:	8b 40 08             	mov    0x8(%eax),%eax
c0103955:	c1 e0 05             	shl    $0x5,%eax
c0103958:	89 c2                	mov    %eax,%edx
c010395a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010395d:	01 d0                	add    %edx,%eax
c010395f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103962:	75 68                	jne    c01039cc <default_free_pages+0x2fd>
            break;
        p->property += p_next->property;
c0103964:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103967:	8b 50 08             	mov    0x8(%eax),%edx
c010396a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010396d:	8b 40 08             	mov    0x8(%eax),%eax
c0103970:	01 c2                	add    %eax,%edx
c0103972:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103975:	89 50 08             	mov    %edx,0x8(%eax)
        p_next->property = 0;
c0103978:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010397b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        list_del(&(p_next->page_link));
c0103982:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103985:	83 c0 0c             	add    $0xc,%eax
c0103988:	89 45 8c             	mov    %eax,-0x74(%ebp)
    __list_del(listelm->prev, listelm->next);
c010398b:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010398e:	8b 40 04             	mov    0x4(%eax),%eax
c0103991:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0103994:	8b 12                	mov    (%edx),%edx
c0103996:	89 55 88             	mov    %edx,-0x78(%ebp)
c0103999:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next;
c010399c:	8b 45 88             	mov    -0x78(%ebp),%eax
c010399f:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01039a2:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01039a5:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01039a8:	8b 55 88             	mov    -0x78(%ebp),%edx
c01039ab:	89 10                	mov    %edx,(%eax)
}
c01039ad:	90                   	nop
}
c01039ae:	90                   	nop
c01039af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039b2:	89 45 90             	mov    %eax,-0x70(%ebp)
    return listelm->prev;
c01039b5:	8b 45 90             	mov    -0x70(%ebp),%eax
c01039b8:	8b 00                	mov    (%eax),%eax
        le = list_prev(le)){
c01039ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
        le != &free_list;
c01039bd:	81 7d f0 84 6f 12 c0 	cmpl   $0xc0126f84,-0x10(%ebp)
c01039c4:	0f 85 6a ff ff ff    	jne    c0103934 <default_free_pages+0x265>
    }
}
c01039ca:	eb 01                	jmp    c01039cd <default_free_pages+0x2fe>
            break;
c01039cc:	90                   	nop
}
c01039cd:	90                   	nop
c01039ce:	89 ec                	mov    %ebp,%esp
c01039d0:	5d                   	pop    %ebp
c01039d1:	c3                   	ret    

c01039d2 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c01039d2:	55                   	push   %ebp
c01039d3:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01039d5:	a1 8c 6f 12 c0       	mov    0xc0126f8c,%eax
}
c01039da:	5d                   	pop    %ebp
c01039db:	c3                   	ret    

c01039dc <basic_check>:

static void
basic_check(void) {
c01039dc:	55                   	push   %ebp
c01039dd:	89 e5                	mov    %esp,%ebp
c01039df:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01039e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01039e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01039f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039fc:	e8 ec 0e 00 00       	call   c01048ed <alloc_pages>
c0103a01:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103a04:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103a08:	75 24                	jne    c0103a2e <basic_check+0x52>
c0103a0a:	c7 44 24 0c 39 98 10 	movl   $0xc0109839,0xc(%esp)
c0103a11:	c0 
c0103a12:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103a19:	c0 
c0103a1a:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0103a21:	00 
c0103a22:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103a29:	e8 c3 d2 ff ff       	call   c0100cf1 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103a2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a35:	e8 b3 0e 00 00       	call   c01048ed <alloc_pages>
c0103a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a41:	75 24                	jne    c0103a67 <basic_check+0x8b>
c0103a43:	c7 44 24 0c 55 98 10 	movl   $0xc0109855,0xc(%esp)
c0103a4a:	c0 
c0103a4b:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103a52:	c0 
c0103a53:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0103a5a:	00 
c0103a5b:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103a62:	e8 8a d2 ff ff       	call   c0100cf1 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103a67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a6e:	e8 7a 0e 00 00       	call   c01048ed <alloc_pages>
c0103a73:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103a7a:	75 24                	jne    c0103aa0 <basic_check+0xc4>
c0103a7c:	c7 44 24 0c 71 98 10 	movl   $0xc0109871,0xc(%esp)
c0103a83:	c0 
c0103a84:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103a8b:	c0 
c0103a8c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0103a93:	00 
c0103a94:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103a9b:	e8 51 d2 ff ff       	call   c0100cf1 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103aa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103aa3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103aa6:	74 10                	je     c0103ab8 <basic_check+0xdc>
c0103aa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103aab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103aae:	74 08                	je     c0103ab8 <basic_check+0xdc>
c0103ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ab3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103ab6:	75 24                	jne    c0103adc <basic_check+0x100>
c0103ab8:	c7 44 24 0c 90 98 10 	movl   $0xc0109890,0xc(%esp)
c0103abf:	c0 
c0103ac0:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103ac7:	c0 
c0103ac8:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0103acf:	00 
c0103ad0:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103ad7:	e8 15 d2 ff ff       	call   c0100cf1 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103adf:	89 04 24             	mov    %eax,(%esp)
c0103ae2:	e8 ba f8 ff ff       	call   c01033a1 <page_ref>
c0103ae7:	85 c0                	test   %eax,%eax
c0103ae9:	75 1e                	jne    c0103b09 <basic_check+0x12d>
c0103aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103aee:	89 04 24             	mov    %eax,(%esp)
c0103af1:	e8 ab f8 ff ff       	call   c01033a1 <page_ref>
c0103af6:	85 c0                	test   %eax,%eax
c0103af8:	75 0f                	jne    c0103b09 <basic_check+0x12d>
c0103afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103afd:	89 04 24             	mov    %eax,(%esp)
c0103b00:	e8 9c f8 ff ff       	call   c01033a1 <page_ref>
c0103b05:	85 c0                	test   %eax,%eax
c0103b07:	74 24                	je     c0103b2d <basic_check+0x151>
c0103b09:	c7 44 24 0c b4 98 10 	movl   $0xc01098b4,0xc(%esp)
c0103b10:	c0 
c0103b11:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103b18:	c0 
c0103b19:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0103b20:	00 
c0103b21:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103b28:	e8 c4 d1 ff ff       	call   c0100cf1 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b30:	89 04 24             	mov    %eax,(%esp)
c0103b33:	e8 51 f8 ff ff       	call   c0103389 <page2pa>
c0103b38:	8b 15 a4 6f 12 c0    	mov    0xc0126fa4,%edx
c0103b3e:	c1 e2 0c             	shl    $0xc,%edx
c0103b41:	39 d0                	cmp    %edx,%eax
c0103b43:	72 24                	jb     c0103b69 <basic_check+0x18d>
c0103b45:	c7 44 24 0c f0 98 10 	movl   $0xc01098f0,0xc(%esp)
c0103b4c:	c0 
c0103b4d:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103b54:	c0 
c0103b55:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0103b5c:	00 
c0103b5d:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103b64:	e8 88 d1 ff ff       	call   c0100cf1 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b6c:	89 04 24             	mov    %eax,(%esp)
c0103b6f:	e8 15 f8 ff ff       	call   c0103389 <page2pa>
c0103b74:	8b 15 a4 6f 12 c0    	mov    0xc0126fa4,%edx
c0103b7a:	c1 e2 0c             	shl    $0xc,%edx
c0103b7d:	39 d0                	cmp    %edx,%eax
c0103b7f:	72 24                	jb     c0103ba5 <basic_check+0x1c9>
c0103b81:	c7 44 24 0c 0d 99 10 	movl   $0xc010990d,0xc(%esp)
c0103b88:	c0 
c0103b89:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103b90:	c0 
c0103b91:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c0103b98:	00 
c0103b99:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103ba0:	e8 4c d1 ff ff       	call   c0100cf1 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ba8:	89 04 24             	mov    %eax,(%esp)
c0103bab:	e8 d9 f7 ff ff       	call   c0103389 <page2pa>
c0103bb0:	8b 15 a4 6f 12 c0    	mov    0xc0126fa4,%edx
c0103bb6:	c1 e2 0c             	shl    $0xc,%edx
c0103bb9:	39 d0                	cmp    %edx,%eax
c0103bbb:	72 24                	jb     c0103be1 <basic_check+0x205>
c0103bbd:	c7 44 24 0c 2a 99 10 	movl   $0xc010992a,0xc(%esp)
c0103bc4:	c0 
c0103bc5:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103bcc:	c0 
c0103bcd:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c0103bd4:	00 
c0103bd5:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103bdc:	e8 10 d1 ff ff       	call   c0100cf1 <__panic>

    list_entry_t free_list_store = free_list;
c0103be1:	a1 84 6f 12 c0       	mov    0xc0126f84,%eax
c0103be6:	8b 15 88 6f 12 c0    	mov    0xc0126f88,%edx
c0103bec:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103bef:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103bf2:	c7 45 dc 84 6f 12 c0 	movl   $0xc0126f84,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0103bf9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103bfc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103bff:	89 50 04             	mov    %edx,0x4(%eax)
c0103c02:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103c05:	8b 50 04             	mov    0x4(%eax),%edx
c0103c08:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103c0b:	89 10                	mov    %edx,(%eax)
}
c0103c0d:	90                   	nop
c0103c0e:	c7 45 e0 84 6f 12 c0 	movl   $0xc0126f84,-0x20(%ebp)
    return list->next == list;
c0103c15:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103c18:	8b 40 04             	mov    0x4(%eax),%eax
c0103c1b:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103c1e:	0f 94 c0             	sete   %al
c0103c21:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103c24:	85 c0                	test   %eax,%eax
c0103c26:	75 24                	jne    c0103c4c <basic_check+0x270>
c0103c28:	c7 44 24 0c 47 99 10 	movl   $0xc0109947,0xc(%esp)
c0103c2f:	c0 
c0103c30:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103c37:	c0 
c0103c38:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0103c3f:	00 
c0103c40:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103c47:	e8 a5 d0 ff ff       	call   c0100cf1 <__panic>

    unsigned int nr_free_store = nr_free;
c0103c4c:	a1 8c 6f 12 c0       	mov    0xc0126f8c,%eax
c0103c51:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103c54:	c7 05 8c 6f 12 c0 00 	movl   $0x0,0xc0126f8c
c0103c5b:	00 00 00 

    assert(alloc_page() == NULL);
c0103c5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c65:	e8 83 0c 00 00       	call   c01048ed <alloc_pages>
c0103c6a:	85 c0                	test   %eax,%eax
c0103c6c:	74 24                	je     c0103c92 <basic_check+0x2b6>
c0103c6e:	c7 44 24 0c 5e 99 10 	movl   $0xc010995e,0xc(%esp)
c0103c75:	c0 
c0103c76:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103c7d:	c0 
c0103c7e:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c0103c85:	00 
c0103c86:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103c8d:	e8 5f d0 ff ff       	call   c0100cf1 <__panic>

    free_page(p0);
c0103c92:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c99:	00 
c0103c9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c9d:	89 04 24             	mov    %eax,(%esp)
c0103ca0:	e8 b5 0c 00 00       	call   c010495a <free_pages>
    free_page(p1);
c0103ca5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103cac:	00 
c0103cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cb0:	89 04 24             	mov    %eax,(%esp)
c0103cb3:	e8 a2 0c 00 00       	call   c010495a <free_pages>
    free_page(p2);
c0103cb8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103cbf:	00 
c0103cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cc3:	89 04 24             	mov    %eax,(%esp)
c0103cc6:	e8 8f 0c 00 00       	call   c010495a <free_pages>
    assert(nr_free == 3);
c0103ccb:	a1 8c 6f 12 c0       	mov    0xc0126f8c,%eax
c0103cd0:	83 f8 03             	cmp    $0x3,%eax
c0103cd3:	74 24                	je     c0103cf9 <basic_check+0x31d>
c0103cd5:	c7 44 24 0c 73 99 10 	movl   $0xc0109973,0xc(%esp)
c0103cdc:	c0 
c0103cdd:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103ce4:	c0 
c0103ce5:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0103cec:	00 
c0103ced:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103cf4:	e8 f8 cf ff ff       	call   c0100cf1 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103cf9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d00:	e8 e8 0b 00 00       	call   c01048ed <alloc_pages>
c0103d05:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103d08:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103d0c:	75 24                	jne    c0103d32 <basic_check+0x356>
c0103d0e:	c7 44 24 0c 39 98 10 	movl   $0xc0109839,0xc(%esp)
c0103d15:	c0 
c0103d16:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103d1d:	c0 
c0103d1e:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0103d25:	00 
c0103d26:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103d2d:	e8 bf cf ff ff       	call   c0100cf1 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103d32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d39:	e8 af 0b 00 00       	call   c01048ed <alloc_pages>
c0103d3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103d41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103d45:	75 24                	jne    c0103d6b <basic_check+0x38f>
c0103d47:	c7 44 24 0c 55 98 10 	movl   $0xc0109855,0xc(%esp)
c0103d4e:	c0 
c0103d4f:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103d56:	c0 
c0103d57:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0103d5e:	00 
c0103d5f:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103d66:	e8 86 cf ff ff       	call   c0100cf1 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103d6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d72:	e8 76 0b 00 00       	call   c01048ed <alloc_pages>
c0103d77:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103d7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103d7e:	75 24                	jne    c0103da4 <basic_check+0x3c8>
c0103d80:	c7 44 24 0c 71 98 10 	movl   $0xc0109871,0xc(%esp)
c0103d87:	c0 
c0103d88:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103d8f:	c0 
c0103d90:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0103d97:	00 
c0103d98:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103d9f:	e8 4d cf ff ff       	call   c0100cf1 <__panic>

    assert(alloc_page() == NULL);
c0103da4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103dab:	e8 3d 0b 00 00       	call   c01048ed <alloc_pages>
c0103db0:	85 c0                	test   %eax,%eax
c0103db2:	74 24                	je     c0103dd8 <basic_check+0x3fc>
c0103db4:	c7 44 24 0c 5e 99 10 	movl   $0xc010995e,0xc(%esp)
c0103dbb:	c0 
c0103dbc:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103dc3:	c0 
c0103dc4:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c0103dcb:	00 
c0103dcc:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103dd3:	e8 19 cf ff ff       	call   c0100cf1 <__panic>

    free_page(p0);
c0103dd8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ddf:	00 
c0103de0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103de3:	89 04 24             	mov    %eax,(%esp)
c0103de6:	e8 6f 0b 00 00       	call   c010495a <free_pages>
c0103deb:	c7 45 d8 84 6f 12 c0 	movl   $0xc0126f84,-0x28(%ebp)
c0103df2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103df5:	8b 40 04             	mov    0x4(%eax),%eax
c0103df8:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103dfb:	0f 94 c0             	sete   %al
c0103dfe:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103e01:	85 c0                	test   %eax,%eax
c0103e03:	74 24                	je     c0103e29 <basic_check+0x44d>
c0103e05:	c7 44 24 0c 80 99 10 	movl   $0xc0109980,0xc(%esp)
c0103e0c:	c0 
c0103e0d:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103e14:	c0 
c0103e15:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c0103e1c:	00 
c0103e1d:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103e24:	e8 c8 ce ff ff       	call   c0100cf1 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103e29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e30:	e8 b8 0a 00 00       	call   c01048ed <alloc_pages>
c0103e35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103e38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e3b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103e3e:	74 24                	je     c0103e64 <basic_check+0x488>
c0103e40:	c7 44 24 0c 98 99 10 	movl   $0xc0109998,0xc(%esp)
c0103e47:	c0 
c0103e48:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103e4f:	c0 
c0103e50:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c0103e57:	00 
c0103e58:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103e5f:	e8 8d ce ff ff       	call   c0100cf1 <__panic>
    assert(alloc_page() == NULL);
c0103e64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e6b:	e8 7d 0a 00 00       	call   c01048ed <alloc_pages>
c0103e70:	85 c0                	test   %eax,%eax
c0103e72:	74 24                	je     c0103e98 <basic_check+0x4bc>
c0103e74:	c7 44 24 0c 5e 99 10 	movl   $0xc010995e,0xc(%esp)
c0103e7b:	c0 
c0103e7c:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103e83:	c0 
c0103e84:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c0103e8b:	00 
c0103e8c:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103e93:	e8 59 ce ff ff       	call   c0100cf1 <__panic>

    assert(nr_free == 0);
c0103e98:	a1 8c 6f 12 c0       	mov    0xc0126f8c,%eax
c0103e9d:	85 c0                	test   %eax,%eax
c0103e9f:	74 24                	je     c0103ec5 <basic_check+0x4e9>
c0103ea1:	c7 44 24 0c b1 99 10 	movl   $0xc01099b1,0xc(%esp)
c0103ea8:	c0 
c0103ea9:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103eb0:	c0 
c0103eb1:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0103eb8:	00 
c0103eb9:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103ec0:	e8 2c ce ff ff       	call   c0100cf1 <__panic>
    free_list = free_list_store;
c0103ec5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103ec8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103ecb:	a3 84 6f 12 c0       	mov    %eax,0xc0126f84
c0103ed0:	89 15 88 6f 12 c0    	mov    %edx,0xc0126f88
    nr_free = nr_free_store;
c0103ed6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ed9:	a3 8c 6f 12 c0       	mov    %eax,0xc0126f8c

    free_page(p);
c0103ede:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ee5:	00 
c0103ee6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ee9:	89 04 24             	mov    %eax,(%esp)
c0103eec:	e8 69 0a 00 00       	call   c010495a <free_pages>
    free_page(p1);
c0103ef1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ef8:	00 
c0103ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103efc:	89 04 24             	mov    %eax,(%esp)
c0103eff:	e8 56 0a 00 00       	call   c010495a <free_pages>
    free_page(p2);
c0103f04:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f0b:	00 
c0103f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f0f:	89 04 24             	mov    %eax,(%esp)
c0103f12:	e8 43 0a 00 00       	call   c010495a <free_pages>
}
c0103f17:	90                   	nop
c0103f18:	89 ec                	mov    %ebp,%esp
c0103f1a:	5d                   	pop    %ebp
c0103f1b:	c3                   	ret    

c0103f1c <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103f1c:	55                   	push   %ebp
c0103f1d:	89 e5                	mov    %esp,%ebp
c0103f1f:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0103f25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103f2c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103f33:	c7 45 ec 84 6f 12 c0 	movl   $0xc0126f84,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103f3a:	eb 6a                	jmp    c0103fa6 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c0103f3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f3f:	83 e8 0c             	sub    $0xc,%eax
c0103f42:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0103f45:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103f48:	83 c0 04             	add    $0x4,%eax
c0103f4b:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103f52:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103f55:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103f58:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103f5b:	0f a3 10             	bt     %edx,(%eax)
c0103f5e:	19 c0                	sbb    %eax,%eax
c0103f60:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103f63:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103f67:	0f 95 c0             	setne  %al
c0103f6a:	0f b6 c0             	movzbl %al,%eax
c0103f6d:	85 c0                	test   %eax,%eax
c0103f6f:	75 24                	jne    c0103f95 <default_check+0x79>
c0103f71:	c7 44 24 0c be 99 10 	movl   $0xc01099be,0xc(%esp)
c0103f78:	c0 
c0103f79:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103f80:	c0 
c0103f81:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
c0103f88:	00 
c0103f89:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103f90:	e8 5c cd ff ff       	call   c0100cf1 <__panic>
        count ++, total += p->property;
c0103f95:	ff 45 f4             	incl   -0xc(%ebp)
c0103f98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103f9b:	8b 50 08             	mov    0x8(%eax),%edx
c0103f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103fa1:	01 d0                	add    %edx,%eax
c0103fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103fa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103fa9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0103fac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103faf:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0103fb2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103fb5:	81 7d ec 84 6f 12 c0 	cmpl   $0xc0126f84,-0x14(%ebp)
c0103fbc:	0f 85 7a ff ff ff    	jne    c0103f3c <default_check+0x20>
    }
    assert(total == nr_free_pages());
c0103fc2:	e8 c8 09 00 00       	call   c010498f <nr_free_pages>
c0103fc7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103fca:	39 d0                	cmp    %edx,%eax
c0103fcc:	74 24                	je     c0103ff2 <default_check+0xd6>
c0103fce:	c7 44 24 0c ce 99 10 	movl   $0xc01099ce,0xc(%esp)
c0103fd5:	c0 
c0103fd6:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0103fdd:	c0 
c0103fde:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c0103fe5:	00 
c0103fe6:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0103fed:	e8 ff cc ff ff       	call   c0100cf1 <__panic>

    basic_check();
c0103ff2:	e8 e5 f9 ff ff       	call   c01039dc <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103ff7:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103ffe:	e8 ea 08 00 00       	call   c01048ed <alloc_pages>
c0104003:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0104006:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010400a:	75 24                	jne    c0104030 <default_check+0x114>
c010400c:	c7 44 24 0c e7 99 10 	movl   $0xc01099e7,0xc(%esp)
c0104013:	c0 
c0104014:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c010401b:	c0 
c010401c:	c7 44 24 04 3c 01 00 	movl   $0x13c,0x4(%esp)
c0104023:	00 
c0104024:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c010402b:	e8 c1 cc ff ff       	call   c0100cf1 <__panic>
    assert(!PageProperty(p0));
c0104030:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104033:	83 c0 04             	add    $0x4,%eax
c0104036:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010403d:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104040:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104043:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104046:	0f a3 10             	bt     %edx,(%eax)
c0104049:	19 c0                	sbb    %eax,%eax
c010404b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c010404e:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104052:	0f 95 c0             	setne  %al
c0104055:	0f b6 c0             	movzbl %al,%eax
c0104058:	85 c0                	test   %eax,%eax
c010405a:	74 24                	je     c0104080 <default_check+0x164>
c010405c:	c7 44 24 0c f2 99 10 	movl   $0xc01099f2,0xc(%esp)
c0104063:	c0 
c0104064:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c010406b:	c0 
c010406c:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c0104073:	00 
c0104074:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c010407b:	e8 71 cc ff ff       	call   c0100cf1 <__panic>

    list_entry_t free_list_store = free_list;
c0104080:	a1 84 6f 12 c0       	mov    0xc0126f84,%eax
c0104085:	8b 15 88 6f 12 c0    	mov    0xc0126f88,%edx
c010408b:	89 45 80             	mov    %eax,-0x80(%ebp)
c010408e:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104091:	c7 45 b0 84 6f 12 c0 	movl   $0xc0126f84,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0104098:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010409b:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010409e:	89 50 04             	mov    %edx,0x4(%eax)
c01040a1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01040a4:	8b 50 04             	mov    0x4(%eax),%edx
c01040a7:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01040aa:	89 10                	mov    %edx,(%eax)
}
c01040ac:	90                   	nop
c01040ad:	c7 45 b4 84 6f 12 c0 	movl   $0xc0126f84,-0x4c(%ebp)
    return list->next == list;
c01040b4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01040b7:	8b 40 04             	mov    0x4(%eax),%eax
c01040ba:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c01040bd:	0f 94 c0             	sete   %al
c01040c0:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01040c3:	85 c0                	test   %eax,%eax
c01040c5:	75 24                	jne    c01040eb <default_check+0x1cf>
c01040c7:	c7 44 24 0c 47 99 10 	movl   $0xc0109947,0xc(%esp)
c01040ce:	c0 
c01040cf:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c01040d6:	c0 
c01040d7:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
c01040de:	00 
c01040df:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c01040e6:	e8 06 cc ff ff       	call   c0100cf1 <__panic>
    assert(alloc_page() == NULL);
c01040eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01040f2:	e8 f6 07 00 00       	call   c01048ed <alloc_pages>
c01040f7:	85 c0                	test   %eax,%eax
c01040f9:	74 24                	je     c010411f <default_check+0x203>
c01040fb:	c7 44 24 0c 5e 99 10 	movl   $0xc010995e,0xc(%esp)
c0104102:	c0 
c0104103:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c010410a:	c0 
c010410b:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
c0104112:	00 
c0104113:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c010411a:	e8 d2 cb ff ff       	call   c0100cf1 <__panic>

    unsigned int nr_free_store = nr_free;
c010411f:	a1 8c 6f 12 c0       	mov    0xc0126f8c,%eax
c0104124:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0104127:	c7 05 8c 6f 12 c0 00 	movl   $0x0,0xc0126f8c
c010412e:	00 00 00 

    free_pages(p0 + 2, 3);
c0104131:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104134:	83 c0 40             	add    $0x40,%eax
c0104137:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010413e:	00 
c010413f:	89 04 24             	mov    %eax,(%esp)
c0104142:	e8 13 08 00 00       	call   c010495a <free_pages>
    assert(alloc_pages(4) == NULL);
c0104147:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010414e:	e8 9a 07 00 00       	call   c01048ed <alloc_pages>
c0104153:	85 c0                	test   %eax,%eax
c0104155:	74 24                	je     c010417b <default_check+0x25f>
c0104157:	c7 44 24 0c 04 9a 10 	movl   $0xc0109a04,0xc(%esp)
c010415e:	c0 
c010415f:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0104166:	c0 
c0104167:	c7 44 24 04 48 01 00 	movl   $0x148,0x4(%esp)
c010416e:	00 
c010416f:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0104176:	e8 76 cb ff ff       	call   c0100cf1 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010417b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010417e:	83 c0 40             	add    $0x40,%eax
c0104181:	83 c0 04             	add    $0x4,%eax
c0104184:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c010418b:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010418e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104191:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104194:	0f a3 10             	bt     %edx,(%eax)
c0104197:	19 c0                	sbb    %eax,%eax
c0104199:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c010419c:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01041a0:	0f 95 c0             	setne  %al
c01041a3:	0f b6 c0             	movzbl %al,%eax
c01041a6:	85 c0                	test   %eax,%eax
c01041a8:	74 0e                	je     c01041b8 <default_check+0x29c>
c01041aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01041ad:	83 c0 40             	add    $0x40,%eax
c01041b0:	8b 40 08             	mov    0x8(%eax),%eax
c01041b3:	83 f8 03             	cmp    $0x3,%eax
c01041b6:	74 24                	je     c01041dc <default_check+0x2c0>
c01041b8:	c7 44 24 0c 1c 9a 10 	movl   $0xc0109a1c,0xc(%esp)
c01041bf:	c0 
c01041c0:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c01041c7:	c0 
c01041c8:	c7 44 24 04 49 01 00 	movl   $0x149,0x4(%esp)
c01041cf:	00 
c01041d0:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c01041d7:	e8 15 cb ff ff       	call   c0100cf1 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01041dc:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01041e3:	e8 05 07 00 00       	call   c01048ed <alloc_pages>
c01041e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01041eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01041ef:	75 24                	jne    c0104215 <default_check+0x2f9>
c01041f1:	c7 44 24 0c 48 9a 10 	movl   $0xc0109a48,0xc(%esp)
c01041f8:	c0 
c01041f9:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0104200:	c0 
c0104201:	c7 44 24 04 4a 01 00 	movl   $0x14a,0x4(%esp)
c0104208:	00 
c0104209:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0104210:	e8 dc ca ff ff       	call   c0100cf1 <__panic>
    assert(alloc_page() == NULL);
c0104215:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010421c:	e8 cc 06 00 00       	call   c01048ed <alloc_pages>
c0104221:	85 c0                	test   %eax,%eax
c0104223:	74 24                	je     c0104249 <default_check+0x32d>
c0104225:	c7 44 24 0c 5e 99 10 	movl   $0xc010995e,0xc(%esp)
c010422c:	c0 
c010422d:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0104234:	c0 
c0104235:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
c010423c:	00 
c010423d:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0104244:	e8 a8 ca ff ff       	call   c0100cf1 <__panic>
    assert(p0 + 2 == p1);
c0104249:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010424c:	83 c0 40             	add    $0x40,%eax
c010424f:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104252:	74 24                	je     c0104278 <default_check+0x35c>
c0104254:	c7 44 24 0c 66 9a 10 	movl   $0xc0109a66,0xc(%esp)
c010425b:	c0 
c010425c:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0104263:	c0 
c0104264:	c7 44 24 04 4c 01 00 	movl   $0x14c,0x4(%esp)
c010426b:	00 
c010426c:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0104273:	e8 79 ca ff ff       	call   c0100cf1 <__panic>

    p2 = p0 + 1;
c0104278:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010427b:	83 c0 20             	add    $0x20,%eax
c010427e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c0104281:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104288:	00 
c0104289:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010428c:	89 04 24             	mov    %eax,(%esp)
c010428f:	e8 c6 06 00 00       	call   c010495a <free_pages>
    free_pages(p1, 3);
c0104294:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010429b:	00 
c010429c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010429f:	89 04 24             	mov    %eax,(%esp)
c01042a2:	e8 b3 06 00 00       	call   c010495a <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01042a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01042aa:	83 c0 04             	add    $0x4,%eax
c01042ad:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01042b4:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01042b7:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01042ba:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01042bd:	0f a3 10             	bt     %edx,(%eax)
c01042c0:	19 c0                	sbb    %eax,%eax
c01042c2:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01042c5:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01042c9:	0f 95 c0             	setne  %al
c01042cc:	0f b6 c0             	movzbl %al,%eax
c01042cf:	85 c0                	test   %eax,%eax
c01042d1:	74 0b                	je     c01042de <default_check+0x3c2>
c01042d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01042d6:	8b 40 08             	mov    0x8(%eax),%eax
c01042d9:	83 f8 01             	cmp    $0x1,%eax
c01042dc:	74 24                	je     c0104302 <default_check+0x3e6>
c01042de:	c7 44 24 0c 74 9a 10 	movl   $0xc0109a74,0xc(%esp)
c01042e5:	c0 
c01042e6:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c01042ed:	c0 
c01042ee:	c7 44 24 04 51 01 00 	movl   $0x151,0x4(%esp)
c01042f5:	00 
c01042f6:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c01042fd:	e8 ef c9 ff ff       	call   c0100cf1 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104302:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104305:	83 c0 04             	add    $0x4,%eax
c0104308:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010430f:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104312:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104315:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104318:	0f a3 10             	bt     %edx,(%eax)
c010431b:	19 c0                	sbb    %eax,%eax
c010431d:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0104320:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0104324:	0f 95 c0             	setne  %al
c0104327:	0f b6 c0             	movzbl %al,%eax
c010432a:	85 c0                	test   %eax,%eax
c010432c:	74 0b                	je     c0104339 <default_check+0x41d>
c010432e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104331:	8b 40 08             	mov    0x8(%eax),%eax
c0104334:	83 f8 03             	cmp    $0x3,%eax
c0104337:	74 24                	je     c010435d <default_check+0x441>
c0104339:	c7 44 24 0c 9c 9a 10 	movl   $0xc0109a9c,0xc(%esp)
c0104340:	c0 
c0104341:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0104348:	c0 
c0104349:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c0104350:	00 
c0104351:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0104358:	e8 94 c9 ff ff       	call   c0100cf1 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010435d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104364:	e8 84 05 00 00       	call   c01048ed <alloc_pages>
c0104369:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010436c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010436f:	83 e8 20             	sub    $0x20,%eax
c0104372:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104375:	74 24                	je     c010439b <default_check+0x47f>
c0104377:	c7 44 24 0c c2 9a 10 	movl   $0xc0109ac2,0xc(%esp)
c010437e:	c0 
c010437f:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0104386:	c0 
c0104387:	c7 44 24 04 54 01 00 	movl   $0x154,0x4(%esp)
c010438e:	00 
c010438f:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0104396:	e8 56 c9 ff ff       	call   c0100cf1 <__panic>
    free_page(p0);
c010439b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01043a2:	00 
c01043a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043a6:	89 04 24             	mov    %eax,(%esp)
c01043a9:	e8 ac 05 00 00       	call   c010495a <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01043ae:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01043b5:	e8 33 05 00 00       	call   c01048ed <alloc_pages>
c01043ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01043bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043c0:	83 c0 20             	add    $0x20,%eax
c01043c3:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01043c6:	74 24                	je     c01043ec <default_check+0x4d0>
c01043c8:	c7 44 24 0c e0 9a 10 	movl   $0xc0109ae0,0xc(%esp)
c01043cf:	c0 
c01043d0:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c01043d7:	c0 
c01043d8:	c7 44 24 04 56 01 00 	movl   $0x156,0x4(%esp)
c01043df:	00 
c01043e0:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c01043e7:	e8 05 c9 ff ff       	call   c0100cf1 <__panic>

    free_pages(p0, 2);
c01043ec:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01043f3:	00 
c01043f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043f7:	89 04 24             	mov    %eax,(%esp)
c01043fa:	e8 5b 05 00 00       	call   c010495a <free_pages>
    free_page(p2);
c01043ff:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104406:	00 
c0104407:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010440a:	89 04 24             	mov    %eax,(%esp)
c010440d:	e8 48 05 00 00       	call   c010495a <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0104412:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104419:	e8 cf 04 00 00       	call   c01048ed <alloc_pages>
c010441e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104421:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104425:	75 24                	jne    c010444b <default_check+0x52f>
c0104427:	c7 44 24 0c 00 9b 10 	movl   $0xc0109b00,0xc(%esp)
c010442e:	c0 
c010442f:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0104436:	c0 
c0104437:	c7 44 24 04 5b 01 00 	movl   $0x15b,0x4(%esp)
c010443e:	00 
c010443f:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0104446:	e8 a6 c8 ff ff       	call   c0100cf1 <__panic>
    assert(alloc_page() == NULL);
c010444b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104452:	e8 96 04 00 00       	call   c01048ed <alloc_pages>
c0104457:	85 c0                	test   %eax,%eax
c0104459:	74 24                	je     c010447f <default_check+0x563>
c010445b:	c7 44 24 0c 5e 99 10 	movl   $0xc010995e,0xc(%esp)
c0104462:	c0 
c0104463:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c010446a:	c0 
c010446b:	c7 44 24 04 5c 01 00 	movl   $0x15c,0x4(%esp)
c0104472:	00 
c0104473:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c010447a:	e8 72 c8 ff ff       	call   c0100cf1 <__panic>

    assert(nr_free == 0);
c010447f:	a1 8c 6f 12 c0       	mov    0xc0126f8c,%eax
c0104484:	85 c0                	test   %eax,%eax
c0104486:	74 24                	je     c01044ac <default_check+0x590>
c0104488:	c7 44 24 0c b1 99 10 	movl   $0xc01099b1,0xc(%esp)
c010448f:	c0 
c0104490:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0104497:	c0 
c0104498:	c7 44 24 04 5e 01 00 	movl   $0x15e,0x4(%esp)
c010449f:	00 
c01044a0:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c01044a7:	e8 45 c8 ff ff       	call   c0100cf1 <__panic>
    nr_free = nr_free_store;
c01044ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01044af:	a3 8c 6f 12 c0       	mov    %eax,0xc0126f8c

    free_list = free_list_store;
c01044b4:	8b 45 80             	mov    -0x80(%ebp),%eax
c01044b7:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01044ba:	a3 84 6f 12 c0       	mov    %eax,0xc0126f84
c01044bf:	89 15 88 6f 12 c0    	mov    %edx,0xc0126f88
    free_pages(p0, 5);
c01044c5:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01044cc:	00 
c01044cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044d0:	89 04 24             	mov    %eax,(%esp)
c01044d3:	e8 82 04 00 00       	call   c010495a <free_pages>

    le = &free_list;
c01044d8:	c7 45 ec 84 6f 12 c0 	movl   $0xc0126f84,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01044df:	eb 1c                	jmp    c01044fd <default_check+0x5e1>
        struct Page *p = le2page(le, page_link);
c01044e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044e4:	83 e8 0c             	sub    $0xc,%eax
c01044e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c01044ea:	ff 4d f4             	decl   -0xc(%ebp)
c01044ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01044f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01044f3:	8b 48 08             	mov    0x8(%eax),%ecx
c01044f6:	89 d0                	mov    %edx,%eax
c01044f8:	29 c8                	sub    %ecx,%eax
c01044fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01044fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104500:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0104503:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104506:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104509:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010450c:	81 7d ec 84 6f 12 c0 	cmpl   $0xc0126f84,-0x14(%ebp)
c0104513:	75 cc                	jne    c01044e1 <default_check+0x5c5>
    }
    assert(count == 0);
c0104515:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104519:	74 24                	je     c010453f <default_check+0x623>
c010451b:	c7 44 24 0c 1e 9b 10 	movl   $0xc0109b1e,0xc(%esp)
c0104522:	c0 
c0104523:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c010452a:	c0 
c010452b:	c7 44 24 04 69 01 00 	movl   $0x169,0x4(%esp)
c0104532:	00 
c0104533:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c010453a:	e8 b2 c7 ff ff       	call   c0100cf1 <__panic>
    assert(total == 0);
c010453f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104543:	74 24                	je     c0104569 <default_check+0x64d>
c0104545:	c7 44 24 0c 29 9b 10 	movl   $0xc0109b29,0xc(%esp)
c010454c:	c0 
c010454d:	c7 44 24 08 d6 97 10 	movl   $0xc01097d6,0x8(%esp)
c0104554:	c0 
c0104555:	c7 44 24 04 6a 01 00 	movl   $0x16a,0x4(%esp)
c010455c:	00 
c010455d:	c7 04 24 eb 97 10 c0 	movl   $0xc01097eb,(%esp)
c0104564:	e8 88 c7 ff ff       	call   c0100cf1 <__panic>
}
c0104569:	90                   	nop
c010456a:	89 ec                	mov    %ebp,%esp
c010456c:	5d                   	pop    %ebp
c010456d:	c3                   	ret    

c010456e <page2ppn>:
page2ppn(struct Page *page) {
c010456e:	55                   	push   %ebp
c010456f:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104571:	8b 15 a0 6f 12 c0    	mov    0xc0126fa0,%edx
c0104577:	8b 45 08             	mov    0x8(%ebp),%eax
c010457a:	29 d0                	sub    %edx,%eax
c010457c:	c1 f8 05             	sar    $0x5,%eax
}
c010457f:	5d                   	pop    %ebp
c0104580:	c3                   	ret    

c0104581 <page2pa>:
page2pa(struct Page *page) {
c0104581:	55                   	push   %ebp
c0104582:	89 e5                	mov    %esp,%ebp
c0104584:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104587:	8b 45 08             	mov    0x8(%ebp),%eax
c010458a:	89 04 24             	mov    %eax,(%esp)
c010458d:	e8 dc ff ff ff       	call   c010456e <page2ppn>
c0104592:	c1 e0 0c             	shl    $0xc,%eax
}
c0104595:	89 ec                	mov    %ebp,%esp
c0104597:	5d                   	pop    %ebp
c0104598:	c3                   	ret    

c0104599 <pa2page>:
pa2page(uintptr_t pa) {
c0104599:	55                   	push   %ebp
c010459a:	89 e5                	mov    %esp,%ebp
c010459c:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010459f:	8b 45 08             	mov    0x8(%ebp),%eax
c01045a2:	c1 e8 0c             	shr    $0xc,%eax
c01045a5:	89 c2                	mov    %eax,%edx
c01045a7:	a1 a4 6f 12 c0       	mov    0xc0126fa4,%eax
c01045ac:	39 c2                	cmp    %eax,%edx
c01045ae:	72 1c                	jb     c01045cc <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01045b0:	c7 44 24 08 64 9b 10 	movl   $0xc0109b64,0x8(%esp)
c01045b7:	c0 
c01045b8:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01045bf:	00 
c01045c0:	c7 04 24 83 9b 10 c0 	movl   $0xc0109b83,(%esp)
c01045c7:	e8 25 c7 ff ff       	call   c0100cf1 <__panic>
    return &pages[PPN(pa)];
c01045cc:	8b 15 a0 6f 12 c0    	mov    0xc0126fa0,%edx
c01045d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01045d5:	c1 e8 0c             	shr    $0xc,%eax
c01045d8:	c1 e0 05             	shl    $0x5,%eax
c01045db:	01 d0                	add    %edx,%eax
}
c01045dd:	89 ec                	mov    %ebp,%esp
c01045df:	5d                   	pop    %ebp
c01045e0:	c3                   	ret    

c01045e1 <page2kva>:
page2kva(struct Page *page) {
c01045e1:	55                   	push   %ebp
c01045e2:	89 e5                	mov    %esp,%ebp
c01045e4:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01045e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01045ea:	89 04 24             	mov    %eax,(%esp)
c01045ed:	e8 8f ff ff ff       	call   c0104581 <page2pa>
c01045f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01045f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045f8:	c1 e8 0c             	shr    $0xc,%eax
c01045fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01045fe:	a1 a4 6f 12 c0       	mov    0xc0126fa4,%eax
c0104603:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104606:	72 23                	jb     c010462b <page2kva+0x4a>
c0104608:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010460b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010460f:	c7 44 24 08 94 9b 10 	movl   $0xc0109b94,0x8(%esp)
c0104616:	c0 
c0104617:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c010461e:	00 
c010461f:	c7 04 24 83 9b 10 c0 	movl   $0xc0109b83,(%esp)
c0104626:	e8 c6 c6 ff ff       	call   c0100cf1 <__panic>
c010462b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010462e:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104633:	89 ec                	mov    %ebp,%esp
c0104635:	5d                   	pop    %ebp
c0104636:	c3                   	ret    

c0104637 <kva2page>:
kva2page(void *kva) {
c0104637:	55                   	push   %ebp
c0104638:	89 e5                	mov    %esp,%ebp
c010463a:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c010463d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104640:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104643:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010464a:	77 23                	ja     c010466f <kva2page+0x38>
c010464c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010464f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104653:	c7 44 24 08 b8 9b 10 	movl   $0xc0109bb8,0x8(%esp)
c010465a:	c0 
c010465b:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0104662:	00 
c0104663:	c7 04 24 83 9b 10 c0 	movl   $0xc0109b83,(%esp)
c010466a:	e8 82 c6 ff ff       	call   c0100cf1 <__panic>
c010466f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104672:	05 00 00 00 40       	add    $0x40000000,%eax
c0104677:	89 04 24             	mov    %eax,(%esp)
c010467a:	e8 1a ff ff ff       	call   c0104599 <pa2page>
}
c010467f:	89 ec                	mov    %ebp,%esp
c0104681:	5d                   	pop    %ebp
c0104682:	c3                   	ret    

c0104683 <pte2page>:
pte2page(pte_t pte) {
c0104683:	55                   	push   %ebp
c0104684:	89 e5                	mov    %esp,%ebp
c0104686:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104689:	8b 45 08             	mov    0x8(%ebp),%eax
c010468c:	83 e0 01             	and    $0x1,%eax
c010468f:	85 c0                	test   %eax,%eax
c0104691:	75 1c                	jne    c01046af <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104693:	c7 44 24 08 dc 9b 10 	movl   $0xc0109bdc,0x8(%esp)
c010469a:	c0 
c010469b:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01046a2:	00 
c01046a3:	c7 04 24 83 9b 10 c0 	movl   $0xc0109b83,(%esp)
c01046aa:	e8 42 c6 ff ff       	call   c0100cf1 <__panic>
    return pa2page(PTE_ADDR(pte));
c01046af:	8b 45 08             	mov    0x8(%ebp),%eax
c01046b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01046b7:	89 04 24             	mov    %eax,(%esp)
c01046ba:	e8 da fe ff ff       	call   c0104599 <pa2page>
}
c01046bf:	89 ec                	mov    %ebp,%esp
c01046c1:	5d                   	pop    %ebp
c01046c2:	c3                   	ret    

c01046c3 <pde2page>:
pde2page(pde_t pde) {
c01046c3:	55                   	push   %ebp
c01046c4:	89 e5                	mov    %esp,%ebp
c01046c6:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c01046c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01046cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01046d1:	89 04 24             	mov    %eax,(%esp)
c01046d4:	e8 c0 fe ff ff       	call   c0104599 <pa2page>
}
c01046d9:	89 ec                	mov    %ebp,%esp
c01046db:	5d                   	pop    %ebp
c01046dc:	c3                   	ret    

c01046dd <page_ref>:
page_ref(struct Page *page) {
c01046dd:	55                   	push   %ebp
c01046de:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01046e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01046e3:	8b 00                	mov    (%eax),%eax
}
c01046e5:	5d                   	pop    %ebp
c01046e6:	c3                   	ret    

c01046e7 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c01046e7:	55                   	push   %ebp
c01046e8:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01046ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01046ed:	8b 55 0c             	mov    0xc(%ebp),%edx
c01046f0:	89 10                	mov    %edx,(%eax)
}
c01046f2:	90                   	nop
c01046f3:	5d                   	pop    %ebp
c01046f4:	c3                   	ret    

c01046f5 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c01046f5:	55                   	push   %ebp
c01046f6:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c01046f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01046fb:	8b 00                	mov    (%eax),%eax
c01046fd:	8d 50 01             	lea    0x1(%eax),%edx
c0104700:	8b 45 08             	mov    0x8(%ebp),%eax
c0104703:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104705:	8b 45 08             	mov    0x8(%ebp),%eax
c0104708:	8b 00                	mov    (%eax),%eax
}
c010470a:	5d                   	pop    %ebp
c010470b:	c3                   	ret    

c010470c <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c010470c:	55                   	push   %ebp
c010470d:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c010470f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104712:	8b 00                	mov    (%eax),%eax
c0104714:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104717:	8b 45 08             	mov    0x8(%ebp),%eax
c010471a:	89 10                	mov    %edx,(%eax)
    return page->ref;
c010471c:	8b 45 08             	mov    0x8(%ebp),%eax
c010471f:	8b 00                	mov    (%eax),%eax
}
c0104721:	5d                   	pop    %ebp
c0104722:	c3                   	ret    

c0104723 <__intr_save>:
__intr_save(void) {
c0104723:	55                   	push   %ebp
c0104724:	89 e5                	mov    %esp,%ebp
c0104726:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104729:	9c                   	pushf  
c010472a:	58                   	pop    %eax
c010472b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c010472e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104731:	25 00 02 00 00       	and    $0x200,%eax
c0104736:	85 c0                	test   %eax,%eax
c0104738:	74 0c                	je     c0104746 <__intr_save+0x23>
        intr_disable();
c010473a:	e8 68 d8 ff ff       	call   c0101fa7 <intr_disable>
        return 1;
c010473f:	b8 01 00 00 00       	mov    $0x1,%eax
c0104744:	eb 05                	jmp    c010474b <__intr_save+0x28>
    return 0;
c0104746:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010474b:	89 ec                	mov    %ebp,%esp
c010474d:	5d                   	pop    %ebp
c010474e:	c3                   	ret    

c010474f <__intr_restore>:
__intr_restore(bool flag) {
c010474f:	55                   	push   %ebp
c0104750:	89 e5                	mov    %esp,%ebp
c0104752:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104755:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104759:	74 05                	je     c0104760 <__intr_restore+0x11>
        intr_enable();
c010475b:	e8 3f d8 ff ff       	call   c0101f9f <intr_enable>
}
c0104760:	90                   	nop
c0104761:	89 ec                	mov    %ebp,%esp
c0104763:	5d                   	pop    %ebp
c0104764:	c3                   	ret    

c0104765 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104765:	55                   	push   %ebp
c0104766:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104768:	8b 45 08             	mov    0x8(%ebp),%eax
c010476b:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c010476e:	b8 23 00 00 00       	mov    $0x23,%eax
c0104773:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104775:	b8 23 00 00 00       	mov    $0x23,%eax
c010477a:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c010477c:	b8 10 00 00 00       	mov    $0x10,%eax
c0104781:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104783:	b8 10 00 00 00       	mov    $0x10,%eax
c0104788:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c010478a:	b8 10 00 00 00       	mov    $0x10,%eax
c010478f:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104791:	ea 98 47 10 c0 08 00 	ljmp   $0x8,$0xc0104798
}
c0104798:	90                   	nop
c0104799:	5d                   	pop    %ebp
c010479a:	c3                   	ret    

c010479b <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c010479b:	55                   	push   %ebp
c010479c:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c010479e:	8b 45 08             	mov    0x8(%ebp),%eax
c01047a1:	a3 c4 6f 12 c0       	mov    %eax,0xc0126fc4
}
c01047a6:	90                   	nop
c01047a7:	5d                   	pop    %ebp
c01047a8:	c3                   	ret    

c01047a9 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c01047a9:	55                   	push   %ebp
c01047aa:	89 e5                	mov    %esp,%ebp
c01047ac:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c01047af:	b8 00 30 12 c0       	mov    $0xc0123000,%eax
c01047b4:	89 04 24             	mov    %eax,(%esp)
c01047b7:	e8 df ff ff ff       	call   c010479b <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c01047bc:	66 c7 05 c8 6f 12 c0 	movw   $0x10,0xc0126fc8
c01047c3:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c01047c5:	66 c7 05 28 3a 12 c0 	movw   $0x68,0xc0123a28
c01047cc:	68 00 
c01047ce:	b8 c0 6f 12 c0       	mov    $0xc0126fc0,%eax
c01047d3:	0f b7 c0             	movzwl %ax,%eax
c01047d6:	66 a3 2a 3a 12 c0    	mov    %ax,0xc0123a2a
c01047dc:	b8 c0 6f 12 c0       	mov    $0xc0126fc0,%eax
c01047e1:	c1 e8 10             	shr    $0x10,%eax
c01047e4:	a2 2c 3a 12 c0       	mov    %al,0xc0123a2c
c01047e9:	0f b6 05 2d 3a 12 c0 	movzbl 0xc0123a2d,%eax
c01047f0:	24 f0                	and    $0xf0,%al
c01047f2:	0c 09                	or     $0x9,%al
c01047f4:	a2 2d 3a 12 c0       	mov    %al,0xc0123a2d
c01047f9:	0f b6 05 2d 3a 12 c0 	movzbl 0xc0123a2d,%eax
c0104800:	24 ef                	and    $0xef,%al
c0104802:	a2 2d 3a 12 c0       	mov    %al,0xc0123a2d
c0104807:	0f b6 05 2d 3a 12 c0 	movzbl 0xc0123a2d,%eax
c010480e:	24 9f                	and    $0x9f,%al
c0104810:	a2 2d 3a 12 c0       	mov    %al,0xc0123a2d
c0104815:	0f b6 05 2d 3a 12 c0 	movzbl 0xc0123a2d,%eax
c010481c:	0c 80                	or     $0x80,%al
c010481e:	a2 2d 3a 12 c0       	mov    %al,0xc0123a2d
c0104823:	0f b6 05 2e 3a 12 c0 	movzbl 0xc0123a2e,%eax
c010482a:	24 f0                	and    $0xf0,%al
c010482c:	a2 2e 3a 12 c0       	mov    %al,0xc0123a2e
c0104831:	0f b6 05 2e 3a 12 c0 	movzbl 0xc0123a2e,%eax
c0104838:	24 ef                	and    $0xef,%al
c010483a:	a2 2e 3a 12 c0       	mov    %al,0xc0123a2e
c010483f:	0f b6 05 2e 3a 12 c0 	movzbl 0xc0123a2e,%eax
c0104846:	24 df                	and    $0xdf,%al
c0104848:	a2 2e 3a 12 c0       	mov    %al,0xc0123a2e
c010484d:	0f b6 05 2e 3a 12 c0 	movzbl 0xc0123a2e,%eax
c0104854:	0c 40                	or     $0x40,%al
c0104856:	a2 2e 3a 12 c0       	mov    %al,0xc0123a2e
c010485b:	0f b6 05 2e 3a 12 c0 	movzbl 0xc0123a2e,%eax
c0104862:	24 7f                	and    $0x7f,%al
c0104864:	a2 2e 3a 12 c0       	mov    %al,0xc0123a2e
c0104869:	b8 c0 6f 12 c0       	mov    $0xc0126fc0,%eax
c010486e:	c1 e8 18             	shr    $0x18,%eax
c0104871:	a2 2f 3a 12 c0       	mov    %al,0xc0123a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104876:	c7 04 24 30 3a 12 c0 	movl   $0xc0123a30,(%esp)
c010487d:	e8 e3 fe ff ff       	call   c0104765 <lgdt>
c0104882:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0104888:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c010488c:	0f 00 d8             	ltr    %ax
}
c010488f:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0104890:	90                   	nop
c0104891:	89 ec                	mov    %ebp,%esp
c0104893:	5d                   	pop    %ebp
c0104894:	c3                   	ret    

c0104895 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0104895:	55                   	push   %ebp
c0104896:	89 e5                	mov    %esp,%ebp
c0104898:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c010489b:	c7 05 ac 6f 12 c0 48 	movl   $0xc0109b48,0xc0126fac
c01048a2:	9b 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c01048a5:	a1 ac 6f 12 c0       	mov    0xc0126fac,%eax
c01048aa:	8b 00                	mov    (%eax),%eax
c01048ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048b0:	c7 04 24 08 9c 10 c0 	movl   $0xc0109c08,(%esp)
c01048b7:	e8 a9 ba ff ff       	call   c0100365 <cprintf>
    pmm_manager->init();
c01048bc:	a1 ac 6f 12 c0       	mov    0xc0126fac,%eax
c01048c1:	8b 40 04             	mov    0x4(%eax),%eax
c01048c4:	ff d0                	call   *%eax
}
c01048c6:	90                   	nop
c01048c7:	89 ec                	mov    %ebp,%esp
c01048c9:	5d                   	pop    %ebp
c01048ca:	c3                   	ret    

c01048cb <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c01048cb:	55                   	push   %ebp
c01048cc:	89 e5                	mov    %esp,%ebp
c01048ce:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c01048d1:	a1 ac 6f 12 c0       	mov    0xc0126fac,%eax
c01048d6:	8b 40 08             	mov    0x8(%eax),%eax
c01048d9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01048dc:	89 54 24 04          	mov    %edx,0x4(%esp)
c01048e0:	8b 55 08             	mov    0x8(%ebp),%edx
c01048e3:	89 14 24             	mov    %edx,(%esp)
c01048e6:	ff d0                	call   *%eax
}
c01048e8:	90                   	nop
c01048e9:	89 ec                	mov    %ebp,%esp
c01048eb:	5d                   	pop    %ebp
c01048ec:	c3                   	ret    

c01048ed <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c01048ed:	55                   	push   %ebp
c01048ee:	89 e5                	mov    %esp,%ebp
c01048f0:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c01048f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c01048fa:	e8 24 fe ff ff       	call   c0104723 <__intr_save>
c01048ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0104902:	a1 ac 6f 12 c0       	mov    0xc0126fac,%eax
c0104907:	8b 40 0c             	mov    0xc(%eax),%eax
c010490a:	8b 55 08             	mov    0x8(%ebp),%edx
c010490d:	89 14 24             	mov    %edx,(%esp)
c0104910:	ff d0                	call   *%eax
c0104912:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0104915:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104918:	89 04 24             	mov    %eax,(%esp)
c010491b:	e8 2f fe ff ff       	call   c010474f <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0104920:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104924:	75 2d                	jne    c0104953 <alloc_pages+0x66>
c0104926:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c010492a:	77 27                	ja     c0104953 <alloc_pages+0x66>
c010492c:	a1 44 70 12 c0       	mov    0xc0127044,%eax
c0104931:	85 c0                	test   %eax,%eax
c0104933:	74 1e                	je     c0104953 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0104935:	8b 55 08             	mov    0x8(%ebp),%edx
c0104938:	a1 0c 71 12 c0       	mov    0xc012710c,%eax
c010493d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104944:	00 
c0104945:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104949:	89 04 24             	mov    %eax,(%esp)
c010494c:	e8 24 1a 00 00       	call   c0106375 <swap_out>
    {
c0104951:	eb a7                	jmp    c01048fa <alloc_pages+0xd>
    }
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0104953:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104956:	89 ec                	mov    %ebp,%esp
c0104958:	5d                   	pop    %ebp
c0104959:	c3                   	ret    

c010495a <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c010495a:	55                   	push   %ebp
c010495b:	89 e5                	mov    %esp,%ebp
c010495d:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0104960:	e8 be fd ff ff       	call   c0104723 <__intr_save>
c0104965:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104968:	a1 ac 6f 12 c0       	mov    0xc0126fac,%eax
c010496d:	8b 40 10             	mov    0x10(%eax),%eax
c0104970:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104973:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104977:	8b 55 08             	mov    0x8(%ebp),%edx
c010497a:	89 14 24             	mov    %edx,(%esp)
c010497d:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c010497f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104982:	89 04 24             	mov    %eax,(%esp)
c0104985:	e8 c5 fd ff ff       	call   c010474f <__intr_restore>
}
c010498a:	90                   	nop
c010498b:	89 ec                	mov    %ebp,%esp
c010498d:	5d                   	pop    %ebp
c010498e:	c3                   	ret    

c010498f <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c010498f:	55                   	push   %ebp
c0104990:	89 e5                	mov    %esp,%ebp
c0104992:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0104995:	e8 89 fd ff ff       	call   c0104723 <__intr_save>
c010499a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c010499d:	a1 ac 6f 12 c0       	mov    0xc0126fac,%eax
c01049a2:	8b 40 14             	mov    0x14(%eax),%eax
c01049a5:	ff d0                	call   *%eax
c01049a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c01049aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049ad:	89 04 24             	mov    %eax,(%esp)
c01049b0:	e8 9a fd ff ff       	call   c010474f <__intr_restore>
    return ret;
c01049b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01049b8:	89 ec                	mov    %ebp,%esp
c01049ba:	5d                   	pop    %ebp
c01049bb:	c3                   	ret    

c01049bc <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c01049bc:	55                   	push   %ebp
c01049bd:	89 e5                	mov    %esp,%ebp
c01049bf:	57                   	push   %edi
c01049c0:	56                   	push   %esi
c01049c1:	53                   	push   %ebx
c01049c2:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c01049c8:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c01049cf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c01049d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c01049dd:	c7 04 24 1f 9c 10 c0 	movl   $0xc0109c1f,(%esp)
c01049e4:	e8 7c b9 ff ff       	call   c0100365 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01049e9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01049f0:	e9 0c 01 00 00       	jmp    c0104b01 <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01049f5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01049f8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01049fb:	89 d0                	mov    %edx,%eax
c01049fd:	c1 e0 02             	shl    $0x2,%eax
c0104a00:	01 d0                	add    %edx,%eax
c0104a02:	c1 e0 02             	shl    $0x2,%eax
c0104a05:	01 c8                	add    %ecx,%eax
c0104a07:	8b 50 08             	mov    0x8(%eax),%edx
c0104a0a:	8b 40 04             	mov    0x4(%eax),%eax
c0104a0d:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0104a10:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0104a13:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104a16:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a19:	89 d0                	mov    %edx,%eax
c0104a1b:	c1 e0 02             	shl    $0x2,%eax
c0104a1e:	01 d0                	add    %edx,%eax
c0104a20:	c1 e0 02             	shl    $0x2,%eax
c0104a23:	01 c8                	add    %ecx,%eax
c0104a25:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104a28:	8b 58 10             	mov    0x10(%eax),%ebx
c0104a2b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104a2e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104a31:	01 c8                	add    %ecx,%eax
c0104a33:	11 da                	adc    %ebx,%edx
c0104a35:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104a38:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104a3b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104a3e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a41:	89 d0                	mov    %edx,%eax
c0104a43:	c1 e0 02             	shl    $0x2,%eax
c0104a46:	01 d0                	add    %edx,%eax
c0104a48:	c1 e0 02             	shl    $0x2,%eax
c0104a4b:	01 c8                	add    %ecx,%eax
c0104a4d:	83 c0 14             	add    $0x14,%eax
c0104a50:	8b 00                	mov    (%eax),%eax
c0104a52:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104a58:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104a5b:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104a5e:	83 c0 ff             	add    $0xffffffff,%eax
c0104a61:	83 d2 ff             	adc    $0xffffffff,%edx
c0104a64:	89 c6                	mov    %eax,%esi
c0104a66:	89 d7                	mov    %edx,%edi
c0104a68:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104a6b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a6e:	89 d0                	mov    %edx,%eax
c0104a70:	c1 e0 02             	shl    $0x2,%eax
c0104a73:	01 d0                	add    %edx,%eax
c0104a75:	c1 e0 02             	shl    $0x2,%eax
c0104a78:	01 c8                	add    %ecx,%eax
c0104a7a:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104a7d:	8b 58 10             	mov    0x10(%eax),%ebx
c0104a80:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104a86:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104a8a:	89 74 24 14          	mov    %esi,0x14(%esp)
c0104a8e:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0104a92:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104a95:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104a98:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104a9c:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104aa0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0104aa4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104aa8:	c7 04 24 2c 9c 10 c0 	movl   $0xc0109c2c,(%esp)
c0104aaf:	e8 b1 b8 ff ff       	call   c0100365 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0104ab4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104ab7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104aba:	89 d0                	mov    %edx,%eax
c0104abc:	c1 e0 02             	shl    $0x2,%eax
c0104abf:	01 d0                	add    %edx,%eax
c0104ac1:	c1 e0 02             	shl    $0x2,%eax
c0104ac4:	01 c8                	add    %ecx,%eax
c0104ac6:	83 c0 14             	add    $0x14,%eax
c0104ac9:	8b 00                	mov    (%eax),%eax
c0104acb:	83 f8 01             	cmp    $0x1,%eax
c0104ace:	75 2e                	jne    c0104afe <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
c0104ad0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ad3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104ad6:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0104ad9:	89 d0                	mov    %edx,%eax
c0104adb:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c0104ade:	73 1e                	jae    c0104afe <page_init+0x142>
c0104ae0:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c0104ae5:	b8 00 00 00 00       	mov    $0x0,%eax
c0104aea:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c0104aed:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c0104af0:	72 0c                	jb     c0104afe <page_init+0x142>
                maxpa = end;
c0104af2:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104af5:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104af8:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104afb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0104afe:	ff 45 dc             	incl   -0x24(%ebp)
c0104b01:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104b04:	8b 00                	mov    (%eax),%eax
c0104b06:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104b09:	0f 8c e6 fe ff ff    	jl     c01049f5 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104b0f:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0104b14:	b8 00 00 00 00       	mov    $0x0,%eax
c0104b19:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0104b1c:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0104b1f:	73 0e                	jae    c0104b2f <page_init+0x173>
        maxpa = KMEMSIZE;
c0104b21:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104b28:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104b2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104b32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104b35:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104b39:	c1 ea 0c             	shr    $0xc,%edx
c0104b3c:	a3 a4 6f 12 c0       	mov    %eax,0xc0126fa4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104b41:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0104b48:	b8 14 71 12 c0       	mov    $0xc0127114,%eax
c0104b4d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104b50:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104b53:	01 d0                	add    %edx,%eax
c0104b55:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0104b58:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104b5b:	ba 00 00 00 00       	mov    $0x0,%edx
c0104b60:	f7 75 c0             	divl   -0x40(%ebp)
c0104b63:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104b66:	29 d0                	sub    %edx,%eax
c0104b68:	a3 a0 6f 12 c0       	mov    %eax,0xc0126fa0

    for (i = 0; i < npage; i ++) {
c0104b6d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104b74:	eb 28                	jmp    c0104b9e <page_init+0x1e2>
        SetPageReserved(pages + i);
c0104b76:	8b 15 a0 6f 12 c0    	mov    0xc0126fa0,%edx
c0104b7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104b7f:	c1 e0 05             	shl    $0x5,%eax
c0104b82:	01 d0                	add    %edx,%eax
c0104b84:	83 c0 04             	add    $0x4,%eax
c0104b87:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0104b8e:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104b91:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104b94:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104b97:	0f ab 10             	bts    %edx,(%eax)
}
c0104b9a:	90                   	nop
    for (i = 0; i < npage; i ++) {
c0104b9b:	ff 45 dc             	incl   -0x24(%ebp)
c0104b9e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ba1:	a1 a4 6f 12 c0       	mov    0xc0126fa4,%eax
c0104ba6:	39 c2                	cmp    %eax,%edx
c0104ba8:	72 cc                	jb     c0104b76 <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0104baa:	a1 a4 6f 12 c0       	mov    0xc0126fa4,%eax
c0104baf:	c1 e0 05             	shl    $0x5,%eax
c0104bb2:	89 c2                	mov    %eax,%edx
c0104bb4:	a1 a0 6f 12 c0       	mov    0xc0126fa0,%eax
c0104bb9:	01 d0                	add    %edx,%eax
c0104bbb:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104bbe:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0104bc5:	77 23                	ja     c0104bea <page_init+0x22e>
c0104bc7:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104bca:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104bce:	c7 44 24 08 b8 9b 10 	movl   $0xc0109bb8,0x8(%esp)
c0104bd5:	c0 
c0104bd6:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0104bdd:	00 
c0104bde:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0104be5:	e8 07 c1 ff ff       	call   c0100cf1 <__panic>
c0104bea:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104bed:	05 00 00 00 40       	add    $0x40000000,%eax
c0104bf2:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104bf5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104bfc:	e9 53 01 00 00       	jmp    c0104d54 <page_init+0x398>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104c01:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104c04:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104c07:	89 d0                	mov    %edx,%eax
c0104c09:	c1 e0 02             	shl    $0x2,%eax
c0104c0c:	01 d0                	add    %edx,%eax
c0104c0e:	c1 e0 02             	shl    $0x2,%eax
c0104c11:	01 c8                	add    %ecx,%eax
c0104c13:	8b 50 08             	mov    0x8(%eax),%edx
c0104c16:	8b 40 04             	mov    0x4(%eax),%eax
c0104c19:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104c1c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104c1f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104c22:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104c25:	89 d0                	mov    %edx,%eax
c0104c27:	c1 e0 02             	shl    $0x2,%eax
c0104c2a:	01 d0                	add    %edx,%eax
c0104c2c:	c1 e0 02             	shl    $0x2,%eax
c0104c2f:	01 c8                	add    %ecx,%eax
c0104c31:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104c34:	8b 58 10             	mov    0x10(%eax),%ebx
c0104c37:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104c3a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104c3d:	01 c8                	add    %ecx,%eax
c0104c3f:	11 da                	adc    %ebx,%edx
c0104c41:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104c44:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104c47:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104c4a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104c4d:	89 d0                	mov    %edx,%eax
c0104c4f:	c1 e0 02             	shl    $0x2,%eax
c0104c52:	01 d0                	add    %edx,%eax
c0104c54:	c1 e0 02             	shl    $0x2,%eax
c0104c57:	01 c8                	add    %ecx,%eax
c0104c59:	83 c0 14             	add    $0x14,%eax
c0104c5c:	8b 00                	mov    (%eax),%eax
c0104c5e:	83 f8 01             	cmp    $0x1,%eax
c0104c61:	0f 85 ea 00 00 00    	jne    c0104d51 <page_init+0x395>
            if (begin < freemem) {
c0104c67:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104c6a:	ba 00 00 00 00       	mov    $0x0,%edx
c0104c6f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104c72:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0104c75:	19 d1                	sbb    %edx,%ecx
c0104c77:	73 0d                	jae    c0104c86 <page_init+0x2ca>
                begin = freemem;
c0104c79:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104c7c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104c7f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104c86:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0104c8b:	b8 00 00 00 00       	mov    $0x0,%eax
c0104c90:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c0104c93:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0104c96:	73 0e                	jae    c0104ca6 <page_init+0x2ea>
                end = KMEMSIZE;
c0104c98:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104c9f:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104ca6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104ca9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104cac:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104caf:	89 d0                	mov    %edx,%eax
c0104cb1:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0104cb4:	0f 83 97 00 00 00    	jae    c0104d51 <page_init+0x395>
                begin = ROUNDUP(begin, PGSIZE);
c0104cba:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0104cc1:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104cc4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104cc7:	01 d0                	add    %edx,%eax
c0104cc9:	48                   	dec    %eax
c0104cca:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0104ccd:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104cd0:	ba 00 00 00 00       	mov    $0x0,%edx
c0104cd5:	f7 75 b0             	divl   -0x50(%ebp)
c0104cd8:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104cdb:	29 d0                	sub    %edx,%eax
c0104cdd:	ba 00 00 00 00       	mov    $0x0,%edx
c0104ce2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104ce5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104ce8:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104ceb:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104cee:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104cf1:	ba 00 00 00 00       	mov    $0x0,%edx
c0104cf6:	89 c7                	mov    %eax,%edi
c0104cf8:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104cfe:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104d01:	89 d0                	mov    %edx,%eax
c0104d03:	83 e0 00             	and    $0x0,%eax
c0104d06:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104d09:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104d0c:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104d0f:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104d12:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104d15:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104d18:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104d1b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104d1e:	89 d0                	mov    %edx,%eax
c0104d20:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0104d23:	73 2c                	jae    c0104d51 <page_init+0x395>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104d25:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104d28:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104d2b:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0104d2e:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0104d31:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104d35:	c1 ea 0c             	shr    $0xc,%edx
c0104d38:	89 c3                	mov    %eax,%ebx
c0104d3a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104d3d:	89 04 24             	mov    %eax,(%esp)
c0104d40:	e8 54 f8 ff ff       	call   c0104599 <pa2page>
c0104d45:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104d49:	89 04 24             	mov    %eax,(%esp)
c0104d4c:	e8 7a fb ff ff       	call   c01048cb <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c0104d51:	ff 45 dc             	incl   -0x24(%ebp)
c0104d54:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104d57:	8b 00                	mov    (%eax),%eax
c0104d59:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104d5c:	0f 8c 9f fe ff ff    	jl     c0104c01 <page_init+0x245>
                }
            }
        }
    }
}
c0104d62:	90                   	nop
c0104d63:	90                   	nop
c0104d64:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104d6a:	5b                   	pop    %ebx
c0104d6b:	5e                   	pop    %esi
c0104d6c:	5f                   	pop    %edi
c0104d6d:	5d                   	pop    %ebp
c0104d6e:	c3                   	ret    

c0104d6f <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104d6f:	55                   	push   %ebp
c0104d70:	89 e5                	mov    %esp,%ebp
c0104d72:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104d75:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d78:	33 45 14             	xor    0x14(%ebp),%eax
c0104d7b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104d80:	85 c0                	test   %eax,%eax
c0104d82:	74 24                	je     c0104da8 <boot_map_segment+0x39>
c0104d84:	c7 44 24 0c 6a 9c 10 	movl   $0xc0109c6a,0xc(%esp)
c0104d8b:	c0 
c0104d8c:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0104d93:	c0 
c0104d94:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0104d9b:	00 
c0104d9c:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0104da3:	e8 49 bf ff ff       	call   c0100cf1 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104da8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104daf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104db2:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104db7:	89 c2                	mov    %eax,%edx
c0104db9:	8b 45 10             	mov    0x10(%ebp),%eax
c0104dbc:	01 c2                	add    %eax,%edx
c0104dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dc1:	01 d0                	add    %edx,%eax
c0104dc3:	48                   	dec    %eax
c0104dc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104dc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104dca:	ba 00 00 00 00       	mov    $0x0,%edx
c0104dcf:	f7 75 f0             	divl   -0x10(%ebp)
c0104dd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104dd5:	29 d0                	sub    %edx,%eax
c0104dd7:	c1 e8 0c             	shr    $0xc,%eax
c0104dda:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104de0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104de3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104de6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104deb:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104dee:	8b 45 14             	mov    0x14(%ebp),%eax
c0104df1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104df4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104df7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104dfc:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104dff:	eb 68                	jmp    c0104e69 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104e01:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104e08:	00 
c0104e09:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104e0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104e10:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e13:	89 04 24             	mov    %eax,(%esp)
c0104e16:	e8 88 01 00 00       	call   c0104fa3 <get_pte>
c0104e1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104e1e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104e22:	75 24                	jne    c0104e48 <boot_map_segment+0xd9>
c0104e24:	c7 44 24 0c 96 9c 10 	movl   $0xc0109c96,0xc(%esp)
c0104e2b:	c0 
c0104e2c:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0104e33:	c0 
c0104e34:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c0104e3b:	00 
c0104e3c:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0104e43:	e8 a9 be ff ff       	call   c0100cf1 <__panic>
        *ptep = pa | PTE_P | perm;
c0104e48:	8b 45 14             	mov    0x14(%ebp),%eax
c0104e4b:	0b 45 18             	or     0x18(%ebp),%eax
c0104e4e:	83 c8 01             	or     $0x1,%eax
c0104e51:	89 c2                	mov    %eax,%edx
c0104e53:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e56:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104e58:	ff 4d f4             	decl   -0xc(%ebp)
c0104e5b:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104e62:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104e69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104e6d:	75 92                	jne    c0104e01 <boot_map_segment+0x92>
    }
}
c0104e6f:	90                   	nop
c0104e70:	90                   	nop
c0104e71:	89 ec                	mov    %ebp,%esp
c0104e73:	5d                   	pop    %ebp
c0104e74:	c3                   	ret    

c0104e75 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104e75:	55                   	push   %ebp
c0104e76:	89 e5                	mov    %esp,%ebp
c0104e78:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104e7b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e82:	e8 66 fa ff ff       	call   c01048ed <alloc_pages>
c0104e87:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104e8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104e8e:	75 1c                	jne    c0104eac <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104e90:	c7 44 24 08 a3 9c 10 	movl   $0xc0109ca3,0x8(%esp)
c0104e97:	c0 
c0104e98:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c0104e9f:	00 
c0104ea0:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0104ea7:	e8 45 be ff ff       	call   c0100cf1 <__panic>
    }
    return page2kva(p);
c0104eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eaf:	89 04 24             	mov    %eax,(%esp)
c0104eb2:	e8 2a f7 ff ff       	call   c01045e1 <page2kva>
}
c0104eb7:	89 ec                	mov    %ebp,%esp
c0104eb9:	5d                   	pop    %ebp
c0104eba:	c3                   	ret    

c0104ebb <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104ebb:	55                   	push   %ebp
c0104ebc:	89 e5                	mov    %esp,%ebp
c0104ebe:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0104ec1:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0104ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104ec9:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104ed0:	77 23                	ja     c0104ef5 <pmm_init+0x3a>
c0104ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ed5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ed9:	c7 44 24 08 b8 9b 10 	movl   $0xc0109bb8,0x8(%esp)
c0104ee0:	c0 
c0104ee1:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0104ee8:	00 
c0104ee9:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0104ef0:	e8 fc bd ff ff       	call   c0100cf1 <__panic>
c0104ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ef8:	05 00 00 00 40       	add    $0x40000000,%eax
c0104efd:	a3 a8 6f 12 c0       	mov    %eax,0xc0126fa8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104f02:	e8 8e f9 ff ff       	call   c0104895 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104f07:	e8 b0 fa ff ff       	call   c01049bc <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104f0c:	e8 df 04 00 00       	call   c01053f0 <check_alloc_page>

    check_pgdir();
c0104f11:	e8 fb 04 00 00       	call   c0105411 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104f16:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0104f1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104f1e:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104f25:	77 23                	ja     c0104f4a <pmm_init+0x8f>
c0104f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f2a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f2e:	c7 44 24 08 b8 9b 10 	movl   $0xc0109bb8,0x8(%esp)
c0104f35:	c0 
c0104f36:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c0104f3d:	00 
c0104f3e:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0104f45:	e8 a7 bd ff ff       	call   c0100cf1 <__panic>
c0104f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f4d:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0104f53:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0104f58:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104f5d:	83 ca 03             	or     $0x3,%edx
c0104f60:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104f62:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0104f67:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104f6e:	00 
c0104f6f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104f76:	00 
c0104f77:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104f7e:	38 
c0104f7f:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104f86:	c0 
c0104f87:	89 04 24             	mov    %eax,(%esp)
c0104f8a:	e8 e0 fd ff ff       	call   c0104d6f <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104f8f:	e8 15 f8 ff ff       	call   c01047a9 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104f94:	e8 16 0b 00 00       	call   c0105aaf <check_boot_pgdir>

    print_pgdir();
c0104f99:	e8 93 0f 00 00       	call   c0105f31 <print_pgdir>

}
c0104f9e:	90                   	nop
c0104f9f:	89 ec                	mov    %ebp,%esp
c0104fa1:	5d                   	pop    %ebp
c0104fa2:	c3                   	ret    

c0104fa3 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104fa3:	55                   	push   %ebp
c0104fa4:	89 e5                	mov    %esp,%ebp
c0104fa6:	83 ec 38             	sub    $0x38,%esp
    }
    return NULL;          // (8) return page table entry
#endif
    // (1) find page directory entry
    // 获取页目录表中给定线性地址对应到的页目录项
    pde_t *pdep = pgdir + PDX(la);
c0104fa9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104fac:	c1 e8 16             	shr    $0x16,%eax
c0104faf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104fb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fb9:	01 d0                	add    %edx,%eax
c0104fbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 获取到该物理页的虚拟地址
    pte_t *ptep = (pte_t *)(KADDR(*pdep & ~0XFFF)); 
c0104fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fc1:	8b 00                	mov    (%eax),%eax
c0104fc3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104fc8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104fcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104fce:	c1 e8 0c             	shr    $0xc,%eax
c0104fd1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104fd4:	a1 a4 6f 12 c0       	mov    0xc0126fa4,%eax
c0104fd9:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104fdc:	72 23                	jb     c0105001 <get_pte+0x5e>
c0104fde:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104fe1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104fe5:	c7 44 24 08 94 9b 10 	movl   $0xc0109b94,0x8(%esp)
c0104fec:	c0 
c0104fed:	c7 44 24 04 7b 01 00 	movl   $0x17b,0x4(%esp)
c0104ff4:	00 
c0104ff5:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0104ffc:	e8 f0 bc ff ff       	call   c0100cf1 <__panic>
c0105001:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105004:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105009:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // (2) check if entry is not present
    // 判断页目录项是否不存在
    if (!(*pdep & PTE_P)) {
c010500c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010500f:	8b 00                	mov    (%eax),%eax
c0105011:	83 e0 01             	and    $0x1,%eax
c0105014:	85 c0                	test   %eax,%eax
c0105016:	0f 85 c6 00 00 00    	jne    c01050e2 <get_pte+0x13f>
        // (3) check if creating is needed, then alloc page for page table
        // CAUTION: this page is used for page table, not for common data page
        // 判断是否需要创建新的页表, 不需要则返回NULL
        if (!create){
c010501c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105020:	75 0a                	jne    c010502c <get_pte+0x89>
            return NULL;
c0105022:	b8 00 00 00 00       	mov    $0x0,%eax
c0105027:	e9 cd 00 00 00       	jmp    c01050f9 <get_pte+0x156>
        }
        // 分配一个页, 如果物理空间不足则返回NULL
        struct Page* pt = alloc_page(); 
c010502c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105033:	e8 b5 f8 ff ff       	call   c01048ed <alloc_pages>
c0105038:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (pt == NULL){
c010503b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010503f:	75 0a                	jne    c010504b <get_pte+0xa8>
            return NULL;
c0105041:	b8 00 00 00 00       	mov    $0x0,%eax
c0105046:	e9 ae 00 00 00       	jmp    c01050f9 <get_pte+0x156>
        }
        // (4) set page reference
        // 更新该物理页的引用计数
        set_page_ref(pt, 1);
c010504b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105052:	00 
c0105053:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105056:	89 04 24             	mov    %eax,(%esp)
c0105059:	e8 89 f6 ff ff       	call   c01046e7 <set_page_ref>
        // (5) get linear address of page
        // 获取到该物理页的虚拟地址(此时已经启动了page机制，内核地址空间)(CPU执行的指令中使用的已经是虚拟地址了)
        ptep = KADDR(page2pa(pt));
c010505e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105061:	89 04 24             	mov    %eax,(%esp)
c0105064:	e8 18 f5 ff ff       	call   c0104581 <page2pa>
c0105069:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010506c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010506f:	c1 e8 0c             	shr    $0xc,%eax
c0105072:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105075:	a1 a4 6f 12 c0       	mov    0xc0126fa4,%eax
c010507a:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010507d:	72 23                	jb     c01050a2 <get_pte+0xff>
c010507f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105082:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105086:	c7 44 24 08 94 9b 10 	movl   $0xc0109b94,0x8(%esp)
c010508d:	c0 
c010508e:	c7 44 24 04 8f 01 00 	movl   $0x18f,0x4(%esp)
c0105095:	00 
c0105096:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c010509d:	e8 4f bc ff ff       	call   c0100cf1 <__panic>
c01050a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050a5:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01050aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // (6) clear page content using memset
        // 对新创建的页表进行初始化
        memset(ptep, 0, PGSIZE);
c01050ad:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01050b4:	00 
c01050b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01050bc:	00 
c01050bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050c0:	89 04 24             	mov    %eax,(%esp)
c01050c3:	e8 2d 3c 00 00       	call   c0108cf5 <memset>
        // (7) set page directory entry's permission
        // 对原先的页目录项进行设置: 对应页表的物理地址, 标志位(存在位, 读写位, 特权级)
        *pdep = (page2pa(pt) & ~0XFFF) | PTE_USER;
c01050c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01050cb:	89 04 24             	mov    %eax,(%esp)
c01050ce:	e8 ae f4 ff ff       	call   c0104581 <page2pa>
c01050d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01050d8:	83 c8 07             	or     $0x7,%eax
c01050db:	89 c2                	mov    %eax,%edx
c01050dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050e0:	89 10                	mov    %edx,(%eax)
    }
    // (8) return page table entry
    // 返回线性地址对应的页表项
    return ptep + PTX(la);
c01050e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050e5:	c1 e8 0c             	shr    $0xc,%eax
c01050e8:	25 ff 03 00 00       	and    $0x3ff,%eax
c01050ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01050f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050f7:	01 d0                	add    %edx,%eax
}
c01050f9:	89 ec                	mov    %ebp,%esp
c01050fb:	5d                   	pop    %ebp
c01050fc:	c3                   	ret    

c01050fd <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01050fd:	55                   	push   %ebp
c01050fe:	89 e5                	mov    %esp,%ebp
c0105100:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105103:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010510a:	00 
c010510b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010510e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105112:	8b 45 08             	mov    0x8(%ebp),%eax
c0105115:	89 04 24             	mov    %eax,(%esp)
c0105118:	e8 86 fe ff ff       	call   c0104fa3 <get_pte>
c010511d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0105120:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105124:	74 08                	je     c010512e <get_page+0x31>
        *ptep_store = ptep;
c0105126:	8b 45 10             	mov    0x10(%ebp),%eax
c0105129:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010512c:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c010512e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105132:	74 1b                	je     c010514f <get_page+0x52>
c0105134:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105137:	8b 00                	mov    (%eax),%eax
c0105139:	83 e0 01             	and    $0x1,%eax
c010513c:	85 c0                	test   %eax,%eax
c010513e:	74 0f                	je     c010514f <get_page+0x52>
        return pte2page(*ptep);
c0105140:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105143:	8b 00                	mov    (%eax),%eax
c0105145:	89 04 24             	mov    %eax,(%esp)
c0105148:	e8 36 f5 ff ff       	call   c0104683 <pte2page>
c010514d:	eb 05                	jmp    c0105154 <get_page+0x57>
    }
    return NULL;
c010514f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105154:	89 ec                	mov    %ebp,%esp
c0105156:	5d                   	pop    %ebp
c0105157:	c3                   	ret    

c0105158 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0105158:	55                   	push   %ebp
c0105159:	89 e5                	mov    %esp,%ebp
c010515b:	83 ec 28             	sub    $0x28,%esp
                                  //(6) flush tlb
    }
#endif
    // (1) check if this page table entry is present
    // 如果二级表项存在
    if (*ptep & PTE_P) {
c010515e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105161:	8b 00                	mov    (%eax),%eax
c0105163:	83 e0 01             	and    $0x1,%eax
c0105166:	85 c0                	test   %eax,%eax
c0105168:	74 53                	je     c01051bd <page_remove_pte+0x65>
        // (2) find corresponding page to pte
        // 获取物理页对应的Page结构
        struct Page *page = pte2page(*ptep);
c010516a:	8b 45 10             	mov    0x10(%ebp),%eax
c010516d:	8b 00                	mov    (%eax),%eax
c010516f:	89 04 24             	mov    %eax,(%esp)
c0105172:	e8 0c f5 ff ff       	call   c0104683 <pte2page>
c0105177:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // (3) decrease page reference
        // (4) and free this page when page reference reachs 0
        // 减少引用计数, 如果该页的引用计数变成0，释放该物理页
        if (page_ref_dec(page)==0){
c010517a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010517d:	89 04 24             	mov    %eax,(%esp)
c0105180:	e8 87 f5 ff ff       	call   c010470c <page_ref_dec>
c0105185:	85 c0                	test   %eax,%eax
c0105187:	75 13                	jne    c010519c <page_remove_pte+0x44>
            free_page(page);
c0105189:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105190:	00 
c0105191:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105194:	89 04 24             	mov    %eax,(%esp)
c0105197:	e8 be f7 ff ff       	call   c010495a <free_pages>
        }
        // (5) clear second page table entry
        // 将PTE的存在位设置为0(表示该映射关系无效)
        *ptep &= (~PTE_P); 
c010519c:	8b 45 10             	mov    0x10(%ebp),%eax
c010519f:	8b 00                	mov    (%eax),%eax
c01051a1:	83 e0 fe             	and    $0xfffffffe,%eax
c01051a4:	89 c2                	mov    %eax,%edx
c01051a6:	8b 45 10             	mov    0x10(%ebp),%eax
c01051a9:	89 10                	mov    %edx,(%eax)
        // (6) flush tlb
        // 刷新TLB(保证TLB中的缓存不会有错误的映射关系)
        tlb_invalidate(pgdir, la);
c01051ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01051b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01051b5:	89 04 24             	mov    %eax,(%esp)
c01051b8:	e8 07 01 00 00       	call   c01052c4 <tlb_invalidate>
    }
}
c01051bd:	90                   	nop
c01051be:	89 ec                	mov    %ebp,%esp
c01051c0:	5d                   	pop    %ebp
c01051c1:	c3                   	ret    

c01051c2 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01051c2:	55                   	push   %ebp
c01051c3:	89 e5                	mov    %esp,%ebp
c01051c5:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01051c8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01051cf:	00 
c01051d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01051d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01051da:	89 04 24             	mov    %eax,(%esp)
c01051dd:	e8 c1 fd ff ff       	call   c0104fa3 <get_pte>
c01051e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01051e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01051e9:	74 19                	je     c0105204 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01051eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051ee:	89 44 24 08          	mov    %eax,0x8(%esp)
c01051f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01051f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01051fc:	89 04 24             	mov    %eax,(%esp)
c01051ff:	e8 54 ff ff ff       	call   c0105158 <page_remove_pte>
    }
}
c0105204:	90                   	nop
c0105205:	89 ec                	mov    %ebp,%esp
c0105207:	5d                   	pop    %ebp
c0105208:	c3                   	ret    

c0105209 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0105209:	55                   	push   %ebp
c010520a:	89 e5                	mov    %esp,%ebp
c010520c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010520f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105216:	00 
c0105217:	8b 45 10             	mov    0x10(%ebp),%eax
c010521a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010521e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105221:	89 04 24             	mov    %eax,(%esp)
c0105224:	e8 7a fd ff ff       	call   c0104fa3 <get_pte>
c0105229:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010522c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105230:	75 0a                	jne    c010523c <page_insert+0x33>
        return -E_NO_MEM;
c0105232:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105237:	e9 84 00 00 00       	jmp    c01052c0 <page_insert+0xb7>
    }
    page_ref_inc(page);
c010523c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010523f:	89 04 24             	mov    %eax,(%esp)
c0105242:	e8 ae f4 ff ff       	call   c01046f5 <page_ref_inc>
    if (*ptep & PTE_P) {
c0105247:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010524a:	8b 00                	mov    (%eax),%eax
c010524c:	83 e0 01             	and    $0x1,%eax
c010524f:	85 c0                	test   %eax,%eax
c0105251:	74 3e                	je     c0105291 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0105253:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105256:	8b 00                	mov    (%eax),%eax
c0105258:	89 04 24             	mov    %eax,(%esp)
c010525b:	e8 23 f4 ff ff       	call   c0104683 <pte2page>
c0105260:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0105263:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105266:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105269:	75 0d                	jne    c0105278 <page_insert+0x6f>
            page_ref_dec(page);
c010526b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010526e:	89 04 24             	mov    %eax,(%esp)
c0105271:	e8 96 f4 ff ff       	call   c010470c <page_ref_dec>
c0105276:	eb 19                	jmp    c0105291 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0105278:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010527b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010527f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105282:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105286:	8b 45 08             	mov    0x8(%ebp),%eax
c0105289:	89 04 24             	mov    %eax,(%esp)
c010528c:	e8 c7 fe ff ff       	call   c0105158 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105291:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105294:	89 04 24             	mov    %eax,(%esp)
c0105297:	e8 e5 f2 ff ff       	call   c0104581 <page2pa>
c010529c:	0b 45 14             	or     0x14(%ebp),%eax
c010529f:	83 c8 01             	or     $0x1,%eax
c01052a2:	89 c2                	mov    %eax,%edx
c01052a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052a7:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01052a9:	8b 45 10             	mov    0x10(%ebp),%eax
c01052ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01052b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01052b3:	89 04 24             	mov    %eax,(%esp)
c01052b6:	e8 09 00 00 00       	call   c01052c4 <tlb_invalidate>
    return 0;
c01052bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01052c0:	89 ec                	mov    %ebp,%esp
c01052c2:	5d                   	pop    %ebp
c01052c3:	c3                   	ret    

c01052c4 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01052c4:	55                   	push   %ebp
c01052c5:	89 e5                	mov    %esp,%ebp
c01052c7:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01052ca:	0f 20 d8             	mov    %cr3,%eax
c01052cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01052d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01052d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01052d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01052d9:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01052e0:	77 23                	ja     c0105305 <tlb_invalidate+0x41>
c01052e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01052e9:	c7 44 24 08 b8 9b 10 	movl   $0xc0109bb8,0x8(%esp)
c01052f0:	c0 
c01052f1:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c01052f8:	00 
c01052f9:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105300:	e8 ec b9 ff ff       	call   c0100cf1 <__panic>
c0105305:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105308:	05 00 00 00 40       	add    $0x40000000,%eax
c010530d:	39 d0                	cmp    %edx,%eax
c010530f:	75 0d                	jne    c010531e <tlb_invalidate+0x5a>
        invlpg((void *)la);
c0105311:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105314:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0105317:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010531a:	0f 01 38             	invlpg (%eax)
}
c010531d:	90                   	nop
    }
}
c010531e:	90                   	nop
c010531f:	89 ec                	mov    %ebp,%esp
c0105321:	5d                   	pop    %ebp
c0105322:	c3                   	ret    

c0105323 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0105323:	55                   	push   %ebp
c0105324:	89 e5                	mov    %esp,%ebp
c0105326:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c0105329:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105330:	e8 b8 f5 ff ff       	call   c01048ed <alloc_pages>
c0105335:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0105338:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010533c:	0f 84 a7 00 00 00    	je     c01053e9 <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c0105342:	8b 45 10             	mov    0x10(%ebp),%eax
c0105345:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105349:	8b 45 0c             	mov    0xc(%ebp),%eax
c010534c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105350:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105353:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105357:	8b 45 08             	mov    0x8(%ebp),%eax
c010535a:	89 04 24             	mov    %eax,(%esp)
c010535d:	e8 a7 fe ff ff       	call   c0105209 <page_insert>
c0105362:	85 c0                	test   %eax,%eax
c0105364:	74 1a                	je     c0105380 <pgdir_alloc_page+0x5d>
            free_page(page);
c0105366:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010536d:	00 
c010536e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105371:	89 04 24             	mov    %eax,(%esp)
c0105374:	e8 e1 f5 ff ff       	call   c010495a <free_pages>
            return NULL;
c0105379:	b8 00 00 00 00       	mov    $0x0,%eax
c010537e:	eb 6c                	jmp    c01053ec <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c0105380:	a1 44 70 12 c0       	mov    0xc0127044,%eax
c0105385:	85 c0                	test   %eax,%eax
c0105387:	74 60                	je     c01053e9 <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c0105389:	a1 0c 71 12 c0       	mov    0xc012710c,%eax
c010538e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105395:	00 
c0105396:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105399:	89 54 24 08          	mov    %edx,0x8(%esp)
c010539d:	8b 55 0c             	mov    0xc(%ebp),%edx
c01053a0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053a4:	89 04 24             	mov    %eax,(%esp)
c01053a7:	e8 79 0f 00 00       	call   c0106325 <swap_map_swappable>
            page->pra_vaddr=la;
c01053ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053af:	8b 55 0c             	mov    0xc(%ebp),%edx
c01053b2:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c01053b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053b8:	89 04 24             	mov    %eax,(%esp)
c01053bb:	e8 1d f3 ff ff       	call   c01046dd <page_ref>
c01053c0:	83 f8 01             	cmp    $0x1,%eax
c01053c3:	74 24                	je     c01053e9 <pgdir_alloc_page+0xc6>
c01053c5:	c7 44 24 0c bc 9c 10 	movl   $0xc0109cbc,0xc(%esp)
c01053cc:	c0 
c01053cd:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c01053d4:	c0 
c01053d5:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c01053dc:	00 
c01053dd:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c01053e4:	e8 08 b9 ff ff       	call   c0100cf1 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c01053e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01053ec:	89 ec                	mov    %ebp,%esp
c01053ee:	5d                   	pop    %ebp
c01053ef:	c3                   	ret    

c01053f0 <check_alloc_page>:

static void
check_alloc_page(void) {
c01053f0:	55                   	push   %ebp
c01053f1:	89 e5                	mov    %esp,%ebp
c01053f3:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01053f6:	a1 ac 6f 12 c0       	mov    0xc0126fac,%eax
c01053fb:	8b 40 18             	mov    0x18(%eax),%eax
c01053fe:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0105400:	c7 04 24 d0 9c 10 c0 	movl   $0xc0109cd0,(%esp)
c0105407:	e8 59 af ff ff       	call   c0100365 <cprintf>
}
c010540c:	90                   	nop
c010540d:	89 ec                	mov    %ebp,%esp
c010540f:	5d                   	pop    %ebp
c0105410:	c3                   	ret    

c0105411 <check_pgdir>:

static void
check_pgdir(void) {
c0105411:	55                   	push   %ebp
c0105412:	89 e5                	mov    %esp,%ebp
c0105414:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0105417:	a1 a4 6f 12 c0       	mov    0xc0126fa4,%eax
c010541c:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0105421:	76 24                	jbe    c0105447 <check_pgdir+0x36>
c0105423:	c7 44 24 0c ef 9c 10 	movl   $0xc0109cef,0xc(%esp)
c010542a:	c0 
c010542b:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0105432:	c0 
c0105433:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c010543a:	00 
c010543b:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105442:	e8 aa b8 ff ff       	call   c0100cf1 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0105447:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c010544c:	85 c0                	test   %eax,%eax
c010544e:	74 0e                	je     c010545e <check_pgdir+0x4d>
c0105450:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0105455:	25 ff 0f 00 00       	and    $0xfff,%eax
c010545a:	85 c0                	test   %eax,%eax
c010545c:	74 24                	je     c0105482 <check_pgdir+0x71>
c010545e:	c7 44 24 0c 0c 9d 10 	movl   $0xc0109d0c,0xc(%esp)
c0105465:	c0 
c0105466:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c010546d:	c0 
c010546e:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0105475:	00 
c0105476:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c010547d:	e8 6f b8 ff ff       	call   c0100cf1 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0105482:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0105487:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010548e:	00 
c010548f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105496:	00 
c0105497:	89 04 24             	mov    %eax,(%esp)
c010549a:	e8 5e fc ff ff       	call   c01050fd <get_page>
c010549f:	85 c0                	test   %eax,%eax
c01054a1:	74 24                	je     c01054c7 <check_pgdir+0xb6>
c01054a3:	c7 44 24 0c 44 9d 10 	movl   $0xc0109d44,0xc(%esp)
c01054aa:	c0 
c01054ab:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c01054b2:	c0 
c01054b3:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c01054ba:	00 
c01054bb:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c01054c2:	e8 2a b8 ff ff       	call   c0100cf1 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01054c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01054ce:	e8 1a f4 ff ff       	call   c01048ed <alloc_pages>
c01054d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01054d6:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c01054db:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01054e2:	00 
c01054e3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01054ea:	00 
c01054eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054ee:	89 54 24 04          	mov    %edx,0x4(%esp)
c01054f2:	89 04 24             	mov    %eax,(%esp)
c01054f5:	e8 0f fd ff ff       	call   c0105209 <page_insert>
c01054fa:	85 c0                	test   %eax,%eax
c01054fc:	74 24                	je     c0105522 <check_pgdir+0x111>
c01054fe:	c7 44 24 0c 6c 9d 10 	movl   $0xc0109d6c,0xc(%esp)
c0105505:	c0 
c0105506:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c010550d:	c0 
c010550e:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0105515:	00 
c0105516:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c010551d:	e8 cf b7 ff ff       	call   c0100cf1 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0105522:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0105527:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010552e:	00 
c010552f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105536:	00 
c0105537:	89 04 24             	mov    %eax,(%esp)
c010553a:	e8 64 fa ff ff       	call   c0104fa3 <get_pte>
c010553f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105542:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105546:	75 24                	jne    c010556c <check_pgdir+0x15b>
c0105548:	c7 44 24 0c 98 9d 10 	movl   $0xc0109d98,0xc(%esp)
c010554f:	c0 
c0105550:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0105557:	c0 
c0105558:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c010555f:	00 
c0105560:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105567:	e8 85 b7 ff ff       	call   c0100cf1 <__panic>
    assert(pte2page(*ptep) == p1);
c010556c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010556f:	8b 00                	mov    (%eax),%eax
c0105571:	89 04 24             	mov    %eax,(%esp)
c0105574:	e8 0a f1 ff ff       	call   c0104683 <pte2page>
c0105579:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010557c:	74 24                	je     c01055a2 <check_pgdir+0x191>
c010557e:	c7 44 24 0c c5 9d 10 	movl   $0xc0109dc5,0xc(%esp)
c0105585:	c0 
c0105586:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c010558d:	c0 
c010558e:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c0105595:	00 
c0105596:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c010559d:	e8 4f b7 ff ff       	call   c0100cf1 <__panic>
    assert(page_ref(p1) == 1);
c01055a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055a5:	89 04 24             	mov    %eax,(%esp)
c01055a8:	e8 30 f1 ff ff       	call   c01046dd <page_ref>
c01055ad:	83 f8 01             	cmp    $0x1,%eax
c01055b0:	74 24                	je     c01055d6 <check_pgdir+0x1c5>
c01055b2:	c7 44 24 0c db 9d 10 	movl   $0xc0109ddb,0xc(%esp)
c01055b9:	c0 
c01055ba:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c01055c1:	c0 
c01055c2:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c01055c9:	00 
c01055ca:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c01055d1:	e8 1b b7 ff ff       	call   c0100cf1 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01055d6:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c01055db:	8b 00                	mov    (%eax),%eax
c01055dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01055e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01055e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01055e8:	c1 e8 0c             	shr    $0xc,%eax
c01055eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01055ee:	a1 a4 6f 12 c0       	mov    0xc0126fa4,%eax
c01055f3:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01055f6:	72 23                	jb     c010561b <check_pgdir+0x20a>
c01055f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01055fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01055ff:	c7 44 24 08 94 9b 10 	movl   $0xc0109b94,0x8(%esp)
c0105606:	c0 
c0105607:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c010560e:	00 
c010560f:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105616:	e8 d6 b6 ff ff       	call   c0100cf1 <__panic>
c010561b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010561e:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105623:	83 c0 04             	add    $0x4,%eax
c0105626:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0105629:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c010562e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105635:	00 
c0105636:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010563d:	00 
c010563e:	89 04 24             	mov    %eax,(%esp)
c0105641:	e8 5d f9 ff ff       	call   c0104fa3 <get_pte>
c0105646:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0105649:	74 24                	je     c010566f <check_pgdir+0x25e>
c010564b:	c7 44 24 0c f0 9d 10 	movl   $0xc0109df0,0xc(%esp)
c0105652:	c0 
c0105653:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c010565a:	c0 
c010565b:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0105662:	00 
c0105663:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c010566a:	e8 82 b6 ff ff       	call   c0100cf1 <__panic>

    p2 = alloc_page();
c010566f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105676:	e8 72 f2 ff ff       	call   c01048ed <alloc_pages>
c010567b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010567e:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0105683:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c010568a:	00 
c010568b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105692:	00 
c0105693:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105696:	89 54 24 04          	mov    %edx,0x4(%esp)
c010569a:	89 04 24             	mov    %eax,(%esp)
c010569d:	e8 67 fb ff ff       	call   c0105209 <page_insert>
c01056a2:	85 c0                	test   %eax,%eax
c01056a4:	74 24                	je     c01056ca <check_pgdir+0x2b9>
c01056a6:	c7 44 24 0c 18 9e 10 	movl   $0xc0109e18,0xc(%esp)
c01056ad:	c0 
c01056ae:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c01056b5:	c0 
c01056b6:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c01056bd:	00 
c01056be:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c01056c5:	e8 27 b6 ff ff       	call   c0100cf1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01056ca:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c01056cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01056d6:	00 
c01056d7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01056de:	00 
c01056df:	89 04 24             	mov    %eax,(%esp)
c01056e2:	e8 bc f8 ff ff       	call   c0104fa3 <get_pte>
c01056e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01056ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01056ee:	75 24                	jne    c0105714 <check_pgdir+0x303>
c01056f0:	c7 44 24 0c 50 9e 10 	movl   $0xc0109e50,0xc(%esp)
c01056f7:	c0 
c01056f8:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c01056ff:	c0 
c0105700:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0105707:	00 
c0105708:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c010570f:	e8 dd b5 ff ff       	call   c0100cf1 <__panic>
    assert(*ptep & PTE_U);
c0105714:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105717:	8b 00                	mov    (%eax),%eax
c0105719:	83 e0 04             	and    $0x4,%eax
c010571c:	85 c0                	test   %eax,%eax
c010571e:	75 24                	jne    c0105744 <check_pgdir+0x333>
c0105720:	c7 44 24 0c 80 9e 10 	movl   $0xc0109e80,0xc(%esp)
c0105727:	c0 
c0105728:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c010572f:	c0 
c0105730:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c0105737:	00 
c0105738:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c010573f:	e8 ad b5 ff ff       	call   c0100cf1 <__panic>
    assert(*ptep & PTE_W);
c0105744:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105747:	8b 00                	mov    (%eax),%eax
c0105749:	83 e0 02             	and    $0x2,%eax
c010574c:	85 c0                	test   %eax,%eax
c010574e:	75 24                	jne    c0105774 <check_pgdir+0x363>
c0105750:	c7 44 24 0c 8e 9e 10 	movl   $0xc0109e8e,0xc(%esp)
c0105757:	c0 
c0105758:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c010575f:	c0 
c0105760:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c0105767:	00 
c0105768:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c010576f:	e8 7d b5 ff ff       	call   c0100cf1 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105774:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0105779:	8b 00                	mov    (%eax),%eax
c010577b:	83 e0 04             	and    $0x4,%eax
c010577e:	85 c0                	test   %eax,%eax
c0105780:	75 24                	jne    c01057a6 <check_pgdir+0x395>
c0105782:	c7 44 24 0c 9c 9e 10 	movl   $0xc0109e9c,0xc(%esp)
c0105789:	c0 
c010578a:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0105791:	c0 
c0105792:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c0105799:	00 
c010579a:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c01057a1:	e8 4b b5 ff ff       	call   c0100cf1 <__panic>
    assert(page_ref(p2) == 1);
c01057a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057a9:	89 04 24             	mov    %eax,(%esp)
c01057ac:	e8 2c ef ff ff       	call   c01046dd <page_ref>
c01057b1:	83 f8 01             	cmp    $0x1,%eax
c01057b4:	74 24                	je     c01057da <check_pgdir+0x3c9>
c01057b6:	c7 44 24 0c b2 9e 10 	movl   $0xc0109eb2,0xc(%esp)
c01057bd:	c0 
c01057be:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c01057c5:	c0 
c01057c6:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c01057cd:	00 
c01057ce:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c01057d5:	e8 17 b5 ff ff       	call   c0100cf1 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01057da:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c01057df:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01057e6:	00 
c01057e7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01057ee:	00 
c01057ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057f2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01057f6:	89 04 24             	mov    %eax,(%esp)
c01057f9:	e8 0b fa ff ff       	call   c0105209 <page_insert>
c01057fe:	85 c0                	test   %eax,%eax
c0105800:	74 24                	je     c0105826 <check_pgdir+0x415>
c0105802:	c7 44 24 0c c4 9e 10 	movl   $0xc0109ec4,0xc(%esp)
c0105809:	c0 
c010580a:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0105811:	c0 
c0105812:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c0105819:	00 
c010581a:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105821:	e8 cb b4 ff ff       	call   c0100cf1 <__panic>
    assert(page_ref(p1) == 2);
c0105826:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105829:	89 04 24             	mov    %eax,(%esp)
c010582c:	e8 ac ee ff ff       	call   c01046dd <page_ref>
c0105831:	83 f8 02             	cmp    $0x2,%eax
c0105834:	74 24                	je     c010585a <check_pgdir+0x449>
c0105836:	c7 44 24 0c f0 9e 10 	movl   $0xc0109ef0,0xc(%esp)
c010583d:	c0 
c010583e:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0105845:	c0 
c0105846:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c010584d:	00 
c010584e:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105855:	e8 97 b4 ff ff       	call   c0100cf1 <__panic>
    assert(page_ref(p2) == 0);
c010585a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010585d:	89 04 24             	mov    %eax,(%esp)
c0105860:	e8 78 ee ff ff       	call   c01046dd <page_ref>
c0105865:	85 c0                	test   %eax,%eax
c0105867:	74 24                	je     c010588d <check_pgdir+0x47c>
c0105869:	c7 44 24 0c 02 9f 10 	movl   $0xc0109f02,0xc(%esp)
c0105870:	c0 
c0105871:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0105878:	c0 
c0105879:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
c0105880:	00 
c0105881:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105888:	e8 64 b4 ff ff       	call   c0100cf1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010588d:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0105892:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105899:	00 
c010589a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01058a1:	00 
c01058a2:	89 04 24             	mov    %eax,(%esp)
c01058a5:	e8 f9 f6 ff ff       	call   c0104fa3 <get_pte>
c01058aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01058b1:	75 24                	jne    c01058d7 <check_pgdir+0x4c6>
c01058b3:	c7 44 24 0c 50 9e 10 	movl   $0xc0109e50,0xc(%esp)
c01058ba:	c0 
c01058bb:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c01058c2:	c0 
c01058c3:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
c01058ca:	00 
c01058cb:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c01058d2:	e8 1a b4 ff ff       	call   c0100cf1 <__panic>
    assert(pte2page(*ptep) == p1);
c01058d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058da:	8b 00                	mov    (%eax),%eax
c01058dc:	89 04 24             	mov    %eax,(%esp)
c01058df:	e8 9f ed ff ff       	call   c0104683 <pte2page>
c01058e4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01058e7:	74 24                	je     c010590d <check_pgdir+0x4fc>
c01058e9:	c7 44 24 0c c5 9d 10 	movl   $0xc0109dc5,0xc(%esp)
c01058f0:	c0 
c01058f1:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c01058f8:	c0 
c01058f9:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c0105900:	00 
c0105901:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105908:	e8 e4 b3 ff ff       	call   c0100cf1 <__panic>
    assert((*ptep & PTE_U) == 0);
c010590d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105910:	8b 00                	mov    (%eax),%eax
c0105912:	83 e0 04             	and    $0x4,%eax
c0105915:	85 c0                	test   %eax,%eax
c0105917:	74 24                	je     c010593d <check_pgdir+0x52c>
c0105919:	c7 44 24 0c 14 9f 10 	movl   $0xc0109f14,0xc(%esp)
c0105920:	c0 
c0105921:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0105928:	c0 
c0105929:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0105930:	00 
c0105931:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105938:	e8 b4 b3 ff ff       	call   c0100cf1 <__panic>

    page_remove(boot_pgdir, 0x0);
c010593d:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0105942:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105949:	00 
c010594a:	89 04 24             	mov    %eax,(%esp)
c010594d:	e8 70 f8 ff ff       	call   c01051c2 <page_remove>
    assert(page_ref(p1) == 1);
c0105952:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105955:	89 04 24             	mov    %eax,(%esp)
c0105958:	e8 80 ed ff ff       	call   c01046dd <page_ref>
c010595d:	83 f8 01             	cmp    $0x1,%eax
c0105960:	74 24                	je     c0105986 <check_pgdir+0x575>
c0105962:	c7 44 24 0c db 9d 10 	movl   $0xc0109ddb,0xc(%esp)
c0105969:	c0 
c010596a:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0105971:	c0 
c0105972:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
c0105979:	00 
c010597a:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105981:	e8 6b b3 ff ff       	call   c0100cf1 <__panic>
    assert(page_ref(p2) == 0);
c0105986:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105989:	89 04 24             	mov    %eax,(%esp)
c010598c:	e8 4c ed ff ff       	call   c01046dd <page_ref>
c0105991:	85 c0                	test   %eax,%eax
c0105993:	74 24                	je     c01059b9 <check_pgdir+0x5a8>
c0105995:	c7 44 24 0c 02 9f 10 	movl   $0xc0109f02,0xc(%esp)
c010599c:	c0 
c010599d:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c01059a4:	c0 
c01059a5:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
c01059ac:	00 
c01059ad:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c01059b4:	e8 38 b3 ff ff       	call   c0100cf1 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c01059b9:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c01059be:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01059c5:	00 
c01059c6:	89 04 24             	mov    %eax,(%esp)
c01059c9:	e8 f4 f7 ff ff       	call   c01051c2 <page_remove>
    assert(page_ref(p1) == 0);
c01059ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059d1:	89 04 24             	mov    %eax,(%esp)
c01059d4:	e8 04 ed ff ff       	call   c01046dd <page_ref>
c01059d9:	85 c0                	test   %eax,%eax
c01059db:	74 24                	je     c0105a01 <check_pgdir+0x5f0>
c01059dd:	c7 44 24 0c 29 9f 10 	movl   $0xc0109f29,0xc(%esp)
c01059e4:	c0 
c01059e5:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c01059ec:	c0 
c01059ed:	c7 44 24 04 4e 02 00 	movl   $0x24e,0x4(%esp)
c01059f4:	00 
c01059f5:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c01059fc:	e8 f0 b2 ff ff       	call   c0100cf1 <__panic>
    assert(page_ref(p2) == 0);
c0105a01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a04:	89 04 24             	mov    %eax,(%esp)
c0105a07:	e8 d1 ec ff ff       	call   c01046dd <page_ref>
c0105a0c:	85 c0                	test   %eax,%eax
c0105a0e:	74 24                	je     c0105a34 <check_pgdir+0x623>
c0105a10:	c7 44 24 0c 02 9f 10 	movl   $0xc0109f02,0xc(%esp)
c0105a17:	c0 
c0105a18:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0105a1f:	c0 
c0105a20:	c7 44 24 04 4f 02 00 	movl   $0x24f,0x4(%esp)
c0105a27:	00 
c0105a28:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105a2f:	e8 bd b2 ff ff       	call   c0100cf1 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0105a34:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0105a39:	8b 00                	mov    (%eax),%eax
c0105a3b:	89 04 24             	mov    %eax,(%esp)
c0105a3e:	e8 80 ec ff ff       	call   c01046c3 <pde2page>
c0105a43:	89 04 24             	mov    %eax,(%esp)
c0105a46:	e8 92 ec ff ff       	call   c01046dd <page_ref>
c0105a4b:	83 f8 01             	cmp    $0x1,%eax
c0105a4e:	74 24                	je     c0105a74 <check_pgdir+0x663>
c0105a50:	c7 44 24 0c 3c 9f 10 	movl   $0xc0109f3c,0xc(%esp)
c0105a57:	c0 
c0105a58:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0105a5f:	c0 
c0105a60:	c7 44 24 04 51 02 00 	movl   $0x251,0x4(%esp)
c0105a67:	00 
c0105a68:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105a6f:	e8 7d b2 ff ff       	call   c0100cf1 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0105a74:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0105a79:	8b 00                	mov    (%eax),%eax
c0105a7b:	89 04 24             	mov    %eax,(%esp)
c0105a7e:	e8 40 ec ff ff       	call   c01046c3 <pde2page>
c0105a83:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105a8a:	00 
c0105a8b:	89 04 24             	mov    %eax,(%esp)
c0105a8e:	e8 c7 ee ff ff       	call   c010495a <free_pages>
    boot_pgdir[0] = 0;
c0105a93:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0105a98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0105a9e:	c7 04 24 63 9f 10 c0 	movl   $0xc0109f63,(%esp)
c0105aa5:	e8 bb a8 ff ff       	call   c0100365 <cprintf>
}
c0105aaa:	90                   	nop
c0105aab:	89 ec                	mov    %ebp,%esp
c0105aad:	5d                   	pop    %ebp
c0105aae:	c3                   	ret    

c0105aaf <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0105aaf:	55                   	push   %ebp
c0105ab0:	89 e5                	mov    %esp,%ebp
c0105ab2:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105ab5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105abc:	e9 ca 00 00 00       	jmp    c0105b8b <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0105ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ac4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105ac7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105aca:	c1 e8 0c             	shr    $0xc,%eax
c0105acd:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105ad0:	a1 a4 6f 12 c0       	mov    0xc0126fa4,%eax
c0105ad5:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0105ad8:	72 23                	jb     c0105afd <check_boot_pgdir+0x4e>
c0105ada:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105add:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105ae1:	c7 44 24 08 94 9b 10 	movl   $0xc0109b94,0x8(%esp)
c0105ae8:	c0 
c0105ae9:	c7 44 24 04 5d 02 00 	movl   $0x25d,0x4(%esp)
c0105af0:	00 
c0105af1:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105af8:	e8 f4 b1 ff ff       	call   c0100cf1 <__panic>
c0105afd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b00:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105b05:	89 c2                	mov    %eax,%edx
c0105b07:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0105b0c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105b13:	00 
c0105b14:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105b18:	89 04 24             	mov    %eax,(%esp)
c0105b1b:	e8 83 f4 ff ff       	call   c0104fa3 <get_pte>
c0105b20:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105b23:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105b27:	75 24                	jne    c0105b4d <check_boot_pgdir+0x9e>
c0105b29:	c7 44 24 0c 80 9f 10 	movl   $0xc0109f80,0xc(%esp)
c0105b30:	c0 
c0105b31:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0105b38:	c0 
c0105b39:	c7 44 24 04 5d 02 00 	movl   $0x25d,0x4(%esp)
c0105b40:	00 
c0105b41:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105b48:	e8 a4 b1 ff ff       	call   c0100cf1 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0105b4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105b50:	8b 00                	mov    (%eax),%eax
c0105b52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105b57:	89 c2                	mov    %eax,%edx
c0105b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b5c:	39 c2                	cmp    %eax,%edx
c0105b5e:	74 24                	je     c0105b84 <check_boot_pgdir+0xd5>
c0105b60:	c7 44 24 0c bd 9f 10 	movl   $0xc0109fbd,0xc(%esp)
c0105b67:	c0 
c0105b68:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0105b6f:	c0 
c0105b70:	c7 44 24 04 5e 02 00 	movl   $0x25e,0x4(%esp)
c0105b77:	00 
c0105b78:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105b7f:	e8 6d b1 ff ff       	call   c0100cf1 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0105b84:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0105b8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b8e:	a1 a4 6f 12 c0       	mov    0xc0126fa4,%eax
c0105b93:	39 c2                	cmp    %eax,%edx
c0105b95:	0f 82 26 ff ff ff    	jb     c0105ac1 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0105b9b:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0105ba0:	05 ac 0f 00 00       	add    $0xfac,%eax
c0105ba5:	8b 00                	mov    (%eax),%eax
c0105ba7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105bac:	89 c2                	mov    %eax,%edx
c0105bae:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0105bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bb6:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0105bbd:	77 23                	ja     c0105be2 <check_boot_pgdir+0x133>
c0105bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bc2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105bc6:	c7 44 24 08 b8 9b 10 	movl   $0xc0109bb8,0x8(%esp)
c0105bcd:	c0 
c0105bce:	c7 44 24 04 61 02 00 	movl   $0x261,0x4(%esp)
c0105bd5:	00 
c0105bd6:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105bdd:	e8 0f b1 ff ff       	call   c0100cf1 <__panic>
c0105be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105be5:	05 00 00 00 40       	add    $0x40000000,%eax
c0105bea:	39 d0                	cmp    %edx,%eax
c0105bec:	74 24                	je     c0105c12 <check_boot_pgdir+0x163>
c0105bee:	c7 44 24 0c d4 9f 10 	movl   $0xc0109fd4,0xc(%esp)
c0105bf5:	c0 
c0105bf6:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0105bfd:	c0 
c0105bfe:	c7 44 24 04 61 02 00 	movl   $0x261,0x4(%esp)
c0105c05:	00 
c0105c06:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105c0d:	e8 df b0 ff ff       	call   c0100cf1 <__panic>

    assert(boot_pgdir[0] == 0);
c0105c12:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0105c17:	8b 00                	mov    (%eax),%eax
c0105c19:	85 c0                	test   %eax,%eax
c0105c1b:	74 24                	je     c0105c41 <check_boot_pgdir+0x192>
c0105c1d:	c7 44 24 0c 08 a0 10 	movl   $0xc010a008,0xc(%esp)
c0105c24:	c0 
c0105c25:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0105c2c:	c0 
c0105c2d:	c7 44 24 04 63 02 00 	movl   $0x263,0x4(%esp)
c0105c34:	00 
c0105c35:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105c3c:	e8 b0 b0 ff ff       	call   c0100cf1 <__panic>

    struct Page *p;
    p = alloc_page();
c0105c41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105c48:	e8 a0 ec ff ff       	call   c01048ed <alloc_pages>
c0105c4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105c50:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0105c55:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105c5c:	00 
c0105c5d:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105c64:	00 
c0105c65:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105c68:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105c6c:	89 04 24             	mov    %eax,(%esp)
c0105c6f:	e8 95 f5 ff ff       	call   c0105209 <page_insert>
c0105c74:	85 c0                	test   %eax,%eax
c0105c76:	74 24                	je     c0105c9c <check_boot_pgdir+0x1ed>
c0105c78:	c7 44 24 0c 1c a0 10 	movl   $0xc010a01c,0xc(%esp)
c0105c7f:	c0 
c0105c80:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0105c87:	c0 
c0105c88:	c7 44 24 04 67 02 00 	movl   $0x267,0x4(%esp)
c0105c8f:	00 
c0105c90:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105c97:	e8 55 b0 ff ff       	call   c0100cf1 <__panic>
    assert(page_ref(p) == 1);
c0105c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c9f:	89 04 24             	mov    %eax,(%esp)
c0105ca2:	e8 36 ea ff ff       	call   c01046dd <page_ref>
c0105ca7:	83 f8 01             	cmp    $0x1,%eax
c0105caa:	74 24                	je     c0105cd0 <check_boot_pgdir+0x221>
c0105cac:	c7 44 24 0c 4a a0 10 	movl   $0xc010a04a,0xc(%esp)
c0105cb3:	c0 
c0105cb4:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0105cbb:	c0 
c0105cbc:	c7 44 24 04 68 02 00 	movl   $0x268,0x4(%esp)
c0105cc3:	00 
c0105cc4:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105ccb:	e8 21 b0 ff ff       	call   c0100cf1 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105cd0:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0105cd5:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105cdc:	00 
c0105cdd:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105ce4:	00 
c0105ce5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105ce8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105cec:	89 04 24             	mov    %eax,(%esp)
c0105cef:	e8 15 f5 ff ff       	call   c0105209 <page_insert>
c0105cf4:	85 c0                	test   %eax,%eax
c0105cf6:	74 24                	je     c0105d1c <check_boot_pgdir+0x26d>
c0105cf8:	c7 44 24 0c 5c a0 10 	movl   $0xc010a05c,0xc(%esp)
c0105cff:	c0 
c0105d00:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0105d07:	c0 
c0105d08:	c7 44 24 04 69 02 00 	movl   $0x269,0x4(%esp)
c0105d0f:	00 
c0105d10:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105d17:	e8 d5 af ff ff       	call   c0100cf1 <__panic>
    assert(page_ref(p) == 2);
c0105d1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d1f:	89 04 24             	mov    %eax,(%esp)
c0105d22:	e8 b6 e9 ff ff       	call   c01046dd <page_ref>
c0105d27:	83 f8 02             	cmp    $0x2,%eax
c0105d2a:	74 24                	je     c0105d50 <check_boot_pgdir+0x2a1>
c0105d2c:	c7 44 24 0c 93 a0 10 	movl   $0xc010a093,0xc(%esp)
c0105d33:	c0 
c0105d34:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0105d3b:	c0 
c0105d3c:	c7 44 24 04 6a 02 00 	movl   $0x26a,0x4(%esp)
c0105d43:	00 
c0105d44:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105d4b:	e8 a1 af ff ff       	call   c0100cf1 <__panic>

    const char *str = "ucore: Hello world!!";
c0105d50:	c7 45 e8 a4 a0 10 c0 	movl   $0xc010a0a4,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0105d57:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d5a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d5e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105d65:	e8 bb 2c 00 00       	call   c0108a25 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105d6a:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105d71:	00 
c0105d72:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105d79:	e8 1f 2d 00 00       	call   c0108a9d <strcmp>
c0105d7e:	85 c0                	test   %eax,%eax
c0105d80:	74 24                	je     c0105da6 <check_boot_pgdir+0x2f7>
c0105d82:	c7 44 24 0c bc a0 10 	movl   $0xc010a0bc,0xc(%esp)
c0105d89:	c0 
c0105d8a:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0105d91:	c0 
c0105d92:	c7 44 24 04 6e 02 00 	movl   $0x26e,0x4(%esp)
c0105d99:	00 
c0105d9a:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105da1:	e8 4b af ff ff       	call   c0100cf1 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105da6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105da9:	89 04 24             	mov    %eax,(%esp)
c0105dac:	e8 30 e8 ff ff       	call   c01045e1 <page2kva>
c0105db1:	05 00 01 00 00       	add    $0x100,%eax
c0105db6:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105db9:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105dc0:	e8 06 2c 00 00       	call   c01089cb <strlen>
c0105dc5:	85 c0                	test   %eax,%eax
c0105dc7:	74 24                	je     c0105ded <check_boot_pgdir+0x33e>
c0105dc9:	c7 44 24 0c f4 a0 10 	movl   $0xc010a0f4,0xc(%esp)
c0105dd0:	c0 
c0105dd1:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0105dd8:	c0 
c0105dd9:	c7 44 24 04 71 02 00 	movl   $0x271,0x4(%esp)
c0105de0:	00 
c0105de1:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0105de8:	e8 04 af ff ff       	call   c0100cf1 <__panic>

    free_page(p);
c0105ded:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105df4:	00 
c0105df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105df8:	89 04 24             	mov    %eax,(%esp)
c0105dfb:	e8 5a eb ff ff       	call   c010495a <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105e00:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0105e05:	8b 00                	mov    (%eax),%eax
c0105e07:	89 04 24             	mov    %eax,(%esp)
c0105e0a:	e8 b4 e8 ff ff       	call   c01046c3 <pde2page>
c0105e0f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105e16:	00 
c0105e17:	89 04 24             	mov    %eax,(%esp)
c0105e1a:	e8 3b eb ff ff       	call   c010495a <free_pages>
    boot_pgdir[0] = 0;
c0105e1f:	a1 e0 39 12 c0       	mov    0xc01239e0,%eax
c0105e24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105e2a:	c7 04 24 18 a1 10 c0 	movl   $0xc010a118,(%esp)
c0105e31:	e8 2f a5 ff ff       	call   c0100365 <cprintf>
}
c0105e36:	90                   	nop
c0105e37:	89 ec                	mov    %ebp,%esp
c0105e39:	5d                   	pop    %ebp
c0105e3a:	c3                   	ret    

c0105e3b <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105e3b:	55                   	push   %ebp
c0105e3c:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105e3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e41:	83 e0 04             	and    $0x4,%eax
c0105e44:	85 c0                	test   %eax,%eax
c0105e46:	74 04                	je     c0105e4c <perm2str+0x11>
c0105e48:	b0 75                	mov    $0x75,%al
c0105e4a:	eb 02                	jmp    c0105e4e <perm2str+0x13>
c0105e4c:	b0 2d                	mov    $0x2d,%al
c0105e4e:	a2 28 70 12 c0       	mov    %al,0xc0127028
    str[1] = 'r';
c0105e53:	c6 05 29 70 12 c0 72 	movb   $0x72,0xc0127029
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105e5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e5d:	83 e0 02             	and    $0x2,%eax
c0105e60:	85 c0                	test   %eax,%eax
c0105e62:	74 04                	je     c0105e68 <perm2str+0x2d>
c0105e64:	b0 77                	mov    $0x77,%al
c0105e66:	eb 02                	jmp    c0105e6a <perm2str+0x2f>
c0105e68:	b0 2d                	mov    $0x2d,%al
c0105e6a:	a2 2a 70 12 c0       	mov    %al,0xc012702a
    str[3] = '\0';
c0105e6f:	c6 05 2b 70 12 c0 00 	movb   $0x0,0xc012702b
    return str;
c0105e76:	b8 28 70 12 c0       	mov    $0xc0127028,%eax
}
c0105e7b:	5d                   	pop    %ebp
c0105e7c:	c3                   	ret    

c0105e7d <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105e7d:	55                   	push   %ebp
c0105e7e:	89 e5                	mov    %esp,%ebp
c0105e80:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105e83:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e86:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105e89:	72 0d                	jb     c0105e98 <get_pgtable_items+0x1b>
        return 0;
c0105e8b:	b8 00 00 00 00       	mov    $0x0,%eax
c0105e90:	e9 98 00 00 00       	jmp    c0105f2d <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0105e95:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0105e98:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e9b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105e9e:	73 18                	jae    c0105eb8 <get_pgtable_items+0x3b>
c0105ea0:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ea3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105eaa:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ead:	01 d0                	add    %edx,%eax
c0105eaf:	8b 00                	mov    (%eax),%eax
c0105eb1:	83 e0 01             	and    $0x1,%eax
c0105eb4:	85 c0                	test   %eax,%eax
c0105eb6:	74 dd                	je     c0105e95 <get_pgtable_items+0x18>
    }
    if (start < right) {
c0105eb8:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ebb:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105ebe:	73 68                	jae    c0105f28 <get_pgtable_items+0xab>
        if (left_store != NULL) {
c0105ec0:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105ec4:	74 08                	je     c0105ece <get_pgtable_items+0x51>
            *left_store = start;
c0105ec6:	8b 45 18             	mov    0x18(%ebp),%eax
c0105ec9:	8b 55 10             	mov    0x10(%ebp),%edx
c0105ecc:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105ece:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ed1:	8d 50 01             	lea    0x1(%eax),%edx
c0105ed4:	89 55 10             	mov    %edx,0x10(%ebp)
c0105ed7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105ede:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ee1:	01 d0                	add    %edx,%eax
c0105ee3:	8b 00                	mov    (%eax),%eax
c0105ee5:	83 e0 07             	and    $0x7,%eax
c0105ee8:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105eeb:	eb 03                	jmp    c0105ef0 <get_pgtable_items+0x73>
            start ++;
c0105eed:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105ef0:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ef3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105ef6:	73 1d                	jae    c0105f15 <get_pgtable_items+0x98>
c0105ef8:	8b 45 10             	mov    0x10(%ebp),%eax
c0105efb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105f02:	8b 45 14             	mov    0x14(%ebp),%eax
c0105f05:	01 d0                	add    %edx,%eax
c0105f07:	8b 00                	mov    (%eax),%eax
c0105f09:	83 e0 07             	and    $0x7,%eax
c0105f0c:	89 c2                	mov    %eax,%edx
c0105f0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f11:	39 c2                	cmp    %eax,%edx
c0105f13:	74 d8                	je     c0105eed <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c0105f15:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105f19:	74 08                	je     c0105f23 <get_pgtable_items+0xa6>
            *right_store = start;
c0105f1b:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105f1e:	8b 55 10             	mov    0x10(%ebp),%edx
c0105f21:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105f23:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f26:	eb 05                	jmp    c0105f2d <get_pgtable_items+0xb0>
    }
    return 0;
c0105f28:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f2d:	89 ec                	mov    %ebp,%esp
c0105f2f:	5d                   	pop    %ebp
c0105f30:	c3                   	ret    

c0105f31 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105f31:	55                   	push   %ebp
c0105f32:	89 e5                	mov    %esp,%ebp
c0105f34:	57                   	push   %edi
c0105f35:	56                   	push   %esi
c0105f36:	53                   	push   %ebx
c0105f37:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105f3a:	c7 04 24 38 a1 10 c0 	movl   $0xc010a138,(%esp)
c0105f41:	e8 1f a4 ff ff       	call   c0100365 <cprintf>
    size_t left, right = 0, perm;
c0105f46:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105f4d:	e9 f2 00 00 00       	jmp    c0106044 <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105f52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f55:	89 04 24             	mov    %eax,(%esp)
c0105f58:	e8 de fe ff ff       	call   c0105e3b <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105f5d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105f60:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105f63:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105f65:	89 d6                	mov    %edx,%esi
c0105f67:	c1 e6 16             	shl    $0x16,%esi
c0105f6a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105f6d:	89 d3                	mov    %edx,%ebx
c0105f6f:	c1 e3 16             	shl    $0x16,%ebx
c0105f72:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105f75:	89 d1                	mov    %edx,%ecx
c0105f77:	c1 e1 16             	shl    $0x16,%ecx
c0105f7a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105f7d:	8b 7d e0             	mov    -0x20(%ebp),%edi
c0105f80:	29 fa                	sub    %edi,%edx
c0105f82:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105f86:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105f8a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105f8e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105f92:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105f96:	c7 04 24 69 a1 10 c0 	movl   $0xc010a169,(%esp)
c0105f9d:	e8 c3 a3 ff ff       	call   c0100365 <cprintf>
        size_t l, r = left * NPTEENTRY;
c0105fa2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105fa5:	c1 e0 0a             	shl    $0xa,%eax
c0105fa8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105fab:	eb 50                	jmp    c0105ffd <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105fad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105fb0:	89 04 24             	mov    %eax,(%esp)
c0105fb3:	e8 83 fe ff ff       	call   c0105e3b <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105fb8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105fbb:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0105fbe:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105fc0:	89 d6                	mov    %edx,%esi
c0105fc2:	c1 e6 0c             	shl    $0xc,%esi
c0105fc5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105fc8:	89 d3                	mov    %edx,%ebx
c0105fca:	c1 e3 0c             	shl    $0xc,%ebx
c0105fcd:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105fd0:	89 d1                	mov    %edx,%ecx
c0105fd2:	c1 e1 0c             	shl    $0xc,%ecx
c0105fd5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105fd8:	8b 7d d8             	mov    -0x28(%ebp),%edi
c0105fdb:	29 fa                	sub    %edi,%edx
c0105fdd:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105fe1:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105fe5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105fe9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105fed:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105ff1:	c7 04 24 88 a1 10 c0 	movl   $0xc010a188,(%esp)
c0105ff8:	e8 68 a3 ff ff       	call   c0100365 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105ffd:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0106002:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106005:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106008:	89 d3                	mov    %edx,%ebx
c010600a:	c1 e3 0a             	shl    $0xa,%ebx
c010600d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106010:	89 d1                	mov    %edx,%ecx
c0106012:	c1 e1 0a             	shl    $0xa,%ecx
c0106015:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0106018:	89 54 24 14          	mov    %edx,0x14(%esp)
c010601c:	8d 55 d8             	lea    -0x28(%ebp),%edx
c010601f:	89 54 24 10          	mov    %edx,0x10(%esp)
c0106023:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0106027:	89 44 24 08          	mov    %eax,0x8(%esp)
c010602b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010602f:	89 0c 24             	mov    %ecx,(%esp)
c0106032:	e8 46 fe ff ff       	call   c0105e7d <get_pgtable_items>
c0106037:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010603a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010603e:	0f 85 69 ff ff ff    	jne    c0105fad <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106044:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0106049:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010604c:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010604f:	89 54 24 14          	mov    %edx,0x14(%esp)
c0106053:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0106056:	89 54 24 10          	mov    %edx,0x10(%esp)
c010605a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010605e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106062:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0106069:	00 
c010606a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0106071:	e8 07 fe ff ff       	call   c0105e7d <get_pgtable_items>
c0106076:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106079:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010607d:	0f 85 cf fe ff ff    	jne    c0105f52 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0106083:	c7 04 24 ac a1 10 c0 	movl   $0xc010a1ac,(%esp)
c010608a:	e8 d6 a2 ff ff       	call   c0100365 <cprintf>
}
c010608f:	90                   	nop
c0106090:	83 c4 4c             	add    $0x4c,%esp
c0106093:	5b                   	pop    %ebx
c0106094:	5e                   	pop    %esi
c0106095:	5f                   	pop    %edi
c0106096:	5d                   	pop    %ebp
c0106097:	c3                   	ret    

c0106098 <kmalloc>:

void *
kmalloc(size_t n) {
c0106098:	55                   	push   %ebp
c0106099:	89 e5                	mov    %esp,%ebp
c010609b:	83 ec 28             	sub    $0x28,%esp
    void * ptr=NULL;
c010609e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c01060a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c01060ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01060b0:	74 09                	je     c01060bb <kmalloc+0x23>
c01060b2:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c01060b9:	76 24                	jbe    c01060df <kmalloc+0x47>
c01060bb:	c7 44 24 0c dd a1 10 	movl   $0xc010a1dd,0xc(%esp)
c01060c2:	c0 
c01060c3:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c01060ca:	c0 
c01060cb:	c7 44 24 04 bd 02 00 	movl   $0x2bd,0x4(%esp)
c01060d2:	00 
c01060d3:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c01060da:	e8 12 ac ff ff       	call   c0100cf1 <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c01060df:	8b 45 08             	mov    0x8(%ebp),%eax
c01060e2:	05 ff 0f 00 00       	add    $0xfff,%eax
c01060e7:	c1 e8 0c             	shr    $0xc,%eax
c01060ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c01060ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01060f0:	89 04 24             	mov    %eax,(%esp)
c01060f3:	e8 f5 e7 ff ff       	call   c01048ed <alloc_pages>
c01060f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c01060fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01060ff:	75 24                	jne    c0106125 <kmalloc+0x8d>
c0106101:	c7 44 24 0c f4 a1 10 	movl   $0xc010a1f4,0xc(%esp)
c0106108:	c0 
c0106109:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0106110:	c0 
c0106111:	c7 44 24 04 c0 02 00 	movl   $0x2c0,0x4(%esp)
c0106118:	00 
c0106119:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0106120:	e8 cc ab ff ff       	call   c0100cf1 <__panic>
    ptr=page2kva(base);
c0106125:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106128:	89 04 24             	mov    %eax,(%esp)
c010612b:	e8 b1 e4 ff ff       	call   c01045e1 <page2kva>
c0106130:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c0106133:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106136:	89 ec                	mov    %ebp,%esp
c0106138:	5d                   	pop    %ebp
c0106139:	c3                   	ret    

c010613a <kfree>:

void 
kfree(void *ptr, size_t n) {
c010613a:	55                   	push   %ebp
c010613b:	89 e5                	mov    %esp,%ebp
c010613d:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0 && n < 1024*0124);
c0106140:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106144:	74 09                	je     c010614f <kfree+0x15>
c0106146:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c010614d:	76 24                	jbe    c0106173 <kfree+0x39>
c010614f:	c7 44 24 0c dd a1 10 	movl   $0xc010a1dd,0xc(%esp)
c0106156:	c0 
c0106157:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c010615e:	c0 
c010615f:	c7 44 24 04 c7 02 00 	movl   $0x2c7,0x4(%esp)
c0106166:	00 
c0106167:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c010616e:	e8 7e ab ff ff       	call   c0100cf1 <__panic>
    assert(ptr != NULL);
c0106173:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106177:	75 24                	jne    c010619d <kfree+0x63>
c0106179:	c7 44 24 0c 01 a2 10 	movl   $0xc010a201,0xc(%esp)
c0106180:	c0 
c0106181:	c7 44 24 08 81 9c 10 	movl   $0xc0109c81,0x8(%esp)
c0106188:	c0 
c0106189:	c7 44 24 04 c8 02 00 	movl   $0x2c8,0x4(%esp)
c0106190:	00 
c0106191:	c7 04 24 5c 9c 10 c0 	movl   $0xc0109c5c,(%esp)
c0106198:	e8 54 ab ff ff       	call   c0100cf1 <__panic>
    struct Page *base=NULL;
c010619d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c01061a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01061a7:	05 ff 0f 00 00       	add    $0xfff,%eax
c01061ac:	c1 e8 0c             	shr    $0xc,%eax
c01061af:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c01061b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01061b5:	89 04 24             	mov    %eax,(%esp)
c01061b8:	e8 7a e4 ff ff       	call   c0104637 <kva2page>
c01061bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c01061c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01061c3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01061c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061ca:	89 04 24             	mov    %eax,(%esp)
c01061cd:	e8 88 e7 ff ff       	call   c010495a <free_pages>
}
c01061d2:	90                   	nop
c01061d3:	89 ec                	mov    %ebp,%esp
c01061d5:	5d                   	pop    %ebp
c01061d6:	c3                   	ret    

c01061d7 <pa2page>:
pa2page(uintptr_t pa) {
c01061d7:	55                   	push   %ebp
c01061d8:	89 e5                	mov    %esp,%ebp
c01061da:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01061dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01061e0:	c1 e8 0c             	shr    $0xc,%eax
c01061e3:	89 c2                	mov    %eax,%edx
c01061e5:	a1 a4 6f 12 c0       	mov    0xc0126fa4,%eax
c01061ea:	39 c2                	cmp    %eax,%edx
c01061ec:	72 1c                	jb     c010620a <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01061ee:	c7 44 24 08 10 a2 10 	movl   $0xc010a210,0x8(%esp)
c01061f5:	c0 
c01061f6:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01061fd:	00 
c01061fe:	c7 04 24 2f a2 10 c0 	movl   $0xc010a22f,(%esp)
c0106205:	e8 e7 aa ff ff       	call   c0100cf1 <__panic>
    return &pages[PPN(pa)];
c010620a:	8b 15 a0 6f 12 c0    	mov    0xc0126fa0,%edx
c0106210:	8b 45 08             	mov    0x8(%ebp),%eax
c0106213:	c1 e8 0c             	shr    $0xc,%eax
c0106216:	c1 e0 05             	shl    $0x5,%eax
c0106219:	01 d0                	add    %edx,%eax
}
c010621b:	89 ec                	mov    %ebp,%esp
c010621d:	5d                   	pop    %ebp
c010621e:	c3                   	ret    

c010621f <pte2page>:
pte2page(pte_t pte) {
c010621f:	55                   	push   %ebp
c0106220:	89 e5                	mov    %esp,%ebp
c0106222:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0106225:	8b 45 08             	mov    0x8(%ebp),%eax
c0106228:	83 e0 01             	and    $0x1,%eax
c010622b:	85 c0                	test   %eax,%eax
c010622d:	75 1c                	jne    c010624b <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c010622f:	c7 44 24 08 40 a2 10 	movl   $0xc010a240,0x8(%esp)
c0106236:	c0 
c0106237:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c010623e:	00 
c010623f:	c7 04 24 2f a2 10 c0 	movl   $0xc010a22f,(%esp)
c0106246:	e8 a6 aa ff ff       	call   c0100cf1 <__panic>
    return pa2page(PTE_ADDR(pte));
c010624b:	8b 45 08             	mov    0x8(%ebp),%eax
c010624e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106253:	89 04 24             	mov    %eax,(%esp)
c0106256:	e8 7c ff ff ff       	call   c01061d7 <pa2page>
}
c010625b:	89 ec                	mov    %ebp,%esp
c010625d:	5d                   	pop    %ebp
c010625e:	c3                   	ret    

c010625f <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c010625f:	55                   	push   %ebp
c0106260:	89 e5                	mov    %esp,%ebp
c0106262:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0106265:	e8 e2 1e 00 00       	call   c010814c <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c010626a:	a1 40 70 12 c0       	mov    0xc0127040,%eax
c010626f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0106274:	76 0c                	jbe    c0106282 <swap_init+0x23>
c0106276:	a1 40 70 12 c0       	mov    0xc0127040,%eax
c010627b:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0106280:	76 25                	jbe    c01062a7 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0106282:	a1 40 70 12 c0       	mov    0xc0127040,%eax
c0106287:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010628b:	c7 44 24 08 61 a2 10 	movl   $0xc010a261,0x8(%esp)
c0106292:	c0 
c0106293:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
c010629a:	00 
c010629b:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c01062a2:	e8 4a aa ff ff       	call   c0100cf1 <__panic>
     }
     

     sm = &swap_manager_fifo;
c01062a7:	c7 05 00 71 12 c0 40 	movl   $0xc0123a40,0xc0127100
c01062ae:	3a 12 c0 
     //sm = &swap_manager_enhanced_clock;
     int r = sm->init();
c01062b1:	a1 00 71 12 c0       	mov    0xc0127100,%eax
c01062b6:	8b 40 04             	mov    0x4(%eax),%eax
c01062b9:	ff d0                	call   *%eax
c01062bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c01062be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01062c2:	75 26                	jne    c01062ea <swap_init+0x8b>
     {
          swap_init_ok = 1;
c01062c4:	c7 05 44 70 12 c0 01 	movl   $0x1,0xc0127044
c01062cb:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c01062ce:	a1 00 71 12 c0       	mov    0xc0127100,%eax
c01062d3:	8b 00                	mov    (%eax),%eax
c01062d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01062d9:	c7 04 24 8b a2 10 c0 	movl   $0xc010a28b,(%esp)
c01062e0:	e8 80 a0 ff ff       	call   c0100365 <cprintf>
          check_swap();
c01062e5:	e8 b0 04 00 00       	call   c010679a <check_swap>
     }

     return r;
c01062ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01062ed:	89 ec                	mov    %ebp,%esp
c01062ef:	5d                   	pop    %ebp
c01062f0:	c3                   	ret    

c01062f1 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c01062f1:	55                   	push   %ebp
c01062f2:	89 e5                	mov    %esp,%ebp
c01062f4:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c01062f7:	a1 00 71 12 c0       	mov    0xc0127100,%eax
c01062fc:	8b 40 08             	mov    0x8(%eax),%eax
c01062ff:	8b 55 08             	mov    0x8(%ebp),%edx
c0106302:	89 14 24             	mov    %edx,(%esp)
c0106305:	ff d0                	call   *%eax
}
c0106307:	89 ec                	mov    %ebp,%esp
c0106309:	5d                   	pop    %ebp
c010630a:	c3                   	ret    

c010630b <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c010630b:	55                   	push   %ebp
c010630c:	89 e5                	mov    %esp,%ebp
c010630e:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0106311:	a1 00 71 12 c0       	mov    0xc0127100,%eax
c0106316:	8b 40 0c             	mov    0xc(%eax),%eax
c0106319:	8b 55 08             	mov    0x8(%ebp),%edx
c010631c:	89 14 24             	mov    %edx,(%esp)
c010631f:	ff d0                	call   *%eax
}
c0106321:	89 ec                	mov    %ebp,%esp
c0106323:	5d                   	pop    %ebp
c0106324:	c3                   	ret    

c0106325 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106325:	55                   	push   %ebp
c0106326:	89 e5                	mov    %esp,%ebp
c0106328:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c010632b:	a1 00 71 12 c0       	mov    0xc0127100,%eax
c0106330:	8b 40 10             	mov    0x10(%eax),%eax
c0106333:	8b 55 14             	mov    0x14(%ebp),%edx
c0106336:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010633a:	8b 55 10             	mov    0x10(%ebp),%edx
c010633d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106341:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106344:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106348:	8b 55 08             	mov    0x8(%ebp),%edx
c010634b:	89 14 24             	mov    %edx,(%esp)
c010634e:	ff d0                	call   *%eax
}
c0106350:	89 ec                	mov    %ebp,%esp
c0106352:	5d                   	pop    %ebp
c0106353:	c3                   	ret    

c0106354 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106354:	55                   	push   %ebp
c0106355:	89 e5                	mov    %esp,%ebp
c0106357:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c010635a:	a1 00 71 12 c0       	mov    0xc0127100,%eax
c010635f:	8b 40 14             	mov    0x14(%eax),%eax
c0106362:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106365:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106369:	8b 55 08             	mov    0x8(%ebp),%edx
c010636c:	89 14 24             	mov    %edx,(%esp)
c010636f:	ff d0                	call   *%eax
}
c0106371:	89 ec                	mov    %ebp,%esp
c0106373:	5d                   	pop    %ebp
c0106374:	c3                   	ret    

c0106375 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0106375:	55                   	push   %ebp
c0106376:	89 e5                	mov    %esp,%ebp
c0106378:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c010637b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106382:	e9 53 01 00 00       	jmp    c01064da <swap_out+0x165>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0106387:	a1 00 71 12 c0       	mov    0xc0127100,%eax
c010638c:	8b 40 18             	mov    0x18(%eax),%eax
c010638f:	8b 55 10             	mov    0x10(%ebp),%edx
c0106392:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106396:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0106399:	89 54 24 04          	mov    %edx,0x4(%esp)
c010639d:	8b 55 08             	mov    0x8(%ebp),%edx
c01063a0:	89 14 24             	mov    %edx,(%esp)
c01063a3:	ff d0                	call   *%eax
c01063a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c01063a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01063ac:	74 18                	je     c01063c6 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c01063ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01063b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01063b5:	c7 04 24 a0 a2 10 c0 	movl   $0xc010a2a0,(%esp)
c01063bc:	e8 a4 9f ff ff       	call   c0100365 <cprintf>
c01063c1:	e9 20 01 00 00       	jmp    c01064e6 <swap_out+0x171>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c01063c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01063c9:	8b 40 1c             	mov    0x1c(%eax),%eax
c01063cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c01063cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01063d2:	8b 40 0c             	mov    0xc(%eax),%eax
c01063d5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01063dc:	00 
c01063dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01063e0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01063e4:	89 04 24             	mov    %eax,(%esp)
c01063e7:	e8 b7 eb ff ff       	call   c0104fa3 <get_pte>
c01063ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c01063ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01063f2:	8b 00                	mov    (%eax),%eax
c01063f4:	83 e0 01             	and    $0x1,%eax
c01063f7:	85 c0                	test   %eax,%eax
c01063f9:	75 24                	jne    c010641f <swap_out+0xaa>
c01063fb:	c7 44 24 0c cd a2 10 	movl   $0xc010a2cd,0xc(%esp)
c0106402:	c0 
c0106403:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c010640a:	c0 
c010640b:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0106412:	00 
c0106413:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c010641a:	e8 d2 a8 ff ff       	call   c0100cf1 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c010641f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106422:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106425:	8b 52 1c             	mov    0x1c(%edx),%edx
c0106428:	c1 ea 0c             	shr    $0xc,%edx
c010642b:	42                   	inc    %edx
c010642c:	c1 e2 08             	shl    $0x8,%edx
c010642f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106433:	89 14 24             	mov    %edx,(%esp)
c0106436:	e8 d0 1d 00 00       	call   c010820b <swapfs_write>
c010643b:	85 c0                	test   %eax,%eax
c010643d:	74 34                	je     c0106473 <swap_out+0xfe>
                    cprintf("SWAP: failed to save\n");
c010643f:	c7 04 24 f7 a2 10 c0 	movl   $0xc010a2f7,(%esp)
c0106446:	e8 1a 9f ff ff       	call   c0100365 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c010644b:	a1 00 71 12 c0       	mov    0xc0127100,%eax
c0106450:	8b 40 10             	mov    0x10(%eax),%eax
c0106453:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106456:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010645d:	00 
c010645e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106462:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106465:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106469:	8b 55 08             	mov    0x8(%ebp),%edx
c010646c:	89 14 24             	mov    %edx,(%esp)
c010646f:	ff d0                	call   *%eax
c0106471:	eb 64                	jmp    c01064d7 <swap_out+0x162>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0106473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106476:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106479:	c1 e8 0c             	shr    $0xc,%eax
c010647c:	40                   	inc    %eax
c010647d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106481:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106484:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106488:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010648b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010648f:	c7 04 24 10 a3 10 c0 	movl   $0xc010a310,(%esp)
c0106496:	e8 ca 9e ff ff       	call   c0100365 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c010649b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010649e:	8b 40 1c             	mov    0x1c(%eax),%eax
c01064a1:	c1 e8 0c             	shr    $0xc,%eax
c01064a4:	40                   	inc    %eax
c01064a5:	c1 e0 08             	shl    $0x8,%eax
c01064a8:	89 c2                	mov    %eax,%edx
c01064aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01064ad:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c01064af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064b2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01064b9:	00 
c01064ba:	89 04 24             	mov    %eax,(%esp)
c01064bd:	e8 98 e4 ff ff       	call   c010495a <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c01064c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01064c5:	8b 40 0c             	mov    0xc(%eax),%eax
c01064c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01064cb:	89 54 24 04          	mov    %edx,0x4(%esp)
c01064cf:	89 04 24             	mov    %eax,(%esp)
c01064d2:	e8 ed ed ff ff       	call   c01052c4 <tlb_invalidate>
     for (i = 0; i != n; ++ i)
c01064d7:	ff 45 f4             	incl   -0xc(%ebp)
c01064da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01064dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01064e0:	0f 85 a1 fe ff ff    	jne    c0106387 <swap_out+0x12>
     }
     return i;
c01064e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01064e9:	89 ec                	mov    %ebp,%esp
c01064eb:	5d                   	pop    %ebp
c01064ec:	c3                   	ret    

c01064ed <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c01064ed:	55                   	push   %ebp
c01064ee:	89 e5                	mov    %esp,%ebp
c01064f0:	83 ec 28             	sub    $0x28,%esp
     // 分配一个物理页
     struct Page *result = alloc_page();
c01064f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01064fa:	e8 ee e3 ff ff       	call   c01048ed <alloc_pages>
c01064ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0106502:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106506:	75 24                	jne    c010652c <swap_in+0x3f>
c0106508:	c7 44 24 0c 50 a3 10 	movl   $0xc010a350,0xc(%esp)
c010650f:	c0 
c0106510:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c0106517:	c0 
c0106518:	c7 44 24 04 7e 00 00 	movl   $0x7e,0x4(%esp)
c010651f:	00 
c0106520:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c0106527:	e8 c5 a7 ff ff       	call   c0100cf1 <__panic>
     // 获得页表项
     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c010652c:	8b 45 08             	mov    0x8(%ebp),%eax
c010652f:	8b 40 0c             	mov    0xc(%eax),%eax
c0106532:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106539:	00 
c010653a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010653d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106541:	89 04 24             	mov    %eax,(%esp)
c0106544:	e8 5a ea ff ff       	call   c0104fa3 <get_pte>
c0106549:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c010654c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010654f:	8b 00                	mov    (%eax),%eax
c0106551:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106554:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106558:	89 04 24             	mov    %eax,(%esp)
c010655b:	e8 37 1c 00 00       	call   c0108197 <swapfs_read>
c0106560:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106563:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106567:	74 2a                	je     c0106593 <swap_in+0xa6>
     {
        assert(r!=0);
c0106569:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010656d:	75 24                	jne    c0106593 <swap_in+0xa6>
c010656f:	c7 44 24 0c 5d a3 10 	movl   $0xc010a35d,0xc(%esp)
c0106576:	c0 
c0106577:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c010657e:	c0 
c010657f:	c7 44 24 04 86 00 00 	movl   $0x86,0x4(%esp)
c0106586:	00 
c0106587:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c010658e:	e8 5e a7 ff ff       	call   c0100cf1 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0106593:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106596:	8b 00                	mov    (%eax),%eax
c0106598:	c1 e8 08             	shr    $0x8,%eax
c010659b:	89 c2                	mov    %eax,%edx
c010659d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01065a0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01065a4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01065a8:	c7 04 24 64 a3 10 c0 	movl   $0xc010a364,(%esp)
c01065af:	e8 b1 9d ff ff       	call   c0100365 <cprintf>
     *ptr_result=result;
c01065b4:	8b 45 10             	mov    0x10(%ebp),%eax
c01065b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01065ba:	89 10                	mov    %edx,(%eax)
     return 0;
c01065bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01065c1:	89 ec                	mov    %ebp,%esp
c01065c3:	5d                   	pop    %ebp
c01065c4:	c3                   	ret    

c01065c5 <check_content_set>:



static inline void
check_content_set(void)
{
c01065c5:	55                   	push   %ebp
c01065c6:	89 e5                	mov    %esp,%ebp
c01065c8:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c01065cb:	b8 00 10 00 00       	mov    $0x1000,%eax
c01065d0:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01065d3:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c01065d8:	83 f8 01             	cmp    $0x1,%eax
c01065db:	74 24                	je     c0106601 <check_content_set+0x3c>
c01065dd:	c7 44 24 0c a2 a3 10 	movl   $0xc010a3a2,0xc(%esp)
c01065e4:	c0 
c01065e5:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c01065ec:	c0 
c01065ed:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
c01065f4:	00 
c01065f5:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c01065fc:	e8 f0 a6 ff ff       	call   c0100cf1 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0106601:	b8 10 10 00 00       	mov    $0x1010,%eax
c0106606:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106609:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c010660e:	83 f8 01             	cmp    $0x1,%eax
c0106611:	74 24                	je     c0106637 <check_content_set+0x72>
c0106613:	c7 44 24 0c a2 a3 10 	movl   $0xc010a3a2,0xc(%esp)
c010661a:	c0 
c010661b:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c0106622:	c0 
c0106623:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
c010662a:	00 
c010662b:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c0106632:	e8 ba a6 ff ff       	call   c0100cf1 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0106637:	b8 00 20 00 00       	mov    $0x2000,%eax
c010663c:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c010663f:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c0106644:	83 f8 02             	cmp    $0x2,%eax
c0106647:	74 24                	je     c010666d <check_content_set+0xa8>
c0106649:	c7 44 24 0c b1 a3 10 	movl   $0xc010a3b1,0xc(%esp)
c0106650:	c0 
c0106651:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c0106658:	c0 
c0106659:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
c0106660:	00 
c0106661:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c0106668:	e8 84 a6 ff ff       	call   c0100cf1 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c010666d:	b8 10 20 00 00       	mov    $0x2010,%eax
c0106672:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106675:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c010667a:	83 f8 02             	cmp    $0x2,%eax
c010667d:	74 24                	je     c01066a3 <check_content_set+0xde>
c010667f:	c7 44 24 0c b1 a3 10 	movl   $0xc010a3b1,0xc(%esp)
c0106686:	c0 
c0106687:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c010668e:	c0 
c010668f:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
c0106696:	00 
c0106697:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c010669e:	e8 4e a6 ff ff       	call   c0100cf1 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c01066a3:	b8 00 30 00 00       	mov    $0x3000,%eax
c01066a8:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01066ab:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c01066b0:	83 f8 03             	cmp    $0x3,%eax
c01066b3:	74 24                	je     c01066d9 <check_content_set+0x114>
c01066b5:	c7 44 24 0c c0 a3 10 	movl   $0xc010a3c0,0xc(%esp)
c01066bc:	c0 
c01066bd:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c01066c4:	c0 
c01066c5:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
c01066cc:	00 
c01066cd:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c01066d4:	e8 18 a6 ff ff       	call   c0100cf1 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c01066d9:	b8 10 30 00 00       	mov    $0x3010,%eax
c01066de:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01066e1:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c01066e6:	83 f8 03             	cmp    $0x3,%eax
c01066e9:	74 24                	je     c010670f <check_content_set+0x14a>
c01066eb:	c7 44 24 0c c0 a3 10 	movl   $0xc010a3c0,0xc(%esp)
c01066f2:	c0 
c01066f3:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c01066fa:	c0 
c01066fb:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
c0106702:	00 
c0106703:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c010670a:	e8 e2 a5 ff ff       	call   c0100cf1 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c010670f:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106714:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106717:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c010671c:	83 f8 04             	cmp    $0x4,%eax
c010671f:	74 24                	je     c0106745 <check_content_set+0x180>
c0106721:	c7 44 24 0c cf a3 10 	movl   $0xc010a3cf,0xc(%esp)
c0106728:	c0 
c0106729:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c0106730:	c0 
c0106731:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0106738:	00 
c0106739:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c0106740:	e8 ac a5 ff ff       	call   c0100cf1 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0106745:	b8 10 40 00 00       	mov    $0x4010,%eax
c010674a:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c010674d:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c0106752:	83 f8 04             	cmp    $0x4,%eax
c0106755:	74 24                	je     c010677b <check_content_set+0x1b6>
c0106757:	c7 44 24 0c cf a3 10 	movl   $0xc010a3cf,0xc(%esp)
c010675e:	c0 
c010675f:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c0106766:	c0 
c0106767:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
c010676e:	00 
c010676f:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c0106776:	e8 76 a5 ff ff       	call   c0100cf1 <__panic>
}
c010677b:	90                   	nop
c010677c:	89 ec                	mov    %ebp,%esp
c010677e:	5d                   	pop    %ebp
c010677f:	c3                   	ret    

c0106780 <check_content_access>:

static inline int
check_content_access(void)
{
c0106780:	55                   	push   %ebp
c0106781:	89 e5                	mov    %esp,%ebp
c0106783:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0106786:	a1 00 71 12 c0       	mov    0xc0127100,%eax
c010678b:	8b 40 1c             	mov    0x1c(%eax),%eax
c010678e:	ff d0                	call   *%eax
c0106790:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0106793:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106796:	89 ec                	mov    %ebp,%esp
c0106798:	5d                   	pop    %ebp
c0106799:	c3                   	ret    

c010679a <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c010679a:	55                   	push   %ebp
c010679b:	89 e5                	mov    %esp,%ebp
c010679d:	83 ec 78             	sub    $0x78,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c01067a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01067a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c01067ae:	c7 45 e8 84 6f 12 c0 	movl   $0xc0126f84,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c01067b5:	eb 6a                	jmp    c0106821 <check_swap+0x87>
        struct Page *p = le2page(le, page_link);
c01067b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01067ba:	83 e8 0c             	sub    $0xc,%eax
c01067bd:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(PageProperty(p));
c01067c0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01067c3:	83 c0 04             	add    $0x4,%eax
c01067c6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c01067cd:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01067d0:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01067d3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01067d6:	0f a3 10             	bt     %edx,(%eax)
c01067d9:	19 c0                	sbb    %eax,%eax
c01067db:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c01067de:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01067e2:	0f 95 c0             	setne  %al
c01067e5:	0f b6 c0             	movzbl %al,%eax
c01067e8:	85 c0                	test   %eax,%eax
c01067ea:	75 24                	jne    c0106810 <check_swap+0x76>
c01067ec:	c7 44 24 0c de a3 10 	movl   $0xc010a3de,0xc(%esp)
c01067f3:	c0 
c01067f4:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c01067fb:	c0 
c01067fc:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0106803:	00 
c0106804:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c010680b:	e8 e1 a4 ff ff       	call   c0100cf1 <__panic>
        count ++, total += p->property;
c0106810:	ff 45 f4             	incl   -0xc(%ebp)
c0106813:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106816:	8b 50 08             	mov    0x8(%eax),%edx
c0106819:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010681c:	01 d0                	add    %edx,%eax
c010681e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106821:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106824:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106827:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010682a:	8b 40 04             	mov    0x4(%eax),%eax
     while ((le = list_next(le)) != &free_list) {
c010682d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106830:	81 7d e8 84 6f 12 c0 	cmpl   $0xc0126f84,-0x18(%ebp)
c0106837:	0f 85 7a ff ff ff    	jne    c01067b7 <check_swap+0x1d>
     }
     assert(total == nr_free_pages());
c010683d:	e8 4d e1 ff ff       	call   c010498f <nr_free_pages>
c0106842:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106845:	39 d0                	cmp    %edx,%eax
c0106847:	74 24                	je     c010686d <check_swap+0xd3>
c0106849:	c7 44 24 0c ee a3 10 	movl   $0xc010a3ee,0xc(%esp)
c0106850:	c0 
c0106851:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c0106858:	c0 
c0106859:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0106860:	00 
c0106861:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c0106868:	e8 84 a4 ff ff       	call   c0100cf1 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c010686d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106870:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106874:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106877:	89 44 24 04          	mov    %eax,0x4(%esp)
c010687b:	c7 04 24 08 a4 10 c0 	movl   $0xc010a408,(%esp)
c0106882:	e8 de 9a ff ff       	call   c0100365 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0106887:	e8 ed 0a 00 00       	call   c0107379 <mm_create>
c010688c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     assert(mm != NULL);
c010688f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106893:	75 24                	jne    c01068b9 <check_swap+0x11f>
c0106895:	c7 44 24 0c 2e a4 10 	movl   $0xc010a42e,0xc(%esp)
c010689c:	c0 
c010689d:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c01068a4:	c0 
c01068a5:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c01068ac:	00 
c01068ad:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c01068b4:	e8 38 a4 ff ff       	call   c0100cf1 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c01068b9:	a1 0c 71 12 c0       	mov    0xc012710c,%eax
c01068be:	85 c0                	test   %eax,%eax
c01068c0:	74 24                	je     c01068e6 <check_swap+0x14c>
c01068c2:	c7 44 24 0c 39 a4 10 	movl   $0xc010a439,0xc(%esp)
c01068c9:	c0 
c01068ca:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c01068d1:	c0 
c01068d2:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c01068d9:	00 
c01068da:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c01068e1:	e8 0b a4 ff ff       	call   c0100cf1 <__panic>

     check_mm_struct = mm;
c01068e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01068e9:	a3 0c 71 12 c0       	mov    %eax,0xc012710c

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c01068ee:	8b 15 e0 39 12 c0    	mov    0xc01239e0,%edx
c01068f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01068f7:	89 50 0c             	mov    %edx,0xc(%eax)
c01068fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01068fd:	8b 40 0c             	mov    0xc(%eax),%eax
c0106900:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(pgdir[0] == 0);
c0106903:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106906:	8b 00                	mov    (%eax),%eax
c0106908:	85 c0                	test   %eax,%eax
c010690a:	74 24                	je     c0106930 <check_swap+0x196>
c010690c:	c7 44 24 0c 51 a4 10 	movl   $0xc010a451,0xc(%esp)
c0106913:	c0 
c0106914:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c010691b:	c0 
c010691c:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0106923:	00 
c0106924:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c010692b:	e8 c1 a3 ff ff       	call   c0100cf1 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0106930:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0106937:	00 
c0106938:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c010693f:	00 
c0106940:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0106947:	e8 a8 0a 00 00       	call   c01073f4 <vma_create>
c010694c:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(vma != NULL);
c010694f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0106953:	75 24                	jne    c0106979 <check_swap+0x1df>
c0106955:	c7 44 24 0c 5f a4 10 	movl   $0xc010a45f,0xc(%esp)
c010695c:	c0 
c010695d:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c0106964:	c0 
c0106965:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c010696c:	00 
c010696d:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c0106974:	e8 78 a3 ff ff       	call   c0100cf1 <__panic>

     insert_vma_struct(mm, vma);
c0106979:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010697c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106980:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106983:	89 04 24             	mov    %eax,(%esp)
c0106986:	e8 00 0c 00 00       	call   c010758b <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c010698b:	c7 04 24 6c a4 10 c0 	movl   $0xc010a46c,(%esp)
c0106992:	e8 ce 99 ff ff       	call   c0100365 <cprintf>
     pte_t *temp_ptep=NULL;
c0106997:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c010699e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01069a1:	8b 40 0c             	mov    0xc(%eax),%eax
c01069a4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01069ab:	00 
c01069ac:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01069b3:	00 
c01069b4:	89 04 24             	mov    %eax,(%esp)
c01069b7:	e8 e7 e5 ff ff       	call   c0104fa3 <get_pte>
c01069bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(temp_ptep!= NULL);
c01069bf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01069c3:	75 24                	jne    c01069e9 <check_swap+0x24f>
c01069c5:	c7 44 24 0c a0 a4 10 	movl   $0xc010a4a0,0xc(%esp)
c01069cc:	c0 
c01069cd:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c01069d4:	c0 
c01069d5:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c01069dc:	00 
c01069dd:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c01069e4:	e8 08 a3 ff ff       	call   c0100cf1 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c01069e9:	c7 04 24 b4 a4 10 c0 	movl   $0xc010a4b4,(%esp)
c01069f0:	e8 70 99 ff ff       	call   c0100365 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01069f5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01069fc:	e9 a2 00 00 00       	jmp    c0106aa3 <check_swap+0x309>
          check_rp[i] = alloc_page();
c0106a01:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106a08:	e8 e0 de ff ff       	call   c01048ed <alloc_pages>
c0106a0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106a10:	89 04 95 cc 70 12 c0 	mov    %eax,-0x3fed8f34(,%edx,4)
          assert(check_rp[i] != NULL );
c0106a17:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a1a:	8b 04 85 cc 70 12 c0 	mov    -0x3fed8f34(,%eax,4),%eax
c0106a21:	85 c0                	test   %eax,%eax
c0106a23:	75 24                	jne    c0106a49 <check_swap+0x2af>
c0106a25:	c7 44 24 0c d8 a4 10 	movl   $0xc010a4d8,0xc(%esp)
c0106a2c:	c0 
c0106a2d:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c0106a34:	c0 
c0106a35:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0106a3c:	00 
c0106a3d:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c0106a44:	e8 a8 a2 ff ff       	call   c0100cf1 <__panic>
          assert(!PageProperty(check_rp[i]));
c0106a49:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a4c:	8b 04 85 cc 70 12 c0 	mov    -0x3fed8f34(,%eax,4),%eax
c0106a53:	83 c0 04             	add    $0x4,%eax
c0106a56:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0106a5d:	89 45 b0             	mov    %eax,-0x50(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106a60:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106a63:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106a66:	0f a3 10             	bt     %edx,(%eax)
c0106a69:	19 c0                	sbb    %eax,%eax
c0106a6b:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0106a6e:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0106a72:	0f 95 c0             	setne  %al
c0106a75:	0f b6 c0             	movzbl %al,%eax
c0106a78:	85 c0                	test   %eax,%eax
c0106a7a:	74 24                	je     c0106aa0 <check_swap+0x306>
c0106a7c:	c7 44 24 0c ec a4 10 	movl   $0xc010a4ec,0xc(%esp)
c0106a83:	c0 
c0106a84:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c0106a8b:	c0 
c0106a8c:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0106a93:	00 
c0106a94:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c0106a9b:	e8 51 a2 ff ff       	call   c0100cf1 <__panic>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106aa0:	ff 45 ec             	incl   -0x14(%ebp)
c0106aa3:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106aa7:	0f 8e 54 ff ff ff    	jle    c0106a01 <check_swap+0x267>
     }
     list_entry_t free_list_store = free_list;
c0106aad:	a1 84 6f 12 c0       	mov    0xc0126f84,%eax
c0106ab2:	8b 15 88 6f 12 c0    	mov    0xc0126f88,%edx
c0106ab8:	89 45 98             	mov    %eax,-0x68(%ebp)
c0106abb:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0106abe:	c7 45 a4 84 6f 12 c0 	movl   $0xc0126f84,-0x5c(%ebp)
    elm->prev = elm->next = elm;
c0106ac5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106ac8:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0106acb:	89 50 04             	mov    %edx,0x4(%eax)
c0106ace:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106ad1:	8b 50 04             	mov    0x4(%eax),%edx
c0106ad4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106ad7:	89 10                	mov    %edx,(%eax)
}
c0106ad9:	90                   	nop
c0106ada:	c7 45 a8 84 6f 12 c0 	movl   $0xc0126f84,-0x58(%ebp)
    return list->next == list;
c0106ae1:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106ae4:	8b 40 04             	mov    0x4(%eax),%eax
c0106ae7:	39 45 a8             	cmp    %eax,-0x58(%ebp)
c0106aea:	0f 94 c0             	sete   %al
c0106aed:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0106af0:	85 c0                	test   %eax,%eax
c0106af2:	75 24                	jne    c0106b18 <check_swap+0x37e>
c0106af4:	c7 44 24 0c 07 a5 10 	movl   $0xc010a507,0xc(%esp)
c0106afb:	c0 
c0106afc:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c0106b03:	c0 
c0106b04:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0106b0b:	00 
c0106b0c:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c0106b13:	e8 d9 a1 ff ff       	call   c0100cf1 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0106b18:	a1 8c 6f 12 c0       	mov    0xc0126f8c,%eax
c0106b1d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     nr_free = 0;
c0106b20:	c7 05 8c 6f 12 c0 00 	movl   $0x0,0xc0126f8c
c0106b27:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106b2a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106b31:	eb 1d                	jmp    c0106b50 <check_swap+0x3b6>
        free_pages(check_rp[i],1);
c0106b33:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b36:	8b 04 85 cc 70 12 c0 	mov    -0x3fed8f34(,%eax,4),%eax
c0106b3d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106b44:	00 
c0106b45:	89 04 24             	mov    %eax,(%esp)
c0106b48:	e8 0d de ff ff       	call   c010495a <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106b4d:	ff 45 ec             	incl   -0x14(%ebp)
c0106b50:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106b54:	7e dd                	jle    c0106b33 <check_swap+0x399>
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0106b56:	a1 8c 6f 12 c0       	mov    0xc0126f8c,%eax
c0106b5b:	83 f8 04             	cmp    $0x4,%eax
c0106b5e:	74 24                	je     c0106b84 <check_swap+0x3ea>
c0106b60:	c7 44 24 0c 20 a5 10 	movl   $0xc010a520,0xc(%esp)
c0106b67:	c0 
c0106b68:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c0106b6f:	c0 
c0106b70:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0106b77:	00 
c0106b78:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c0106b7f:	e8 6d a1 ff ff       	call   c0100cf1 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0106b84:	c7 04 24 44 a5 10 c0 	movl   $0xc010a544,(%esp)
c0106b8b:	e8 d5 97 ff ff       	call   c0100365 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0106b90:	c7 05 10 71 12 c0 00 	movl   $0x0,0xc0127110
c0106b97:	00 00 00 
     
     check_content_set();
c0106b9a:	e8 26 fa ff ff       	call   c01065c5 <check_content_set>
     assert( nr_free == 0);         
c0106b9f:	a1 8c 6f 12 c0       	mov    0xc0126f8c,%eax
c0106ba4:	85 c0                	test   %eax,%eax
c0106ba6:	74 24                	je     c0106bcc <check_swap+0x432>
c0106ba8:	c7 44 24 0c 6b a5 10 	movl   $0xc010a56b,0xc(%esp)
c0106baf:	c0 
c0106bb0:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c0106bb7:	c0 
c0106bb8:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0106bbf:	00 
c0106bc0:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c0106bc7:	e8 25 a1 ff ff       	call   c0100cf1 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106bcc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106bd3:	eb 25                	jmp    c0106bfa <check_swap+0x460>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0106bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106bd8:	c7 04 85 60 70 12 c0 	movl   $0xffffffff,-0x3fed8fa0(,%eax,4)
c0106bdf:	ff ff ff ff 
c0106be3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106be6:	8b 14 85 60 70 12 c0 	mov    -0x3fed8fa0(,%eax,4),%edx
c0106bed:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106bf0:	89 14 85 a0 70 12 c0 	mov    %edx,-0x3fed8f60(,%eax,4)
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106bf7:	ff 45 ec             	incl   -0x14(%ebp)
c0106bfa:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0106bfe:	7e d5                	jle    c0106bd5 <check_swap+0x43b>
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106c00:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106c07:	e9 e8 00 00 00       	jmp    c0106cf4 <check_swap+0x55a>
         check_ptep[i]=0;
c0106c0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c0f:	c7 04 85 dc 70 12 c0 	movl   $0x0,-0x3fed8f24(,%eax,4)
c0106c16:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0106c1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c1d:	40                   	inc    %eax
c0106c1e:	c1 e0 0c             	shl    $0xc,%eax
c0106c21:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106c28:	00 
c0106c29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c30:	89 04 24             	mov    %eax,(%esp)
c0106c33:	e8 6b e3 ff ff       	call   c0104fa3 <get_pte>
c0106c38:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106c3b:	89 04 95 dc 70 12 c0 	mov    %eax,-0x3fed8f24(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0106c42:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c45:	8b 04 85 dc 70 12 c0 	mov    -0x3fed8f24(,%eax,4),%eax
c0106c4c:	85 c0                	test   %eax,%eax
c0106c4e:	75 24                	jne    c0106c74 <check_swap+0x4da>
c0106c50:	c7 44 24 0c 78 a5 10 	movl   $0xc010a578,0xc(%esp)
c0106c57:	c0 
c0106c58:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c0106c5f:	c0 
c0106c60:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0106c67:	00 
c0106c68:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c0106c6f:	e8 7d a0 ff ff       	call   c0100cf1 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0106c74:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c77:	8b 04 85 dc 70 12 c0 	mov    -0x3fed8f24(,%eax,4),%eax
c0106c7e:	8b 00                	mov    (%eax),%eax
c0106c80:	89 04 24             	mov    %eax,(%esp)
c0106c83:	e8 97 f5 ff ff       	call   c010621f <pte2page>
c0106c88:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106c8b:	8b 14 95 cc 70 12 c0 	mov    -0x3fed8f34(,%edx,4),%edx
c0106c92:	39 d0                	cmp    %edx,%eax
c0106c94:	74 24                	je     c0106cba <check_swap+0x520>
c0106c96:	c7 44 24 0c 90 a5 10 	movl   $0xc010a590,0xc(%esp)
c0106c9d:	c0 
c0106c9e:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c0106ca5:	c0 
c0106ca6:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0106cad:	00 
c0106cae:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c0106cb5:	e8 37 a0 ff ff       	call   c0100cf1 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0106cba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106cbd:	8b 04 85 dc 70 12 c0 	mov    -0x3fed8f24(,%eax,4),%eax
c0106cc4:	8b 00                	mov    (%eax),%eax
c0106cc6:	83 e0 01             	and    $0x1,%eax
c0106cc9:	85 c0                	test   %eax,%eax
c0106ccb:	75 24                	jne    c0106cf1 <check_swap+0x557>
c0106ccd:	c7 44 24 0c b8 a5 10 	movl   $0xc010a5b8,0xc(%esp)
c0106cd4:	c0 
c0106cd5:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c0106cdc:	c0 
c0106cdd:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0106ce4:	00 
c0106ce5:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c0106cec:	e8 00 a0 ff ff       	call   c0100cf1 <__panic>
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106cf1:	ff 45 ec             	incl   -0x14(%ebp)
c0106cf4:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106cf8:	0f 8e 0e ff ff ff    	jle    c0106c0c <check_swap+0x472>
     }
     cprintf("set up init env for check_swap over!\n");
c0106cfe:	c7 04 24 d4 a5 10 c0 	movl   $0xc010a5d4,(%esp)
c0106d05:	e8 5b 96 ff ff       	call   c0100365 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0106d0a:	e8 71 fa ff ff       	call   c0106780 <check_content_access>
c0106d0f:	89 45 d0             	mov    %eax,-0x30(%ebp)
     assert(ret==0);
c0106d12:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0106d16:	74 24                	je     c0106d3c <check_swap+0x5a2>
c0106d18:	c7 44 24 0c fa a5 10 	movl   $0xc010a5fa,0xc(%esp)
c0106d1f:	c0 
c0106d20:	c7 44 24 08 e2 a2 10 	movl   $0xc010a2e2,0x8(%esp)
c0106d27:	c0 
c0106d28:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0106d2f:	00 
c0106d30:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c0106d37:	e8 b5 9f ff ff       	call   c0100cf1 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106d3c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106d43:	eb 1d                	jmp    c0106d62 <check_swap+0x5c8>
         free_pages(check_rp[i],1);
c0106d45:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106d48:	8b 04 85 cc 70 12 c0 	mov    -0x3fed8f34(,%eax,4),%eax
c0106d4f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106d56:	00 
c0106d57:	89 04 24             	mov    %eax,(%esp)
c0106d5a:	e8 fb db ff ff       	call   c010495a <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106d5f:	ff 45 ec             	incl   -0x14(%ebp)
c0106d62:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106d66:	7e dd                	jle    c0106d45 <check_swap+0x5ab>
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0106d68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d6b:	89 04 24             	mov    %eax,(%esp)
c0106d6e:	e8 4e 09 00 00       	call   c01076c1 <mm_destroy>
         
     nr_free = nr_free_store;
c0106d73:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106d76:	a3 8c 6f 12 c0       	mov    %eax,0xc0126f8c
     free_list = free_list_store;
c0106d7b:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106d7e:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0106d81:	a3 84 6f 12 c0       	mov    %eax,0xc0126f84
c0106d86:	89 15 88 6f 12 c0    	mov    %edx,0xc0126f88

     
     le = &free_list;
c0106d8c:	c7 45 e8 84 6f 12 c0 	movl   $0xc0126f84,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106d93:	eb 1c                	jmp    c0106db1 <check_swap+0x617>
         struct Page *p = le2page(le, page_link);
c0106d95:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106d98:	83 e8 0c             	sub    $0xc,%eax
c0106d9b:	89 45 cc             	mov    %eax,-0x34(%ebp)
         count --, total -= p->property;
c0106d9e:	ff 4d f4             	decl   -0xc(%ebp)
c0106da1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106da4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106da7:	8b 48 08             	mov    0x8(%eax),%ecx
c0106daa:	89 d0                	mov    %edx,%eax
c0106dac:	29 c8                	sub    %ecx,%eax
c0106dae:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106db1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106db4:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return listelm->next;
c0106db7:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106dba:	8b 40 04             	mov    0x4(%eax),%eax
     while ((le = list_next(le)) != &free_list) {
c0106dbd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106dc0:	81 7d e8 84 6f 12 c0 	cmpl   $0xc0126f84,-0x18(%ebp)
c0106dc7:	75 cc                	jne    c0106d95 <check_swap+0x5fb>
     }
     cprintf("count is %d, total is %d\n",count,total);
c0106dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106dcc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106dd3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106dd7:	c7 04 24 01 a6 10 c0 	movl   $0xc010a601,(%esp)
c0106dde:	e8 82 95 ff ff       	call   c0100365 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0106de3:	c7 04 24 1b a6 10 c0 	movl   $0xc010a61b,(%esp)
c0106dea:	e8 76 95 ff ff       	call   c0100365 <cprintf>
}
c0106def:	90                   	nop
c0106df0:	89 ec                	mov    %ebp,%esp
c0106df2:	5d                   	pop    %ebp
c0106df3:	c3                   	ret    

c0106df4 <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0106df4:	55                   	push   %ebp
c0106df5:	89 e5                	mov    %esp,%ebp
c0106df7:	83 ec 10             	sub    $0x10,%esp
c0106dfa:	c7 45 fc 04 71 12 c0 	movl   $0xc0127104,-0x4(%ebp)
    elm->prev = elm->next = elm;
c0106e01:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106e04:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0106e07:	89 50 04             	mov    %edx,0x4(%eax)
c0106e0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106e0d:	8b 50 04             	mov    0x4(%eax),%edx
c0106e10:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106e13:	89 10                	mov    %edx,(%eax)
}
c0106e15:	90                   	nop
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0106e16:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e19:	c7 40 14 04 71 12 c0 	movl   $0xc0127104,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0106e20:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106e25:	89 ec                	mov    %ebp,%esp
c0106e27:	5d                   	pop    %ebp
c0106e28:	c3                   	ret    

c0106e29 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106e29:	55                   	push   %ebp
c0106e2a:	89 e5                	mov    %esp,%ebp
c0106e2c:	83 ec 38             	sub    $0x38,%esp
    // 找到链表入口
    list_entry_t *head = (list_entry_t *)mm->sm_priv;
c0106e2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e32:	8b 40 14             	mov    0x14(%eax),%eax
c0106e35:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // 找到当前物理页用于组织成链表的list_entry_t
    list_entry_t *entry = &(page->pra_page_link);
c0106e38:	8b 45 10             	mov    0x10(%ebp),%eax
c0106e3b:	83 c0 14             	add    $0x14,%eax
c0106e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 检查
    assert(entry != NULL && head != NULL);
c0106e41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106e45:	74 06                	je     c0106e4d <_fifo_map_swappable+0x24>
c0106e47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106e4b:	75 24                	jne    c0106e71 <_fifo_map_swappable+0x48>
c0106e4d:	c7 44 24 0c 34 a6 10 	movl   $0xc010a634,0xc(%esp)
c0106e54:	c0 
c0106e55:	c7 44 24 08 52 a6 10 	movl   $0xc010a652,0x8(%esp)
c0106e5c:	c0 
c0106e5d:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
c0106e64:	00 
c0106e65:	c7 04 24 67 a6 10 c0 	movl   $0xc010a667,(%esp)
c0106e6c:	e8 80 9e ff ff       	call   c0100cf1 <__panic>
c0106e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106e74:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e7a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0106e7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106e80:	8b 00                	mov    (%eax),%eax
c0106e82:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106e85:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106e88:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106e8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106e8e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    prev->next = next->prev = elm;
c0106e91:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106e94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106e97:	89 10                	mov    %edx,(%eax)
c0106e99:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106e9c:	8b 10                	mov    (%eax),%edx
c0106e9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106ea1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0106ea4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106ea7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106eaa:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0106ead:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106eb0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106eb3:	89 10                	mov    %edx,(%eax)
}
c0106eb5:	90                   	nop
}
c0106eb6:	90                   	nop
    // record the page access situlation
    /* LAB3 EXERCISE 2: YOUR CODE */
    // (1)link the most recent arrival page at the back of the pra_list_head qeueue.
    // 将当前指定的物理页插入到链表的末尾
    list_add_before(head, entry);
    return 0;
c0106eb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106ebc:	89 ec                	mov    %ebp,%esp
c0106ebe:	5d                   	pop    %ebp
c0106ebf:	c3                   	ret    

c0106ec0 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0106ec0:	55                   	push   %ebp
c0106ec1:	89 e5                	mov    %esp,%ebp
c0106ec3:	83 ec 38             	sub    $0x38,%esp
    // 找到链表的入口
    list_entry_t *head = (list_entry_t *)mm->sm_priv;
c0106ec6:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ec9:	8b 40 14             	mov    0x14(%eax),%eax
c0106ecc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // 检查
    assert(head != NULL);
c0106ecf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106ed3:	75 24                	jne    c0106ef9 <_fifo_swap_out_victim+0x39>
c0106ed5:	c7 44 24 0c 7b a6 10 	movl   $0xc010a67b,0xc(%esp)
c0106edc:	c0 
c0106edd:	c7 44 24 08 52 a6 10 	movl   $0xc010a652,0x8(%esp)
c0106ee4:	c0 
c0106ee5:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0106eec:	00 
c0106eed:	c7 04 24 67 a6 10 c0 	movl   $0xc010a667,(%esp)
c0106ef4:	e8 f8 9d ff ff       	call   c0100cf1 <__panic>
    assert(in_tick == 0);
c0106ef9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106efd:	74 24                	je     c0106f23 <_fifo_swap_out_victim+0x63>
c0106eff:	c7 44 24 0c 88 a6 10 	movl   $0xc010a688,0xc(%esp)
c0106f06:	c0 
c0106f07:	c7 44 24 08 52 a6 10 	movl   $0xc010a652,0x8(%esp)
c0106f0e:	c0 
c0106f0f:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
c0106f16:	00 
c0106f17:	c7 04 24 67 a6 10 c0 	movl   $0xc010a667,(%esp)
c0106f1e:	e8 ce 9d ff ff       	call   c0100cf1 <__panic>
c0106f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106f26:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return listelm->next;
c0106f29:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106f2c:	8b 40 04             	mov    0x4(%eax),%eax
    /* Select the victim */
    /* LAB3 EXERCISE 2: YOUR CODE */
    // (1) unlink the earliest arrival page in front of pra_list_head qeueue
    // 取出链表头，即最早进入的物理页面
    list_entry_t *le = list_next(head);
c0106f2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(le != head);     // 链表非空
c0106f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106f35:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0106f38:	75 24                	jne    c0106f5e <_fifo_swap_out_victim+0x9e>
c0106f3a:	c7 44 24 0c 95 a6 10 	movl   $0xc010a695,0xc(%esp)
c0106f41:	c0 
c0106f42:	c7 44 24 08 52 a6 10 	movl   $0xc010a652,0x8(%esp)
c0106f49:	c0 
c0106f4a:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
c0106f51:	00 
c0106f52:	c7 04 24 67 a6 10 c0 	movl   $0xc010a667,(%esp)
c0106f59:	e8 93 9d ff ff       	call   c0100cf1 <__panic>
    // (2) assign the value of *ptr_page to the addr of this page
    // 找到对应的物理页面的Page结构
    struct Page *page = le2page(le, pra_page_link); 
c0106f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106f61:	83 e8 14             	sub    $0x14,%eax
c0106f64:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106f6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0106f6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106f70:	8b 40 04             	mov    0x4(%eax),%eax
c0106f73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106f76:	8b 12                	mov    (%edx),%edx
c0106f78:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0106f7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    prev->next = next;
c0106f7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106f81:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106f84:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0106f87:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106f8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106f8d:	89 10                	mov    %edx,(%eax)
}
c0106f8f:	90                   	nop
}
c0106f90:	90                   	nop
    // 从链表上删除取出的即将被换出的物理页面
    list_del(le);
    *ptr_page = page;
c0106f91:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f94:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106f97:	89 10                	mov    %edx,(%eax)
    return 0;
c0106f99:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106f9e:	89 ec                	mov    %ebp,%esp
c0106fa0:	5d                   	pop    %ebp
c0106fa1:	c3                   	ret    

c0106fa2 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0106fa2:	55                   	push   %ebp
c0106fa3:	89 e5                	mov    %esp,%ebp
c0106fa5:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106fa8:	c7 04 24 a0 a6 10 c0 	movl   $0xc010a6a0,(%esp)
c0106faf:	e8 b1 93 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0106fb4:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106fb9:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0106fbc:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c0106fc1:	83 f8 04             	cmp    $0x4,%eax
c0106fc4:	74 24                	je     c0106fea <_fifo_check_swap+0x48>
c0106fc6:	c7 44 24 0c c6 a6 10 	movl   $0xc010a6c6,0xc(%esp)
c0106fcd:	c0 
c0106fce:	c7 44 24 08 52 a6 10 	movl   $0xc010a652,0x8(%esp)
c0106fd5:	c0 
c0106fd6:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0106fdd:	00 
c0106fde:	c7 04 24 67 a6 10 c0 	movl   $0xc010a667,(%esp)
c0106fe5:	e8 07 9d ff ff       	call   c0100cf1 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106fea:	c7 04 24 d8 a6 10 c0 	movl   $0xc010a6d8,(%esp)
c0106ff1:	e8 6f 93 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0106ff6:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106ffb:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0106ffe:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c0107003:	83 f8 04             	cmp    $0x4,%eax
c0107006:	74 24                	je     c010702c <_fifo_check_swap+0x8a>
c0107008:	c7 44 24 0c c6 a6 10 	movl   $0xc010a6c6,0xc(%esp)
c010700f:	c0 
c0107010:	c7 44 24 08 52 a6 10 	movl   $0xc010a652,0x8(%esp)
c0107017:	c0 
c0107018:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c010701f:	00 
c0107020:	c7 04 24 67 a6 10 c0 	movl   $0xc010a667,(%esp)
c0107027:	e8 c5 9c ff ff       	call   c0100cf1 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c010702c:	c7 04 24 00 a7 10 c0 	movl   $0xc010a700,(%esp)
c0107033:	e8 2d 93 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107038:	b8 00 40 00 00       	mov    $0x4000,%eax
c010703d:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0107040:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c0107045:	83 f8 04             	cmp    $0x4,%eax
c0107048:	74 24                	je     c010706e <_fifo_check_swap+0xcc>
c010704a:	c7 44 24 0c c6 a6 10 	movl   $0xc010a6c6,0xc(%esp)
c0107051:	c0 
c0107052:	c7 44 24 08 52 a6 10 	movl   $0xc010a652,0x8(%esp)
c0107059:	c0 
c010705a:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0107061:	00 
c0107062:	c7 04 24 67 a6 10 c0 	movl   $0xc010a667,(%esp)
c0107069:	e8 83 9c ff ff       	call   c0100cf1 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010706e:	c7 04 24 28 a7 10 c0 	movl   $0xc010a728,(%esp)
c0107075:	e8 eb 92 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c010707a:	b8 00 20 00 00       	mov    $0x2000,%eax
c010707f:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0107082:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c0107087:	83 f8 04             	cmp    $0x4,%eax
c010708a:	74 24                	je     c01070b0 <_fifo_check_swap+0x10e>
c010708c:	c7 44 24 0c c6 a6 10 	movl   $0xc010a6c6,0xc(%esp)
c0107093:	c0 
c0107094:	c7 44 24 08 52 a6 10 	movl   $0xc010a652,0x8(%esp)
c010709b:	c0 
c010709c:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01070a3:	00 
c01070a4:	c7 04 24 67 a6 10 c0 	movl   $0xc010a667,(%esp)
c01070ab:	e8 41 9c ff ff       	call   c0100cf1 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c01070b0:	c7 04 24 50 a7 10 c0 	movl   $0xc010a750,(%esp)
c01070b7:	e8 a9 92 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c01070bc:	b8 00 50 00 00       	mov    $0x5000,%eax
c01070c1:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c01070c4:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c01070c9:	83 f8 05             	cmp    $0x5,%eax
c01070cc:	74 24                	je     c01070f2 <_fifo_check_swap+0x150>
c01070ce:	c7 44 24 0c 76 a7 10 	movl   $0xc010a776,0xc(%esp)
c01070d5:	c0 
c01070d6:	c7 44 24 08 52 a6 10 	movl   $0xc010a652,0x8(%esp)
c01070dd:	c0 
c01070de:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c01070e5:	00 
c01070e6:	c7 04 24 67 a6 10 c0 	movl   $0xc010a667,(%esp)
c01070ed:	e8 ff 9b ff ff       	call   c0100cf1 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01070f2:	c7 04 24 28 a7 10 c0 	movl   $0xc010a728,(%esp)
c01070f9:	e8 67 92 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01070fe:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107103:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0107106:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c010710b:	83 f8 05             	cmp    $0x5,%eax
c010710e:	74 24                	je     c0107134 <_fifo_check_swap+0x192>
c0107110:	c7 44 24 0c 76 a7 10 	movl   $0xc010a776,0xc(%esp)
c0107117:	c0 
c0107118:	c7 44 24 08 52 a6 10 	movl   $0xc010a652,0x8(%esp)
c010711f:	c0 
c0107120:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c0107127:	00 
c0107128:	c7 04 24 67 a6 10 c0 	movl   $0xc010a667,(%esp)
c010712f:	e8 bd 9b ff ff       	call   c0100cf1 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107134:	c7 04 24 d8 a6 10 c0 	movl   $0xc010a6d8,(%esp)
c010713b:	e8 25 92 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107140:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107145:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0107148:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c010714d:	83 f8 06             	cmp    $0x6,%eax
c0107150:	74 24                	je     c0107176 <_fifo_check_swap+0x1d4>
c0107152:	c7 44 24 0c 85 a7 10 	movl   $0xc010a785,0xc(%esp)
c0107159:	c0 
c010715a:	c7 44 24 08 52 a6 10 	movl   $0xc010a652,0x8(%esp)
c0107161:	c0 
c0107162:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0107169:	00 
c010716a:	c7 04 24 67 a6 10 c0 	movl   $0xc010a667,(%esp)
c0107171:	e8 7b 9b ff ff       	call   c0100cf1 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107176:	c7 04 24 28 a7 10 c0 	movl   $0xc010a728,(%esp)
c010717d:	e8 e3 91 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107182:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107187:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c010718a:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c010718f:	83 f8 07             	cmp    $0x7,%eax
c0107192:	74 24                	je     c01071b8 <_fifo_check_swap+0x216>
c0107194:	c7 44 24 0c 94 a7 10 	movl   $0xc010a794,0xc(%esp)
c010719b:	c0 
c010719c:	c7 44 24 08 52 a6 10 	movl   $0xc010a652,0x8(%esp)
c01071a3:	c0 
c01071a4:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01071ab:	00 
c01071ac:	c7 04 24 67 a6 10 c0 	movl   $0xc010a667,(%esp)
c01071b3:	e8 39 9b ff ff       	call   c0100cf1 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c01071b8:	c7 04 24 a0 a6 10 c0 	movl   $0xc010a6a0,(%esp)
c01071bf:	e8 a1 91 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01071c4:	b8 00 30 00 00       	mov    $0x3000,%eax
c01071c9:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c01071cc:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c01071d1:	83 f8 08             	cmp    $0x8,%eax
c01071d4:	74 24                	je     c01071fa <_fifo_check_swap+0x258>
c01071d6:	c7 44 24 0c a3 a7 10 	movl   $0xc010a7a3,0xc(%esp)
c01071dd:	c0 
c01071de:	c7 44 24 08 52 a6 10 	movl   $0xc010a652,0x8(%esp)
c01071e5:	c0 
c01071e6:	c7 44 24 04 73 00 00 	movl   $0x73,0x4(%esp)
c01071ed:	00 
c01071ee:	c7 04 24 67 a6 10 c0 	movl   $0xc010a667,(%esp)
c01071f5:	e8 f7 9a ff ff       	call   c0100cf1 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c01071fa:	c7 04 24 00 a7 10 c0 	movl   $0xc010a700,(%esp)
c0107201:	e8 5f 91 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107206:	b8 00 40 00 00       	mov    $0x4000,%eax
c010720b:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c010720e:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c0107213:	83 f8 09             	cmp    $0x9,%eax
c0107216:	74 24                	je     c010723c <_fifo_check_swap+0x29a>
c0107218:	c7 44 24 0c b2 a7 10 	movl   $0xc010a7b2,0xc(%esp)
c010721f:	c0 
c0107220:	c7 44 24 08 52 a6 10 	movl   $0xc010a652,0x8(%esp)
c0107227:	c0 
c0107228:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
c010722f:	00 
c0107230:	c7 04 24 67 a6 10 c0 	movl   $0xc010a667,(%esp)
c0107237:	e8 b5 9a ff ff       	call   c0100cf1 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c010723c:	c7 04 24 50 a7 10 c0 	movl   $0xc010a750,(%esp)
c0107243:	e8 1d 91 ff ff       	call   c0100365 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0107248:	b8 00 50 00 00       	mov    $0x5000,%eax
c010724d:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==10);
c0107250:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c0107255:	83 f8 0a             	cmp    $0xa,%eax
c0107258:	74 24                	je     c010727e <_fifo_check_swap+0x2dc>
c010725a:	c7 44 24 0c c1 a7 10 	movl   $0xc010a7c1,0xc(%esp)
c0107261:	c0 
c0107262:	c7 44 24 08 52 a6 10 	movl   $0xc010a652,0x8(%esp)
c0107269:	c0 
c010726a:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
c0107271:	00 
c0107272:	c7 04 24 67 a6 10 c0 	movl   $0xc010a667,(%esp)
c0107279:	e8 73 9a ff ff       	call   c0100cf1 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c010727e:	c7 04 24 d8 a6 10 c0 	movl   $0xc010a6d8,(%esp)
c0107285:	e8 db 90 ff ff       	call   c0100365 <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
c010728a:	b8 00 10 00 00       	mov    $0x1000,%eax
c010728f:	0f b6 00             	movzbl (%eax),%eax
c0107292:	3c 0a                	cmp    $0xa,%al
c0107294:	74 24                	je     c01072ba <_fifo_check_swap+0x318>
c0107296:	c7 44 24 0c d4 a7 10 	movl   $0xc010a7d4,0xc(%esp)
c010729d:	c0 
c010729e:	c7 44 24 08 52 a6 10 	movl   $0xc010a652,0x8(%esp)
c01072a5:	c0 
c01072a6:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c01072ad:	00 
c01072ae:	c7 04 24 67 a6 10 c0 	movl   $0xc010a667,(%esp)
c01072b5:	e8 37 9a ff ff       	call   c0100cf1 <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c01072ba:	b8 00 10 00 00       	mov    $0x1000,%eax
c01072bf:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==11);
c01072c2:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c01072c7:	83 f8 0b             	cmp    $0xb,%eax
c01072ca:	74 24                	je     c01072f0 <_fifo_check_swap+0x34e>
c01072cc:	c7 44 24 0c f5 a7 10 	movl   $0xc010a7f5,0xc(%esp)
c01072d3:	c0 
c01072d4:	c7 44 24 08 52 a6 10 	movl   $0xc010a652,0x8(%esp)
c01072db:	c0 
c01072dc:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c01072e3:	00 
c01072e4:	c7 04 24 67 a6 10 c0 	movl   $0xc010a667,(%esp)
c01072eb:	e8 01 9a ff ff       	call   c0100cf1 <__panic>
    return 0;
c01072f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01072f5:	89 ec                	mov    %ebp,%esp
c01072f7:	5d                   	pop    %ebp
c01072f8:	c3                   	ret    

c01072f9 <_fifo_init>:


static int
_fifo_init(void)
{
c01072f9:	55                   	push   %ebp
c01072fa:	89 e5                	mov    %esp,%ebp
    return 0;
c01072fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107301:	5d                   	pop    %ebp
c0107302:	c3                   	ret    

c0107303 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0107303:	55                   	push   %ebp
c0107304:	89 e5                	mov    %esp,%ebp
    return 0;
c0107306:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010730b:	5d                   	pop    %ebp
c010730c:	c3                   	ret    

c010730d <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c010730d:	55                   	push   %ebp
c010730e:	89 e5                	mov    %esp,%ebp
c0107310:	b8 00 00 00 00       	mov    $0x0,%eax
c0107315:	5d                   	pop    %ebp
c0107316:	c3                   	ret    

c0107317 <pa2page>:
pa2page(uintptr_t pa) {
c0107317:	55                   	push   %ebp
c0107318:	89 e5                	mov    %esp,%ebp
c010731a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010731d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107320:	c1 e8 0c             	shr    $0xc,%eax
c0107323:	89 c2                	mov    %eax,%edx
c0107325:	a1 a4 6f 12 c0       	mov    0xc0126fa4,%eax
c010732a:	39 c2                	cmp    %eax,%edx
c010732c:	72 1c                	jb     c010734a <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010732e:	c7 44 24 08 18 a8 10 	movl   $0xc010a818,0x8(%esp)
c0107335:	c0 
c0107336:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c010733d:	00 
c010733e:	c7 04 24 37 a8 10 c0 	movl   $0xc010a837,(%esp)
c0107345:	e8 a7 99 ff ff       	call   c0100cf1 <__panic>
    return &pages[PPN(pa)];
c010734a:	8b 15 a0 6f 12 c0    	mov    0xc0126fa0,%edx
c0107350:	8b 45 08             	mov    0x8(%ebp),%eax
c0107353:	c1 e8 0c             	shr    $0xc,%eax
c0107356:	c1 e0 05             	shl    $0x5,%eax
c0107359:	01 d0                	add    %edx,%eax
}
c010735b:	89 ec                	mov    %ebp,%esp
c010735d:	5d                   	pop    %ebp
c010735e:	c3                   	ret    

c010735f <pde2page>:
pde2page(pde_t pde) {
c010735f:	55                   	push   %ebp
c0107360:	89 e5                	mov    %esp,%ebp
c0107362:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0107365:	8b 45 08             	mov    0x8(%ebp),%eax
c0107368:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010736d:	89 04 24             	mov    %eax,(%esp)
c0107370:	e8 a2 ff ff ff       	call   c0107317 <pa2page>
}
c0107375:	89 ec                	mov    %ebp,%esp
c0107377:	5d                   	pop    %ebp
c0107378:	c3                   	ret    

c0107379 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0107379:	55                   	push   %ebp
c010737a:	89 e5                	mov    %esp,%ebp
c010737c:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c010737f:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107386:	e8 0d ed ff ff       	call   c0106098 <kmalloc>
c010738b:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c010738e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107392:	74 59                	je     c01073ed <mm_create+0x74>
        list_init(&(mm->mmap_list));
c0107394:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107397:	89 45 f0             	mov    %eax,-0x10(%ebp)
    elm->prev = elm->next = elm;
c010739a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010739d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01073a0:	89 50 04             	mov    %edx,0x4(%eax)
c01073a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073a6:	8b 50 04             	mov    0x4(%eax),%edx
c01073a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073ac:	89 10                	mov    %edx,(%eax)
}
c01073ae:	90                   	nop
        mm->mmap_cache = NULL;
c01073af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c01073b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073bc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c01073c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073c6:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c01073cd:	a1 44 70 12 c0       	mov    0xc0127044,%eax
c01073d2:	85 c0                	test   %eax,%eax
c01073d4:	74 0d                	je     c01073e3 <mm_create+0x6a>
c01073d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073d9:	89 04 24             	mov    %eax,(%esp)
c01073dc:	e8 10 ef ff ff       	call   c01062f1 <swap_init_mm>
c01073e1:	eb 0a                	jmp    c01073ed <mm_create+0x74>
        else mm->sm_priv = NULL;
c01073e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073e6:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c01073ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01073f0:	89 ec                	mov    %ebp,%esp
c01073f2:	5d                   	pop    %ebp
c01073f3:	c3                   	ret    

c01073f4 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c01073f4:	55                   	push   %ebp
c01073f5:	89 e5                	mov    %esp,%ebp
c01073f7:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c01073fa:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107401:	e8 92 ec ff ff       	call   c0106098 <kmalloc>
c0107406:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0107409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010740d:	74 1b                	je     c010742a <vma_create+0x36>
        vma->vm_start = vm_start;
c010740f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107412:	8b 55 08             	mov    0x8(%ebp),%edx
c0107415:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0107418:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010741b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010741e:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0107421:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107424:	8b 55 10             	mov    0x10(%ebp),%edx
c0107427:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c010742a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010742d:	89 ec                	mov    %ebp,%esp
c010742f:	5d                   	pop    %ebp
c0107430:	c3                   	ret    

c0107431 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0107431:	55                   	push   %ebp
c0107432:	89 e5                	mov    %esp,%ebp
c0107434:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0107437:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c010743e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107442:	0f 84 95 00 00 00    	je     c01074dd <find_vma+0xac>
        vma = mm->mmap_cache;
c0107448:	8b 45 08             	mov    0x8(%ebp),%eax
c010744b:	8b 40 08             	mov    0x8(%eax),%eax
c010744e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0107451:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107455:	74 16                	je     c010746d <find_vma+0x3c>
c0107457:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010745a:	8b 40 04             	mov    0x4(%eax),%eax
c010745d:	39 45 0c             	cmp    %eax,0xc(%ebp)
c0107460:	72 0b                	jb     c010746d <find_vma+0x3c>
c0107462:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107465:	8b 40 08             	mov    0x8(%eax),%eax
c0107468:	39 45 0c             	cmp    %eax,0xc(%ebp)
c010746b:	72 61                	jb     c01074ce <find_vma+0x9d>
                bool found = 0;
c010746d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0107474:	8b 45 08             	mov    0x8(%ebp),%eax
c0107477:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010747a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010747d:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0107480:	eb 28                	jmp    c01074aa <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0107482:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107485:	83 e8 10             	sub    $0x10,%eax
c0107488:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c010748b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010748e:	8b 40 04             	mov    0x4(%eax),%eax
c0107491:	39 45 0c             	cmp    %eax,0xc(%ebp)
c0107494:	72 14                	jb     c01074aa <find_vma+0x79>
c0107496:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107499:	8b 40 08             	mov    0x8(%eax),%eax
c010749c:	39 45 0c             	cmp    %eax,0xc(%ebp)
c010749f:	73 09                	jae    c01074aa <find_vma+0x79>
                        found = 1;
c01074a1:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c01074a8:	eb 17                	jmp    c01074c1 <find_vma+0x90>
c01074aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01074ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return listelm->next;
c01074b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01074b3:	8b 40 04             	mov    0x4(%eax),%eax
                while ((le = list_next(le)) != list) {
c01074b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01074b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01074bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01074bf:	75 c1                	jne    c0107482 <find_vma+0x51>
                    }
                }
                if (!found) {
c01074c1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c01074c5:	75 07                	jne    c01074ce <find_vma+0x9d>
                    vma = NULL;
c01074c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c01074ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01074d2:	74 09                	je     c01074dd <find_vma+0xac>
            mm->mmap_cache = vma;
c01074d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01074d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01074da:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c01074dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01074e0:	89 ec                	mov    %ebp,%esp
c01074e2:	5d                   	pop    %ebp
c01074e3:	c3                   	ret    

c01074e4 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c01074e4:	55                   	push   %ebp
c01074e5:	89 e5                	mov    %esp,%ebp
c01074e7:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c01074ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01074ed:	8b 50 04             	mov    0x4(%eax),%edx
c01074f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01074f3:	8b 40 08             	mov    0x8(%eax),%eax
c01074f6:	39 c2                	cmp    %eax,%edx
c01074f8:	72 24                	jb     c010751e <check_vma_overlap+0x3a>
c01074fa:	c7 44 24 0c 45 a8 10 	movl   $0xc010a845,0xc(%esp)
c0107501:	c0 
c0107502:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c0107509:	c0 
c010750a:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0107511:	00 
c0107512:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c0107519:	e8 d3 97 ff ff       	call   c0100cf1 <__panic>
    assert(prev->vm_end <= next->vm_start);
c010751e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107521:	8b 50 08             	mov    0x8(%eax),%edx
c0107524:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107527:	8b 40 04             	mov    0x4(%eax),%eax
c010752a:	39 c2                	cmp    %eax,%edx
c010752c:	76 24                	jbe    c0107552 <check_vma_overlap+0x6e>
c010752e:	c7 44 24 0c 88 a8 10 	movl   $0xc010a888,0xc(%esp)
c0107535:	c0 
c0107536:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c010753d:	c0 
c010753e:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c0107545:	00 
c0107546:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c010754d:	e8 9f 97 ff ff       	call   c0100cf1 <__panic>
    assert(next->vm_start < next->vm_end);
c0107552:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107555:	8b 50 04             	mov    0x4(%eax),%edx
c0107558:	8b 45 0c             	mov    0xc(%ebp),%eax
c010755b:	8b 40 08             	mov    0x8(%eax),%eax
c010755e:	39 c2                	cmp    %eax,%edx
c0107560:	72 24                	jb     c0107586 <check_vma_overlap+0xa2>
c0107562:	c7 44 24 0c a7 a8 10 	movl   $0xc010a8a7,0xc(%esp)
c0107569:	c0 
c010756a:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c0107571:	c0 
c0107572:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0107579:	00 
c010757a:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c0107581:	e8 6b 97 ff ff       	call   c0100cf1 <__panic>
}
c0107586:	90                   	nop
c0107587:	89 ec                	mov    %ebp,%esp
c0107589:	5d                   	pop    %ebp
c010758a:	c3                   	ret    

c010758b <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c010758b:	55                   	push   %ebp
c010758c:	89 e5                	mov    %esp,%ebp
c010758e:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c0107591:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107594:	8b 50 04             	mov    0x4(%eax),%edx
c0107597:	8b 45 0c             	mov    0xc(%ebp),%eax
c010759a:	8b 40 08             	mov    0x8(%eax),%eax
c010759d:	39 c2                	cmp    %eax,%edx
c010759f:	72 24                	jb     c01075c5 <insert_vma_struct+0x3a>
c01075a1:	c7 44 24 0c c5 a8 10 	movl   $0xc010a8c5,0xc(%esp)
c01075a8:	c0 
c01075a9:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c01075b0:	c0 
c01075b1:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01075b8:	00 
c01075b9:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c01075c0:	e8 2c 97 ff ff       	call   c0100cf1 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c01075c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01075c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c01075cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01075ce:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c01075d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01075d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c01075d7:	eb 1f                	jmp    c01075f8 <insert_vma_struct+0x6d>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c01075d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01075dc:	83 e8 10             	sub    $0x10,%eax
c01075df:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c01075e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01075e5:	8b 50 04             	mov    0x4(%eax),%edx
c01075e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01075eb:	8b 40 04             	mov    0x4(%eax),%eax
c01075ee:	39 c2                	cmp    %eax,%edx
c01075f0:	77 1f                	ja     c0107611 <insert_vma_struct+0x86>
                break;
            }
            le_prev = le;
c01075f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01075f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01075f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01075fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01075fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107601:	8b 40 04             	mov    0x4(%eax),%eax
        while ((le = list_next(le)) != list) {
c0107604:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107607:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010760a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010760d:	75 ca                	jne    c01075d9 <insert_vma_struct+0x4e>
c010760f:	eb 01                	jmp    c0107612 <insert_vma_struct+0x87>
                break;
c0107611:	90                   	nop
c0107612:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107615:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107618:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010761b:	8b 40 04             	mov    0x4(%eax),%eax
        }

    le_next = list_next(le_prev);
c010761e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0107621:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107624:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107627:	74 15                	je     c010763e <insert_vma_struct+0xb3>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0107629:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010762c:	8d 50 f0             	lea    -0x10(%eax),%edx
c010762f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107632:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107636:	89 14 24             	mov    %edx,(%esp)
c0107639:	e8 a6 fe ff ff       	call   c01074e4 <check_vma_overlap>
    }
    if (le_next != list) {
c010763e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107641:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107644:	74 15                	je     c010765b <insert_vma_struct+0xd0>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0107646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107649:	83 e8 10             	sub    $0x10,%eax
c010764c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107650:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107653:	89 04 24             	mov    %eax,(%esp)
c0107656:	e8 89 fe ff ff       	call   c01074e4 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c010765b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010765e:	8b 55 08             	mov    0x8(%ebp),%edx
c0107661:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0107663:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107666:	8d 50 10             	lea    0x10(%eax),%edx
c0107669:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010766c:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010766f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c0107672:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107675:	8b 40 04             	mov    0x4(%eax),%eax
c0107678:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010767b:	89 55 d0             	mov    %edx,-0x30(%ebp)
c010767e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107681:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0107684:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c0107687:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010768a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010768d:	89 10                	mov    %edx,(%eax)
c010768f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107692:	8b 10                	mov    (%eax),%edx
c0107694:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107697:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010769a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010769d:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01076a0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01076a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01076a6:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01076a9:	89 10                	mov    %edx,(%eax)
}
c01076ab:	90                   	nop
}
c01076ac:	90                   	nop

    mm->map_count ++;
c01076ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01076b0:	8b 40 10             	mov    0x10(%eax),%eax
c01076b3:	8d 50 01             	lea    0x1(%eax),%edx
c01076b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01076b9:	89 50 10             	mov    %edx,0x10(%eax)
}
c01076bc:	90                   	nop
c01076bd:	89 ec                	mov    %ebp,%esp
c01076bf:	5d                   	pop    %ebp
c01076c0:	c3                   	ret    

c01076c1 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c01076c1:	55                   	push   %ebp
c01076c2:	89 e5                	mov    %esp,%ebp
c01076c4:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c01076c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01076ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c01076cd:	eb 40                	jmp    c010770f <mm_destroy+0x4e>
c01076cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01076d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    __list_del(listelm->prev, listelm->next);
c01076d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01076d8:	8b 40 04             	mov    0x4(%eax),%eax
c01076db:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01076de:	8b 12                	mov    (%edx),%edx
c01076e0:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01076e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    prev->next = next;
c01076e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01076e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01076ec:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01076ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01076f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01076f5:	89 10                	mov    %edx,(%eax)
}
c01076f7:	90                   	nop
}
c01076f8:	90                   	nop
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c01076f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01076fc:	83 e8 10             	sub    $0x10,%eax
c01076ff:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c0107706:	00 
c0107707:	89 04 24             	mov    %eax,(%esp)
c010770a:	e8 2b ea ff ff       	call   c010613a <kfree>
c010770f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107712:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return listelm->next;
c0107715:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107718:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(list)) != list) {
c010771b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010771e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107721:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107724:	75 a9                	jne    c01076cf <mm_destroy+0xe>
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c0107726:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c010772d:	00 
c010772e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107731:	89 04 24             	mov    %eax,(%esp)
c0107734:	e8 01 ea ff ff       	call   c010613a <kfree>
    mm=NULL;
c0107739:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0107740:	90                   	nop
c0107741:	89 ec                	mov    %ebp,%esp
c0107743:	5d                   	pop    %ebp
c0107744:	c3                   	ret    

c0107745 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0107745:	55                   	push   %ebp
c0107746:	89 e5                	mov    %esp,%ebp
c0107748:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c010774b:	e8 05 00 00 00       	call   c0107755 <check_vmm>
}
c0107750:	90                   	nop
c0107751:	89 ec                	mov    %ebp,%esp
c0107753:	5d                   	pop    %ebp
c0107754:	c3                   	ret    

c0107755 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0107755:	55                   	push   %ebp
c0107756:	89 e5                	mov    %esp,%ebp
c0107758:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010775b:	e8 2f d2 ff ff       	call   c010498f <nr_free_pages>
c0107760:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0107763:	e8 44 00 00 00       	call   c01077ac <check_vma_struct>
    check_pgfault();
c0107768:	e8 01 05 00 00       	call   c0107c6e <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c010776d:	e8 1d d2 ff ff       	call   c010498f <nr_free_pages>
c0107772:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0107775:	74 24                	je     c010779b <check_vmm+0x46>
c0107777:	c7 44 24 0c e4 a8 10 	movl   $0xc010a8e4,0xc(%esp)
c010777e:	c0 
c010777f:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c0107786:	c0 
c0107787:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c010778e:	00 
c010778f:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c0107796:	e8 56 95 ff ff       	call   c0100cf1 <__panic>

    cprintf("check_vmm() succeeded.\n");
c010779b:	c7 04 24 0b a9 10 c0 	movl   $0xc010a90b,(%esp)
c01077a2:	e8 be 8b ff ff       	call   c0100365 <cprintf>
}
c01077a7:	90                   	nop
c01077a8:	89 ec                	mov    %ebp,%esp
c01077aa:	5d                   	pop    %ebp
c01077ab:	c3                   	ret    

c01077ac <check_vma_struct>:

static void
check_vma_struct(void) {
c01077ac:	55                   	push   %ebp
c01077ad:	89 e5                	mov    %esp,%ebp
c01077af:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01077b2:	e8 d8 d1 ff ff       	call   c010498f <nr_free_pages>
c01077b7:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c01077ba:	e8 ba fb ff ff       	call   c0107379 <mm_create>
c01077bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c01077c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01077c6:	75 24                	jne    c01077ec <check_vma_struct+0x40>
c01077c8:	c7 44 24 0c 23 a9 10 	movl   $0xc010a923,0xc(%esp)
c01077cf:	c0 
c01077d0:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c01077d7:	c0 
c01077d8:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c01077df:	00 
c01077e0:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c01077e7:	e8 05 95 ff ff       	call   c0100cf1 <__panic>

    int step1 = 10, step2 = step1 * 10;
c01077ec:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c01077f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01077f6:	89 d0                	mov    %edx,%eax
c01077f8:	c1 e0 02             	shl    $0x2,%eax
c01077fb:	01 d0                	add    %edx,%eax
c01077fd:	01 c0                	add    %eax,%eax
c01077ff:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0107802:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107805:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107808:	eb 6f                	jmp    c0107879 <check_vma_struct+0xcd>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c010780a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010780d:	89 d0                	mov    %edx,%eax
c010780f:	c1 e0 02             	shl    $0x2,%eax
c0107812:	01 d0                	add    %edx,%eax
c0107814:	83 c0 02             	add    $0x2,%eax
c0107817:	89 c1                	mov    %eax,%ecx
c0107819:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010781c:	89 d0                	mov    %edx,%eax
c010781e:	c1 e0 02             	shl    $0x2,%eax
c0107821:	01 d0                	add    %edx,%eax
c0107823:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010782a:	00 
c010782b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010782f:	89 04 24             	mov    %eax,(%esp)
c0107832:	e8 bd fb ff ff       	call   c01073f4 <vma_create>
c0107837:	89 45 bc             	mov    %eax,-0x44(%ebp)
        assert(vma != NULL);
c010783a:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010783e:	75 24                	jne    c0107864 <check_vma_struct+0xb8>
c0107840:	c7 44 24 0c 2e a9 10 	movl   $0xc010a92e,0xc(%esp)
c0107847:	c0 
c0107848:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c010784f:	c0 
c0107850:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0107857:	00 
c0107858:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c010785f:	e8 8d 94 ff ff       	call   c0100cf1 <__panic>
        insert_vma_struct(mm, vma);
c0107864:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107867:	89 44 24 04          	mov    %eax,0x4(%esp)
c010786b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010786e:	89 04 24             	mov    %eax,(%esp)
c0107871:	e8 15 fd ff ff       	call   c010758b <insert_vma_struct>
    for (i = step1; i >= 1; i --) {
c0107876:	ff 4d f4             	decl   -0xc(%ebp)
c0107879:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010787d:	7f 8b                	jg     c010780a <check_vma_struct+0x5e>
    }

    for (i = step1 + 1; i <= step2; i ++) {
c010787f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107882:	40                   	inc    %eax
c0107883:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107886:	eb 6f                	jmp    c01078f7 <check_vma_struct+0x14b>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107888:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010788b:	89 d0                	mov    %edx,%eax
c010788d:	c1 e0 02             	shl    $0x2,%eax
c0107890:	01 d0                	add    %edx,%eax
c0107892:	83 c0 02             	add    $0x2,%eax
c0107895:	89 c1                	mov    %eax,%ecx
c0107897:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010789a:	89 d0                	mov    %edx,%eax
c010789c:	c1 e0 02             	shl    $0x2,%eax
c010789f:	01 d0                	add    %edx,%eax
c01078a1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01078a8:	00 
c01078a9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01078ad:	89 04 24             	mov    %eax,(%esp)
c01078b0:	e8 3f fb ff ff       	call   c01073f4 <vma_create>
c01078b5:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma != NULL);
c01078b8:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c01078bc:	75 24                	jne    c01078e2 <check_vma_struct+0x136>
c01078be:	c7 44 24 0c 2e a9 10 	movl   $0xc010a92e,0xc(%esp)
c01078c5:	c0 
c01078c6:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c01078cd:	c0 
c01078ce:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c01078d5:	00 
c01078d6:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c01078dd:	e8 0f 94 ff ff       	call   c0100cf1 <__panic>
        insert_vma_struct(mm, vma);
c01078e2:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01078e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01078e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01078ec:	89 04 24             	mov    %eax,(%esp)
c01078ef:	e8 97 fc ff ff       	call   c010758b <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i ++) {
c01078f4:	ff 45 f4             	incl   -0xc(%ebp)
c01078f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078fa:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01078fd:	7e 89                	jle    c0107888 <check_vma_struct+0xdc>
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c01078ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107902:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0107905:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0107908:	8b 40 04             	mov    0x4(%eax),%eax
c010790b:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c010790e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0107915:	e9 96 00 00 00       	jmp    c01079b0 <check_vma_struct+0x204>
        assert(le != &(mm->mmap_list));
c010791a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010791d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0107920:	75 24                	jne    c0107946 <check_vma_struct+0x19a>
c0107922:	c7 44 24 0c 3a a9 10 	movl   $0xc010a93a,0xc(%esp)
c0107929:	c0 
c010792a:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c0107931:	c0 
c0107932:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0107939:	00 
c010793a:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c0107941:	e8 ab 93 ff ff       	call   c0100cf1 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0107946:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107949:	83 e8 10             	sub    $0x10,%eax
c010794c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c010794f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0107952:	8b 48 04             	mov    0x4(%eax),%ecx
c0107955:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107958:	89 d0                	mov    %edx,%eax
c010795a:	c1 e0 02             	shl    $0x2,%eax
c010795d:	01 d0                	add    %edx,%eax
c010795f:	39 c1                	cmp    %eax,%ecx
c0107961:	75 17                	jne    c010797a <check_vma_struct+0x1ce>
c0107963:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0107966:	8b 48 08             	mov    0x8(%eax),%ecx
c0107969:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010796c:	89 d0                	mov    %edx,%eax
c010796e:	c1 e0 02             	shl    $0x2,%eax
c0107971:	01 d0                	add    %edx,%eax
c0107973:	83 c0 02             	add    $0x2,%eax
c0107976:	39 c1                	cmp    %eax,%ecx
c0107978:	74 24                	je     c010799e <check_vma_struct+0x1f2>
c010797a:	c7 44 24 0c 54 a9 10 	movl   $0xc010a954,0xc(%esp)
c0107981:	c0 
c0107982:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c0107989:	c0 
c010798a:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0107991:	00 
c0107992:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c0107999:	e8 53 93 ff ff       	call   c0100cf1 <__panic>
c010799e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01079a1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01079a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01079a7:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01079aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for (i = 1; i <= step2; i ++) {
c01079ad:	ff 45 f4             	incl   -0xc(%ebp)
c01079b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079b3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01079b6:	0f 8e 5e ff ff ff    	jle    c010791a <check_vma_struct+0x16e>
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c01079bc:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c01079c3:	e9 cb 01 00 00       	jmp    c0107b93 <check_vma_struct+0x3e7>
        struct vma_struct *vma1 = find_vma(mm, i);
c01079c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01079cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01079d2:	89 04 24             	mov    %eax,(%esp)
c01079d5:	e8 57 fa ff ff       	call   c0107431 <find_vma>
c01079da:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma1 != NULL);
c01079dd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01079e1:	75 24                	jne    c0107a07 <check_vma_struct+0x25b>
c01079e3:	c7 44 24 0c 89 a9 10 	movl   $0xc010a989,0xc(%esp)
c01079ea:	c0 
c01079eb:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c01079f2:	c0 
c01079f3:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c01079fa:	00 
c01079fb:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c0107a02:	e8 ea 92 ff ff       	call   c0100cf1 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0107a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a0a:	40                   	inc    %eax
c0107a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107a0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107a12:	89 04 24             	mov    %eax,(%esp)
c0107a15:	e8 17 fa ff ff       	call   c0107431 <find_vma>
c0107a1a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(vma2 != NULL);
c0107a1d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0107a21:	75 24                	jne    c0107a47 <check_vma_struct+0x29b>
c0107a23:	c7 44 24 0c 96 a9 10 	movl   $0xc010a996,0xc(%esp)
c0107a2a:	c0 
c0107a2b:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c0107a32:	c0 
c0107a33:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0107a3a:	00 
c0107a3b:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c0107a42:	e8 aa 92 ff ff       	call   c0100cf1 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0107a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a4a:	83 c0 02             	add    $0x2,%eax
c0107a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107a51:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107a54:	89 04 24             	mov    %eax,(%esp)
c0107a57:	e8 d5 f9 ff ff       	call   c0107431 <find_vma>
c0107a5c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma3 == NULL);
c0107a5f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0107a63:	74 24                	je     c0107a89 <check_vma_struct+0x2dd>
c0107a65:	c7 44 24 0c a3 a9 10 	movl   $0xc010a9a3,0xc(%esp)
c0107a6c:	c0 
c0107a6d:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c0107a74:	c0 
c0107a75:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0107a7c:	00 
c0107a7d:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c0107a84:	e8 68 92 ff ff       	call   c0100cf1 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0107a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a8c:	83 c0 03             	add    $0x3,%eax
c0107a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107a93:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107a96:	89 04 24             	mov    %eax,(%esp)
c0107a99:	e8 93 f9 ff ff       	call   c0107431 <find_vma>
c0107a9e:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma4 == NULL);
c0107aa1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107aa5:	74 24                	je     c0107acb <check_vma_struct+0x31f>
c0107aa7:	c7 44 24 0c b0 a9 10 	movl   $0xc010a9b0,0xc(%esp)
c0107aae:	c0 
c0107aaf:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c0107ab6:	c0 
c0107ab7:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0107abe:	00 
c0107abf:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c0107ac6:	e8 26 92 ff ff       	call   c0100cf1 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0107acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ace:	83 c0 04             	add    $0x4,%eax
c0107ad1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ad5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ad8:	89 04 24             	mov    %eax,(%esp)
c0107adb:	e8 51 f9 ff ff       	call   c0107431 <find_vma>
c0107ae0:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma5 == NULL);
c0107ae3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0107ae7:	74 24                	je     c0107b0d <check_vma_struct+0x361>
c0107ae9:	c7 44 24 0c bd a9 10 	movl   $0xc010a9bd,0xc(%esp)
c0107af0:	c0 
c0107af1:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c0107af8:	c0 
c0107af9:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0107b00:	00 
c0107b01:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c0107b08:	e8 e4 91 ff ff       	call   c0100cf1 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0107b0d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107b10:	8b 50 04             	mov    0x4(%eax),%edx
c0107b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b16:	39 c2                	cmp    %eax,%edx
c0107b18:	75 10                	jne    c0107b2a <check_vma_struct+0x37e>
c0107b1a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107b1d:	8b 40 08             	mov    0x8(%eax),%eax
c0107b20:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b23:	83 c2 02             	add    $0x2,%edx
c0107b26:	39 d0                	cmp    %edx,%eax
c0107b28:	74 24                	je     c0107b4e <check_vma_struct+0x3a2>
c0107b2a:	c7 44 24 0c cc a9 10 	movl   $0xc010a9cc,0xc(%esp)
c0107b31:	c0 
c0107b32:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c0107b39:	c0 
c0107b3a:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0107b41:	00 
c0107b42:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c0107b49:	e8 a3 91 ff ff       	call   c0100cf1 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0107b4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107b51:	8b 50 04             	mov    0x4(%eax),%edx
c0107b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b57:	39 c2                	cmp    %eax,%edx
c0107b59:	75 10                	jne    c0107b6b <check_vma_struct+0x3bf>
c0107b5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107b5e:	8b 40 08             	mov    0x8(%eax),%eax
c0107b61:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b64:	83 c2 02             	add    $0x2,%edx
c0107b67:	39 d0                	cmp    %edx,%eax
c0107b69:	74 24                	je     c0107b8f <check_vma_struct+0x3e3>
c0107b6b:	c7 44 24 0c fc a9 10 	movl   $0xc010a9fc,0xc(%esp)
c0107b72:	c0 
c0107b73:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c0107b7a:	c0 
c0107b7b:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0107b82:	00 
c0107b83:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c0107b8a:	e8 62 91 ff ff       	call   c0100cf1 <__panic>
    for (i = 5; i <= 5 * step2; i +=5) {
c0107b8f:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0107b93:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107b96:	89 d0                	mov    %edx,%eax
c0107b98:	c1 e0 02             	shl    $0x2,%eax
c0107b9b:	01 d0                	add    %edx,%eax
c0107b9d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0107ba0:	0f 8e 22 fe ff ff    	jle    c01079c8 <check_vma_struct+0x21c>
    }

    for (i =4; i>=0; i--) {
c0107ba6:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0107bad:	eb 6f                	jmp    c0107c1e <check_vma_struct+0x472>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0107baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107bb2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107bb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107bb9:	89 04 24             	mov    %eax,(%esp)
c0107bbc:	e8 70 f8 ff ff       	call   c0107431 <find_vma>
c0107bc1:	89 45 dc             	mov    %eax,-0x24(%ebp)
        if (vma_below_5 != NULL ) {
c0107bc4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107bc8:	74 27                	je     c0107bf1 <check_vma_struct+0x445>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0107bca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107bcd:	8b 50 08             	mov    0x8(%eax),%edx
c0107bd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107bd3:	8b 40 04             	mov    0x4(%eax),%eax
c0107bd6:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107bda:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107be1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107be5:	c7 04 24 2c aa 10 c0 	movl   $0xc010aa2c,(%esp)
c0107bec:	e8 74 87 ff ff       	call   c0100365 <cprintf>
        }
        assert(vma_below_5 == NULL);
c0107bf1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107bf5:	74 24                	je     c0107c1b <check_vma_struct+0x46f>
c0107bf7:	c7 44 24 0c 51 aa 10 	movl   $0xc010aa51,0xc(%esp)
c0107bfe:	c0 
c0107bff:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c0107c06:	c0 
c0107c07:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0107c0e:	00 
c0107c0f:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c0107c16:	e8 d6 90 ff ff       	call   c0100cf1 <__panic>
    for (i =4; i>=0; i--) {
c0107c1b:	ff 4d f4             	decl   -0xc(%ebp)
c0107c1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107c22:	79 8b                	jns    c0107baf <check_vma_struct+0x403>
    }

    mm_destroy(mm);
c0107c24:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c27:	89 04 24             	mov    %eax,(%esp)
c0107c2a:	e8 92 fa ff ff       	call   c01076c1 <mm_destroy>

    assert(nr_free_pages_store == nr_free_pages());
c0107c2f:	e8 5b cd ff ff       	call   c010498f <nr_free_pages>
c0107c34:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0107c37:	74 24                	je     c0107c5d <check_vma_struct+0x4b1>
c0107c39:	c7 44 24 0c e4 a8 10 	movl   $0xc010a8e4,0xc(%esp)
c0107c40:	c0 
c0107c41:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c0107c48:	c0 
c0107c49:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0107c50:	00 
c0107c51:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c0107c58:	e8 94 90 ff ff       	call   c0100cf1 <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c0107c5d:	c7 04 24 68 aa 10 c0 	movl   $0xc010aa68,(%esp)
c0107c64:	e8 fc 86 ff ff       	call   c0100365 <cprintf>
}
c0107c69:	90                   	nop
c0107c6a:	89 ec                	mov    %ebp,%esp
c0107c6c:	5d                   	pop    %ebp
c0107c6d:	c3                   	ret    

c0107c6e <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0107c6e:	55                   	push   %ebp
c0107c6f:	89 e5                	mov    %esp,%ebp
c0107c71:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107c74:	e8 16 cd ff ff       	call   c010498f <nr_free_pages>
c0107c79:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0107c7c:	e8 f8 f6 ff ff       	call   c0107379 <mm_create>
c0107c81:	a3 0c 71 12 c0       	mov    %eax,0xc012710c
    assert(check_mm_struct != NULL);
c0107c86:	a1 0c 71 12 c0       	mov    0xc012710c,%eax
c0107c8b:	85 c0                	test   %eax,%eax
c0107c8d:	75 24                	jne    c0107cb3 <check_pgfault+0x45>
c0107c8f:	c7 44 24 0c 87 aa 10 	movl   $0xc010aa87,0xc(%esp)
c0107c96:	c0 
c0107c97:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c0107c9e:	c0 
c0107c9f:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0107ca6:	00 
c0107ca7:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c0107cae:	e8 3e 90 ff ff       	call   c0100cf1 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0107cb3:	a1 0c 71 12 c0       	mov    0xc012710c,%eax
c0107cb8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0107cbb:	8b 15 e0 39 12 c0    	mov    0xc01239e0,%edx
c0107cc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107cc4:	89 50 0c             	mov    %edx,0xc(%eax)
c0107cc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107cca:	8b 40 0c             	mov    0xc(%eax),%eax
c0107ccd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0107cd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107cd3:	8b 00                	mov    (%eax),%eax
c0107cd5:	85 c0                	test   %eax,%eax
c0107cd7:	74 24                	je     c0107cfd <check_pgfault+0x8f>
c0107cd9:	c7 44 24 0c 9f aa 10 	movl   $0xc010aa9f,0xc(%esp)
c0107ce0:	c0 
c0107ce1:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c0107ce8:	c0 
c0107ce9:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0107cf0:	00 
c0107cf1:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c0107cf8:	e8 f4 8f ff ff       	call   c0100cf1 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0107cfd:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0107d04:	00 
c0107d05:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0107d0c:	00 
c0107d0d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0107d14:	e8 db f6 ff ff       	call   c01073f4 <vma_create>
c0107d19:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0107d1c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107d20:	75 24                	jne    c0107d46 <check_pgfault+0xd8>
c0107d22:	c7 44 24 0c 2e a9 10 	movl   $0xc010a92e,0xc(%esp)
c0107d29:	c0 
c0107d2a:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c0107d31:	c0 
c0107d32:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0107d39:	00 
c0107d3a:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c0107d41:	e8 ab 8f ff ff       	call   c0100cf1 <__panic>

    insert_vma_struct(mm, vma);
c0107d46:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107d49:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d50:	89 04 24             	mov    %eax,(%esp)
c0107d53:	e8 33 f8 ff ff       	call   c010758b <insert_vma_struct>

    uintptr_t addr = 0x100;
c0107d58:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0107d5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107d62:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d66:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d69:	89 04 24             	mov    %eax,(%esp)
c0107d6c:	e8 c0 f6 ff ff       	call   c0107431 <find_vma>
c0107d71:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0107d74:	74 24                	je     c0107d9a <check_pgfault+0x12c>
c0107d76:	c7 44 24 0c ad aa 10 	movl   $0xc010aaad,0xc(%esp)
c0107d7d:	c0 
c0107d7e:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c0107d85:	c0 
c0107d86:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0107d8d:	00 
c0107d8e:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c0107d95:	e8 57 8f ff ff       	call   c0100cf1 <__panic>

    int i, sum = 0;
c0107d9a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0107da1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107da8:	eb 16                	jmp    c0107dc0 <check_pgfault+0x152>
        *(char *)(addr + i) = i;
c0107daa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107dad:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107db0:	01 d0                	add    %edx,%eax
c0107db2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107db5:	88 10                	mov    %dl,(%eax)
        sum += i;
c0107db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107dba:	01 45 f0             	add    %eax,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0107dbd:	ff 45 f4             	incl   -0xc(%ebp)
c0107dc0:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107dc4:	7e e4                	jle    c0107daa <check_pgfault+0x13c>
    }
    for (i = 0; i < 100; i ++) {
c0107dc6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107dcd:	eb 14                	jmp    c0107de3 <check_pgfault+0x175>
        sum -= *(char *)(addr + i);
c0107dcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107dd2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107dd5:	01 d0                	add    %edx,%eax
c0107dd7:	0f b6 00             	movzbl (%eax),%eax
c0107dda:	0f be c0             	movsbl %al,%eax
c0107ddd:	29 45 f0             	sub    %eax,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0107de0:	ff 45 f4             	incl   -0xc(%ebp)
c0107de3:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107de7:	7e e6                	jle    c0107dcf <check_pgfault+0x161>
    }
    assert(sum == 0);
c0107de9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107ded:	74 24                	je     c0107e13 <check_pgfault+0x1a5>
c0107def:	c7 44 24 0c c7 aa 10 	movl   $0xc010aac7,0xc(%esp)
c0107df6:	c0 
c0107df7:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c0107dfe:	c0 
c0107dff:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0107e06:	00 
c0107e07:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c0107e0e:	e8 de 8e ff ff       	call   c0100cf1 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0107e13:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107e16:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107e19:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107e1c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107e21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107e28:	89 04 24             	mov    %eax,(%esp)
c0107e2b:	e8 92 d3 ff ff       	call   c01051c2 <page_remove>
    free_page(pde2page(pgdir[0]));
c0107e30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107e33:	8b 00                	mov    (%eax),%eax
c0107e35:	89 04 24             	mov    %eax,(%esp)
c0107e38:	e8 22 f5 ff ff       	call   c010735f <pde2page>
c0107e3d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107e44:	00 
c0107e45:	89 04 24             	mov    %eax,(%esp)
c0107e48:	e8 0d cb ff ff       	call   c010495a <free_pages>
    pgdir[0] = 0;
c0107e4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107e50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0107e56:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107e59:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0107e60:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107e63:	89 04 24             	mov    %eax,(%esp)
c0107e66:	e8 56 f8 ff ff       	call   c01076c1 <mm_destroy>
    check_mm_struct = NULL;
c0107e6b:	c7 05 0c 71 12 c0 00 	movl   $0x0,0xc012710c
c0107e72:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0107e75:	e8 15 cb ff ff       	call   c010498f <nr_free_pages>
c0107e7a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0107e7d:	74 24                	je     c0107ea3 <check_pgfault+0x235>
c0107e7f:	c7 44 24 0c e4 a8 10 	movl   $0xc010a8e4,0xc(%esp)
c0107e86:	c0 
c0107e87:	c7 44 24 08 63 a8 10 	movl   $0xc010a863,0x8(%esp)
c0107e8e:	c0 
c0107e8f:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0107e96:	00 
c0107e97:	c7 04 24 78 a8 10 c0 	movl   $0xc010a878,(%esp)
c0107e9e:	e8 4e 8e ff ff       	call   c0100cf1 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0107ea3:	c7 04 24 d0 aa 10 c0 	movl   $0xc010aad0,(%esp)
c0107eaa:	e8 b6 84 ff ff       	call   c0100365 <cprintf>
}
c0107eaf:	90                   	nop
c0107eb0:	89 ec                	mov    %ebp,%esp
c0107eb2:	5d                   	pop    %ebp
c0107eb3:	c3                   	ret    

c0107eb4 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0107eb4:	55                   	push   %ebp
c0107eb5:	89 e5                	mov    %esp,%ebp
c0107eb7:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0107eba:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0107ec1:	8b 45 10             	mov    0x10(%ebp),%eax
c0107ec4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ec8:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ecb:	89 04 24             	mov    %eax,(%esp)
c0107ece:	e8 5e f5 ff ff       	call   c0107431 <find_vma>
c0107ed3:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0107ed6:	a1 10 71 12 c0       	mov    0xc0127110,%eax
c0107edb:	40                   	inc    %eax
c0107edc:	a3 10 71 12 c0       	mov    %eax,0xc0127110
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0107ee1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107ee5:	74 0b                	je     c0107ef2 <do_pgfault+0x3e>
c0107ee7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107eea:	8b 40 04             	mov    0x4(%eax),%eax
c0107eed:	39 45 10             	cmp    %eax,0x10(%ebp)
c0107ef0:	73 18                	jae    c0107f0a <do_pgfault+0x56>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0107ef2:	8b 45 10             	mov    0x10(%ebp),%eax
c0107ef5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ef9:	c7 04 24 ec aa 10 c0 	movl   $0xc010aaec,(%esp)
c0107f00:	e8 60 84 ff ff       	call   c0100365 <cprintf>
        goto failed;
c0107f05:	e9 ba 01 00 00       	jmp    c01080c4 <do_pgfault+0x210>
    }
    //check the error_code
    switch (error_code & 3) {
c0107f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f0d:	83 e0 03             	and    $0x3,%eax
c0107f10:	85 c0                	test   %eax,%eax
c0107f12:	74 34                	je     c0107f48 <do_pgfault+0x94>
c0107f14:	83 f8 01             	cmp    $0x1,%eax
c0107f17:	74 1e                	je     c0107f37 <do_pgfault+0x83>
    default:
        /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0107f19:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107f1c:	8b 40 0c             	mov    0xc(%eax),%eax
c0107f1f:	83 e0 02             	and    $0x2,%eax
c0107f22:	85 c0                	test   %eax,%eax
c0107f24:	75 40                	jne    c0107f66 <do_pgfault+0xb2>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0107f26:	c7 04 24 1c ab 10 c0 	movl   $0xc010ab1c,(%esp)
c0107f2d:	e8 33 84 ff ff       	call   c0100365 <cprintf>
            goto failed;
c0107f32:	e9 8d 01 00 00       	jmp    c01080c4 <do_pgfault+0x210>
        }
        break;
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0107f37:	c7 04 24 7c ab 10 c0 	movl   $0xc010ab7c,(%esp)
c0107f3e:	e8 22 84 ff ff       	call   c0100365 <cprintf>
        goto failed;
c0107f43:	e9 7c 01 00 00       	jmp    c01080c4 <do_pgfault+0x210>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0107f48:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107f4b:	8b 40 0c             	mov    0xc(%eax),%eax
c0107f4e:	83 e0 05             	and    $0x5,%eax
c0107f51:	85 c0                	test   %eax,%eax
c0107f53:	75 12                	jne    c0107f67 <do_pgfault+0xb3>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0107f55:	c7 04 24 b4 ab 10 c0 	movl   $0xc010abb4,(%esp)
c0107f5c:	e8 04 84 ff ff       	call   c0100365 <cprintf>
            goto failed;
c0107f61:	e9 5e 01 00 00       	jmp    c01080c4 <do_pgfault+0x210>
        break;
c0107f66:	90                   	nop
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0107f67:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0107f6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107f71:	8b 40 0c             	mov    0xc(%eax),%eax
c0107f74:	83 e0 02             	and    $0x2,%eax
c0107f77:	85 c0                	test   %eax,%eax
c0107f79:	74 04                	je     c0107f7f <do_pgfault+0xcb>
        perm |= PTE_W;
c0107f7b:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0107f7f:	8b 45 10             	mov    0x10(%ebp),%eax
c0107f82:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107f85:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107f8d:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0107f90:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep = NULL;
c0107f97:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
     * VARIABLES:
     *   mm->pgdir : the PDT of these vma
     *
     */
    //(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    ptep = get_pte(mm->pgdir, addr, 1);
c0107f9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fa1:	8b 40 0c             	mov    0xc(%eax),%eax
c0107fa4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0107fab:	00 
c0107fac:	8b 55 10             	mov    0x10(%ebp),%edx
c0107faf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107fb3:	89 04 24             	mov    %eax,(%esp)
c0107fb6:	e8 e8 cf ff ff       	call   c0104fa3 <get_pte>
c0107fbb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (ptep == NULL) {
c0107fbe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107fc2:	75 11                	jne    c0107fd5 <do_pgfault+0x121>
        cprintf("get_pte in do_pgfault failed\n");
c0107fc4:	c7 04 24 17 ac 10 c0 	movl   $0xc010ac17,(%esp)
c0107fcb:	e8 95 83 ff ff       	call   c0100365 <cprintf>
        goto failed;
c0107fd0:	e9 ef 00 00 00       	jmp    c01080c4 <do_pgfault+0x210>
    }
    //(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
    if (*ptep == 0) {
c0107fd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107fd8:	8b 00                	mov    (%eax),%eax
c0107fda:	85 c0                	test   %eax,%eax
c0107fdc:	75 35                	jne    c0108013 <do_pgfault+0x15f>
        // 分配物理页，并且与对应的虚拟页建立映射关系
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
c0107fde:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fe1:	8b 40 0c             	mov    0xc(%eax),%eax
c0107fe4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107fe7:	89 54 24 08          	mov    %edx,0x8(%esp)
c0107feb:	8b 55 10             	mov    0x10(%ebp),%edx
c0107fee:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107ff2:	89 04 24             	mov    %eax,(%esp)
c0107ff5:	e8 29 d3 ff ff       	call   c0105323 <pgdir_alloc_page>
c0107ffa:	85 c0                	test   %eax,%eax
c0107ffc:	0f 85 bb 00 00 00    	jne    c01080bd <do_pgfault+0x209>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
c0108002:	c7 04 24 38 ac 10 c0 	movl   $0xc010ac38,(%esp)
c0108009:	e8 57 83 ff ff       	call   c0100365 <cprintf>
            goto failed;
c010800e:	e9 b1 00 00 00       	jmp    c01080c4 <do_pgfault+0x210>
         *                               find the addr of disk page, read the content of disk page into this memroy page
         *    page_insert ： build the map of phy addr of an Page with the linear addr la
         *    swap_map_swappable ： set the page swappable
         */
        // 判断是否当前交换机制正确被初始化
        if (swap_init_ok) {
c0108013:	a1 44 70 12 c0       	mov    0xc0127044,%eax
c0108018:	85 c0                	test   %eax,%eax
c010801a:	0f 84 86 00 00 00    	je     c01080a6 <do_pgfault+0x1f2>
            struct Page *page = NULL;
c0108020:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            //(1）According to the mm AND addr, try to load the content of right disk page into the memory which page managed.
            // 将物理页换入到内存中
            ret = swap_in(mm, addr, &page);
c0108027:	8d 45 e0             	lea    -0x20(%ebp),%eax
c010802a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010802e:	8b 45 10             	mov    0x10(%ebp),%eax
c0108031:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108035:	8b 45 08             	mov    0x8(%ebp),%eax
c0108038:	89 04 24             	mov    %eax,(%esp)
c010803b:	e8 ad e4 ff ff       	call   c01064ed <swap_in>
c0108040:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (ret != 0) {
c0108043:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108047:	74 0e                	je     c0108057 <do_pgfault+0x1a3>
                cprintf("swap_in in do_pgfault failed\n");
c0108049:	c7 04 24 5f ac 10 c0 	movl   $0xc010ac5f,(%esp)
c0108050:	e8 10 83 ff ff       	call   c0100365 <cprintf>
c0108055:	eb 6d                	jmp    c01080c4 <do_pgfault+0x210>
                goto failed;
            }
            //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
            // 将物理页与虚拟页建立映射关系
            page_insert(mm->pgdir, page, addr, perm); 
c0108057:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010805a:	8b 45 08             	mov    0x8(%ebp),%eax
c010805d:	8b 40 0c             	mov    0xc(%eax),%eax
c0108060:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0108063:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0108067:	8b 4d 10             	mov    0x10(%ebp),%ecx
c010806a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010806e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108072:	89 04 24             	mov    %eax,(%esp)
c0108075:	e8 8f d1 ff ff       	call   c0105209 <page_insert>
            //(3) make the page swappable.
            // 设置当前的物理页为可交换的
            swap_map_swappable(mm, addr, page, 1);
c010807a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010807d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0108084:	00 
c0108085:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108089:	8b 45 10             	mov    0x10(%ebp),%eax
c010808c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108090:	8b 45 08             	mov    0x8(%ebp),%eax
c0108093:	89 04 24             	mov    %eax,(%esp)
c0108096:	e8 8a e2 ff ff       	call   c0106325 <swap_map_swappable>
            // 同时在物理页中维护其对应到的虚拟页的信息
            page->pra_vaddr = addr;
c010809b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010809e:	8b 55 10             	mov    0x10(%ebp),%edx
c01080a1:	89 50 1c             	mov    %edx,0x1c(%eax)
c01080a4:	eb 17                	jmp    c01080bd <do_pgfault+0x209>
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c01080a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01080a9:	8b 00                	mov    (%eax),%eax
c01080ab:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080af:	c7 04 24 80 ac 10 c0 	movl   $0xc010ac80,(%esp)
c01080b6:	e8 aa 82 ff ff       	call   c0100365 <cprintf>
            goto failed;
c01080bb:	eb 07                	jmp    c01080c4 <do_pgfault+0x210>
        }
   }
#endif
    ret = 0;
c01080bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c01080c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01080c7:	89 ec                	mov    %ebp,%esp
c01080c9:	5d                   	pop    %ebp
c01080ca:	c3                   	ret    

c01080cb <page2ppn>:
page2ppn(struct Page *page) {
c01080cb:	55                   	push   %ebp
c01080cc:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01080ce:	8b 15 a0 6f 12 c0    	mov    0xc0126fa0,%edx
c01080d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01080d7:	29 d0                	sub    %edx,%eax
c01080d9:	c1 f8 05             	sar    $0x5,%eax
}
c01080dc:	5d                   	pop    %ebp
c01080dd:	c3                   	ret    

c01080de <page2pa>:
page2pa(struct Page *page) {
c01080de:	55                   	push   %ebp
c01080df:	89 e5                	mov    %esp,%ebp
c01080e1:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01080e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01080e7:	89 04 24             	mov    %eax,(%esp)
c01080ea:	e8 dc ff ff ff       	call   c01080cb <page2ppn>
c01080ef:	c1 e0 0c             	shl    $0xc,%eax
}
c01080f2:	89 ec                	mov    %ebp,%esp
c01080f4:	5d                   	pop    %ebp
c01080f5:	c3                   	ret    

c01080f6 <page2kva>:
page2kva(struct Page *page) {
c01080f6:	55                   	push   %ebp
c01080f7:	89 e5                	mov    %esp,%ebp
c01080f9:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01080fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01080ff:	89 04 24             	mov    %eax,(%esp)
c0108102:	e8 d7 ff ff ff       	call   c01080de <page2pa>
c0108107:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010810a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010810d:	c1 e8 0c             	shr    $0xc,%eax
c0108110:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108113:	a1 a4 6f 12 c0       	mov    0xc0126fa4,%eax
c0108118:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010811b:	72 23                	jb     c0108140 <page2kva+0x4a>
c010811d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108120:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108124:	c7 44 24 08 a8 ac 10 	movl   $0xc010aca8,0x8(%esp)
c010812b:	c0 
c010812c:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0108133:	00 
c0108134:	c7 04 24 cb ac 10 c0 	movl   $0xc010accb,(%esp)
c010813b:	e8 b1 8b ff ff       	call   c0100cf1 <__panic>
c0108140:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108143:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0108148:	89 ec                	mov    %ebp,%esp
c010814a:	5d                   	pop    %ebp
c010814b:	c3                   	ret    

c010814c <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c010814c:	55                   	push   %ebp
c010814d:	89 e5                	mov    %esp,%ebp
c010814f:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0108152:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108159:	e8 42 99 ff ff       	call   c0101aa0 <ide_device_valid>
c010815e:	85 c0                	test   %eax,%eax
c0108160:	75 1c                	jne    c010817e <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c0108162:	c7 44 24 08 d9 ac 10 	movl   $0xc010acd9,0x8(%esp)
c0108169:	c0 
c010816a:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c0108171:	00 
c0108172:	c7 04 24 f3 ac 10 c0 	movl   $0xc010acf3,(%esp)
c0108179:	e8 73 8b ff ff       	call   c0100cf1 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c010817e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108185:	e8 56 99 ff ff       	call   c0101ae0 <ide_device_size>
c010818a:	c1 e8 03             	shr    $0x3,%eax
c010818d:	a3 40 70 12 c0       	mov    %eax,0xc0127040
}
c0108192:	90                   	nop
c0108193:	89 ec                	mov    %ebp,%esp
c0108195:	5d                   	pop    %ebp
c0108196:	c3                   	ret    

c0108197 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0108197:	55                   	push   %ebp
c0108198:	89 e5                	mov    %esp,%ebp
c010819a:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c010819d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081a0:	89 04 24             	mov    %eax,(%esp)
c01081a3:	e8 4e ff ff ff       	call   c01080f6 <page2kva>
c01081a8:	8b 55 08             	mov    0x8(%ebp),%edx
c01081ab:	c1 ea 08             	shr    $0x8,%edx
c01081ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01081b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01081b5:	74 0b                	je     c01081c2 <swapfs_read+0x2b>
c01081b7:	8b 15 40 70 12 c0    	mov    0xc0127040,%edx
c01081bd:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c01081c0:	72 23                	jb     c01081e5 <swapfs_read+0x4e>
c01081c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01081c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01081c9:	c7 44 24 08 04 ad 10 	movl   $0xc010ad04,0x8(%esp)
c01081d0:	c0 
c01081d1:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c01081d8:	00 
c01081d9:	c7 04 24 f3 ac 10 c0 	movl   $0xc010acf3,(%esp)
c01081e0:	e8 0c 8b ff ff       	call   c0100cf1 <__panic>
c01081e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01081e8:	c1 e2 03             	shl    $0x3,%edx
c01081eb:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c01081f2:	00 
c01081f3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01081f7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01081fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108202:	e8 16 99 ff ff       	call   c0101b1d <ide_read_secs>
}
c0108207:	89 ec                	mov    %ebp,%esp
c0108209:	5d                   	pop    %ebp
c010820a:	c3                   	ret    

c010820b <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c010820b:	55                   	push   %ebp
c010820c:	89 e5                	mov    %esp,%ebp
c010820e:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108211:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108214:	89 04 24             	mov    %eax,(%esp)
c0108217:	e8 da fe ff ff       	call   c01080f6 <page2kva>
c010821c:	8b 55 08             	mov    0x8(%ebp),%edx
c010821f:	c1 ea 08             	shr    $0x8,%edx
c0108222:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108225:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108229:	74 0b                	je     c0108236 <swapfs_write+0x2b>
c010822b:	8b 15 40 70 12 c0    	mov    0xc0127040,%edx
c0108231:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0108234:	72 23                	jb     c0108259 <swapfs_write+0x4e>
c0108236:	8b 45 08             	mov    0x8(%ebp),%eax
c0108239:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010823d:	c7 44 24 08 04 ad 10 	movl   $0xc010ad04,0x8(%esp)
c0108244:	c0 
c0108245:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c010824c:	00 
c010824d:	c7 04 24 f3 ac 10 c0 	movl   $0xc010acf3,(%esp)
c0108254:	e8 98 8a ff ff       	call   c0100cf1 <__panic>
c0108259:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010825c:	c1 e2 03             	shl    $0x3,%edx
c010825f:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0108266:	00 
c0108267:	89 44 24 08          	mov    %eax,0x8(%esp)
c010826b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010826f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108276:	e8 e3 9a ff ff       	call   c0101d5e <ide_write_secs>
}
c010827b:	89 ec                	mov    %ebp,%esp
c010827d:	5d                   	pop    %ebp
c010827e:	c3                   	ret    

c010827f <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010827f:	55                   	push   %ebp
c0108280:	89 e5                	mov    %esp,%ebp
c0108282:	83 ec 58             	sub    $0x58,%esp
c0108285:	8b 45 10             	mov    0x10(%ebp),%eax
c0108288:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010828b:	8b 45 14             	mov    0x14(%ebp),%eax
c010828e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0108291:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108294:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108297:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010829a:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010829d:	8b 45 18             	mov    0x18(%ebp),%eax
c01082a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01082a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01082a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01082a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01082ac:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01082af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01082b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01082b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01082b9:	74 1c                	je     c01082d7 <printnum+0x58>
c01082bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01082be:	ba 00 00 00 00       	mov    $0x0,%edx
c01082c3:	f7 75 e4             	divl   -0x1c(%ebp)
c01082c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01082c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01082cc:	ba 00 00 00 00       	mov    $0x0,%edx
c01082d1:	f7 75 e4             	divl   -0x1c(%ebp)
c01082d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01082d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01082da:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01082dd:	f7 75 e4             	divl   -0x1c(%ebp)
c01082e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01082e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01082e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01082e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01082ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01082ef:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01082f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01082f5:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01082f8:	8b 45 18             	mov    0x18(%ebp),%eax
c01082fb:	ba 00 00 00 00       	mov    $0x0,%edx
c0108300:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0108303:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0108306:	19 d1                	sbb    %edx,%ecx
c0108308:	72 4c                	jb     c0108356 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
c010830a:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010830d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108310:	8b 45 20             	mov    0x20(%ebp),%eax
c0108313:	89 44 24 18          	mov    %eax,0x18(%esp)
c0108317:	89 54 24 14          	mov    %edx,0x14(%esp)
c010831b:	8b 45 18             	mov    0x18(%ebp),%eax
c010831e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0108322:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108325:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108328:	89 44 24 08          	mov    %eax,0x8(%esp)
c010832c:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108330:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108333:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108337:	8b 45 08             	mov    0x8(%ebp),%eax
c010833a:	89 04 24             	mov    %eax,(%esp)
c010833d:	e8 3d ff ff ff       	call   c010827f <printnum>
c0108342:	eb 1b                	jmp    c010835f <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0108344:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108347:	89 44 24 04          	mov    %eax,0x4(%esp)
c010834b:	8b 45 20             	mov    0x20(%ebp),%eax
c010834e:	89 04 24             	mov    %eax,(%esp)
c0108351:	8b 45 08             	mov    0x8(%ebp),%eax
c0108354:	ff d0                	call   *%eax
        while (-- width > 0)
c0108356:	ff 4d 1c             	decl   0x1c(%ebp)
c0108359:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010835d:	7f e5                	jg     c0108344 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010835f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108362:	05 a4 ad 10 c0       	add    $0xc010ada4,%eax
c0108367:	0f b6 00             	movzbl (%eax),%eax
c010836a:	0f be c0             	movsbl %al,%eax
c010836d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108370:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108374:	89 04 24             	mov    %eax,(%esp)
c0108377:	8b 45 08             	mov    0x8(%ebp),%eax
c010837a:	ff d0                	call   *%eax
}
c010837c:	90                   	nop
c010837d:	89 ec                	mov    %ebp,%esp
c010837f:	5d                   	pop    %ebp
c0108380:	c3                   	ret    

c0108381 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0108381:	55                   	push   %ebp
c0108382:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0108384:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0108388:	7e 14                	jle    c010839e <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010838a:	8b 45 08             	mov    0x8(%ebp),%eax
c010838d:	8b 00                	mov    (%eax),%eax
c010838f:	8d 48 08             	lea    0x8(%eax),%ecx
c0108392:	8b 55 08             	mov    0x8(%ebp),%edx
c0108395:	89 0a                	mov    %ecx,(%edx)
c0108397:	8b 50 04             	mov    0x4(%eax),%edx
c010839a:	8b 00                	mov    (%eax),%eax
c010839c:	eb 30                	jmp    c01083ce <getuint+0x4d>
    }
    else if (lflag) {
c010839e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01083a2:	74 16                	je     c01083ba <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01083a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01083a7:	8b 00                	mov    (%eax),%eax
c01083a9:	8d 48 04             	lea    0x4(%eax),%ecx
c01083ac:	8b 55 08             	mov    0x8(%ebp),%edx
c01083af:	89 0a                	mov    %ecx,(%edx)
c01083b1:	8b 00                	mov    (%eax),%eax
c01083b3:	ba 00 00 00 00       	mov    $0x0,%edx
c01083b8:	eb 14                	jmp    c01083ce <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01083ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01083bd:	8b 00                	mov    (%eax),%eax
c01083bf:	8d 48 04             	lea    0x4(%eax),%ecx
c01083c2:	8b 55 08             	mov    0x8(%ebp),%edx
c01083c5:	89 0a                	mov    %ecx,(%edx)
c01083c7:	8b 00                	mov    (%eax),%eax
c01083c9:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01083ce:	5d                   	pop    %ebp
c01083cf:	c3                   	ret    

c01083d0 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01083d0:	55                   	push   %ebp
c01083d1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01083d3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01083d7:	7e 14                	jle    c01083ed <getint+0x1d>
        return va_arg(*ap, long long);
c01083d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01083dc:	8b 00                	mov    (%eax),%eax
c01083de:	8d 48 08             	lea    0x8(%eax),%ecx
c01083e1:	8b 55 08             	mov    0x8(%ebp),%edx
c01083e4:	89 0a                	mov    %ecx,(%edx)
c01083e6:	8b 50 04             	mov    0x4(%eax),%edx
c01083e9:	8b 00                	mov    (%eax),%eax
c01083eb:	eb 28                	jmp    c0108415 <getint+0x45>
    }
    else if (lflag) {
c01083ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01083f1:	74 12                	je     c0108405 <getint+0x35>
        return va_arg(*ap, long);
c01083f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01083f6:	8b 00                	mov    (%eax),%eax
c01083f8:	8d 48 04             	lea    0x4(%eax),%ecx
c01083fb:	8b 55 08             	mov    0x8(%ebp),%edx
c01083fe:	89 0a                	mov    %ecx,(%edx)
c0108400:	8b 00                	mov    (%eax),%eax
c0108402:	99                   	cltd   
c0108403:	eb 10                	jmp    c0108415 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0108405:	8b 45 08             	mov    0x8(%ebp),%eax
c0108408:	8b 00                	mov    (%eax),%eax
c010840a:	8d 48 04             	lea    0x4(%eax),%ecx
c010840d:	8b 55 08             	mov    0x8(%ebp),%edx
c0108410:	89 0a                	mov    %ecx,(%edx)
c0108412:	8b 00                	mov    (%eax),%eax
c0108414:	99                   	cltd   
    }
}
c0108415:	5d                   	pop    %ebp
c0108416:	c3                   	ret    

c0108417 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0108417:	55                   	push   %ebp
c0108418:	89 e5                	mov    %esp,%ebp
c010841a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010841d:	8d 45 14             	lea    0x14(%ebp),%eax
c0108420:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0108423:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108426:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010842a:	8b 45 10             	mov    0x10(%ebp),%eax
c010842d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108431:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108434:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108438:	8b 45 08             	mov    0x8(%ebp),%eax
c010843b:	89 04 24             	mov    %eax,(%esp)
c010843e:	e8 05 00 00 00       	call   c0108448 <vprintfmt>
    va_end(ap);
}
c0108443:	90                   	nop
c0108444:	89 ec                	mov    %ebp,%esp
c0108446:	5d                   	pop    %ebp
c0108447:	c3                   	ret    

c0108448 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0108448:	55                   	push   %ebp
c0108449:	89 e5                	mov    %esp,%ebp
c010844b:	56                   	push   %esi
c010844c:	53                   	push   %ebx
c010844d:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108450:	eb 17                	jmp    c0108469 <vprintfmt+0x21>
            if (ch == '\0') {
c0108452:	85 db                	test   %ebx,%ebx
c0108454:	0f 84 bf 03 00 00    	je     c0108819 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c010845a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010845d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108461:	89 1c 24             	mov    %ebx,(%esp)
c0108464:	8b 45 08             	mov    0x8(%ebp),%eax
c0108467:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108469:	8b 45 10             	mov    0x10(%ebp),%eax
c010846c:	8d 50 01             	lea    0x1(%eax),%edx
c010846f:	89 55 10             	mov    %edx,0x10(%ebp)
c0108472:	0f b6 00             	movzbl (%eax),%eax
c0108475:	0f b6 d8             	movzbl %al,%ebx
c0108478:	83 fb 25             	cmp    $0x25,%ebx
c010847b:	75 d5                	jne    c0108452 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c010847d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0108481:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0108488:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010848b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010848e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0108495:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108498:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010849b:	8b 45 10             	mov    0x10(%ebp),%eax
c010849e:	8d 50 01             	lea    0x1(%eax),%edx
c01084a1:	89 55 10             	mov    %edx,0x10(%ebp)
c01084a4:	0f b6 00             	movzbl (%eax),%eax
c01084a7:	0f b6 d8             	movzbl %al,%ebx
c01084aa:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01084ad:	83 f8 55             	cmp    $0x55,%eax
c01084b0:	0f 87 37 03 00 00    	ja     c01087ed <vprintfmt+0x3a5>
c01084b6:	8b 04 85 c8 ad 10 c0 	mov    -0x3fef5238(,%eax,4),%eax
c01084bd:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01084bf:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01084c3:	eb d6                	jmp    c010849b <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01084c5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01084c9:	eb d0                	jmp    c010849b <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01084cb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01084d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01084d5:	89 d0                	mov    %edx,%eax
c01084d7:	c1 e0 02             	shl    $0x2,%eax
c01084da:	01 d0                	add    %edx,%eax
c01084dc:	01 c0                	add    %eax,%eax
c01084de:	01 d8                	add    %ebx,%eax
c01084e0:	83 e8 30             	sub    $0x30,%eax
c01084e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01084e6:	8b 45 10             	mov    0x10(%ebp),%eax
c01084e9:	0f b6 00             	movzbl (%eax),%eax
c01084ec:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01084ef:	83 fb 2f             	cmp    $0x2f,%ebx
c01084f2:	7e 38                	jle    c010852c <vprintfmt+0xe4>
c01084f4:	83 fb 39             	cmp    $0x39,%ebx
c01084f7:	7f 33                	jg     c010852c <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c01084f9:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c01084fc:	eb d4                	jmp    c01084d2 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c01084fe:	8b 45 14             	mov    0x14(%ebp),%eax
c0108501:	8d 50 04             	lea    0x4(%eax),%edx
c0108504:	89 55 14             	mov    %edx,0x14(%ebp)
c0108507:	8b 00                	mov    (%eax),%eax
c0108509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010850c:	eb 1f                	jmp    c010852d <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c010850e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108512:	79 87                	jns    c010849b <vprintfmt+0x53>
                width = 0;
c0108514:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010851b:	e9 7b ff ff ff       	jmp    c010849b <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0108520:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0108527:	e9 6f ff ff ff       	jmp    c010849b <vprintfmt+0x53>
            goto process_precision;
c010852c:	90                   	nop

        process_precision:
            if (width < 0)
c010852d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108531:	0f 89 64 ff ff ff    	jns    c010849b <vprintfmt+0x53>
                width = precision, precision = -1;
c0108537:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010853a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010853d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0108544:	e9 52 ff ff ff       	jmp    c010849b <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0108549:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c010854c:	e9 4a ff ff ff       	jmp    c010849b <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0108551:	8b 45 14             	mov    0x14(%ebp),%eax
c0108554:	8d 50 04             	lea    0x4(%eax),%edx
c0108557:	89 55 14             	mov    %edx,0x14(%ebp)
c010855a:	8b 00                	mov    (%eax),%eax
c010855c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010855f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108563:	89 04 24             	mov    %eax,(%esp)
c0108566:	8b 45 08             	mov    0x8(%ebp),%eax
c0108569:	ff d0                	call   *%eax
            break;
c010856b:	e9 a4 02 00 00       	jmp    c0108814 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0108570:	8b 45 14             	mov    0x14(%ebp),%eax
c0108573:	8d 50 04             	lea    0x4(%eax),%edx
c0108576:	89 55 14             	mov    %edx,0x14(%ebp)
c0108579:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010857b:	85 db                	test   %ebx,%ebx
c010857d:	79 02                	jns    c0108581 <vprintfmt+0x139>
                err = -err;
c010857f:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0108581:	83 fb 06             	cmp    $0x6,%ebx
c0108584:	7f 0b                	jg     c0108591 <vprintfmt+0x149>
c0108586:	8b 34 9d 88 ad 10 c0 	mov    -0x3fef5278(,%ebx,4),%esi
c010858d:	85 f6                	test   %esi,%esi
c010858f:	75 23                	jne    c01085b4 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c0108591:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0108595:	c7 44 24 08 b5 ad 10 	movl   $0xc010adb5,0x8(%esp)
c010859c:	c0 
c010859d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01085a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01085a7:	89 04 24             	mov    %eax,(%esp)
c01085aa:	e8 68 fe ff ff       	call   c0108417 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01085af:	e9 60 02 00 00       	jmp    c0108814 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c01085b4:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01085b8:	c7 44 24 08 be ad 10 	movl   $0xc010adbe,0x8(%esp)
c01085bf:	c0 
c01085c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085c3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01085c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01085ca:	89 04 24             	mov    %eax,(%esp)
c01085cd:	e8 45 fe ff ff       	call   c0108417 <printfmt>
            break;
c01085d2:	e9 3d 02 00 00       	jmp    c0108814 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01085d7:	8b 45 14             	mov    0x14(%ebp),%eax
c01085da:	8d 50 04             	lea    0x4(%eax),%edx
c01085dd:	89 55 14             	mov    %edx,0x14(%ebp)
c01085e0:	8b 30                	mov    (%eax),%esi
c01085e2:	85 f6                	test   %esi,%esi
c01085e4:	75 05                	jne    c01085eb <vprintfmt+0x1a3>
                p = "(null)";
c01085e6:	be c1 ad 10 c0       	mov    $0xc010adc1,%esi
            }
            if (width > 0 && padc != '-') {
c01085eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01085ef:	7e 76                	jle    c0108667 <vprintfmt+0x21f>
c01085f1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01085f5:	74 70                	je     c0108667 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01085f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01085fa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01085fe:	89 34 24             	mov    %esi,(%esp)
c0108601:	e8 ee 03 00 00       	call   c01089f4 <strnlen>
c0108606:	89 c2                	mov    %eax,%edx
c0108608:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010860b:	29 d0                	sub    %edx,%eax
c010860d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108610:	eb 16                	jmp    c0108628 <vprintfmt+0x1e0>
                    putch(padc, putdat);
c0108612:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0108616:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108619:	89 54 24 04          	mov    %edx,0x4(%esp)
c010861d:	89 04 24             	mov    %eax,(%esp)
c0108620:	8b 45 08             	mov    0x8(%ebp),%eax
c0108623:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108625:	ff 4d e8             	decl   -0x18(%ebp)
c0108628:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010862c:	7f e4                	jg     c0108612 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010862e:	eb 37                	jmp    c0108667 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c0108630:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108634:	74 1f                	je     c0108655 <vprintfmt+0x20d>
c0108636:	83 fb 1f             	cmp    $0x1f,%ebx
c0108639:	7e 05                	jle    c0108640 <vprintfmt+0x1f8>
c010863b:	83 fb 7e             	cmp    $0x7e,%ebx
c010863e:	7e 15                	jle    c0108655 <vprintfmt+0x20d>
                    putch('?', putdat);
c0108640:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108643:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108647:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010864e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108651:	ff d0                	call   *%eax
c0108653:	eb 0f                	jmp    c0108664 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c0108655:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108658:	89 44 24 04          	mov    %eax,0x4(%esp)
c010865c:	89 1c 24             	mov    %ebx,(%esp)
c010865f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108662:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108664:	ff 4d e8             	decl   -0x18(%ebp)
c0108667:	89 f0                	mov    %esi,%eax
c0108669:	8d 70 01             	lea    0x1(%eax),%esi
c010866c:	0f b6 00             	movzbl (%eax),%eax
c010866f:	0f be d8             	movsbl %al,%ebx
c0108672:	85 db                	test   %ebx,%ebx
c0108674:	74 27                	je     c010869d <vprintfmt+0x255>
c0108676:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010867a:	78 b4                	js     c0108630 <vprintfmt+0x1e8>
c010867c:	ff 4d e4             	decl   -0x1c(%ebp)
c010867f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108683:	79 ab                	jns    c0108630 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c0108685:	eb 16                	jmp    c010869d <vprintfmt+0x255>
                putch(' ', putdat);
c0108687:	8b 45 0c             	mov    0xc(%ebp),%eax
c010868a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010868e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0108695:	8b 45 08             	mov    0x8(%ebp),%eax
c0108698:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c010869a:	ff 4d e8             	decl   -0x18(%ebp)
c010869d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01086a1:	7f e4                	jg     c0108687 <vprintfmt+0x23f>
            }
            break;
c01086a3:	e9 6c 01 00 00       	jmp    c0108814 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01086a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01086ab:	89 44 24 04          	mov    %eax,0x4(%esp)
c01086af:	8d 45 14             	lea    0x14(%ebp),%eax
c01086b2:	89 04 24             	mov    %eax,(%esp)
c01086b5:	e8 16 fd ff ff       	call   c01083d0 <getint>
c01086ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01086bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01086c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01086c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01086c6:	85 d2                	test   %edx,%edx
c01086c8:	79 26                	jns    c01086f0 <vprintfmt+0x2a8>
                putch('-', putdat);
c01086ca:	8b 45 0c             	mov    0xc(%ebp),%eax
c01086cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01086d1:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01086d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01086db:	ff d0                	call   *%eax
                num = -(long long)num;
c01086dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01086e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01086e3:	f7 d8                	neg    %eax
c01086e5:	83 d2 00             	adc    $0x0,%edx
c01086e8:	f7 da                	neg    %edx
c01086ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01086ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01086f0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01086f7:	e9 a8 00 00 00       	jmp    c01087a4 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01086fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01086ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108703:	8d 45 14             	lea    0x14(%ebp),%eax
c0108706:	89 04 24             	mov    %eax,(%esp)
c0108709:	e8 73 fc ff ff       	call   c0108381 <getuint>
c010870e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108711:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0108714:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010871b:	e9 84 00 00 00       	jmp    c01087a4 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0108720:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108723:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108727:	8d 45 14             	lea    0x14(%ebp),%eax
c010872a:	89 04 24             	mov    %eax,(%esp)
c010872d:	e8 4f fc ff ff       	call   c0108381 <getuint>
c0108732:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108735:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0108738:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010873f:	eb 63                	jmp    c01087a4 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c0108741:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108744:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108748:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010874f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108752:	ff d0                	call   *%eax
            putch('x', putdat);
c0108754:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108757:	89 44 24 04          	mov    %eax,0x4(%esp)
c010875b:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0108762:	8b 45 08             	mov    0x8(%ebp),%eax
c0108765:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0108767:	8b 45 14             	mov    0x14(%ebp),%eax
c010876a:	8d 50 04             	lea    0x4(%eax),%edx
c010876d:	89 55 14             	mov    %edx,0x14(%ebp)
c0108770:	8b 00                	mov    (%eax),%eax
c0108772:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108775:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010877c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0108783:	eb 1f                	jmp    c01087a4 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0108785:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108788:	89 44 24 04          	mov    %eax,0x4(%esp)
c010878c:	8d 45 14             	lea    0x14(%ebp),%eax
c010878f:	89 04 24             	mov    %eax,(%esp)
c0108792:	e8 ea fb ff ff       	call   c0108381 <getuint>
c0108797:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010879a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010879d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01087a4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01087a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01087ab:	89 54 24 18          	mov    %edx,0x18(%esp)
c01087af:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01087b2:	89 54 24 14          	mov    %edx,0x14(%esp)
c01087b6:	89 44 24 10          	mov    %eax,0x10(%esp)
c01087ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01087bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01087c0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01087c4:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01087c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01087cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01087d2:	89 04 24             	mov    %eax,(%esp)
c01087d5:	e8 a5 fa ff ff       	call   c010827f <printnum>
            break;
c01087da:	eb 38                	jmp    c0108814 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01087dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01087e3:	89 1c 24             	mov    %ebx,(%esp)
c01087e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01087e9:	ff d0                	call   *%eax
            break;
c01087eb:	eb 27                	jmp    c0108814 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01087ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087f0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01087f4:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01087fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01087fe:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0108800:	ff 4d 10             	decl   0x10(%ebp)
c0108803:	eb 03                	jmp    c0108808 <vprintfmt+0x3c0>
c0108805:	ff 4d 10             	decl   0x10(%ebp)
c0108808:	8b 45 10             	mov    0x10(%ebp),%eax
c010880b:	48                   	dec    %eax
c010880c:	0f b6 00             	movzbl (%eax),%eax
c010880f:	3c 25                	cmp    $0x25,%al
c0108811:	75 f2                	jne    c0108805 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c0108813:	90                   	nop
    while (1) {
c0108814:	e9 37 fc ff ff       	jmp    c0108450 <vprintfmt+0x8>
                return;
c0108819:	90                   	nop
        }
    }
}
c010881a:	83 c4 40             	add    $0x40,%esp
c010881d:	5b                   	pop    %ebx
c010881e:	5e                   	pop    %esi
c010881f:	5d                   	pop    %ebp
c0108820:	c3                   	ret    

c0108821 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0108821:	55                   	push   %ebp
c0108822:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0108824:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108827:	8b 40 08             	mov    0x8(%eax),%eax
c010882a:	8d 50 01             	lea    0x1(%eax),%edx
c010882d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108830:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0108833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108836:	8b 10                	mov    (%eax),%edx
c0108838:	8b 45 0c             	mov    0xc(%ebp),%eax
c010883b:	8b 40 04             	mov    0x4(%eax),%eax
c010883e:	39 c2                	cmp    %eax,%edx
c0108840:	73 12                	jae    c0108854 <sprintputch+0x33>
        *b->buf ++ = ch;
c0108842:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108845:	8b 00                	mov    (%eax),%eax
c0108847:	8d 48 01             	lea    0x1(%eax),%ecx
c010884a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010884d:	89 0a                	mov    %ecx,(%edx)
c010884f:	8b 55 08             	mov    0x8(%ebp),%edx
c0108852:	88 10                	mov    %dl,(%eax)
    }
}
c0108854:	90                   	nop
c0108855:	5d                   	pop    %ebp
c0108856:	c3                   	ret    

c0108857 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0108857:	55                   	push   %ebp
c0108858:	89 e5                	mov    %esp,%ebp
c010885a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010885d:	8d 45 14             	lea    0x14(%ebp),%eax
c0108860:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0108863:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108866:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010886a:	8b 45 10             	mov    0x10(%ebp),%eax
c010886d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108871:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108874:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108878:	8b 45 08             	mov    0x8(%ebp),%eax
c010887b:	89 04 24             	mov    %eax,(%esp)
c010887e:	e8 0a 00 00 00       	call   c010888d <vsnprintf>
c0108883:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0108886:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108889:	89 ec                	mov    %ebp,%esp
c010888b:	5d                   	pop    %ebp
c010888c:	c3                   	ret    

c010888d <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c010888d:	55                   	push   %ebp
c010888e:	89 e5                	mov    %esp,%ebp
c0108890:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0108893:	8b 45 08             	mov    0x8(%ebp),%eax
c0108896:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108899:	8b 45 0c             	mov    0xc(%ebp),%eax
c010889c:	8d 50 ff             	lea    -0x1(%eax),%edx
c010889f:	8b 45 08             	mov    0x8(%ebp),%eax
c01088a2:	01 d0                	add    %edx,%eax
c01088a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01088a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01088ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01088b2:	74 0a                	je     c01088be <vsnprintf+0x31>
c01088b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01088b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01088ba:	39 c2                	cmp    %eax,%edx
c01088bc:	76 07                	jbe    c01088c5 <vsnprintf+0x38>
        return -E_INVAL;
c01088be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01088c3:	eb 2a                	jmp    c01088ef <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01088c5:	8b 45 14             	mov    0x14(%ebp),%eax
c01088c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01088cc:	8b 45 10             	mov    0x10(%ebp),%eax
c01088cf:	89 44 24 08          	mov    %eax,0x8(%esp)
c01088d3:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01088d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01088da:	c7 04 24 21 88 10 c0 	movl   $0xc0108821,(%esp)
c01088e1:	e8 62 fb ff ff       	call   c0108448 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01088e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01088e9:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01088ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01088ef:	89 ec                	mov    %ebp,%esp
c01088f1:	5d                   	pop    %ebp
c01088f2:	c3                   	ret    

c01088f3 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c01088f3:	55                   	push   %ebp
c01088f4:	89 e5                	mov    %esp,%ebp
c01088f6:	57                   	push   %edi
c01088f7:	56                   	push   %esi
c01088f8:	53                   	push   %ebx
c01088f9:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c01088fc:	a1 60 3a 12 c0       	mov    0xc0123a60,%eax
c0108901:	8b 15 64 3a 12 c0    	mov    0xc0123a64,%edx
c0108907:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c010890d:	6b f0 05             	imul   $0x5,%eax,%esi
c0108910:	01 fe                	add    %edi,%esi
c0108912:	bf 6d e6 ec de       	mov    $0xdeece66d,%edi
c0108917:	f7 e7                	mul    %edi
c0108919:	01 d6                	add    %edx,%esi
c010891b:	89 f2                	mov    %esi,%edx
c010891d:	83 c0 0b             	add    $0xb,%eax
c0108920:	83 d2 00             	adc    $0x0,%edx
c0108923:	89 c7                	mov    %eax,%edi
c0108925:	83 e7 ff             	and    $0xffffffff,%edi
c0108928:	89 f9                	mov    %edi,%ecx
c010892a:	0f b7 da             	movzwl %dx,%ebx
c010892d:	89 0d 60 3a 12 c0    	mov    %ecx,0xc0123a60
c0108933:	89 1d 64 3a 12 c0    	mov    %ebx,0xc0123a64
    unsigned long long result = (next >> 12);
c0108939:	a1 60 3a 12 c0       	mov    0xc0123a60,%eax
c010893e:	8b 15 64 3a 12 c0    	mov    0xc0123a64,%edx
c0108944:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0108948:	c1 ea 0c             	shr    $0xc,%edx
c010894b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010894e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0108951:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c0108958:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010895b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010895e:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108961:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0108964:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108967:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010896a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010896e:	74 1c                	je     c010898c <rand+0x99>
c0108970:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108973:	ba 00 00 00 00       	mov    $0x0,%edx
c0108978:	f7 75 dc             	divl   -0x24(%ebp)
c010897b:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010897e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108981:	ba 00 00 00 00       	mov    $0x0,%edx
c0108986:	f7 75 dc             	divl   -0x24(%ebp)
c0108989:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010898c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010898f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108992:	f7 75 dc             	divl   -0x24(%ebp)
c0108995:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108998:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010899b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010899e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01089a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01089a4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01089a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c01089aa:	83 c4 24             	add    $0x24,%esp
c01089ad:	5b                   	pop    %ebx
c01089ae:	5e                   	pop    %esi
c01089af:	5f                   	pop    %edi
c01089b0:	5d                   	pop    %ebp
c01089b1:	c3                   	ret    

c01089b2 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c01089b2:	55                   	push   %ebp
c01089b3:	89 e5                	mov    %esp,%ebp
    next = seed;
c01089b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01089b8:	ba 00 00 00 00       	mov    $0x0,%edx
c01089bd:	a3 60 3a 12 c0       	mov    %eax,0xc0123a60
c01089c2:	89 15 64 3a 12 c0    	mov    %edx,0xc0123a64
}
c01089c8:	90                   	nop
c01089c9:	5d                   	pop    %ebp
c01089ca:	c3                   	ret    

c01089cb <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01089cb:	55                   	push   %ebp
c01089cc:	89 e5                	mov    %esp,%ebp
c01089ce:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01089d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01089d8:	eb 03                	jmp    c01089dd <strlen+0x12>
        cnt ++;
c01089da:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c01089dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01089e0:	8d 50 01             	lea    0x1(%eax),%edx
c01089e3:	89 55 08             	mov    %edx,0x8(%ebp)
c01089e6:	0f b6 00             	movzbl (%eax),%eax
c01089e9:	84 c0                	test   %al,%al
c01089eb:	75 ed                	jne    c01089da <strlen+0xf>
    }
    return cnt;
c01089ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01089f0:	89 ec                	mov    %ebp,%esp
c01089f2:	5d                   	pop    %ebp
c01089f3:	c3                   	ret    

c01089f4 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01089f4:	55                   	push   %ebp
c01089f5:	89 e5                	mov    %esp,%ebp
c01089f7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01089fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0108a01:	eb 03                	jmp    c0108a06 <strnlen+0x12>
        cnt ++;
c0108a03:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0108a06:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108a09:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108a0c:	73 10                	jae    c0108a1e <strnlen+0x2a>
c0108a0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a11:	8d 50 01             	lea    0x1(%eax),%edx
c0108a14:	89 55 08             	mov    %edx,0x8(%ebp)
c0108a17:	0f b6 00             	movzbl (%eax),%eax
c0108a1a:	84 c0                	test   %al,%al
c0108a1c:	75 e5                	jne    c0108a03 <strnlen+0xf>
    }
    return cnt;
c0108a1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108a21:	89 ec                	mov    %ebp,%esp
c0108a23:	5d                   	pop    %ebp
c0108a24:	c3                   	ret    

c0108a25 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0108a25:	55                   	push   %ebp
c0108a26:	89 e5                	mov    %esp,%ebp
c0108a28:	57                   	push   %edi
c0108a29:	56                   	push   %esi
c0108a2a:	83 ec 20             	sub    $0x20,%esp
c0108a2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108a33:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0108a39:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a3f:	89 d1                	mov    %edx,%ecx
c0108a41:	89 c2                	mov    %eax,%edx
c0108a43:	89 ce                	mov    %ecx,%esi
c0108a45:	89 d7                	mov    %edx,%edi
c0108a47:	ac                   	lods   %ds:(%esi),%al
c0108a48:	aa                   	stos   %al,%es:(%edi)
c0108a49:	84 c0                	test   %al,%al
c0108a4b:	75 fa                	jne    c0108a47 <strcpy+0x22>
c0108a4d:	89 fa                	mov    %edi,%edx
c0108a4f:	89 f1                	mov    %esi,%ecx
c0108a51:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108a54:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0108a57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0108a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0108a5d:	83 c4 20             	add    $0x20,%esp
c0108a60:	5e                   	pop    %esi
c0108a61:	5f                   	pop    %edi
c0108a62:	5d                   	pop    %ebp
c0108a63:	c3                   	ret    

c0108a64 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0108a64:	55                   	push   %ebp
c0108a65:	89 e5                	mov    %esp,%ebp
c0108a67:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0108a6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0108a70:	eb 1e                	jmp    c0108a90 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c0108a72:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a75:	0f b6 10             	movzbl (%eax),%edx
c0108a78:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108a7b:	88 10                	mov    %dl,(%eax)
c0108a7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108a80:	0f b6 00             	movzbl (%eax),%eax
c0108a83:	84 c0                	test   %al,%al
c0108a85:	74 03                	je     c0108a8a <strncpy+0x26>
            src ++;
c0108a87:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0108a8a:	ff 45 fc             	incl   -0x4(%ebp)
c0108a8d:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c0108a90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108a94:	75 dc                	jne    c0108a72 <strncpy+0xe>
    }
    return dst;
c0108a96:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0108a99:	89 ec                	mov    %ebp,%esp
c0108a9b:	5d                   	pop    %ebp
c0108a9c:	c3                   	ret    

c0108a9d <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0108a9d:	55                   	push   %ebp
c0108a9e:	89 e5                	mov    %esp,%ebp
c0108aa0:	57                   	push   %edi
c0108aa1:	56                   	push   %esi
c0108aa2:	83 ec 20             	sub    $0x20,%esp
c0108aa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0108aa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108aab:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108aae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0108ab1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108ab7:	89 d1                	mov    %edx,%ecx
c0108ab9:	89 c2                	mov    %eax,%edx
c0108abb:	89 ce                	mov    %ecx,%esi
c0108abd:	89 d7                	mov    %edx,%edi
c0108abf:	ac                   	lods   %ds:(%esi),%al
c0108ac0:	ae                   	scas   %es:(%edi),%al
c0108ac1:	75 08                	jne    c0108acb <strcmp+0x2e>
c0108ac3:	84 c0                	test   %al,%al
c0108ac5:	75 f8                	jne    c0108abf <strcmp+0x22>
c0108ac7:	31 c0                	xor    %eax,%eax
c0108ac9:	eb 04                	jmp    c0108acf <strcmp+0x32>
c0108acb:	19 c0                	sbb    %eax,%eax
c0108acd:	0c 01                	or     $0x1,%al
c0108acf:	89 fa                	mov    %edi,%edx
c0108ad1:	89 f1                	mov    %esi,%ecx
c0108ad3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108ad6:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108ad9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0108adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0108adf:	83 c4 20             	add    $0x20,%esp
c0108ae2:	5e                   	pop    %esi
c0108ae3:	5f                   	pop    %edi
c0108ae4:	5d                   	pop    %ebp
c0108ae5:	c3                   	ret    

c0108ae6 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0108ae6:	55                   	push   %ebp
c0108ae7:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0108ae9:	eb 09                	jmp    c0108af4 <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0108aeb:	ff 4d 10             	decl   0x10(%ebp)
c0108aee:	ff 45 08             	incl   0x8(%ebp)
c0108af1:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0108af4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108af8:	74 1a                	je     c0108b14 <strncmp+0x2e>
c0108afa:	8b 45 08             	mov    0x8(%ebp),%eax
c0108afd:	0f b6 00             	movzbl (%eax),%eax
c0108b00:	84 c0                	test   %al,%al
c0108b02:	74 10                	je     c0108b14 <strncmp+0x2e>
c0108b04:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b07:	0f b6 10             	movzbl (%eax),%edx
c0108b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b0d:	0f b6 00             	movzbl (%eax),%eax
c0108b10:	38 c2                	cmp    %al,%dl
c0108b12:	74 d7                	je     c0108aeb <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108b14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108b18:	74 18                	je     c0108b32 <strncmp+0x4c>
c0108b1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b1d:	0f b6 00             	movzbl (%eax),%eax
c0108b20:	0f b6 d0             	movzbl %al,%edx
c0108b23:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b26:	0f b6 00             	movzbl (%eax),%eax
c0108b29:	0f b6 c8             	movzbl %al,%ecx
c0108b2c:	89 d0                	mov    %edx,%eax
c0108b2e:	29 c8                	sub    %ecx,%eax
c0108b30:	eb 05                	jmp    c0108b37 <strncmp+0x51>
c0108b32:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108b37:	5d                   	pop    %ebp
c0108b38:	c3                   	ret    

c0108b39 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0108b39:	55                   	push   %ebp
c0108b3a:	89 e5                	mov    %esp,%ebp
c0108b3c:	83 ec 04             	sub    $0x4,%esp
c0108b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b42:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0108b45:	eb 13                	jmp    c0108b5a <strchr+0x21>
        if (*s == c) {
c0108b47:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b4a:	0f b6 00             	movzbl (%eax),%eax
c0108b4d:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0108b50:	75 05                	jne    c0108b57 <strchr+0x1e>
            return (char *)s;
c0108b52:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b55:	eb 12                	jmp    c0108b69 <strchr+0x30>
        }
        s ++;
c0108b57:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0108b5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b5d:	0f b6 00             	movzbl (%eax),%eax
c0108b60:	84 c0                	test   %al,%al
c0108b62:	75 e3                	jne    c0108b47 <strchr+0xe>
    }
    return NULL;
c0108b64:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108b69:	89 ec                	mov    %ebp,%esp
c0108b6b:	5d                   	pop    %ebp
c0108b6c:	c3                   	ret    

c0108b6d <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0108b6d:	55                   	push   %ebp
c0108b6e:	89 e5                	mov    %esp,%ebp
c0108b70:	83 ec 04             	sub    $0x4,%esp
c0108b73:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b76:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0108b79:	eb 0e                	jmp    c0108b89 <strfind+0x1c>
        if (*s == c) {
c0108b7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b7e:	0f b6 00             	movzbl (%eax),%eax
c0108b81:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0108b84:	74 0f                	je     c0108b95 <strfind+0x28>
            break;
        }
        s ++;
c0108b86:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0108b89:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b8c:	0f b6 00             	movzbl (%eax),%eax
c0108b8f:	84 c0                	test   %al,%al
c0108b91:	75 e8                	jne    c0108b7b <strfind+0xe>
c0108b93:	eb 01                	jmp    c0108b96 <strfind+0x29>
            break;
c0108b95:	90                   	nop
    }
    return (char *)s;
c0108b96:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0108b99:	89 ec                	mov    %ebp,%esp
c0108b9b:	5d                   	pop    %ebp
c0108b9c:	c3                   	ret    

c0108b9d <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0108b9d:	55                   	push   %ebp
c0108b9e:	89 e5                	mov    %esp,%ebp
c0108ba0:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0108ba3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0108baa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0108bb1:	eb 03                	jmp    c0108bb6 <strtol+0x19>
        s ++;
c0108bb3:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0108bb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bb9:	0f b6 00             	movzbl (%eax),%eax
c0108bbc:	3c 20                	cmp    $0x20,%al
c0108bbe:	74 f3                	je     c0108bb3 <strtol+0x16>
c0108bc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bc3:	0f b6 00             	movzbl (%eax),%eax
c0108bc6:	3c 09                	cmp    $0x9,%al
c0108bc8:	74 e9                	je     c0108bb3 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0108bca:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bcd:	0f b6 00             	movzbl (%eax),%eax
c0108bd0:	3c 2b                	cmp    $0x2b,%al
c0108bd2:	75 05                	jne    c0108bd9 <strtol+0x3c>
        s ++;
c0108bd4:	ff 45 08             	incl   0x8(%ebp)
c0108bd7:	eb 14                	jmp    c0108bed <strtol+0x50>
    }
    else if (*s == '-') {
c0108bd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bdc:	0f b6 00             	movzbl (%eax),%eax
c0108bdf:	3c 2d                	cmp    $0x2d,%al
c0108be1:	75 0a                	jne    c0108bed <strtol+0x50>
        s ++, neg = 1;
c0108be3:	ff 45 08             	incl   0x8(%ebp)
c0108be6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0108bed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108bf1:	74 06                	je     c0108bf9 <strtol+0x5c>
c0108bf3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0108bf7:	75 22                	jne    c0108c1b <strtol+0x7e>
c0108bf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bfc:	0f b6 00             	movzbl (%eax),%eax
c0108bff:	3c 30                	cmp    $0x30,%al
c0108c01:	75 18                	jne    c0108c1b <strtol+0x7e>
c0108c03:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c06:	40                   	inc    %eax
c0108c07:	0f b6 00             	movzbl (%eax),%eax
c0108c0a:	3c 78                	cmp    $0x78,%al
c0108c0c:	75 0d                	jne    c0108c1b <strtol+0x7e>
        s += 2, base = 16;
c0108c0e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0108c12:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0108c19:	eb 29                	jmp    c0108c44 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c0108c1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108c1f:	75 16                	jne    c0108c37 <strtol+0x9a>
c0108c21:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c24:	0f b6 00             	movzbl (%eax),%eax
c0108c27:	3c 30                	cmp    $0x30,%al
c0108c29:	75 0c                	jne    c0108c37 <strtol+0x9a>
        s ++, base = 8;
c0108c2b:	ff 45 08             	incl   0x8(%ebp)
c0108c2e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0108c35:	eb 0d                	jmp    c0108c44 <strtol+0xa7>
    }
    else if (base == 0) {
c0108c37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108c3b:	75 07                	jne    c0108c44 <strtol+0xa7>
        base = 10;
c0108c3d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0108c44:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c47:	0f b6 00             	movzbl (%eax),%eax
c0108c4a:	3c 2f                	cmp    $0x2f,%al
c0108c4c:	7e 1b                	jle    c0108c69 <strtol+0xcc>
c0108c4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c51:	0f b6 00             	movzbl (%eax),%eax
c0108c54:	3c 39                	cmp    $0x39,%al
c0108c56:	7f 11                	jg     c0108c69 <strtol+0xcc>
            dig = *s - '0';
c0108c58:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c5b:	0f b6 00             	movzbl (%eax),%eax
c0108c5e:	0f be c0             	movsbl %al,%eax
c0108c61:	83 e8 30             	sub    $0x30,%eax
c0108c64:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108c67:	eb 48                	jmp    c0108cb1 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0108c69:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c6c:	0f b6 00             	movzbl (%eax),%eax
c0108c6f:	3c 60                	cmp    $0x60,%al
c0108c71:	7e 1b                	jle    c0108c8e <strtol+0xf1>
c0108c73:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c76:	0f b6 00             	movzbl (%eax),%eax
c0108c79:	3c 7a                	cmp    $0x7a,%al
c0108c7b:	7f 11                	jg     c0108c8e <strtol+0xf1>
            dig = *s - 'a' + 10;
c0108c7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c80:	0f b6 00             	movzbl (%eax),%eax
c0108c83:	0f be c0             	movsbl %al,%eax
c0108c86:	83 e8 57             	sub    $0x57,%eax
c0108c89:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108c8c:	eb 23                	jmp    c0108cb1 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0108c8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c91:	0f b6 00             	movzbl (%eax),%eax
c0108c94:	3c 40                	cmp    $0x40,%al
c0108c96:	7e 3b                	jle    c0108cd3 <strtol+0x136>
c0108c98:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c9b:	0f b6 00             	movzbl (%eax),%eax
c0108c9e:	3c 5a                	cmp    $0x5a,%al
c0108ca0:	7f 31                	jg     c0108cd3 <strtol+0x136>
            dig = *s - 'A' + 10;
c0108ca2:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ca5:	0f b6 00             	movzbl (%eax),%eax
c0108ca8:	0f be c0             	movsbl %al,%eax
c0108cab:	83 e8 37             	sub    $0x37,%eax
c0108cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0108cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108cb4:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108cb7:	7d 19                	jge    c0108cd2 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c0108cb9:	ff 45 08             	incl   0x8(%ebp)
c0108cbc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108cbf:	0f af 45 10          	imul   0x10(%ebp),%eax
c0108cc3:	89 c2                	mov    %eax,%edx
c0108cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108cc8:	01 d0                	add    %edx,%eax
c0108cca:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0108ccd:	e9 72 ff ff ff       	jmp    c0108c44 <strtol+0xa7>
            break;
c0108cd2:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0108cd3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108cd7:	74 08                	je     c0108ce1 <strtol+0x144>
        *endptr = (char *) s;
c0108cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108cdc:	8b 55 08             	mov    0x8(%ebp),%edx
c0108cdf:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0108ce1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108ce5:	74 07                	je     c0108cee <strtol+0x151>
c0108ce7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108cea:	f7 d8                	neg    %eax
c0108cec:	eb 03                	jmp    c0108cf1 <strtol+0x154>
c0108cee:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0108cf1:	89 ec                	mov    %ebp,%esp
c0108cf3:	5d                   	pop    %ebp
c0108cf4:	c3                   	ret    

c0108cf5 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0108cf5:	55                   	push   %ebp
c0108cf6:	89 e5                	mov    %esp,%ebp
c0108cf8:	83 ec 28             	sub    $0x28,%esp
c0108cfb:	89 7d fc             	mov    %edi,-0x4(%ebp)
c0108cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108d01:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0108d04:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0108d08:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d0b:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0108d0e:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0108d11:	8b 45 10             	mov    0x10(%ebp),%eax
c0108d14:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0108d17:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0108d1a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0108d1e:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0108d21:	89 d7                	mov    %edx,%edi
c0108d23:	f3 aa                	rep stos %al,%es:(%edi)
c0108d25:	89 fa                	mov    %edi,%edx
c0108d27:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108d2a:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0108d2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0108d30:	8b 7d fc             	mov    -0x4(%ebp),%edi
c0108d33:	89 ec                	mov    %ebp,%esp
c0108d35:	5d                   	pop    %ebp
c0108d36:	c3                   	ret    

c0108d37 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0108d37:	55                   	push   %ebp
c0108d38:	89 e5                	mov    %esp,%ebp
c0108d3a:	57                   	push   %edi
c0108d3b:	56                   	push   %esi
c0108d3c:	53                   	push   %ebx
c0108d3d:	83 ec 30             	sub    $0x30,%esp
c0108d40:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108d46:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108d49:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108d4c:	8b 45 10             	mov    0x10(%ebp),%eax
c0108d4f:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0108d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d55:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108d58:	73 42                	jae    c0108d9c <memmove+0x65>
c0108d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108d60:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d63:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108d66:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d69:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108d6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108d6f:	c1 e8 02             	shr    $0x2,%eax
c0108d72:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0108d74:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108d77:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108d7a:	89 d7                	mov    %edx,%edi
c0108d7c:	89 c6                	mov    %eax,%esi
c0108d7e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108d80:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108d83:	83 e1 03             	and    $0x3,%ecx
c0108d86:	74 02                	je     c0108d8a <memmove+0x53>
c0108d88:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108d8a:	89 f0                	mov    %esi,%eax
c0108d8c:	89 fa                	mov    %edi,%edx
c0108d8e:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0108d91:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108d94:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0108d97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0108d9a:	eb 36                	jmp    c0108dd2 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0108d9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d9f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108da2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108da5:	01 c2                	add    %eax,%edx
c0108da7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108daa:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0108dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108db0:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0108db3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108db6:	89 c1                	mov    %eax,%ecx
c0108db8:	89 d8                	mov    %ebx,%eax
c0108dba:	89 d6                	mov    %edx,%esi
c0108dbc:	89 c7                	mov    %eax,%edi
c0108dbe:	fd                   	std    
c0108dbf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108dc1:	fc                   	cld    
c0108dc2:	89 f8                	mov    %edi,%eax
c0108dc4:	89 f2                	mov    %esi,%edx
c0108dc6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0108dc9:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0108dcc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0108dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0108dd2:	83 c4 30             	add    $0x30,%esp
c0108dd5:	5b                   	pop    %ebx
c0108dd6:	5e                   	pop    %esi
c0108dd7:	5f                   	pop    %edi
c0108dd8:	5d                   	pop    %ebp
c0108dd9:	c3                   	ret    

c0108dda <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0108dda:	55                   	push   %ebp
c0108ddb:	89 e5                	mov    %esp,%ebp
c0108ddd:	57                   	push   %edi
c0108dde:	56                   	push   %esi
c0108ddf:	83 ec 20             	sub    $0x20,%esp
c0108de2:	8b 45 08             	mov    0x8(%ebp),%eax
c0108de5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108de8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108deb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108dee:	8b 45 10             	mov    0x10(%ebp),%eax
c0108df1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108df4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108df7:	c1 e8 02             	shr    $0x2,%eax
c0108dfa:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0108dfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108e02:	89 d7                	mov    %edx,%edi
c0108e04:	89 c6                	mov    %eax,%esi
c0108e06:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108e08:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0108e0b:	83 e1 03             	and    $0x3,%ecx
c0108e0e:	74 02                	je     c0108e12 <memcpy+0x38>
c0108e10:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108e12:	89 f0                	mov    %esi,%eax
c0108e14:	89 fa                	mov    %edi,%edx
c0108e16:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108e19:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108e1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0108e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0108e22:	83 c4 20             	add    $0x20,%esp
c0108e25:	5e                   	pop    %esi
c0108e26:	5f                   	pop    %edi
c0108e27:	5d                   	pop    %ebp
c0108e28:	c3                   	ret    

c0108e29 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0108e29:	55                   	push   %ebp
c0108e2a:	89 e5                	mov    %esp,%ebp
c0108e2c:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0108e2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e32:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0108e35:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108e38:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0108e3b:	eb 2e                	jmp    c0108e6b <memcmp+0x42>
        if (*s1 != *s2) {
c0108e3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108e40:	0f b6 10             	movzbl (%eax),%edx
c0108e43:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108e46:	0f b6 00             	movzbl (%eax),%eax
c0108e49:	38 c2                	cmp    %al,%dl
c0108e4b:	74 18                	je     c0108e65 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108e50:	0f b6 00             	movzbl (%eax),%eax
c0108e53:	0f b6 d0             	movzbl %al,%edx
c0108e56:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108e59:	0f b6 00             	movzbl (%eax),%eax
c0108e5c:	0f b6 c8             	movzbl %al,%ecx
c0108e5f:	89 d0                	mov    %edx,%eax
c0108e61:	29 c8                	sub    %ecx,%eax
c0108e63:	eb 18                	jmp    c0108e7d <memcmp+0x54>
        }
        s1 ++, s2 ++;
c0108e65:	ff 45 fc             	incl   -0x4(%ebp)
c0108e68:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c0108e6b:	8b 45 10             	mov    0x10(%ebp),%eax
c0108e6e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108e71:	89 55 10             	mov    %edx,0x10(%ebp)
c0108e74:	85 c0                	test   %eax,%eax
c0108e76:	75 c5                	jne    c0108e3d <memcmp+0x14>
    }
    return 0;
c0108e78:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108e7d:	89 ec                	mov    %ebp,%esp
c0108e7f:	5d                   	pop    %ebp
c0108e80:	c3                   	ret    
