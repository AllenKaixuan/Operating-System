
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 c0 11 00       	mov    $0x11c000,%eax
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
c0100020:	a3 00 c0 11 c0       	mov    %eax,0xc011c000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 b0 11 c0       	mov    $0xc011b000,%esp
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
c010003c:	b8 2c ef 11 c0       	mov    $0xc011ef2c,%eax
c0100041:	2d 00 e0 11 c0       	sub    $0xc011e000,%eax
c0100046:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100051:	00 
c0100052:	c7 04 24 00 e0 11 c0 	movl   $0xc011e000,(%esp)
c0100059:	e8 8f 6b 00 00       	call   c0106bed <memset>

    cons_init();                // init the console
c010005e:	e8 fc 15 00 00       	call   c010165f <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100063:	c7 45 f4 80 6d 10 c0 	movl   $0xc0106d80,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010006d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100071:	c7 04 24 9c 6d 10 c0 	movl   $0xc0106d9c,(%esp)
c0100078:	e8 e4 02 00 00       	call   c0100361 <cprintf>

    print_kerninfo();
c010007d:	e8 02 08 00 00       	call   c0100884 <print_kerninfo>

    grade_backtrace();
c0100082:	e8 90 00 00 00       	call   c0100117 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100087:	e8 b3 50 00 00       	call   c010513f <pmm_init>

    pic_init();                 // init interrupt controller
c010008c:	e8 4f 17 00 00       	call   c01017e0 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100091:	e8 d6 18 00 00       	call   c010196c <idt_init>

    clock_init();               // init clock interrupt
c0100096:	e8 23 0d 00 00       	call   c0100dbe <clock_init>
    intr_enable();              // enable irq interrupt
c010009b:	e8 9e 16 00 00       	call   c010173e <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a0:	eb fe                	jmp    c01000a0 <kern_init+0x6a>

c01000a2 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a2:	55                   	push   %ebp
c01000a3:	89 e5                	mov    %esp,%ebp
c01000a5:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000af:	00 
c01000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000b7:	00 
c01000b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000bf:	e8 15 0c 00 00       	call   c0100cd9 <mon_backtrace>
}
c01000c4:	90                   	nop
c01000c5:	89 ec                	mov    %ebp,%esp
c01000c7:	5d                   	pop    %ebp
c01000c8:	c3                   	ret    

c01000c9 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000c9:	55                   	push   %ebp
c01000ca:	89 e5                	mov    %esp,%ebp
c01000cc:	83 ec 18             	sub    $0x18,%esp
c01000cf:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d2:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000d5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000d8:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000db:	8b 45 08             	mov    0x8(%ebp),%eax
c01000de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000e2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000ea:	89 04 24             	mov    %eax,(%esp)
c01000ed:	e8 b0 ff ff ff       	call   c01000a2 <grade_backtrace2>
}
c01000f2:	90                   	nop
c01000f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000f6:	89 ec                	mov    %ebp,%esp
c01000f8:	5d                   	pop    %ebp
c01000f9:	c3                   	ret    

c01000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000fa:	55                   	push   %ebp
c01000fb:	89 e5                	mov    %esp,%ebp
c01000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100100:	8b 45 10             	mov    0x10(%ebp),%eax
c0100103:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100107:	8b 45 08             	mov    0x8(%ebp),%eax
c010010a:	89 04 24             	mov    %eax,(%esp)
c010010d:	e8 b7 ff ff ff       	call   c01000c9 <grade_backtrace1>
}
c0100112:	90                   	nop
c0100113:	89 ec                	mov    %ebp,%esp
c0100115:	5d                   	pop    %ebp
c0100116:	c3                   	ret    

c0100117 <grade_backtrace>:

void
grade_backtrace(void) {
c0100117:	55                   	push   %ebp
c0100118:	89 e5                	mov    %esp,%ebp
c010011a:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010011d:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100122:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100129:	ff 
c010012a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010012e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100135:	e8 c0 ff ff ff       	call   c01000fa <grade_backtrace0>
}
c010013a:	90                   	nop
c010013b:	89 ec                	mov    %ebp,%esp
c010013d:	5d                   	pop    %ebp
c010013e:	c3                   	ret    

c010013f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010013f:	55                   	push   %ebp
c0100140:	89 e5                	mov    %esp,%ebp
c0100142:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100145:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100148:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010014b:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010014e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100155:	83 e0 03             	and    $0x3,%eax
c0100158:	89 c2                	mov    %eax,%edx
c010015a:	a1 00 e0 11 c0       	mov    0xc011e000,%eax
c010015f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100163:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100167:	c7 04 24 a1 6d 10 c0 	movl   $0xc0106da1,(%esp)
c010016e:	e8 ee 01 00 00       	call   c0100361 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100177:	89 c2                	mov    %eax,%edx
c0100179:	a1 00 e0 11 c0       	mov    0xc011e000,%eax
c010017e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100182:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100186:	c7 04 24 af 6d 10 c0 	movl   $0xc0106daf,(%esp)
c010018d:	e8 cf 01 00 00       	call   c0100361 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100196:	89 c2                	mov    %eax,%edx
c0100198:	a1 00 e0 11 c0       	mov    0xc011e000,%eax
c010019d:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a5:	c7 04 24 bd 6d 10 c0 	movl   $0xc0106dbd,(%esp)
c01001ac:	e8 b0 01 00 00       	call   c0100361 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b5:	89 c2                	mov    %eax,%edx
c01001b7:	a1 00 e0 11 c0       	mov    0xc011e000,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 cb 6d 10 c0 	movl   $0xc0106dcb,(%esp)
c01001cb:	e8 91 01 00 00       	call   c0100361 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	89 c2                	mov    %eax,%edx
c01001d6:	a1 00 e0 11 c0       	mov    0xc011e000,%eax
c01001db:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e3:	c7 04 24 d9 6d 10 c0 	movl   $0xc0106dd9,(%esp)
c01001ea:	e8 72 01 00 00       	call   c0100361 <cprintf>
    round ++;
c01001ef:	a1 00 e0 11 c0       	mov    0xc011e000,%eax
c01001f4:	40                   	inc    %eax
c01001f5:	a3 00 e0 11 c0       	mov    %eax,0xc011e000
}
c01001fa:	90                   	nop
c01001fb:	89 ec                	mov    %ebp,%esp
c01001fd:	5d                   	pop    %ebp
c01001fe:	c3                   	ret    

c01001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001ff:	55                   	push   %ebp
c0100200:	89 e5                	mov    %esp,%ebp
    //执行“int n”时, CPU从中断向量表中, 找到第n号表项, 修改CS和IP
    //1. 取中断类型码n ;
    //2. 标志寄存器入栈(pushf) , IF=0, TF=0(重置中断标志位)  ;
    //3. CS、IP入栈 ;
    //4. 查中断向量表,  (IP)=(n*4), (CS)=(n*4+2)。
    asm volatile (
c0100202:	83 ec 08             	sub    $0x8,%esp
c0100205:	cd 78                	int    $0x78
c0100207:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
c0100209:	90                   	nop
c010020a:	5d                   	pop    %ebp
c010020b:	c3                   	ret    

c010020c <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c010020c:	55                   	push   %ebp
c010020d:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
c010020f:	cd 79                	int    $0x79
c0100211:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
c0100213:	90                   	nop
c0100214:	5d                   	pop    %ebp
c0100215:	c3                   	ret    

c0100216 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100216:	55                   	push   %ebp
c0100217:	89 e5                	mov    %esp,%ebp
c0100219:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010021c:	e8 1e ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100221:	c7 04 24 e8 6d 10 c0 	movl   $0xc0106de8,(%esp)
c0100228:	e8 34 01 00 00       	call   c0100361 <cprintf>
    lab1_switch_to_user();
c010022d:	e8 cd ff ff ff       	call   c01001ff <lab1_switch_to_user>
    lab1_print_cur_status();
c0100232:	e8 08 ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100237:	c7 04 24 08 6e 10 c0 	movl   $0xc0106e08,(%esp)
c010023e:	e8 1e 01 00 00       	call   c0100361 <cprintf>
    lab1_switch_to_kernel();
c0100243:	e8 c4 ff ff ff       	call   c010020c <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100248:	e8 f2 fe ff ff       	call   c010013f <lab1_print_cur_status>
}
c010024d:	90                   	nop
c010024e:	89 ec                	mov    %ebp,%esp
c0100250:	5d                   	pop    %ebp
c0100251:	c3                   	ret    

c0100252 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100252:	55                   	push   %ebp
c0100253:	89 e5                	mov    %esp,%ebp
c0100255:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100258:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010025c:	74 13                	je     c0100271 <readline+0x1f>
        cprintf("%s", prompt);
c010025e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100261:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100265:	c7 04 24 27 6e 10 c0 	movl   $0xc0106e27,(%esp)
c010026c:	e8 f0 00 00 00       	call   c0100361 <cprintf>
    }
    int i = 0, c;
c0100271:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100278:	e8 73 01 00 00       	call   c01003f0 <getchar>
c010027d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100284:	79 07                	jns    c010028d <readline+0x3b>
            return NULL;
c0100286:	b8 00 00 00 00       	mov    $0x0,%eax
c010028b:	eb 78                	jmp    c0100305 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010028d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100291:	7e 28                	jle    c01002bb <readline+0x69>
c0100293:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010029a:	7f 1f                	jg     c01002bb <readline+0x69>
            cputchar(c);
c010029c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010029f:	89 04 24             	mov    %eax,(%esp)
c01002a2:	e8 e2 00 00 00       	call   c0100389 <cputchar>
            buf[i ++] = c;
c01002a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002aa:	8d 50 01             	lea    0x1(%eax),%edx
c01002ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002b3:	88 90 20 e0 11 c0    	mov    %dl,-0x3fee1fe0(%eax)
c01002b9:	eb 45                	jmp    c0100300 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
c01002bb:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002bf:	75 16                	jne    c01002d7 <readline+0x85>
c01002c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002c5:	7e 10                	jle    c01002d7 <readline+0x85>
            cputchar(c);
c01002c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ca:	89 04 24             	mov    %eax,(%esp)
c01002cd:	e8 b7 00 00 00       	call   c0100389 <cputchar>
            i --;
c01002d2:	ff 4d f4             	decl   -0xc(%ebp)
c01002d5:	eb 29                	jmp    c0100300 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
c01002d7:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002db:	74 06                	je     c01002e3 <readline+0x91>
c01002dd:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002e1:	75 95                	jne    c0100278 <readline+0x26>
            cputchar(c);
c01002e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002e6:	89 04 24             	mov    %eax,(%esp)
c01002e9:	e8 9b 00 00 00       	call   c0100389 <cputchar>
            buf[i] = '\0';
c01002ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002f1:	05 20 e0 11 c0       	add    $0xc011e020,%eax
c01002f6:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002f9:	b8 20 e0 11 c0       	mov    $0xc011e020,%eax
c01002fe:	eb 05                	jmp    c0100305 <readline+0xb3>
        c = getchar();
c0100300:	e9 73 ff ff ff       	jmp    c0100278 <readline+0x26>
        }
    }
}
c0100305:	89 ec                	mov    %ebp,%esp
c0100307:	5d                   	pop    %ebp
c0100308:	c3                   	ret    

c0100309 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010030f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100312:	89 04 24             	mov    %eax,(%esp)
c0100315:	e8 74 13 00 00       	call   c010168e <cons_putc>
    (*cnt) ++;
c010031a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010031d:	8b 00                	mov    (%eax),%eax
c010031f:	8d 50 01             	lea    0x1(%eax),%edx
c0100322:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100325:	89 10                	mov    %edx,(%eax)
}
c0100327:	90                   	nop
c0100328:	89 ec                	mov    %ebp,%esp
c010032a:	5d                   	pop    %ebp
c010032b:	c3                   	ret    

c010032c <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010032c:	55                   	push   %ebp
c010032d:	89 e5                	mov    %esp,%ebp
c010032f:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100332:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100339:	8b 45 0c             	mov    0xc(%ebp),%eax
c010033c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100340:	8b 45 08             	mov    0x8(%ebp),%eax
c0100343:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100347:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010034a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034e:	c7 04 24 09 03 10 c0 	movl   $0xc0100309,(%esp)
c0100355:	e8 be 60 00 00       	call   c0106418 <vprintfmt>
    return cnt;
c010035a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010035d:	89 ec                	mov    %ebp,%esp
c010035f:	5d                   	pop    %ebp
c0100360:	c3                   	ret    

c0100361 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100361:	55                   	push   %ebp
c0100362:	89 e5                	mov    %esp,%ebp
c0100364:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100367:	8d 45 0c             	lea    0xc(%ebp),%eax
c010036a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010036d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100370:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100374:	8b 45 08             	mov    0x8(%ebp),%eax
c0100377:	89 04 24             	mov    %eax,(%esp)
c010037a:	e8 ad ff ff ff       	call   c010032c <vcprintf>
c010037f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100382:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100385:	89 ec                	mov    %ebp,%esp
c0100387:	5d                   	pop    %ebp
c0100388:	c3                   	ret    

c0100389 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100389:	55                   	push   %ebp
c010038a:	89 e5                	mov    %esp,%ebp
c010038c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010038f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100392:	89 04 24             	mov    %eax,(%esp)
c0100395:	e8 f4 12 00 00       	call   c010168e <cons_putc>
}
c010039a:	90                   	nop
c010039b:	89 ec                	mov    %ebp,%esp
c010039d:	5d                   	pop    %ebp
c010039e:	c3                   	ret    

c010039f <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c010039f:	55                   	push   %ebp
c01003a0:	89 e5                	mov    %esp,%ebp
c01003a2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01003a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01003ac:	eb 13                	jmp    c01003c1 <cputs+0x22>
        cputch(c, &cnt);
c01003ae:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01003b2:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003b5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01003b9:	89 04 24             	mov    %eax,(%esp)
c01003bc:	e8 48 ff ff ff       	call   c0100309 <cputch>
    while ((c = *str ++) != '\0') {
c01003c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01003c4:	8d 50 01             	lea    0x1(%eax),%edx
c01003c7:	89 55 08             	mov    %edx,0x8(%ebp)
c01003ca:	0f b6 00             	movzbl (%eax),%eax
c01003cd:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003d0:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003d4:	75 d8                	jne    c01003ae <cputs+0xf>
    }
    cputch('\n', &cnt);
c01003d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003dd:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003e4:	e8 20 ff ff ff       	call   c0100309 <cputch>
    return cnt;
c01003e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003ec:	89 ec                	mov    %ebp,%esp
c01003ee:	5d                   	pop    %ebp
c01003ef:	c3                   	ret    

c01003f0 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003f0:	55                   	push   %ebp
c01003f1:	89 e5                	mov    %esp,%ebp
c01003f3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003f6:	90                   	nop
c01003f7:	e8 d1 12 00 00       	call   c01016cd <cons_getc>
c01003fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100403:	74 f2                	je     c01003f7 <getchar+0x7>
        /* do nothing */;
    return c;
c0100405:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100408:	89 ec                	mov    %ebp,%esp
c010040a:	5d                   	pop    %ebp
c010040b:	c3                   	ret    

c010040c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c010040c:	55                   	push   %ebp
c010040d:	89 e5                	mov    %esp,%ebp
c010040f:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100412:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100415:	8b 00                	mov    (%eax),%eax
c0100417:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010041a:	8b 45 10             	mov    0x10(%ebp),%eax
c010041d:	8b 00                	mov    (%eax),%eax
c010041f:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100422:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100429:	e9 ca 00 00 00       	jmp    c01004f8 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
c010042e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100431:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100434:	01 d0                	add    %edx,%eax
c0100436:	89 c2                	mov    %eax,%edx
c0100438:	c1 ea 1f             	shr    $0x1f,%edx
c010043b:	01 d0                	add    %edx,%eax
c010043d:	d1 f8                	sar    %eax
c010043f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100442:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100445:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100448:	eb 03                	jmp    c010044d <stab_binsearch+0x41>
            m --;
c010044a:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c010044d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100450:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100453:	7c 1f                	jl     c0100474 <stab_binsearch+0x68>
c0100455:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100458:	89 d0                	mov    %edx,%eax
c010045a:	01 c0                	add    %eax,%eax
c010045c:	01 d0                	add    %edx,%eax
c010045e:	c1 e0 02             	shl    $0x2,%eax
c0100461:	89 c2                	mov    %eax,%edx
c0100463:	8b 45 08             	mov    0x8(%ebp),%eax
c0100466:	01 d0                	add    %edx,%eax
c0100468:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010046c:	0f b6 c0             	movzbl %al,%eax
c010046f:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100472:	75 d6                	jne    c010044a <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c0100474:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100477:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010047a:	7d 09                	jge    c0100485 <stab_binsearch+0x79>
            l = true_m + 1;
c010047c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010047f:	40                   	inc    %eax
c0100480:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100483:	eb 73                	jmp    c01004f8 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
c0100485:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010048c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010048f:	89 d0                	mov    %edx,%eax
c0100491:	01 c0                	add    %eax,%eax
c0100493:	01 d0                	add    %edx,%eax
c0100495:	c1 e0 02             	shl    $0x2,%eax
c0100498:	89 c2                	mov    %eax,%edx
c010049a:	8b 45 08             	mov    0x8(%ebp),%eax
c010049d:	01 d0                	add    %edx,%eax
c010049f:	8b 40 08             	mov    0x8(%eax),%eax
c01004a2:	39 45 18             	cmp    %eax,0x18(%ebp)
c01004a5:	76 11                	jbe    c01004b8 <stab_binsearch+0xac>
            *region_left = m;
c01004a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004ad:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c01004af:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004b2:	40                   	inc    %eax
c01004b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004b6:	eb 40                	jmp    c01004f8 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
c01004b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004bb:	89 d0                	mov    %edx,%eax
c01004bd:	01 c0                	add    %eax,%eax
c01004bf:	01 d0                	add    %edx,%eax
c01004c1:	c1 e0 02             	shl    $0x2,%eax
c01004c4:	89 c2                	mov    %eax,%edx
c01004c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01004c9:	01 d0                	add    %edx,%eax
c01004cb:	8b 40 08             	mov    0x8(%eax),%eax
c01004ce:	39 45 18             	cmp    %eax,0x18(%ebp)
c01004d1:	73 14                	jae    c01004e7 <stab_binsearch+0xdb>
            *region_right = m - 1;
c01004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d6:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004d9:	8b 45 10             	mov    0x10(%ebp),%eax
c01004dc:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e1:	48                   	dec    %eax
c01004e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004e5:	eb 11                	jmp    c01004f8 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004e7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004ed:	89 10                	mov    %edx,(%eax)
            l = m;
c01004ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004f5:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01004f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004fe:	0f 8e 2a ff ff ff    	jle    c010042e <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c0100504:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100508:	75 0f                	jne    c0100519 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
c010050a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010050d:	8b 00                	mov    (%eax),%eax
c010050f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100512:	8b 45 10             	mov    0x10(%ebp),%eax
c0100515:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c0100517:	eb 3e                	jmp    c0100557 <stab_binsearch+0x14b>
        l = *region_right;
c0100519:	8b 45 10             	mov    0x10(%ebp),%eax
c010051c:	8b 00                	mov    (%eax),%eax
c010051e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100521:	eb 03                	jmp    c0100526 <stab_binsearch+0x11a>
c0100523:	ff 4d fc             	decl   -0x4(%ebp)
c0100526:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100529:	8b 00                	mov    (%eax),%eax
c010052b:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c010052e:	7e 1f                	jle    c010054f <stab_binsearch+0x143>
c0100530:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100533:	89 d0                	mov    %edx,%eax
c0100535:	01 c0                	add    %eax,%eax
c0100537:	01 d0                	add    %edx,%eax
c0100539:	c1 e0 02             	shl    $0x2,%eax
c010053c:	89 c2                	mov    %eax,%edx
c010053e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100541:	01 d0                	add    %edx,%eax
c0100543:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100547:	0f b6 c0             	movzbl %al,%eax
c010054a:	39 45 14             	cmp    %eax,0x14(%ebp)
c010054d:	75 d4                	jne    c0100523 <stab_binsearch+0x117>
        *region_left = l;
c010054f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100552:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100555:	89 10                	mov    %edx,(%eax)
}
c0100557:	90                   	nop
c0100558:	89 ec                	mov    %ebp,%esp
c010055a:	5d                   	pop    %ebp
c010055b:	c3                   	ret    

c010055c <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010055c:	55                   	push   %ebp
c010055d:	89 e5                	mov    %esp,%ebp
c010055f:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100562:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100565:	c7 00 2c 6e 10 c0    	movl   $0xc0106e2c,(%eax)
    info->eip_line = 0;
c010056b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100575:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100578:	c7 40 08 2c 6e 10 c0 	movl   $0xc0106e2c,0x8(%eax)
    info->eip_fn_namelen = 9;
c010057f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100582:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100589:	8b 45 0c             	mov    0xc(%ebp),%eax
c010058c:	8b 55 08             	mov    0x8(%ebp),%edx
c010058f:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100592:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100595:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010059c:	c7 45 f4 2c 83 10 c0 	movl   $0xc010832c,-0xc(%ebp)
    stab_end = __STAB_END__;
c01005a3:	c7 45 f0 3c 4e 11 c0 	movl   $0xc0114e3c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01005aa:	c7 45 ec 3d 4e 11 c0 	movl   $0xc0114e3d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01005b1:	c7 45 e8 59 86 11 c0 	movl   $0xc0118659,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01005b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005bb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005be:	76 0b                	jbe    c01005cb <debuginfo_eip+0x6f>
c01005c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005c3:	48                   	dec    %eax
c01005c4:	0f b6 00             	movzbl (%eax),%eax
c01005c7:	84 c0                	test   %al,%al
c01005c9:	74 0a                	je     c01005d5 <debuginfo_eip+0x79>
        return -1;
c01005cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005d0:	e9 ab 02 00 00       	jmp    c0100880 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005df:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01005e2:	c1 f8 02             	sar    $0x2,%eax
c01005e5:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005eb:	48                   	dec    %eax
c01005ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01005f2:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005f6:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005fd:	00 
c01005fe:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0100601:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100605:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c0100608:	89 44 24 04          	mov    %eax,0x4(%esp)
c010060c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010060f:	89 04 24             	mov    %eax,(%esp)
c0100612:	e8 f5 fd ff ff       	call   c010040c <stab_binsearch>
    if (lfile == 0)
c0100617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010061a:	85 c0                	test   %eax,%eax
c010061c:	75 0a                	jne    c0100628 <debuginfo_eip+0xcc>
        return -1;
c010061e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100623:	e9 58 02 00 00       	jmp    c0100880 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010062b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010062e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100631:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100634:	8b 45 08             	mov    0x8(%ebp),%eax
c0100637:	89 44 24 10          	mov    %eax,0x10(%esp)
c010063b:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100642:	00 
c0100643:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100646:	89 44 24 08          	mov    %eax,0x8(%esp)
c010064a:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010064d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100651:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100654:	89 04 24             	mov    %eax,(%esp)
c0100657:	e8 b0 fd ff ff       	call   c010040c <stab_binsearch>

    if (lfun <= rfun) {
c010065c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010065f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100662:	39 c2                	cmp    %eax,%edx
c0100664:	7f 78                	jg     c01006de <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100666:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100669:	89 c2                	mov    %eax,%edx
c010066b:	89 d0                	mov    %edx,%eax
c010066d:	01 c0                	add    %eax,%eax
c010066f:	01 d0                	add    %edx,%eax
c0100671:	c1 e0 02             	shl    $0x2,%eax
c0100674:	89 c2                	mov    %eax,%edx
c0100676:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100679:	01 d0                	add    %edx,%eax
c010067b:	8b 10                	mov    (%eax),%edx
c010067d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100680:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100683:	39 c2                	cmp    %eax,%edx
c0100685:	73 22                	jae    c01006a9 <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100687:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068a:	89 c2                	mov    %eax,%edx
c010068c:	89 d0                	mov    %edx,%eax
c010068e:	01 c0                	add    %eax,%eax
c0100690:	01 d0                	add    %edx,%eax
c0100692:	c1 e0 02             	shl    $0x2,%eax
c0100695:	89 c2                	mov    %eax,%edx
c0100697:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069a:	01 d0                	add    %edx,%eax
c010069c:	8b 10                	mov    (%eax),%edx
c010069e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01006a1:	01 c2                	add    %eax,%edx
c01006a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a6:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01006a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006ac:	89 c2                	mov    %eax,%edx
c01006ae:	89 d0                	mov    %edx,%eax
c01006b0:	01 c0                	add    %eax,%eax
c01006b2:	01 d0                	add    %edx,%eax
c01006b4:	c1 e0 02             	shl    $0x2,%eax
c01006b7:	89 c2                	mov    %eax,%edx
c01006b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006bc:	01 d0                	add    %edx,%eax
c01006be:	8b 50 08             	mov    0x8(%eax),%edx
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ca:	8b 40 10             	mov    0x10(%eax),%eax
c01006cd:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006d9:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006dc:	eb 15                	jmp    c01006f3 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e1:	8b 55 08             	mov    0x8(%ebp),%edx
c01006e4:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f6:	8b 40 08             	mov    0x8(%eax),%eax
c01006f9:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c0100700:	00 
c0100701:	89 04 24             	mov    %eax,(%esp)
c0100704:	e8 5c 63 00 00       	call   c0106a65 <strfind>
c0100709:	8b 55 0c             	mov    0xc(%ebp),%edx
c010070c:	8b 4a 08             	mov    0x8(%edx),%ecx
c010070f:	29 c8                	sub    %ecx,%eax
c0100711:	89 c2                	mov    %eax,%edx
c0100713:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100716:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100719:	8b 45 08             	mov    0x8(%ebp),%eax
c010071c:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100720:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100727:	00 
c0100728:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010072b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010072f:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100732:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100736:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100739:	89 04 24             	mov    %eax,(%esp)
c010073c:	e8 cb fc ff ff       	call   c010040c <stab_binsearch>
    if (lline <= rline) {
c0100741:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100744:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100747:	39 c2                	cmp    %eax,%edx
c0100749:	7f 23                	jg     c010076e <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
c010074b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010074e:	89 c2                	mov    %eax,%edx
c0100750:	89 d0                	mov    %edx,%eax
c0100752:	01 c0                	add    %eax,%eax
c0100754:	01 d0                	add    %edx,%eax
c0100756:	c1 e0 02             	shl    $0x2,%eax
c0100759:	89 c2                	mov    %eax,%edx
c010075b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010075e:	01 d0                	add    %edx,%eax
c0100760:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100764:	89 c2                	mov    %eax,%edx
c0100766:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100769:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010076c:	eb 11                	jmp    c010077f <debuginfo_eip+0x223>
        return -1;
c010076e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100773:	e9 08 01 00 00       	jmp    c0100880 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100778:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077b:	48                   	dec    %eax
c010077c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c010077f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100785:	39 c2                	cmp    %eax,%edx
c0100787:	7c 56                	jl     c01007df <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
c0100789:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078c:	89 c2                	mov    %eax,%edx
c010078e:	89 d0                	mov    %edx,%eax
c0100790:	01 c0                	add    %eax,%eax
c0100792:	01 d0                	add    %edx,%eax
c0100794:	c1 e0 02             	shl    $0x2,%eax
c0100797:	89 c2                	mov    %eax,%edx
c0100799:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079c:	01 d0                	add    %edx,%eax
c010079e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a2:	3c 84                	cmp    $0x84,%al
c01007a4:	74 39                	je     c01007df <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01007a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007a9:	89 c2                	mov    %eax,%edx
c01007ab:	89 d0                	mov    %edx,%eax
c01007ad:	01 c0                	add    %eax,%eax
c01007af:	01 d0                	add    %edx,%eax
c01007b1:	c1 e0 02             	shl    $0x2,%eax
c01007b4:	89 c2                	mov    %eax,%edx
c01007b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007b9:	01 d0                	add    %edx,%eax
c01007bb:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007bf:	3c 64                	cmp    $0x64,%al
c01007c1:	75 b5                	jne    c0100778 <debuginfo_eip+0x21c>
c01007c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007c6:	89 c2                	mov    %eax,%edx
c01007c8:	89 d0                	mov    %edx,%eax
c01007ca:	01 c0                	add    %eax,%eax
c01007cc:	01 d0                	add    %edx,%eax
c01007ce:	c1 e0 02             	shl    $0x2,%eax
c01007d1:	89 c2                	mov    %eax,%edx
c01007d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007d6:	01 d0                	add    %edx,%eax
c01007d8:	8b 40 08             	mov    0x8(%eax),%eax
c01007db:	85 c0                	test   %eax,%eax
c01007dd:	74 99                	je     c0100778 <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007e5:	39 c2                	cmp    %eax,%edx
c01007e7:	7c 42                	jl     c010082b <debuginfo_eip+0x2cf>
c01007e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ec:	89 c2                	mov    %eax,%edx
c01007ee:	89 d0                	mov    %edx,%eax
c01007f0:	01 c0                	add    %eax,%eax
c01007f2:	01 d0                	add    %edx,%eax
c01007f4:	c1 e0 02             	shl    $0x2,%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007fc:	01 d0                	add    %edx,%eax
c01007fe:	8b 10                	mov    (%eax),%edx
c0100800:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100803:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100806:	39 c2                	cmp    %eax,%edx
c0100808:	73 21                	jae    c010082b <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
c010080a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010080d:	89 c2                	mov    %eax,%edx
c010080f:	89 d0                	mov    %edx,%eax
c0100811:	01 c0                	add    %eax,%eax
c0100813:	01 d0                	add    %edx,%eax
c0100815:	c1 e0 02             	shl    $0x2,%eax
c0100818:	89 c2                	mov    %eax,%edx
c010081a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010081d:	01 d0                	add    %edx,%eax
c010081f:	8b 10                	mov    (%eax),%edx
c0100821:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100824:	01 c2                	add    %eax,%edx
c0100826:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100829:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c010082b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010082e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100831:	39 c2                	cmp    %eax,%edx
c0100833:	7d 46                	jge    c010087b <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
c0100835:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100838:	40                   	inc    %eax
c0100839:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010083c:	eb 16                	jmp    c0100854 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010083e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100841:	8b 40 14             	mov    0x14(%eax),%eax
c0100844:	8d 50 01             	lea    0x1(%eax),%edx
c0100847:	8b 45 0c             	mov    0xc(%ebp),%eax
c010084a:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c010084d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100850:	40                   	inc    %eax
c0100851:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100854:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100857:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010085a:	39 c2                	cmp    %eax,%edx
c010085c:	7d 1d                	jge    c010087b <debuginfo_eip+0x31f>
c010085e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100861:	89 c2                	mov    %eax,%edx
c0100863:	89 d0                	mov    %edx,%eax
c0100865:	01 c0                	add    %eax,%eax
c0100867:	01 d0                	add    %edx,%eax
c0100869:	c1 e0 02             	shl    $0x2,%eax
c010086c:	89 c2                	mov    %eax,%edx
c010086e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100871:	01 d0                	add    %edx,%eax
c0100873:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100877:	3c a0                	cmp    $0xa0,%al
c0100879:	74 c3                	je     c010083e <debuginfo_eip+0x2e2>
        }
    }
    return 0;
c010087b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100880:	89 ec                	mov    %ebp,%esp
c0100882:	5d                   	pop    %ebp
c0100883:	c3                   	ret    

c0100884 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100884:	55                   	push   %ebp
c0100885:	89 e5                	mov    %esp,%ebp
c0100887:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010088a:	c7 04 24 36 6e 10 c0 	movl   $0xc0106e36,(%esp)
c0100891:	e8 cb fa ff ff       	call   c0100361 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100896:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 4f 6e 10 c0 	movl   $0xc0106e4f,(%esp)
c01008a5:	e8 b7 fa ff ff       	call   c0100361 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008aa:	c7 44 24 04 79 6d 10 	movl   $0xc0106d79,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 67 6e 10 c0 	movl   $0xc0106e67,(%esp)
c01008b9:	e8 a3 fa ff ff       	call   c0100361 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008be:	c7 44 24 04 00 e0 11 	movl   $0xc011e000,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 7f 6e 10 c0 	movl   $0xc0106e7f,(%esp)
c01008cd:	e8 8f fa ff ff       	call   c0100361 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008d2:	c7 44 24 04 2c ef 11 	movl   $0xc011ef2c,0x4(%esp)
c01008d9:	c0 
c01008da:	c7 04 24 97 6e 10 c0 	movl   $0xc0106e97,(%esp)
c01008e1:	e8 7b fa ff ff       	call   c0100361 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008e6:	b8 2c ef 11 c0       	mov    $0xc011ef2c,%eax
c01008eb:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01008f0:	05 ff 03 00 00       	add    $0x3ff,%eax
c01008f5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008fb:	85 c0                	test   %eax,%eax
c01008fd:	0f 48 c2             	cmovs  %edx,%eax
c0100900:	c1 f8 0a             	sar    $0xa,%eax
c0100903:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100907:	c7 04 24 b0 6e 10 c0 	movl   $0xc0106eb0,(%esp)
c010090e:	e8 4e fa ff ff       	call   c0100361 <cprintf>
}
c0100913:	90                   	nop
c0100914:	89 ec                	mov    %ebp,%esp
c0100916:	5d                   	pop    %ebp
c0100917:	c3                   	ret    

c0100918 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100918:	55                   	push   %ebp
c0100919:	89 e5                	mov    %esp,%ebp
c010091b:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100921:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100924:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100928:	8b 45 08             	mov    0x8(%ebp),%eax
c010092b:	89 04 24             	mov    %eax,(%esp)
c010092e:	e8 29 fc ff ff       	call   c010055c <debuginfo_eip>
c0100933:	85 c0                	test   %eax,%eax
c0100935:	74 15                	je     c010094c <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100937:	8b 45 08             	mov    0x8(%ebp),%eax
c010093a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010093e:	c7 04 24 da 6e 10 c0 	movl   $0xc0106eda,(%esp)
c0100945:	e8 17 fa ff ff       	call   c0100361 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c010094a:	eb 6c                	jmp    c01009b8 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010094c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100953:	eb 1b                	jmp    c0100970 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
c0100955:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100958:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010095b:	01 d0                	add    %edx,%eax
c010095d:	0f b6 10             	movzbl (%eax),%edx
c0100960:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100966:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100969:	01 c8                	add    %ecx,%eax
c010096b:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010096d:	ff 45 f4             	incl   -0xc(%ebp)
c0100970:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100973:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100976:	7c dd                	jl     c0100955 <print_debuginfo+0x3d>
        fnname[j] = '\0';
c0100978:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010097e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100981:	01 d0                	add    %edx,%eax
c0100983:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100986:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100989:	8b 45 08             	mov    0x8(%ebp),%eax
c010098c:	29 d0                	sub    %edx,%eax
c010098e:	89 c1                	mov    %eax,%ecx
c0100990:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100993:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100996:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010099a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009a0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009a4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ac:	c7 04 24 f6 6e 10 c0 	movl   $0xc0106ef6,(%esp)
c01009b3:	e8 a9 f9 ff ff       	call   c0100361 <cprintf>
}
c01009b8:	90                   	nop
c01009b9:	89 ec                	mov    %ebp,%esp
c01009bb:	5d                   	pop    %ebp
c01009bc:	c3                   	ret    

c01009bd <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009bd:	55                   	push   %ebp
c01009be:	89 e5                	mov    %esp,%ebp
c01009c0:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009c3:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009cc:	89 ec                	mov    %ebp,%esp
c01009ce:	5d                   	pop    %ebp
c01009cf:	c3                   	ret    

c01009d0 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009d0:	55                   	push   %ebp
c01009d1:	89 e5                	mov    %esp,%ebp
c01009d3:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009d6:	89 e8                	mov    %ebp,%eax
c01009d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009db:	8b 45 e0             	mov    -0x20(%ebp),%eax
      */
    // ebp是第一个被调用函数的栈帧的base pointer，
    // eip是在该栈帧对应函数中调用下一个栈帧对应函数的指令的下一条指令的地址（return address）
    // args是传递给这第一个被调用的函数的参数
    // get ebp and eip
    uint32_t ebp = read_ebp(), eip = read_eip();
c01009de:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009e1:	e8 d7 ff ff ff       	call   c01009bd <read_eip>
c01009e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // traverse all
    for(int i=0,j=0; ebp!=0 && i<STACKFRAME_DEPTH;i++){
c01009e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c01009f7:	e9 84 00 00 00       	jmp    c0100a80 <print_stackframe+0xb0>
        //print ebp & eip
        cprintf("ebp:0x%08x eip:0x%08x args:",ebp,eip);
c01009fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009ff:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a06:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a0a:	c7 04 24 08 6f 10 c0 	movl   $0xc0106f08,(%esp)
c0100a11:	e8 4b f9 ff ff       	call   c0100361 <cprintf>
        //print args
        // +1 -> 返回地址
        // +2 -> 参数
        uint32_t *args =(uint32_t*)ebp+2;
c0100a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a19:	83 c0 08             	add    $0x8,%eax
c0100a1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for(j=0;j<4;j++){
c0100a1f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a26:	eb 24                	jmp    c0100a4c <print_stackframe+0x7c>
            cprintf("0x%08x ",args[j]);
c0100a28:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a2b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a35:	01 d0                	add    %edx,%eax
c0100a37:	8b 00                	mov    (%eax),%eax
c0100a39:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a3d:	c7 04 24 24 6f 10 c0 	movl   $0xc0106f24,(%esp)
c0100a44:	e8 18 f9 ff ff       	call   c0100361 <cprintf>
        for(j=0;j<4;j++){
c0100a49:	ff 45 e8             	incl   -0x18(%ebp)
c0100a4c:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a50:	7e d6                	jle    c0100a28 <print_stackframe+0x58>
        }
        cprintf("\n");
c0100a52:	c7 04 24 2c 6f 10 c0 	movl   $0xc0106f2c,(%esp)
c0100a59:	e8 03 f9 ff ff       	call   c0100361 <cprintf>
        // print the C calling function name and line number, etc
        print_debuginfo(eip - 1);
c0100a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a61:	48                   	dec    %eax
c0100a62:	89 04 24             	mov    %eax,(%esp)
c0100a65:	e8 ae fe ff ff       	call   c0100918 <print_debuginfo>
        // get next func call
        // popup a calling stackframe
        // the calling funciton's return addr eip  = ss:[ebp+4]
        // the calling funciton's ebp = ss:[ebp]
        eip = ((uint32_t *)ebp)[1];
c0100a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6d:	83 c0 04             	add    $0x4,%eax
c0100a70:	8b 00                	mov    (%eax),%eax
c0100a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a78:	8b 00                	mov    (%eax),%eax
c0100a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(int i=0,j=0; ebp!=0 && i<STACKFRAME_DEPTH;i++){
c0100a7d:	ff 45 ec             	incl   -0x14(%ebp)
c0100a80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a84:	74 0a                	je     c0100a90 <print_stackframe+0xc0>
c0100a86:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a8a:	0f 8e 6c ff ff ff    	jle    c01009fc <print_stackframe+0x2c>
    }
}
c0100a90:	90                   	nop
c0100a91:	89 ec                	mov    %ebp,%esp
c0100a93:	5d                   	pop    %ebp
c0100a94:	c3                   	ret    

c0100a95 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a95:	55                   	push   %ebp
c0100a96:	89 e5                	mov    %esp,%ebp
c0100a98:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aa2:	eb 0c                	jmp    c0100ab0 <parse+0x1b>
            *buf ++ = '\0';
c0100aa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa7:	8d 50 01             	lea    0x1(%eax),%edx
c0100aaa:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aad:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ab0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab3:	0f b6 00             	movzbl (%eax),%eax
c0100ab6:	84 c0                	test   %al,%al
c0100ab8:	74 1d                	je     c0100ad7 <parse+0x42>
c0100aba:	8b 45 08             	mov    0x8(%ebp),%eax
c0100abd:	0f b6 00             	movzbl (%eax),%eax
c0100ac0:	0f be c0             	movsbl %al,%eax
c0100ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ac7:	c7 04 24 b0 6f 10 c0 	movl   $0xc0106fb0,(%esp)
c0100ace:	e8 5e 5f 00 00       	call   c0106a31 <strchr>
c0100ad3:	85 c0                	test   %eax,%eax
c0100ad5:	75 cd                	jne    c0100aa4 <parse+0xf>
        }
        if (*buf == '\0') {
c0100ad7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ada:	0f b6 00             	movzbl (%eax),%eax
c0100add:	84 c0                	test   %al,%al
c0100adf:	74 65                	je     c0100b46 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ae1:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ae5:	75 14                	jne    c0100afb <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ae7:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100aee:	00 
c0100aef:	c7 04 24 b5 6f 10 c0 	movl   $0xc0106fb5,(%esp)
c0100af6:	e8 66 f8 ff ff       	call   c0100361 <cprintf>
        }
        argv[argc ++] = buf;
c0100afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100afe:	8d 50 01             	lea    0x1(%eax),%edx
c0100b01:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b04:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b0e:	01 c2                	add    %eax,%edx
c0100b10:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b13:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b15:	eb 03                	jmp    c0100b1a <parse+0x85>
            buf ++;
c0100b17:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1d:	0f b6 00             	movzbl (%eax),%eax
c0100b20:	84 c0                	test   %al,%al
c0100b22:	74 8c                	je     c0100ab0 <parse+0x1b>
c0100b24:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b27:	0f b6 00             	movzbl (%eax),%eax
c0100b2a:	0f be c0             	movsbl %al,%eax
c0100b2d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b31:	c7 04 24 b0 6f 10 c0 	movl   $0xc0106fb0,(%esp)
c0100b38:	e8 f4 5e 00 00       	call   c0106a31 <strchr>
c0100b3d:	85 c0                	test   %eax,%eax
c0100b3f:	74 d6                	je     c0100b17 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b41:	e9 6a ff ff ff       	jmp    c0100ab0 <parse+0x1b>
            break;
c0100b46:	90                   	nop
        }
    }
    return argc;
c0100b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b4a:	89 ec                	mov    %ebp,%esp
c0100b4c:	5d                   	pop    %ebp
c0100b4d:	c3                   	ret    

c0100b4e <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b4e:	55                   	push   %ebp
c0100b4f:	89 e5                	mov    %esp,%ebp
c0100b51:	83 ec 68             	sub    $0x68,%esp
c0100b54:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b57:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b5a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b61:	89 04 24             	mov    %eax,(%esp)
c0100b64:	e8 2c ff ff ff       	call   c0100a95 <parse>
c0100b69:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b70:	75 0a                	jne    c0100b7c <runcmd+0x2e>
        return 0;
c0100b72:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b77:	e9 83 00 00 00       	jmp    c0100bff <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b83:	eb 5a                	jmp    c0100bdf <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b85:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0100b88:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100b8b:	89 c8                	mov    %ecx,%eax
c0100b8d:	01 c0                	add    %eax,%eax
c0100b8f:	01 c8                	add    %ecx,%eax
c0100b91:	c1 e0 02             	shl    $0x2,%eax
c0100b94:	05 00 b0 11 c0       	add    $0xc011b000,%eax
c0100b99:	8b 00                	mov    (%eax),%eax
c0100b9b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100b9f:	89 04 24             	mov    %eax,(%esp)
c0100ba2:	e8 ee 5d 00 00       	call   c0106995 <strcmp>
c0100ba7:	85 c0                	test   %eax,%eax
c0100ba9:	75 31                	jne    c0100bdc <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100bab:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bae:	89 d0                	mov    %edx,%eax
c0100bb0:	01 c0                	add    %eax,%eax
c0100bb2:	01 d0                	add    %edx,%eax
c0100bb4:	c1 e0 02             	shl    $0x2,%eax
c0100bb7:	05 08 b0 11 c0       	add    $0xc011b008,%eax
c0100bbc:	8b 10                	mov    (%eax),%edx
c0100bbe:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bc1:	83 c0 04             	add    $0x4,%eax
c0100bc4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100bc7:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100bca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100bcd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd5:	89 1c 24             	mov    %ebx,(%esp)
c0100bd8:	ff d2                	call   *%edx
c0100bda:	eb 23                	jmp    c0100bff <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bdc:	ff 45 f4             	incl   -0xc(%ebp)
c0100bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100be2:	83 f8 02             	cmp    $0x2,%eax
c0100be5:	76 9e                	jbe    c0100b85 <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100be7:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bea:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bee:	c7 04 24 d3 6f 10 c0 	movl   $0xc0106fd3,(%esp)
c0100bf5:	e8 67 f7 ff ff       	call   c0100361 <cprintf>
    return 0;
c0100bfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100c02:	89 ec                	mov    %ebp,%esp
c0100c04:	5d                   	pop    %ebp
c0100c05:	c3                   	ret    

c0100c06 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c06:	55                   	push   %ebp
c0100c07:	89 e5                	mov    %esp,%ebp
c0100c09:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c0c:	c7 04 24 ec 6f 10 c0 	movl   $0xc0106fec,(%esp)
c0100c13:	e8 49 f7 ff ff       	call   c0100361 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c18:	c7 04 24 14 70 10 c0 	movl   $0xc0107014,(%esp)
c0100c1f:	e8 3d f7 ff ff       	call   c0100361 <cprintf>

    if (tf != NULL) {
c0100c24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c28:	74 0b                	je     c0100c35 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c2d:	89 04 24             	mov    %eax,(%esp)
c0100c30:	e8 73 0f 00 00       	call   c0101ba8 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c35:	c7 04 24 39 70 10 c0 	movl   $0xc0107039,(%esp)
c0100c3c:	e8 11 f6 ff ff       	call   c0100252 <readline>
c0100c41:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c48:	74 eb                	je     c0100c35 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
c0100c4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c54:	89 04 24             	mov    %eax,(%esp)
c0100c57:	e8 f2 fe ff ff       	call   c0100b4e <runcmd>
c0100c5c:	85 c0                	test   %eax,%eax
c0100c5e:	78 02                	js     c0100c62 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
c0100c60:	eb d3                	jmp    c0100c35 <kmonitor+0x2f>
                break;
c0100c62:	90                   	nop
            }
        }
    }
}
c0100c63:	90                   	nop
c0100c64:	89 ec                	mov    %ebp,%esp
c0100c66:	5d                   	pop    %ebp
c0100c67:	c3                   	ret    

c0100c68 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c68:	55                   	push   %ebp
c0100c69:	89 e5                	mov    %esp,%ebp
c0100c6b:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c75:	eb 3d                	jmp    c0100cb4 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c77:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c7a:	89 d0                	mov    %edx,%eax
c0100c7c:	01 c0                	add    %eax,%eax
c0100c7e:	01 d0                	add    %edx,%eax
c0100c80:	c1 e0 02             	shl    $0x2,%eax
c0100c83:	05 04 b0 11 c0       	add    $0xc011b004,%eax
c0100c88:	8b 10                	mov    (%eax),%edx
c0100c8a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100c8d:	89 c8                	mov    %ecx,%eax
c0100c8f:	01 c0                	add    %eax,%eax
c0100c91:	01 c8                	add    %ecx,%eax
c0100c93:	c1 e0 02             	shl    $0x2,%eax
c0100c96:	05 00 b0 11 c0       	add    $0xc011b000,%eax
c0100c9b:	8b 00                	mov    (%eax),%eax
c0100c9d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100ca1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ca5:	c7 04 24 3d 70 10 c0 	movl   $0xc010703d,(%esp)
c0100cac:	e8 b0 f6 ff ff       	call   c0100361 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cb1:	ff 45 f4             	incl   -0xc(%ebp)
c0100cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cb7:	83 f8 02             	cmp    $0x2,%eax
c0100cba:	76 bb                	jbe    c0100c77 <mon_help+0xf>
    }
    return 0;
c0100cbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc1:	89 ec                	mov    %ebp,%esp
c0100cc3:	5d                   	pop    %ebp
c0100cc4:	c3                   	ret    

c0100cc5 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cc5:	55                   	push   %ebp
c0100cc6:	89 e5                	mov    %esp,%ebp
c0100cc8:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100ccb:	e8 b4 fb ff ff       	call   c0100884 <print_kerninfo>
    return 0;
c0100cd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cd5:	89 ec                	mov    %ebp,%esp
c0100cd7:	5d                   	pop    %ebp
c0100cd8:	c3                   	ret    

c0100cd9 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cd9:	55                   	push   %ebp
c0100cda:	89 e5                	mov    %esp,%ebp
c0100cdc:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cdf:	e8 ec fc ff ff       	call   c01009d0 <print_stackframe>
    return 0;
c0100ce4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ce9:	89 ec                	mov    %ebp,%esp
c0100ceb:	5d                   	pop    %ebp
c0100cec:	c3                   	ret    

c0100ced <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100ced:	55                   	push   %ebp
c0100cee:	89 e5                	mov    %esp,%ebp
c0100cf0:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cf3:	a1 20 e4 11 c0       	mov    0xc011e420,%eax
c0100cf8:	85 c0                	test   %eax,%eax
c0100cfa:	75 5b                	jne    c0100d57 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c0100cfc:	c7 05 20 e4 11 c0 01 	movl   $0x1,0xc011e420
c0100d03:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100d06:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d09:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d0f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d13:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d16:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d1a:	c7 04 24 46 70 10 c0 	movl   $0xc0107046,(%esp)
c0100d21:	e8 3b f6 ff ff       	call   c0100361 <cprintf>
    vcprintf(fmt, ap);
c0100d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d2d:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d30:	89 04 24             	mov    %eax,(%esp)
c0100d33:	e8 f4 f5 ff ff       	call   c010032c <vcprintf>
    cprintf("\n");
c0100d38:	c7 04 24 62 70 10 c0 	movl   $0xc0107062,(%esp)
c0100d3f:	e8 1d f6 ff ff       	call   c0100361 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d44:	c7 04 24 64 70 10 c0 	movl   $0xc0107064,(%esp)
c0100d4b:	e8 11 f6 ff ff       	call   c0100361 <cprintf>
    print_stackframe();
c0100d50:	e8 7b fc ff ff       	call   c01009d0 <print_stackframe>
c0100d55:	eb 01                	jmp    c0100d58 <__panic+0x6b>
        goto panic_dead;
c0100d57:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100d58:	e8 e9 09 00 00       	call   c0101746 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d64:	e8 9d fe ff ff       	call   c0100c06 <kmonitor>
c0100d69:	eb f2                	jmp    c0100d5d <__panic+0x70>

c0100d6b <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d6b:	55                   	push   %ebp
c0100d6c:	89 e5                	mov    %esp,%ebp
c0100d6e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d71:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d74:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d77:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d7a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d81:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d85:	c7 04 24 76 70 10 c0 	movl   $0xc0107076,(%esp)
c0100d8c:	e8 d0 f5 ff ff       	call   c0100361 <cprintf>
    vcprintf(fmt, ap);
c0100d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d94:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d98:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d9b:	89 04 24             	mov    %eax,(%esp)
c0100d9e:	e8 89 f5 ff ff       	call   c010032c <vcprintf>
    cprintf("\n");
c0100da3:	c7 04 24 62 70 10 c0 	movl   $0xc0107062,(%esp)
c0100daa:	e8 b2 f5 ff ff       	call   c0100361 <cprintf>
    va_end(ap);
}
c0100daf:	90                   	nop
c0100db0:	89 ec                	mov    %ebp,%esp
c0100db2:	5d                   	pop    %ebp
c0100db3:	c3                   	ret    

c0100db4 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100db4:	55                   	push   %ebp
c0100db5:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100db7:	a1 20 e4 11 c0       	mov    0xc011e420,%eax
}
c0100dbc:	5d                   	pop    %ebp
c0100dbd:	c3                   	ret    

c0100dbe <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100dbe:	55                   	push   %ebp
c0100dbf:	89 e5                	mov    %esp,%ebp
c0100dc1:	83 ec 28             	sub    $0x28,%esp
c0100dc4:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100dca:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100dce:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dd2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dd6:	ee                   	out    %al,(%dx)
}
c0100dd7:	90                   	nop
c0100dd8:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100dde:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100de2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100de6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dea:	ee                   	out    %al,(%dx)
}
c0100deb:	90                   	nop
c0100dec:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100df2:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100df6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dfa:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100dfe:	ee                   	out    %al,(%dx)
}
c0100dff:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100e00:	c7 05 24 e4 11 c0 00 	movl   $0x0,0xc011e424
c0100e07:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e0a:	c7 04 24 94 70 10 c0 	movl   $0xc0107094,(%esp)
c0100e11:	e8 4b f5 ff ff       	call   c0100361 <cprintf>
    pic_enable(IRQ_TIMER);
c0100e16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e1d:	e8 89 09 00 00       	call   c01017ab <pic_enable>
}
c0100e22:	90                   	nop
c0100e23:	89 ec                	mov    %ebp,%esp
c0100e25:	5d                   	pop    %ebp
c0100e26:	c3                   	ret    

c0100e27 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e27:	55                   	push   %ebp
c0100e28:	89 e5                	mov    %esp,%ebp
c0100e2a:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e2d:	9c                   	pushf  
c0100e2e:	58                   	pop    %eax
c0100e2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e35:	25 00 02 00 00       	and    $0x200,%eax
c0100e3a:	85 c0                	test   %eax,%eax
c0100e3c:	74 0c                	je     c0100e4a <__intr_save+0x23>
        intr_disable();
c0100e3e:	e8 03 09 00 00       	call   c0101746 <intr_disable>
        return 1;
c0100e43:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e48:	eb 05                	jmp    c0100e4f <__intr_save+0x28>
    }
    return 0;
c0100e4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e4f:	89 ec                	mov    %ebp,%esp
c0100e51:	5d                   	pop    %ebp
c0100e52:	c3                   	ret    

c0100e53 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e53:	55                   	push   %ebp
c0100e54:	89 e5                	mov    %esp,%ebp
c0100e56:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e5d:	74 05                	je     c0100e64 <__intr_restore+0x11>
        intr_enable();
c0100e5f:	e8 da 08 00 00       	call   c010173e <intr_enable>
    }
}
c0100e64:	90                   	nop
c0100e65:	89 ec                	mov    %ebp,%esp
c0100e67:	5d                   	pop    %ebp
c0100e68:	c3                   	ret    

c0100e69 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e69:	55                   	push   %ebp
c0100e6a:	89 e5                	mov    %esp,%ebp
c0100e6c:	83 ec 10             	sub    $0x10,%esp
c0100e6f:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e75:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e79:	89 c2                	mov    %eax,%edx
c0100e7b:	ec                   	in     (%dx),%al
c0100e7c:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100e7f:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e85:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e89:	89 c2                	mov    %eax,%edx
c0100e8b:	ec                   	in     (%dx),%al
c0100e8c:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e8f:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e95:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e99:	89 c2                	mov    %eax,%edx
c0100e9b:	ec                   	in     (%dx),%al
c0100e9c:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e9f:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100ea5:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100ea9:	89 c2                	mov    %eax,%edx
c0100eab:	ec                   	in     (%dx),%al
c0100eac:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100eaf:	90                   	nop
c0100eb0:	89 ec                	mov    %ebp,%esp
c0100eb2:	5d                   	pop    %ebp
c0100eb3:	c3                   	ret    

c0100eb4 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100eb4:	55                   	push   %ebp
c0100eb5:	89 e5                	mov    %esp,%ebp
c0100eb7:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100eba:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec4:	0f b7 00             	movzwl (%eax),%eax
c0100ec7:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100ecb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ece:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100ed3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ed6:	0f b7 00             	movzwl (%eax),%eax
c0100ed9:	0f b7 c0             	movzwl %ax,%eax
c0100edc:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100ee1:	74 12                	je     c0100ef5 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ee3:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eea:	66 c7 05 46 e4 11 c0 	movw   $0x3b4,0xc011e446
c0100ef1:	b4 03 
c0100ef3:	eb 13                	jmp    c0100f08 <cga_init+0x54>
    } else {
        *cp = was;
c0100ef5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ef8:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100efc:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eff:	66 c7 05 46 e4 11 c0 	movw   $0x3d4,0xc011e446
c0100f06:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100f08:	0f b7 05 46 e4 11 c0 	movzwl 0xc011e446,%eax
c0100f0f:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f13:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f17:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f1b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f1f:	ee                   	out    %al,(%dx)
}
c0100f20:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f21:	0f b7 05 46 e4 11 c0 	movzwl 0xc011e446,%eax
c0100f28:	40                   	inc    %eax
c0100f29:	0f b7 c0             	movzwl %ax,%eax
c0100f2c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f30:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f34:	89 c2                	mov    %eax,%edx
c0100f36:	ec                   	in     (%dx),%al
c0100f37:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100f3a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f3e:	0f b6 c0             	movzbl %al,%eax
c0100f41:	c1 e0 08             	shl    $0x8,%eax
c0100f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f47:	0f b7 05 46 e4 11 c0 	movzwl 0xc011e446,%eax
c0100f4e:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f52:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f56:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f5a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f5e:	ee                   	out    %al,(%dx)
}
c0100f5f:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f60:	0f b7 05 46 e4 11 c0 	movzwl 0xc011e446,%eax
c0100f67:	40                   	inc    %eax
c0100f68:	0f b7 c0             	movzwl %ax,%eax
c0100f6b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f6f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f73:	89 c2                	mov    %eax,%edx
c0100f75:	ec                   	in     (%dx),%al
c0100f76:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100f79:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f7d:	0f b6 c0             	movzbl %al,%eax
c0100f80:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f83:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f86:	a3 40 e4 11 c0       	mov    %eax,0xc011e440
    crt_pos = pos;
c0100f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f8e:	0f b7 c0             	movzwl %ax,%eax
c0100f91:	66 a3 44 e4 11 c0    	mov    %ax,0xc011e444
}
c0100f97:	90                   	nop
c0100f98:	89 ec                	mov    %ebp,%esp
c0100f9a:	5d                   	pop    %ebp
c0100f9b:	c3                   	ret    

c0100f9c <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f9c:	55                   	push   %ebp
c0100f9d:	89 e5                	mov    %esp,%ebp
c0100f9f:	83 ec 48             	sub    $0x48,%esp
c0100fa2:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100fa8:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fac:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100fb0:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100fb4:	ee                   	out    %al,(%dx)
}
c0100fb5:	90                   	nop
c0100fb6:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100fbc:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fc0:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100fc4:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100fc8:	ee                   	out    %al,(%dx)
}
c0100fc9:	90                   	nop
c0100fca:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100fd0:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fd4:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100fd8:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100fdc:	ee                   	out    %al,(%dx)
}
c0100fdd:	90                   	nop
c0100fde:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fe4:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fe8:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fec:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100ff0:	ee                   	out    %al,(%dx)
}
c0100ff1:	90                   	nop
c0100ff2:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0100ff8:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ffc:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101000:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101004:	ee                   	out    %al,(%dx)
}
c0101005:	90                   	nop
c0101006:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c010100c:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101010:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101014:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101018:	ee                   	out    %al,(%dx)
}
c0101019:	90                   	nop
c010101a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0101020:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101024:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101028:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010102c:	ee                   	out    %al,(%dx)
}
c010102d:	90                   	nop
c010102e:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101034:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0101038:	89 c2                	mov    %eax,%edx
c010103a:	ec                   	in     (%dx),%al
c010103b:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c010103e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101042:	3c ff                	cmp    $0xff,%al
c0101044:	0f 95 c0             	setne  %al
c0101047:	0f b6 c0             	movzbl %al,%eax
c010104a:	a3 48 e4 11 c0       	mov    %eax,0xc011e448
c010104f:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101055:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101059:	89 c2                	mov    %eax,%edx
c010105b:	ec                   	in     (%dx),%al
c010105c:	88 45 f1             	mov    %al,-0xf(%ebp)
c010105f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101065:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101069:	89 c2                	mov    %eax,%edx
c010106b:	ec                   	in     (%dx),%al
c010106c:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010106f:	a1 48 e4 11 c0       	mov    0xc011e448,%eax
c0101074:	85 c0                	test   %eax,%eax
c0101076:	74 0c                	je     c0101084 <serial_init+0xe8>
        pic_enable(IRQ_COM1);
c0101078:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010107f:	e8 27 07 00 00       	call   c01017ab <pic_enable>
    }
}
c0101084:	90                   	nop
c0101085:	89 ec                	mov    %ebp,%esp
c0101087:	5d                   	pop    %ebp
c0101088:	c3                   	ret    

c0101089 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101089:	55                   	push   %ebp
c010108a:	89 e5                	mov    %esp,%ebp
c010108c:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010108f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101096:	eb 08                	jmp    c01010a0 <lpt_putc_sub+0x17>
        delay();
c0101098:	e8 cc fd ff ff       	call   c0100e69 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010109d:	ff 45 fc             	incl   -0x4(%ebp)
c01010a0:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c01010a6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01010aa:	89 c2                	mov    %eax,%edx
c01010ac:	ec                   	in     (%dx),%al
c01010ad:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01010b0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01010b4:	84 c0                	test   %al,%al
c01010b6:	78 09                	js     c01010c1 <lpt_putc_sub+0x38>
c01010b8:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01010bf:	7e d7                	jle    c0101098 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c01010c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01010c4:	0f b6 c0             	movzbl %al,%eax
c01010c7:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c01010cd:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010d0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010d4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010d8:	ee                   	out    %al,(%dx)
}
c01010d9:	90                   	nop
c01010da:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010e0:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010e4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010e8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010ec:	ee                   	out    %al,(%dx)
}
c01010ed:	90                   	nop
c01010ee:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c01010f4:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010f8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010fc:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101100:	ee                   	out    %al,(%dx)
}
c0101101:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101102:	90                   	nop
c0101103:	89 ec                	mov    %ebp,%esp
c0101105:	5d                   	pop    %ebp
c0101106:	c3                   	ret    

c0101107 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101107:	55                   	push   %ebp
c0101108:	89 e5                	mov    %esp,%ebp
c010110a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010110d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101111:	74 0d                	je     c0101120 <lpt_putc+0x19>
        lpt_putc_sub(c);
c0101113:	8b 45 08             	mov    0x8(%ebp),%eax
c0101116:	89 04 24             	mov    %eax,(%esp)
c0101119:	e8 6b ff ff ff       	call   c0101089 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c010111e:	eb 24                	jmp    c0101144 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
c0101120:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101127:	e8 5d ff ff ff       	call   c0101089 <lpt_putc_sub>
        lpt_putc_sub(' ');
c010112c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101133:	e8 51 ff ff ff       	call   c0101089 <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101138:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010113f:	e8 45 ff ff ff       	call   c0101089 <lpt_putc_sub>
}
c0101144:	90                   	nop
c0101145:	89 ec                	mov    %ebp,%esp
c0101147:	5d                   	pop    %ebp
c0101148:	c3                   	ret    

c0101149 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101149:	55                   	push   %ebp
c010114a:	89 e5                	mov    %esp,%ebp
c010114c:	83 ec 38             	sub    $0x38,%esp
c010114f:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
c0101152:	8b 45 08             	mov    0x8(%ebp),%eax
c0101155:	25 00 ff ff ff       	and    $0xffffff00,%eax
c010115a:	85 c0                	test   %eax,%eax
c010115c:	75 07                	jne    c0101165 <cga_putc+0x1c>
        c |= 0x0700;
c010115e:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101165:	8b 45 08             	mov    0x8(%ebp),%eax
c0101168:	0f b6 c0             	movzbl %al,%eax
c010116b:	83 f8 0d             	cmp    $0xd,%eax
c010116e:	74 72                	je     c01011e2 <cga_putc+0x99>
c0101170:	83 f8 0d             	cmp    $0xd,%eax
c0101173:	0f 8f a3 00 00 00    	jg     c010121c <cga_putc+0xd3>
c0101179:	83 f8 08             	cmp    $0x8,%eax
c010117c:	74 0a                	je     c0101188 <cga_putc+0x3f>
c010117e:	83 f8 0a             	cmp    $0xa,%eax
c0101181:	74 4c                	je     c01011cf <cga_putc+0x86>
c0101183:	e9 94 00 00 00       	jmp    c010121c <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
c0101188:	0f b7 05 44 e4 11 c0 	movzwl 0xc011e444,%eax
c010118f:	85 c0                	test   %eax,%eax
c0101191:	0f 84 af 00 00 00    	je     c0101246 <cga_putc+0xfd>
            crt_pos --;
c0101197:	0f b7 05 44 e4 11 c0 	movzwl 0xc011e444,%eax
c010119e:	48                   	dec    %eax
c010119f:	0f b7 c0             	movzwl %ax,%eax
c01011a2:	66 a3 44 e4 11 c0    	mov    %ax,0xc011e444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01011ab:	98                   	cwtl   
c01011ac:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01011b1:	98                   	cwtl   
c01011b2:	83 c8 20             	or     $0x20,%eax
c01011b5:	98                   	cwtl   
c01011b6:	8b 0d 40 e4 11 c0    	mov    0xc011e440,%ecx
c01011bc:	0f b7 15 44 e4 11 c0 	movzwl 0xc011e444,%edx
c01011c3:	01 d2                	add    %edx,%edx
c01011c5:	01 ca                	add    %ecx,%edx
c01011c7:	0f b7 c0             	movzwl %ax,%eax
c01011ca:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01011cd:	eb 77                	jmp    c0101246 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
c01011cf:	0f b7 05 44 e4 11 c0 	movzwl 0xc011e444,%eax
c01011d6:	83 c0 50             	add    $0x50,%eax
c01011d9:	0f b7 c0             	movzwl %ax,%eax
c01011dc:	66 a3 44 e4 11 c0    	mov    %ax,0xc011e444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01011e2:	0f b7 1d 44 e4 11 c0 	movzwl 0xc011e444,%ebx
c01011e9:	0f b7 0d 44 e4 11 c0 	movzwl 0xc011e444,%ecx
c01011f0:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c01011f5:	89 c8                	mov    %ecx,%eax
c01011f7:	f7 e2                	mul    %edx
c01011f9:	c1 ea 06             	shr    $0x6,%edx
c01011fc:	89 d0                	mov    %edx,%eax
c01011fe:	c1 e0 02             	shl    $0x2,%eax
c0101201:	01 d0                	add    %edx,%eax
c0101203:	c1 e0 04             	shl    $0x4,%eax
c0101206:	29 c1                	sub    %eax,%ecx
c0101208:	89 ca                	mov    %ecx,%edx
c010120a:	0f b7 d2             	movzwl %dx,%edx
c010120d:	89 d8                	mov    %ebx,%eax
c010120f:	29 d0                	sub    %edx,%eax
c0101211:	0f b7 c0             	movzwl %ax,%eax
c0101214:	66 a3 44 e4 11 c0    	mov    %ax,0xc011e444
        break;
c010121a:	eb 2b                	jmp    c0101247 <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c010121c:	8b 0d 40 e4 11 c0    	mov    0xc011e440,%ecx
c0101222:	0f b7 05 44 e4 11 c0 	movzwl 0xc011e444,%eax
c0101229:	8d 50 01             	lea    0x1(%eax),%edx
c010122c:	0f b7 d2             	movzwl %dx,%edx
c010122f:	66 89 15 44 e4 11 c0 	mov    %dx,0xc011e444
c0101236:	01 c0                	add    %eax,%eax
c0101238:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c010123b:	8b 45 08             	mov    0x8(%ebp),%eax
c010123e:	0f b7 c0             	movzwl %ax,%eax
c0101241:	66 89 02             	mov    %ax,(%edx)
        break;
c0101244:	eb 01                	jmp    c0101247 <cga_putc+0xfe>
        break;
c0101246:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101247:	0f b7 05 44 e4 11 c0 	movzwl 0xc011e444,%eax
c010124e:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101253:	76 5e                	jbe    c01012b3 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101255:	a1 40 e4 11 c0       	mov    0xc011e440,%eax
c010125a:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101260:	a1 40 e4 11 c0       	mov    0xc011e440,%eax
c0101265:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c010126c:	00 
c010126d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101271:	89 04 24             	mov    %eax,(%esp)
c0101274:	e8 b6 59 00 00       	call   c0106c2f <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101279:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101280:	eb 15                	jmp    c0101297 <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
c0101282:	8b 15 40 e4 11 c0    	mov    0xc011e440,%edx
c0101288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010128b:	01 c0                	add    %eax,%eax
c010128d:	01 d0                	add    %edx,%eax
c010128f:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101294:	ff 45 f4             	incl   -0xc(%ebp)
c0101297:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010129e:	7e e2                	jle    c0101282 <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
c01012a0:	0f b7 05 44 e4 11 c0 	movzwl 0xc011e444,%eax
c01012a7:	83 e8 50             	sub    $0x50,%eax
c01012aa:	0f b7 c0             	movzwl %ax,%eax
c01012ad:	66 a3 44 e4 11 c0    	mov    %ax,0xc011e444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012b3:	0f b7 05 46 e4 11 c0 	movzwl 0xc011e446,%eax
c01012ba:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c01012be:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012c2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012c6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012ca:	ee                   	out    %al,(%dx)
}
c01012cb:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c01012cc:	0f b7 05 44 e4 11 c0 	movzwl 0xc011e444,%eax
c01012d3:	c1 e8 08             	shr    $0x8,%eax
c01012d6:	0f b7 c0             	movzwl %ax,%eax
c01012d9:	0f b6 c0             	movzbl %al,%eax
c01012dc:	0f b7 15 46 e4 11 c0 	movzwl 0xc011e446,%edx
c01012e3:	42                   	inc    %edx
c01012e4:	0f b7 d2             	movzwl %dx,%edx
c01012e7:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c01012eb:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012ee:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012f2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012f6:	ee                   	out    %al,(%dx)
}
c01012f7:	90                   	nop
    outb(addr_6845, 15);
c01012f8:	0f b7 05 46 e4 11 c0 	movzwl 0xc011e446,%eax
c01012ff:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101303:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101307:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010130b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010130f:	ee                   	out    %al,(%dx)
}
c0101310:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c0101311:	0f b7 05 44 e4 11 c0 	movzwl 0xc011e444,%eax
c0101318:	0f b6 c0             	movzbl %al,%eax
c010131b:	0f b7 15 46 e4 11 c0 	movzwl 0xc011e446,%edx
c0101322:	42                   	inc    %edx
c0101323:	0f b7 d2             	movzwl %dx,%edx
c0101326:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c010132a:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010132d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101331:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101335:	ee                   	out    %al,(%dx)
}
c0101336:	90                   	nop
}
c0101337:	90                   	nop
c0101338:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010133b:	89 ec                	mov    %ebp,%esp
c010133d:	5d                   	pop    %ebp
c010133e:	c3                   	ret    

c010133f <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c010133f:	55                   	push   %ebp
c0101340:	89 e5                	mov    %esp,%ebp
c0101342:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101345:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010134c:	eb 08                	jmp    c0101356 <serial_putc_sub+0x17>
        delay();
c010134e:	e8 16 fb ff ff       	call   c0100e69 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101353:	ff 45 fc             	incl   -0x4(%ebp)
c0101356:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010135c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101360:	89 c2                	mov    %eax,%edx
c0101362:	ec                   	in     (%dx),%al
c0101363:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101366:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010136a:	0f b6 c0             	movzbl %al,%eax
c010136d:	83 e0 20             	and    $0x20,%eax
c0101370:	85 c0                	test   %eax,%eax
c0101372:	75 09                	jne    c010137d <serial_putc_sub+0x3e>
c0101374:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010137b:	7e d1                	jle    c010134e <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c010137d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101380:	0f b6 c0             	movzbl %al,%eax
c0101383:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101389:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010138c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101390:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101394:	ee                   	out    %al,(%dx)
}
c0101395:	90                   	nop
}
c0101396:	90                   	nop
c0101397:	89 ec                	mov    %ebp,%esp
c0101399:	5d                   	pop    %ebp
c010139a:	c3                   	ret    

c010139b <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010139b:	55                   	push   %ebp
c010139c:	89 e5                	mov    %esp,%ebp
c010139e:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01013a1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01013a5:	74 0d                	je     c01013b4 <serial_putc+0x19>
        serial_putc_sub(c);
c01013a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01013aa:	89 04 24             	mov    %eax,(%esp)
c01013ad:	e8 8d ff ff ff       	call   c010133f <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c01013b2:	eb 24                	jmp    c01013d8 <serial_putc+0x3d>
        serial_putc_sub('\b');
c01013b4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013bb:	e8 7f ff ff ff       	call   c010133f <serial_putc_sub>
        serial_putc_sub(' ');
c01013c0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01013c7:	e8 73 ff ff ff       	call   c010133f <serial_putc_sub>
        serial_putc_sub('\b');
c01013cc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013d3:	e8 67 ff ff ff       	call   c010133f <serial_putc_sub>
}
c01013d8:	90                   	nop
c01013d9:	89 ec                	mov    %ebp,%esp
c01013db:	5d                   	pop    %ebp
c01013dc:	c3                   	ret    

c01013dd <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c01013dd:	55                   	push   %ebp
c01013de:	89 e5                	mov    %esp,%ebp
c01013e0:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c01013e3:	eb 33                	jmp    c0101418 <cons_intr+0x3b>
        if (c != 0) {
c01013e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01013e9:	74 2d                	je     c0101418 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c01013eb:	a1 64 e6 11 c0       	mov    0xc011e664,%eax
c01013f0:	8d 50 01             	lea    0x1(%eax),%edx
c01013f3:	89 15 64 e6 11 c0    	mov    %edx,0xc011e664
c01013f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013fc:	88 90 60 e4 11 c0    	mov    %dl,-0x3fee1ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101402:	a1 64 e6 11 c0       	mov    0xc011e664,%eax
c0101407:	3d 00 02 00 00       	cmp    $0x200,%eax
c010140c:	75 0a                	jne    c0101418 <cons_intr+0x3b>
                cons.wpos = 0;
c010140e:	c7 05 64 e6 11 c0 00 	movl   $0x0,0xc011e664
c0101415:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101418:	8b 45 08             	mov    0x8(%ebp),%eax
c010141b:	ff d0                	call   *%eax
c010141d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101420:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101424:	75 bf                	jne    c01013e5 <cons_intr+0x8>
            }
        }
    }
}
c0101426:	90                   	nop
c0101427:	90                   	nop
c0101428:	89 ec                	mov    %ebp,%esp
c010142a:	5d                   	pop    %ebp
c010142b:	c3                   	ret    

c010142c <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c010142c:	55                   	push   %ebp
c010142d:	89 e5                	mov    %esp,%ebp
c010142f:	83 ec 10             	sub    $0x10,%esp
c0101432:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101438:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010143c:	89 c2                	mov    %eax,%edx
c010143e:	ec                   	in     (%dx),%al
c010143f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101442:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101446:	0f b6 c0             	movzbl %al,%eax
c0101449:	83 e0 01             	and    $0x1,%eax
c010144c:	85 c0                	test   %eax,%eax
c010144e:	75 07                	jne    c0101457 <serial_proc_data+0x2b>
        return -1;
c0101450:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101455:	eb 2a                	jmp    c0101481 <serial_proc_data+0x55>
c0101457:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010145d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101461:	89 c2                	mov    %eax,%edx
c0101463:	ec                   	in     (%dx),%al
c0101464:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101467:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c010146b:	0f b6 c0             	movzbl %al,%eax
c010146e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101471:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101475:	75 07                	jne    c010147e <serial_proc_data+0x52>
        c = '\b';
c0101477:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010147e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101481:	89 ec                	mov    %ebp,%esp
c0101483:	5d                   	pop    %ebp
c0101484:	c3                   	ret    

c0101485 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101485:	55                   	push   %ebp
c0101486:	89 e5                	mov    %esp,%ebp
c0101488:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010148b:	a1 48 e4 11 c0       	mov    0xc011e448,%eax
c0101490:	85 c0                	test   %eax,%eax
c0101492:	74 0c                	je     c01014a0 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101494:	c7 04 24 2c 14 10 c0 	movl   $0xc010142c,(%esp)
c010149b:	e8 3d ff ff ff       	call   c01013dd <cons_intr>
    }
}
c01014a0:	90                   	nop
c01014a1:	89 ec                	mov    %ebp,%esp
c01014a3:	5d                   	pop    %ebp
c01014a4:	c3                   	ret    

c01014a5 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01014a5:	55                   	push   %ebp
c01014a6:	89 e5                	mov    %esp,%ebp
c01014a8:	83 ec 38             	sub    $0x38,%esp
c01014ab:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01014b4:	89 c2                	mov    %eax,%edx
c01014b6:	ec                   	in     (%dx),%al
c01014b7:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c01014ba:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c01014be:	0f b6 c0             	movzbl %al,%eax
c01014c1:	83 e0 01             	and    $0x1,%eax
c01014c4:	85 c0                	test   %eax,%eax
c01014c6:	75 0a                	jne    c01014d2 <kbd_proc_data+0x2d>
        return -1;
c01014c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014cd:	e9 56 01 00 00       	jmp    c0101628 <kbd_proc_data+0x183>
c01014d2:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01014db:	89 c2                	mov    %eax,%edx
c01014dd:	ec                   	in     (%dx),%al
c01014de:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c01014e1:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c01014e5:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c01014e8:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c01014ec:	75 17                	jne    c0101505 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
c01014ee:	a1 68 e6 11 c0       	mov    0xc011e668,%eax
c01014f3:	83 c8 40             	or     $0x40,%eax
c01014f6:	a3 68 e6 11 c0       	mov    %eax,0xc011e668
        return 0;
c01014fb:	b8 00 00 00 00       	mov    $0x0,%eax
c0101500:	e9 23 01 00 00       	jmp    c0101628 <kbd_proc_data+0x183>
    } else if (data & 0x80) {
c0101505:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101509:	84 c0                	test   %al,%al
c010150b:	79 45                	jns    c0101552 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010150d:	a1 68 e6 11 c0       	mov    0xc011e668,%eax
c0101512:	83 e0 40             	and    $0x40,%eax
c0101515:	85 c0                	test   %eax,%eax
c0101517:	75 08                	jne    c0101521 <kbd_proc_data+0x7c>
c0101519:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010151d:	24 7f                	and    $0x7f,%al
c010151f:	eb 04                	jmp    c0101525 <kbd_proc_data+0x80>
c0101521:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101525:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101528:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010152c:	0f b6 80 40 b0 11 c0 	movzbl -0x3fee4fc0(%eax),%eax
c0101533:	0c 40                	or     $0x40,%al
c0101535:	0f b6 c0             	movzbl %al,%eax
c0101538:	f7 d0                	not    %eax
c010153a:	89 c2                	mov    %eax,%edx
c010153c:	a1 68 e6 11 c0       	mov    0xc011e668,%eax
c0101541:	21 d0                	and    %edx,%eax
c0101543:	a3 68 e6 11 c0       	mov    %eax,0xc011e668
        return 0;
c0101548:	b8 00 00 00 00       	mov    $0x0,%eax
c010154d:	e9 d6 00 00 00       	jmp    c0101628 <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
c0101552:	a1 68 e6 11 c0       	mov    0xc011e668,%eax
c0101557:	83 e0 40             	and    $0x40,%eax
c010155a:	85 c0                	test   %eax,%eax
c010155c:	74 11                	je     c010156f <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c010155e:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101562:	a1 68 e6 11 c0       	mov    0xc011e668,%eax
c0101567:	83 e0 bf             	and    $0xffffffbf,%eax
c010156a:	a3 68 e6 11 c0       	mov    %eax,0xc011e668
    }

    shift |= shiftcode[data];
c010156f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101573:	0f b6 80 40 b0 11 c0 	movzbl -0x3fee4fc0(%eax),%eax
c010157a:	0f b6 d0             	movzbl %al,%edx
c010157d:	a1 68 e6 11 c0       	mov    0xc011e668,%eax
c0101582:	09 d0                	or     %edx,%eax
c0101584:	a3 68 e6 11 c0       	mov    %eax,0xc011e668
    shift ^= togglecode[data];
c0101589:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010158d:	0f b6 80 40 b1 11 c0 	movzbl -0x3fee4ec0(%eax),%eax
c0101594:	0f b6 d0             	movzbl %al,%edx
c0101597:	a1 68 e6 11 c0       	mov    0xc011e668,%eax
c010159c:	31 d0                	xor    %edx,%eax
c010159e:	a3 68 e6 11 c0       	mov    %eax,0xc011e668

    c = charcode[shift & (CTL | SHIFT)][data];
c01015a3:	a1 68 e6 11 c0       	mov    0xc011e668,%eax
c01015a8:	83 e0 03             	and    $0x3,%eax
c01015ab:	8b 14 85 40 b5 11 c0 	mov    -0x3fee4ac0(,%eax,4),%edx
c01015b2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015b6:	01 d0                	add    %edx,%eax
c01015b8:	0f b6 00             	movzbl (%eax),%eax
c01015bb:	0f b6 c0             	movzbl %al,%eax
c01015be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c01015c1:	a1 68 e6 11 c0       	mov    0xc011e668,%eax
c01015c6:	83 e0 08             	and    $0x8,%eax
c01015c9:	85 c0                	test   %eax,%eax
c01015cb:	74 22                	je     c01015ef <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
c01015cd:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c01015d1:	7e 0c                	jle    c01015df <kbd_proc_data+0x13a>
c01015d3:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c01015d7:	7f 06                	jg     c01015df <kbd_proc_data+0x13a>
            c += 'A' - 'a';
c01015d9:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c01015dd:	eb 10                	jmp    c01015ef <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
c01015df:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c01015e3:	7e 0a                	jle    c01015ef <kbd_proc_data+0x14a>
c01015e5:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c01015e9:	7f 04                	jg     c01015ef <kbd_proc_data+0x14a>
            c += 'a' - 'A';
c01015eb:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c01015ef:	a1 68 e6 11 c0       	mov    0xc011e668,%eax
c01015f4:	f7 d0                	not    %eax
c01015f6:	83 e0 06             	and    $0x6,%eax
c01015f9:	85 c0                	test   %eax,%eax
c01015fb:	75 28                	jne    c0101625 <kbd_proc_data+0x180>
c01015fd:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101604:	75 1f                	jne    c0101625 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
c0101606:	c7 04 24 af 70 10 c0 	movl   $0xc01070af,(%esp)
c010160d:	e8 4f ed ff ff       	call   c0100361 <cprintf>
c0101612:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101618:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010161c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101620:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101623:	ee                   	out    %al,(%dx)
}
c0101624:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101625:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101628:	89 ec                	mov    %ebp,%esp
c010162a:	5d                   	pop    %ebp
c010162b:	c3                   	ret    

c010162c <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010162c:	55                   	push   %ebp
c010162d:	89 e5                	mov    %esp,%ebp
c010162f:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101632:	c7 04 24 a5 14 10 c0 	movl   $0xc01014a5,(%esp)
c0101639:	e8 9f fd ff ff       	call   c01013dd <cons_intr>
}
c010163e:	90                   	nop
c010163f:	89 ec                	mov    %ebp,%esp
c0101641:	5d                   	pop    %ebp
c0101642:	c3                   	ret    

c0101643 <kbd_init>:

static void
kbd_init(void) {
c0101643:	55                   	push   %ebp
c0101644:	89 e5                	mov    %esp,%ebp
c0101646:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c0101649:	e8 de ff ff ff       	call   c010162c <kbd_intr>
    pic_enable(IRQ_KBD);
c010164e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101655:	e8 51 01 00 00       	call   c01017ab <pic_enable>
}
c010165a:	90                   	nop
c010165b:	89 ec                	mov    %ebp,%esp
c010165d:	5d                   	pop    %ebp
c010165e:	c3                   	ret    

c010165f <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c010165f:	55                   	push   %ebp
c0101660:	89 e5                	mov    %esp,%ebp
c0101662:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101665:	e8 4a f8 ff ff       	call   c0100eb4 <cga_init>
    serial_init();
c010166a:	e8 2d f9 ff ff       	call   c0100f9c <serial_init>
    kbd_init();
c010166f:	e8 cf ff ff ff       	call   c0101643 <kbd_init>
    if (!serial_exists) {
c0101674:	a1 48 e4 11 c0       	mov    0xc011e448,%eax
c0101679:	85 c0                	test   %eax,%eax
c010167b:	75 0c                	jne    c0101689 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c010167d:	c7 04 24 bb 70 10 c0 	movl   $0xc01070bb,(%esp)
c0101684:	e8 d8 ec ff ff       	call   c0100361 <cprintf>
    }
}
c0101689:	90                   	nop
c010168a:	89 ec                	mov    %ebp,%esp
c010168c:	5d                   	pop    %ebp
c010168d:	c3                   	ret    

c010168e <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010168e:	55                   	push   %ebp
c010168f:	89 e5                	mov    %esp,%ebp
c0101691:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101694:	e8 8e f7 ff ff       	call   c0100e27 <__intr_save>
c0101699:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010169c:	8b 45 08             	mov    0x8(%ebp),%eax
c010169f:	89 04 24             	mov    %eax,(%esp)
c01016a2:	e8 60 fa ff ff       	call   c0101107 <lpt_putc>
        cga_putc(c);
c01016a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01016aa:	89 04 24             	mov    %eax,(%esp)
c01016ad:	e8 97 fa ff ff       	call   c0101149 <cga_putc>
        serial_putc(c);
c01016b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b5:	89 04 24             	mov    %eax,(%esp)
c01016b8:	e8 de fc ff ff       	call   c010139b <serial_putc>
    }
    local_intr_restore(intr_flag);
c01016bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01016c0:	89 04 24             	mov    %eax,(%esp)
c01016c3:	e8 8b f7 ff ff       	call   c0100e53 <__intr_restore>
}
c01016c8:	90                   	nop
c01016c9:	89 ec                	mov    %ebp,%esp
c01016cb:	5d                   	pop    %ebp
c01016cc:	c3                   	ret    

c01016cd <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c01016cd:	55                   	push   %ebp
c01016ce:	89 e5                	mov    %esp,%ebp
c01016d0:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c01016d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c01016da:	e8 48 f7 ff ff       	call   c0100e27 <__intr_save>
c01016df:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c01016e2:	e8 9e fd ff ff       	call   c0101485 <serial_intr>
        kbd_intr();
c01016e7:	e8 40 ff ff ff       	call   c010162c <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c01016ec:	8b 15 60 e6 11 c0    	mov    0xc011e660,%edx
c01016f2:	a1 64 e6 11 c0       	mov    0xc011e664,%eax
c01016f7:	39 c2                	cmp    %eax,%edx
c01016f9:	74 31                	je     c010172c <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c01016fb:	a1 60 e6 11 c0       	mov    0xc011e660,%eax
c0101700:	8d 50 01             	lea    0x1(%eax),%edx
c0101703:	89 15 60 e6 11 c0    	mov    %edx,0xc011e660
c0101709:	0f b6 80 60 e4 11 c0 	movzbl -0x3fee1ba0(%eax),%eax
c0101710:	0f b6 c0             	movzbl %al,%eax
c0101713:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101716:	a1 60 e6 11 c0       	mov    0xc011e660,%eax
c010171b:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101720:	75 0a                	jne    c010172c <cons_getc+0x5f>
                cons.rpos = 0;
c0101722:	c7 05 60 e6 11 c0 00 	movl   $0x0,0xc011e660
c0101729:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010172c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010172f:	89 04 24             	mov    %eax,(%esp)
c0101732:	e8 1c f7 ff ff       	call   c0100e53 <__intr_restore>
    return c;
c0101737:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010173a:	89 ec                	mov    %ebp,%esp
c010173c:	5d                   	pop    %ebp
c010173d:	c3                   	ret    

c010173e <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c010173e:	55                   	push   %ebp
c010173f:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101741:	fb                   	sti    
}
c0101742:	90                   	nop
    sti();
}
c0101743:	90                   	nop
c0101744:	5d                   	pop    %ebp
c0101745:	c3                   	ret    

c0101746 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101746:	55                   	push   %ebp
c0101747:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c0101749:	fa                   	cli    
}
c010174a:	90                   	nop
    cli();
}
c010174b:	90                   	nop
c010174c:	5d                   	pop    %ebp
c010174d:	c3                   	ret    

c010174e <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c010174e:	55                   	push   %ebp
c010174f:	89 e5                	mov    %esp,%ebp
c0101751:	83 ec 14             	sub    $0x14,%esp
c0101754:	8b 45 08             	mov    0x8(%ebp),%eax
c0101757:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c010175b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010175e:	66 a3 50 b5 11 c0    	mov    %ax,0xc011b550
    if (did_init) {
c0101764:	a1 6c e6 11 c0       	mov    0xc011e66c,%eax
c0101769:	85 c0                	test   %eax,%eax
c010176b:	74 39                	je     c01017a6 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
c010176d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101770:	0f b6 c0             	movzbl %al,%eax
c0101773:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c0101779:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010177c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101780:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101784:	ee                   	out    %al,(%dx)
}
c0101785:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c0101786:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010178a:	c1 e8 08             	shr    $0x8,%eax
c010178d:	0f b7 c0             	movzwl %ax,%eax
c0101790:	0f b6 c0             	movzbl %al,%eax
c0101793:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c0101799:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010179c:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01017a0:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01017a4:	ee                   	out    %al,(%dx)
}
c01017a5:	90                   	nop
    }
}
c01017a6:	90                   	nop
c01017a7:	89 ec                	mov    %ebp,%esp
c01017a9:	5d                   	pop    %ebp
c01017aa:	c3                   	ret    

c01017ab <pic_enable>:

void
pic_enable(unsigned int irq) {
c01017ab:	55                   	push   %ebp
c01017ac:	89 e5                	mov    %esp,%ebp
c01017ae:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c01017b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01017b4:	ba 01 00 00 00       	mov    $0x1,%edx
c01017b9:	88 c1                	mov    %al,%cl
c01017bb:	d3 e2                	shl    %cl,%edx
c01017bd:	89 d0                	mov    %edx,%eax
c01017bf:	98                   	cwtl   
c01017c0:	f7 d0                	not    %eax
c01017c2:	0f bf d0             	movswl %ax,%edx
c01017c5:	0f b7 05 50 b5 11 c0 	movzwl 0xc011b550,%eax
c01017cc:	98                   	cwtl   
c01017cd:	21 d0                	and    %edx,%eax
c01017cf:	98                   	cwtl   
c01017d0:	0f b7 c0             	movzwl %ax,%eax
c01017d3:	89 04 24             	mov    %eax,(%esp)
c01017d6:	e8 73 ff ff ff       	call   c010174e <pic_setmask>
}
c01017db:	90                   	nop
c01017dc:	89 ec                	mov    %ebp,%esp
c01017de:	5d                   	pop    %ebp
c01017df:	c3                   	ret    

c01017e0 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c01017e0:	55                   	push   %ebp
c01017e1:	89 e5                	mov    %esp,%ebp
c01017e3:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c01017e6:	c7 05 6c e6 11 c0 01 	movl   $0x1,0xc011e66c
c01017ed:	00 00 00 
c01017f0:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c01017f6:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017fa:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017fe:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101802:	ee                   	out    %al,(%dx)
}
c0101803:	90                   	nop
c0101804:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c010180a:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010180e:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101812:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101816:	ee                   	out    %al,(%dx)
}
c0101817:	90                   	nop
c0101818:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010181e:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101822:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101826:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010182a:	ee                   	out    %al,(%dx)
}
c010182b:	90                   	nop
c010182c:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101832:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101836:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010183a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010183e:	ee                   	out    %al,(%dx)
}
c010183f:	90                   	nop
c0101840:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c0101846:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010184a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010184e:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101852:	ee                   	out    %al,(%dx)
}
c0101853:	90                   	nop
c0101854:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c010185a:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010185e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101862:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101866:	ee                   	out    %al,(%dx)
}
c0101867:	90                   	nop
c0101868:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c010186e:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101872:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101876:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010187a:	ee                   	out    %al,(%dx)
}
c010187b:	90                   	nop
c010187c:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c0101882:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101886:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010188a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010188e:	ee                   	out    %al,(%dx)
}
c010188f:	90                   	nop
c0101890:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c0101896:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010189a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010189e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01018a2:	ee                   	out    %al,(%dx)
}
c01018a3:	90                   	nop
c01018a4:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01018aa:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018ae:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01018b2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01018b6:	ee                   	out    %al,(%dx)
}
c01018b7:	90                   	nop
c01018b8:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c01018be:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018c2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01018c6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01018ca:	ee                   	out    %al,(%dx)
}
c01018cb:	90                   	nop
c01018cc:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01018d2:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018d6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01018da:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01018de:	ee                   	out    %al,(%dx)
}
c01018df:	90                   	nop
c01018e0:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c01018e6:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018ea:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01018ee:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01018f2:	ee                   	out    %al,(%dx)
}
c01018f3:	90                   	nop
c01018f4:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c01018fa:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018fe:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101902:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101906:	ee                   	out    %al,(%dx)
}
c0101907:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101908:	0f b7 05 50 b5 11 c0 	movzwl 0xc011b550,%eax
c010190f:	3d ff ff 00 00       	cmp    $0xffff,%eax
c0101914:	74 0f                	je     c0101925 <pic_init+0x145>
        pic_setmask(irq_mask);
c0101916:	0f b7 05 50 b5 11 c0 	movzwl 0xc011b550,%eax
c010191d:	89 04 24             	mov    %eax,(%esp)
c0101920:	e8 29 fe ff ff       	call   c010174e <pic_setmask>
    }
}
c0101925:	90                   	nop
c0101926:	89 ec                	mov    %ebp,%esp
c0101928:	5d                   	pop    %ebp
c0101929:	c3                   	ret    

c010192a <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010192a:	55                   	push   %ebp
c010192b:	89 e5                	mov    %esp,%ebp
c010192d:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101930:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101937:	00 
c0101938:	c7 04 24 e0 70 10 c0 	movl   $0xc01070e0,(%esp)
c010193f:	e8 1d ea ff ff       	call   c0100361 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0101944:	c7 04 24 ea 70 10 c0 	movl   $0xc01070ea,(%esp)
c010194b:	e8 11 ea ff ff       	call   c0100361 <cprintf>
    panic("EOT: kernel seems ok.");
c0101950:	c7 44 24 08 f8 70 10 	movl   $0xc01070f8,0x8(%esp)
c0101957:	c0 
c0101958:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c010195f:	00 
c0101960:	c7 04 24 0e 71 10 c0 	movl   $0xc010710e,(%esp)
c0101967:	e8 81 f3 ff ff       	call   c0100ced <__panic>

c010196c <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010196c:	55                   	push   %ebp
c010196d:	89 e5                	mov    %esp,%ebp
c010196f:	83 ec 10             	sub    $0x10,%esp
    //然后使用lidt加载IDT即可，指令格式与LGDT类似；至此完成了中断描述符表的初始化过程；

    // entry adders of ISR(Interrupt Service Routine)
    extern uintptr_t __vectors[];
    // setup the entries of ISR in IDT(Interrupt Description Table)
    int n=sizeof(idt)/sizeof(struct gatedesc);
c0101972:	c7 45 f8 00 01 00 00 	movl   $0x100,-0x8(%ebp)
    for(int i=0;i<n;i++){
c0101979:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101980:	e9 c4 00 00 00       	jmp    c0101a49 <idt_init+0xdd>
        trap: 1 for a trap (= exception) gate, 0 for an interrupt gate
        sel: 段选择器
        off: 偏移
        dpl: 特权级
        * */
        SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
c0101985:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101988:	8b 04 85 e0 b5 11 c0 	mov    -0x3fee4a20(,%eax,4),%eax
c010198f:	0f b7 d0             	movzwl %ax,%edx
c0101992:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101995:	66 89 14 c5 80 e6 11 	mov    %dx,-0x3fee1980(,%eax,8)
c010199c:	c0 
c010199d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a0:	66 c7 04 c5 82 e6 11 	movw   $0x8,-0x3fee197e(,%eax,8)
c01019a7:	c0 08 00 
c01019aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019ad:	0f b6 14 c5 84 e6 11 	movzbl -0x3fee197c(,%eax,8),%edx
c01019b4:	c0 
c01019b5:	80 e2 e0             	and    $0xe0,%dl
c01019b8:	88 14 c5 84 e6 11 c0 	mov    %dl,-0x3fee197c(,%eax,8)
c01019bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019c2:	0f b6 14 c5 84 e6 11 	movzbl -0x3fee197c(,%eax,8),%edx
c01019c9:	c0 
c01019ca:	80 e2 1f             	and    $0x1f,%dl
c01019cd:	88 14 c5 84 e6 11 c0 	mov    %dl,-0x3fee197c(,%eax,8)
c01019d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019d7:	0f b6 14 c5 85 e6 11 	movzbl -0x3fee197b(,%eax,8),%edx
c01019de:	c0 
c01019df:	80 e2 f0             	and    $0xf0,%dl
c01019e2:	80 ca 0e             	or     $0xe,%dl
c01019e5:	88 14 c5 85 e6 11 c0 	mov    %dl,-0x3fee197b(,%eax,8)
c01019ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019ef:	0f b6 14 c5 85 e6 11 	movzbl -0x3fee197b(,%eax,8),%edx
c01019f6:	c0 
c01019f7:	80 e2 ef             	and    $0xef,%dl
c01019fa:	88 14 c5 85 e6 11 c0 	mov    %dl,-0x3fee197b(,%eax,8)
c0101a01:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a04:	0f b6 14 c5 85 e6 11 	movzbl -0x3fee197b(,%eax,8),%edx
c0101a0b:	c0 
c0101a0c:	80 e2 9f             	and    $0x9f,%dl
c0101a0f:	88 14 c5 85 e6 11 c0 	mov    %dl,-0x3fee197b(,%eax,8)
c0101a16:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a19:	0f b6 14 c5 85 e6 11 	movzbl -0x3fee197b(,%eax,8),%edx
c0101a20:	c0 
c0101a21:	80 ca 80             	or     $0x80,%dl
c0101a24:	88 14 c5 85 e6 11 c0 	mov    %dl,-0x3fee197b(,%eax,8)
c0101a2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a2e:	8b 04 85 e0 b5 11 c0 	mov    -0x3fee4a20(,%eax,4),%eax
c0101a35:	c1 e8 10             	shr    $0x10,%eax
c0101a38:	0f b7 d0             	movzwl %ax,%edx
c0101a3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a3e:	66 89 14 c5 86 e6 11 	mov    %dx,-0x3fee197a(,%eax,8)
c0101a45:	c0 
    for(int i=0;i<n;i++){
c0101a46:	ff 45 fc             	incl   -0x4(%ebp)
c0101a49:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a4c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0101a4f:	0f 8c 30 ff ff ff    	jl     c0101985 <idt_init+0x19>
    }
    //系统调用中断
    //而ucore的应用程序处于特权级３，需要采用｀int 0x80`指令操作（软中断）来发出系统调用请求，并要能实现从特权级３到特权级０的转换
    //所以系统调用中断(T_SYSCALL)所对应的中断门描述符中的特权级（DPL）需要设置为３。
    SETGATE(idt[T_SYSCALL],1,GD_KTEXT,__vectors[T_SYSCALL],DPL_USER);
c0101a55:	a1 e0 b7 11 c0       	mov    0xc011b7e0,%eax
c0101a5a:	0f b7 c0             	movzwl %ax,%eax
c0101a5d:	66 a3 80 ea 11 c0    	mov    %ax,0xc011ea80
c0101a63:	66 c7 05 82 ea 11 c0 	movw   $0x8,0xc011ea82
c0101a6a:	08 00 
c0101a6c:	0f b6 05 84 ea 11 c0 	movzbl 0xc011ea84,%eax
c0101a73:	24 e0                	and    $0xe0,%al
c0101a75:	a2 84 ea 11 c0       	mov    %al,0xc011ea84
c0101a7a:	0f b6 05 84 ea 11 c0 	movzbl 0xc011ea84,%eax
c0101a81:	24 1f                	and    $0x1f,%al
c0101a83:	a2 84 ea 11 c0       	mov    %al,0xc011ea84
c0101a88:	0f b6 05 85 ea 11 c0 	movzbl 0xc011ea85,%eax
c0101a8f:	0c 0f                	or     $0xf,%al
c0101a91:	a2 85 ea 11 c0       	mov    %al,0xc011ea85
c0101a96:	0f b6 05 85 ea 11 c0 	movzbl 0xc011ea85,%eax
c0101a9d:	24 ef                	and    $0xef,%al
c0101a9f:	a2 85 ea 11 c0       	mov    %al,0xc011ea85
c0101aa4:	0f b6 05 85 ea 11 c0 	movzbl 0xc011ea85,%eax
c0101aab:	0c 60                	or     $0x60,%al
c0101aad:	a2 85 ea 11 c0       	mov    %al,0xc011ea85
c0101ab2:	0f b6 05 85 ea 11 c0 	movzbl 0xc011ea85,%eax
c0101ab9:	0c 80                	or     $0x80,%al
c0101abb:	a2 85 ea 11 c0       	mov    %al,0xc011ea85
c0101ac0:	a1 e0 b7 11 c0       	mov    0xc011b7e0,%eax
c0101ac5:	c1 e8 10             	shr    $0x10,%eax
c0101ac8:	0f b7 c0             	movzwl %ax,%eax
c0101acb:	66 a3 86 ea 11 c0    	mov    %ax,0xc011ea86
    SETGATE(idt[T_SWITCH_TOK],0,GD_KTEXT,__vectors[T_SWITCH_TOK],DPL_USER);
c0101ad1:	a1 c4 b7 11 c0       	mov    0xc011b7c4,%eax
c0101ad6:	0f b7 c0             	movzwl %ax,%eax
c0101ad9:	66 a3 48 ea 11 c0    	mov    %ax,0xc011ea48
c0101adf:	66 c7 05 4a ea 11 c0 	movw   $0x8,0xc011ea4a
c0101ae6:	08 00 
c0101ae8:	0f b6 05 4c ea 11 c0 	movzbl 0xc011ea4c,%eax
c0101aef:	24 e0                	and    $0xe0,%al
c0101af1:	a2 4c ea 11 c0       	mov    %al,0xc011ea4c
c0101af6:	0f b6 05 4c ea 11 c0 	movzbl 0xc011ea4c,%eax
c0101afd:	24 1f                	and    $0x1f,%al
c0101aff:	a2 4c ea 11 c0       	mov    %al,0xc011ea4c
c0101b04:	0f b6 05 4d ea 11 c0 	movzbl 0xc011ea4d,%eax
c0101b0b:	24 f0                	and    $0xf0,%al
c0101b0d:	0c 0e                	or     $0xe,%al
c0101b0f:	a2 4d ea 11 c0       	mov    %al,0xc011ea4d
c0101b14:	0f b6 05 4d ea 11 c0 	movzbl 0xc011ea4d,%eax
c0101b1b:	24 ef                	and    $0xef,%al
c0101b1d:	a2 4d ea 11 c0       	mov    %al,0xc011ea4d
c0101b22:	0f b6 05 4d ea 11 c0 	movzbl 0xc011ea4d,%eax
c0101b29:	0c 60                	or     $0x60,%al
c0101b2b:	a2 4d ea 11 c0       	mov    %al,0xc011ea4d
c0101b30:	0f b6 05 4d ea 11 c0 	movzbl 0xc011ea4d,%eax
c0101b37:	0c 80                	or     $0x80,%al
c0101b39:	a2 4d ea 11 c0       	mov    %al,0xc011ea4d
c0101b3e:	a1 c4 b7 11 c0       	mov    0xc011b7c4,%eax
c0101b43:	c1 e8 10             	shr    $0x10,%eax
c0101b46:	0f b7 c0             	movzwl %ax,%eax
c0101b49:	66 a3 4e ea 11 c0    	mov    %ax,0xc011ea4e
c0101b4f:	c7 45 f4 60 b5 11 c0 	movl   $0xc011b560,-0xc(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b59:	0f 01 18             	lidtl  (%eax)
}
c0101b5c:	90                   	nop
    // load the IDT
    lidt(&idt_pd);
}
c0101b5d:	90                   	nop
c0101b5e:	89 ec                	mov    %ebp,%esp
c0101b60:	5d                   	pop    %ebp
c0101b61:	c3                   	ret    

c0101b62 <trapname>:

static const char *
trapname(int trapno) {
c0101b62:	55                   	push   %ebp
c0101b63:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101b65:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b68:	83 f8 13             	cmp    $0x13,%eax
c0101b6b:	77 0c                	ja     c0101b79 <trapname+0x17>
        return excnames[trapno];
c0101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b70:	8b 04 85 60 74 10 c0 	mov    -0x3fef8ba0(,%eax,4),%eax
c0101b77:	eb 18                	jmp    c0101b91 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101b79:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101b7d:	7e 0d                	jle    c0101b8c <trapname+0x2a>
c0101b7f:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101b83:	7f 07                	jg     c0101b8c <trapname+0x2a>
        return "Hardware Interrupt";
c0101b85:	b8 1f 71 10 c0       	mov    $0xc010711f,%eax
c0101b8a:	eb 05                	jmp    c0101b91 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101b8c:	b8 32 71 10 c0       	mov    $0xc0107132,%eax
}
c0101b91:	5d                   	pop    %ebp
c0101b92:	c3                   	ret    

c0101b93 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101b93:	55                   	push   %ebp
c0101b94:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101b96:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b99:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b9d:	83 f8 08             	cmp    $0x8,%eax
c0101ba0:	0f 94 c0             	sete   %al
c0101ba3:	0f b6 c0             	movzbl %al,%eax
}
c0101ba6:	5d                   	pop    %ebp
c0101ba7:	c3                   	ret    

c0101ba8 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101ba8:	55                   	push   %ebp
c0101ba9:	89 e5                	mov    %esp,%ebp
c0101bab:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101bae:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bb5:	c7 04 24 73 71 10 c0 	movl   $0xc0107173,(%esp)
c0101bbc:	e8 a0 e7 ff ff       	call   c0100361 <cprintf>
    print_regs(&tf->tf_regs);
c0101bc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc4:	89 04 24             	mov    %eax,(%esp)
c0101bc7:	e8 8f 01 00 00       	call   c0101d5b <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101bcc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bcf:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101bd3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bd7:	c7 04 24 84 71 10 c0 	movl   $0xc0107184,(%esp)
c0101bde:	e8 7e e7 ff ff       	call   c0100361 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101be3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be6:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101bea:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bee:	c7 04 24 97 71 10 c0 	movl   $0xc0107197,(%esp)
c0101bf5:	e8 67 e7 ff ff       	call   c0100361 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101bfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfd:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101c01:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c05:	c7 04 24 aa 71 10 c0 	movl   $0xc01071aa,(%esp)
c0101c0c:	e8 50 e7 ff ff       	call   c0100361 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101c11:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c14:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101c18:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c1c:	c7 04 24 bd 71 10 c0 	movl   $0xc01071bd,(%esp)
c0101c23:	e8 39 e7 ff ff       	call   c0100361 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101c28:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2b:	8b 40 30             	mov    0x30(%eax),%eax
c0101c2e:	89 04 24             	mov    %eax,(%esp)
c0101c31:	e8 2c ff ff ff       	call   c0101b62 <trapname>
c0101c36:	8b 55 08             	mov    0x8(%ebp),%edx
c0101c39:	8b 52 30             	mov    0x30(%edx),%edx
c0101c3c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101c40:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101c44:	c7 04 24 d0 71 10 c0 	movl   $0xc01071d0,(%esp)
c0101c4b:	e8 11 e7 ff ff       	call   c0100361 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101c50:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c53:	8b 40 34             	mov    0x34(%eax),%eax
c0101c56:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c5a:	c7 04 24 e2 71 10 c0 	movl   $0xc01071e2,(%esp)
c0101c61:	e8 fb e6 ff ff       	call   c0100361 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101c66:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c69:	8b 40 38             	mov    0x38(%eax),%eax
c0101c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c70:	c7 04 24 f1 71 10 c0 	movl   $0xc01071f1,(%esp)
c0101c77:	e8 e5 e6 ff ff       	call   c0100361 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101c7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101c83:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c87:	c7 04 24 00 72 10 c0 	movl   $0xc0107200,(%esp)
c0101c8e:	e8 ce e6 ff ff       	call   c0100361 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101c93:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c96:	8b 40 40             	mov    0x40(%eax),%eax
c0101c99:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c9d:	c7 04 24 13 72 10 c0 	movl   $0xc0107213,(%esp)
c0101ca4:	e8 b8 e6 ff ff       	call   c0100361 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101ca9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101cb0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101cb7:	eb 3d                	jmp    c0101cf6 <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101cb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbc:	8b 50 40             	mov    0x40(%eax),%edx
c0101cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101cc2:	21 d0                	and    %edx,%eax
c0101cc4:	85 c0                	test   %eax,%eax
c0101cc6:	74 28                	je     c0101cf0 <print_trapframe+0x148>
c0101cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ccb:	8b 04 85 80 b5 11 c0 	mov    -0x3fee4a80(,%eax,4),%eax
c0101cd2:	85 c0                	test   %eax,%eax
c0101cd4:	74 1a                	je     c0101cf0 <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
c0101cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101cd9:	8b 04 85 80 b5 11 c0 	mov    -0x3fee4a80(,%eax,4),%eax
c0101ce0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ce4:	c7 04 24 22 72 10 c0 	movl   $0xc0107222,(%esp)
c0101ceb:	e8 71 e6 ff ff       	call   c0100361 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101cf0:	ff 45 f4             	incl   -0xc(%ebp)
c0101cf3:	d1 65 f0             	shll   -0x10(%ebp)
c0101cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101cf9:	83 f8 17             	cmp    $0x17,%eax
c0101cfc:	76 bb                	jbe    c0101cb9 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101cfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d01:	8b 40 40             	mov    0x40(%eax),%eax
c0101d04:	c1 e8 0c             	shr    $0xc,%eax
c0101d07:	83 e0 03             	and    $0x3,%eax
c0101d0a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d0e:	c7 04 24 26 72 10 c0 	movl   $0xc0107226,(%esp)
c0101d15:	e8 47 e6 ff ff       	call   c0100361 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101d1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d1d:	89 04 24             	mov    %eax,(%esp)
c0101d20:	e8 6e fe ff ff       	call   c0101b93 <trap_in_kernel>
c0101d25:	85 c0                	test   %eax,%eax
c0101d27:	75 2d                	jne    c0101d56 <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101d29:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d2c:	8b 40 44             	mov    0x44(%eax),%eax
c0101d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d33:	c7 04 24 2f 72 10 c0 	movl   $0xc010722f,(%esp)
c0101d3a:	e8 22 e6 ff ff       	call   c0100361 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101d3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d42:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101d46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d4a:	c7 04 24 3e 72 10 c0 	movl   $0xc010723e,(%esp)
c0101d51:	e8 0b e6 ff ff       	call   c0100361 <cprintf>
    }
}
c0101d56:	90                   	nop
c0101d57:	89 ec                	mov    %ebp,%esp
c0101d59:	5d                   	pop    %ebp
c0101d5a:	c3                   	ret    

c0101d5b <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101d5b:	55                   	push   %ebp
c0101d5c:	89 e5                	mov    %esp,%ebp
c0101d5e:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101d61:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d64:	8b 00                	mov    (%eax),%eax
c0101d66:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d6a:	c7 04 24 51 72 10 c0 	movl   $0xc0107251,(%esp)
c0101d71:	e8 eb e5 ff ff       	call   c0100361 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101d76:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d79:	8b 40 04             	mov    0x4(%eax),%eax
c0101d7c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d80:	c7 04 24 60 72 10 c0 	movl   $0xc0107260,(%esp)
c0101d87:	e8 d5 e5 ff ff       	call   c0100361 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101d8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d8f:	8b 40 08             	mov    0x8(%eax),%eax
c0101d92:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d96:	c7 04 24 6f 72 10 c0 	movl   $0xc010726f,(%esp)
c0101d9d:	e8 bf e5 ff ff       	call   c0100361 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101da2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101da5:	8b 40 0c             	mov    0xc(%eax),%eax
c0101da8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dac:	c7 04 24 7e 72 10 c0 	movl   $0xc010727e,(%esp)
c0101db3:	e8 a9 e5 ff ff       	call   c0100361 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101db8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dbb:	8b 40 10             	mov    0x10(%eax),%eax
c0101dbe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dc2:	c7 04 24 8d 72 10 c0 	movl   $0xc010728d,(%esp)
c0101dc9:	e8 93 e5 ff ff       	call   c0100361 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101dce:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dd1:	8b 40 14             	mov    0x14(%eax),%eax
c0101dd4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dd8:	c7 04 24 9c 72 10 c0 	movl   $0xc010729c,(%esp)
c0101ddf:	e8 7d e5 ff ff       	call   c0100361 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101de4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101de7:	8b 40 18             	mov    0x18(%eax),%eax
c0101dea:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dee:	c7 04 24 ab 72 10 c0 	movl   $0xc01072ab,(%esp)
c0101df5:	e8 67 e5 ff ff       	call   c0100361 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101dfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dfd:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101e00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e04:	c7 04 24 ba 72 10 c0 	movl   $0xc01072ba,(%esp)
c0101e0b:	e8 51 e5 ff ff       	call   c0100361 <cprintf>
}
c0101e10:	90                   	nop
c0101e11:	89 ec                	mov    %ebp,%esp
c0101e13:	5d                   	pop    %ebp
c0101e14:	c3                   	ret    

c0101e15 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101e15:	55                   	push   %ebp
c0101e16:	89 e5                	mov    %esp,%ebp
c0101e18:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101e1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e1e:	8b 40 30             	mov    0x30(%eax),%eax
c0101e21:	83 f8 79             	cmp    $0x79,%eax
c0101e24:	0f 84 54 01 00 00    	je     c0101f7e <trap_dispatch+0x169>
c0101e2a:	83 f8 79             	cmp    $0x79,%eax
c0101e2d:	0f 87 ba 01 00 00    	ja     c0101fed <trap_dispatch+0x1d8>
c0101e33:	83 f8 78             	cmp    $0x78,%eax
c0101e36:	0f 84 d0 00 00 00    	je     c0101f0c <trap_dispatch+0xf7>
c0101e3c:	83 f8 78             	cmp    $0x78,%eax
c0101e3f:	0f 87 a8 01 00 00    	ja     c0101fed <trap_dispatch+0x1d8>
c0101e45:	83 f8 2f             	cmp    $0x2f,%eax
c0101e48:	0f 87 9f 01 00 00    	ja     c0101fed <trap_dispatch+0x1d8>
c0101e4e:	83 f8 2e             	cmp    $0x2e,%eax
c0101e51:	0f 83 cb 01 00 00    	jae    c0102022 <trap_dispatch+0x20d>
c0101e57:	83 f8 24             	cmp    $0x24,%eax
c0101e5a:	74 5e                	je     c0101eba <trap_dispatch+0xa5>
c0101e5c:	83 f8 24             	cmp    $0x24,%eax
c0101e5f:	0f 87 88 01 00 00    	ja     c0101fed <trap_dispatch+0x1d8>
c0101e65:	83 f8 20             	cmp    $0x20,%eax
c0101e68:	74 0a                	je     c0101e74 <trap_dispatch+0x5f>
c0101e6a:	83 f8 21             	cmp    $0x21,%eax
c0101e6d:	74 74                	je     c0101ee3 <trap_dispatch+0xce>
c0101e6f:	e9 79 01 00 00       	jmp    c0101fed <trap_dispatch+0x1d8>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
c0101e74:	a1 24 e4 11 c0       	mov    0xc011e424,%eax
c0101e79:	40                   	inc    %eax
c0101e7a:	a3 24 e4 11 c0       	mov    %eax,0xc011e424
        if(ticks%TICK_NUM==0){
c0101e7f:	8b 0d 24 e4 11 c0    	mov    0xc011e424,%ecx
c0101e85:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101e8a:	89 c8                	mov    %ecx,%eax
c0101e8c:	f7 e2                	mul    %edx
c0101e8e:	c1 ea 05             	shr    $0x5,%edx
c0101e91:	89 d0                	mov    %edx,%eax
c0101e93:	c1 e0 02             	shl    $0x2,%eax
c0101e96:	01 d0                	add    %edx,%eax
c0101e98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101e9f:	01 d0                	add    %edx,%eax
c0101ea1:	c1 e0 02             	shl    $0x2,%eax
c0101ea4:	29 c1                	sub    %eax,%ecx
c0101ea6:	89 ca                	mov    %ecx,%edx
c0101ea8:	85 d2                	test   %edx,%edx
c0101eaa:	0f 85 75 01 00 00    	jne    c0102025 <trap_dispatch+0x210>
            //print ticks info
            print_ticks();
c0101eb0:	e8 75 fa ff ff       	call   c010192a <print_ticks>
        }
        break;
c0101eb5:	e9 6b 01 00 00       	jmp    c0102025 <trap_dispatch+0x210>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101eba:	e8 0e f8 ff ff       	call   c01016cd <cons_getc>
c0101ebf:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101ec2:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101ec6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101eca:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101ece:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ed2:	c7 04 24 c9 72 10 c0 	movl   $0xc01072c9,(%esp)
c0101ed9:	e8 83 e4 ff ff       	call   c0100361 <cprintf>
        break;
c0101ede:	e9 49 01 00 00       	jmp    c010202c <trap_dispatch+0x217>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101ee3:	e8 e5 f7 ff ff       	call   c01016cd <cons_getc>
c0101ee8:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101eeb:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101eef:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101ef3:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101efb:	c7 04 24 db 72 10 c0 	movl   $0xc01072db,(%esp)
c0101f02:	e8 5a e4 ff ff       	call   c0100361 <cprintf>
        break;
c0101f07:	e9 20 01 00 00       	jmp    c010202c <trap_dispatch+0x217>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
c0101f0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f0f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f13:	83 f8 1b             	cmp    $0x1b,%eax
c0101f16:	0f 84 0c 01 00 00    	je     c0102028 <trap_dispatch+0x213>
            //为了使得程序在低CPL的情况下仍然能够使用IO，需要将eflags中对应的IOPL位置成表示用户态的
            //if CPL > IOPL, then cpu will generate a general protection.
            tf->tf_eflags |= FL_IOPL_MASK;
c0101f1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f1f:	8b 40 40             	mov    0x40(%eax),%eax
c0101f22:	0d 00 30 00 00       	or     $0x3000,%eax
c0101f27:	89 c2                	mov    %eax,%edx
c0101f29:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f2c:	89 50 40             	mov    %edx,0x40(%eax)
            //iret认定在发生中断的时候是否发生了PL的切换，是取决于CPL和最终跳转回的地址的cs选择子对应的段描述符处的CPL（也就是发生中断前的CPL）是否相等来决定的
            //因此将保存在trapframe中的原先的cs修改成指向用户态描述子的USER_CS
            tf->tf_cs = USER_CS;
c0101f2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f32:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            //为了使得中断返回之后能够正常访问数据，将其他的段选择子都修改为USER_DS
            tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = USER_DS;
c0101f38:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f3b:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
c0101f41:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f44:	0f b7 50 24          	movzwl 0x24(%eax),%edx
c0101f48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f4b:	66 89 50 48          	mov    %dx,0x48(%eax)
c0101f4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f52:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101f56:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f59:	66 89 50 20          	mov    %dx,0x20(%eax)
c0101f5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f60:	0f b7 50 20          	movzwl 0x20(%eax),%edx
c0101f64:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f67:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101f6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f6e:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101f72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f75:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        }
        break;
c0101f79:	e9 aa 00 00 00       	jmp    c0102028 <trap_dispatch+0x213>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
c0101f7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f81:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f85:	83 f8 08             	cmp    $0x8,%eax
c0101f88:	0f 84 9d 00 00 00    	je     c010202b <trap_dispatch+0x216>
            tf->tf_eflags &= ~FL_IOPL_MASK;
c0101f8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f91:	8b 40 40             	mov    0x40(%eax),%eax
c0101f94:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c0101f99:	89 c2                	mov    %eax,%edx
c0101f9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f9e:	89 50 40             	mov    %edx,0x40(%eax)
            tf->tf_cs = KERNEL_CS;
c0101fa1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fa4:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = KERNEL_DS;
c0101faa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fad:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
c0101fb3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fb6:	0f b7 50 24          	movzwl 0x24(%eax),%edx
c0101fba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fbd:	66 89 50 48          	mov    %dx,0x48(%eax)
c0101fc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fc4:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0101fc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fcb:	66 89 50 20          	mov    %dx,0x20(%eax)
c0101fcf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fd2:	0f b7 50 20          	movzwl 0x20(%eax),%edx
c0101fd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fd9:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101fdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fe0:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101fe4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fe7:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        }
        //panic("T_SWITCH_** ??\n");
        break;
c0101feb:	eb 3e                	jmp    c010202b <trap_dispatch+0x216>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101fed:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ff0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ff4:	83 e0 03             	and    $0x3,%eax
c0101ff7:	85 c0                	test   %eax,%eax
c0101ff9:	75 31                	jne    c010202c <trap_dispatch+0x217>
            print_trapframe(tf);
c0101ffb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ffe:	89 04 24             	mov    %eax,(%esp)
c0102001:	e8 a2 fb ff ff       	call   c0101ba8 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0102006:	c7 44 24 08 ea 72 10 	movl   $0xc01072ea,0x8(%esp)
c010200d:	c0 
c010200e:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0102015:	00 
c0102016:	c7 04 24 0e 71 10 c0 	movl   $0xc010710e,(%esp)
c010201d:	e8 cb ec ff ff       	call   c0100ced <__panic>
        break;
c0102022:	90                   	nop
c0102023:	eb 07                	jmp    c010202c <trap_dispatch+0x217>
        break;
c0102025:	90                   	nop
c0102026:	eb 04                	jmp    c010202c <trap_dispatch+0x217>
        break;
c0102028:	90                   	nop
c0102029:	eb 01                	jmp    c010202c <trap_dispatch+0x217>
        break;
c010202b:	90                   	nop
        }
    }
}
c010202c:	90                   	nop
c010202d:	89 ec                	mov    %ebp,%esp
c010202f:	5d                   	pop    %ebp
c0102030:	c3                   	ret    

c0102031 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102031:	55                   	push   %ebp
c0102032:	89 e5                	mov    %esp,%ebp
c0102034:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0102037:	8b 45 08             	mov    0x8(%ebp),%eax
c010203a:	89 04 24             	mov    %eax,(%esp)
c010203d:	e8 d3 fd ff ff       	call   c0101e15 <trap_dispatch>
}
c0102042:	90                   	nop
c0102043:	89 ec                	mov    %ebp,%esp
c0102045:	5d                   	pop    %ebp
c0102046:	c3                   	ret    

c0102047 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102047:	1e                   	push   %ds
    pushl %es
c0102048:	06                   	push   %es
    pushl %fs
c0102049:	0f a0                	push   %fs
    pushl %gs
c010204b:	0f a8                	push   %gs
    pushal
c010204d:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c010204e:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102053:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102055:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102057:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102058:	e8 d4 ff ff ff       	call   c0102031 <trap>

    # pop the pushed stack pointer
    popl %esp
c010205d:	5c                   	pop    %esp

c010205e <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c010205e:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c010205f:	0f a9                	pop    %gs
    popl %fs
c0102061:	0f a1                	pop    %fs
    popl %es
c0102063:	07                   	pop    %es
    popl %ds
c0102064:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102065:	83 c4 08             	add    $0x8,%esp
    iret
c0102068:	cf                   	iret   

c0102069 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102069:	6a 00                	push   $0x0
  pushl $0
c010206b:	6a 00                	push   $0x0
  jmp __alltraps
c010206d:	e9 d5 ff ff ff       	jmp    c0102047 <__alltraps>

c0102072 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102072:	6a 00                	push   $0x0
  pushl $1
c0102074:	6a 01                	push   $0x1
  jmp __alltraps
c0102076:	e9 cc ff ff ff       	jmp    c0102047 <__alltraps>

c010207b <vector2>:
.globl vector2
vector2:
  pushl $0
c010207b:	6a 00                	push   $0x0
  pushl $2
c010207d:	6a 02                	push   $0x2
  jmp __alltraps
c010207f:	e9 c3 ff ff ff       	jmp    c0102047 <__alltraps>

c0102084 <vector3>:
.globl vector3
vector3:
  pushl $0
c0102084:	6a 00                	push   $0x0
  pushl $3
c0102086:	6a 03                	push   $0x3
  jmp __alltraps
c0102088:	e9 ba ff ff ff       	jmp    c0102047 <__alltraps>

c010208d <vector4>:
.globl vector4
vector4:
  pushl $0
c010208d:	6a 00                	push   $0x0
  pushl $4
c010208f:	6a 04                	push   $0x4
  jmp __alltraps
c0102091:	e9 b1 ff ff ff       	jmp    c0102047 <__alltraps>

c0102096 <vector5>:
.globl vector5
vector5:
  pushl $0
c0102096:	6a 00                	push   $0x0
  pushl $5
c0102098:	6a 05                	push   $0x5
  jmp __alltraps
c010209a:	e9 a8 ff ff ff       	jmp    c0102047 <__alltraps>

c010209f <vector6>:
.globl vector6
vector6:
  pushl $0
c010209f:	6a 00                	push   $0x0
  pushl $6
c01020a1:	6a 06                	push   $0x6
  jmp __alltraps
c01020a3:	e9 9f ff ff ff       	jmp    c0102047 <__alltraps>

c01020a8 <vector7>:
.globl vector7
vector7:
  pushl $0
c01020a8:	6a 00                	push   $0x0
  pushl $7
c01020aa:	6a 07                	push   $0x7
  jmp __alltraps
c01020ac:	e9 96 ff ff ff       	jmp    c0102047 <__alltraps>

c01020b1 <vector8>:
.globl vector8
vector8:
  pushl $8
c01020b1:	6a 08                	push   $0x8
  jmp __alltraps
c01020b3:	e9 8f ff ff ff       	jmp    c0102047 <__alltraps>

c01020b8 <vector9>:
.globl vector9
vector9:
  pushl $0
c01020b8:	6a 00                	push   $0x0
  pushl $9
c01020ba:	6a 09                	push   $0x9
  jmp __alltraps
c01020bc:	e9 86 ff ff ff       	jmp    c0102047 <__alltraps>

c01020c1 <vector10>:
.globl vector10
vector10:
  pushl $10
c01020c1:	6a 0a                	push   $0xa
  jmp __alltraps
c01020c3:	e9 7f ff ff ff       	jmp    c0102047 <__alltraps>

c01020c8 <vector11>:
.globl vector11
vector11:
  pushl $11
c01020c8:	6a 0b                	push   $0xb
  jmp __alltraps
c01020ca:	e9 78 ff ff ff       	jmp    c0102047 <__alltraps>

c01020cf <vector12>:
.globl vector12
vector12:
  pushl $12
c01020cf:	6a 0c                	push   $0xc
  jmp __alltraps
c01020d1:	e9 71 ff ff ff       	jmp    c0102047 <__alltraps>

c01020d6 <vector13>:
.globl vector13
vector13:
  pushl $13
c01020d6:	6a 0d                	push   $0xd
  jmp __alltraps
c01020d8:	e9 6a ff ff ff       	jmp    c0102047 <__alltraps>

c01020dd <vector14>:
.globl vector14
vector14:
  pushl $14
c01020dd:	6a 0e                	push   $0xe
  jmp __alltraps
c01020df:	e9 63 ff ff ff       	jmp    c0102047 <__alltraps>

c01020e4 <vector15>:
.globl vector15
vector15:
  pushl $0
c01020e4:	6a 00                	push   $0x0
  pushl $15
c01020e6:	6a 0f                	push   $0xf
  jmp __alltraps
c01020e8:	e9 5a ff ff ff       	jmp    c0102047 <__alltraps>

c01020ed <vector16>:
.globl vector16
vector16:
  pushl $0
c01020ed:	6a 00                	push   $0x0
  pushl $16
c01020ef:	6a 10                	push   $0x10
  jmp __alltraps
c01020f1:	e9 51 ff ff ff       	jmp    c0102047 <__alltraps>

c01020f6 <vector17>:
.globl vector17
vector17:
  pushl $17
c01020f6:	6a 11                	push   $0x11
  jmp __alltraps
c01020f8:	e9 4a ff ff ff       	jmp    c0102047 <__alltraps>

c01020fd <vector18>:
.globl vector18
vector18:
  pushl $0
c01020fd:	6a 00                	push   $0x0
  pushl $18
c01020ff:	6a 12                	push   $0x12
  jmp __alltraps
c0102101:	e9 41 ff ff ff       	jmp    c0102047 <__alltraps>

c0102106 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102106:	6a 00                	push   $0x0
  pushl $19
c0102108:	6a 13                	push   $0x13
  jmp __alltraps
c010210a:	e9 38 ff ff ff       	jmp    c0102047 <__alltraps>

c010210f <vector20>:
.globl vector20
vector20:
  pushl $0
c010210f:	6a 00                	push   $0x0
  pushl $20
c0102111:	6a 14                	push   $0x14
  jmp __alltraps
c0102113:	e9 2f ff ff ff       	jmp    c0102047 <__alltraps>

c0102118 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102118:	6a 00                	push   $0x0
  pushl $21
c010211a:	6a 15                	push   $0x15
  jmp __alltraps
c010211c:	e9 26 ff ff ff       	jmp    c0102047 <__alltraps>

c0102121 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102121:	6a 00                	push   $0x0
  pushl $22
c0102123:	6a 16                	push   $0x16
  jmp __alltraps
c0102125:	e9 1d ff ff ff       	jmp    c0102047 <__alltraps>

c010212a <vector23>:
.globl vector23
vector23:
  pushl $0
c010212a:	6a 00                	push   $0x0
  pushl $23
c010212c:	6a 17                	push   $0x17
  jmp __alltraps
c010212e:	e9 14 ff ff ff       	jmp    c0102047 <__alltraps>

c0102133 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102133:	6a 00                	push   $0x0
  pushl $24
c0102135:	6a 18                	push   $0x18
  jmp __alltraps
c0102137:	e9 0b ff ff ff       	jmp    c0102047 <__alltraps>

c010213c <vector25>:
.globl vector25
vector25:
  pushl $0
c010213c:	6a 00                	push   $0x0
  pushl $25
c010213e:	6a 19                	push   $0x19
  jmp __alltraps
c0102140:	e9 02 ff ff ff       	jmp    c0102047 <__alltraps>

c0102145 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102145:	6a 00                	push   $0x0
  pushl $26
c0102147:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102149:	e9 f9 fe ff ff       	jmp    c0102047 <__alltraps>

c010214e <vector27>:
.globl vector27
vector27:
  pushl $0
c010214e:	6a 00                	push   $0x0
  pushl $27
c0102150:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102152:	e9 f0 fe ff ff       	jmp    c0102047 <__alltraps>

c0102157 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102157:	6a 00                	push   $0x0
  pushl $28
c0102159:	6a 1c                	push   $0x1c
  jmp __alltraps
c010215b:	e9 e7 fe ff ff       	jmp    c0102047 <__alltraps>

c0102160 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102160:	6a 00                	push   $0x0
  pushl $29
c0102162:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102164:	e9 de fe ff ff       	jmp    c0102047 <__alltraps>

c0102169 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102169:	6a 00                	push   $0x0
  pushl $30
c010216b:	6a 1e                	push   $0x1e
  jmp __alltraps
c010216d:	e9 d5 fe ff ff       	jmp    c0102047 <__alltraps>

c0102172 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102172:	6a 00                	push   $0x0
  pushl $31
c0102174:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102176:	e9 cc fe ff ff       	jmp    c0102047 <__alltraps>

c010217b <vector32>:
.globl vector32
vector32:
  pushl $0
c010217b:	6a 00                	push   $0x0
  pushl $32
c010217d:	6a 20                	push   $0x20
  jmp __alltraps
c010217f:	e9 c3 fe ff ff       	jmp    c0102047 <__alltraps>

c0102184 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102184:	6a 00                	push   $0x0
  pushl $33
c0102186:	6a 21                	push   $0x21
  jmp __alltraps
c0102188:	e9 ba fe ff ff       	jmp    c0102047 <__alltraps>

c010218d <vector34>:
.globl vector34
vector34:
  pushl $0
c010218d:	6a 00                	push   $0x0
  pushl $34
c010218f:	6a 22                	push   $0x22
  jmp __alltraps
c0102191:	e9 b1 fe ff ff       	jmp    c0102047 <__alltraps>

c0102196 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102196:	6a 00                	push   $0x0
  pushl $35
c0102198:	6a 23                	push   $0x23
  jmp __alltraps
c010219a:	e9 a8 fe ff ff       	jmp    c0102047 <__alltraps>

c010219f <vector36>:
.globl vector36
vector36:
  pushl $0
c010219f:	6a 00                	push   $0x0
  pushl $36
c01021a1:	6a 24                	push   $0x24
  jmp __alltraps
c01021a3:	e9 9f fe ff ff       	jmp    c0102047 <__alltraps>

c01021a8 <vector37>:
.globl vector37
vector37:
  pushl $0
c01021a8:	6a 00                	push   $0x0
  pushl $37
c01021aa:	6a 25                	push   $0x25
  jmp __alltraps
c01021ac:	e9 96 fe ff ff       	jmp    c0102047 <__alltraps>

c01021b1 <vector38>:
.globl vector38
vector38:
  pushl $0
c01021b1:	6a 00                	push   $0x0
  pushl $38
c01021b3:	6a 26                	push   $0x26
  jmp __alltraps
c01021b5:	e9 8d fe ff ff       	jmp    c0102047 <__alltraps>

c01021ba <vector39>:
.globl vector39
vector39:
  pushl $0
c01021ba:	6a 00                	push   $0x0
  pushl $39
c01021bc:	6a 27                	push   $0x27
  jmp __alltraps
c01021be:	e9 84 fe ff ff       	jmp    c0102047 <__alltraps>

c01021c3 <vector40>:
.globl vector40
vector40:
  pushl $0
c01021c3:	6a 00                	push   $0x0
  pushl $40
c01021c5:	6a 28                	push   $0x28
  jmp __alltraps
c01021c7:	e9 7b fe ff ff       	jmp    c0102047 <__alltraps>

c01021cc <vector41>:
.globl vector41
vector41:
  pushl $0
c01021cc:	6a 00                	push   $0x0
  pushl $41
c01021ce:	6a 29                	push   $0x29
  jmp __alltraps
c01021d0:	e9 72 fe ff ff       	jmp    c0102047 <__alltraps>

c01021d5 <vector42>:
.globl vector42
vector42:
  pushl $0
c01021d5:	6a 00                	push   $0x0
  pushl $42
c01021d7:	6a 2a                	push   $0x2a
  jmp __alltraps
c01021d9:	e9 69 fe ff ff       	jmp    c0102047 <__alltraps>

c01021de <vector43>:
.globl vector43
vector43:
  pushl $0
c01021de:	6a 00                	push   $0x0
  pushl $43
c01021e0:	6a 2b                	push   $0x2b
  jmp __alltraps
c01021e2:	e9 60 fe ff ff       	jmp    c0102047 <__alltraps>

c01021e7 <vector44>:
.globl vector44
vector44:
  pushl $0
c01021e7:	6a 00                	push   $0x0
  pushl $44
c01021e9:	6a 2c                	push   $0x2c
  jmp __alltraps
c01021eb:	e9 57 fe ff ff       	jmp    c0102047 <__alltraps>

c01021f0 <vector45>:
.globl vector45
vector45:
  pushl $0
c01021f0:	6a 00                	push   $0x0
  pushl $45
c01021f2:	6a 2d                	push   $0x2d
  jmp __alltraps
c01021f4:	e9 4e fe ff ff       	jmp    c0102047 <__alltraps>

c01021f9 <vector46>:
.globl vector46
vector46:
  pushl $0
c01021f9:	6a 00                	push   $0x0
  pushl $46
c01021fb:	6a 2e                	push   $0x2e
  jmp __alltraps
c01021fd:	e9 45 fe ff ff       	jmp    c0102047 <__alltraps>

c0102202 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102202:	6a 00                	push   $0x0
  pushl $47
c0102204:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102206:	e9 3c fe ff ff       	jmp    c0102047 <__alltraps>

c010220b <vector48>:
.globl vector48
vector48:
  pushl $0
c010220b:	6a 00                	push   $0x0
  pushl $48
c010220d:	6a 30                	push   $0x30
  jmp __alltraps
c010220f:	e9 33 fe ff ff       	jmp    c0102047 <__alltraps>

c0102214 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102214:	6a 00                	push   $0x0
  pushl $49
c0102216:	6a 31                	push   $0x31
  jmp __alltraps
c0102218:	e9 2a fe ff ff       	jmp    c0102047 <__alltraps>

c010221d <vector50>:
.globl vector50
vector50:
  pushl $0
c010221d:	6a 00                	push   $0x0
  pushl $50
c010221f:	6a 32                	push   $0x32
  jmp __alltraps
c0102221:	e9 21 fe ff ff       	jmp    c0102047 <__alltraps>

c0102226 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102226:	6a 00                	push   $0x0
  pushl $51
c0102228:	6a 33                	push   $0x33
  jmp __alltraps
c010222a:	e9 18 fe ff ff       	jmp    c0102047 <__alltraps>

c010222f <vector52>:
.globl vector52
vector52:
  pushl $0
c010222f:	6a 00                	push   $0x0
  pushl $52
c0102231:	6a 34                	push   $0x34
  jmp __alltraps
c0102233:	e9 0f fe ff ff       	jmp    c0102047 <__alltraps>

c0102238 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102238:	6a 00                	push   $0x0
  pushl $53
c010223a:	6a 35                	push   $0x35
  jmp __alltraps
c010223c:	e9 06 fe ff ff       	jmp    c0102047 <__alltraps>

c0102241 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102241:	6a 00                	push   $0x0
  pushl $54
c0102243:	6a 36                	push   $0x36
  jmp __alltraps
c0102245:	e9 fd fd ff ff       	jmp    c0102047 <__alltraps>

c010224a <vector55>:
.globl vector55
vector55:
  pushl $0
c010224a:	6a 00                	push   $0x0
  pushl $55
c010224c:	6a 37                	push   $0x37
  jmp __alltraps
c010224e:	e9 f4 fd ff ff       	jmp    c0102047 <__alltraps>

c0102253 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102253:	6a 00                	push   $0x0
  pushl $56
c0102255:	6a 38                	push   $0x38
  jmp __alltraps
c0102257:	e9 eb fd ff ff       	jmp    c0102047 <__alltraps>

c010225c <vector57>:
.globl vector57
vector57:
  pushl $0
c010225c:	6a 00                	push   $0x0
  pushl $57
c010225e:	6a 39                	push   $0x39
  jmp __alltraps
c0102260:	e9 e2 fd ff ff       	jmp    c0102047 <__alltraps>

c0102265 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102265:	6a 00                	push   $0x0
  pushl $58
c0102267:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102269:	e9 d9 fd ff ff       	jmp    c0102047 <__alltraps>

c010226e <vector59>:
.globl vector59
vector59:
  pushl $0
c010226e:	6a 00                	push   $0x0
  pushl $59
c0102270:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102272:	e9 d0 fd ff ff       	jmp    c0102047 <__alltraps>

c0102277 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102277:	6a 00                	push   $0x0
  pushl $60
c0102279:	6a 3c                	push   $0x3c
  jmp __alltraps
c010227b:	e9 c7 fd ff ff       	jmp    c0102047 <__alltraps>

c0102280 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102280:	6a 00                	push   $0x0
  pushl $61
c0102282:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102284:	e9 be fd ff ff       	jmp    c0102047 <__alltraps>

c0102289 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102289:	6a 00                	push   $0x0
  pushl $62
c010228b:	6a 3e                	push   $0x3e
  jmp __alltraps
c010228d:	e9 b5 fd ff ff       	jmp    c0102047 <__alltraps>

c0102292 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102292:	6a 00                	push   $0x0
  pushl $63
c0102294:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102296:	e9 ac fd ff ff       	jmp    c0102047 <__alltraps>

c010229b <vector64>:
.globl vector64
vector64:
  pushl $0
c010229b:	6a 00                	push   $0x0
  pushl $64
c010229d:	6a 40                	push   $0x40
  jmp __alltraps
c010229f:	e9 a3 fd ff ff       	jmp    c0102047 <__alltraps>

c01022a4 <vector65>:
.globl vector65
vector65:
  pushl $0
c01022a4:	6a 00                	push   $0x0
  pushl $65
c01022a6:	6a 41                	push   $0x41
  jmp __alltraps
c01022a8:	e9 9a fd ff ff       	jmp    c0102047 <__alltraps>

c01022ad <vector66>:
.globl vector66
vector66:
  pushl $0
c01022ad:	6a 00                	push   $0x0
  pushl $66
c01022af:	6a 42                	push   $0x42
  jmp __alltraps
c01022b1:	e9 91 fd ff ff       	jmp    c0102047 <__alltraps>

c01022b6 <vector67>:
.globl vector67
vector67:
  pushl $0
c01022b6:	6a 00                	push   $0x0
  pushl $67
c01022b8:	6a 43                	push   $0x43
  jmp __alltraps
c01022ba:	e9 88 fd ff ff       	jmp    c0102047 <__alltraps>

c01022bf <vector68>:
.globl vector68
vector68:
  pushl $0
c01022bf:	6a 00                	push   $0x0
  pushl $68
c01022c1:	6a 44                	push   $0x44
  jmp __alltraps
c01022c3:	e9 7f fd ff ff       	jmp    c0102047 <__alltraps>

c01022c8 <vector69>:
.globl vector69
vector69:
  pushl $0
c01022c8:	6a 00                	push   $0x0
  pushl $69
c01022ca:	6a 45                	push   $0x45
  jmp __alltraps
c01022cc:	e9 76 fd ff ff       	jmp    c0102047 <__alltraps>

c01022d1 <vector70>:
.globl vector70
vector70:
  pushl $0
c01022d1:	6a 00                	push   $0x0
  pushl $70
c01022d3:	6a 46                	push   $0x46
  jmp __alltraps
c01022d5:	e9 6d fd ff ff       	jmp    c0102047 <__alltraps>

c01022da <vector71>:
.globl vector71
vector71:
  pushl $0
c01022da:	6a 00                	push   $0x0
  pushl $71
c01022dc:	6a 47                	push   $0x47
  jmp __alltraps
c01022de:	e9 64 fd ff ff       	jmp    c0102047 <__alltraps>

c01022e3 <vector72>:
.globl vector72
vector72:
  pushl $0
c01022e3:	6a 00                	push   $0x0
  pushl $72
c01022e5:	6a 48                	push   $0x48
  jmp __alltraps
c01022e7:	e9 5b fd ff ff       	jmp    c0102047 <__alltraps>

c01022ec <vector73>:
.globl vector73
vector73:
  pushl $0
c01022ec:	6a 00                	push   $0x0
  pushl $73
c01022ee:	6a 49                	push   $0x49
  jmp __alltraps
c01022f0:	e9 52 fd ff ff       	jmp    c0102047 <__alltraps>

c01022f5 <vector74>:
.globl vector74
vector74:
  pushl $0
c01022f5:	6a 00                	push   $0x0
  pushl $74
c01022f7:	6a 4a                	push   $0x4a
  jmp __alltraps
c01022f9:	e9 49 fd ff ff       	jmp    c0102047 <__alltraps>

c01022fe <vector75>:
.globl vector75
vector75:
  pushl $0
c01022fe:	6a 00                	push   $0x0
  pushl $75
c0102300:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102302:	e9 40 fd ff ff       	jmp    c0102047 <__alltraps>

c0102307 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102307:	6a 00                	push   $0x0
  pushl $76
c0102309:	6a 4c                	push   $0x4c
  jmp __alltraps
c010230b:	e9 37 fd ff ff       	jmp    c0102047 <__alltraps>

c0102310 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102310:	6a 00                	push   $0x0
  pushl $77
c0102312:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102314:	e9 2e fd ff ff       	jmp    c0102047 <__alltraps>

c0102319 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102319:	6a 00                	push   $0x0
  pushl $78
c010231b:	6a 4e                	push   $0x4e
  jmp __alltraps
c010231d:	e9 25 fd ff ff       	jmp    c0102047 <__alltraps>

c0102322 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102322:	6a 00                	push   $0x0
  pushl $79
c0102324:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102326:	e9 1c fd ff ff       	jmp    c0102047 <__alltraps>

c010232b <vector80>:
.globl vector80
vector80:
  pushl $0
c010232b:	6a 00                	push   $0x0
  pushl $80
c010232d:	6a 50                	push   $0x50
  jmp __alltraps
c010232f:	e9 13 fd ff ff       	jmp    c0102047 <__alltraps>

c0102334 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102334:	6a 00                	push   $0x0
  pushl $81
c0102336:	6a 51                	push   $0x51
  jmp __alltraps
c0102338:	e9 0a fd ff ff       	jmp    c0102047 <__alltraps>

c010233d <vector82>:
.globl vector82
vector82:
  pushl $0
c010233d:	6a 00                	push   $0x0
  pushl $82
c010233f:	6a 52                	push   $0x52
  jmp __alltraps
c0102341:	e9 01 fd ff ff       	jmp    c0102047 <__alltraps>

c0102346 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102346:	6a 00                	push   $0x0
  pushl $83
c0102348:	6a 53                	push   $0x53
  jmp __alltraps
c010234a:	e9 f8 fc ff ff       	jmp    c0102047 <__alltraps>

c010234f <vector84>:
.globl vector84
vector84:
  pushl $0
c010234f:	6a 00                	push   $0x0
  pushl $84
c0102351:	6a 54                	push   $0x54
  jmp __alltraps
c0102353:	e9 ef fc ff ff       	jmp    c0102047 <__alltraps>

c0102358 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102358:	6a 00                	push   $0x0
  pushl $85
c010235a:	6a 55                	push   $0x55
  jmp __alltraps
c010235c:	e9 e6 fc ff ff       	jmp    c0102047 <__alltraps>

c0102361 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102361:	6a 00                	push   $0x0
  pushl $86
c0102363:	6a 56                	push   $0x56
  jmp __alltraps
c0102365:	e9 dd fc ff ff       	jmp    c0102047 <__alltraps>

c010236a <vector87>:
.globl vector87
vector87:
  pushl $0
c010236a:	6a 00                	push   $0x0
  pushl $87
c010236c:	6a 57                	push   $0x57
  jmp __alltraps
c010236e:	e9 d4 fc ff ff       	jmp    c0102047 <__alltraps>

c0102373 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102373:	6a 00                	push   $0x0
  pushl $88
c0102375:	6a 58                	push   $0x58
  jmp __alltraps
c0102377:	e9 cb fc ff ff       	jmp    c0102047 <__alltraps>

c010237c <vector89>:
.globl vector89
vector89:
  pushl $0
c010237c:	6a 00                	push   $0x0
  pushl $89
c010237e:	6a 59                	push   $0x59
  jmp __alltraps
c0102380:	e9 c2 fc ff ff       	jmp    c0102047 <__alltraps>

c0102385 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102385:	6a 00                	push   $0x0
  pushl $90
c0102387:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102389:	e9 b9 fc ff ff       	jmp    c0102047 <__alltraps>

c010238e <vector91>:
.globl vector91
vector91:
  pushl $0
c010238e:	6a 00                	push   $0x0
  pushl $91
c0102390:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102392:	e9 b0 fc ff ff       	jmp    c0102047 <__alltraps>

c0102397 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102397:	6a 00                	push   $0x0
  pushl $92
c0102399:	6a 5c                	push   $0x5c
  jmp __alltraps
c010239b:	e9 a7 fc ff ff       	jmp    c0102047 <__alltraps>

c01023a0 <vector93>:
.globl vector93
vector93:
  pushl $0
c01023a0:	6a 00                	push   $0x0
  pushl $93
c01023a2:	6a 5d                	push   $0x5d
  jmp __alltraps
c01023a4:	e9 9e fc ff ff       	jmp    c0102047 <__alltraps>

c01023a9 <vector94>:
.globl vector94
vector94:
  pushl $0
c01023a9:	6a 00                	push   $0x0
  pushl $94
c01023ab:	6a 5e                	push   $0x5e
  jmp __alltraps
c01023ad:	e9 95 fc ff ff       	jmp    c0102047 <__alltraps>

c01023b2 <vector95>:
.globl vector95
vector95:
  pushl $0
c01023b2:	6a 00                	push   $0x0
  pushl $95
c01023b4:	6a 5f                	push   $0x5f
  jmp __alltraps
c01023b6:	e9 8c fc ff ff       	jmp    c0102047 <__alltraps>

c01023bb <vector96>:
.globl vector96
vector96:
  pushl $0
c01023bb:	6a 00                	push   $0x0
  pushl $96
c01023bd:	6a 60                	push   $0x60
  jmp __alltraps
c01023bf:	e9 83 fc ff ff       	jmp    c0102047 <__alltraps>

c01023c4 <vector97>:
.globl vector97
vector97:
  pushl $0
c01023c4:	6a 00                	push   $0x0
  pushl $97
c01023c6:	6a 61                	push   $0x61
  jmp __alltraps
c01023c8:	e9 7a fc ff ff       	jmp    c0102047 <__alltraps>

c01023cd <vector98>:
.globl vector98
vector98:
  pushl $0
c01023cd:	6a 00                	push   $0x0
  pushl $98
c01023cf:	6a 62                	push   $0x62
  jmp __alltraps
c01023d1:	e9 71 fc ff ff       	jmp    c0102047 <__alltraps>

c01023d6 <vector99>:
.globl vector99
vector99:
  pushl $0
c01023d6:	6a 00                	push   $0x0
  pushl $99
c01023d8:	6a 63                	push   $0x63
  jmp __alltraps
c01023da:	e9 68 fc ff ff       	jmp    c0102047 <__alltraps>

c01023df <vector100>:
.globl vector100
vector100:
  pushl $0
c01023df:	6a 00                	push   $0x0
  pushl $100
c01023e1:	6a 64                	push   $0x64
  jmp __alltraps
c01023e3:	e9 5f fc ff ff       	jmp    c0102047 <__alltraps>

c01023e8 <vector101>:
.globl vector101
vector101:
  pushl $0
c01023e8:	6a 00                	push   $0x0
  pushl $101
c01023ea:	6a 65                	push   $0x65
  jmp __alltraps
c01023ec:	e9 56 fc ff ff       	jmp    c0102047 <__alltraps>

c01023f1 <vector102>:
.globl vector102
vector102:
  pushl $0
c01023f1:	6a 00                	push   $0x0
  pushl $102
c01023f3:	6a 66                	push   $0x66
  jmp __alltraps
c01023f5:	e9 4d fc ff ff       	jmp    c0102047 <__alltraps>

c01023fa <vector103>:
.globl vector103
vector103:
  pushl $0
c01023fa:	6a 00                	push   $0x0
  pushl $103
c01023fc:	6a 67                	push   $0x67
  jmp __alltraps
c01023fe:	e9 44 fc ff ff       	jmp    c0102047 <__alltraps>

c0102403 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102403:	6a 00                	push   $0x0
  pushl $104
c0102405:	6a 68                	push   $0x68
  jmp __alltraps
c0102407:	e9 3b fc ff ff       	jmp    c0102047 <__alltraps>

c010240c <vector105>:
.globl vector105
vector105:
  pushl $0
c010240c:	6a 00                	push   $0x0
  pushl $105
c010240e:	6a 69                	push   $0x69
  jmp __alltraps
c0102410:	e9 32 fc ff ff       	jmp    c0102047 <__alltraps>

c0102415 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102415:	6a 00                	push   $0x0
  pushl $106
c0102417:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102419:	e9 29 fc ff ff       	jmp    c0102047 <__alltraps>

c010241e <vector107>:
.globl vector107
vector107:
  pushl $0
c010241e:	6a 00                	push   $0x0
  pushl $107
c0102420:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102422:	e9 20 fc ff ff       	jmp    c0102047 <__alltraps>

c0102427 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102427:	6a 00                	push   $0x0
  pushl $108
c0102429:	6a 6c                	push   $0x6c
  jmp __alltraps
c010242b:	e9 17 fc ff ff       	jmp    c0102047 <__alltraps>

c0102430 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102430:	6a 00                	push   $0x0
  pushl $109
c0102432:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102434:	e9 0e fc ff ff       	jmp    c0102047 <__alltraps>

c0102439 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102439:	6a 00                	push   $0x0
  pushl $110
c010243b:	6a 6e                	push   $0x6e
  jmp __alltraps
c010243d:	e9 05 fc ff ff       	jmp    c0102047 <__alltraps>

c0102442 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102442:	6a 00                	push   $0x0
  pushl $111
c0102444:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102446:	e9 fc fb ff ff       	jmp    c0102047 <__alltraps>

c010244b <vector112>:
.globl vector112
vector112:
  pushl $0
c010244b:	6a 00                	push   $0x0
  pushl $112
c010244d:	6a 70                	push   $0x70
  jmp __alltraps
c010244f:	e9 f3 fb ff ff       	jmp    c0102047 <__alltraps>

c0102454 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102454:	6a 00                	push   $0x0
  pushl $113
c0102456:	6a 71                	push   $0x71
  jmp __alltraps
c0102458:	e9 ea fb ff ff       	jmp    c0102047 <__alltraps>

c010245d <vector114>:
.globl vector114
vector114:
  pushl $0
c010245d:	6a 00                	push   $0x0
  pushl $114
c010245f:	6a 72                	push   $0x72
  jmp __alltraps
c0102461:	e9 e1 fb ff ff       	jmp    c0102047 <__alltraps>

c0102466 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102466:	6a 00                	push   $0x0
  pushl $115
c0102468:	6a 73                	push   $0x73
  jmp __alltraps
c010246a:	e9 d8 fb ff ff       	jmp    c0102047 <__alltraps>

c010246f <vector116>:
.globl vector116
vector116:
  pushl $0
c010246f:	6a 00                	push   $0x0
  pushl $116
c0102471:	6a 74                	push   $0x74
  jmp __alltraps
c0102473:	e9 cf fb ff ff       	jmp    c0102047 <__alltraps>

c0102478 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102478:	6a 00                	push   $0x0
  pushl $117
c010247a:	6a 75                	push   $0x75
  jmp __alltraps
c010247c:	e9 c6 fb ff ff       	jmp    c0102047 <__alltraps>

c0102481 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102481:	6a 00                	push   $0x0
  pushl $118
c0102483:	6a 76                	push   $0x76
  jmp __alltraps
c0102485:	e9 bd fb ff ff       	jmp    c0102047 <__alltraps>

c010248a <vector119>:
.globl vector119
vector119:
  pushl $0
c010248a:	6a 00                	push   $0x0
  pushl $119
c010248c:	6a 77                	push   $0x77
  jmp __alltraps
c010248e:	e9 b4 fb ff ff       	jmp    c0102047 <__alltraps>

c0102493 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102493:	6a 00                	push   $0x0
  pushl $120
c0102495:	6a 78                	push   $0x78
  jmp __alltraps
c0102497:	e9 ab fb ff ff       	jmp    c0102047 <__alltraps>

c010249c <vector121>:
.globl vector121
vector121:
  pushl $0
c010249c:	6a 00                	push   $0x0
  pushl $121
c010249e:	6a 79                	push   $0x79
  jmp __alltraps
c01024a0:	e9 a2 fb ff ff       	jmp    c0102047 <__alltraps>

c01024a5 <vector122>:
.globl vector122
vector122:
  pushl $0
c01024a5:	6a 00                	push   $0x0
  pushl $122
c01024a7:	6a 7a                	push   $0x7a
  jmp __alltraps
c01024a9:	e9 99 fb ff ff       	jmp    c0102047 <__alltraps>

c01024ae <vector123>:
.globl vector123
vector123:
  pushl $0
c01024ae:	6a 00                	push   $0x0
  pushl $123
c01024b0:	6a 7b                	push   $0x7b
  jmp __alltraps
c01024b2:	e9 90 fb ff ff       	jmp    c0102047 <__alltraps>

c01024b7 <vector124>:
.globl vector124
vector124:
  pushl $0
c01024b7:	6a 00                	push   $0x0
  pushl $124
c01024b9:	6a 7c                	push   $0x7c
  jmp __alltraps
c01024bb:	e9 87 fb ff ff       	jmp    c0102047 <__alltraps>

c01024c0 <vector125>:
.globl vector125
vector125:
  pushl $0
c01024c0:	6a 00                	push   $0x0
  pushl $125
c01024c2:	6a 7d                	push   $0x7d
  jmp __alltraps
c01024c4:	e9 7e fb ff ff       	jmp    c0102047 <__alltraps>

c01024c9 <vector126>:
.globl vector126
vector126:
  pushl $0
c01024c9:	6a 00                	push   $0x0
  pushl $126
c01024cb:	6a 7e                	push   $0x7e
  jmp __alltraps
c01024cd:	e9 75 fb ff ff       	jmp    c0102047 <__alltraps>

c01024d2 <vector127>:
.globl vector127
vector127:
  pushl $0
c01024d2:	6a 00                	push   $0x0
  pushl $127
c01024d4:	6a 7f                	push   $0x7f
  jmp __alltraps
c01024d6:	e9 6c fb ff ff       	jmp    c0102047 <__alltraps>

c01024db <vector128>:
.globl vector128
vector128:
  pushl $0
c01024db:	6a 00                	push   $0x0
  pushl $128
c01024dd:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01024e2:	e9 60 fb ff ff       	jmp    c0102047 <__alltraps>

c01024e7 <vector129>:
.globl vector129
vector129:
  pushl $0
c01024e7:	6a 00                	push   $0x0
  pushl $129
c01024e9:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01024ee:	e9 54 fb ff ff       	jmp    c0102047 <__alltraps>

c01024f3 <vector130>:
.globl vector130
vector130:
  pushl $0
c01024f3:	6a 00                	push   $0x0
  pushl $130
c01024f5:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01024fa:	e9 48 fb ff ff       	jmp    c0102047 <__alltraps>

c01024ff <vector131>:
.globl vector131
vector131:
  pushl $0
c01024ff:	6a 00                	push   $0x0
  pushl $131
c0102501:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102506:	e9 3c fb ff ff       	jmp    c0102047 <__alltraps>

c010250b <vector132>:
.globl vector132
vector132:
  pushl $0
c010250b:	6a 00                	push   $0x0
  pushl $132
c010250d:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102512:	e9 30 fb ff ff       	jmp    c0102047 <__alltraps>

c0102517 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102517:	6a 00                	push   $0x0
  pushl $133
c0102519:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c010251e:	e9 24 fb ff ff       	jmp    c0102047 <__alltraps>

c0102523 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102523:	6a 00                	push   $0x0
  pushl $134
c0102525:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010252a:	e9 18 fb ff ff       	jmp    c0102047 <__alltraps>

c010252f <vector135>:
.globl vector135
vector135:
  pushl $0
c010252f:	6a 00                	push   $0x0
  pushl $135
c0102531:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102536:	e9 0c fb ff ff       	jmp    c0102047 <__alltraps>

c010253b <vector136>:
.globl vector136
vector136:
  pushl $0
c010253b:	6a 00                	push   $0x0
  pushl $136
c010253d:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102542:	e9 00 fb ff ff       	jmp    c0102047 <__alltraps>

c0102547 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102547:	6a 00                	push   $0x0
  pushl $137
c0102549:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c010254e:	e9 f4 fa ff ff       	jmp    c0102047 <__alltraps>

c0102553 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102553:	6a 00                	push   $0x0
  pushl $138
c0102555:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010255a:	e9 e8 fa ff ff       	jmp    c0102047 <__alltraps>

c010255f <vector139>:
.globl vector139
vector139:
  pushl $0
c010255f:	6a 00                	push   $0x0
  pushl $139
c0102561:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102566:	e9 dc fa ff ff       	jmp    c0102047 <__alltraps>

c010256b <vector140>:
.globl vector140
vector140:
  pushl $0
c010256b:	6a 00                	push   $0x0
  pushl $140
c010256d:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102572:	e9 d0 fa ff ff       	jmp    c0102047 <__alltraps>

c0102577 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102577:	6a 00                	push   $0x0
  pushl $141
c0102579:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010257e:	e9 c4 fa ff ff       	jmp    c0102047 <__alltraps>

c0102583 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102583:	6a 00                	push   $0x0
  pushl $142
c0102585:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c010258a:	e9 b8 fa ff ff       	jmp    c0102047 <__alltraps>

c010258f <vector143>:
.globl vector143
vector143:
  pushl $0
c010258f:	6a 00                	push   $0x0
  pushl $143
c0102591:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102596:	e9 ac fa ff ff       	jmp    c0102047 <__alltraps>

c010259b <vector144>:
.globl vector144
vector144:
  pushl $0
c010259b:	6a 00                	push   $0x0
  pushl $144
c010259d:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01025a2:	e9 a0 fa ff ff       	jmp    c0102047 <__alltraps>

c01025a7 <vector145>:
.globl vector145
vector145:
  pushl $0
c01025a7:	6a 00                	push   $0x0
  pushl $145
c01025a9:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01025ae:	e9 94 fa ff ff       	jmp    c0102047 <__alltraps>

c01025b3 <vector146>:
.globl vector146
vector146:
  pushl $0
c01025b3:	6a 00                	push   $0x0
  pushl $146
c01025b5:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01025ba:	e9 88 fa ff ff       	jmp    c0102047 <__alltraps>

c01025bf <vector147>:
.globl vector147
vector147:
  pushl $0
c01025bf:	6a 00                	push   $0x0
  pushl $147
c01025c1:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01025c6:	e9 7c fa ff ff       	jmp    c0102047 <__alltraps>

c01025cb <vector148>:
.globl vector148
vector148:
  pushl $0
c01025cb:	6a 00                	push   $0x0
  pushl $148
c01025cd:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01025d2:	e9 70 fa ff ff       	jmp    c0102047 <__alltraps>

c01025d7 <vector149>:
.globl vector149
vector149:
  pushl $0
c01025d7:	6a 00                	push   $0x0
  pushl $149
c01025d9:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01025de:	e9 64 fa ff ff       	jmp    c0102047 <__alltraps>

c01025e3 <vector150>:
.globl vector150
vector150:
  pushl $0
c01025e3:	6a 00                	push   $0x0
  pushl $150
c01025e5:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01025ea:	e9 58 fa ff ff       	jmp    c0102047 <__alltraps>

c01025ef <vector151>:
.globl vector151
vector151:
  pushl $0
c01025ef:	6a 00                	push   $0x0
  pushl $151
c01025f1:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01025f6:	e9 4c fa ff ff       	jmp    c0102047 <__alltraps>

c01025fb <vector152>:
.globl vector152
vector152:
  pushl $0
c01025fb:	6a 00                	push   $0x0
  pushl $152
c01025fd:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102602:	e9 40 fa ff ff       	jmp    c0102047 <__alltraps>

c0102607 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102607:	6a 00                	push   $0x0
  pushl $153
c0102609:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c010260e:	e9 34 fa ff ff       	jmp    c0102047 <__alltraps>

c0102613 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102613:	6a 00                	push   $0x0
  pushl $154
c0102615:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010261a:	e9 28 fa ff ff       	jmp    c0102047 <__alltraps>

c010261f <vector155>:
.globl vector155
vector155:
  pushl $0
c010261f:	6a 00                	push   $0x0
  pushl $155
c0102621:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102626:	e9 1c fa ff ff       	jmp    c0102047 <__alltraps>

c010262b <vector156>:
.globl vector156
vector156:
  pushl $0
c010262b:	6a 00                	push   $0x0
  pushl $156
c010262d:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102632:	e9 10 fa ff ff       	jmp    c0102047 <__alltraps>

c0102637 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102637:	6a 00                	push   $0x0
  pushl $157
c0102639:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c010263e:	e9 04 fa ff ff       	jmp    c0102047 <__alltraps>

c0102643 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102643:	6a 00                	push   $0x0
  pushl $158
c0102645:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010264a:	e9 f8 f9 ff ff       	jmp    c0102047 <__alltraps>

c010264f <vector159>:
.globl vector159
vector159:
  pushl $0
c010264f:	6a 00                	push   $0x0
  pushl $159
c0102651:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102656:	e9 ec f9 ff ff       	jmp    c0102047 <__alltraps>

c010265b <vector160>:
.globl vector160
vector160:
  pushl $0
c010265b:	6a 00                	push   $0x0
  pushl $160
c010265d:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102662:	e9 e0 f9 ff ff       	jmp    c0102047 <__alltraps>

c0102667 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102667:	6a 00                	push   $0x0
  pushl $161
c0102669:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010266e:	e9 d4 f9 ff ff       	jmp    c0102047 <__alltraps>

c0102673 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102673:	6a 00                	push   $0x0
  pushl $162
c0102675:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010267a:	e9 c8 f9 ff ff       	jmp    c0102047 <__alltraps>

c010267f <vector163>:
.globl vector163
vector163:
  pushl $0
c010267f:	6a 00                	push   $0x0
  pushl $163
c0102681:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102686:	e9 bc f9 ff ff       	jmp    c0102047 <__alltraps>

c010268b <vector164>:
.globl vector164
vector164:
  pushl $0
c010268b:	6a 00                	push   $0x0
  pushl $164
c010268d:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102692:	e9 b0 f9 ff ff       	jmp    c0102047 <__alltraps>

c0102697 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102697:	6a 00                	push   $0x0
  pushl $165
c0102699:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010269e:	e9 a4 f9 ff ff       	jmp    c0102047 <__alltraps>

c01026a3 <vector166>:
.globl vector166
vector166:
  pushl $0
c01026a3:	6a 00                	push   $0x0
  pushl $166
c01026a5:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01026aa:	e9 98 f9 ff ff       	jmp    c0102047 <__alltraps>

c01026af <vector167>:
.globl vector167
vector167:
  pushl $0
c01026af:	6a 00                	push   $0x0
  pushl $167
c01026b1:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01026b6:	e9 8c f9 ff ff       	jmp    c0102047 <__alltraps>

c01026bb <vector168>:
.globl vector168
vector168:
  pushl $0
c01026bb:	6a 00                	push   $0x0
  pushl $168
c01026bd:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01026c2:	e9 80 f9 ff ff       	jmp    c0102047 <__alltraps>

c01026c7 <vector169>:
.globl vector169
vector169:
  pushl $0
c01026c7:	6a 00                	push   $0x0
  pushl $169
c01026c9:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01026ce:	e9 74 f9 ff ff       	jmp    c0102047 <__alltraps>

c01026d3 <vector170>:
.globl vector170
vector170:
  pushl $0
c01026d3:	6a 00                	push   $0x0
  pushl $170
c01026d5:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01026da:	e9 68 f9 ff ff       	jmp    c0102047 <__alltraps>

c01026df <vector171>:
.globl vector171
vector171:
  pushl $0
c01026df:	6a 00                	push   $0x0
  pushl $171
c01026e1:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01026e6:	e9 5c f9 ff ff       	jmp    c0102047 <__alltraps>

c01026eb <vector172>:
.globl vector172
vector172:
  pushl $0
c01026eb:	6a 00                	push   $0x0
  pushl $172
c01026ed:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01026f2:	e9 50 f9 ff ff       	jmp    c0102047 <__alltraps>

c01026f7 <vector173>:
.globl vector173
vector173:
  pushl $0
c01026f7:	6a 00                	push   $0x0
  pushl $173
c01026f9:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01026fe:	e9 44 f9 ff ff       	jmp    c0102047 <__alltraps>

c0102703 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102703:	6a 00                	push   $0x0
  pushl $174
c0102705:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c010270a:	e9 38 f9 ff ff       	jmp    c0102047 <__alltraps>

c010270f <vector175>:
.globl vector175
vector175:
  pushl $0
c010270f:	6a 00                	push   $0x0
  pushl $175
c0102711:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102716:	e9 2c f9 ff ff       	jmp    c0102047 <__alltraps>

c010271b <vector176>:
.globl vector176
vector176:
  pushl $0
c010271b:	6a 00                	push   $0x0
  pushl $176
c010271d:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102722:	e9 20 f9 ff ff       	jmp    c0102047 <__alltraps>

c0102727 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102727:	6a 00                	push   $0x0
  pushl $177
c0102729:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010272e:	e9 14 f9 ff ff       	jmp    c0102047 <__alltraps>

c0102733 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102733:	6a 00                	push   $0x0
  pushl $178
c0102735:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010273a:	e9 08 f9 ff ff       	jmp    c0102047 <__alltraps>

c010273f <vector179>:
.globl vector179
vector179:
  pushl $0
c010273f:	6a 00                	push   $0x0
  pushl $179
c0102741:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102746:	e9 fc f8 ff ff       	jmp    c0102047 <__alltraps>

c010274b <vector180>:
.globl vector180
vector180:
  pushl $0
c010274b:	6a 00                	push   $0x0
  pushl $180
c010274d:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102752:	e9 f0 f8 ff ff       	jmp    c0102047 <__alltraps>

c0102757 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102757:	6a 00                	push   $0x0
  pushl $181
c0102759:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010275e:	e9 e4 f8 ff ff       	jmp    c0102047 <__alltraps>

c0102763 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102763:	6a 00                	push   $0x0
  pushl $182
c0102765:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010276a:	e9 d8 f8 ff ff       	jmp    c0102047 <__alltraps>

c010276f <vector183>:
.globl vector183
vector183:
  pushl $0
c010276f:	6a 00                	push   $0x0
  pushl $183
c0102771:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102776:	e9 cc f8 ff ff       	jmp    c0102047 <__alltraps>

c010277b <vector184>:
.globl vector184
vector184:
  pushl $0
c010277b:	6a 00                	push   $0x0
  pushl $184
c010277d:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102782:	e9 c0 f8 ff ff       	jmp    c0102047 <__alltraps>

c0102787 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102787:	6a 00                	push   $0x0
  pushl $185
c0102789:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010278e:	e9 b4 f8 ff ff       	jmp    c0102047 <__alltraps>

c0102793 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102793:	6a 00                	push   $0x0
  pushl $186
c0102795:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010279a:	e9 a8 f8 ff ff       	jmp    c0102047 <__alltraps>

c010279f <vector187>:
.globl vector187
vector187:
  pushl $0
c010279f:	6a 00                	push   $0x0
  pushl $187
c01027a1:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01027a6:	e9 9c f8 ff ff       	jmp    c0102047 <__alltraps>

c01027ab <vector188>:
.globl vector188
vector188:
  pushl $0
c01027ab:	6a 00                	push   $0x0
  pushl $188
c01027ad:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01027b2:	e9 90 f8 ff ff       	jmp    c0102047 <__alltraps>

c01027b7 <vector189>:
.globl vector189
vector189:
  pushl $0
c01027b7:	6a 00                	push   $0x0
  pushl $189
c01027b9:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01027be:	e9 84 f8 ff ff       	jmp    c0102047 <__alltraps>

c01027c3 <vector190>:
.globl vector190
vector190:
  pushl $0
c01027c3:	6a 00                	push   $0x0
  pushl $190
c01027c5:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01027ca:	e9 78 f8 ff ff       	jmp    c0102047 <__alltraps>

c01027cf <vector191>:
.globl vector191
vector191:
  pushl $0
c01027cf:	6a 00                	push   $0x0
  pushl $191
c01027d1:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01027d6:	e9 6c f8 ff ff       	jmp    c0102047 <__alltraps>

c01027db <vector192>:
.globl vector192
vector192:
  pushl $0
c01027db:	6a 00                	push   $0x0
  pushl $192
c01027dd:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01027e2:	e9 60 f8 ff ff       	jmp    c0102047 <__alltraps>

c01027e7 <vector193>:
.globl vector193
vector193:
  pushl $0
c01027e7:	6a 00                	push   $0x0
  pushl $193
c01027e9:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01027ee:	e9 54 f8 ff ff       	jmp    c0102047 <__alltraps>

c01027f3 <vector194>:
.globl vector194
vector194:
  pushl $0
c01027f3:	6a 00                	push   $0x0
  pushl $194
c01027f5:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01027fa:	e9 48 f8 ff ff       	jmp    c0102047 <__alltraps>

c01027ff <vector195>:
.globl vector195
vector195:
  pushl $0
c01027ff:	6a 00                	push   $0x0
  pushl $195
c0102801:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102806:	e9 3c f8 ff ff       	jmp    c0102047 <__alltraps>

c010280b <vector196>:
.globl vector196
vector196:
  pushl $0
c010280b:	6a 00                	push   $0x0
  pushl $196
c010280d:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102812:	e9 30 f8 ff ff       	jmp    c0102047 <__alltraps>

c0102817 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102817:	6a 00                	push   $0x0
  pushl $197
c0102819:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c010281e:	e9 24 f8 ff ff       	jmp    c0102047 <__alltraps>

c0102823 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102823:	6a 00                	push   $0x0
  pushl $198
c0102825:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010282a:	e9 18 f8 ff ff       	jmp    c0102047 <__alltraps>

c010282f <vector199>:
.globl vector199
vector199:
  pushl $0
c010282f:	6a 00                	push   $0x0
  pushl $199
c0102831:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102836:	e9 0c f8 ff ff       	jmp    c0102047 <__alltraps>

c010283b <vector200>:
.globl vector200
vector200:
  pushl $0
c010283b:	6a 00                	push   $0x0
  pushl $200
c010283d:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102842:	e9 00 f8 ff ff       	jmp    c0102047 <__alltraps>

c0102847 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102847:	6a 00                	push   $0x0
  pushl $201
c0102849:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c010284e:	e9 f4 f7 ff ff       	jmp    c0102047 <__alltraps>

c0102853 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102853:	6a 00                	push   $0x0
  pushl $202
c0102855:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010285a:	e9 e8 f7 ff ff       	jmp    c0102047 <__alltraps>

c010285f <vector203>:
.globl vector203
vector203:
  pushl $0
c010285f:	6a 00                	push   $0x0
  pushl $203
c0102861:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102866:	e9 dc f7 ff ff       	jmp    c0102047 <__alltraps>

c010286b <vector204>:
.globl vector204
vector204:
  pushl $0
c010286b:	6a 00                	push   $0x0
  pushl $204
c010286d:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102872:	e9 d0 f7 ff ff       	jmp    c0102047 <__alltraps>

c0102877 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102877:	6a 00                	push   $0x0
  pushl $205
c0102879:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010287e:	e9 c4 f7 ff ff       	jmp    c0102047 <__alltraps>

c0102883 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102883:	6a 00                	push   $0x0
  pushl $206
c0102885:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010288a:	e9 b8 f7 ff ff       	jmp    c0102047 <__alltraps>

c010288f <vector207>:
.globl vector207
vector207:
  pushl $0
c010288f:	6a 00                	push   $0x0
  pushl $207
c0102891:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102896:	e9 ac f7 ff ff       	jmp    c0102047 <__alltraps>

c010289b <vector208>:
.globl vector208
vector208:
  pushl $0
c010289b:	6a 00                	push   $0x0
  pushl $208
c010289d:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01028a2:	e9 a0 f7 ff ff       	jmp    c0102047 <__alltraps>

c01028a7 <vector209>:
.globl vector209
vector209:
  pushl $0
c01028a7:	6a 00                	push   $0x0
  pushl $209
c01028a9:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01028ae:	e9 94 f7 ff ff       	jmp    c0102047 <__alltraps>

c01028b3 <vector210>:
.globl vector210
vector210:
  pushl $0
c01028b3:	6a 00                	push   $0x0
  pushl $210
c01028b5:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01028ba:	e9 88 f7 ff ff       	jmp    c0102047 <__alltraps>

c01028bf <vector211>:
.globl vector211
vector211:
  pushl $0
c01028bf:	6a 00                	push   $0x0
  pushl $211
c01028c1:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01028c6:	e9 7c f7 ff ff       	jmp    c0102047 <__alltraps>

c01028cb <vector212>:
.globl vector212
vector212:
  pushl $0
c01028cb:	6a 00                	push   $0x0
  pushl $212
c01028cd:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01028d2:	e9 70 f7 ff ff       	jmp    c0102047 <__alltraps>

c01028d7 <vector213>:
.globl vector213
vector213:
  pushl $0
c01028d7:	6a 00                	push   $0x0
  pushl $213
c01028d9:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01028de:	e9 64 f7 ff ff       	jmp    c0102047 <__alltraps>

c01028e3 <vector214>:
.globl vector214
vector214:
  pushl $0
c01028e3:	6a 00                	push   $0x0
  pushl $214
c01028e5:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01028ea:	e9 58 f7 ff ff       	jmp    c0102047 <__alltraps>

c01028ef <vector215>:
.globl vector215
vector215:
  pushl $0
c01028ef:	6a 00                	push   $0x0
  pushl $215
c01028f1:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01028f6:	e9 4c f7 ff ff       	jmp    c0102047 <__alltraps>

c01028fb <vector216>:
.globl vector216
vector216:
  pushl $0
c01028fb:	6a 00                	push   $0x0
  pushl $216
c01028fd:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102902:	e9 40 f7 ff ff       	jmp    c0102047 <__alltraps>

c0102907 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102907:	6a 00                	push   $0x0
  pushl $217
c0102909:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c010290e:	e9 34 f7 ff ff       	jmp    c0102047 <__alltraps>

c0102913 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102913:	6a 00                	push   $0x0
  pushl $218
c0102915:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010291a:	e9 28 f7 ff ff       	jmp    c0102047 <__alltraps>

c010291f <vector219>:
.globl vector219
vector219:
  pushl $0
c010291f:	6a 00                	push   $0x0
  pushl $219
c0102921:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102926:	e9 1c f7 ff ff       	jmp    c0102047 <__alltraps>

c010292b <vector220>:
.globl vector220
vector220:
  pushl $0
c010292b:	6a 00                	push   $0x0
  pushl $220
c010292d:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102932:	e9 10 f7 ff ff       	jmp    c0102047 <__alltraps>

c0102937 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102937:	6a 00                	push   $0x0
  pushl $221
c0102939:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010293e:	e9 04 f7 ff ff       	jmp    c0102047 <__alltraps>

c0102943 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102943:	6a 00                	push   $0x0
  pushl $222
c0102945:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010294a:	e9 f8 f6 ff ff       	jmp    c0102047 <__alltraps>

c010294f <vector223>:
.globl vector223
vector223:
  pushl $0
c010294f:	6a 00                	push   $0x0
  pushl $223
c0102951:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102956:	e9 ec f6 ff ff       	jmp    c0102047 <__alltraps>

c010295b <vector224>:
.globl vector224
vector224:
  pushl $0
c010295b:	6a 00                	push   $0x0
  pushl $224
c010295d:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102962:	e9 e0 f6 ff ff       	jmp    c0102047 <__alltraps>

c0102967 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102967:	6a 00                	push   $0x0
  pushl $225
c0102969:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010296e:	e9 d4 f6 ff ff       	jmp    c0102047 <__alltraps>

c0102973 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102973:	6a 00                	push   $0x0
  pushl $226
c0102975:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010297a:	e9 c8 f6 ff ff       	jmp    c0102047 <__alltraps>

c010297f <vector227>:
.globl vector227
vector227:
  pushl $0
c010297f:	6a 00                	push   $0x0
  pushl $227
c0102981:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102986:	e9 bc f6 ff ff       	jmp    c0102047 <__alltraps>

c010298b <vector228>:
.globl vector228
vector228:
  pushl $0
c010298b:	6a 00                	push   $0x0
  pushl $228
c010298d:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102992:	e9 b0 f6 ff ff       	jmp    c0102047 <__alltraps>

c0102997 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102997:	6a 00                	push   $0x0
  pushl $229
c0102999:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010299e:	e9 a4 f6 ff ff       	jmp    c0102047 <__alltraps>

c01029a3 <vector230>:
.globl vector230
vector230:
  pushl $0
c01029a3:	6a 00                	push   $0x0
  pushl $230
c01029a5:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01029aa:	e9 98 f6 ff ff       	jmp    c0102047 <__alltraps>

c01029af <vector231>:
.globl vector231
vector231:
  pushl $0
c01029af:	6a 00                	push   $0x0
  pushl $231
c01029b1:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01029b6:	e9 8c f6 ff ff       	jmp    c0102047 <__alltraps>

c01029bb <vector232>:
.globl vector232
vector232:
  pushl $0
c01029bb:	6a 00                	push   $0x0
  pushl $232
c01029bd:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01029c2:	e9 80 f6 ff ff       	jmp    c0102047 <__alltraps>

c01029c7 <vector233>:
.globl vector233
vector233:
  pushl $0
c01029c7:	6a 00                	push   $0x0
  pushl $233
c01029c9:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01029ce:	e9 74 f6 ff ff       	jmp    c0102047 <__alltraps>

c01029d3 <vector234>:
.globl vector234
vector234:
  pushl $0
c01029d3:	6a 00                	push   $0x0
  pushl $234
c01029d5:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01029da:	e9 68 f6 ff ff       	jmp    c0102047 <__alltraps>

c01029df <vector235>:
.globl vector235
vector235:
  pushl $0
c01029df:	6a 00                	push   $0x0
  pushl $235
c01029e1:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01029e6:	e9 5c f6 ff ff       	jmp    c0102047 <__alltraps>

c01029eb <vector236>:
.globl vector236
vector236:
  pushl $0
c01029eb:	6a 00                	push   $0x0
  pushl $236
c01029ed:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01029f2:	e9 50 f6 ff ff       	jmp    c0102047 <__alltraps>

c01029f7 <vector237>:
.globl vector237
vector237:
  pushl $0
c01029f7:	6a 00                	push   $0x0
  pushl $237
c01029f9:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01029fe:	e9 44 f6 ff ff       	jmp    c0102047 <__alltraps>

c0102a03 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102a03:	6a 00                	push   $0x0
  pushl $238
c0102a05:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102a0a:	e9 38 f6 ff ff       	jmp    c0102047 <__alltraps>

c0102a0f <vector239>:
.globl vector239
vector239:
  pushl $0
c0102a0f:	6a 00                	push   $0x0
  pushl $239
c0102a11:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102a16:	e9 2c f6 ff ff       	jmp    c0102047 <__alltraps>

c0102a1b <vector240>:
.globl vector240
vector240:
  pushl $0
c0102a1b:	6a 00                	push   $0x0
  pushl $240
c0102a1d:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102a22:	e9 20 f6 ff ff       	jmp    c0102047 <__alltraps>

c0102a27 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102a27:	6a 00                	push   $0x0
  pushl $241
c0102a29:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102a2e:	e9 14 f6 ff ff       	jmp    c0102047 <__alltraps>

c0102a33 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102a33:	6a 00                	push   $0x0
  pushl $242
c0102a35:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102a3a:	e9 08 f6 ff ff       	jmp    c0102047 <__alltraps>

c0102a3f <vector243>:
.globl vector243
vector243:
  pushl $0
c0102a3f:	6a 00                	push   $0x0
  pushl $243
c0102a41:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102a46:	e9 fc f5 ff ff       	jmp    c0102047 <__alltraps>

c0102a4b <vector244>:
.globl vector244
vector244:
  pushl $0
c0102a4b:	6a 00                	push   $0x0
  pushl $244
c0102a4d:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102a52:	e9 f0 f5 ff ff       	jmp    c0102047 <__alltraps>

c0102a57 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102a57:	6a 00                	push   $0x0
  pushl $245
c0102a59:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102a5e:	e9 e4 f5 ff ff       	jmp    c0102047 <__alltraps>

c0102a63 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102a63:	6a 00                	push   $0x0
  pushl $246
c0102a65:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102a6a:	e9 d8 f5 ff ff       	jmp    c0102047 <__alltraps>

c0102a6f <vector247>:
.globl vector247
vector247:
  pushl $0
c0102a6f:	6a 00                	push   $0x0
  pushl $247
c0102a71:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102a76:	e9 cc f5 ff ff       	jmp    c0102047 <__alltraps>

c0102a7b <vector248>:
.globl vector248
vector248:
  pushl $0
c0102a7b:	6a 00                	push   $0x0
  pushl $248
c0102a7d:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102a82:	e9 c0 f5 ff ff       	jmp    c0102047 <__alltraps>

c0102a87 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102a87:	6a 00                	push   $0x0
  pushl $249
c0102a89:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102a8e:	e9 b4 f5 ff ff       	jmp    c0102047 <__alltraps>

c0102a93 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102a93:	6a 00                	push   $0x0
  pushl $250
c0102a95:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102a9a:	e9 a8 f5 ff ff       	jmp    c0102047 <__alltraps>

c0102a9f <vector251>:
.globl vector251
vector251:
  pushl $0
c0102a9f:	6a 00                	push   $0x0
  pushl $251
c0102aa1:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102aa6:	e9 9c f5 ff ff       	jmp    c0102047 <__alltraps>

c0102aab <vector252>:
.globl vector252
vector252:
  pushl $0
c0102aab:	6a 00                	push   $0x0
  pushl $252
c0102aad:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102ab2:	e9 90 f5 ff ff       	jmp    c0102047 <__alltraps>

c0102ab7 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102ab7:	6a 00                	push   $0x0
  pushl $253
c0102ab9:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102abe:	e9 84 f5 ff ff       	jmp    c0102047 <__alltraps>

c0102ac3 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102ac3:	6a 00                	push   $0x0
  pushl $254
c0102ac5:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102aca:	e9 78 f5 ff ff       	jmp    c0102047 <__alltraps>

c0102acf <vector255>:
.globl vector255
vector255:
  pushl $0
c0102acf:	6a 00                	push   $0x0
  pushl $255
c0102ad1:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102ad6:	e9 6c f5 ff ff       	jmp    c0102047 <__alltraps>

c0102adb <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102adb:	55                   	push   %ebp
c0102adc:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102ade:	8b 15 a0 ee 11 c0    	mov    0xc011eea0,%edx
c0102ae4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ae7:	29 d0                	sub    %edx,%eax
c0102ae9:	c1 f8 02             	sar    $0x2,%eax
c0102aec:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102af2:	5d                   	pop    %ebp
c0102af3:	c3                   	ret    

c0102af4 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102af4:	55                   	push   %ebp
c0102af5:	89 e5                	mov    %esp,%ebp
c0102af7:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102afa:	8b 45 08             	mov    0x8(%ebp),%eax
c0102afd:	89 04 24             	mov    %eax,(%esp)
c0102b00:	e8 d6 ff ff ff       	call   c0102adb <page2ppn>
c0102b05:	c1 e0 0c             	shl    $0xc,%eax
}
c0102b08:	89 ec                	mov    %ebp,%esp
c0102b0a:	5d                   	pop    %ebp
c0102b0b:	c3                   	ret    

c0102b0c <set_page_ref>:
page_ref(struct Page *page) {
    return page->ref;
}

static inline void
set_page_ref(struct Page *page, int val) {
c0102b0c:	55                   	push   %ebp
c0102b0d:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102b0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b12:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b15:	89 10                	mov    %edx,(%eax)
}
c0102b17:	90                   	nop
c0102b18:	5d                   	pop    %ebp
c0102b19:	c3                   	ret    

c0102b1a <buddy_init>:
static unsigned int buddy_page_num;
static unsigned int useable_page_num;
static struct Page* useable_page_base;

static void
buddy_init(void) {
c0102b1a:	55                   	push   %ebp
c0102b1b:	89 e5                	mov    %esp,%ebp
    /* do nothing */
}
c0102b1d:	90                   	nop
c0102b1e:	5d                   	pop    %ebp
c0102b1f:	c3                   	ret    

c0102b20 <buddy_init_memmap>:

static void
buddy_init_memmap(struct Page *base, size_t n) {
c0102b20:	55                   	push   %ebp
c0102b21:	89 e5                	mov    %esp,%ebp
c0102b23:	83 ec 58             	sub    $0x58,%esp
    // 检查参数
    assert((n > 0));// && IS_POWER_OF_2(n)
c0102b26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102b2a:	75 24                	jne    c0102b50 <buddy_init_memmap+0x30>
c0102b2c:	c7 44 24 0c b0 74 10 	movl   $0xc01074b0,0xc(%esp)
c0102b33:	c0 
c0102b34:	c7 44 24 08 b8 74 10 	movl   $0xc01074b8,0x8(%esp)
c0102b3b:	c0 
c0102b3c:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
c0102b43:	00 
c0102b44:	c7 04 24 cd 74 10 c0 	movl   $0xc01074cd,(%esp)
c0102b4b:	e8 9d e1 ff ff       	call   c0100ced <__panic>
    // 获得伙伴系统的各参数
    // 可使用内存页数 && 管理内存页数
    useable_page_num = 1;
c0102b50:	c7 05 88 ee 11 c0 01 	movl   $0x1,0xc011ee88
c0102b57:	00 00 00 
    for (int i = 1;
c0102b5a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0102b61:	eb 0f                	jmp    c0102b72 <buddy_init_memmap+0x52>
         (i < BUDDY_MAX_DEPTH) && (useable_page_num + (useable_page_num >> 9) < n);
         i++, useable_page_num <<= 1)
c0102b63:	ff 45 f4             	incl   -0xc(%ebp)
c0102b66:	a1 88 ee 11 c0       	mov    0xc011ee88,%eax
c0102b6b:	01 c0                	add    %eax,%eax
c0102b6d:	a3 88 ee 11 c0       	mov    %eax,0xc011ee88
         (i < BUDDY_MAX_DEPTH) && (useable_page_num + (useable_page_num >> 9) < n);
c0102b72:	83 7d f4 1d          	cmpl   $0x1d,-0xc(%ebp)
c0102b76:	7f 16                	jg     c0102b8e <buddy_init_memmap+0x6e>
c0102b78:	a1 88 ee 11 c0       	mov    0xc011ee88,%eax
c0102b7d:	c1 e8 09             	shr    $0x9,%eax
c0102b80:	89 c2                	mov    %eax,%edx
c0102b82:	a1 88 ee 11 c0       	mov    0xc011ee88,%eax
c0102b87:	01 d0                	add    %edx,%eax
c0102b89:	39 45 0c             	cmp    %eax,0xc(%ebp)
c0102b8c:	77 d5                	ja     c0102b63 <buddy_init_memmap+0x43>
        /* do nothing */;
    useable_page_num >>= 1;
c0102b8e:	a1 88 ee 11 c0       	mov    0xc011ee88,%eax
c0102b93:	d1 e8                	shr    %eax
c0102b95:	a3 88 ee 11 c0       	mov    %eax,0xc011ee88
    buddy_page_num = (useable_page_num >> 9) + 1;
c0102b9a:	a1 88 ee 11 c0       	mov    0xc011ee88,%eax
c0102b9f:	c1 e8 09             	shr    $0x9,%eax
c0102ba2:	40                   	inc    %eax
c0102ba3:	a3 84 ee 11 c0       	mov    %eax,0xc011ee84
    // 可使用内存页基址
    useable_page_base = base + buddy_page_num;
c0102ba8:	8b 15 84 ee 11 c0    	mov    0xc011ee84,%edx
c0102bae:	89 d0                	mov    %edx,%eax
c0102bb0:	c1 e0 02             	shl    $0x2,%eax
c0102bb3:	01 d0                	add    %edx,%eax
c0102bb5:	c1 e0 02             	shl    $0x2,%eax
c0102bb8:	89 c2                	mov    %eax,%edx
c0102bba:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bbd:	01 d0                	add    %edx,%eax
c0102bbf:	a3 8c ee 11 c0       	mov    %eax,0xc011ee8c
    // 初始化所有页权限
    for (int i = 0; i != buddy_page_num; i++){
c0102bc4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102bcb:	eb 2e                	jmp    c0102bfb <buddy_init_memmap+0xdb>
        SetPageReserved(base + i);
c0102bcd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102bd0:	89 d0                	mov    %edx,%eax
c0102bd2:	c1 e0 02             	shl    $0x2,%eax
c0102bd5:	01 d0                	add    %edx,%eax
c0102bd7:	c1 e0 02             	shl    $0x2,%eax
c0102bda:	89 c2                	mov    %eax,%edx
c0102bdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bdf:	01 d0                	add    %edx,%eax
c0102be1:	83 c0 04             	add    $0x4,%eax
c0102be4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
c0102beb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102bee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102bf1:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102bf4:	0f ab 10             	bts    %edx,(%eax)
}
c0102bf7:	90                   	nop
    for (int i = 0; i != buddy_page_num; i++){
c0102bf8:	ff 45 f0             	incl   -0x10(%ebp)
c0102bfb:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102bfe:	a1 84 ee 11 c0       	mov    0xc011ee84,%eax
c0102c03:	39 c2                	cmp    %eax,%edx
c0102c05:	75 c6                	jne    c0102bcd <buddy_init_memmap+0xad>
    }
    for (int i = buddy_page_num; i != n; i++){
c0102c07:	a1 84 ee 11 c0       	mov    0xc011ee84,%eax
c0102c0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102c0f:	eb 7d                	jmp    c0102c8e <buddy_init_memmap+0x16e>
        ClearPageReserved(base + i);
c0102c11:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102c14:	89 d0                	mov    %edx,%eax
c0102c16:	c1 e0 02             	shl    $0x2,%eax
c0102c19:	01 d0                	add    %edx,%eax
c0102c1b:	c1 e0 02             	shl    $0x2,%eax
c0102c1e:	89 c2                	mov    %eax,%edx
c0102c20:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c23:	01 d0                	add    %edx,%eax
c0102c25:	83 c0 04             	add    $0x4,%eax
c0102c28:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
c0102c2f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c32:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102c35:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102c38:	0f b3 10             	btr    %edx,(%eax)
}
c0102c3b:	90                   	nop
        SetPageProperty(base + i);
c0102c3c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102c3f:	89 d0                	mov    %edx,%eax
c0102c41:	c1 e0 02             	shl    $0x2,%eax
c0102c44:	01 d0                	add    %edx,%eax
c0102c46:	c1 e0 02             	shl    $0x2,%eax
c0102c49:	89 c2                	mov    %eax,%edx
c0102c4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c4e:	01 d0                	add    %edx,%eax
c0102c50:	83 c0 04             	add    $0x4,%eax
c0102c53:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102c5a:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c60:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102c63:	0f ab 10             	bts    %edx,(%eax)
}
c0102c66:	90                   	nop
        set_page_ref(base + i, 0);
c0102c67:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102c6a:	89 d0                	mov    %edx,%eax
c0102c6c:	c1 e0 02             	shl    $0x2,%eax
c0102c6f:	01 d0                	add    %edx,%eax
c0102c71:	c1 e0 02             	shl    $0x2,%eax
c0102c74:	89 c2                	mov    %eax,%edx
c0102c76:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c79:	01 d0                	add    %edx,%eax
c0102c7b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102c82:	00 
c0102c83:	89 04 24             	mov    %eax,(%esp)
c0102c86:	e8 81 fe ff ff       	call   c0102b0c <set_page_ref>
    for (int i = buddy_page_num; i != n; i++){
c0102c8b:	ff 45 ec             	incl   -0x14(%ebp)
c0102c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102c91:	39 45 0c             	cmp    %eax,0xc(%ebp)
c0102c94:	0f 85 77 ff ff ff    	jne    c0102c11 <buddy_init_memmap+0xf1>
    }
    // 初始化管理页 (自底向上)
    buddy_page = (unsigned int*)KADDR(page2pa(base));
c0102c9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c9d:	89 04 24             	mov    %eax,(%esp)
c0102ca0:	e8 4f fe ff ff       	call   c0102af4 <page2pa>
c0102ca5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102ca8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102cab:	c1 e8 0c             	shr    $0xc,%eax
c0102cae:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102cb1:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c0102cb6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102cb9:	72 23                	jb     c0102cde <buddy_init_memmap+0x1be>
c0102cbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102cbe:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102cc2:	c7 44 24 08 e4 74 10 	movl   $0xc01074e4,0x8(%esp)
c0102cc9:	c0 
c0102cca:	c7 44 24 04 31 00 00 	movl   $0x31,0x4(%esp)
c0102cd1:	00 
c0102cd2:	c7 04 24 cd 74 10 c0 	movl   $0xc01074cd,(%esp)
c0102cd9:	e8 0f e0 ff ff       	call   c0100ced <__panic>
c0102cde:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102ce1:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0102ce6:	a3 80 ee 11 c0       	mov    %eax,0xc011ee80
    for (int i = useable_page_num; i < useable_page_num << 1; i++){
c0102ceb:	a1 88 ee 11 c0       	mov    0xc011ee88,%eax
c0102cf0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0102cf3:	eb 17                	jmp    c0102d0c <buddy_init_memmap+0x1ec>
        buddy_page[i] = 1;
c0102cf5:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0102cfb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102cfe:	c1 e0 02             	shl    $0x2,%eax
c0102d01:	01 d0                	add    %edx,%eax
c0102d03:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    for (int i = useable_page_num; i < useable_page_num << 1; i++){
c0102d09:	ff 45 e8             	incl   -0x18(%ebp)
c0102d0c:	a1 88 ee 11 c0       	mov    0xc011ee88,%eax
c0102d11:	8d 14 00             	lea    (%eax,%eax,1),%edx
c0102d14:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102d17:	39 c2                	cmp    %eax,%edx
c0102d19:	77 da                	ja     c0102cf5 <buddy_init_memmap+0x1d5>
    }
    for (int i = useable_page_num - 1; i > 0; i--){
c0102d1b:	a1 88 ee 11 c0       	mov    0xc011ee88,%eax
c0102d20:	48                   	dec    %eax
c0102d21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0102d24:	eb 27                	jmp    c0102d4d <buddy_init_memmap+0x22d>
        buddy_page[i] = buddy_page[i << 1] << 1;
c0102d26:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0102d2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102d2f:	01 c0                	add    %eax,%eax
c0102d31:	c1 e0 02             	shl    $0x2,%eax
c0102d34:	01 d0                	add    %edx,%eax
c0102d36:	8b 10                	mov    (%eax),%edx
c0102d38:	8b 0d 80 ee 11 c0    	mov    0xc011ee80,%ecx
c0102d3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102d41:	c1 e0 02             	shl    $0x2,%eax
c0102d44:	01 c8                	add    %ecx,%eax
c0102d46:	01 d2                	add    %edx,%edx
c0102d48:	89 10                	mov    %edx,(%eax)
    for (int i = useable_page_num - 1; i > 0; i--){
c0102d4a:	ff 4d e4             	decl   -0x1c(%ebp)
c0102d4d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102d51:	7f d3                	jg     c0102d26 <buddy_init_memmap+0x206>
    }
    // 输出信息
    cprintf("buddy init: Total %d, Buddy %d, Useable %d\n",
c0102d53:	8b 15 88 ee 11 c0    	mov    0xc011ee88,%edx
c0102d59:	a1 84 ee 11 c0       	mov    0xc011ee84,%eax
c0102d5e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0102d62:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102d66:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102d69:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102d6d:	c7 04 24 08 75 10 c0 	movl   $0xc0107508,(%esp)
c0102d74:	e8 e8 d5 ff ff       	call   c0100361 <cprintf>
            n, buddy_page_num, useable_page_num);
}
c0102d79:	90                   	nop
c0102d7a:	89 ec                	mov    %ebp,%esp
c0102d7c:	5d                   	pop    %ebp
c0102d7d:	c3                   	ret    

c0102d7e <buddy_alloc_pages>:

static struct
Page* buddy_alloc_pages(size_t n) {
c0102d7e:	55                   	push   %ebp
c0102d7f:	89 e5                	mov    %esp,%ebp
c0102d81:	83 ec 38             	sub    $0x38,%esp
c0102d84:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // 检查参数
    assert(n > 0);
c0102d87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102d8b:	75 24                	jne    c0102db1 <buddy_alloc_pages+0x33>
c0102d8d:	c7 44 24 0c 34 75 10 	movl   $0xc0107534,0xc(%esp)
c0102d94:	c0 
c0102d95:	c7 44 24 08 b8 74 10 	movl   $0xc01074b8,0x8(%esp)
c0102d9c:	c0 
c0102d9d:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
c0102da4:	00 
c0102da5:	c7 04 24 cd 74 10 c0 	movl   $0xc01074cd,(%esp)
c0102dac:	e8 3c df ff ff       	call   c0100ced <__panic>
    // 需要的页数太大, 返回NULL(分配失败)
    if (n > buddy_page[1]){
c0102db1:	a1 80 ee 11 c0       	mov    0xc011ee80,%eax
c0102db6:	83 c0 04             	add    $0x4,%eax
c0102db9:	8b 00                	mov    (%eax),%eax
c0102dbb:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102dbe:	76 0a                	jbe    c0102dca <buddy_alloc_pages+0x4c>
        return NULL;
c0102dc0:	b8 00 00 00 00       	mov    $0x0,%eax
c0102dc5:	e9 2d 01 00 00       	jmp    c0102ef7 <buddy_alloc_pages+0x179>
    }
    // 找到需要的页区
    unsigned int index = 1;
c0102dca:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    while(1){
        if (buddy_page[LEFT_CHILD(index)] >= n){
c0102dd1:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0102dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dda:	c1 e0 03             	shl    $0x3,%eax
c0102ddd:	01 d0                	add    %edx,%eax
c0102ddf:	8b 00                	mov    (%eax),%eax
c0102de1:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102de4:	77 05                	ja     c0102deb <buddy_alloc_pages+0x6d>
            index = LEFT_CHILD(index);
c0102de6:	d1 65 f4             	shll   -0xc(%ebp)
c0102de9:	eb e6                	jmp    c0102dd1 <buddy_alloc_pages+0x53>
        }
        else if (buddy_page[RIGHT_CHILD(index)] >= n){
c0102deb:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0102df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102df4:	c1 e0 03             	shl    $0x3,%eax
c0102df7:	83 c0 04             	add    $0x4,%eax
c0102dfa:	01 d0                	add    %edx,%eax
c0102dfc:	8b 00                	mov    (%eax),%eax
c0102dfe:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102e01:	77 0b                	ja     c0102e0e <buddy_alloc_pages+0x90>
            index = RIGHT_CHILD(index);
c0102e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e06:	01 c0                	add    %eax,%eax
c0102e08:	40                   	inc    %eax
c0102e09:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (buddy_page[LEFT_CHILD(index)] >= n){
c0102e0c:	eb c3                	jmp    c0102dd1 <buddy_alloc_pages+0x53>
        }
        else{
            break;
c0102e0e:	90                   	nop
        }
    }
    // 分配
    unsigned int size = buddy_page[index];
c0102e0f:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0102e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e18:	c1 e0 02             	shl    $0x2,%eax
c0102e1b:	01 d0                	add    %edx,%eax
c0102e1d:	8b 00                	mov    (%eax),%eax
c0102e1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    buddy_page[index] = 0;
c0102e22:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0102e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e2b:	c1 e0 02             	shl    $0x2,%eax
c0102e2e:	01 d0                	add    %edx,%eax
c0102e30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            ..............
         *    *       *    *
        / \  / \ ... / \  / \
       *  * *  *    *  * *  *
    */
    struct Page* new_page = &useable_page_base[index * size - useable_page_num];
c0102e36:	8b 0d 8c ee 11 c0    	mov    0xc011ee8c,%ecx
c0102e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e3f:	0f af 45 ec          	imul   -0x14(%ebp),%eax
c0102e43:	8b 1d 88 ee 11 c0    	mov    0xc011ee88,%ebx
c0102e49:	29 d8                	sub    %ebx,%eax
c0102e4b:	89 c2                	mov    %eax,%edx
c0102e4d:	89 d0                	mov    %edx,%eax
c0102e4f:	c1 e0 02             	shl    $0x2,%eax
c0102e52:	01 d0                	add    %edx,%eax
c0102e54:	c1 e0 02             	shl    $0x2,%eax
c0102e57:	01 c8                	add    %ecx,%eax
c0102e59:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for (struct Page* p = new_page; p != new_page + size; p++){
c0102e5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102e5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e62:	eb 31                	jmp    c0102e95 <buddy_alloc_pages+0x117>
        ClearPageProperty(p);
c0102e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e67:	83 c0 04             	add    $0x4,%eax
c0102e6a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102e71:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102e74:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102e77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102e7a:	0f b3 10             	btr    %edx,(%eax)
}
c0102e7d:	90                   	nop
        set_page_ref(p, 0);
c0102e7e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102e85:	00 
c0102e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e89:	89 04 24             	mov    %eax,(%esp)
c0102e8c:	e8 7b fc ff ff       	call   c0102b0c <set_page_ref>
    for (struct Page* p = new_page; p != new_page + size; p++){
c0102e91:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
c0102e95:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102e98:	89 d0                	mov    %edx,%eax
c0102e9a:	c1 e0 02             	shl    $0x2,%eax
c0102e9d:	01 d0                	add    %edx,%eax
c0102e9f:	c1 e0 02             	shl    $0x2,%eax
c0102ea2:	89 c2                	mov    %eax,%edx
c0102ea4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ea7:	01 d0                	add    %edx,%eax
c0102ea9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102eac:	75 b6                	jne    c0102e64 <buddy_alloc_pages+0xe6>
    }
    // 更新上方节点
    index = PARENT(index);
c0102eae:	d1 6d f4             	shrl   -0xc(%ebp)
    while(index > 0){
c0102eb1:	eb 3b                	jmp    c0102eee <buddy_alloc_pages+0x170>
        buddy_page[index] = MAX(buddy_page[LEFT_CHILD(index)], buddy_page[RIGHT_CHILD(index)]);
c0102eb3:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0102eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ebc:	c1 e0 03             	shl    $0x3,%eax
c0102ebf:	83 c0 04             	add    $0x4,%eax
c0102ec2:	01 d0                	add    %edx,%eax
c0102ec4:	8b 10                	mov    (%eax),%edx
c0102ec6:	8b 0d 80 ee 11 c0    	mov    0xc011ee80,%ecx
c0102ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ecf:	c1 e0 03             	shl    $0x3,%eax
c0102ed2:	01 c8                	add    %ecx,%eax
c0102ed4:	8b 00                	mov    (%eax),%eax
c0102ed6:	8b 1d 80 ee 11 c0    	mov    0xc011ee80,%ebx
c0102edc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0102edf:	c1 e1 02             	shl    $0x2,%ecx
c0102ee2:	01 d9                	add    %ebx,%ecx
c0102ee4:	39 c2                	cmp    %eax,%edx
c0102ee6:	0f 43 c2             	cmovae %edx,%eax
c0102ee9:	89 01                	mov    %eax,(%ecx)
        index = PARENT(index);
c0102eeb:	d1 6d f4             	shrl   -0xc(%ebp)
    while(index > 0){
c0102eee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102ef2:	75 bf                	jne    c0102eb3 <buddy_alloc_pages+0x135>
    }
    // 返回分配到的page
    return new_page;
c0102ef4:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
c0102ef7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0102efa:	89 ec                	mov    %ebp,%esp
c0102efc:	5d                   	pop    %ebp
c0102efd:	c3                   	ret    

c0102efe <buddy_free_pages>:

static void
buddy_free_pages(struct Page *base, size_t n) {
c0102efe:	55                   	push   %ebp
c0102eff:	89 e5                	mov    %esp,%ebp
c0102f01:	83 ec 48             	sub    $0x48,%esp
c0102f04:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // 检查参数
    assert(n > 0);
c0102f07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102f0b:	75 24                	jne    c0102f31 <buddy_free_pages+0x33>
c0102f0d:	c7 44 24 0c 34 75 10 	movl   $0xc0107534,0xc(%esp)
c0102f14:	c0 
c0102f15:	c7 44 24 08 b8 74 10 	movl   $0xc01074b8,0x8(%esp)
c0102f1c:	c0 
c0102f1d:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0102f24:	00 
c0102f25:	c7 04 24 cd 74 10 c0 	movl   $0xc01074cd,(%esp)
c0102f2c:	e8 bc dd ff ff       	call   c0100ced <__panic>
    // 释放
    for (struct Page *p = base; p != base + n; p++) {
c0102f31:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f34:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f37:	e9 ad 00 00 00       	jmp    c0102fe9 <buddy_free_pages+0xeb>
        assert(!PageReserved(p) && !PageProperty(p));
c0102f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f3f:	83 c0 04             	add    $0x4,%eax
c0102f42:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0102f49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102f4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102f4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0102f52:	0f a3 10             	bt     %edx,(%eax)
c0102f55:	19 c0                	sbb    %eax,%eax
c0102f57:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c0102f5a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0102f5e:	0f 95 c0             	setne  %al
c0102f61:	0f b6 c0             	movzbl %al,%eax
c0102f64:	85 c0                	test   %eax,%eax
c0102f66:	75 2c                	jne    c0102f94 <buddy_free_pages+0x96>
c0102f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f6b:	83 c0 04             	add    $0x4,%eax
c0102f6e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c0102f75:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102f78:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102f7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f7e:	0f a3 10             	bt     %edx,(%eax)
c0102f81:	19 c0                	sbb    %eax,%eax
c0102f83:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
c0102f86:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0102f8a:	0f 95 c0             	setne  %al
c0102f8d:	0f b6 c0             	movzbl %al,%eax
c0102f90:	85 c0                	test   %eax,%eax
c0102f92:	74 24                	je     c0102fb8 <buddy_free_pages+0xba>
c0102f94:	c7 44 24 0c 3c 75 10 	movl   $0xc010753c,0xc(%esp)
c0102f9b:	c0 
c0102f9c:	c7 44 24 08 b8 74 10 	movl   $0xc01074b8,0x8(%esp)
c0102fa3:	c0 
c0102fa4:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0102fab:	00 
c0102fac:	c7 04 24 cd 74 10 c0 	movl   $0xc01074cd,(%esp)
c0102fb3:	e8 35 dd ff ff       	call   c0100ced <__panic>
        SetPageProperty(p);
c0102fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fbb:	83 c0 04             	add    $0x4,%eax
c0102fbe:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102fc5:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102fc8:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102fcb:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102fce:	0f ab 10             	bts    %edx,(%eax)
}
c0102fd1:	90                   	nop
        set_page_ref(p, 0);
c0102fd2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102fd9:	00 
c0102fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fdd:	89 04 24             	mov    %eax,(%esp)
c0102fe0:	e8 27 fb ff ff       	call   c0102b0c <set_page_ref>
    for (struct Page *p = base; p != base + n; p++) {
c0102fe5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102fe9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102fec:	89 d0                	mov    %edx,%eax
c0102fee:	c1 e0 02             	shl    $0x2,%eax
c0102ff1:	01 d0                	add    %edx,%eax
c0102ff3:	c1 e0 02             	shl    $0x2,%eax
c0102ff6:	89 c2                	mov    %eax,%edx
c0102ff8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ffb:	01 d0                	add    %edx,%eax
c0102ffd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103000:	0f 85 36 ff ff ff    	jne    c0102f3c <buddy_free_pages+0x3e>
    }
    // 维护
    unsigned int index = useable_page_num + (unsigned int)(base - useable_page_base), size = 1;
c0103006:	8b 15 8c ee 11 c0    	mov    0xc011ee8c,%edx
c010300c:	8b 45 08             	mov    0x8(%ebp),%eax
c010300f:	29 d0                	sub    %edx,%eax
c0103011:	c1 f8 02             	sar    $0x2,%eax
c0103014:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
c010301a:	89 c2                	mov    %eax,%edx
c010301c:	a1 88 ee 11 c0       	mov    0xc011ee88,%eax
c0103021:	01 d0                	add    %edx,%eax
c0103023:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103026:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
    while(buddy_page[index] > 0){
c010302d:	eb 06                	jmp    c0103035 <buddy_free_pages+0x137>
        index=PARENT(index);
c010302f:	d1 6d f0             	shrl   -0x10(%ebp)
        size <<= 1;
c0103032:	d1 65 ec             	shll   -0x14(%ebp)
    while(buddy_page[index] > 0){
c0103035:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c010303b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010303e:	c1 e0 02             	shl    $0x2,%eax
c0103041:	01 d0                	add    %edx,%eax
c0103043:	8b 00                	mov    (%eax),%eax
c0103045:	85 c0                	test   %eax,%eax
c0103047:	75 e6                	jne    c010302f <buddy_free_pages+0x131>
    }
    buddy_page[index] = size;
c0103049:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c010304f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103052:	c1 e0 02             	shl    $0x2,%eax
c0103055:	01 c2                	add    %eax,%edx
c0103057:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010305a:	89 02                	mov    %eax,(%edx)
    while((index = PARENT(index)) > 0){
c010305c:	eb 7a                	jmp    c01030d8 <buddy_free_pages+0x1da>
        size <<= 1;
c010305e:	d1 65 ec             	shll   -0x14(%ebp)
        if(buddy_page[LEFT_CHILD(index)] + buddy_page[RIGHT_CHILD(index)] == size){
c0103061:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0103067:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010306a:	c1 e0 03             	shl    $0x3,%eax
c010306d:	01 d0                	add    %edx,%eax
c010306f:	8b 10                	mov    (%eax),%edx
c0103071:	8b 0d 80 ee 11 c0    	mov    0xc011ee80,%ecx
c0103077:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010307a:	c1 e0 03             	shl    $0x3,%eax
c010307d:	83 c0 04             	add    $0x4,%eax
c0103080:	01 c8                	add    %ecx,%eax
c0103082:	8b 00                	mov    (%eax),%eax
c0103084:	01 d0                	add    %edx,%eax
c0103086:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103089:	75 15                	jne    c01030a0 <buddy_free_pages+0x1a2>
            buddy_page[index] = size;
c010308b:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c0103091:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103094:	c1 e0 02             	shl    $0x2,%eax
c0103097:	01 c2                	add    %eax,%edx
c0103099:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010309c:	89 02                	mov    %eax,(%edx)
c010309e:	eb 38                	jmp    c01030d8 <buddy_free_pages+0x1da>
        }
        else{
            buddy_page[index] = MAX(buddy_page[LEFT_CHILD(index)], buddy_page[RIGHT_CHILD(index)]);
c01030a0:	8b 15 80 ee 11 c0    	mov    0xc011ee80,%edx
c01030a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030a9:	c1 e0 03             	shl    $0x3,%eax
c01030ac:	83 c0 04             	add    $0x4,%eax
c01030af:	01 d0                	add    %edx,%eax
c01030b1:	8b 10                	mov    (%eax),%edx
c01030b3:	8b 0d 80 ee 11 c0    	mov    0xc011ee80,%ecx
c01030b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030bc:	c1 e0 03             	shl    $0x3,%eax
c01030bf:	01 c8                	add    %ecx,%eax
c01030c1:	8b 00                	mov    (%eax),%eax
c01030c3:	8b 1d 80 ee 11 c0    	mov    0xc011ee80,%ebx
c01030c9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01030cc:	c1 e1 02             	shl    $0x2,%ecx
c01030cf:	01 d9                	add    %ebx,%ecx
c01030d1:	39 c2                	cmp    %eax,%edx
c01030d3:	0f 43 c2             	cmovae %edx,%eax
c01030d6:	89 01                	mov    %eax,(%ecx)
    while((index = PARENT(index)) > 0){
c01030d8:	d1 6d f0             	shrl   -0x10(%ebp)
c01030db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01030df:	0f 85 79 ff ff ff    	jne    c010305e <buddy_free_pages+0x160>
        }
    }
}
c01030e5:	90                   	nop
c01030e6:	90                   	nop
c01030e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01030ea:	89 ec                	mov    %ebp,%esp
c01030ec:	5d                   	pop    %ebp
c01030ed:	c3                   	ret    

c01030ee <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void) {
c01030ee:	55                   	push   %ebp
c01030ef:	89 e5                	mov    %esp,%ebp
    return buddy_page[1];
c01030f1:	a1 80 ee 11 c0       	mov    0xc011ee80,%eax
c01030f6:	83 c0 04             	add    $0x4,%eax
c01030f9:	8b 00                	mov    (%eax),%eax
}
c01030fb:	5d                   	pop    %ebp
c01030fc:	c3                   	ret    

c01030fd <buddy_check>:

static void
buddy_check(void) {
c01030fd:	55                   	push   %ebp
c01030fe:	89 e5                	mov    %esp,%ebp
c0103100:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int all_pages = nr_free_pages();
c0103106:	e8 f9 1a 00 00       	call   c0104c04 <nr_free_pages>
c010310b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    struct Page* p0, *p1, *p2, *p3;
    // 分配过大的页数
    assert(alloc_pages(all_pages + 1) == NULL);
c010310e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103111:	40                   	inc    %eax
c0103112:	89 04 24             	mov    %eax,(%esp)
c0103115:	e8 7b 1a 00 00       	call   c0104b95 <alloc_pages>
c010311a:	85 c0                	test   %eax,%eax
c010311c:	74 24                	je     c0103142 <buddy_check+0x45>
c010311e:	c7 44 24 0c 64 75 10 	movl   $0xc0107564,0xc(%esp)
c0103125:	c0 
c0103126:	c7 44 24 08 b8 74 10 	movl   $0xc01074b8,0x8(%esp)
c010312d:	c0 
c010312e:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0103135:	00 
c0103136:	c7 04 24 cd 74 10 c0 	movl   $0xc01074cd,(%esp)
c010313d:	e8 ab db ff ff       	call   c0100ced <__panic>
    // 分配两个组页
    p0 = alloc_pages(1);
c0103142:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103149:	e8 47 1a 00 00       	call   c0104b95 <alloc_pages>
c010314e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(p0 != NULL);
c0103151:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103155:	75 24                	jne    c010317b <buddy_check+0x7e>
c0103157:	c7 44 24 0c 87 75 10 	movl   $0xc0107587,0xc(%esp)
c010315e:	c0 
c010315f:	c7 44 24 08 b8 74 10 	movl   $0xc01074b8,0x8(%esp)
c0103166:	c0 
c0103167:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
c010316e:	00 
c010316f:	c7 04 24 cd 74 10 c0 	movl   $0xc01074cd,(%esp)
c0103176:	e8 72 db ff ff       	call   c0100ced <__panic>
    p1 = alloc_pages(2);
c010317b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103182:	e8 0e 1a 00 00       	call   c0104b95 <alloc_pages>
c0103187:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(p1 == p0 + 2);
c010318a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010318d:	83 c0 28             	add    $0x28,%eax
c0103190:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103193:	74 24                	je     c01031b9 <buddy_check+0xbc>
c0103195:	c7 44 24 0c 92 75 10 	movl   $0xc0107592,0xc(%esp)
c010319c:	c0 
c010319d:	c7 44 24 08 b8 74 10 	movl   $0xc01074b8,0x8(%esp)
c01031a4:	c0 
c01031a5:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
c01031ac:	00 
c01031ad:	c7 04 24 cd 74 10 c0 	movl   $0xc01074cd,(%esp)
c01031b4:	e8 34 db ff ff       	call   c0100ced <__panic>
    assert(!PageReserved(p0) && !PageProperty(p0));
c01031b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031bc:	83 c0 04             	add    $0x4,%eax
c01031bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c01031c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01031c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01031cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01031cf:	0f a3 10             	bt     %edx,(%eax)
c01031d2:	19 c0                	sbb    %eax,%eax
c01031d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c01031d7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01031db:	0f 95 c0             	setne  %al
c01031de:	0f b6 c0             	movzbl %al,%eax
c01031e1:	85 c0                	test   %eax,%eax
c01031e3:	75 2c                	jne    c0103211 <buddy_check+0x114>
c01031e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031e8:	83 c0 04             	add    $0x4,%eax
c01031eb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c01031f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01031f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01031f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01031fb:	0f a3 10             	bt     %edx,(%eax)
c01031fe:	19 c0                	sbb    %eax,%eax
c0103200:	89 45 cc             	mov    %eax,-0x34(%ebp)
    return oldbit != 0;
c0103203:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103207:	0f 95 c0             	setne  %al
c010320a:	0f b6 c0             	movzbl %al,%eax
c010320d:	85 c0                	test   %eax,%eax
c010320f:	74 24                	je     c0103235 <buddy_check+0x138>
c0103211:	c7 44 24 0c a0 75 10 	movl   $0xc01075a0,0xc(%esp)
c0103218:	c0 
c0103219:	c7 44 24 08 b8 74 10 	movl   $0xc01074b8,0x8(%esp)
c0103220:	c0 
c0103221:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0103228:	00 
c0103229:	c7 04 24 cd 74 10 c0 	movl   $0xc01074cd,(%esp)
c0103230:	e8 b8 da ff ff       	call   c0100ced <__panic>
    assert(!PageReserved(p1) && !PageProperty(p1));
c0103235:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103238:	83 c0 04             	add    $0x4,%eax
c010323b:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
c0103242:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103245:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103248:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010324b:	0f a3 10             	bt     %edx,(%eax)
c010324e:	19 c0                	sbb    %eax,%eax
c0103250:	89 45 c0             	mov    %eax,-0x40(%ebp)
    return oldbit != 0;
c0103253:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0103257:	0f 95 c0             	setne  %al
c010325a:	0f b6 c0             	movzbl %al,%eax
c010325d:	85 c0                	test   %eax,%eax
c010325f:	75 2c                	jne    c010328d <buddy_check+0x190>
c0103261:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103264:	83 c0 04             	add    $0x4,%eax
c0103267:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c010326e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103271:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103274:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103277:	0f a3 10             	bt     %edx,(%eax)
c010327a:	19 c0                	sbb    %eax,%eax
c010327c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return oldbit != 0;
c010327f:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
c0103283:	0f 95 c0             	setne  %al
c0103286:	0f b6 c0             	movzbl %al,%eax
c0103289:	85 c0                	test   %eax,%eax
c010328b:	74 24                	je     c01032b1 <buddy_check+0x1b4>
c010328d:	c7 44 24 0c c8 75 10 	movl   $0xc01075c8,0xc(%esp)
c0103294:	c0 
c0103295:	c7 44 24 08 b8 74 10 	movl   $0xc01074b8,0x8(%esp)
c010329c:	c0 
c010329d:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
c01032a4:	00 
c01032a5:	c7 04 24 cd 74 10 c0 	movl   $0xc01074cd,(%esp)
c01032ac:	e8 3c da ff ff       	call   c0100ced <__panic>
    // 再分配两个组页
    p2 = alloc_pages(1);
c01032b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032b8:	e8 d8 18 00 00       	call   c0104b95 <alloc_pages>
c01032bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p2 == p0 + 1);
c01032c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032c3:	83 c0 14             	add    $0x14,%eax
c01032c6:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01032c9:	74 24                	je     c01032ef <buddy_check+0x1f2>
c01032cb:	c7 44 24 0c ef 75 10 	movl   $0xc01075ef,0xc(%esp)
c01032d2:	c0 
c01032d3:	c7 44 24 08 b8 74 10 	movl   $0xc01074b8,0x8(%esp)
c01032da:	c0 
c01032db:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c01032e2:	00 
c01032e3:	c7 04 24 cd 74 10 c0 	movl   $0xc01074cd,(%esp)
c01032ea:	e8 fe d9 ff ff       	call   c0100ced <__panic>
    p3 = alloc_pages(8);
c01032ef:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01032f6:	e8 9a 18 00 00       	call   c0104b95 <alloc_pages>
c01032fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p3 == p0 + 8);
c01032fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103301:	05 a0 00 00 00       	add    $0xa0,%eax
c0103306:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103309:	74 24                	je     c010332f <buddy_check+0x232>
c010330b:	c7 44 24 0c fc 75 10 	movl   $0xc01075fc,0xc(%esp)
c0103312:	c0 
c0103313:	c7 44 24 08 b8 74 10 	movl   $0xc01074b8,0x8(%esp)
c010331a:	c0 
c010331b:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0103322:	00 
c0103323:	c7 04 24 cd 74 10 c0 	movl   $0xc01074cd,(%esp)
c010332a:	e8 be d9 ff ff       	call   c0100ced <__panic>
    assert(!PageProperty(p3) && !PageProperty(p3 + 7) && PageProperty(p3 + 8));
c010332f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103332:	83 c0 04             	add    $0x4,%eax
c0103335:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c010333c:	89 45 ac             	mov    %eax,-0x54(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010333f:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103342:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0103345:	0f a3 10             	bt     %edx,(%eax)
c0103348:	19 c0                	sbb    %eax,%eax
c010334a:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c010334d:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c0103351:	0f 95 c0             	setne  %al
c0103354:	0f b6 c0             	movzbl %al,%eax
c0103357:	85 c0                	test   %eax,%eax
c0103359:	75 62                	jne    c01033bd <buddy_check+0x2c0>
c010335b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010335e:	05 8c 00 00 00       	add    $0x8c,%eax
c0103363:	83 c0 04             	add    $0x4,%eax
c0103366:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c010336d:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103370:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103373:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103376:	0f a3 10             	bt     %edx,(%eax)
c0103379:	19 c0                	sbb    %eax,%eax
c010337b:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return oldbit != 0;
c010337e:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
c0103382:	0f 95 c0             	setne  %al
c0103385:	0f b6 c0             	movzbl %al,%eax
c0103388:	85 c0                	test   %eax,%eax
c010338a:	75 31                	jne    c01033bd <buddy_check+0x2c0>
c010338c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010338f:	05 a0 00 00 00       	add    $0xa0,%eax
c0103394:	83 c0 04             	add    $0x4,%eax
c0103397:	c7 45 98 01 00 00 00 	movl   $0x1,-0x68(%ebp)
c010339e:	89 45 94             	mov    %eax,-0x6c(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01033a1:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01033a4:	8b 55 98             	mov    -0x68(%ebp),%edx
c01033a7:	0f a3 10             	bt     %edx,(%eax)
c01033aa:	19 c0                	sbb    %eax,%eax
c01033ac:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
c01033af:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
c01033b3:	0f 95 c0             	setne  %al
c01033b6:	0f b6 c0             	movzbl %al,%eax
c01033b9:	85 c0                	test   %eax,%eax
c01033bb:	75 24                	jne    c01033e1 <buddy_check+0x2e4>
c01033bd:	c7 44 24 0c 0c 76 10 	movl   $0xc010760c,0xc(%esp)
c01033c4:	c0 
c01033c5:	c7 44 24 08 b8 74 10 	movl   $0xc01074b8,0x8(%esp)
c01033cc:	c0 
c01033cd:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
c01033d4:	00 
c01033d5:	c7 04 24 cd 74 10 c0 	movl   $0xc01074cd,(%esp)
c01033dc:	e8 0c d9 ff ff       	call   c0100ced <__panic>
    // 回收页
    free_pages(p1, 2);
c01033e1:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01033e8:	00 
c01033e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033ec:	89 04 24             	mov    %eax,(%esp)
c01033ef:	e8 db 17 00 00       	call   c0104bcf <free_pages>
    assert(PageProperty(p1) && PageProperty(p1 + 1));
c01033f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033f7:	83 c0 04             	add    $0x4,%eax
c01033fa:	c7 45 8c 01 00 00 00 	movl   $0x1,-0x74(%ebp)
c0103401:	89 45 88             	mov    %eax,-0x78(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103404:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103407:	8b 55 8c             	mov    -0x74(%ebp),%edx
c010340a:	0f a3 10             	bt     %edx,(%eax)
c010340d:	19 c0                	sbb    %eax,%eax
c010340f:	89 45 84             	mov    %eax,-0x7c(%ebp)
    return oldbit != 0;
c0103412:	83 7d 84 00          	cmpl   $0x0,-0x7c(%ebp)
c0103416:	0f 95 c0             	setne  %al
c0103419:	0f b6 c0             	movzbl %al,%eax
c010341c:	85 c0                	test   %eax,%eax
c010341e:	74 3b                	je     c010345b <buddy_check+0x35e>
c0103420:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103423:	83 c0 14             	add    $0x14,%eax
c0103426:	83 c0 04             	add    $0x4,%eax
c0103429:	c7 45 80 01 00 00 00 	movl   $0x1,-0x80(%ebp)
c0103430:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103436:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c010343c:	8b 55 80             	mov    -0x80(%ebp),%edx
c010343f:	0f a3 10             	bt     %edx,(%eax)
c0103442:	19 c0                	sbb    %eax,%eax
c0103444:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
    return oldbit != 0;
c010344a:	83 bd 78 ff ff ff 00 	cmpl   $0x0,-0x88(%ebp)
c0103451:	0f 95 c0             	setne  %al
c0103454:	0f b6 c0             	movzbl %al,%eax
c0103457:	85 c0                	test   %eax,%eax
c0103459:	75 24                	jne    c010347f <buddy_check+0x382>
c010345b:	c7 44 24 0c 50 76 10 	movl   $0xc0107650,0xc(%esp)
c0103462:	c0 
c0103463:	c7 44 24 08 b8 74 10 	movl   $0xc01074b8,0x8(%esp)
c010346a:	c0 
c010346b:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c0103472:	00 
c0103473:	c7 04 24 cd 74 10 c0 	movl   $0xc01074cd,(%esp)
c010347a:	e8 6e d8 ff ff       	call   c0100ced <__panic>
    assert(p1->ref == 0);
c010347f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103482:	8b 00                	mov    (%eax),%eax
c0103484:	85 c0                	test   %eax,%eax
c0103486:	74 24                	je     c01034ac <buddy_check+0x3af>
c0103488:	c7 44 24 0c 79 76 10 	movl   $0xc0107679,0xc(%esp)
c010348f:	c0 
c0103490:	c7 44 24 08 b8 74 10 	movl   $0xc01074b8,0x8(%esp)
c0103497:	c0 
c0103498:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
c010349f:	00 
c01034a0:	c7 04 24 cd 74 10 c0 	movl   $0xc01074cd,(%esp)
c01034a7:	e8 41 d8 ff ff       	call   c0100ced <__panic>
    free_pages(p0, 1);
c01034ac:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01034b3:	00 
c01034b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034b7:	89 04 24             	mov    %eax,(%esp)
c01034ba:	e8 10 17 00 00       	call   c0104bcf <free_pages>
    free_pages(p2, 1);
c01034bf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01034c6:	00 
c01034c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034ca:	89 04 24             	mov    %eax,(%esp)
c01034cd:	e8 fd 16 00 00       	call   c0104bcf <free_pages>
    // 回收后再分配
    p2 = alloc_pages(3);
c01034d2:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01034d9:	e8 b7 16 00 00       	call   c0104b95 <alloc_pages>
c01034de:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p2 == p0);
c01034e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01034e7:	74 24                	je     c010350d <buddy_check+0x410>
c01034e9:	c7 44 24 0c 86 76 10 	movl   $0xc0107686,0xc(%esp)
c01034f0:	c0 
c01034f1:	c7 44 24 08 b8 74 10 	movl   $0xc01074b8,0x8(%esp)
c01034f8:	c0 
c01034f9:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
c0103500:	00 
c0103501:	c7 04 24 cd 74 10 c0 	movl   $0xc01074cd,(%esp)
c0103508:	e8 e0 d7 ff ff       	call   c0100ced <__panic>
    free_pages(p2, 3);
c010350d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103514:	00 
c0103515:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103518:	89 04 24             	mov    %eax,(%esp)
c010351b:	e8 af 16 00 00       	call   c0104bcf <free_pages>
    assert((p2 + 2)->ref == 0);
c0103520:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103523:	83 c0 28             	add    $0x28,%eax
c0103526:	8b 00                	mov    (%eax),%eax
c0103528:	85 c0                	test   %eax,%eax
c010352a:	74 24                	je     c0103550 <buddy_check+0x453>
c010352c:	c7 44 24 0c 8f 76 10 	movl   $0xc010768f,0xc(%esp)
c0103533:	c0 
c0103534:	c7 44 24 08 b8 74 10 	movl   $0xc01074b8,0x8(%esp)
c010353b:	c0 
c010353c:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0103543:	00 
c0103544:	c7 04 24 cd 74 10 c0 	movl   $0xc01074cd,(%esp)
c010354b:	e8 9d d7 ff ff       	call   c0100ced <__panic>
    assert(nr_free_pages() == all_pages >> 1);
c0103550:	e8 af 16 00 00       	call   c0104c04 <nr_free_pages>
c0103555:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103558:	d1 fa                	sar    %edx
c010355a:	39 d0                	cmp    %edx,%eax
c010355c:	74 24                	je     c0103582 <buddy_check+0x485>
c010355e:	c7 44 24 0c a4 76 10 	movl   $0xc01076a4,0xc(%esp)
c0103565:	c0 
c0103566:	c7 44 24 08 b8 74 10 	movl   $0xc01074b8,0x8(%esp)
c010356d:	c0 
c010356e:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
c0103575:	00 
c0103576:	c7 04 24 cd 74 10 c0 	movl   $0xc01074cd,(%esp)
c010357d:	e8 6b d7 ff ff       	call   c0100ced <__panic>

    p1 = alloc_pages(129);
c0103582:	c7 04 24 81 00 00 00 	movl   $0x81,(%esp)
c0103589:	e8 07 16 00 00       	call   c0104b95 <alloc_pages>
c010358e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(p1 == p0 + 256);
c0103591:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103594:	05 00 14 00 00       	add    $0x1400,%eax
c0103599:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010359c:	74 24                	je     c01035c2 <buddy_check+0x4c5>
c010359e:	c7 44 24 0c c6 76 10 	movl   $0xc01076c6,0xc(%esp)
c01035a5:	c0 
c01035a6:	c7 44 24 08 b8 74 10 	movl   $0xc01074b8,0x8(%esp)
c01035ad:	c0 
c01035ae:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c01035b5:	00 
c01035b6:	c7 04 24 cd 74 10 c0 	movl   $0xc01074cd,(%esp)
c01035bd:	e8 2b d7 ff ff       	call   c0100ced <__panic>
    free_pages(p1, 256);
c01035c2:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c01035c9:	00 
c01035ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035cd:	89 04 24             	mov    %eax,(%esp)
c01035d0:	e8 fa 15 00 00       	call   c0104bcf <free_pages>
    free_pages(p3, 8);
c01035d5:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
c01035dc:	00 
c01035dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035e0:	89 04 24             	mov    %eax,(%esp)
c01035e3:	e8 e7 15 00 00       	call   c0104bcf <free_pages>
}
c01035e8:	90                   	nop
c01035e9:	89 ec                	mov    %ebp,%esp
c01035eb:	5d                   	pop    %ebp
c01035ec:	c3                   	ret    

c01035ed <page2ppn>:
page2ppn(struct Page *page) {
c01035ed:	55                   	push   %ebp
c01035ee:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01035f0:	8b 15 a0 ee 11 c0    	mov    0xc011eea0,%edx
c01035f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01035f9:	29 d0                	sub    %edx,%eax
c01035fb:	c1 f8 02             	sar    $0x2,%eax
c01035fe:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103604:	5d                   	pop    %ebp
c0103605:	c3                   	ret    

c0103606 <page2pa>:
page2pa(struct Page *page) {
c0103606:	55                   	push   %ebp
c0103607:	89 e5                	mov    %esp,%ebp
c0103609:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010360c:	8b 45 08             	mov    0x8(%ebp),%eax
c010360f:	89 04 24             	mov    %eax,(%esp)
c0103612:	e8 d6 ff ff ff       	call   c01035ed <page2ppn>
c0103617:	c1 e0 0c             	shl    $0xc,%eax
}
c010361a:	89 ec                	mov    %ebp,%esp
c010361c:	5d                   	pop    %ebp
c010361d:	c3                   	ret    

c010361e <page_ref>:
page_ref(struct Page *page) {
c010361e:	55                   	push   %ebp
c010361f:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103621:	8b 45 08             	mov    0x8(%ebp),%eax
c0103624:	8b 00                	mov    (%eax),%eax
}
c0103626:	5d                   	pop    %ebp
c0103627:	c3                   	ret    

c0103628 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0103628:	55                   	push   %ebp
c0103629:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010362b:	8b 45 08             	mov    0x8(%ebp),%eax
c010362e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103631:	89 10                	mov    %edx,(%eax)
}
c0103633:	90                   	nop
c0103634:	5d                   	pop    %ebp
c0103635:	c3                   	ret    

c0103636 <default_init>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

// 初始化空闲内存*块*链表
static void
default_init(void) {
c0103636:	55                   	push   %ebp
c0103637:	89 e5                	mov    %esp,%ebp
c0103639:	83 ec 10             	sub    $0x10,%esp
c010363c:	c7 45 fc 90 ee 11 c0 	movl   $0xc011ee90,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103643:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103646:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103649:	89 50 04             	mov    %edx,0x4(%eax)
c010364c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010364f:	8b 50 04             	mov    0x4(%eax),%edx
c0103652:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103655:	89 10                	mov    %edx,(%eax)
}
c0103657:	90                   	nop
    // 对空闲内存块链表初始化
    list_init(&free_list);
    // 将总空闲数目置零
    nr_free = 0;
c0103658:	c7 05 98 ee 11 c0 00 	movl   $0x0,0xc011ee98
c010365f:	00 00 00 
}
c0103662:	90                   	nop
c0103663:	89 ec                	mov    %ebp,%esp
c0103665:	5d                   	pop    %ebp
c0103666:	c3                   	ret    

c0103667 <default_init_memmap>:

// 初始化*块*, 对其每一*页*进行初始化
static void
default_init_memmap(struct Page *base, size_t n) {
c0103667:	55                   	push   %ebp
c0103668:	89 e5                	mov    %esp,%ebp
c010366a:	83 ec 48             	sub    $0x48,%esp
    // 检查: 参数合法性
    assert(n > 0);
c010366d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103671:	75 24                	jne    c0103697 <default_init_memmap+0x30>
c0103673:	c7 44 24 0c 04 77 10 	movl   $0xc0107704,0xc(%esp)
c010367a:	c0 
c010367b:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0103682:	c0 
c0103683:	c7 44 24 04 72 00 00 	movl   $0x72,0x4(%esp)
c010368a:	00 
c010368b:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0103692:	e8 56 d6 ff ff       	call   c0100ced <__panic>
    // 初始化: 所有*页*
    // 遍历所有*页*
    struct Page *p = base;
c0103697:	8b 45 08             	mov    0x8(%ebp),%eax
c010369a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010369d:	e9 95 00 00 00       	jmp    c0103737 <default_init_memmap+0xd0>
        // 检查当前页是否是保留的
        assert(PageReserved(p));
c01036a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036a5:	83 c0 04             	add    $0x4,%eax
c01036a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01036af:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01036b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01036b8:	0f a3 10             	bt     %edx,(%eax)
c01036bb:	19 c0                	sbb    %eax,%eax
c01036bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01036c0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01036c4:	0f 95 c0             	setne  %al
c01036c7:	0f b6 c0             	movzbl %al,%eax
c01036ca:	85 c0                	test   %eax,%eax
c01036cc:	75 24                	jne    c01036f2 <default_init_memmap+0x8b>
c01036ce:	c7 44 24 0c 35 77 10 	movl   $0xc0107735,0xc(%esp)
c01036d5:	c0 
c01036d6:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c01036dd:	c0 
c01036de:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
c01036e5:	00 
c01036e6:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c01036ed:	e8 fb d5 ff ff       	call   c0100ced <__panic>
        // 标记位清空
        p->flags = 0;
c01036f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        // 空闲块数置零(即无效)
        p->property = 0;
c01036fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036ff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        // 清空引用计数
        set_page_ref(p, 0);
c0103706:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010370d:	00 
c010370e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103711:	89 04 24             	mov    %eax,(%esp)
c0103714:	e8 0f ff ff ff       	call   c0103628 <set_page_ref>
        // 启用property属性(即, 将页设为空闲)
        SetPageProperty(p);
c0103719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010371c:	83 c0 04             	add    $0x4,%eax
c010371f:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0103726:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103729:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010372c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010372f:	0f ab 10             	bts    %edx,(%eax)
}
c0103732:	90                   	nop
    for (; p != base + n; p ++) {
c0103733:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0103737:	8b 55 0c             	mov    0xc(%ebp),%edx
c010373a:	89 d0                	mov    %edx,%eax
c010373c:	c1 e0 02             	shl    $0x2,%eax
c010373f:	01 d0                	add    %edx,%eax
c0103741:	c1 e0 02             	shl    $0x2,%eax
c0103744:	89 c2                	mov    %eax,%edx
c0103746:	8b 45 08             	mov    0x8(%ebp),%eax
c0103749:	01 d0                	add    %edx,%eax
c010374b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010374e:	0f 85 4e ff ff ff    	jne    c01036a2 <default_init_memmap+0x3b>
    }
    // 初始化: 第一*页*
    // 当前块的空闲页数置为n(即, 设置当前块的大小为n, 单位为页)
    base->property = n;
c0103754:	8b 45 08             	mov    0x8(%ebp),%eax
c0103757:	8b 55 0c             	mov    0xc(%ebp),%edx
c010375a:	89 50 08             	mov    %edx,0x8(%eax)
    // 更新总空页数
    nr_free += n;
c010375d:	8b 15 98 ee 11 c0    	mov    0xc011ee98,%edx
c0103763:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103766:	01 d0                	add    %edx,%eax
c0103768:	a3 98 ee 11 c0       	mov    %eax,0xc011ee98
    // 将这个空闲*块*插入到空闲内存*块*链表的最后
    list_add_before(&free_list, &(base->page_link));
c010376d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103770:	83 c0 0c             	add    $0xc,%eax
c0103773:	c7 45 dc 90 ee 11 c0 	movl   $0xc011ee90,-0x24(%ebp)
c010377a:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010377d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103780:	8b 00                	mov    (%eax),%eax
c0103782:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103785:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103788:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010378b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010378e:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103791:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103794:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103797:	89 10                	mov    %edx,(%eax)
c0103799:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010379c:	8b 10                	mov    (%eax),%edx
c010379e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01037a1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01037a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01037a7:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01037aa:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01037ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01037b0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01037b3:	89 10                	mov    %edx,(%eax)
}
c01037b5:	90                   	nop
}
c01037b6:	90                   	nop
}
c01037b7:	90                   	nop
c01037b8:	89 ec                	mov    %ebp,%esp
c01037ba:	5d                   	pop    %ebp
c01037bb:	c3                   	ret    

c01037bc <default_alloc_pages>:

// 分配指定页数的连续空闲物理空间, 并且返回分配到的首页指针
static struct Page *
default_alloc_pages(size_t n) {
c01037bc:	55                   	push   %ebp
c01037bd:	89 e5                	mov    %esp,%ebp
c01037bf:	83 ec 68             	sub    $0x68,%esp
    // 检查: 参数合法性
    assert(n > 0);
c01037c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01037c6:	75 24                	jne    c01037ec <default_alloc_pages+0x30>
c01037c8:	c7 44 24 0c 04 77 10 	movl   $0xc0107704,0xc(%esp)
c01037cf:	c0 
c01037d0:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c01037d7:	c0 
c01037d8:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
c01037df:	00 
c01037e0:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c01037e7:	e8 01 d5 ff ff       	call   c0100ced <__panic>
    // 检查: 总的空闲物理页数目是否足够, 不够则返回NULL(分配失败)
    if (n > nr_free) {
c01037ec:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c01037f1:	39 45 08             	cmp    %eax,0x8(%ebp)
c01037f4:	76 0a                	jbe    c0103800 <default_alloc_pages+0x44>
        return NULL;
c01037f6:	b8 00 00 00 00       	mov    $0x0,%eax
c01037fb:	e9 5d 01 00 00       	jmp    c010395d <default_alloc_pages+0x1a1>
    }
    // 查找: 符合的块
    struct Page *page = NULL;
c0103800:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103807:	c7 45 e0 90 ee 11 c0 	movl   $0xc011ee90,-0x20(%ebp)
    return listelm->next;
c010380e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103811:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0103814:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 按照物理地址的从小到大顺序遍历空闲内存*块*链表
    while (le != &free_list) {
c0103817:	eb 2b                	jmp    c0103844 <default_alloc_pages+0x88>
        struct Page *p = le2page(le, page_link);
c0103819:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010381c:	83 e8 0c             	sub    $0xc,%eax
c010381f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        // 如果找到第一个不小于需要的大小连续内存块, 则成功分配
        if (p->property >= n) {
c0103822:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103825:	8b 40 08             	mov    0x8(%eax),%eax
c0103828:	39 45 08             	cmp    %eax,0x8(%ebp)
c010382b:	77 08                	ja     c0103835 <default_alloc_pages+0x79>
            page = p;
c010382d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103830:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0103833:	eb 18                	jmp    c010384d <default_alloc_pages+0x91>
c0103835:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103838:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010383b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010383e:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le = list_next(le);
c0103841:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0103844:	81 7d f0 90 ee 11 c0 	cmpl   $0xc011ee90,-0x10(%ebp)
c010384b:	75 cc                	jne    c0103819 <default_alloc_pages+0x5d>
    }
    // 处理:
    if (page != NULL) {
c010384d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103851:	0f 84 03 01 00 00    	je     c010395a <default_alloc_pages+0x19e>
        // 该内存块的大小大于需要的内存大小, 将空闲内存块分裂成两块
        if (page->property > n) {
c0103857:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010385a:	8b 40 08             	mov    0x8(%eax),%eax
c010385d:	39 45 08             	cmp    %eax,0x8(%ebp)
c0103860:	73 75                	jae    c01038d7 <default_alloc_pages+0x11b>
            // 放回 物理地址较大的块
            struct Page *p = page + n;
c0103862:	8b 55 08             	mov    0x8(%ebp),%edx
c0103865:	89 d0                	mov    %edx,%eax
c0103867:	c1 e0 02             	shl    $0x2,%eax
c010386a:	01 d0                	add    %edx,%eax
c010386c:	c1 e0 02             	shl    $0x2,%eax
c010386f:	89 c2                	mov    %eax,%edx
c0103871:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103874:	01 d0                	add    %edx,%eax
c0103876:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            // 重新进行初始化
            p->property = page->property - n;
c0103879:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010387c:	8b 40 08             	mov    0x8(%eax),%eax
c010387f:	2b 45 08             	sub    0x8(%ebp),%eax
c0103882:	89 c2                	mov    %eax,%edx
c0103884:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103887:	89 50 08             	mov    %edx,0x8(%eax)
            // 插入到原块之后
            list_add_after(&(page->page_link), &(p->page_link));
c010388a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010388d:	83 c0 0c             	add    $0xc,%eax
c0103890:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103893:	83 c2 0c             	add    $0xc,%edx
c0103896:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0103899:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c010389c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010389f:	8b 40 04             	mov    0x4(%eax),%eax
c01038a2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01038a5:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01038a8:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01038ab:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01038ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c01038b1:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01038b4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01038b7:	89 10                	mov    %edx,(%eax)
c01038b9:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01038bc:	8b 10                	mov    (%eax),%edx
c01038be:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01038c1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01038c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01038c7:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01038ca:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01038cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01038d0:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01038d3:	89 10                	mov    %edx,(%eax)
}
c01038d5:	90                   	nop
}
c01038d6:	90                   	nop
        }
        // 取用 取到的块 或 分裂出来物理地址较小的块
        // 设为非空闲
        for (struct Page *p = page; p != page + n; p++) {
c01038d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038da:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01038dd:	eb 1e                	jmp    c01038fd <default_alloc_pages+0x141>
            ClearPageProperty(p);
c01038df:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038e2:	83 c0 04             	add    $0x4,%eax
c01038e5:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c01038ec:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01038ef:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01038f2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01038f5:	0f b3 10             	btr    %edx,(%eax)
}
c01038f8:	90                   	nop
        for (struct Page *p = page; p != page + n; p++) {
c01038f9:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
c01038fd:	8b 55 08             	mov    0x8(%ebp),%edx
c0103900:	89 d0                	mov    %edx,%eax
c0103902:	c1 e0 02             	shl    $0x2,%eax
c0103905:	01 d0                	add    %edx,%eax
c0103907:	c1 e0 02             	shl    $0x2,%eax
c010390a:	89 c2                	mov    %eax,%edx
c010390c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010390f:	01 d0                	add    %edx,%eax
c0103911:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103914:	75 c9                	jne    c01038df <default_alloc_pages+0x123>
        }
        // 从链表中取出
        list_del(&(page->page_link));
c0103916:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103919:	83 c0 0c             	add    $0xc,%eax
c010391c:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c010391f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103922:	8b 40 04             	mov    0x4(%eax),%eax
c0103925:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103928:	8b 12                	mov    (%edx),%edx
c010392a:	89 55 b8             	mov    %edx,-0x48(%ebp)
c010392d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103930:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103933:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103936:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103939:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010393c:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010393f:	89 10                	mov    %edx,(%eax)
}
c0103941:	90                   	nop
}
c0103942:	90                   	nop
        page->property = 0;
c0103943:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103946:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        // 更新总空页数
        nr_free -= n;
c010394d:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c0103952:	2b 45 08             	sub    0x8(%ebp),%eax
c0103955:	a3 98 ee 11 c0       	mov    %eax,0xc011ee98
    }
    //返回: 分配到的页指针
    return page;
c010395a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010395d:	89 ec                	mov    %ebp,%esp
c010395f:	5d                   	pop    %ebp
c0103960:	c3                   	ret    

c0103961 <default_free_pages>:

// 释放指定的某一物理页开始的若干个连续物理页，并完成first-fit算法中需要信息的维护
static void
default_free_pages(struct Page *base, size_t n) {
c0103961:	55                   	push   %ebp
c0103962:	89 e5                	mov    %esp,%ebp
c0103964:	81 ec 98 00 00 00    	sub    $0x98,%esp
    // 检查: 参数合法性
    assert(n > 0);
c010396a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010396e:	75 24                	jne    c0103994 <default_free_pages+0x33>
c0103970:	c7 44 24 0c 04 77 10 	movl   $0xc0107704,0xc(%esp)
c0103977:	c0 
c0103978:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c010397f:	c0 
c0103980:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0103987:	00 
c0103988:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c010398f:	e8 59 d3 ff ff       	call   c0100ced <__panic>
    // 检查: 所有页 是否是保留的 或 原本就是空闲的
    struct Page *p = base, *p_next = NULL;
c0103994:	8b 45 08             	mov    0x8(%ebp),%eax
c0103997:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010399a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (; p != base + n; p++) {
c01039a1:	e9 c1 00 00 00       	jmp    c0103a67 <default_free_pages+0x106>
        assert(!PageReserved(p) && !PageProperty(p));
c01039a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039a9:	83 c0 04             	add    $0x4,%eax
c01039ac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c01039b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01039b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01039b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01039bc:	0f a3 10             	bt     %edx,(%eax)
c01039bf:	19 c0                	sbb    %eax,%eax
c01039c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c01039c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01039c8:	0f 95 c0             	setne  %al
c01039cb:	0f b6 c0             	movzbl %al,%eax
c01039ce:	85 c0                	test   %eax,%eax
c01039d0:	75 2c                	jne    c01039fe <default_free_pages+0x9d>
c01039d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039d5:	83 c0 04             	add    $0x4,%eax
c01039d8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c01039df:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01039e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01039e5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01039e8:	0f a3 10             	bt     %edx,(%eax)
c01039eb:	19 c0                	sbb    %eax,%eax
c01039ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
c01039f0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01039f4:	0f 95 c0             	setne  %al
c01039f7:	0f b6 c0             	movzbl %al,%eax
c01039fa:	85 c0                	test   %eax,%eax
c01039fc:	74 24                	je     c0103a22 <default_free_pages+0xc1>
c01039fe:	c7 44 24 0c 48 77 10 	movl   $0xc0107748,0xc(%esp)
c0103a05:	c0 
c0103a06:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0103a0d:	c0 
c0103a0e:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0103a15:	00 
c0103a16:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0103a1d:	e8 cb d2 ff ff       	call   c0100ced <__panic>
        // 清空标志位
        p->flags = 0;
c0103a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        // 恢复为空闲状态
        SetPageProperty(p);
c0103a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a2f:	83 c0 04             	add    $0x4,%eax
c0103a32:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103a39:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103a3c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103a3f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103a42:	0f ab 10             	bts    %edx,(%eax)
}
c0103a45:	90                   	nop
        // 清空引用计数
        set_page_ref(p, 0);
c0103a46:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103a4d:	00 
c0103a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a51:	89 04 24             	mov    %eax,(%esp)
c0103a54:	e8 cf fb ff ff       	call   c0103628 <set_page_ref>
        p->property = 0;
c0103a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a5c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    for (; p != base + n; p++) {
c0103a63:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0103a67:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103a6a:	89 d0                	mov    %edx,%eax
c0103a6c:	c1 e0 02             	shl    $0x2,%eax
c0103a6f:	01 d0                	add    %edx,%eax
c0103a71:	c1 e0 02             	shl    $0x2,%eax
c0103a74:	89 c2                	mov    %eax,%edx
c0103a76:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a79:	01 d0                	add    %edx,%eax
c0103a7b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103a7e:	0f 85 22 ff ff ff    	jne    c01039a6 <default_free_pages+0x45>
    }
    // 恢复:
    // 标记该空闲块大小
    base->property = n;
c0103a84:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a87:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103a8a:	89 50 08             	mov    %edx,0x8(%eax)
c0103a8d:	c7 45 c8 90 ee 11 c0 	movl   $0xc011ee90,-0x38(%ebp)
    return listelm->next;
c0103a94:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103a97:	8b 40 04             	mov    0x4(%eax),%eax
    // 顺序遍历. 找到恰好大于该块位置的空块
    list_entry_t *le = list_next(&free_list);
c0103a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(le != &free_list && le < &(base->page_link)){
c0103a9d:	eb 0f                	jmp    c0103aae <default_free_pages+0x14d>
c0103a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103aa2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0103aa5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103aa8:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0103aab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(le != &free_list && le < &(base->page_link)){
c0103aae:	81 7d f0 90 ee 11 c0 	cmpl   $0xc011ee90,-0x10(%ebp)
c0103ab5:	74 0b                	je     c0103ac2 <default_free_pages+0x161>
c0103ab7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aba:	83 c0 0c             	add    $0xc,%eax
c0103abd:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103ac0:	72 dd                	jb     c0103a9f <default_free_pages+0x13e>
    }
    // 插入到块链表中
    list_add_before(le,&(base->page_link));
c0103ac2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ac5:	8d 50 0c             	lea    0xc(%eax),%edx
c0103ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103acb:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0103ace:	89 55 b8             	mov    %edx,-0x48(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0103ad1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103ad4:	8b 00                	mov    (%eax),%eax
c0103ad6:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0103ad9:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c0103adc:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103adf:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103ae2:	89 45 ac             	mov    %eax,-0x54(%ebp)
    prev->next = next->prev = elm;
c0103ae5:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103ae8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103aeb:	89 10                	mov    %edx,(%eax)
c0103aed:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103af0:	8b 10                	mov    (%eax),%edx
c0103af2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103af5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103af8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103afb:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103afe:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103b01:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103b04:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0103b07:	89 10                	mov    %edx,(%eax)
}
c0103b09:	90                   	nop
}
c0103b0a:	90                   	nop
    // 更新总空页数
    nr_free += n;
c0103b0b:	8b 15 98 ee 11 c0    	mov    0xc011ee98,%edx
c0103b11:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103b14:	01 d0                	add    %edx,%eax
c0103b16:	a3 98 ee 11 c0       	mov    %eax,0xc011ee98
    // 合并:
    // 不是最后一个块, 向后合并
    for(le = list_next(&(base->page_link));
c0103b1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b1e:	83 c0 0c             	add    $0xc,%eax
c0103b21:	89 45 c0             	mov    %eax,-0x40(%ebp)
    return listelm->next;
c0103b24:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103b27:	8b 40 04             	mov    0x4(%eax),%eax
c0103b2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b2d:	eb 7f                	jmp    c0103bae <default_free_pages+0x24d>
        le != &free_list;
        le = list_next(&(base->page_link))){
        p = le2page(le, page_link);
c0103b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b32:	83 e8 0c             	sub    $0xc,%eax
c0103b35:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // 后一个空闲块 不相邻就退出, 相邻就继续合并
        if(base + base->property != p)
c0103b38:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b3b:	8b 50 08             	mov    0x8(%eax),%edx
c0103b3e:	89 d0                	mov    %edx,%eax
c0103b40:	c1 e0 02             	shl    $0x2,%eax
c0103b43:	01 d0                	add    %edx,%eax
c0103b45:	c1 e0 02             	shl    $0x2,%eax
c0103b48:	89 c2                	mov    %eax,%edx
c0103b4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b4d:	01 d0                	add    %edx,%eax
c0103b4f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103b52:	75 69                	jne    c0103bbd <default_free_pages+0x25c>
            break;
        base->property += p->property;
c0103b54:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b57:	8b 50 08             	mov    0x8(%eax),%edx
c0103b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b5d:	8b 40 08             	mov    0x8(%eax),%eax
c0103b60:	01 c2                	add    %eax,%edx
c0103b62:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b65:	89 50 08             	mov    %edx,0x8(%eax)
        p->property = 0;
c0103b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b6b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0103b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b75:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0103b78:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103b7b:	8b 40 04             	mov    0x4(%eax),%eax
c0103b7e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103b81:	8b 12                	mov    (%edx),%edx
c0103b83:	89 55 a0             	mov    %edx,-0x60(%ebp)
c0103b86:	89 45 9c             	mov    %eax,-0x64(%ebp)
    prev->next = next;
c0103b89:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103b8c:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0103b8f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103b92:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103b95:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103b98:	89 10                	mov    %edx,(%eax)
}
c0103b9a:	90                   	nop
}
c0103b9b:	90                   	nop
        le = list_next(&(base->page_link))){
c0103b9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b9f:	83 c0 0c             	add    $0xc,%eax
c0103ba2:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return listelm->next;
c0103ba5:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103ba8:	8b 40 04             	mov    0x4(%eax),%eax
c0103bab:	89 45 f0             	mov    %eax,-0x10(%ebp)
        le != &free_list;
c0103bae:	81 7d f0 90 ee 11 c0 	cmpl   $0xc011ee90,-0x10(%ebp)
c0103bb5:	0f 85 74 ff ff ff    	jne    c0103b2f <default_free_pages+0x1ce>
c0103bbb:	eb 01                	jmp    c0103bbe <default_free_pages+0x25d>
            break;
c0103bbd:	90                   	nop
        list_del(le);
    }
    // 不是第一个块, 向前合并
    for(le = list_prev(&(base->page_link));
c0103bbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bc1:	83 c0 0c             	add    $0xc,%eax
c0103bc4:	89 45 98             	mov    %eax,-0x68(%ebp)
    return listelm->prev;
c0103bc7:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103bca:	8b 00                	mov    (%eax),%eax
c0103bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103bcf:	e9 90 00 00 00       	jmp    c0103c64 <default_free_pages+0x303>
        le != &free_list;
        le = list_prev(le)){
        p = le2page(le, page_link);
c0103bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bd7:	83 e8 0c             	sub    $0xc,%eax
c0103bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103be0:	89 45 94             	mov    %eax,-0x6c(%ebp)
    return listelm->next;
c0103be3:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0103be6:	8b 40 04             	mov    0x4(%eax),%eax
        p_next = le2page(list_next(le), page_link);
c0103be9:	83 e8 0c             	sub    $0xc,%eax
c0103bec:	89 45 ec             	mov    %eax,-0x14(%ebp)
        // 前一个空闲块 不相邻就退出, 相邻就继续合并
        if(p + p->property != p_next)
c0103bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bf2:	8b 50 08             	mov    0x8(%eax),%edx
c0103bf5:	89 d0                	mov    %edx,%eax
c0103bf7:	c1 e0 02             	shl    $0x2,%eax
c0103bfa:	01 d0                	add    %edx,%eax
c0103bfc:	c1 e0 02             	shl    $0x2,%eax
c0103bff:	89 c2                	mov    %eax,%edx
c0103c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c04:	01 d0                	add    %edx,%eax
c0103c06:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103c09:	75 68                	jne    c0103c73 <default_free_pages+0x312>
            break;
        p->property += p_next->property;
c0103c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c0e:	8b 50 08             	mov    0x8(%eax),%edx
c0103c11:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c14:	8b 40 08             	mov    0x8(%eax),%eax
c0103c17:	01 c2                	add    %eax,%edx
c0103c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c1c:	89 50 08             	mov    %edx,0x8(%eax)
        p_next->property = 0;
c0103c1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        list_del(&(p_next->page_link));
c0103c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c2c:	83 c0 0c             	add    $0xc,%eax
c0103c2f:	89 45 8c             	mov    %eax,-0x74(%ebp)
    __list_del(listelm->prev, listelm->next);
c0103c32:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103c35:	8b 40 04             	mov    0x4(%eax),%eax
c0103c38:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0103c3b:	8b 12                	mov    (%edx),%edx
c0103c3d:	89 55 88             	mov    %edx,-0x78(%ebp)
c0103c40:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next;
c0103c43:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103c46:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103c49:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103c4c:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0103c4f:	8b 55 88             	mov    -0x78(%ebp),%edx
c0103c52:	89 10                	mov    %edx,(%eax)
}
c0103c54:	90                   	nop
}
c0103c55:	90                   	nop
c0103c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c59:	89 45 90             	mov    %eax,-0x70(%ebp)
    return listelm->prev;
c0103c5c:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103c5f:	8b 00                	mov    (%eax),%eax
        le = list_prev(le)){
c0103c61:	89 45 f0             	mov    %eax,-0x10(%ebp)
        le != &free_list;
c0103c64:	81 7d f0 90 ee 11 c0 	cmpl   $0xc011ee90,-0x10(%ebp)
c0103c6b:	0f 85 63 ff ff ff    	jne    c0103bd4 <default_free_pages+0x273>
    }
}
c0103c71:	eb 01                	jmp    c0103c74 <default_free_pages+0x313>
            break;
c0103c73:	90                   	nop
}
c0103c74:	90                   	nop
c0103c75:	89 ec                	mov    %ebp,%esp
c0103c77:	5d                   	pop    %ebp
c0103c78:	c3                   	ret    

c0103c79 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0103c79:	55                   	push   %ebp
c0103c7a:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103c7c:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
}
c0103c81:	5d                   	pop    %ebp
c0103c82:	c3                   	ret    

c0103c83 <basic_check>:

static void
basic_check(void) {
c0103c83:	55                   	push   %ebp
c0103c84:	89 e5                	mov    %esp,%ebp
c0103c86:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0103c89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c93:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c96:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c99:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103c9c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ca3:	e8 ed 0e 00 00       	call   c0104b95 <alloc_pages>
c0103ca8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103cab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103caf:	75 24                	jne    c0103cd5 <basic_check+0x52>
c0103cb1:	c7 44 24 0c 6d 77 10 	movl   $0xc010776d,0xc(%esp)
c0103cb8:	c0 
c0103cb9:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0103cc0:	c0 
c0103cc1:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0103cc8:	00 
c0103cc9:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0103cd0:	e8 18 d0 ff ff       	call   c0100ced <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103cd5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103cdc:	e8 b4 0e 00 00       	call   c0104b95 <alloc_pages>
c0103ce1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103ce4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103ce8:	75 24                	jne    c0103d0e <basic_check+0x8b>
c0103cea:	c7 44 24 0c 89 77 10 	movl   $0xc0107789,0xc(%esp)
c0103cf1:	c0 
c0103cf2:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0103cf9:	c0 
c0103cfa:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0103d01:	00 
c0103d02:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0103d09:	e8 df cf ff ff       	call   c0100ced <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103d0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d15:	e8 7b 0e 00 00       	call   c0104b95 <alloc_pages>
c0103d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103d1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103d21:	75 24                	jne    c0103d47 <basic_check+0xc4>
c0103d23:	c7 44 24 0c a5 77 10 	movl   $0xc01077a5,0xc(%esp)
c0103d2a:	c0 
c0103d2b:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0103d32:	c0 
c0103d33:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0103d3a:	00 
c0103d3b:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0103d42:	e8 a6 cf ff ff       	call   c0100ced <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d4a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103d4d:	74 10                	je     c0103d5f <basic_check+0xdc>
c0103d4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d52:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103d55:	74 08                	je     c0103d5f <basic_check+0xdc>
c0103d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d5a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103d5d:	75 24                	jne    c0103d83 <basic_check+0x100>
c0103d5f:	c7 44 24 0c c4 77 10 	movl   $0xc01077c4,0xc(%esp)
c0103d66:	c0 
c0103d67:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0103d6e:	c0 
c0103d6f:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0103d76:	00 
c0103d77:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0103d7e:	e8 6a cf ff ff       	call   c0100ced <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103d83:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d86:	89 04 24             	mov    %eax,(%esp)
c0103d89:	e8 90 f8 ff ff       	call   c010361e <page_ref>
c0103d8e:	85 c0                	test   %eax,%eax
c0103d90:	75 1e                	jne    c0103db0 <basic_check+0x12d>
c0103d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d95:	89 04 24             	mov    %eax,(%esp)
c0103d98:	e8 81 f8 ff ff       	call   c010361e <page_ref>
c0103d9d:	85 c0                	test   %eax,%eax
c0103d9f:	75 0f                	jne    c0103db0 <basic_check+0x12d>
c0103da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103da4:	89 04 24             	mov    %eax,(%esp)
c0103da7:	e8 72 f8 ff ff       	call   c010361e <page_ref>
c0103dac:	85 c0                	test   %eax,%eax
c0103dae:	74 24                	je     c0103dd4 <basic_check+0x151>
c0103db0:	c7 44 24 0c e8 77 10 	movl   $0xc01077e8,0xc(%esp)
c0103db7:	c0 
c0103db8:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0103dbf:	c0 
c0103dc0:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0103dc7:	00 
c0103dc8:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0103dcf:	e8 19 cf ff ff       	call   c0100ced <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103dd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103dd7:	89 04 24             	mov    %eax,(%esp)
c0103dda:	e8 27 f8 ff ff       	call   c0103606 <page2pa>
c0103ddf:	8b 15 a4 ee 11 c0    	mov    0xc011eea4,%edx
c0103de5:	c1 e2 0c             	shl    $0xc,%edx
c0103de8:	39 d0                	cmp    %edx,%eax
c0103dea:	72 24                	jb     c0103e10 <basic_check+0x18d>
c0103dec:	c7 44 24 0c 24 78 10 	movl   $0xc0107824,0xc(%esp)
c0103df3:	c0 
c0103df4:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0103dfb:	c0 
c0103dfc:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0103e03:	00 
c0103e04:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0103e0b:	e8 dd ce ff ff       	call   c0100ced <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e13:	89 04 24             	mov    %eax,(%esp)
c0103e16:	e8 eb f7 ff ff       	call   c0103606 <page2pa>
c0103e1b:	8b 15 a4 ee 11 c0    	mov    0xc011eea4,%edx
c0103e21:	c1 e2 0c             	shl    $0xc,%edx
c0103e24:	39 d0                	cmp    %edx,%eax
c0103e26:	72 24                	jb     c0103e4c <basic_check+0x1c9>
c0103e28:	c7 44 24 0c 41 78 10 	movl   $0xc0107841,0xc(%esp)
c0103e2f:	c0 
c0103e30:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0103e37:	c0 
c0103e38:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c0103e3f:	00 
c0103e40:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0103e47:	e8 a1 ce ff ff       	call   c0100ced <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e4f:	89 04 24             	mov    %eax,(%esp)
c0103e52:	e8 af f7 ff ff       	call   c0103606 <page2pa>
c0103e57:	8b 15 a4 ee 11 c0    	mov    0xc011eea4,%edx
c0103e5d:	c1 e2 0c             	shl    $0xc,%edx
c0103e60:	39 d0                	cmp    %edx,%eax
c0103e62:	72 24                	jb     c0103e88 <basic_check+0x205>
c0103e64:	c7 44 24 0c 5e 78 10 	movl   $0xc010785e,0xc(%esp)
c0103e6b:	c0 
c0103e6c:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0103e73:	c0 
c0103e74:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c0103e7b:	00 
c0103e7c:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0103e83:	e8 65 ce ff ff       	call   c0100ced <__panic>

    list_entry_t free_list_store = free_list;
c0103e88:	a1 90 ee 11 c0       	mov    0xc011ee90,%eax
c0103e8d:	8b 15 94 ee 11 c0    	mov    0xc011ee94,%edx
c0103e93:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103e96:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103e99:	c7 45 dc 90 ee 11 c0 	movl   $0xc011ee90,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0103ea0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103ea3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ea6:	89 50 04             	mov    %edx,0x4(%eax)
c0103ea9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103eac:	8b 50 04             	mov    0x4(%eax),%edx
c0103eaf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103eb2:	89 10                	mov    %edx,(%eax)
}
c0103eb4:	90                   	nop
c0103eb5:	c7 45 e0 90 ee 11 c0 	movl   $0xc011ee90,-0x20(%ebp)
    return list->next == list;
c0103ebc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ebf:	8b 40 04             	mov    0x4(%eax),%eax
c0103ec2:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103ec5:	0f 94 c0             	sete   %al
c0103ec8:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103ecb:	85 c0                	test   %eax,%eax
c0103ecd:	75 24                	jne    c0103ef3 <basic_check+0x270>
c0103ecf:	c7 44 24 0c 7b 78 10 	movl   $0xc010787b,0xc(%esp)
c0103ed6:	c0 
c0103ed7:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0103ede:	c0 
c0103edf:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0103ee6:	00 
c0103ee7:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0103eee:	e8 fa cd ff ff       	call   c0100ced <__panic>

    unsigned int nr_free_store = nr_free;
c0103ef3:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c0103ef8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103efb:	c7 05 98 ee 11 c0 00 	movl   $0x0,0xc011ee98
c0103f02:	00 00 00 

    assert(alloc_page() == NULL);
c0103f05:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f0c:	e8 84 0c 00 00       	call   c0104b95 <alloc_pages>
c0103f11:	85 c0                	test   %eax,%eax
c0103f13:	74 24                	je     c0103f39 <basic_check+0x2b6>
c0103f15:	c7 44 24 0c 92 78 10 	movl   $0xc0107892,0xc(%esp)
c0103f1c:	c0 
c0103f1d:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0103f24:	c0 
c0103f25:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c0103f2c:	00 
c0103f2d:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0103f34:	e8 b4 cd ff ff       	call   c0100ced <__panic>

    free_page(p0);
c0103f39:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f40:	00 
c0103f41:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f44:	89 04 24             	mov    %eax,(%esp)
c0103f47:	e8 83 0c 00 00       	call   c0104bcf <free_pages>
    free_page(p1);
c0103f4c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f53:	00 
c0103f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f57:	89 04 24             	mov    %eax,(%esp)
c0103f5a:	e8 70 0c 00 00       	call   c0104bcf <free_pages>
    free_page(p2);
c0103f5f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f66:	00 
c0103f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f6a:	89 04 24             	mov    %eax,(%esp)
c0103f6d:	e8 5d 0c 00 00       	call   c0104bcf <free_pages>
    assert(nr_free == 3);
c0103f72:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c0103f77:	83 f8 03             	cmp    $0x3,%eax
c0103f7a:	74 24                	je     c0103fa0 <basic_check+0x31d>
c0103f7c:	c7 44 24 0c a7 78 10 	movl   $0xc01078a7,0xc(%esp)
c0103f83:	c0 
c0103f84:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0103f8b:	c0 
c0103f8c:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0103f93:	00 
c0103f94:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0103f9b:	e8 4d cd ff ff       	call   c0100ced <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103fa0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103fa7:	e8 e9 0b 00 00       	call   c0104b95 <alloc_pages>
c0103fac:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103faf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103fb3:	75 24                	jne    c0103fd9 <basic_check+0x356>
c0103fb5:	c7 44 24 0c 6d 77 10 	movl   $0xc010776d,0xc(%esp)
c0103fbc:	c0 
c0103fbd:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0103fc4:	c0 
c0103fc5:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0103fcc:	00 
c0103fcd:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0103fd4:	e8 14 cd ff ff       	call   c0100ced <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103fd9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103fe0:	e8 b0 0b 00 00       	call   c0104b95 <alloc_pages>
c0103fe5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103fe8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103fec:	75 24                	jne    c0104012 <basic_check+0x38f>
c0103fee:	c7 44 24 0c 89 77 10 	movl   $0xc0107789,0xc(%esp)
c0103ff5:	c0 
c0103ff6:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0103ffd:	c0 
c0103ffe:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0104005:	00 
c0104006:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c010400d:	e8 db cc ff ff       	call   c0100ced <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104012:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104019:	e8 77 0b 00 00       	call   c0104b95 <alloc_pages>
c010401e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104021:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104025:	75 24                	jne    c010404b <basic_check+0x3c8>
c0104027:	c7 44 24 0c a5 77 10 	movl   $0xc01077a5,0xc(%esp)
c010402e:	c0 
c010402f:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0104036:	c0 
c0104037:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c010403e:	00 
c010403f:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0104046:	e8 a2 cc ff ff       	call   c0100ced <__panic>

    assert(alloc_page() == NULL);
c010404b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104052:	e8 3e 0b 00 00       	call   c0104b95 <alloc_pages>
c0104057:	85 c0                	test   %eax,%eax
c0104059:	74 24                	je     c010407f <basic_check+0x3fc>
c010405b:	c7 44 24 0c 92 78 10 	movl   $0xc0107892,0xc(%esp)
c0104062:	c0 
c0104063:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c010406a:	c0 
c010406b:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c0104072:	00 
c0104073:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c010407a:	e8 6e cc ff ff       	call   c0100ced <__panic>

    free_page(p0);
c010407f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104086:	00 
c0104087:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010408a:	89 04 24             	mov    %eax,(%esp)
c010408d:	e8 3d 0b 00 00       	call   c0104bcf <free_pages>
c0104092:	c7 45 d8 90 ee 11 c0 	movl   $0xc011ee90,-0x28(%ebp)
c0104099:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010409c:	8b 40 04             	mov    0x4(%eax),%eax
c010409f:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01040a2:	0f 94 c0             	sete   %al
c01040a5:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01040a8:	85 c0                	test   %eax,%eax
c01040aa:	74 24                	je     c01040d0 <basic_check+0x44d>
c01040ac:	c7 44 24 0c b4 78 10 	movl   $0xc01078b4,0xc(%esp)
c01040b3:	c0 
c01040b4:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c01040bb:	c0 
c01040bc:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c01040c3:	00 
c01040c4:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c01040cb:	e8 1d cc ff ff       	call   c0100ced <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01040d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01040d7:	e8 b9 0a 00 00       	call   c0104b95 <alloc_pages>
c01040dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01040df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040e2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01040e5:	74 24                	je     c010410b <basic_check+0x488>
c01040e7:	c7 44 24 0c cc 78 10 	movl   $0xc01078cc,0xc(%esp)
c01040ee:	c0 
c01040ef:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c01040f6:	c0 
c01040f7:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c01040fe:	00 
c01040ff:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0104106:	e8 e2 cb ff ff       	call   c0100ced <__panic>
    assert(alloc_page() == NULL);
c010410b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104112:	e8 7e 0a 00 00       	call   c0104b95 <alloc_pages>
c0104117:	85 c0                	test   %eax,%eax
c0104119:	74 24                	je     c010413f <basic_check+0x4bc>
c010411b:	c7 44 24 0c 92 78 10 	movl   $0xc0107892,0xc(%esp)
c0104122:	c0 
c0104123:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c010412a:	c0 
c010412b:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c0104132:	00 
c0104133:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c010413a:	e8 ae cb ff ff       	call   c0100ced <__panic>

    assert(nr_free == 0);
c010413f:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c0104144:	85 c0                	test   %eax,%eax
c0104146:	74 24                	je     c010416c <basic_check+0x4e9>
c0104148:	c7 44 24 0c e5 78 10 	movl   $0xc01078e5,0xc(%esp)
c010414f:	c0 
c0104150:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0104157:	c0 
c0104158:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c010415f:	00 
c0104160:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0104167:	e8 81 cb ff ff       	call   c0100ced <__panic>
    free_list = free_list_store;
c010416c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010416f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104172:	a3 90 ee 11 c0       	mov    %eax,0xc011ee90
c0104177:	89 15 94 ee 11 c0    	mov    %edx,0xc011ee94
    nr_free = nr_free_store;
c010417d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104180:	a3 98 ee 11 c0       	mov    %eax,0xc011ee98

    free_page(p);
c0104185:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010418c:	00 
c010418d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104190:	89 04 24             	mov    %eax,(%esp)
c0104193:	e8 37 0a 00 00       	call   c0104bcf <free_pages>
    free_page(p1);
c0104198:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010419f:	00 
c01041a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041a3:	89 04 24             	mov    %eax,(%esp)
c01041a6:	e8 24 0a 00 00       	call   c0104bcf <free_pages>
    free_page(p2);
c01041ab:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01041b2:	00 
c01041b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041b6:	89 04 24             	mov    %eax,(%esp)
c01041b9:	e8 11 0a 00 00       	call   c0104bcf <free_pages>
}
c01041be:	90                   	nop
c01041bf:	89 ec                	mov    %ebp,%esp
c01041c1:	5d                   	pop    %ebp
c01041c2:	c3                   	ret    

c01041c3 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01041c3:	55                   	push   %ebp
c01041c4:	89 e5                	mov    %esp,%ebp
c01041c6:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c01041cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01041d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01041da:	c7 45 ec 90 ee 11 c0 	movl   $0xc011ee90,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01041e1:	eb 6a                	jmp    c010424d <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c01041e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041e6:	83 e8 0c             	sub    $0xc,%eax
c01041e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c01041ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01041ef:	83 c0 04             	add    $0x4,%eax
c01041f2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01041f9:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01041fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01041ff:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104202:	0f a3 10             	bt     %edx,(%eax)
c0104205:	19 c0                	sbb    %eax,%eax
c0104207:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c010420a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010420e:	0f 95 c0             	setne  %al
c0104211:	0f b6 c0             	movzbl %al,%eax
c0104214:	85 c0                	test   %eax,%eax
c0104216:	75 24                	jne    c010423c <default_check+0x79>
c0104218:	c7 44 24 0c f2 78 10 	movl   $0xc01078f2,0xc(%esp)
c010421f:	c0 
c0104220:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0104227:	c0 
c0104228:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
c010422f:	00 
c0104230:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0104237:	e8 b1 ca ff ff       	call   c0100ced <__panic>
        count ++, total += p->property;
c010423c:	ff 45 f4             	incl   -0xc(%ebp)
c010423f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104242:	8b 50 08             	mov    0x8(%eax),%edx
c0104245:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104248:	01 d0                	add    %edx,%eax
c010424a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010424d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104250:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0104253:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104256:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104259:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010425c:	81 7d ec 90 ee 11 c0 	cmpl   $0xc011ee90,-0x14(%ebp)
c0104263:	0f 85 7a ff ff ff    	jne    c01041e3 <default_check+0x20>
    }
    assert(total == nr_free_pages());
c0104269:	e8 96 09 00 00       	call   c0104c04 <nr_free_pages>
c010426e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104271:	39 d0                	cmp    %edx,%eax
c0104273:	74 24                	je     c0104299 <default_check+0xd6>
c0104275:	c7 44 24 0c 02 79 10 	movl   $0xc0107902,0xc(%esp)
c010427c:	c0 
c010427d:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0104284:	c0 
c0104285:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c010428c:	00 
c010428d:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0104294:	e8 54 ca ff ff       	call   c0100ced <__panic>

    basic_check();
c0104299:	e8 e5 f9 ff ff       	call   c0103c83 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010429e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01042a5:	e8 eb 08 00 00       	call   c0104b95 <alloc_pages>
c01042aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c01042ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01042b1:	75 24                	jne    c01042d7 <default_check+0x114>
c01042b3:	c7 44 24 0c 1b 79 10 	movl   $0xc010791b,0xc(%esp)
c01042ba:	c0 
c01042bb:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c01042c2:	c0 
c01042c3:	c7 44 24 04 3c 01 00 	movl   $0x13c,0x4(%esp)
c01042ca:	00 
c01042cb:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c01042d2:	e8 16 ca ff ff       	call   c0100ced <__panic>
    assert(!PageProperty(p0));
c01042d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01042da:	83 c0 04             	add    $0x4,%eax
c01042dd:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01042e4:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01042e7:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01042ea:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01042ed:	0f a3 10             	bt     %edx,(%eax)
c01042f0:	19 c0                	sbb    %eax,%eax
c01042f2:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01042f5:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01042f9:	0f 95 c0             	setne  %al
c01042fc:	0f b6 c0             	movzbl %al,%eax
c01042ff:	85 c0                	test   %eax,%eax
c0104301:	74 24                	je     c0104327 <default_check+0x164>
c0104303:	c7 44 24 0c 26 79 10 	movl   $0xc0107926,0xc(%esp)
c010430a:	c0 
c010430b:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0104312:	c0 
c0104313:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c010431a:	00 
c010431b:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0104322:	e8 c6 c9 ff ff       	call   c0100ced <__panic>

    list_entry_t free_list_store = free_list;
c0104327:	a1 90 ee 11 c0       	mov    0xc011ee90,%eax
c010432c:	8b 15 94 ee 11 c0    	mov    0xc011ee94,%edx
c0104332:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104335:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104338:	c7 45 b0 90 ee 11 c0 	movl   $0xc011ee90,-0x50(%ebp)
    elm->prev = elm->next = elm;
c010433f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104342:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104345:	89 50 04             	mov    %edx,0x4(%eax)
c0104348:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010434b:	8b 50 04             	mov    0x4(%eax),%edx
c010434e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104351:	89 10                	mov    %edx,(%eax)
}
c0104353:	90                   	nop
c0104354:	c7 45 b4 90 ee 11 c0 	movl   $0xc011ee90,-0x4c(%ebp)
    return list->next == list;
c010435b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010435e:	8b 40 04             	mov    0x4(%eax),%eax
c0104361:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0104364:	0f 94 c0             	sete   %al
c0104367:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010436a:	85 c0                	test   %eax,%eax
c010436c:	75 24                	jne    c0104392 <default_check+0x1cf>
c010436e:	c7 44 24 0c 7b 78 10 	movl   $0xc010787b,0xc(%esp)
c0104375:	c0 
c0104376:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c010437d:	c0 
c010437e:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
c0104385:	00 
c0104386:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c010438d:	e8 5b c9 ff ff       	call   c0100ced <__panic>
    assert(alloc_page() == NULL);
c0104392:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104399:	e8 f7 07 00 00       	call   c0104b95 <alloc_pages>
c010439e:	85 c0                	test   %eax,%eax
c01043a0:	74 24                	je     c01043c6 <default_check+0x203>
c01043a2:	c7 44 24 0c 92 78 10 	movl   $0xc0107892,0xc(%esp)
c01043a9:	c0 
c01043aa:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c01043b1:	c0 
c01043b2:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
c01043b9:	00 
c01043ba:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c01043c1:	e8 27 c9 ff ff       	call   c0100ced <__panic>

    unsigned int nr_free_store = nr_free;
c01043c6:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c01043cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c01043ce:	c7 05 98 ee 11 c0 00 	movl   $0x0,0xc011ee98
c01043d5:	00 00 00 

    free_pages(p0 + 2, 3);
c01043d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043db:	83 c0 28             	add    $0x28,%eax
c01043de:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01043e5:	00 
c01043e6:	89 04 24             	mov    %eax,(%esp)
c01043e9:	e8 e1 07 00 00       	call   c0104bcf <free_pages>
    assert(alloc_pages(4) == NULL);
c01043ee:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01043f5:	e8 9b 07 00 00       	call   c0104b95 <alloc_pages>
c01043fa:	85 c0                	test   %eax,%eax
c01043fc:	74 24                	je     c0104422 <default_check+0x25f>
c01043fe:	c7 44 24 0c 38 79 10 	movl   $0xc0107938,0xc(%esp)
c0104405:	c0 
c0104406:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c010440d:	c0 
c010440e:	c7 44 24 04 48 01 00 	movl   $0x148,0x4(%esp)
c0104415:	00 
c0104416:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c010441d:	e8 cb c8 ff ff       	call   c0100ced <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104422:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104425:	83 c0 28             	add    $0x28,%eax
c0104428:	83 c0 04             	add    $0x4,%eax
c010442b:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0104432:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104435:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104438:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010443b:	0f a3 10             	bt     %edx,(%eax)
c010443e:	19 c0                	sbb    %eax,%eax
c0104440:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0104443:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0104447:	0f 95 c0             	setne  %al
c010444a:	0f b6 c0             	movzbl %al,%eax
c010444d:	85 c0                	test   %eax,%eax
c010444f:	74 0e                	je     c010445f <default_check+0x29c>
c0104451:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104454:	83 c0 28             	add    $0x28,%eax
c0104457:	8b 40 08             	mov    0x8(%eax),%eax
c010445a:	83 f8 03             	cmp    $0x3,%eax
c010445d:	74 24                	je     c0104483 <default_check+0x2c0>
c010445f:	c7 44 24 0c 50 79 10 	movl   $0xc0107950,0xc(%esp)
c0104466:	c0 
c0104467:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c010446e:	c0 
c010446f:	c7 44 24 04 49 01 00 	movl   $0x149,0x4(%esp)
c0104476:	00 
c0104477:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c010447e:	e8 6a c8 ff ff       	call   c0100ced <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104483:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010448a:	e8 06 07 00 00       	call   c0104b95 <alloc_pages>
c010448f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104492:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104496:	75 24                	jne    c01044bc <default_check+0x2f9>
c0104498:	c7 44 24 0c 7c 79 10 	movl   $0xc010797c,0xc(%esp)
c010449f:	c0 
c01044a0:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c01044a7:	c0 
c01044a8:	c7 44 24 04 4a 01 00 	movl   $0x14a,0x4(%esp)
c01044af:	00 
c01044b0:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c01044b7:	e8 31 c8 ff ff       	call   c0100ced <__panic>
    assert(alloc_page() == NULL);
c01044bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044c3:	e8 cd 06 00 00       	call   c0104b95 <alloc_pages>
c01044c8:	85 c0                	test   %eax,%eax
c01044ca:	74 24                	je     c01044f0 <default_check+0x32d>
c01044cc:	c7 44 24 0c 92 78 10 	movl   $0xc0107892,0xc(%esp)
c01044d3:	c0 
c01044d4:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c01044db:	c0 
c01044dc:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
c01044e3:	00 
c01044e4:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c01044eb:	e8 fd c7 ff ff       	call   c0100ced <__panic>
    assert(p0 + 2 == p1);
c01044f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044f3:	83 c0 28             	add    $0x28,%eax
c01044f6:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01044f9:	74 24                	je     c010451f <default_check+0x35c>
c01044fb:	c7 44 24 0c 9a 79 10 	movl   $0xc010799a,0xc(%esp)
c0104502:	c0 
c0104503:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c010450a:	c0 
c010450b:	c7 44 24 04 4c 01 00 	movl   $0x14c,0x4(%esp)
c0104512:	00 
c0104513:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c010451a:	e8 ce c7 ff ff       	call   c0100ced <__panic>

    p2 = p0 + 1;
c010451f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104522:	83 c0 14             	add    $0x14,%eax
c0104525:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c0104528:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010452f:	00 
c0104530:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104533:	89 04 24             	mov    %eax,(%esp)
c0104536:	e8 94 06 00 00       	call   c0104bcf <free_pages>
    free_pages(p1, 3);
c010453b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104542:	00 
c0104543:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104546:	89 04 24             	mov    %eax,(%esp)
c0104549:	e8 81 06 00 00       	call   c0104bcf <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010454e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104551:	83 c0 04             	add    $0x4,%eax
c0104554:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010455b:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010455e:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104561:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104564:	0f a3 10             	bt     %edx,(%eax)
c0104567:	19 c0                	sbb    %eax,%eax
c0104569:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010456c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104570:	0f 95 c0             	setne  %al
c0104573:	0f b6 c0             	movzbl %al,%eax
c0104576:	85 c0                	test   %eax,%eax
c0104578:	74 0b                	je     c0104585 <default_check+0x3c2>
c010457a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010457d:	8b 40 08             	mov    0x8(%eax),%eax
c0104580:	83 f8 01             	cmp    $0x1,%eax
c0104583:	74 24                	je     c01045a9 <default_check+0x3e6>
c0104585:	c7 44 24 0c a8 79 10 	movl   $0xc01079a8,0xc(%esp)
c010458c:	c0 
c010458d:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0104594:	c0 
c0104595:	c7 44 24 04 51 01 00 	movl   $0x151,0x4(%esp)
c010459c:	00 
c010459d:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c01045a4:	e8 44 c7 ff ff       	call   c0100ced <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01045a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045ac:	83 c0 04             	add    $0x4,%eax
c01045af:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01045b6:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01045b9:	8b 45 90             	mov    -0x70(%ebp),%eax
c01045bc:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01045bf:	0f a3 10             	bt     %edx,(%eax)
c01045c2:	19 c0                	sbb    %eax,%eax
c01045c4:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01045c7:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01045cb:	0f 95 c0             	setne  %al
c01045ce:	0f b6 c0             	movzbl %al,%eax
c01045d1:	85 c0                	test   %eax,%eax
c01045d3:	74 0b                	je     c01045e0 <default_check+0x41d>
c01045d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045d8:	8b 40 08             	mov    0x8(%eax),%eax
c01045db:	83 f8 03             	cmp    $0x3,%eax
c01045de:	74 24                	je     c0104604 <default_check+0x441>
c01045e0:	c7 44 24 0c d0 79 10 	movl   $0xc01079d0,0xc(%esp)
c01045e7:	c0 
c01045e8:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c01045ef:	c0 
c01045f0:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c01045f7:	00 
c01045f8:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c01045ff:	e8 e9 c6 ff ff       	call   c0100ced <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104604:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010460b:	e8 85 05 00 00       	call   c0104b95 <alloc_pages>
c0104610:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104613:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104616:	83 e8 14             	sub    $0x14,%eax
c0104619:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010461c:	74 24                	je     c0104642 <default_check+0x47f>
c010461e:	c7 44 24 0c f6 79 10 	movl   $0xc01079f6,0xc(%esp)
c0104625:	c0 
c0104626:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c010462d:	c0 
c010462e:	c7 44 24 04 54 01 00 	movl   $0x154,0x4(%esp)
c0104635:	00 
c0104636:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c010463d:	e8 ab c6 ff ff       	call   c0100ced <__panic>
    free_page(p0);
c0104642:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104649:	00 
c010464a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010464d:	89 04 24             	mov    %eax,(%esp)
c0104650:	e8 7a 05 00 00       	call   c0104bcf <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104655:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010465c:	e8 34 05 00 00       	call   c0104b95 <alloc_pages>
c0104661:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104664:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104667:	83 c0 14             	add    $0x14,%eax
c010466a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010466d:	74 24                	je     c0104693 <default_check+0x4d0>
c010466f:	c7 44 24 0c 14 7a 10 	movl   $0xc0107a14,0xc(%esp)
c0104676:	c0 
c0104677:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c010467e:	c0 
c010467f:	c7 44 24 04 56 01 00 	movl   $0x156,0x4(%esp)
c0104686:	00 
c0104687:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c010468e:	e8 5a c6 ff ff       	call   c0100ced <__panic>

    free_pages(p0, 2);
c0104693:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010469a:	00 
c010469b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010469e:	89 04 24             	mov    %eax,(%esp)
c01046a1:	e8 29 05 00 00       	call   c0104bcf <free_pages>
    free_page(p2);
c01046a6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01046ad:	00 
c01046ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01046b1:	89 04 24             	mov    %eax,(%esp)
c01046b4:	e8 16 05 00 00       	call   c0104bcf <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01046b9:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01046c0:	e8 d0 04 00 00       	call   c0104b95 <alloc_pages>
c01046c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01046c8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01046cc:	75 24                	jne    c01046f2 <default_check+0x52f>
c01046ce:	c7 44 24 0c 34 7a 10 	movl   $0xc0107a34,0xc(%esp)
c01046d5:	c0 
c01046d6:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c01046dd:	c0 
c01046de:	c7 44 24 04 5b 01 00 	movl   $0x15b,0x4(%esp)
c01046e5:	00 
c01046e6:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c01046ed:	e8 fb c5 ff ff       	call   c0100ced <__panic>
    assert(alloc_page() == NULL);
c01046f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01046f9:	e8 97 04 00 00       	call   c0104b95 <alloc_pages>
c01046fe:	85 c0                	test   %eax,%eax
c0104700:	74 24                	je     c0104726 <default_check+0x563>
c0104702:	c7 44 24 0c 92 78 10 	movl   $0xc0107892,0xc(%esp)
c0104709:	c0 
c010470a:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0104711:	c0 
c0104712:	c7 44 24 04 5c 01 00 	movl   $0x15c,0x4(%esp)
c0104719:	00 
c010471a:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0104721:	e8 c7 c5 ff ff       	call   c0100ced <__panic>

    assert(nr_free == 0);
c0104726:	a1 98 ee 11 c0       	mov    0xc011ee98,%eax
c010472b:	85 c0                	test   %eax,%eax
c010472d:	74 24                	je     c0104753 <default_check+0x590>
c010472f:	c7 44 24 0c e5 78 10 	movl   $0xc01078e5,0xc(%esp)
c0104736:	c0 
c0104737:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c010473e:	c0 
c010473f:	c7 44 24 04 5e 01 00 	movl   $0x15e,0x4(%esp)
c0104746:	00 
c0104747:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c010474e:	e8 9a c5 ff ff       	call   c0100ced <__panic>
    nr_free = nr_free_store;
c0104753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104756:	a3 98 ee 11 c0       	mov    %eax,0xc011ee98

    free_list = free_list_store;
c010475b:	8b 45 80             	mov    -0x80(%ebp),%eax
c010475e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104761:	a3 90 ee 11 c0       	mov    %eax,0xc011ee90
c0104766:	89 15 94 ee 11 c0    	mov    %edx,0xc011ee94
    free_pages(p0, 5);
c010476c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104773:	00 
c0104774:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104777:	89 04 24             	mov    %eax,(%esp)
c010477a:	e8 50 04 00 00       	call   c0104bcf <free_pages>

    le = &free_list;
c010477f:	c7 45 ec 90 ee 11 c0 	movl   $0xc011ee90,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104786:	eb 5a                	jmp    c01047e2 <default_check+0x61f>
        assert(le->next->prev == le && le->prev->next == le);
c0104788:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010478b:	8b 40 04             	mov    0x4(%eax),%eax
c010478e:	8b 00                	mov    (%eax),%eax
c0104790:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104793:	75 0d                	jne    c01047a2 <default_check+0x5df>
c0104795:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104798:	8b 00                	mov    (%eax),%eax
c010479a:	8b 40 04             	mov    0x4(%eax),%eax
c010479d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01047a0:	74 24                	je     c01047c6 <default_check+0x603>
c01047a2:	c7 44 24 0c 54 7a 10 	movl   $0xc0107a54,0xc(%esp)
c01047a9:	c0 
c01047aa:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c01047b1:	c0 
c01047b2:	c7 44 24 04 66 01 00 	movl   $0x166,0x4(%esp)
c01047b9:	00 
c01047ba:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c01047c1:	e8 27 c5 ff ff       	call   c0100ced <__panic>
        struct Page *p = le2page(le, page_link);
c01047c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047c9:	83 e8 0c             	sub    $0xc,%eax
c01047cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c01047cf:	ff 4d f4             	decl   -0xc(%ebp)
c01047d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01047d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01047d8:	8b 48 08             	mov    0x8(%eax),%ecx
c01047db:	89 d0                	mov    %edx,%eax
c01047dd:	29 c8                	sub    %ecx,%eax
c01047df:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01047e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047e5:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c01047e8:	8b 45 88             	mov    -0x78(%ebp),%eax
c01047eb:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01047ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01047f1:	81 7d ec 90 ee 11 c0 	cmpl   $0xc011ee90,-0x14(%ebp)
c01047f8:	75 8e                	jne    c0104788 <default_check+0x5c5>
    }
    assert(count == 0);
c01047fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01047fe:	74 24                	je     c0104824 <default_check+0x661>
c0104800:	c7 44 24 0c 81 7a 10 	movl   $0xc0107a81,0xc(%esp)
c0104807:	c0 
c0104808:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c010480f:	c0 
c0104810:	c7 44 24 04 6a 01 00 	movl   $0x16a,0x4(%esp)
c0104817:	00 
c0104818:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c010481f:	e8 c9 c4 ff ff       	call   c0100ced <__panic>
    assert(total == 0);
c0104824:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104828:	74 24                	je     c010484e <default_check+0x68b>
c010482a:	c7 44 24 0c 8c 7a 10 	movl   $0xc0107a8c,0xc(%esp)
c0104831:	c0 
c0104832:	c7 44 24 08 0a 77 10 	movl   $0xc010770a,0x8(%esp)
c0104839:	c0 
c010483a:	c7 44 24 04 6b 01 00 	movl   $0x16b,0x4(%esp)
c0104841:	00 
c0104842:	c7 04 24 1f 77 10 c0 	movl   $0xc010771f,(%esp)
c0104849:	e8 9f c4 ff ff       	call   c0100ced <__panic>
}
c010484e:	90                   	nop
c010484f:	89 ec                	mov    %ebp,%esp
c0104851:	5d                   	pop    %ebp
c0104852:	c3                   	ret    

c0104853 <page2ppn>:
page2ppn(struct Page *page) {
c0104853:	55                   	push   %ebp
c0104854:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104856:	8b 15 a0 ee 11 c0    	mov    0xc011eea0,%edx
c010485c:	8b 45 08             	mov    0x8(%ebp),%eax
c010485f:	29 d0                	sub    %edx,%eax
c0104861:	c1 f8 02             	sar    $0x2,%eax
c0104864:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010486a:	5d                   	pop    %ebp
c010486b:	c3                   	ret    

c010486c <page2pa>:
page2pa(struct Page *page) {
c010486c:	55                   	push   %ebp
c010486d:	89 e5                	mov    %esp,%ebp
c010486f:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104872:	8b 45 08             	mov    0x8(%ebp),%eax
c0104875:	89 04 24             	mov    %eax,(%esp)
c0104878:	e8 d6 ff ff ff       	call   c0104853 <page2ppn>
c010487d:	c1 e0 0c             	shl    $0xc,%eax
}
c0104880:	89 ec                	mov    %ebp,%esp
c0104882:	5d                   	pop    %ebp
c0104883:	c3                   	ret    

c0104884 <pa2page>:
pa2page(uintptr_t pa) {
c0104884:	55                   	push   %ebp
c0104885:	89 e5                	mov    %esp,%ebp
c0104887:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010488a:	8b 45 08             	mov    0x8(%ebp),%eax
c010488d:	c1 e8 0c             	shr    $0xc,%eax
c0104890:	89 c2                	mov    %eax,%edx
c0104892:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c0104897:	39 c2                	cmp    %eax,%edx
c0104899:	72 1c                	jb     c01048b7 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010489b:	c7 44 24 08 c8 7a 10 	movl   $0xc0107ac8,0x8(%esp)
c01048a2:	c0 
c01048a3:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c01048aa:	00 
c01048ab:	c7 04 24 e7 7a 10 c0 	movl   $0xc0107ae7,(%esp)
c01048b2:	e8 36 c4 ff ff       	call   c0100ced <__panic>
    return &pages[PPN(pa)];
c01048b7:	8b 0d a0 ee 11 c0    	mov    0xc011eea0,%ecx
c01048bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01048c0:	c1 e8 0c             	shr    $0xc,%eax
c01048c3:	89 c2                	mov    %eax,%edx
c01048c5:	89 d0                	mov    %edx,%eax
c01048c7:	c1 e0 02             	shl    $0x2,%eax
c01048ca:	01 d0                	add    %edx,%eax
c01048cc:	c1 e0 02             	shl    $0x2,%eax
c01048cf:	01 c8                	add    %ecx,%eax
}
c01048d1:	89 ec                	mov    %ebp,%esp
c01048d3:	5d                   	pop    %ebp
c01048d4:	c3                   	ret    

c01048d5 <page2kva>:
page2kva(struct Page *page) {
c01048d5:	55                   	push   %ebp
c01048d6:	89 e5                	mov    %esp,%ebp
c01048d8:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01048db:	8b 45 08             	mov    0x8(%ebp),%eax
c01048de:	89 04 24             	mov    %eax,(%esp)
c01048e1:	e8 86 ff ff ff       	call   c010486c <page2pa>
c01048e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01048e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048ec:	c1 e8 0c             	shr    $0xc,%eax
c01048ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048f2:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c01048f7:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01048fa:	72 23                	jb     c010491f <page2kva+0x4a>
c01048fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104903:	c7 44 24 08 f8 7a 10 	movl   $0xc0107af8,0x8(%esp)
c010490a:	c0 
c010490b:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0104912:	00 
c0104913:	c7 04 24 e7 7a 10 c0 	movl   $0xc0107ae7,(%esp)
c010491a:	e8 ce c3 ff ff       	call   c0100ced <__panic>
c010491f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104922:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104927:	89 ec                	mov    %ebp,%esp
c0104929:	5d                   	pop    %ebp
c010492a:	c3                   	ret    

c010492b <pte2page>:
pte2page(pte_t pte) {
c010492b:	55                   	push   %ebp
c010492c:	89 e5                	mov    %esp,%ebp
c010492e:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104931:	8b 45 08             	mov    0x8(%ebp),%eax
c0104934:	83 e0 01             	and    $0x1,%eax
c0104937:	85 c0                	test   %eax,%eax
c0104939:	75 1c                	jne    c0104957 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c010493b:	c7 44 24 08 1c 7b 10 	movl   $0xc0107b1c,0x8(%esp)
c0104942:	c0 
c0104943:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c010494a:	00 
c010494b:	c7 04 24 e7 7a 10 c0 	movl   $0xc0107ae7,(%esp)
c0104952:	e8 96 c3 ff ff       	call   c0100ced <__panic>
    return pa2page(PTE_ADDR(pte));
c0104957:	8b 45 08             	mov    0x8(%ebp),%eax
c010495a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010495f:	89 04 24             	mov    %eax,(%esp)
c0104962:	e8 1d ff ff ff       	call   c0104884 <pa2page>
}
c0104967:	89 ec                	mov    %ebp,%esp
c0104969:	5d                   	pop    %ebp
c010496a:	c3                   	ret    

c010496b <pde2page>:
pde2page(pde_t pde) {
c010496b:	55                   	push   %ebp
c010496c:	89 e5                	mov    %esp,%ebp
c010496e:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0104971:	8b 45 08             	mov    0x8(%ebp),%eax
c0104974:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104979:	89 04 24             	mov    %eax,(%esp)
c010497c:	e8 03 ff ff ff       	call   c0104884 <pa2page>
}
c0104981:	89 ec                	mov    %ebp,%esp
c0104983:	5d                   	pop    %ebp
c0104984:	c3                   	ret    

c0104985 <page_ref>:
page_ref(struct Page *page) {
c0104985:	55                   	push   %ebp
c0104986:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104988:	8b 45 08             	mov    0x8(%ebp),%eax
c010498b:	8b 00                	mov    (%eax),%eax
}
c010498d:	5d                   	pop    %ebp
c010498e:	c3                   	ret    

c010498f <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c010498f:	55                   	push   %ebp
c0104990:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104992:	8b 45 08             	mov    0x8(%ebp),%eax
c0104995:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104998:	89 10                	mov    %edx,(%eax)
}
c010499a:	90                   	nop
c010499b:	5d                   	pop    %ebp
c010499c:	c3                   	ret    

c010499d <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c010499d:	55                   	push   %ebp
c010499e:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c01049a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01049a3:	8b 00                	mov    (%eax),%eax
c01049a5:	8d 50 01             	lea    0x1(%eax),%edx
c01049a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01049ab:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01049ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01049b0:	8b 00                	mov    (%eax),%eax
}
c01049b2:	5d                   	pop    %ebp
c01049b3:	c3                   	ret    

c01049b4 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c01049b4:	55                   	push   %ebp
c01049b5:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c01049b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01049ba:	8b 00                	mov    (%eax),%eax
c01049bc:	8d 50 ff             	lea    -0x1(%eax),%edx
c01049bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01049c2:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01049c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01049c7:	8b 00                	mov    (%eax),%eax
}
c01049c9:	5d                   	pop    %ebp
c01049ca:	c3                   	ret    

c01049cb <__intr_save>:
__intr_save(void) {
c01049cb:	55                   	push   %ebp
c01049cc:	89 e5                	mov    %esp,%ebp
c01049ce:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01049d1:	9c                   	pushf  
c01049d2:	58                   	pop    %eax
c01049d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01049d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01049d9:	25 00 02 00 00       	and    $0x200,%eax
c01049de:	85 c0                	test   %eax,%eax
c01049e0:	74 0c                	je     c01049ee <__intr_save+0x23>
        intr_disable();
c01049e2:	e8 5f cd ff ff       	call   c0101746 <intr_disable>
        return 1;
c01049e7:	b8 01 00 00 00       	mov    $0x1,%eax
c01049ec:	eb 05                	jmp    c01049f3 <__intr_save+0x28>
    return 0;
c01049ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01049f3:	89 ec                	mov    %ebp,%esp
c01049f5:	5d                   	pop    %ebp
c01049f6:	c3                   	ret    

c01049f7 <__intr_restore>:
__intr_restore(bool flag) {
c01049f7:	55                   	push   %ebp
c01049f8:	89 e5                	mov    %esp,%ebp
c01049fa:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01049fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104a01:	74 05                	je     c0104a08 <__intr_restore+0x11>
        intr_enable();
c0104a03:	e8 36 cd ff ff       	call   c010173e <intr_enable>
}
c0104a08:	90                   	nop
c0104a09:	89 ec                	mov    %ebp,%esp
c0104a0b:	5d                   	pop    %ebp
c0104a0c:	c3                   	ret    

c0104a0d <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104a0d:	55                   	push   %ebp
c0104a0e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104a10:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a13:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104a16:	b8 23 00 00 00       	mov    $0x23,%eax
c0104a1b:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104a1d:	b8 23 00 00 00       	mov    $0x23,%eax
c0104a22:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104a24:	b8 10 00 00 00       	mov    $0x10,%eax
c0104a29:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104a2b:	b8 10 00 00 00       	mov    $0x10,%eax
c0104a30:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104a32:	b8 10 00 00 00       	mov    $0x10,%eax
c0104a37:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104a39:	ea 40 4a 10 c0 08 00 	ljmp   $0x8,$0xc0104a40
}
c0104a40:	90                   	nop
c0104a41:	5d                   	pop    %ebp
c0104a42:	c3                   	ret    

c0104a43 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104a43:	55                   	push   %ebp
c0104a44:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104a46:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a49:	a3 c4 ee 11 c0       	mov    %eax,0xc011eec4
}
c0104a4e:	90                   	nop
c0104a4f:	5d                   	pop    %ebp
c0104a50:	c3                   	ret    

c0104a51 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104a51:	55                   	push   %ebp
c0104a52:	89 e5                	mov    %esp,%ebp
c0104a54:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104a57:	b8 00 b0 11 c0       	mov    $0xc011b000,%eax
c0104a5c:	89 04 24             	mov    %eax,(%esp)
c0104a5f:	e8 df ff ff ff       	call   c0104a43 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104a64:	66 c7 05 c8 ee 11 c0 	movw   $0x10,0xc011eec8
c0104a6b:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104a6d:	66 c7 05 28 ba 11 c0 	movw   $0x68,0xc011ba28
c0104a74:	68 00 
c0104a76:	b8 c0 ee 11 c0       	mov    $0xc011eec0,%eax
c0104a7b:	0f b7 c0             	movzwl %ax,%eax
c0104a7e:	66 a3 2a ba 11 c0    	mov    %ax,0xc011ba2a
c0104a84:	b8 c0 ee 11 c0       	mov    $0xc011eec0,%eax
c0104a89:	c1 e8 10             	shr    $0x10,%eax
c0104a8c:	a2 2c ba 11 c0       	mov    %al,0xc011ba2c
c0104a91:	0f b6 05 2d ba 11 c0 	movzbl 0xc011ba2d,%eax
c0104a98:	24 f0                	and    $0xf0,%al
c0104a9a:	0c 09                	or     $0x9,%al
c0104a9c:	a2 2d ba 11 c0       	mov    %al,0xc011ba2d
c0104aa1:	0f b6 05 2d ba 11 c0 	movzbl 0xc011ba2d,%eax
c0104aa8:	24 ef                	and    $0xef,%al
c0104aaa:	a2 2d ba 11 c0       	mov    %al,0xc011ba2d
c0104aaf:	0f b6 05 2d ba 11 c0 	movzbl 0xc011ba2d,%eax
c0104ab6:	24 9f                	and    $0x9f,%al
c0104ab8:	a2 2d ba 11 c0       	mov    %al,0xc011ba2d
c0104abd:	0f b6 05 2d ba 11 c0 	movzbl 0xc011ba2d,%eax
c0104ac4:	0c 80                	or     $0x80,%al
c0104ac6:	a2 2d ba 11 c0       	mov    %al,0xc011ba2d
c0104acb:	0f b6 05 2e ba 11 c0 	movzbl 0xc011ba2e,%eax
c0104ad2:	24 f0                	and    $0xf0,%al
c0104ad4:	a2 2e ba 11 c0       	mov    %al,0xc011ba2e
c0104ad9:	0f b6 05 2e ba 11 c0 	movzbl 0xc011ba2e,%eax
c0104ae0:	24 ef                	and    $0xef,%al
c0104ae2:	a2 2e ba 11 c0       	mov    %al,0xc011ba2e
c0104ae7:	0f b6 05 2e ba 11 c0 	movzbl 0xc011ba2e,%eax
c0104aee:	24 df                	and    $0xdf,%al
c0104af0:	a2 2e ba 11 c0       	mov    %al,0xc011ba2e
c0104af5:	0f b6 05 2e ba 11 c0 	movzbl 0xc011ba2e,%eax
c0104afc:	0c 40                	or     $0x40,%al
c0104afe:	a2 2e ba 11 c0       	mov    %al,0xc011ba2e
c0104b03:	0f b6 05 2e ba 11 c0 	movzbl 0xc011ba2e,%eax
c0104b0a:	24 7f                	and    $0x7f,%al
c0104b0c:	a2 2e ba 11 c0       	mov    %al,0xc011ba2e
c0104b11:	b8 c0 ee 11 c0       	mov    $0xc011eec0,%eax
c0104b16:	c1 e8 18             	shr    $0x18,%eax
c0104b19:	a2 2f ba 11 c0       	mov    %al,0xc011ba2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104b1e:	c7 04 24 30 ba 11 c0 	movl   $0xc011ba30,(%esp)
c0104b25:	e8 e3 fe ff ff       	call   c0104a0d <lgdt>
c0104b2a:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0104b30:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104b34:	0f 00 d8             	ltr    %ax
}
c0104b37:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0104b38:	90                   	nop
c0104b39:	89 ec                	mov    %ebp,%esp
c0104b3b:	5d                   	pop    %ebp
c0104b3c:	c3                   	ret    

c0104b3d <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0104b3d:	55                   	push   %ebp
c0104b3e:	89 e5                	mov    %esp,%ebp
c0104b40:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &buddy_pmm_manager;
c0104b43:	c7 05 ac ee 11 c0 e8 	movl   $0xc01076e8,0xc011eeac
c0104b4a:	76 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0104b4d:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c0104b52:	8b 00                	mov    (%eax),%eax
c0104b54:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104b58:	c7 04 24 48 7b 10 c0 	movl   $0xc0107b48,(%esp)
c0104b5f:	e8 fd b7 ff ff       	call   c0100361 <cprintf>
    pmm_manager->init();
c0104b64:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c0104b69:	8b 40 04             	mov    0x4(%eax),%eax
c0104b6c:	ff d0                	call   *%eax
}
c0104b6e:	90                   	nop
c0104b6f:	89 ec                	mov    %ebp,%esp
c0104b71:	5d                   	pop    %ebp
c0104b72:	c3                   	ret    

c0104b73 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0104b73:	55                   	push   %ebp
c0104b74:	89 e5                	mov    %esp,%ebp
c0104b76:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104b79:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c0104b7e:	8b 40 08             	mov    0x8(%eax),%eax
c0104b81:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104b84:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104b88:	8b 55 08             	mov    0x8(%ebp),%edx
c0104b8b:	89 14 24             	mov    %edx,(%esp)
c0104b8e:	ff d0                	call   *%eax
}
c0104b90:	90                   	nop
c0104b91:	89 ec                	mov    %ebp,%esp
c0104b93:	5d                   	pop    %ebp
c0104b94:	c3                   	ret    

c0104b95 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0104b95:	55                   	push   %ebp
c0104b96:	89 e5                	mov    %esp,%ebp
c0104b98:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0104b9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0104ba2:	e8 24 fe ff ff       	call   c01049cb <__intr_save>
c0104ba7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0104baa:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c0104baf:	8b 40 0c             	mov    0xc(%eax),%eax
c0104bb2:	8b 55 08             	mov    0x8(%ebp),%edx
c0104bb5:	89 14 24             	mov    %edx,(%esp)
c0104bb8:	ff d0                	call   *%eax
c0104bba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0104bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bc0:	89 04 24             	mov    %eax,(%esp)
c0104bc3:	e8 2f fe ff ff       	call   c01049f7 <__intr_restore>
    return page;
c0104bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104bcb:	89 ec                	mov    %ebp,%esp
c0104bcd:	5d                   	pop    %ebp
c0104bce:	c3                   	ret    

c0104bcf <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0104bcf:	55                   	push   %ebp
c0104bd0:	89 e5                	mov    %esp,%ebp
c0104bd2:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0104bd5:	e8 f1 fd ff ff       	call   c01049cb <__intr_save>
c0104bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104bdd:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c0104be2:	8b 40 10             	mov    0x10(%eax),%eax
c0104be5:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104be8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104bec:	8b 55 08             	mov    0x8(%ebp),%edx
c0104bef:	89 14 24             	mov    %edx,(%esp)
c0104bf2:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0104bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bf7:	89 04 24             	mov    %eax,(%esp)
c0104bfa:	e8 f8 fd ff ff       	call   c01049f7 <__intr_restore>
}
c0104bff:	90                   	nop
c0104c00:	89 ec                	mov    %ebp,%esp
c0104c02:	5d                   	pop    %ebp
c0104c03:	c3                   	ret    

c0104c04 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0104c04:	55                   	push   %ebp
c0104c05:	89 e5                	mov    %esp,%ebp
c0104c07:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0104c0a:	e8 bc fd ff ff       	call   c01049cb <__intr_save>
c0104c0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0104c12:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c0104c17:	8b 40 14             	mov    0x14(%eax),%eax
c0104c1a:	ff d0                	call   *%eax
c0104c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0104c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c22:	89 04 24             	mov    %eax,(%esp)
c0104c25:	e8 cd fd ff ff       	call   c01049f7 <__intr_restore>
    return ret;
c0104c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104c2d:	89 ec                	mov    %ebp,%esp
c0104c2f:	5d                   	pop    %ebp
c0104c30:	c3                   	ret    

c0104c31 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0104c31:	55                   	push   %ebp
c0104c32:	89 e5                	mov    %esp,%ebp
c0104c34:	57                   	push   %edi
c0104c35:	56                   	push   %esi
c0104c36:	53                   	push   %ebx
c0104c37:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104c3d:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0104c44:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104c4b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104c52:	c7 04 24 5f 7b 10 c0 	movl   $0xc0107b5f,(%esp)
c0104c59:	e8 03 b7 ff ff       	call   c0100361 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104c5e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104c65:	e9 0c 01 00 00       	jmp    c0104d76 <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104c6a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104c6d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104c70:	89 d0                	mov    %edx,%eax
c0104c72:	c1 e0 02             	shl    $0x2,%eax
c0104c75:	01 d0                	add    %edx,%eax
c0104c77:	c1 e0 02             	shl    $0x2,%eax
c0104c7a:	01 c8                	add    %ecx,%eax
c0104c7c:	8b 50 08             	mov    0x8(%eax),%edx
c0104c7f:	8b 40 04             	mov    0x4(%eax),%eax
c0104c82:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0104c85:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0104c88:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104c8b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104c8e:	89 d0                	mov    %edx,%eax
c0104c90:	c1 e0 02             	shl    $0x2,%eax
c0104c93:	01 d0                	add    %edx,%eax
c0104c95:	c1 e0 02             	shl    $0x2,%eax
c0104c98:	01 c8                	add    %ecx,%eax
c0104c9a:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104c9d:	8b 58 10             	mov    0x10(%eax),%ebx
c0104ca0:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104ca3:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104ca6:	01 c8                	add    %ecx,%eax
c0104ca8:	11 da                	adc    %ebx,%edx
c0104caa:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104cad:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104cb0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104cb3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104cb6:	89 d0                	mov    %edx,%eax
c0104cb8:	c1 e0 02             	shl    $0x2,%eax
c0104cbb:	01 d0                	add    %edx,%eax
c0104cbd:	c1 e0 02             	shl    $0x2,%eax
c0104cc0:	01 c8                	add    %ecx,%eax
c0104cc2:	83 c0 14             	add    $0x14,%eax
c0104cc5:	8b 00                	mov    (%eax),%eax
c0104cc7:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104ccd:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104cd0:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104cd3:	83 c0 ff             	add    $0xffffffff,%eax
c0104cd6:	83 d2 ff             	adc    $0xffffffff,%edx
c0104cd9:	89 c6                	mov    %eax,%esi
c0104cdb:	89 d7                	mov    %edx,%edi
c0104cdd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104ce0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ce3:	89 d0                	mov    %edx,%eax
c0104ce5:	c1 e0 02             	shl    $0x2,%eax
c0104ce8:	01 d0                	add    %edx,%eax
c0104cea:	c1 e0 02             	shl    $0x2,%eax
c0104ced:	01 c8                	add    %ecx,%eax
c0104cef:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104cf2:	8b 58 10             	mov    0x10(%eax),%ebx
c0104cf5:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104cfb:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104cff:	89 74 24 14          	mov    %esi,0x14(%esp)
c0104d03:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0104d07:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104d0a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104d0d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d11:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104d15:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0104d19:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104d1d:	c7 04 24 6c 7b 10 c0 	movl   $0xc0107b6c,(%esp)
c0104d24:	e8 38 b6 ff ff       	call   c0100361 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0104d29:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104d2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104d2f:	89 d0                	mov    %edx,%eax
c0104d31:	c1 e0 02             	shl    $0x2,%eax
c0104d34:	01 d0                	add    %edx,%eax
c0104d36:	c1 e0 02             	shl    $0x2,%eax
c0104d39:	01 c8                	add    %ecx,%eax
c0104d3b:	83 c0 14             	add    $0x14,%eax
c0104d3e:	8b 00                	mov    (%eax),%eax
c0104d40:	83 f8 01             	cmp    $0x1,%eax
c0104d43:	75 2e                	jne    c0104d73 <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
c0104d45:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104d4b:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0104d4e:	89 d0                	mov    %edx,%eax
c0104d50:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c0104d53:	73 1e                	jae    c0104d73 <page_init+0x142>
c0104d55:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c0104d5a:	b8 00 00 00 00       	mov    $0x0,%eax
c0104d5f:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c0104d62:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c0104d65:	72 0c                	jb     c0104d73 <page_init+0x142>
                maxpa = end;
c0104d67:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104d6a:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104d6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104d70:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0104d73:	ff 45 dc             	incl   -0x24(%ebp)
c0104d76:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104d79:	8b 00                	mov    (%eax),%eax
c0104d7b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104d7e:	0f 8c e6 fe ff ff    	jl     c0104c6a <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104d84:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0104d89:	b8 00 00 00 00       	mov    $0x0,%eax
c0104d8e:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0104d91:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0104d94:	73 0e                	jae    c0104da4 <page_init+0x173>
        maxpa = KMEMSIZE;
c0104d96:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104d9d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104da4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104da7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104daa:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104dae:	c1 ea 0c             	shr    $0xc,%edx
c0104db1:	a3 a4 ee 11 c0       	mov    %eax,0xc011eea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104db6:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0104dbd:	b8 2c ef 11 c0       	mov    $0xc011ef2c,%eax
c0104dc2:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104dc5:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104dc8:	01 d0                	add    %edx,%eax
c0104dca:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0104dcd:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104dd0:	ba 00 00 00 00       	mov    $0x0,%edx
c0104dd5:	f7 75 c0             	divl   -0x40(%ebp)
c0104dd8:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104ddb:	29 d0                	sub    %edx,%eax
c0104ddd:	a3 a0 ee 11 c0       	mov    %eax,0xc011eea0

    for (i = 0; i < npage; i ++) {
c0104de2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104de9:	eb 2f                	jmp    c0104e1a <page_init+0x1e9>
        SetPageReserved(pages + i);
c0104deb:	8b 0d a0 ee 11 c0    	mov    0xc011eea0,%ecx
c0104df1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104df4:	89 d0                	mov    %edx,%eax
c0104df6:	c1 e0 02             	shl    $0x2,%eax
c0104df9:	01 d0                	add    %edx,%eax
c0104dfb:	c1 e0 02             	shl    $0x2,%eax
c0104dfe:	01 c8                	add    %ecx,%eax
c0104e00:	83 c0 04             	add    $0x4,%eax
c0104e03:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0104e0a:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104e0d:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104e10:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104e13:	0f ab 10             	bts    %edx,(%eax)
}
c0104e16:	90                   	nop
    for (i = 0; i < npage; i ++) {
c0104e17:	ff 45 dc             	incl   -0x24(%ebp)
c0104e1a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e1d:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c0104e22:	39 c2                	cmp    %eax,%edx
c0104e24:	72 c5                	jb     c0104deb <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0104e26:	8b 15 a4 ee 11 c0    	mov    0xc011eea4,%edx
c0104e2c:	89 d0                	mov    %edx,%eax
c0104e2e:	c1 e0 02             	shl    $0x2,%eax
c0104e31:	01 d0                	add    %edx,%eax
c0104e33:	c1 e0 02             	shl    $0x2,%eax
c0104e36:	89 c2                	mov    %eax,%edx
c0104e38:	a1 a0 ee 11 c0       	mov    0xc011eea0,%eax
c0104e3d:	01 d0                	add    %edx,%eax
c0104e3f:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104e42:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0104e49:	77 23                	ja     c0104e6e <page_init+0x23d>
c0104e4b:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104e4e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e52:	c7 44 24 08 9c 7b 10 	movl   $0xc0107b9c,0x8(%esp)
c0104e59:	c0 
c0104e5a:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0104e61:	00 
c0104e62:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0104e69:	e8 7f be ff ff       	call   c0100ced <__panic>
c0104e6e:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104e71:	05 00 00 00 40       	add    $0x40000000,%eax
c0104e76:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104e79:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104e80:	e9 53 01 00 00       	jmp    c0104fd8 <page_init+0x3a7>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104e85:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104e88:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e8b:	89 d0                	mov    %edx,%eax
c0104e8d:	c1 e0 02             	shl    $0x2,%eax
c0104e90:	01 d0                	add    %edx,%eax
c0104e92:	c1 e0 02             	shl    $0x2,%eax
c0104e95:	01 c8                	add    %ecx,%eax
c0104e97:	8b 50 08             	mov    0x8(%eax),%edx
c0104e9a:	8b 40 04             	mov    0x4(%eax),%eax
c0104e9d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104ea0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104ea3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104ea6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ea9:	89 d0                	mov    %edx,%eax
c0104eab:	c1 e0 02             	shl    $0x2,%eax
c0104eae:	01 d0                	add    %edx,%eax
c0104eb0:	c1 e0 02             	shl    $0x2,%eax
c0104eb3:	01 c8                	add    %ecx,%eax
c0104eb5:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104eb8:	8b 58 10             	mov    0x10(%eax),%ebx
c0104ebb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104ebe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104ec1:	01 c8                	add    %ecx,%eax
c0104ec3:	11 da                	adc    %ebx,%edx
c0104ec5:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104ec8:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104ecb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104ece:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ed1:	89 d0                	mov    %edx,%eax
c0104ed3:	c1 e0 02             	shl    $0x2,%eax
c0104ed6:	01 d0                	add    %edx,%eax
c0104ed8:	c1 e0 02             	shl    $0x2,%eax
c0104edb:	01 c8                	add    %ecx,%eax
c0104edd:	83 c0 14             	add    $0x14,%eax
c0104ee0:	8b 00                	mov    (%eax),%eax
c0104ee2:	83 f8 01             	cmp    $0x1,%eax
c0104ee5:	0f 85 ea 00 00 00    	jne    c0104fd5 <page_init+0x3a4>
            if (begin < freemem) {
c0104eeb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104eee:	ba 00 00 00 00       	mov    $0x0,%edx
c0104ef3:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104ef6:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0104ef9:	19 d1                	sbb    %edx,%ecx
c0104efb:	73 0d                	jae    c0104f0a <page_init+0x2d9>
                begin = freemem;
c0104efd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104f00:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104f03:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104f0a:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0104f0f:	b8 00 00 00 00       	mov    $0x0,%eax
c0104f14:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c0104f17:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0104f1a:	73 0e                	jae    c0104f2a <page_init+0x2f9>
                end = KMEMSIZE;
c0104f1c:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104f23:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104f2a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104f2d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104f30:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104f33:	89 d0                	mov    %edx,%eax
c0104f35:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0104f38:	0f 83 97 00 00 00    	jae    c0104fd5 <page_init+0x3a4>
                begin = ROUNDUP(begin, PGSIZE);
c0104f3e:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0104f45:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104f48:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104f4b:	01 d0                	add    %edx,%eax
c0104f4d:	48                   	dec    %eax
c0104f4e:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0104f51:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104f54:	ba 00 00 00 00       	mov    $0x0,%edx
c0104f59:	f7 75 b0             	divl   -0x50(%ebp)
c0104f5c:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104f5f:	29 d0                	sub    %edx,%eax
c0104f61:	ba 00 00 00 00       	mov    $0x0,%edx
c0104f66:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104f69:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104f6c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104f6f:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104f72:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104f75:	ba 00 00 00 00       	mov    $0x0,%edx
c0104f7a:	89 c7                	mov    %eax,%edi
c0104f7c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104f82:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104f85:	89 d0                	mov    %edx,%eax
c0104f87:	83 e0 00             	and    $0x0,%eax
c0104f8a:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104f8d:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104f90:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104f93:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104f96:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104f99:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104f9c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104f9f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104fa2:	89 d0                	mov    %edx,%eax
c0104fa4:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0104fa7:	73 2c                	jae    c0104fd5 <page_init+0x3a4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104fa9:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104fac:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104faf:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0104fb2:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0104fb5:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104fb9:	c1 ea 0c             	shr    $0xc,%edx
c0104fbc:	89 c3                	mov    %eax,%ebx
c0104fbe:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104fc1:	89 04 24             	mov    %eax,(%esp)
c0104fc4:	e8 bb f8 ff ff       	call   c0104884 <pa2page>
c0104fc9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104fcd:	89 04 24             	mov    %eax,(%esp)
c0104fd0:	e8 9e fb ff ff       	call   c0104b73 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c0104fd5:	ff 45 dc             	incl   -0x24(%ebp)
c0104fd8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104fdb:	8b 00                	mov    (%eax),%eax
c0104fdd:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104fe0:	0f 8c 9f fe ff ff    	jl     c0104e85 <page_init+0x254>
                }
            }
        }
    }
}
c0104fe6:	90                   	nop
c0104fe7:	90                   	nop
c0104fe8:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104fee:	5b                   	pop    %ebx
c0104fef:	5e                   	pop    %esi
c0104ff0:	5f                   	pop    %edi
c0104ff1:	5d                   	pop    %ebp
c0104ff2:	c3                   	ret    

c0104ff3 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104ff3:	55                   	push   %ebp
c0104ff4:	89 e5                	mov    %esp,%ebp
c0104ff6:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ffc:	33 45 14             	xor    0x14(%ebp),%eax
c0104fff:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105004:	85 c0                	test   %eax,%eax
c0105006:	74 24                	je     c010502c <boot_map_segment+0x39>
c0105008:	c7 44 24 0c ce 7b 10 	movl   $0xc0107bce,0xc(%esp)
c010500f:	c0 
c0105010:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105017:	c0 
c0105018:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c010501f:	00 
c0105020:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105027:	e8 c1 bc ff ff       	call   c0100ced <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010502c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0105033:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105036:	25 ff 0f 00 00       	and    $0xfff,%eax
c010503b:	89 c2                	mov    %eax,%edx
c010503d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105040:	01 c2                	add    %eax,%edx
c0105042:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105045:	01 d0                	add    %edx,%eax
c0105047:	48                   	dec    %eax
c0105048:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010504b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010504e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105053:	f7 75 f0             	divl   -0x10(%ebp)
c0105056:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105059:	29 d0                	sub    %edx,%eax
c010505b:	c1 e8 0c             	shr    $0xc,%eax
c010505e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0105061:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105064:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105067:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010506a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010506f:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0105072:	8b 45 14             	mov    0x14(%ebp),%eax
c0105075:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105078:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010507b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105080:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0105083:	eb 68                	jmp    c01050ed <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0105085:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010508c:	00 
c010508d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105090:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105094:	8b 45 08             	mov    0x8(%ebp),%eax
c0105097:	89 04 24             	mov    %eax,(%esp)
c010509a:	e8 88 01 00 00       	call   c0105227 <get_pte>
c010509f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01050a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01050a6:	75 24                	jne    c01050cc <boot_map_segment+0xd9>
c01050a8:	c7 44 24 0c fa 7b 10 	movl   $0xc0107bfa,0xc(%esp)
c01050af:	c0 
c01050b0:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c01050b7:	c0 
c01050b8:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c01050bf:	00 
c01050c0:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c01050c7:	e8 21 bc ff ff       	call   c0100ced <__panic>
        *ptep = pa | PTE_P | perm;
c01050cc:	8b 45 14             	mov    0x14(%ebp),%eax
c01050cf:	0b 45 18             	or     0x18(%ebp),%eax
c01050d2:	83 c8 01             	or     $0x1,%eax
c01050d5:	89 c2                	mov    %eax,%edx
c01050d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050da:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01050dc:	ff 4d f4             	decl   -0xc(%ebp)
c01050df:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01050e6:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01050ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01050f1:	75 92                	jne    c0105085 <boot_map_segment+0x92>
    }
}
c01050f3:	90                   	nop
c01050f4:	90                   	nop
c01050f5:	89 ec                	mov    %ebp,%esp
c01050f7:	5d                   	pop    %ebp
c01050f8:	c3                   	ret    

c01050f9 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01050f9:	55                   	push   %ebp
c01050fa:	89 e5                	mov    %esp,%ebp
c01050fc:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01050ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105106:	e8 8a fa ff ff       	call   c0104b95 <alloc_pages>
c010510b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010510e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105112:	75 1c                	jne    c0105130 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0105114:	c7 44 24 08 07 7c 10 	movl   $0xc0107c07,0x8(%esp)
c010511b:	c0 
c010511c:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c0105123:	00 
c0105124:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c010512b:	e8 bd bb ff ff       	call   c0100ced <__panic>
    }
    return page2kva(p);
c0105130:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105133:	89 04 24             	mov    %eax,(%esp)
c0105136:	e8 9a f7 ff ff       	call   c01048d5 <page2kva>
}
c010513b:	89 ec                	mov    %ebp,%esp
c010513d:	5d                   	pop    %ebp
c010513e:	c3                   	ret    

c010513f <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010513f:	55                   	push   %ebp
c0105140:	89 e5                	mov    %esp,%ebp
c0105142:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0105145:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c010514a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010514d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105154:	77 23                	ja     c0105179 <pmm_init+0x3a>
c0105156:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105159:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010515d:	c7 44 24 08 9c 7b 10 	movl   $0xc0107b9c,0x8(%esp)
c0105164:	c0 
c0105165:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c010516c:	00 
c010516d:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105174:	e8 74 bb ff ff       	call   c0100ced <__panic>
c0105179:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010517c:	05 00 00 00 40       	add    $0x40000000,%eax
c0105181:	a3 a8 ee 11 c0       	mov    %eax,0xc011eea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0105186:	e8 b2 f9 ff ff       	call   c0104b3d <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010518b:	e8 a1 fa ff ff       	call   c0104c31 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0105190:	e8 12 04 00 00       	call   c01055a7 <check_alloc_page>

    check_pgdir();
c0105195:	e8 2e 04 00 00       	call   c01055c8 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c010519a:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c010519f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01051a2:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01051a9:	77 23                	ja     c01051ce <pmm_init+0x8f>
c01051ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01051ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01051b2:	c7 44 24 08 9c 7b 10 	movl   $0xc0107b9c,0x8(%esp)
c01051b9:	c0 
c01051ba:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
c01051c1:	00 
c01051c2:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c01051c9:	e8 1f bb ff ff       	call   c0100ced <__panic>
c01051ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01051d1:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c01051d7:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c01051dc:	05 ac 0f 00 00       	add    $0xfac,%eax
c01051e1:	83 ca 03             	or     $0x3,%edx
c01051e4:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01051e6:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c01051eb:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01051f2:	00 
c01051f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01051fa:	00 
c01051fb:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0105202:	38 
c0105203:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c010520a:	c0 
c010520b:	89 04 24             	mov    %eax,(%esp)
c010520e:	e8 e0 fd ff ff       	call   c0104ff3 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0105213:	e8 39 f8 ff ff       	call   c0104a51 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0105218:	e8 49 0a 00 00       	call   c0105c66 <check_boot_pgdir>

    print_pgdir();
c010521d:	e8 c6 0e 00 00       	call   c01060e8 <print_pgdir>

}
c0105222:	90                   	nop
c0105223:	89 ec                	mov    %ebp,%esp
c0105225:	5d                   	pop    %ebp
c0105226:	c3                   	ret    

c0105227 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0105227:	55                   	push   %ebp
c0105228:	89 e5                	mov    %esp,%ebp
c010522a:	83 ec 38             	sub    $0x38,%esp
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
#if 1
    // (1) find page directory entry
    // 获取页目录表中给定线性地址对应到的页目录项
    pde_t *pdep = pgdir + PDX(la);
c010522d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105230:	c1 e8 16             	shr    $0x16,%eax
c0105233:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010523a:	8b 45 08             	mov    0x8(%ebp),%eax
c010523d:	01 d0                	add    %edx,%eax
c010523f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 获取到该物理页的虚拟地址
    pte_t *ptep = (pte_t *)(KADDR(*pdep & ~0XFFF)); 
c0105242:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105245:	8b 00                	mov    (%eax),%eax
c0105247:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010524c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010524f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105252:	c1 e8 0c             	shr    $0xc,%eax
c0105255:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105258:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c010525d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105260:	72 23                	jb     c0105285 <get_pte+0x5e>
c0105262:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105265:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105269:	c7 44 24 08 f8 7a 10 	movl   $0xc0107af8,0x8(%esp)
c0105270:	c0 
c0105271:	c7 44 24 04 64 01 00 	movl   $0x164,0x4(%esp)
c0105278:	00 
c0105279:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105280:	e8 68 ba ff ff       	call   c0100ced <__panic>
c0105285:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105288:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010528d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // (2) check if entry is not present
    // 判断页目录项是否不存在
    if (!(*pdep & PTE_P)) {
c0105290:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105293:	8b 00                	mov    (%eax),%eax
c0105295:	83 e0 01             	and    $0x1,%eax
c0105298:	85 c0                	test   %eax,%eax
c010529a:	0f 85 c6 00 00 00    	jne    c0105366 <get_pte+0x13f>
        // (3) check if creating is needed, then alloc page for page table
        // CAUTION: this page is used for page table, not for common data page
        // 判断是否需要创建新的页表, 不需要则返回NULL
        if (!create){
c01052a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01052a4:	75 0a                	jne    c01052b0 <get_pte+0x89>
            return NULL;
c01052a6:	b8 00 00 00 00       	mov    $0x0,%eax
c01052ab:	e9 cd 00 00 00       	jmp    c010537d <get_pte+0x156>
        }
        // 分配一个页, 如果物理空间不足则返回NULL
        struct Page* pt = alloc_page(); 
c01052b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01052b7:	e8 d9 f8 ff ff       	call   c0104b95 <alloc_pages>
c01052bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (pt == NULL){
c01052bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01052c3:	75 0a                	jne    c01052cf <get_pte+0xa8>
            return NULL;
c01052c5:	b8 00 00 00 00       	mov    $0x0,%eax
c01052ca:	e9 ae 00 00 00       	jmp    c010537d <get_pte+0x156>
        }
        // (4) set page reference
        // 更新该物理页的引用计数
        set_page_ref(pt, 1);
c01052cf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01052d6:	00 
c01052d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052da:	89 04 24             	mov    %eax,(%esp)
c01052dd:	e8 ad f6 ff ff       	call   c010498f <set_page_ref>
        // (5) get linear address of page
        // 获取到该物理页的虚拟地址(此时已经启动了page机制，内核地址空间)(CPU执行的指令中使用的已经是虚拟地址了)
        ptep = KADDR(page2pa(pt));
c01052e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052e5:	89 04 24             	mov    %eax,(%esp)
c01052e8:	e8 7f f5 ff ff       	call   c010486c <page2pa>
c01052ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01052f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052f3:	c1 e8 0c             	shr    $0xc,%eax
c01052f6:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01052f9:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c01052fe:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0105301:	72 23                	jb     c0105326 <get_pte+0xff>
c0105303:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105306:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010530a:	c7 44 24 08 f8 7a 10 	movl   $0xc0107af8,0x8(%esp)
c0105311:	c0 
c0105312:	c7 44 24 04 78 01 00 	movl   $0x178,0x4(%esp)
c0105319:	00 
c010531a:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105321:	e8 c7 b9 ff ff       	call   c0100ced <__panic>
c0105326:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105329:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010532e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // (6) clear page content using memset
        // 对新创建的页表进行初始化
        memset(ptep, 0, PGSIZE);
c0105331:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105338:	00 
c0105339:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105340:	00 
c0105341:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105344:	89 04 24             	mov    %eax,(%esp)
c0105347:	e8 a1 18 00 00       	call   c0106bed <memset>
        // (7) set page directory entry's permission
        // 对原先的页目录项进行设置: 对应页表的物理地址, 标志位(存在位, 读写位, 特权级)
        *pdep = (page2pa(pt) & ~0XFFF) | PTE_USER;
c010534c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010534f:	89 04 24             	mov    %eax,(%esp)
c0105352:	e8 15 f5 ff ff       	call   c010486c <page2pa>
c0105357:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010535c:	83 c8 07             	or     $0x7,%eax
c010535f:	89 c2                	mov    %eax,%edx
c0105361:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105364:	89 10                	mov    %edx,(%eax)
    }
    // (8) return page table entry
    // 返回线性地址对应的页表项
    return ptep + PTX(la);
c0105366:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105369:	c1 e8 0c             	shr    $0xc,%eax
c010536c:	25 ff 03 00 00       	and    $0x3ff,%eax
c0105371:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105378:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010537b:	01 d0                	add    %edx,%eax
#endif
}
c010537d:	89 ec                	mov    %ebp,%esp
c010537f:	5d                   	pop    %ebp
c0105380:	c3                   	ret    

c0105381 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0105381:	55                   	push   %ebp
c0105382:	89 e5                	mov    %esp,%ebp
c0105384:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105387:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010538e:	00 
c010538f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105392:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105396:	8b 45 08             	mov    0x8(%ebp),%eax
c0105399:	89 04 24             	mov    %eax,(%esp)
c010539c:	e8 86 fe ff ff       	call   c0105227 <get_pte>
c01053a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01053a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01053a8:	74 08                	je     c01053b2 <get_page+0x31>
        *ptep_store = ptep;
c01053aa:	8b 45 10             	mov    0x10(%ebp),%eax
c01053ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01053b0:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01053b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01053b6:	74 1b                	je     c01053d3 <get_page+0x52>
c01053b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053bb:	8b 00                	mov    (%eax),%eax
c01053bd:	83 e0 01             	and    $0x1,%eax
c01053c0:	85 c0                	test   %eax,%eax
c01053c2:	74 0f                	je     c01053d3 <get_page+0x52>
        return pte2page(*ptep);
c01053c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053c7:	8b 00                	mov    (%eax),%eax
c01053c9:	89 04 24             	mov    %eax,(%esp)
c01053cc:	e8 5a f5 ff ff       	call   c010492b <pte2page>
c01053d1:	eb 05                	jmp    c01053d8 <get_page+0x57>
    }
    return NULL;
c01053d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01053d8:	89 ec                	mov    %ebp,%esp
c01053da:	5d                   	pop    %ebp
c01053db:	c3                   	ret    

c01053dc <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01053dc:	55                   	push   %ebp
c01053dd:	89 e5                	mov    %esp,%ebp
c01053df:	83 ec 28             	sub    $0x28,%esp
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
#if 1
    // (1) check if this page table entry is present
    // 如果二级表项存在
    if (*ptep & PTE_P) {
c01053e2:	8b 45 10             	mov    0x10(%ebp),%eax
c01053e5:	8b 00                	mov    (%eax),%eax
c01053e7:	83 e0 01             	and    $0x1,%eax
c01053ea:	85 c0                	test   %eax,%eax
c01053ec:	74 53                	je     c0105441 <page_remove_pte+0x65>
        // (2) find corresponding page to pte
        // 获取物理页对应的Page结构
        struct Page *page = pte2page(*ptep);
c01053ee:	8b 45 10             	mov    0x10(%ebp),%eax
c01053f1:	8b 00                	mov    (%eax),%eax
c01053f3:	89 04 24             	mov    %eax,(%esp)
c01053f6:	e8 30 f5 ff ff       	call   c010492b <pte2page>
c01053fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // (3) decrease page reference
        // (4) and free this page when page reference reachs 0
        // 减少引用计数, 如果该页的引用计数变成0，释放该物理页
        if (page_ref_dec(page)==0){
c01053fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105401:	89 04 24             	mov    %eax,(%esp)
c0105404:	e8 ab f5 ff ff       	call   c01049b4 <page_ref_dec>
c0105409:	85 c0                	test   %eax,%eax
c010540b:	75 13                	jne    c0105420 <page_remove_pte+0x44>
            free_page(page);
c010540d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105414:	00 
c0105415:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105418:	89 04 24             	mov    %eax,(%esp)
c010541b:	e8 af f7 ff ff       	call   c0104bcf <free_pages>
        }
        // (5) clear second page table entry
        // 将PTE的存在位设置为0(表示该映射关系无效)
        *ptep &= (~PTE_P); 
c0105420:	8b 45 10             	mov    0x10(%ebp),%eax
c0105423:	8b 00                	mov    (%eax),%eax
c0105425:	83 e0 fe             	and    $0xfffffffe,%eax
c0105428:	89 c2                	mov    %eax,%edx
c010542a:	8b 45 10             	mov    0x10(%ebp),%eax
c010542d:	89 10                	mov    %edx,(%eax)
        // (6) flush tlb
        // 刷新TLB(保证TLB中的缓存不会有错误的映射关系)
        tlb_invalidate(pgdir, la);
c010542f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105432:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105436:	8b 45 08             	mov    0x8(%ebp),%eax
c0105439:	89 04 24             	mov    %eax,(%esp)
c010543c:	e8 07 01 00 00       	call   c0105548 <tlb_invalidate>
    }
#endif
}
c0105441:	90                   	nop
c0105442:	89 ec                	mov    %ebp,%esp
c0105444:	5d                   	pop    %ebp
c0105445:	c3                   	ret    

c0105446 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0105446:	55                   	push   %ebp
c0105447:	89 e5                	mov    %esp,%ebp
c0105449:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010544c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105453:	00 
c0105454:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105457:	89 44 24 04          	mov    %eax,0x4(%esp)
c010545b:	8b 45 08             	mov    0x8(%ebp),%eax
c010545e:	89 04 24             	mov    %eax,(%esp)
c0105461:	e8 c1 fd ff ff       	call   c0105227 <get_pte>
c0105466:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0105469:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010546d:	74 19                	je     c0105488 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010546f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105472:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105476:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105479:	89 44 24 04          	mov    %eax,0x4(%esp)
c010547d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105480:	89 04 24             	mov    %eax,(%esp)
c0105483:	e8 54 ff ff ff       	call   c01053dc <page_remove_pte>
    }
}
c0105488:	90                   	nop
c0105489:	89 ec                	mov    %ebp,%esp
c010548b:	5d                   	pop    %ebp
c010548c:	c3                   	ret    

c010548d <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010548d:	55                   	push   %ebp
c010548e:	89 e5                	mov    %esp,%ebp
c0105490:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0105493:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010549a:	00 
c010549b:	8b 45 10             	mov    0x10(%ebp),%eax
c010549e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01054a5:	89 04 24             	mov    %eax,(%esp)
c01054a8:	e8 7a fd ff ff       	call   c0105227 <get_pte>
c01054ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01054b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01054b4:	75 0a                	jne    c01054c0 <page_insert+0x33>
        return -E_NO_MEM;
c01054b6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01054bb:	e9 84 00 00 00       	jmp    c0105544 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01054c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054c3:	89 04 24             	mov    %eax,(%esp)
c01054c6:	e8 d2 f4 ff ff       	call   c010499d <page_ref_inc>
    if (*ptep & PTE_P) {
c01054cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054ce:	8b 00                	mov    (%eax),%eax
c01054d0:	83 e0 01             	and    $0x1,%eax
c01054d3:	85 c0                	test   %eax,%eax
c01054d5:	74 3e                	je     c0105515 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01054d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054da:	8b 00                	mov    (%eax),%eax
c01054dc:	89 04 24             	mov    %eax,(%esp)
c01054df:	e8 47 f4 ff ff       	call   c010492b <pte2page>
c01054e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01054e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01054ed:	75 0d                	jne    c01054fc <page_insert+0x6f>
            page_ref_dec(page);
c01054ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054f2:	89 04 24             	mov    %eax,(%esp)
c01054f5:	e8 ba f4 ff ff       	call   c01049b4 <page_ref_dec>
c01054fa:	eb 19                	jmp    c0105515 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01054fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054ff:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105503:	8b 45 10             	mov    0x10(%ebp),%eax
c0105506:	89 44 24 04          	mov    %eax,0x4(%esp)
c010550a:	8b 45 08             	mov    0x8(%ebp),%eax
c010550d:	89 04 24             	mov    %eax,(%esp)
c0105510:	e8 c7 fe ff ff       	call   c01053dc <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105515:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105518:	89 04 24             	mov    %eax,(%esp)
c010551b:	e8 4c f3 ff ff       	call   c010486c <page2pa>
c0105520:	0b 45 14             	or     0x14(%ebp),%eax
c0105523:	83 c8 01             	or     $0x1,%eax
c0105526:	89 c2                	mov    %eax,%edx
c0105528:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010552b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010552d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105530:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105534:	8b 45 08             	mov    0x8(%ebp),%eax
c0105537:	89 04 24             	mov    %eax,(%esp)
c010553a:	e8 09 00 00 00       	call   c0105548 <tlb_invalidate>
    return 0;
c010553f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105544:	89 ec                	mov    %ebp,%esp
c0105546:	5d                   	pop    %ebp
c0105547:	c3                   	ret    

c0105548 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0105548:	55                   	push   %ebp
c0105549:	89 e5                	mov    %esp,%ebp
c010554b:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010554e:	0f 20 d8             	mov    %cr3,%eax
c0105551:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0105554:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0105557:	8b 45 08             	mov    0x8(%ebp),%eax
c010555a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010555d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105564:	77 23                	ja     c0105589 <tlb_invalidate+0x41>
c0105566:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105569:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010556d:	c7 44 24 08 9c 7b 10 	movl   $0xc0107b9c,0x8(%esp)
c0105574:	c0 
c0105575:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c010557c:	00 
c010557d:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105584:	e8 64 b7 ff ff       	call   c0100ced <__panic>
c0105589:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010558c:	05 00 00 00 40       	add    $0x40000000,%eax
c0105591:	39 d0                	cmp    %edx,%eax
c0105593:	75 0d                	jne    c01055a2 <tlb_invalidate+0x5a>
        invlpg((void *)la);
c0105595:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105598:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010559b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010559e:	0f 01 38             	invlpg (%eax)
}
c01055a1:	90                   	nop
    }
}
c01055a2:	90                   	nop
c01055a3:	89 ec                	mov    %ebp,%esp
c01055a5:	5d                   	pop    %ebp
c01055a6:	c3                   	ret    

c01055a7 <check_alloc_page>:

static void
check_alloc_page(void) {
c01055a7:	55                   	push   %ebp
c01055a8:	89 e5                	mov    %esp,%ebp
c01055aa:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01055ad:	a1 ac ee 11 c0       	mov    0xc011eeac,%eax
c01055b2:	8b 40 18             	mov    0x18(%eax),%eax
c01055b5:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01055b7:	c7 04 24 20 7c 10 c0 	movl   $0xc0107c20,(%esp)
c01055be:	e8 9e ad ff ff       	call   c0100361 <cprintf>
}
c01055c3:	90                   	nop
c01055c4:	89 ec                	mov    %ebp,%esp
c01055c6:	5d                   	pop    %ebp
c01055c7:	c3                   	ret    

c01055c8 <check_pgdir>:

static void
check_pgdir(void) {
c01055c8:	55                   	push   %ebp
c01055c9:	89 e5                	mov    %esp,%ebp
c01055cb:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01055ce:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c01055d3:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01055d8:	76 24                	jbe    c01055fe <check_pgdir+0x36>
c01055da:	c7 44 24 0c 3f 7c 10 	movl   $0xc0107c3f,0xc(%esp)
c01055e1:	c0 
c01055e2:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c01055e9:	c0 
c01055ea:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c01055f1:	00 
c01055f2:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c01055f9:	e8 ef b6 ff ff       	call   c0100ced <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01055fe:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105603:	85 c0                	test   %eax,%eax
c0105605:	74 0e                	je     c0105615 <check_pgdir+0x4d>
c0105607:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c010560c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105611:	85 c0                	test   %eax,%eax
c0105613:	74 24                	je     c0105639 <check_pgdir+0x71>
c0105615:	c7 44 24 0c 5c 7c 10 	movl   $0xc0107c5c,0xc(%esp)
c010561c:	c0 
c010561d:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105624:	c0 
c0105625:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c010562c:	00 
c010562d:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105634:	e8 b4 b6 ff ff       	call   c0100ced <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0105639:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c010563e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105645:	00 
c0105646:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010564d:	00 
c010564e:	89 04 24             	mov    %eax,(%esp)
c0105651:	e8 2b fd ff ff       	call   c0105381 <get_page>
c0105656:	85 c0                	test   %eax,%eax
c0105658:	74 24                	je     c010567e <check_pgdir+0xb6>
c010565a:	c7 44 24 0c 94 7c 10 	movl   $0xc0107c94,0xc(%esp)
c0105661:	c0 
c0105662:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105669:	c0 
c010566a:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c0105671:	00 
c0105672:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105679:	e8 6f b6 ff ff       	call   c0100ced <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010567e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105685:	e8 0b f5 ff ff       	call   c0104b95 <alloc_pages>
c010568a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010568d:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105692:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105699:	00 
c010569a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01056a1:	00 
c01056a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01056a5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01056a9:	89 04 24             	mov    %eax,(%esp)
c01056ac:	e8 dc fd ff ff       	call   c010548d <page_insert>
c01056b1:	85 c0                	test   %eax,%eax
c01056b3:	74 24                	je     c01056d9 <check_pgdir+0x111>
c01056b5:	c7 44 24 0c bc 7c 10 	movl   $0xc0107cbc,0xc(%esp)
c01056bc:	c0 
c01056bd:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c01056c4:	c0 
c01056c5:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c01056cc:	00 
c01056cd:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c01056d4:	e8 14 b6 ff ff       	call   c0100ced <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01056d9:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c01056de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01056e5:	00 
c01056e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01056ed:	00 
c01056ee:	89 04 24             	mov    %eax,(%esp)
c01056f1:	e8 31 fb ff ff       	call   c0105227 <get_pte>
c01056f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01056f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01056fd:	75 24                	jne    c0105723 <check_pgdir+0x15b>
c01056ff:	c7 44 24 0c e8 7c 10 	movl   $0xc0107ce8,0xc(%esp)
c0105706:	c0 
c0105707:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c010570e:	c0 
c010570f:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0105716:	00 
c0105717:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c010571e:	e8 ca b5 ff ff       	call   c0100ced <__panic>
    assert(pte2page(*ptep) == p1);
c0105723:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105726:	8b 00                	mov    (%eax),%eax
c0105728:	89 04 24             	mov    %eax,(%esp)
c010572b:	e8 fb f1 ff ff       	call   c010492b <pte2page>
c0105730:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0105733:	74 24                	je     c0105759 <check_pgdir+0x191>
c0105735:	c7 44 24 0c 15 7d 10 	movl   $0xc0107d15,0xc(%esp)
c010573c:	c0 
c010573d:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105744:	c0 
c0105745:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c010574c:	00 
c010574d:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105754:	e8 94 b5 ff ff       	call   c0100ced <__panic>
    assert(page_ref(p1) == 1);
c0105759:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010575c:	89 04 24             	mov    %eax,(%esp)
c010575f:	e8 21 f2 ff ff       	call   c0104985 <page_ref>
c0105764:	83 f8 01             	cmp    $0x1,%eax
c0105767:	74 24                	je     c010578d <check_pgdir+0x1c5>
c0105769:	c7 44 24 0c 2b 7d 10 	movl   $0xc0107d2b,0xc(%esp)
c0105770:	c0 
c0105771:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105778:	c0 
c0105779:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0105780:	00 
c0105781:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105788:	e8 60 b5 ff ff       	call   c0100ced <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010578d:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105792:	8b 00                	mov    (%eax),%eax
c0105794:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105799:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010579c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010579f:	c1 e8 0c             	shr    $0xc,%eax
c01057a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057a5:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c01057aa:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01057ad:	72 23                	jb     c01057d2 <check_pgdir+0x20a>
c01057af:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01057b6:	c7 44 24 08 f8 7a 10 	movl   $0xc0107af8,0x8(%esp)
c01057bd:	c0 
c01057be:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c01057c5:	00 
c01057c6:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c01057cd:	e8 1b b5 ff ff       	call   c0100ced <__panic>
c01057d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057d5:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01057da:	83 c0 04             	add    $0x4,%eax
c01057dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01057e0:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c01057e5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01057ec:	00 
c01057ed:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01057f4:	00 
c01057f5:	89 04 24             	mov    %eax,(%esp)
c01057f8:	e8 2a fa ff ff       	call   c0105227 <get_pte>
c01057fd:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0105800:	74 24                	je     c0105826 <check_pgdir+0x25e>
c0105802:	c7 44 24 0c 40 7d 10 	movl   $0xc0107d40,0xc(%esp)
c0105809:	c0 
c010580a:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105811:	c0 
c0105812:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0105819:	00 
c010581a:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105821:	e8 c7 b4 ff ff       	call   c0100ced <__panic>

    p2 = alloc_page();
c0105826:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010582d:	e8 63 f3 ff ff       	call   c0104b95 <alloc_pages>
c0105832:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0105835:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c010583a:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105841:	00 
c0105842:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105849:	00 
c010584a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010584d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105851:	89 04 24             	mov    %eax,(%esp)
c0105854:	e8 34 fc ff ff       	call   c010548d <page_insert>
c0105859:	85 c0                	test   %eax,%eax
c010585b:	74 24                	je     c0105881 <check_pgdir+0x2b9>
c010585d:	c7 44 24 0c 68 7d 10 	movl   $0xc0107d68,0xc(%esp)
c0105864:	c0 
c0105865:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c010586c:	c0 
c010586d:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0105874:	00 
c0105875:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c010587c:	e8 6c b4 ff ff       	call   c0100ced <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105881:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105886:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010588d:	00 
c010588e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105895:	00 
c0105896:	89 04 24             	mov    %eax,(%esp)
c0105899:	e8 89 f9 ff ff       	call   c0105227 <get_pte>
c010589e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01058a5:	75 24                	jne    c01058cb <check_pgdir+0x303>
c01058a7:	c7 44 24 0c a0 7d 10 	movl   $0xc0107da0,0xc(%esp)
c01058ae:	c0 
c01058af:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c01058b6:	c0 
c01058b7:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c01058be:	00 
c01058bf:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c01058c6:	e8 22 b4 ff ff       	call   c0100ced <__panic>
    assert(*ptep & PTE_U);
c01058cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058ce:	8b 00                	mov    (%eax),%eax
c01058d0:	83 e0 04             	and    $0x4,%eax
c01058d3:	85 c0                	test   %eax,%eax
c01058d5:	75 24                	jne    c01058fb <check_pgdir+0x333>
c01058d7:	c7 44 24 0c d0 7d 10 	movl   $0xc0107dd0,0xc(%esp)
c01058de:	c0 
c01058df:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c01058e6:	c0 
c01058e7:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c01058ee:	00 
c01058ef:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c01058f6:	e8 f2 b3 ff ff       	call   c0100ced <__panic>
    assert(*ptep & PTE_W);
c01058fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058fe:	8b 00                	mov    (%eax),%eax
c0105900:	83 e0 02             	and    $0x2,%eax
c0105903:	85 c0                	test   %eax,%eax
c0105905:	75 24                	jne    c010592b <check_pgdir+0x363>
c0105907:	c7 44 24 0c de 7d 10 	movl   $0xc0107dde,0xc(%esp)
c010590e:	c0 
c010590f:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105916:	c0 
c0105917:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c010591e:	00 
c010591f:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105926:	e8 c2 b3 ff ff       	call   c0100ced <__panic>
    assert(boot_pgdir[0] & PTE_U);
c010592b:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105930:	8b 00                	mov    (%eax),%eax
c0105932:	83 e0 04             	and    $0x4,%eax
c0105935:	85 c0                	test   %eax,%eax
c0105937:	75 24                	jne    c010595d <check_pgdir+0x395>
c0105939:	c7 44 24 0c ec 7d 10 	movl   $0xc0107dec,0xc(%esp)
c0105940:	c0 
c0105941:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105948:	c0 
c0105949:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0105950:	00 
c0105951:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105958:	e8 90 b3 ff ff       	call   c0100ced <__panic>
    assert(page_ref(p2) == 1);
c010595d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105960:	89 04 24             	mov    %eax,(%esp)
c0105963:	e8 1d f0 ff ff       	call   c0104985 <page_ref>
c0105968:	83 f8 01             	cmp    $0x1,%eax
c010596b:	74 24                	je     c0105991 <check_pgdir+0x3c9>
c010596d:	c7 44 24 0c 02 7e 10 	movl   $0xc0107e02,0xc(%esp)
c0105974:	c0 
c0105975:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c010597c:	c0 
c010597d:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0105984:	00 
c0105985:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c010598c:	e8 5c b3 ff ff       	call   c0100ced <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0105991:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105996:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010599d:	00 
c010599e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01059a5:	00 
c01059a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059a9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01059ad:	89 04 24             	mov    %eax,(%esp)
c01059b0:	e8 d8 fa ff ff       	call   c010548d <page_insert>
c01059b5:	85 c0                	test   %eax,%eax
c01059b7:	74 24                	je     c01059dd <check_pgdir+0x415>
c01059b9:	c7 44 24 0c 14 7e 10 	movl   $0xc0107e14,0xc(%esp)
c01059c0:	c0 
c01059c1:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c01059c8:	c0 
c01059c9:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c01059d0:	00 
c01059d1:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c01059d8:	e8 10 b3 ff ff       	call   c0100ced <__panic>
    assert(page_ref(p1) == 2);
c01059dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059e0:	89 04 24             	mov    %eax,(%esp)
c01059e3:	e8 9d ef ff ff       	call   c0104985 <page_ref>
c01059e8:	83 f8 02             	cmp    $0x2,%eax
c01059eb:	74 24                	je     c0105a11 <check_pgdir+0x449>
c01059ed:	c7 44 24 0c 40 7e 10 	movl   $0xc0107e40,0xc(%esp)
c01059f4:	c0 
c01059f5:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c01059fc:	c0 
c01059fd:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0105a04:	00 
c0105a05:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105a0c:	e8 dc b2 ff ff       	call   c0100ced <__panic>
    assert(page_ref(p2) == 0);
c0105a11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a14:	89 04 24             	mov    %eax,(%esp)
c0105a17:	e8 69 ef ff ff       	call   c0104985 <page_ref>
c0105a1c:	85 c0                	test   %eax,%eax
c0105a1e:	74 24                	je     c0105a44 <check_pgdir+0x47c>
c0105a20:	c7 44 24 0c 52 7e 10 	movl   $0xc0107e52,0xc(%esp)
c0105a27:	c0 
c0105a28:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105a2f:	c0 
c0105a30:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0105a37:	00 
c0105a38:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105a3f:	e8 a9 b2 ff ff       	call   c0100ced <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105a44:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105a49:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105a50:	00 
c0105a51:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105a58:	00 
c0105a59:	89 04 24             	mov    %eax,(%esp)
c0105a5c:	e8 c6 f7 ff ff       	call   c0105227 <get_pte>
c0105a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105a68:	75 24                	jne    c0105a8e <check_pgdir+0x4c6>
c0105a6a:	c7 44 24 0c a0 7d 10 	movl   $0xc0107da0,0xc(%esp)
c0105a71:	c0 
c0105a72:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105a79:	c0 
c0105a7a:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0105a81:	00 
c0105a82:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105a89:	e8 5f b2 ff ff       	call   c0100ced <__panic>
    assert(pte2page(*ptep) == p1);
c0105a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a91:	8b 00                	mov    (%eax),%eax
c0105a93:	89 04 24             	mov    %eax,(%esp)
c0105a96:	e8 90 ee ff ff       	call   c010492b <pte2page>
c0105a9b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0105a9e:	74 24                	je     c0105ac4 <check_pgdir+0x4fc>
c0105aa0:	c7 44 24 0c 15 7d 10 	movl   $0xc0107d15,0xc(%esp)
c0105aa7:	c0 
c0105aa8:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105aaf:	c0 
c0105ab0:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0105ab7:	00 
c0105ab8:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105abf:	e8 29 b2 ff ff       	call   c0100ced <__panic>
    assert((*ptep & PTE_U) == 0);
c0105ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ac7:	8b 00                	mov    (%eax),%eax
c0105ac9:	83 e0 04             	and    $0x4,%eax
c0105acc:	85 c0                	test   %eax,%eax
c0105ace:	74 24                	je     c0105af4 <check_pgdir+0x52c>
c0105ad0:	c7 44 24 0c 64 7e 10 	movl   $0xc0107e64,0xc(%esp)
c0105ad7:	c0 
c0105ad8:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105adf:	c0 
c0105ae0:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0105ae7:	00 
c0105ae8:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105aef:	e8 f9 b1 ff ff       	call   c0100ced <__panic>

    page_remove(boot_pgdir, 0x0);
c0105af4:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105af9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105b00:	00 
c0105b01:	89 04 24             	mov    %eax,(%esp)
c0105b04:	e8 3d f9 ff ff       	call   c0105446 <page_remove>
    assert(page_ref(p1) == 1);
c0105b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b0c:	89 04 24             	mov    %eax,(%esp)
c0105b0f:	e8 71 ee ff ff       	call   c0104985 <page_ref>
c0105b14:	83 f8 01             	cmp    $0x1,%eax
c0105b17:	74 24                	je     c0105b3d <check_pgdir+0x575>
c0105b19:	c7 44 24 0c 2b 7d 10 	movl   $0xc0107d2b,0xc(%esp)
c0105b20:	c0 
c0105b21:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105b28:	c0 
c0105b29:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0105b30:	00 
c0105b31:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105b38:	e8 b0 b1 ff ff       	call   c0100ced <__panic>
    assert(page_ref(p2) == 0);
c0105b3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b40:	89 04 24             	mov    %eax,(%esp)
c0105b43:	e8 3d ee ff ff       	call   c0104985 <page_ref>
c0105b48:	85 c0                	test   %eax,%eax
c0105b4a:	74 24                	je     c0105b70 <check_pgdir+0x5a8>
c0105b4c:	c7 44 24 0c 52 7e 10 	movl   $0xc0107e52,0xc(%esp)
c0105b53:	c0 
c0105b54:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105b5b:	c0 
c0105b5c:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0105b63:	00 
c0105b64:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105b6b:	e8 7d b1 ff ff       	call   c0100ced <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0105b70:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105b75:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105b7c:	00 
c0105b7d:	89 04 24             	mov    %eax,(%esp)
c0105b80:	e8 c1 f8 ff ff       	call   c0105446 <page_remove>
    assert(page_ref(p1) == 0);
c0105b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b88:	89 04 24             	mov    %eax,(%esp)
c0105b8b:	e8 f5 ed ff ff       	call   c0104985 <page_ref>
c0105b90:	85 c0                	test   %eax,%eax
c0105b92:	74 24                	je     c0105bb8 <check_pgdir+0x5f0>
c0105b94:	c7 44 24 0c 79 7e 10 	movl   $0xc0107e79,0xc(%esp)
c0105b9b:	c0 
c0105b9c:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105ba3:	c0 
c0105ba4:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0105bab:	00 
c0105bac:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105bb3:	e8 35 b1 ff ff       	call   c0100ced <__panic>
    assert(page_ref(p2) == 0);
c0105bb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105bbb:	89 04 24             	mov    %eax,(%esp)
c0105bbe:	e8 c2 ed ff ff       	call   c0104985 <page_ref>
c0105bc3:	85 c0                	test   %eax,%eax
c0105bc5:	74 24                	je     c0105beb <check_pgdir+0x623>
c0105bc7:	c7 44 24 0c 52 7e 10 	movl   $0xc0107e52,0xc(%esp)
c0105bce:	c0 
c0105bcf:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105bd6:	c0 
c0105bd7:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0105bde:	00 
c0105bdf:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105be6:	e8 02 b1 ff ff       	call   c0100ced <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0105beb:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105bf0:	8b 00                	mov    (%eax),%eax
c0105bf2:	89 04 24             	mov    %eax,(%esp)
c0105bf5:	e8 71 ed ff ff       	call   c010496b <pde2page>
c0105bfa:	89 04 24             	mov    %eax,(%esp)
c0105bfd:	e8 83 ed ff ff       	call   c0104985 <page_ref>
c0105c02:	83 f8 01             	cmp    $0x1,%eax
c0105c05:	74 24                	je     c0105c2b <check_pgdir+0x663>
c0105c07:	c7 44 24 0c 8c 7e 10 	movl   $0xc0107e8c,0xc(%esp)
c0105c0e:	c0 
c0105c0f:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105c16:	c0 
c0105c17:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0105c1e:	00 
c0105c1f:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105c26:	e8 c2 b0 ff ff       	call   c0100ced <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0105c2b:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105c30:	8b 00                	mov    (%eax),%eax
c0105c32:	89 04 24             	mov    %eax,(%esp)
c0105c35:	e8 31 ed ff ff       	call   c010496b <pde2page>
c0105c3a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105c41:	00 
c0105c42:	89 04 24             	mov    %eax,(%esp)
c0105c45:	e8 85 ef ff ff       	call   c0104bcf <free_pages>
    boot_pgdir[0] = 0;
c0105c4a:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105c4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0105c55:	c7 04 24 b3 7e 10 c0 	movl   $0xc0107eb3,(%esp)
c0105c5c:	e8 00 a7 ff ff       	call   c0100361 <cprintf>
}
c0105c61:	90                   	nop
c0105c62:	89 ec                	mov    %ebp,%esp
c0105c64:	5d                   	pop    %ebp
c0105c65:	c3                   	ret    

c0105c66 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0105c66:	55                   	push   %ebp
c0105c67:	89 e5                	mov    %esp,%ebp
c0105c69:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105c6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105c73:	e9 ca 00 00 00       	jmp    c0105d42 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0105c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105c7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105c81:	c1 e8 0c             	shr    $0xc,%eax
c0105c84:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105c87:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c0105c8c:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0105c8f:	72 23                	jb     c0105cb4 <check_boot_pgdir+0x4e>
c0105c91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105c94:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105c98:	c7 44 24 08 f8 7a 10 	movl   $0xc0107af8,0x8(%esp)
c0105c9f:	c0 
c0105ca0:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0105ca7:	00 
c0105ca8:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105caf:	e8 39 b0 ff ff       	call   c0100ced <__panic>
c0105cb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105cb7:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105cbc:	89 c2                	mov    %eax,%edx
c0105cbe:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105cc3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105cca:	00 
c0105ccb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105ccf:	89 04 24             	mov    %eax,(%esp)
c0105cd2:	e8 50 f5 ff ff       	call   c0105227 <get_pte>
c0105cd7:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105cda:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105cde:	75 24                	jne    c0105d04 <check_boot_pgdir+0x9e>
c0105ce0:	c7 44 24 0c d0 7e 10 	movl   $0xc0107ed0,0xc(%esp)
c0105ce7:	c0 
c0105ce8:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105cef:	c0 
c0105cf0:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0105cf7:	00 
c0105cf8:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105cff:	e8 e9 af ff ff       	call   c0100ced <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0105d04:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105d07:	8b 00                	mov    (%eax),%eax
c0105d09:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105d0e:	89 c2                	mov    %eax,%edx
c0105d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d13:	39 c2                	cmp    %eax,%edx
c0105d15:	74 24                	je     c0105d3b <check_boot_pgdir+0xd5>
c0105d17:	c7 44 24 0c 0d 7f 10 	movl   $0xc0107f0d,0xc(%esp)
c0105d1e:	c0 
c0105d1f:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105d26:	c0 
c0105d27:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0105d2e:	00 
c0105d2f:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105d36:	e8 b2 af ff ff       	call   c0100ced <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0105d3b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0105d42:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d45:	a1 a4 ee 11 c0       	mov    0xc011eea4,%eax
c0105d4a:	39 c2                	cmp    %eax,%edx
c0105d4c:	0f 82 26 ff ff ff    	jb     c0105c78 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0105d52:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105d57:	05 ac 0f 00 00       	add    $0xfac,%eax
c0105d5c:	8b 00                	mov    (%eax),%eax
c0105d5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105d63:	89 c2                	mov    %eax,%edx
c0105d65:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105d6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d6d:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0105d74:	77 23                	ja     c0105d99 <check_boot_pgdir+0x133>
c0105d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d79:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105d7d:	c7 44 24 08 9c 7b 10 	movl   $0xc0107b9c,0x8(%esp)
c0105d84:	c0 
c0105d85:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0105d8c:	00 
c0105d8d:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105d94:	e8 54 af ff ff       	call   c0100ced <__panic>
c0105d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d9c:	05 00 00 00 40       	add    $0x40000000,%eax
c0105da1:	39 d0                	cmp    %edx,%eax
c0105da3:	74 24                	je     c0105dc9 <check_boot_pgdir+0x163>
c0105da5:	c7 44 24 0c 24 7f 10 	movl   $0xc0107f24,0xc(%esp)
c0105dac:	c0 
c0105dad:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105db4:	c0 
c0105db5:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0105dbc:	00 
c0105dbd:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105dc4:	e8 24 af ff ff       	call   c0100ced <__panic>

    assert(boot_pgdir[0] == 0);
c0105dc9:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105dce:	8b 00                	mov    (%eax),%eax
c0105dd0:	85 c0                	test   %eax,%eax
c0105dd2:	74 24                	je     c0105df8 <check_boot_pgdir+0x192>
c0105dd4:	c7 44 24 0c 58 7f 10 	movl   $0xc0107f58,0xc(%esp)
c0105ddb:	c0 
c0105ddc:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105de3:	c0 
c0105de4:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0105deb:	00 
c0105dec:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105df3:	e8 f5 ae ff ff       	call   c0100ced <__panic>

    struct Page *p;
    p = alloc_page();
c0105df8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105dff:	e8 91 ed ff ff       	call   c0104b95 <alloc_pages>
c0105e04:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105e07:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105e0c:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105e13:	00 
c0105e14:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105e1b:	00 
c0105e1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105e1f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105e23:	89 04 24             	mov    %eax,(%esp)
c0105e26:	e8 62 f6 ff ff       	call   c010548d <page_insert>
c0105e2b:	85 c0                	test   %eax,%eax
c0105e2d:	74 24                	je     c0105e53 <check_boot_pgdir+0x1ed>
c0105e2f:	c7 44 24 0c 6c 7f 10 	movl   $0xc0107f6c,0xc(%esp)
c0105e36:	c0 
c0105e37:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105e3e:	c0 
c0105e3f:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0105e46:	00 
c0105e47:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105e4e:	e8 9a ae ff ff       	call   c0100ced <__panic>
    assert(page_ref(p) == 1);
c0105e53:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e56:	89 04 24             	mov    %eax,(%esp)
c0105e59:	e8 27 eb ff ff       	call   c0104985 <page_ref>
c0105e5e:	83 f8 01             	cmp    $0x1,%eax
c0105e61:	74 24                	je     c0105e87 <check_boot_pgdir+0x221>
c0105e63:	c7 44 24 0c 9a 7f 10 	movl   $0xc0107f9a,0xc(%esp)
c0105e6a:	c0 
c0105e6b:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105e72:	c0 
c0105e73:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c0105e7a:	00 
c0105e7b:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105e82:	e8 66 ae ff ff       	call   c0100ced <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105e87:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105e8c:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105e93:	00 
c0105e94:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105e9b:	00 
c0105e9c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105e9f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105ea3:	89 04 24             	mov    %eax,(%esp)
c0105ea6:	e8 e2 f5 ff ff       	call   c010548d <page_insert>
c0105eab:	85 c0                	test   %eax,%eax
c0105ead:	74 24                	je     c0105ed3 <check_boot_pgdir+0x26d>
c0105eaf:	c7 44 24 0c ac 7f 10 	movl   $0xc0107fac,0xc(%esp)
c0105eb6:	c0 
c0105eb7:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105ebe:	c0 
c0105ebf:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c0105ec6:	00 
c0105ec7:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105ece:	e8 1a ae ff ff       	call   c0100ced <__panic>
    assert(page_ref(p) == 2);
c0105ed3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ed6:	89 04 24             	mov    %eax,(%esp)
c0105ed9:	e8 a7 ea ff ff       	call   c0104985 <page_ref>
c0105ede:	83 f8 02             	cmp    $0x2,%eax
c0105ee1:	74 24                	je     c0105f07 <check_boot_pgdir+0x2a1>
c0105ee3:	c7 44 24 0c e3 7f 10 	movl   $0xc0107fe3,0xc(%esp)
c0105eea:	c0 
c0105eeb:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105ef2:	c0 
c0105ef3:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0105efa:	00 
c0105efb:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105f02:	e8 e6 ad ff ff       	call   c0100ced <__panic>

    const char *str = "ucore: Hello world!!";
c0105f07:	c7 45 e8 f4 7f 10 c0 	movl   $0xc0107ff4,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0105f0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f11:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f15:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105f1c:	e8 fc 09 00 00       	call   c010691d <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105f21:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105f28:	00 
c0105f29:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105f30:	e8 60 0a 00 00       	call   c0106995 <strcmp>
c0105f35:	85 c0                	test   %eax,%eax
c0105f37:	74 24                	je     c0105f5d <check_boot_pgdir+0x2f7>
c0105f39:	c7 44 24 0c 0c 80 10 	movl   $0xc010800c,0xc(%esp)
c0105f40:	c0 
c0105f41:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105f48:	c0 
c0105f49:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c0105f50:	00 
c0105f51:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105f58:	e8 90 ad ff ff       	call   c0100ced <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105f5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f60:	89 04 24             	mov    %eax,(%esp)
c0105f63:	e8 6d e9 ff ff       	call   c01048d5 <page2kva>
c0105f68:	05 00 01 00 00       	add    $0x100,%eax
c0105f6d:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105f70:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105f77:	e8 47 09 00 00       	call   c01068c3 <strlen>
c0105f7c:	85 c0                	test   %eax,%eax
c0105f7e:	74 24                	je     c0105fa4 <check_boot_pgdir+0x33e>
c0105f80:	c7 44 24 0c 44 80 10 	movl   $0xc0108044,0xc(%esp)
c0105f87:	c0 
c0105f88:	c7 44 24 08 e5 7b 10 	movl   $0xc0107be5,0x8(%esp)
c0105f8f:	c0 
c0105f90:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c0105f97:	00 
c0105f98:	c7 04 24 c0 7b 10 c0 	movl   $0xc0107bc0,(%esp)
c0105f9f:	e8 49 ad ff ff       	call   c0100ced <__panic>

    free_page(p);
c0105fa4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105fab:	00 
c0105fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105faf:	89 04 24             	mov    %eax,(%esp)
c0105fb2:	e8 18 ec ff ff       	call   c0104bcf <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105fb7:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105fbc:	8b 00                	mov    (%eax),%eax
c0105fbe:	89 04 24             	mov    %eax,(%esp)
c0105fc1:	e8 a5 e9 ff ff       	call   c010496b <pde2page>
c0105fc6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105fcd:	00 
c0105fce:	89 04 24             	mov    %eax,(%esp)
c0105fd1:	e8 f9 eb ff ff       	call   c0104bcf <free_pages>
    boot_pgdir[0] = 0;
c0105fd6:	a1 e0 b9 11 c0       	mov    0xc011b9e0,%eax
c0105fdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105fe1:	c7 04 24 68 80 10 c0 	movl   $0xc0108068,(%esp)
c0105fe8:	e8 74 a3 ff ff       	call   c0100361 <cprintf>
}
c0105fed:	90                   	nop
c0105fee:	89 ec                	mov    %ebp,%esp
c0105ff0:	5d                   	pop    %ebp
c0105ff1:	c3                   	ret    

c0105ff2 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105ff2:	55                   	push   %ebp
c0105ff3:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105ff5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ff8:	83 e0 04             	and    $0x4,%eax
c0105ffb:	85 c0                	test   %eax,%eax
c0105ffd:	74 04                	je     c0106003 <perm2str+0x11>
c0105fff:	b0 75                	mov    $0x75,%al
c0106001:	eb 02                	jmp    c0106005 <perm2str+0x13>
c0106003:	b0 2d                	mov    $0x2d,%al
c0106005:	a2 28 ef 11 c0       	mov    %al,0xc011ef28
    str[1] = 'r';
c010600a:	c6 05 29 ef 11 c0 72 	movb   $0x72,0xc011ef29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0106011:	8b 45 08             	mov    0x8(%ebp),%eax
c0106014:	83 e0 02             	and    $0x2,%eax
c0106017:	85 c0                	test   %eax,%eax
c0106019:	74 04                	je     c010601f <perm2str+0x2d>
c010601b:	b0 77                	mov    $0x77,%al
c010601d:	eb 02                	jmp    c0106021 <perm2str+0x2f>
c010601f:	b0 2d                	mov    $0x2d,%al
c0106021:	a2 2a ef 11 c0       	mov    %al,0xc011ef2a
    str[3] = '\0';
c0106026:	c6 05 2b ef 11 c0 00 	movb   $0x0,0xc011ef2b
    return str;
c010602d:	b8 28 ef 11 c0       	mov    $0xc011ef28,%eax
}
c0106032:	5d                   	pop    %ebp
c0106033:	c3                   	ret    

c0106034 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0106034:	55                   	push   %ebp
c0106035:	89 e5                	mov    %esp,%ebp
c0106037:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010603a:	8b 45 10             	mov    0x10(%ebp),%eax
c010603d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106040:	72 0d                	jb     c010604f <get_pgtable_items+0x1b>
        return 0;
c0106042:	b8 00 00 00 00       	mov    $0x0,%eax
c0106047:	e9 98 00 00 00       	jmp    c01060e4 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c010604c:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c010604f:	8b 45 10             	mov    0x10(%ebp),%eax
c0106052:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106055:	73 18                	jae    c010606f <get_pgtable_items+0x3b>
c0106057:	8b 45 10             	mov    0x10(%ebp),%eax
c010605a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106061:	8b 45 14             	mov    0x14(%ebp),%eax
c0106064:	01 d0                	add    %edx,%eax
c0106066:	8b 00                	mov    (%eax),%eax
c0106068:	83 e0 01             	and    $0x1,%eax
c010606b:	85 c0                	test   %eax,%eax
c010606d:	74 dd                	je     c010604c <get_pgtable_items+0x18>
    }
    if (start < right) {
c010606f:	8b 45 10             	mov    0x10(%ebp),%eax
c0106072:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106075:	73 68                	jae    c01060df <get_pgtable_items+0xab>
        if (left_store != NULL) {
c0106077:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010607b:	74 08                	je     c0106085 <get_pgtable_items+0x51>
            *left_store = start;
c010607d:	8b 45 18             	mov    0x18(%ebp),%eax
c0106080:	8b 55 10             	mov    0x10(%ebp),%edx
c0106083:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0106085:	8b 45 10             	mov    0x10(%ebp),%eax
c0106088:	8d 50 01             	lea    0x1(%eax),%edx
c010608b:	89 55 10             	mov    %edx,0x10(%ebp)
c010608e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106095:	8b 45 14             	mov    0x14(%ebp),%eax
c0106098:	01 d0                	add    %edx,%eax
c010609a:	8b 00                	mov    (%eax),%eax
c010609c:	83 e0 07             	and    $0x7,%eax
c010609f:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01060a2:	eb 03                	jmp    c01060a7 <get_pgtable_items+0x73>
            start ++;
c01060a4:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01060a7:	8b 45 10             	mov    0x10(%ebp),%eax
c01060aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01060ad:	73 1d                	jae    c01060cc <get_pgtable_items+0x98>
c01060af:	8b 45 10             	mov    0x10(%ebp),%eax
c01060b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01060b9:	8b 45 14             	mov    0x14(%ebp),%eax
c01060bc:	01 d0                	add    %edx,%eax
c01060be:	8b 00                	mov    (%eax),%eax
c01060c0:	83 e0 07             	and    $0x7,%eax
c01060c3:	89 c2                	mov    %eax,%edx
c01060c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01060c8:	39 c2                	cmp    %eax,%edx
c01060ca:	74 d8                	je     c01060a4 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c01060cc:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01060d0:	74 08                	je     c01060da <get_pgtable_items+0xa6>
            *right_store = start;
c01060d2:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01060d5:	8b 55 10             	mov    0x10(%ebp),%edx
c01060d8:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01060da:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01060dd:	eb 05                	jmp    c01060e4 <get_pgtable_items+0xb0>
    }
    return 0;
c01060df:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01060e4:	89 ec                	mov    %ebp,%esp
c01060e6:	5d                   	pop    %ebp
c01060e7:	c3                   	ret    

c01060e8 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01060e8:	55                   	push   %ebp
c01060e9:	89 e5                	mov    %esp,%ebp
c01060eb:	57                   	push   %edi
c01060ec:	56                   	push   %esi
c01060ed:	53                   	push   %ebx
c01060ee:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01060f1:	c7 04 24 88 80 10 c0 	movl   $0xc0108088,(%esp)
c01060f8:	e8 64 a2 ff ff       	call   c0100361 <cprintf>
    size_t left, right = 0, perm;
c01060fd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106104:	e9 f2 00 00 00       	jmp    c01061fb <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106109:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010610c:	89 04 24             	mov    %eax,(%esp)
c010610f:	e8 de fe ff ff       	call   c0105ff2 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0106114:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106117:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c010611a:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010611c:	89 d6                	mov    %edx,%esi
c010611e:	c1 e6 16             	shl    $0x16,%esi
c0106121:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106124:	89 d3                	mov    %edx,%ebx
c0106126:	c1 e3 16             	shl    $0x16,%ebx
c0106129:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010612c:	89 d1                	mov    %edx,%ecx
c010612e:	c1 e1 16             	shl    $0x16,%ecx
c0106131:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106134:	8b 7d e0             	mov    -0x20(%ebp),%edi
c0106137:	29 fa                	sub    %edi,%edx
c0106139:	89 44 24 14          	mov    %eax,0x14(%esp)
c010613d:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106141:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106145:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106149:	89 54 24 04          	mov    %edx,0x4(%esp)
c010614d:	c7 04 24 b9 80 10 c0 	movl   $0xc01080b9,(%esp)
c0106154:	e8 08 a2 ff ff       	call   c0100361 <cprintf>
        size_t l, r = left * NPTEENTRY;
c0106159:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010615c:	c1 e0 0a             	shl    $0xa,%eax
c010615f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106162:	eb 50                	jmp    c01061b4 <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106164:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106167:	89 04 24             	mov    %eax,(%esp)
c010616a:	e8 83 fe ff ff       	call   c0105ff2 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c010616f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106172:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0106175:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106177:	89 d6                	mov    %edx,%esi
c0106179:	c1 e6 0c             	shl    $0xc,%esi
c010617c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010617f:	89 d3                	mov    %edx,%ebx
c0106181:	c1 e3 0c             	shl    $0xc,%ebx
c0106184:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106187:	89 d1                	mov    %edx,%ecx
c0106189:	c1 e1 0c             	shl    $0xc,%ecx
c010618c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010618f:	8b 7d d8             	mov    -0x28(%ebp),%edi
c0106192:	29 fa                	sub    %edi,%edx
c0106194:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106198:	89 74 24 10          	mov    %esi,0x10(%esp)
c010619c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01061a0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01061a4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01061a8:	c7 04 24 d8 80 10 c0 	movl   $0xc01080d8,(%esp)
c01061af:	e8 ad a1 ff ff       	call   c0100361 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01061b4:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c01061b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01061bc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01061bf:	89 d3                	mov    %edx,%ebx
c01061c1:	c1 e3 0a             	shl    $0xa,%ebx
c01061c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01061c7:	89 d1                	mov    %edx,%ecx
c01061c9:	c1 e1 0a             	shl    $0xa,%ecx
c01061cc:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c01061cf:	89 54 24 14          	mov    %edx,0x14(%esp)
c01061d3:	8d 55 d8             	lea    -0x28(%ebp),%edx
c01061d6:	89 54 24 10          	mov    %edx,0x10(%esp)
c01061da:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01061de:	89 44 24 08          	mov    %eax,0x8(%esp)
c01061e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01061e6:	89 0c 24             	mov    %ecx,(%esp)
c01061e9:	e8 46 fe ff ff       	call   c0106034 <get_pgtable_items>
c01061ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01061f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01061f5:	0f 85 69 ff ff ff    	jne    c0106164 <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01061fb:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0106200:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106203:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0106206:	89 54 24 14          	mov    %edx,0x14(%esp)
c010620a:	8d 55 e0             	lea    -0x20(%ebp),%edx
c010620d:	89 54 24 10          	mov    %edx,0x10(%esp)
c0106211:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0106215:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106219:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0106220:	00 
c0106221:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0106228:	e8 07 fe ff ff       	call   c0106034 <get_pgtable_items>
c010622d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106230:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106234:	0f 85 cf fe ff ff    	jne    c0106109 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010623a:	c7 04 24 fc 80 10 c0 	movl   $0xc01080fc,(%esp)
c0106241:	e8 1b a1 ff ff       	call   c0100361 <cprintf>
}
c0106246:	90                   	nop
c0106247:	83 c4 4c             	add    $0x4c,%esp
c010624a:	5b                   	pop    %ebx
c010624b:	5e                   	pop    %esi
c010624c:	5f                   	pop    %edi
c010624d:	5d                   	pop    %ebp
c010624e:	c3                   	ret    

c010624f <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010624f:	55                   	push   %ebp
c0106250:	89 e5                	mov    %esp,%ebp
c0106252:	83 ec 58             	sub    $0x58,%esp
c0106255:	8b 45 10             	mov    0x10(%ebp),%eax
c0106258:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010625b:	8b 45 14             	mov    0x14(%ebp),%eax
c010625e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0106261:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106264:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106267:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010626a:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010626d:	8b 45 18             	mov    0x18(%ebp),%eax
c0106270:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106273:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106276:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106279:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010627c:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010627f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106282:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106285:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106289:	74 1c                	je     c01062a7 <printnum+0x58>
c010628b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010628e:	ba 00 00 00 00       	mov    $0x0,%edx
c0106293:	f7 75 e4             	divl   -0x1c(%ebp)
c0106296:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0106299:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010629c:	ba 00 00 00 00       	mov    $0x0,%edx
c01062a1:	f7 75 e4             	divl   -0x1c(%ebp)
c01062a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01062a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01062aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01062ad:	f7 75 e4             	divl   -0x1c(%ebp)
c01062b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01062b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01062b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01062b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01062bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01062bf:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01062c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01062c5:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01062c8:	8b 45 18             	mov    0x18(%ebp),%eax
c01062cb:	ba 00 00 00 00       	mov    $0x0,%edx
c01062d0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01062d3:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01062d6:	19 d1                	sbb    %edx,%ecx
c01062d8:	72 4c                	jb     c0106326 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
c01062da:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01062dd:	8d 50 ff             	lea    -0x1(%eax),%edx
c01062e0:	8b 45 20             	mov    0x20(%ebp),%eax
c01062e3:	89 44 24 18          	mov    %eax,0x18(%esp)
c01062e7:	89 54 24 14          	mov    %edx,0x14(%esp)
c01062eb:	8b 45 18             	mov    0x18(%ebp),%eax
c01062ee:	89 44 24 10          	mov    %eax,0x10(%esp)
c01062f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01062f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01062f8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01062fc:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106300:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106303:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106307:	8b 45 08             	mov    0x8(%ebp),%eax
c010630a:	89 04 24             	mov    %eax,(%esp)
c010630d:	e8 3d ff ff ff       	call   c010624f <printnum>
c0106312:	eb 1b                	jmp    c010632f <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0106314:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106317:	89 44 24 04          	mov    %eax,0x4(%esp)
c010631b:	8b 45 20             	mov    0x20(%ebp),%eax
c010631e:	89 04 24             	mov    %eax,(%esp)
c0106321:	8b 45 08             	mov    0x8(%ebp),%eax
c0106324:	ff d0                	call   *%eax
        while (-- width > 0)
c0106326:	ff 4d 1c             	decl   0x1c(%ebp)
c0106329:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010632d:	7f e5                	jg     c0106314 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010632f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106332:	05 b0 81 10 c0       	add    $0xc01081b0,%eax
c0106337:	0f b6 00             	movzbl (%eax),%eax
c010633a:	0f be c0             	movsbl %al,%eax
c010633d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106340:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106344:	89 04 24             	mov    %eax,(%esp)
c0106347:	8b 45 08             	mov    0x8(%ebp),%eax
c010634a:	ff d0                	call   *%eax
}
c010634c:	90                   	nop
c010634d:	89 ec                	mov    %ebp,%esp
c010634f:	5d                   	pop    %ebp
c0106350:	c3                   	ret    

c0106351 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0106351:	55                   	push   %ebp
c0106352:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0106354:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0106358:	7e 14                	jle    c010636e <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010635a:	8b 45 08             	mov    0x8(%ebp),%eax
c010635d:	8b 00                	mov    (%eax),%eax
c010635f:	8d 48 08             	lea    0x8(%eax),%ecx
c0106362:	8b 55 08             	mov    0x8(%ebp),%edx
c0106365:	89 0a                	mov    %ecx,(%edx)
c0106367:	8b 50 04             	mov    0x4(%eax),%edx
c010636a:	8b 00                	mov    (%eax),%eax
c010636c:	eb 30                	jmp    c010639e <getuint+0x4d>
    }
    else if (lflag) {
c010636e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106372:	74 16                	je     c010638a <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0106374:	8b 45 08             	mov    0x8(%ebp),%eax
c0106377:	8b 00                	mov    (%eax),%eax
c0106379:	8d 48 04             	lea    0x4(%eax),%ecx
c010637c:	8b 55 08             	mov    0x8(%ebp),%edx
c010637f:	89 0a                	mov    %ecx,(%edx)
c0106381:	8b 00                	mov    (%eax),%eax
c0106383:	ba 00 00 00 00       	mov    $0x0,%edx
c0106388:	eb 14                	jmp    c010639e <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010638a:	8b 45 08             	mov    0x8(%ebp),%eax
c010638d:	8b 00                	mov    (%eax),%eax
c010638f:	8d 48 04             	lea    0x4(%eax),%ecx
c0106392:	8b 55 08             	mov    0x8(%ebp),%edx
c0106395:	89 0a                	mov    %ecx,(%edx)
c0106397:	8b 00                	mov    (%eax),%eax
c0106399:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010639e:	5d                   	pop    %ebp
c010639f:	c3                   	ret    

c01063a0 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01063a0:	55                   	push   %ebp
c01063a1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01063a3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01063a7:	7e 14                	jle    c01063bd <getint+0x1d>
        return va_arg(*ap, long long);
c01063a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01063ac:	8b 00                	mov    (%eax),%eax
c01063ae:	8d 48 08             	lea    0x8(%eax),%ecx
c01063b1:	8b 55 08             	mov    0x8(%ebp),%edx
c01063b4:	89 0a                	mov    %ecx,(%edx)
c01063b6:	8b 50 04             	mov    0x4(%eax),%edx
c01063b9:	8b 00                	mov    (%eax),%eax
c01063bb:	eb 28                	jmp    c01063e5 <getint+0x45>
    }
    else if (lflag) {
c01063bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01063c1:	74 12                	je     c01063d5 <getint+0x35>
        return va_arg(*ap, long);
c01063c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01063c6:	8b 00                	mov    (%eax),%eax
c01063c8:	8d 48 04             	lea    0x4(%eax),%ecx
c01063cb:	8b 55 08             	mov    0x8(%ebp),%edx
c01063ce:	89 0a                	mov    %ecx,(%edx)
c01063d0:	8b 00                	mov    (%eax),%eax
c01063d2:	99                   	cltd   
c01063d3:	eb 10                	jmp    c01063e5 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01063d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01063d8:	8b 00                	mov    (%eax),%eax
c01063da:	8d 48 04             	lea    0x4(%eax),%ecx
c01063dd:	8b 55 08             	mov    0x8(%ebp),%edx
c01063e0:	89 0a                	mov    %ecx,(%edx)
c01063e2:	8b 00                	mov    (%eax),%eax
c01063e4:	99                   	cltd   
    }
}
c01063e5:	5d                   	pop    %ebp
c01063e6:	c3                   	ret    

c01063e7 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01063e7:	55                   	push   %ebp
c01063e8:	89 e5                	mov    %esp,%ebp
c01063ea:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01063ed:	8d 45 14             	lea    0x14(%ebp),%eax
c01063f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01063f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01063f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01063fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01063fd:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106401:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106404:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106408:	8b 45 08             	mov    0x8(%ebp),%eax
c010640b:	89 04 24             	mov    %eax,(%esp)
c010640e:	e8 05 00 00 00       	call   c0106418 <vprintfmt>
    va_end(ap);
}
c0106413:	90                   	nop
c0106414:	89 ec                	mov    %ebp,%esp
c0106416:	5d                   	pop    %ebp
c0106417:	c3                   	ret    

c0106418 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0106418:	55                   	push   %ebp
c0106419:	89 e5                	mov    %esp,%ebp
c010641b:	56                   	push   %esi
c010641c:	53                   	push   %ebx
c010641d:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0106420:	eb 17                	jmp    c0106439 <vprintfmt+0x21>
            if (ch == '\0') {
c0106422:	85 db                	test   %ebx,%ebx
c0106424:	0f 84 bf 03 00 00    	je     c01067e9 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c010642a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010642d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106431:	89 1c 24             	mov    %ebx,(%esp)
c0106434:	8b 45 08             	mov    0x8(%ebp),%eax
c0106437:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0106439:	8b 45 10             	mov    0x10(%ebp),%eax
c010643c:	8d 50 01             	lea    0x1(%eax),%edx
c010643f:	89 55 10             	mov    %edx,0x10(%ebp)
c0106442:	0f b6 00             	movzbl (%eax),%eax
c0106445:	0f b6 d8             	movzbl %al,%ebx
c0106448:	83 fb 25             	cmp    $0x25,%ebx
c010644b:	75 d5                	jne    c0106422 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c010644d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0106451:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0106458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010645b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010645e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106465:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106468:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010646b:	8b 45 10             	mov    0x10(%ebp),%eax
c010646e:	8d 50 01             	lea    0x1(%eax),%edx
c0106471:	89 55 10             	mov    %edx,0x10(%ebp)
c0106474:	0f b6 00             	movzbl (%eax),%eax
c0106477:	0f b6 d8             	movzbl %al,%ebx
c010647a:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010647d:	83 f8 55             	cmp    $0x55,%eax
c0106480:	0f 87 37 03 00 00    	ja     c01067bd <vprintfmt+0x3a5>
c0106486:	8b 04 85 d4 81 10 c0 	mov    -0x3fef7e2c(,%eax,4),%eax
c010648d:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010648f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0106493:	eb d6                	jmp    c010646b <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0106495:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0106499:	eb d0                	jmp    c010646b <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010649b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01064a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01064a5:	89 d0                	mov    %edx,%eax
c01064a7:	c1 e0 02             	shl    $0x2,%eax
c01064aa:	01 d0                	add    %edx,%eax
c01064ac:	01 c0                	add    %eax,%eax
c01064ae:	01 d8                	add    %ebx,%eax
c01064b0:	83 e8 30             	sub    $0x30,%eax
c01064b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01064b6:	8b 45 10             	mov    0x10(%ebp),%eax
c01064b9:	0f b6 00             	movzbl (%eax),%eax
c01064bc:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01064bf:	83 fb 2f             	cmp    $0x2f,%ebx
c01064c2:	7e 38                	jle    c01064fc <vprintfmt+0xe4>
c01064c4:	83 fb 39             	cmp    $0x39,%ebx
c01064c7:	7f 33                	jg     c01064fc <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c01064c9:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c01064cc:	eb d4                	jmp    c01064a2 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c01064ce:	8b 45 14             	mov    0x14(%ebp),%eax
c01064d1:	8d 50 04             	lea    0x4(%eax),%edx
c01064d4:	89 55 14             	mov    %edx,0x14(%ebp)
c01064d7:	8b 00                	mov    (%eax),%eax
c01064d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01064dc:	eb 1f                	jmp    c01064fd <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c01064de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01064e2:	79 87                	jns    c010646b <vprintfmt+0x53>
                width = 0;
c01064e4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01064eb:	e9 7b ff ff ff       	jmp    c010646b <vprintfmt+0x53>

        case '#':
            altflag = 1;
c01064f0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01064f7:	e9 6f ff ff ff       	jmp    c010646b <vprintfmt+0x53>
            goto process_precision;
c01064fc:	90                   	nop

        process_precision:
            if (width < 0)
c01064fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106501:	0f 89 64 ff ff ff    	jns    c010646b <vprintfmt+0x53>
                width = precision, precision = -1;
c0106507:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010650a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010650d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0106514:	e9 52 ff ff ff       	jmp    c010646b <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0106519:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c010651c:	e9 4a ff ff ff       	jmp    c010646b <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0106521:	8b 45 14             	mov    0x14(%ebp),%eax
c0106524:	8d 50 04             	lea    0x4(%eax),%edx
c0106527:	89 55 14             	mov    %edx,0x14(%ebp)
c010652a:	8b 00                	mov    (%eax),%eax
c010652c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010652f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106533:	89 04 24             	mov    %eax,(%esp)
c0106536:	8b 45 08             	mov    0x8(%ebp),%eax
c0106539:	ff d0                	call   *%eax
            break;
c010653b:	e9 a4 02 00 00       	jmp    c01067e4 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0106540:	8b 45 14             	mov    0x14(%ebp),%eax
c0106543:	8d 50 04             	lea    0x4(%eax),%edx
c0106546:	89 55 14             	mov    %edx,0x14(%ebp)
c0106549:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010654b:	85 db                	test   %ebx,%ebx
c010654d:	79 02                	jns    c0106551 <vprintfmt+0x139>
                err = -err;
c010654f:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0106551:	83 fb 06             	cmp    $0x6,%ebx
c0106554:	7f 0b                	jg     c0106561 <vprintfmt+0x149>
c0106556:	8b 34 9d 94 81 10 c0 	mov    -0x3fef7e6c(,%ebx,4),%esi
c010655d:	85 f6                	test   %esi,%esi
c010655f:	75 23                	jne    c0106584 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c0106561:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106565:	c7 44 24 08 c1 81 10 	movl   $0xc01081c1,0x8(%esp)
c010656c:	c0 
c010656d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106570:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106574:	8b 45 08             	mov    0x8(%ebp),%eax
c0106577:	89 04 24             	mov    %eax,(%esp)
c010657a:	e8 68 fe ff ff       	call   c01063e7 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010657f:	e9 60 02 00 00       	jmp    c01067e4 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c0106584:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0106588:	c7 44 24 08 ca 81 10 	movl   $0xc01081ca,0x8(%esp)
c010658f:	c0 
c0106590:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106593:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106597:	8b 45 08             	mov    0x8(%ebp),%eax
c010659a:	89 04 24             	mov    %eax,(%esp)
c010659d:	e8 45 fe ff ff       	call   c01063e7 <printfmt>
            break;
c01065a2:	e9 3d 02 00 00       	jmp    c01067e4 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01065a7:	8b 45 14             	mov    0x14(%ebp),%eax
c01065aa:	8d 50 04             	lea    0x4(%eax),%edx
c01065ad:	89 55 14             	mov    %edx,0x14(%ebp)
c01065b0:	8b 30                	mov    (%eax),%esi
c01065b2:	85 f6                	test   %esi,%esi
c01065b4:	75 05                	jne    c01065bb <vprintfmt+0x1a3>
                p = "(null)";
c01065b6:	be cd 81 10 c0       	mov    $0xc01081cd,%esi
            }
            if (width > 0 && padc != '-') {
c01065bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01065bf:	7e 76                	jle    c0106637 <vprintfmt+0x21f>
c01065c1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01065c5:	74 70                	je     c0106637 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01065c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01065ca:	89 44 24 04          	mov    %eax,0x4(%esp)
c01065ce:	89 34 24             	mov    %esi,(%esp)
c01065d1:	e8 16 03 00 00       	call   c01068ec <strnlen>
c01065d6:	89 c2                	mov    %eax,%edx
c01065d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01065db:	29 d0                	sub    %edx,%eax
c01065dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01065e0:	eb 16                	jmp    c01065f8 <vprintfmt+0x1e0>
                    putch(padc, putdat);
c01065e2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01065e6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01065e9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01065ed:	89 04 24             	mov    %eax,(%esp)
c01065f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01065f3:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c01065f5:	ff 4d e8             	decl   -0x18(%ebp)
c01065f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01065fc:	7f e4                	jg     c01065e2 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01065fe:	eb 37                	jmp    c0106637 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c0106600:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0106604:	74 1f                	je     c0106625 <vprintfmt+0x20d>
c0106606:	83 fb 1f             	cmp    $0x1f,%ebx
c0106609:	7e 05                	jle    c0106610 <vprintfmt+0x1f8>
c010660b:	83 fb 7e             	cmp    $0x7e,%ebx
c010660e:	7e 15                	jle    c0106625 <vprintfmt+0x20d>
                    putch('?', putdat);
c0106610:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106613:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106617:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010661e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106621:	ff d0                	call   *%eax
c0106623:	eb 0f                	jmp    c0106634 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c0106625:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106628:	89 44 24 04          	mov    %eax,0x4(%esp)
c010662c:	89 1c 24             	mov    %ebx,(%esp)
c010662f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106632:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0106634:	ff 4d e8             	decl   -0x18(%ebp)
c0106637:	89 f0                	mov    %esi,%eax
c0106639:	8d 70 01             	lea    0x1(%eax),%esi
c010663c:	0f b6 00             	movzbl (%eax),%eax
c010663f:	0f be d8             	movsbl %al,%ebx
c0106642:	85 db                	test   %ebx,%ebx
c0106644:	74 27                	je     c010666d <vprintfmt+0x255>
c0106646:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010664a:	78 b4                	js     c0106600 <vprintfmt+0x1e8>
c010664c:	ff 4d e4             	decl   -0x1c(%ebp)
c010664f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106653:	79 ab                	jns    c0106600 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c0106655:	eb 16                	jmp    c010666d <vprintfmt+0x255>
                putch(' ', putdat);
c0106657:	8b 45 0c             	mov    0xc(%ebp),%eax
c010665a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010665e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0106665:	8b 45 08             	mov    0x8(%ebp),%eax
c0106668:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c010666a:	ff 4d e8             	decl   -0x18(%ebp)
c010666d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106671:	7f e4                	jg     c0106657 <vprintfmt+0x23f>
            }
            break;
c0106673:	e9 6c 01 00 00       	jmp    c01067e4 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0106678:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010667b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010667f:	8d 45 14             	lea    0x14(%ebp),%eax
c0106682:	89 04 24             	mov    %eax,(%esp)
c0106685:	e8 16 fd ff ff       	call   c01063a0 <getint>
c010668a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010668d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0106690:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106693:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106696:	85 d2                	test   %edx,%edx
c0106698:	79 26                	jns    c01066c0 <vprintfmt+0x2a8>
                putch('-', putdat);
c010669a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010669d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01066a1:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01066a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01066ab:	ff d0                	call   *%eax
                num = -(long long)num;
c01066ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01066b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01066b3:	f7 d8                	neg    %eax
c01066b5:	83 d2 00             	adc    $0x0,%edx
c01066b8:	f7 da                	neg    %edx
c01066ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01066bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01066c0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01066c7:	e9 a8 00 00 00       	jmp    c0106774 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01066cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01066d3:	8d 45 14             	lea    0x14(%ebp),%eax
c01066d6:	89 04 24             	mov    %eax,(%esp)
c01066d9:	e8 73 fc ff ff       	call   c0106351 <getuint>
c01066de:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01066e1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01066e4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01066eb:	e9 84 00 00 00       	jmp    c0106774 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01066f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01066f7:	8d 45 14             	lea    0x14(%ebp),%eax
c01066fa:	89 04 24             	mov    %eax,(%esp)
c01066fd:	e8 4f fc ff ff       	call   c0106351 <getuint>
c0106702:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106705:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0106708:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010670f:	eb 63                	jmp    c0106774 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c0106711:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106714:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106718:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010671f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106722:	ff d0                	call   *%eax
            putch('x', putdat);
c0106724:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106727:	89 44 24 04          	mov    %eax,0x4(%esp)
c010672b:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0106732:	8b 45 08             	mov    0x8(%ebp),%eax
c0106735:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0106737:	8b 45 14             	mov    0x14(%ebp),%eax
c010673a:	8d 50 04             	lea    0x4(%eax),%edx
c010673d:	89 55 14             	mov    %edx,0x14(%ebp)
c0106740:	8b 00                	mov    (%eax),%eax
c0106742:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106745:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010674c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0106753:	eb 1f                	jmp    c0106774 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0106755:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106758:	89 44 24 04          	mov    %eax,0x4(%esp)
c010675c:	8d 45 14             	lea    0x14(%ebp),%eax
c010675f:	89 04 24             	mov    %eax,(%esp)
c0106762:	e8 ea fb ff ff       	call   c0106351 <getuint>
c0106767:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010676a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010676d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0106774:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0106778:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010677b:	89 54 24 18          	mov    %edx,0x18(%esp)
c010677f:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106782:	89 54 24 14          	mov    %edx,0x14(%esp)
c0106786:	89 44 24 10          	mov    %eax,0x10(%esp)
c010678a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010678d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106790:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106794:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106798:	8b 45 0c             	mov    0xc(%ebp),%eax
c010679b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010679f:	8b 45 08             	mov    0x8(%ebp),%eax
c01067a2:	89 04 24             	mov    %eax,(%esp)
c01067a5:	e8 a5 fa ff ff       	call   c010624f <printnum>
            break;
c01067aa:	eb 38                	jmp    c01067e4 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01067ac:	8b 45 0c             	mov    0xc(%ebp),%eax
c01067af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01067b3:	89 1c 24             	mov    %ebx,(%esp)
c01067b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01067b9:	ff d0                	call   *%eax
            break;
c01067bb:	eb 27                	jmp    c01067e4 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01067bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01067c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01067c4:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01067cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01067ce:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01067d0:	ff 4d 10             	decl   0x10(%ebp)
c01067d3:	eb 03                	jmp    c01067d8 <vprintfmt+0x3c0>
c01067d5:	ff 4d 10             	decl   0x10(%ebp)
c01067d8:	8b 45 10             	mov    0x10(%ebp),%eax
c01067db:	48                   	dec    %eax
c01067dc:	0f b6 00             	movzbl (%eax),%eax
c01067df:	3c 25                	cmp    $0x25,%al
c01067e1:	75 f2                	jne    c01067d5 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c01067e3:	90                   	nop
    while (1) {
c01067e4:	e9 37 fc ff ff       	jmp    c0106420 <vprintfmt+0x8>
                return;
c01067e9:	90                   	nop
        }
    }
}
c01067ea:	83 c4 40             	add    $0x40,%esp
c01067ed:	5b                   	pop    %ebx
c01067ee:	5e                   	pop    %esi
c01067ef:	5d                   	pop    %ebp
c01067f0:	c3                   	ret    

c01067f1 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01067f1:	55                   	push   %ebp
c01067f2:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01067f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01067f7:	8b 40 08             	mov    0x8(%eax),%eax
c01067fa:	8d 50 01             	lea    0x1(%eax),%edx
c01067fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106800:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0106803:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106806:	8b 10                	mov    (%eax),%edx
c0106808:	8b 45 0c             	mov    0xc(%ebp),%eax
c010680b:	8b 40 04             	mov    0x4(%eax),%eax
c010680e:	39 c2                	cmp    %eax,%edx
c0106810:	73 12                	jae    c0106824 <sprintputch+0x33>
        *b->buf ++ = ch;
c0106812:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106815:	8b 00                	mov    (%eax),%eax
c0106817:	8d 48 01             	lea    0x1(%eax),%ecx
c010681a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010681d:	89 0a                	mov    %ecx,(%edx)
c010681f:	8b 55 08             	mov    0x8(%ebp),%edx
c0106822:	88 10                	mov    %dl,(%eax)
    }
}
c0106824:	90                   	nop
c0106825:	5d                   	pop    %ebp
c0106826:	c3                   	ret    

c0106827 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0106827:	55                   	push   %ebp
c0106828:	89 e5                	mov    %esp,%ebp
c010682a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010682d:	8d 45 14             	lea    0x14(%ebp),%eax
c0106830:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0106833:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106836:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010683a:	8b 45 10             	mov    0x10(%ebp),%eax
c010683d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106841:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106844:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106848:	8b 45 08             	mov    0x8(%ebp),%eax
c010684b:	89 04 24             	mov    %eax,(%esp)
c010684e:	e8 0a 00 00 00       	call   c010685d <vsnprintf>
c0106853:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0106856:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106859:	89 ec                	mov    %ebp,%esp
c010685b:	5d                   	pop    %ebp
c010685c:	c3                   	ret    

c010685d <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c010685d:	55                   	push   %ebp
c010685e:	89 e5                	mov    %esp,%ebp
c0106860:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0106863:	8b 45 08             	mov    0x8(%ebp),%eax
c0106866:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106869:	8b 45 0c             	mov    0xc(%ebp),%eax
c010686c:	8d 50 ff             	lea    -0x1(%eax),%edx
c010686f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106872:	01 d0                	add    %edx,%eax
c0106874:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106877:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c010687e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106882:	74 0a                	je     c010688e <vsnprintf+0x31>
c0106884:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106887:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010688a:	39 c2                	cmp    %eax,%edx
c010688c:	76 07                	jbe    c0106895 <vsnprintf+0x38>
        return -E_INVAL;
c010688e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0106893:	eb 2a                	jmp    c01068bf <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0106895:	8b 45 14             	mov    0x14(%ebp),%eax
c0106898:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010689c:	8b 45 10             	mov    0x10(%ebp),%eax
c010689f:	89 44 24 08          	mov    %eax,0x8(%esp)
c01068a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01068a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01068aa:	c7 04 24 f1 67 10 c0 	movl   $0xc01067f1,(%esp)
c01068b1:	e8 62 fb ff ff       	call   c0106418 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01068b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01068b9:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01068bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01068bf:	89 ec                	mov    %ebp,%esp
c01068c1:	5d                   	pop    %ebp
c01068c2:	c3                   	ret    

c01068c3 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01068c3:	55                   	push   %ebp
c01068c4:	89 e5                	mov    %esp,%ebp
c01068c6:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01068c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01068d0:	eb 03                	jmp    c01068d5 <strlen+0x12>
        cnt ++;
c01068d2:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c01068d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01068d8:	8d 50 01             	lea    0x1(%eax),%edx
c01068db:	89 55 08             	mov    %edx,0x8(%ebp)
c01068de:	0f b6 00             	movzbl (%eax),%eax
c01068e1:	84 c0                	test   %al,%al
c01068e3:	75 ed                	jne    c01068d2 <strlen+0xf>
    }
    return cnt;
c01068e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01068e8:	89 ec                	mov    %ebp,%esp
c01068ea:	5d                   	pop    %ebp
c01068eb:	c3                   	ret    

c01068ec <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01068ec:	55                   	push   %ebp
c01068ed:	89 e5                	mov    %esp,%ebp
c01068ef:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01068f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01068f9:	eb 03                	jmp    c01068fe <strnlen+0x12>
        cnt ++;
c01068fb:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01068fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106901:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106904:	73 10                	jae    c0106916 <strnlen+0x2a>
c0106906:	8b 45 08             	mov    0x8(%ebp),%eax
c0106909:	8d 50 01             	lea    0x1(%eax),%edx
c010690c:	89 55 08             	mov    %edx,0x8(%ebp)
c010690f:	0f b6 00             	movzbl (%eax),%eax
c0106912:	84 c0                	test   %al,%al
c0106914:	75 e5                	jne    c01068fb <strnlen+0xf>
    }
    return cnt;
c0106916:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0106919:	89 ec                	mov    %ebp,%esp
c010691b:	5d                   	pop    %ebp
c010691c:	c3                   	ret    

c010691d <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010691d:	55                   	push   %ebp
c010691e:	89 e5                	mov    %esp,%ebp
c0106920:	57                   	push   %edi
c0106921:	56                   	push   %esi
c0106922:	83 ec 20             	sub    $0x20,%esp
c0106925:	8b 45 08             	mov    0x8(%ebp),%eax
c0106928:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010692b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010692e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0106931:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106934:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106937:	89 d1                	mov    %edx,%ecx
c0106939:	89 c2                	mov    %eax,%edx
c010693b:	89 ce                	mov    %ecx,%esi
c010693d:	89 d7                	mov    %edx,%edi
c010693f:	ac                   	lods   %ds:(%esi),%al
c0106940:	aa                   	stos   %al,%es:(%edi)
c0106941:	84 c0                	test   %al,%al
c0106943:	75 fa                	jne    c010693f <strcpy+0x22>
c0106945:	89 fa                	mov    %edi,%edx
c0106947:	89 f1                	mov    %esi,%ecx
c0106949:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010694c:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010694f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0106952:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0106955:	83 c4 20             	add    $0x20,%esp
c0106958:	5e                   	pop    %esi
c0106959:	5f                   	pop    %edi
c010695a:	5d                   	pop    %ebp
c010695b:	c3                   	ret    

c010695c <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010695c:	55                   	push   %ebp
c010695d:	89 e5                	mov    %esp,%ebp
c010695f:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0106962:	8b 45 08             	mov    0x8(%ebp),%eax
c0106965:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0106968:	eb 1e                	jmp    c0106988 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c010696a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010696d:	0f b6 10             	movzbl (%eax),%edx
c0106970:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106973:	88 10                	mov    %dl,(%eax)
c0106975:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106978:	0f b6 00             	movzbl (%eax),%eax
c010697b:	84 c0                	test   %al,%al
c010697d:	74 03                	je     c0106982 <strncpy+0x26>
            src ++;
c010697f:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0106982:	ff 45 fc             	incl   -0x4(%ebp)
c0106985:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c0106988:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010698c:	75 dc                	jne    c010696a <strncpy+0xe>
    }
    return dst;
c010698e:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0106991:	89 ec                	mov    %ebp,%esp
c0106993:	5d                   	pop    %ebp
c0106994:	c3                   	ret    

c0106995 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0106995:	55                   	push   %ebp
c0106996:	89 e5                	mov    %esp,%ebp
c0106998:	57                   	push   %edi
c0106999:	56                   	push   %esi
c010699a:	83 ec 20             	sub    $0x20,%esp
c010699d:	8b 45 08             	mov    0x8(%ebp),%eax
c01069a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01069a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01069a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c01069a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01069ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01069af:	89 d1                	mov    %edx,%ecx
c01069b1:	89 c2                	mov    %eax,%edx
c01069b3:	89 ce                	mov    %ecx,%esi
c01069b5:	89 d7                	mov    %edx,%edi
c01069b7:	ac                   	lods   %ds:(%esi),%al
c01069b8:	ae                   	scas   %es:(%edi),%al
c01069b9:	75 08                	jne    c01069c3 <strcmp+0x2e>
c01069bb:	84 c0                	test   %al,%al
c01069bd:	75 f8                	jne    c01069b7 <strcmp+0x22>
c01069bf:	31 c0                	xor    %eax,%eax
c01069c1:	eb 04                	jmp    c01069c7 <strcmp+0x32>
c01069c3:	19 c0                	sbb    %eax,%eax
c01069c5:	0c 01                	or     $0x1,%al
c01069c7:	89 fa                	mov    %edi,%edx
c01069c9:	89 f1                	mov    %esi,%ecx
c01069cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01069ce:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01069d1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c01069d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01069d7:	83 c4 20             	add    $0x20,%esp
c01069da:	5e                   	pop    %esi
c01069db:	5f                   	pop    %edi
c01069dc:	5d                   	pop    %ebp
c01069dd:	c3                   	ret    

c01069de <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01069de:	55                   	push   %ebp
c01069df:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01069e1:	eb 09                	jmp    c01069ec <strncmp+0xe>
        n --, s1 ++, s2 ++;
c01069e3:	ff 4d 10             	decl   0x10(%ebp)
c01069e6:	ff 45 08             	incl   0x8(%ebp)
c01069e9:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01069ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01069f0:	74 1a                	je     c0106a0c <strncmp+0x2e>
c01069f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01069f5:	0f b6 00             	movzbl (%eax),%eax
c01069f8:	84 c0                	test   %al,%al
c01069fa:	74 10                	je     c0106a0c <strncmp+0x2e>
c01069fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01069ff:	0f b6 10             	movzbl (%eax),%edx
c0106a02:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106a05:	0f b6 00             	movzbl (%eax),%eax
c0106a08:	38 c2                	cmp    %al,%dl
c0106a0a:	74 d7                	je     c01069e3 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0106a0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106a10:	74 18                	je     c0106a2a <strncmp+0x4c>
c0106a12:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a15:	0f b6 00             	movzbl (%eax),%eax
c0106a18:	0f b6 d0             	movzbl %al,%edx
c0106a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106a1e:	0f b6 00             	movzbl (%eax),%eax
c0106a21:	0f b6 c8             	movzbl %al,%ecx
c0106a24:	89 d0                	mov    %edx,%eax
c0106a26:	29 c8                	sub    %ecx,%eax
c0106a28:	eb 05                	jmp    c0106a2f <strncmp+0x51>
c0106a2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106a2f:	5d                   	pop    %ebp
c0106a30:	c3                   	ret    

c0106a31 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0106a31:	55                   	push   %ebp
c0106a32:	89 e5                	mov    %esp,%ebp
c0106a34:	83 ec 04             	sub    $0x4,%esp
c0106a37:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106a3a:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0106a3d:	eb 13                	jmp    c0106a52 <strchr+0x21>
        if (*s == c) {
c0106a3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a42:	0f b6 00             	movzbl (%eax),%eax
c0106a45:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0106a48:	75 05                	jne    c0106a4f <strchr+0x1e>
            return (char *)s;
c0106a4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a4d:	eb 12                	jmp    c0106a61 <strchr+0x30>
        }
        s ++;
c0106a4f:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0106a52:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a55:	0f b6 00             	movzbl (%eax),%eax
c0106a58:	84 c0                	test   %al,%al
c0106a5a:	75 e3                	jne    c0106a3f <strchr+0xe>
    }
    return NULL;
c0106a5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106a61:	89 ec                	mov    %ebp,%esp
c0106a63:	5d                   	pop    %ebp
c0106a64:	c3                   	ret    

c0106a65 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0106a65:	55                   	push   %ebp
c0106a66:	89 e5                	mov    %esp,%ebp
c0106a68:	83 ec 04             	sub    $0x4,%esp
c0106a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106a6e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0106a71:	eb 0e                	jmp    c0106a81 <strfind+0x1c>
        if (*s == c) {
c0106a73:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a76:	0f b6 00             	movzbl (%eax),%eax
c0106a79:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0106a7c:	74 0f                	je     c0106a8d <strfind+0x28>
            break;
        }
        s ++;
c0106a7e:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0106a81:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a84:	0f b6 00             	movzbl (%eax),%eax
c0106a87:	84 c0                	test   %al,%al
c0106a89:	75 e8                	jne    c0106a73 <strfind+0xe>
c0106a8b:	eb 01                	jmp    c0106a8e <strfind+0x29>
            break;
c0106a8d:	90                   	nop
    }
    return (char *)s;
c0106a8e:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0106a91:	89 ec                	mov    %ebp,%esp
c0106a93:	5d                   	pop    %ebp
c0106a94:	c3                   	ret    

c0106a95 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0106a95:	55                   	push   %ebp
c0106a96:	89 e5                	mov    %esp,%ebp
c0106a98:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0106a9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0106aa2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0106aa9:	eb 03                	jmp    c0106aae <strtol+0x19>
        s ++;
c0106aab:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0106aae:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ab1:	0f b6 00             	movzbl (%eax),%eax
c0106ab4:	3c 20                	cmp    $0x20,%al
c0106ab6:	74 f3                	je     c0106aab <strtol+0x16>
c0106ab8:	8b 45 08             	mov    0x8(%ebp),%eax
c0106abb:	0f b6 00             	movzbl (%eax),%eax
c0106abe:	3c 09                	cmp    $0x9,%al
c0106ac0:	74 e9                	je     c0106aab <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0106ac2:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ac5:	0f b6 00             	movzbl (%eax),%eax
c0106ac8:	3c 2b                	cmp    $0x2b,%al
c0106aca:	75 05                	jne    c0106ad1 <strtol+0x3c>
        s ++;
c0106acc:	ff 45 08             	incl   0x8(%ebp)
c0106acf:	eb 14                	jmp    c0106ae5 <strtol+0x50>
    }
    else if (*s == '-') {
c0106ad1:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ad4:	0f b6 00             	movzbl (%eax),%eax
c0106ad7:	3c 2d                	cmp    $0x2d,%al
c0106ad9:	75 0a                	jne    c0106ae5 <strtol+0x50>
        s ++, neg = 1;
c0106adb:	ff 45 08             	incl   0x8(%ebp)
c0106ade:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0106ae5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106ae9:	74 06                	je     c0106af1 <strtol+0x5c>
c0106aeb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0106aef:	75 22                	jne    c0106b13 <strtol+0x7e>
c0106af1:	8b 45 08             	mov    0x8(%ebp),%eax
c0106af4:	0f b6 00             	movzbl (%eax),%eax
c0106af7:	3c 30                	cmp    $0x30,%al
c0106af9:	75 18                	jne    c0106b13 <strtol+0x7e>
c0106afb:	8b 45 08             	mov    0x8(%ebp),%eax
c0106afe:	40                   	inc    %eax
c0106aff:	0f b6 00             	movzbl (%eax),%eax
c0106b02:	3c 78                	cmp    $0x78,%al
c0106b04:	75 0d                	jne    c0106b13 <strtol+0x7e>
        s += 2, base = 16;
c0106b06:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0106b0a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0106b11:	eb 29                	jmp    c0106b3c <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c0106b13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106b17:	75 16                	jne    c0106b2f <strtol+0x9a>
c0106b19:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b1c:	0f b6 00             	movzbl (%eax),%eax
c0106b1f:	3c 30                	cmp    $0x30,%al
c0106b21:	75 0c                	jne    c0106b2f <strtol+0x9a>
        s ++, base = 8;
c0106b23:	ff 45 08             	incl   0x8(%ebp)
c0106b26:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0106b2d:	eb 0d                	jmp    c0106b3c <strtol+0xa7>
    }
    else if (base == 0) {
c0106b2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106b33:	75 07                	jne    c0106b3c <strtol+0xa7>
        base = 10;
c0106b35:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0106b3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b3f:	0f b6 00             	movzbl (%eax),%eax
c0106b42:	3c 2f                	cmp    $0x2f,%al
c0106b44:	7e 1b                	jle    c0106b61 <strtol+0xcc>
c0106b46:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b49:	0f b6 00             	movzbl (%eax),%eax
c0106b4c:	3c 39                	cmp    $0x39,%al
c0106b4e:	7f 11                	jg     c0106b61 <strtol+0xcc>
            dig = *s - '0';
c0106b50:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b53:	0f b6 00             	movzbl (%eax),%eax
c0106b56:	0f be c0             	movsbl %al,%eax
c0106b59:	83 e8 30             	sub    $0x30,%eax
c0106b5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106b5f:	eb 48                	jmp    c0106ba9 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0106b61:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b64:	0f b6 00             	movzbl (%eax),%eax
c0106b67:	3c 60                	cmp    $0x60,%al
c0106b69:	7e 1b                	jle    c0106b86 <strtol+0xf1>
c0106b6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b6e:	0f b6 00             	movzbl (%eax),%eax
c0106b71:	3c 7a                	cmp    $0x7a,%al
c0106b73:	7f 11                	jg     c0106b86 <strtol+0xf1>
            dig = *s - 'a' + 10;
c0106b75:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b78:	0f b6 00             	movzbl (%eax),%eax
c0106b7b:	0f be c0             	movsbl %al,%eax
c0106b7e:	83 e8 57             	sub    $0x57,%eax
c0106b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106b84:	eb 23                	jmp    c0106ba9 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0106b86:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b89:	0f b6 00             	movzbl (%eax),%eax
c0106b8c:	3c 40                	cmp    $0x40,%al
c0106b8e:	7e 3b                	jle    c0106bcb <strtol+0x136>
c0106b90:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b93:	0f b6 00             	movzbl (%eax),%eax
c0106b96:	3c 5a                	cmp    $0x5a,%al
c0106b98:	7f 31                	jg     c0106bcb <strtol+0x136>
            dig = *s - 'A' + 10;
c0106b9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b9d:	0f b6 00             	movzbl (%eax),%eax
c0106ba0:	0f be c0             	movsbl %al,%eax
c0106ba3:	83 e8 37             	sub    $0x37,%eax
c0106ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0106ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106bac:	3b 45 10             	cmp    0x10(%ebp),%eax
c0106baf:	7d 19                	jge    c0106bca <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c0106bb1:	ff 45 08             	incl   0x8(%ebp)
c0106bb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106bb7:	0f af 45 10          	imul   0x10(%ebp),%eax
c0106bbb:	89 c2                	mov    %eax,%edx
c0106bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106bc0:	01 d0                	add    %edx,%eax
c0106bc2:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0106bc5:	e9 72 ff ff ff       	jmp    c0106b3c <strtol+0xa7>
            break;
c0106bca:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0106bcb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106bcf:	74 08                	je     c0106bd9 <strtol+0x144>
        *endptr = (char *) s;
c0106bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106bd4:	8b 55 08             	mov    0x8(%ebp),%edx
c0106bd7:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0106bd9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0106bdd:	74 07                	je     c0106be6 <strtol+0x151>
c0106bdf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106be2:	f7 d8                	neg    %eax
c0106be4:	eb 03                	jmp    c0106be9 <strtol+0x154>
c0106be6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0106be9:	89 ec                	mov    %ebp,%esp
c0106beb:	5d                   	pop    %ebp
c0106bec:	c3                   	ret    

c0106bed <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0106bed:	55                   	push   %ebp
c0106bee:	89 e5                	mov    %esp,%ebp
c0106bf0:	83 ec 28             	sub    $0x28,%esp
c0106bf3:	89 7d fc             	mov    %edi,-0x4(%ebp)
c0106bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106bf9:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0106bfc:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0106c00:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c03:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0106c06:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0106c09:	8b 45 10             	mov    0x10(%ebp),%eax
c0106c0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0106c0f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0106c12:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0106c16:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0106c19:	89 d7                	mov    %edx,%edi
c0106c1b:	f3 aa                	rep stos %al,%es:(%edi)
c0106c1d:	89 fa                	mov    %edi,%edx
c0106c1f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0106c22:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0106c25:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0106c28:	8b 7d fc             	mov    -0x4(%ebp),%edi
c0106c2b:	89 ec                	mov    %ebp,%esp
c0106c2d:	5d                   	pop    %ebp
c0106c2e:	c3                   	ret    

c0106c2f <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0106c2f:	55                   	push   %ebp
c0106c30:	89 e5                	mov    %esp,%ebp
c0106c32:	57                   	push   %edi
c0106c33:	56                   	push   %esi
c0106c34:	53                   	push   %ebx
c0106c35:	83 ec 30             	sub    $0x30,%esp
c0106c38:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106c41:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106c44:	8b 45 10             	mov    0x10(%ebp),%eax
c0106c47:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0106c4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c4d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0106c50:	73 42                	jae    c0106c94 <memmove+0x65>
c0106c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c5b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106c5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c61:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0106c64:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106c67:	c1 e8 02             	shr    $0x2,%eax
c0106c6a:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0106c6c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106c6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c72:	89 d7                	mov    %edx,%edi
c0106c74:	89 c6                	mov    %eax,%esi
c0106c76:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0106c78:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106c7b:	83 e1 03             	and    $0x3,%ecx
c0106c7e:	74 02                	je     c0106c82 <memmove+0x53>
c0106c80:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106c82:	89 f0                	mov    %esi,%eax
c0106c84:	89 fa                	mov    %edi,%edx
c0106c86:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0106c89:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0106c8c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0106c8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0106c92:	eb 36                	jmp    c0106cca <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0106c94:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c97:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106c9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c9d:	01 c2                	add    %eax,%edx
c0106c9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106ca2:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0106ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106ca8:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0106cab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106cae:	89 c1                	mov    %eax,%ecx
c0106cb0:	89 d8                	mov    %ebx,%eax
c0106cb2:	89 d6                	mov    %edx,%esi
c0106cb4:	89 c7                	mov    %eax,%edi
c0106cb6:	fd                   	std    
c0106cb7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106cb9:	fc                   	cld    
c0106cba:	89 f8                	mov    %edi,%eax
c0106cbc:	89 f2                	mov    %esi,%edx
c0106cbe:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0106cc1:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0106cc4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0106cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0106cca:	83 c4 30             	add    $0x30,%esp
c0106ccd:	5b                   	pop    %ebx
c0106cce:	5e                   	pop    %esi
c0106ccf:	5f                   	pop    %edi
c0106cd0:	5d                   	pop    %ebp
c0106cd1:	c3                   	ret    

c0106cd2 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0106cd2:	55                   	push   %ebp
c0106cd3:	89 e5                	mov    %esp,%ebp
c0106cd5:	57                   	push   %edi
c0106cd6:	56                   	push   %esi
c0106cd7:	83 ec 20             	sub    $0x20,%esp
c0106cda:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106ce3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106ce6:	8b 45 10             	mov    0x10(%ebp),%eax
c0106ce9:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0106cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106cef:	c1 e8 02             	shr    $0x2,%eax
c0106cf2:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0106cf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106cfa:	89 d7                	mov    %edx,%edi
c0106cfc:	89 c6                	mov    %eax,%esi
c0106cfe:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0106d00:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0106d03:	83 e1 03             	and    $0x3,%ecx
c0106d06:	74 02                	je     c0106d0a <memcpy+0x38>
c0106d08:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106d0a:	89 f0                	mov    %esi,%eax
c0106d0c:	89 fa                	mov    %edi,%edx
c0106d0e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0106d11:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106d14:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0106d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0106d1a:	83 c4 20             	add    $0x20,%esp
c0106d1d:	5e                   	pop    %esi
c0106d1e:	5f                   	pop    %edi
c0106d1f:	5d                   	pop    %ebp
c0106d20:	c3                   	ret    

c0106d21 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0106d21:	55                   	push   %ebp
c0106d22:	89 e5                	mov    %esp,%ebp
c0106d24:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0106d27:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0106d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106d30:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0106d33:	eb 2e                	jmp    c0106d63 <memcmp+0x42>
        if (*s1 != *s2) {
c0106d35:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106d38:	0f b6 10             	movzbl (%eax),%edx
c0106d3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106d3e:	0f b6 00             	movzbl (%eax),%eax
c0106d41:	38 c2                	cmp    %al,%dl
c0106d43:	74 18                	je     c0106d5d <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0106d45:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106d48:	0f b6 00             	movzbl (%eax),%eax
c0106d4b:	0f b6 d0             	movzbl %al,%edx
c0106d4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106d51:	0f b6 00             	movzbl (%eax),%eax
c0106d54:	0f b6 c8             	movzbl %al,%ecx
c0106d57:	89 d0                	mov    %edx,%eax
c0106d59:	29 c8                	sub    %ecx,%eax
c0106d5b:	eb 18                	jmp    c0106d75 <memcmp+0x54>
        }
        s1 ++, s2 ++;
c0106d5d:	ff 45 fc             	incl   -0x4(%ebp)
c0106d60:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c0106d63:	8b 45 10             	mov    0x10(%ebp),%eax
c0106d66:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106d69:	89 55 10             	mov    %edx,0x10(%ebp)
c0106d6c:	85 c0                	test   %eax,%eax
c0106d6e:	75 c5                	jne    c0106d35 <memcmp+0x14>
    }
    return 0;
c0106d70:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106d75:	89 ec                	mov    %ebp,%esp
c0106d77:	5d                   	pop    %ebp
c0106d78:	c3                   	ret    
