
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 c0 11 40       	mov    $0x4011c000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 c0 11 00       	mov    %eax,0x11c000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 b0 11 00       	mov    $0x11b000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	b8 2c ef 11 00       	mov    $0x11ef2c,%eax
  100041:	2d 36 ba 11 00       	sub    $0x11ba36,%eax
  100046:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100051:	00 
  100052:	c7 04 24 36 ba 11 00 	movl   $0x11ba36,(%esp)
  100059:	e8 8f 6b 00 00       	call   106bed <memset>

    cons_init();                // init the console
  10005e:	e8 fc 15 00 00       	call   10165f <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100063:	c7 45 f4 80 6d 10 00 	movl   $0x106d80,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10006d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100071:	c7 04 24 9c 6d 10 00 	movl   $0x106d9c,(%esp)
  100078:	e8 e4 02 00 00       	call   100361 <cprintf>

    print_kerninfo();
  10007d:	e8 02 08 00 00       	call   100884 <print_kerninfo>

    grade_backtrace();
  100082:	e8 90 00 00 00       	call   100117 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100087:	e8 b3 50 00 00       	call   10513f <pmm_init>

    pic_init();                 // init interrupt controller
  10008c:	e8 4f 17 00 00       	call   1017e0 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100091:	e8 d6 18 00 00       	call   10196c <idt_init>

    clock_init();               // init clock interrupt
  100096:	e8 23 0d 00 00       	call   100dbe <clock_init>
    intr_enable();              // enable irq interrupt
  10009b:	e8 9e 16 00 00       	call   10173e <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a0:	eb fe                	jmp    1000a0 <kern_init+0x6a>

001000a2 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a2:	55                   	push   %ebp
  1000a3:	89 e5                	mov    %esp,%ebp
  1000a5:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000af:	00 
  1000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000b7:	00 
  1000b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000bf:	e8 15 0c 00 00       	call   100cd9 <mon_backtrace>
}
  1000c4:	90                   	nop
  1000c5:	89 ec                	mov    %ebp,%esp
  1000c7:	5d                   	pop    %ebp
  1000c8:	c3                   	ret    

001000c9 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000c9:	55                   	push   %ebp
  1000ca:	89 e5                	mov    %esp,%ebp
  1000cc:	83 ec 18             	sub    $0x18,%esp
  1000cf:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000d2:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000d8:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000db:	8b 45 08             	mov    0x8(%ebp),%eax
  1000de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000e2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000ea:	89 04 24             	mov    %eax,(%esp)
  1000ed:	e8 b0 ff ff ff       	call   1000a2 <grade_backtrace2>
}
  1000f2:	90                   	nop
  1000f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000f6:	89 ec                	mov    %ebp,%esp
  1000f8:	5d                   	pop    %ebp
  1000f9:	c3                   	ret    

001000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000fa:	55                   	push   %ebp
  1000fb:	89 e5                	mov    %esp,%ebp
  1000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  100100:	8b 45 10             	mov    0x10(%ebp),%eax
  100103:	89 44 24 04          	mov    %eax,0x4(%esp)
  100107:	8b 45 08             	mov    0x8(%ebp),%eax
  10010a:	89 04 24             	mov    %eax,(%esp)
  10010d:	e8 b7 ff ff ff       	call   1000c9 <grade_backtrace1>
}
  100112:	90                   	nop
  100113:	89 ec                	mov    %ebp,%esp
  100115:	5d                   	pop    %ebp
  100116:	c3                   	ret    

00100117 <grade_backtrace>:

void
grade_backtrace(void) {
  100117:	55                   	push   %ebp
  100118:	89 e5                	mov    %esp,%ebp
  10011a:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10011d:	b8 36 00 10 00       	mov    $0x100036,%eax
  100122:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100129:	ff 
  10012a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100135:	e8 c0 ff ff ff       	call   1000fa <grade_backtrace0>
}
  10013a:	90                   	nop
  10013b:	89 ec                	mov    %ebp,%esp
  10013d:	5d                   	pop    %ebp
  10013e:	c3                   	ret    

0010013f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10013f:	55                   	push   %ebp
  100140:	89 e5                	mov    %esp,%ebp
  100142:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100145:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100148:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10014b:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10014e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100155:	83 e0 03             	and    $0x3,%eax
  100158:	89 c2                	mov    %eax,%edx
  10015a:	a1 00 e0 11 00       	mov    0x11e000,%eax
  10015f:	89 54 24 08          	mov    %edx,0x8(%esp)
  100163:	89 44 24 04          	mov    %eax,0x4(%esp)
  100167:	c7 04 24 a1 6d 10 00 	movl   $0x106da1,(%esp)
  10016e:	e8 ee 01 00 00       	call   100361 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100177:	89 c2                	mov    %eax,%edx
  100179:	a1 00 e0 11 00       	mov    0x11e000,%eax
  10017e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100182:	89 44 24 04          	mov    %eax,0x4(%esp)
  100186:	c7 04 24 af 6d 10 00 	movl   $0x106daf,(%esp)
  10018d:	e8 cf 01 00 00       	call   100361 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100196:	89 c2                	mov    %eax,%edx
  100198:	a1 00 e0 11 00       	mov    0x11e000,%eax
  10019d:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a5:	c7 04 24 bd 6d 10 00 	movl   $0x106dbd,(%esp)
  1001ac:	e8 b0 01 00 00       	call   100361 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b5:	89 c2                	mov    %eax,%edx
  1001b7:	a1 00 e0 11 00       	mov    0x11e000,%eax
  1001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c4:	c7 04 24 cb 6d 10 00 	movl   $0x106dcb,(%esp)
  1001cb:	e8 91 01 00 00       	call   100361 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d4:	89 c2                	mov    %eax,%edx
  1001d6:	a1 00 e0 11 00       	mov    0x11e000,%eax
  1001db:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e3:	c7 04 24 d9 6d 10 00 	movl   $0x106dd9,(%esp)
  1001ea:	e8 72 01 00 00       	call   100361 <cprintf>
    round ++;
  1001ef:	a1 00 e0 11 00       	mov    0x11e000,%eax
  1001f4:	40                   	inc    %eax
  1001f5:	a3 00 e0 11 00       	mov    %eax,0x11e000
}
  1001fa:	90                   	nop
  1001fb:	89 ec                	mov    %ebp,%esp
  1001fd:	5d                   	pop    %ebp
  1001fe:	c3                   	ret    

001001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001ff:	55                   	push   %ebp
  100200:	89 e5                	mov    %esp,%ebp
    //执行“int n”时, CPU从中断向量表中, 找到第n号表项, 修改CS和IP
    //1. 取中断类型码n ;
    //2. 标志寄存器入栈(pushf) , IF=0, TF=0(重置中断标志位)  ;
    //3. CS、IP入栈 ;
    //4. 查中断向量表,  (IP)=(n*4), (CS)=(n*4+2)。
    asm volatile (
  100202:	83 ec 08             	sub    $0x8,%esp
  100205:	cd 78                	int    $0x78
  100207:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  100209:	90                   	nop
  10020a:	5d                   	pop    %ebp
  10020b:	c3                   	ret    

0010020c <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  10020c:	55                   	push   %ebp
  10020d:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
  10020f:	cd 79                	int    $0x79
  100211:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  100213:	90                   	nop
  100214:	5d                   	pop    %ebp
  100215:	c3                   	ret    

00100216 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100216:	55                   	push   %ebp
  100217:	89 e5                	mov    %esp,%ebp
  100219:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  10021c:	e8 1e ff ff ff       	call   10013f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100221:	c7 04 24 e8 6d 10 00 	movl   $0x106de8,(%esp)
  100228:	e8 34 01 00 00       	call   100361 <cprintf>
    lab1_switch_to_user();
  10022d:	e8 cd ff ff ff       	call   1001ff <lab1_switch_to_user>
    lab1_print_cur_status();
  100232:	e8 08 ff ff ff       	call   10013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100237:	c7 04 24 08 6e 10 00 	movl   $0x106e08,(%esp)
  10023e:	e8 1e 01 00 00       	call   100361 <cprintf>
    lab1_switch_to_kernel();
  100243:	e8 c4 ff ff ff       	call   10020c <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100248:	e8 f2 fe ff ff       	call   10013f <lab1_print_cur_status>
}
  10024d:	90                   	nop
  10024e:	89 ec                	mov    %ebp,%esp
  100250:	5d                   	pop    %ebp
  100251:	c3                   	ret    

00100252 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100252:	55                   	push   %ebp
  100253:	89 e5                	mov    %esp,%ebp
  100255:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100258:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10025c:	74 13                	je     100271 <readline+0x1f>
        cprintf("%s", prompt);
  10025e:	8b 45 08             	mov    0x8(%ebp),%eax
  100261:	89 44 24 04          	mov    %eax,0x4(%esp)
  100265:	c7 04 24 27 6e 10 00 	movl   $0x106e27,(%esp)
  10026c:	e8 f0 00 00 00       	call   100361 <cprintf>
    }
    int i = 0, c;
  100271:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100278:	e8 73 01 00 00       	call   1003f0 <getchar>
  10027d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100284:	79 07                	jns    10028d <readline+0x3b>
            return NULL;
  100286:	b8 00 00 00 00       	mov    $0x0,%eax
  10028b:	eb 78                	jmp    100305 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10028d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100291:	7e 28                	jle    1002bb <readline+0x69>
  100293:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10029a:	7f 1f                	jg     1002bb <readline+0x69>
            cputchar(c);
  10029c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10029f:	89 04 24             	mov    %eax,(%esp)
  1002a2:	e8 e2 00 00 00       	call   100389 <cputchar>
            buf[i ++] = c;
  1002a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002aa:	8d 50 01             	lea    0x1(%eax),%edx
  1002ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1002b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1002b3:	88 90 20 e0 11 00    	mov    %dl,0x11e020(%eax)
  1002b9:	eb 45                	jmp    100300 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  1002bb:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002bf:	75 16                	jne    1002d7 <readline+0x85>
  1002c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002c5:	7e 10                	jle    1002d7 <readline+0x85>
            cputchar(c);
  1002c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ca:	89 04 24             	mov    %eax,(%esp)
  1002cd:	e8 b7 00 00 00       	call   100389 <cputchar>
            i --;
  1002d2:	ff 4d f4             	decl   -0xc(%ebp)
  1002d5:	eb 29                	jmp    100300 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  1002d7:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002db:	74 06                	je     1002e3 <readline+0x91>
  1002dd:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002e1:	75 95                	jne    100278 <readline+0x26>
            cputchar(c);
  1002e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002e6:	89 04 24             	mov    %eax,(%esp)
  1002e9:	e8 9b 00 00 00       	call   100389 <cputchar>
            buf[i] = '\0';
  1002ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002f1:	05 20 e0 11 00       	add    $0x11e020,%eax
  1002f6:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002f9:	b8 20 e0 11 00       	mov    $0x11e020,%eax
  1002fe:	eb 05                	jmp    100305 <readline+0xb3>
        c = getchar();
  100300:	e9 73 ff ff ff       	jmp    100278 <readline+0x26>
        }
    }
}
  100305:	89 ec                	mov    %ebp,%esp
  100307:	5d                   	pop    %ebp
  100308:	c3                   	ret    

00100309 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10030f:	8b 45 08             	mov    0x8(%ebp),%eax
  100312:	89 04 24             	mov    %eax,(%esp)
  100315:	e8 74 13 00 00       	call   10168e <cons_putc>
    (*cnt) ++;
  10031a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10031d:	8b 00                	mov    (%eax),%eax
  10031f:	8d 50 01             	lea    0x1(%eax),%edx
  100322:	8b 45 0c             	mov    0xc(%ebp),%eax
  100325:	89 10                	mov    %edx,(%eax)
}
  100327:	90                   	nop
  100328:	89 ec                	mov    %ebp,%esp
  10032a:	5d                   	pop    %ebp
  10032b:	c3                   	ret    

0010032c <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10032c:	55                   	push   %ebp
  10032d:	89 e5                	mov    %esp,%ebp
  10032f:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100332:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100339:	8b 45 0c             	mov    0xc(%ebp),%eax
  10033c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100340:	8b 45 08             	mov    0x8(%ebp),%eax
  100343:	89 44 24 08          	mov    %eax,0x8(%esp)
  100347:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10034a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034e:	c7 04 24 09 03 10 00 	movl   $0x100309,(%esp)
  100355:	e8 be 60 00 00       	call   106418 <vprintfmt>
    return cnt;
  10035a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10035d:	89 ec                	mov    %ebp,%esp
  10035f:	5d                   	pop    %ebp
  100360:	c3                   	ret    

00100361 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100361:	55                   	push   %ebp
  100362:	89 e5                	mov    %esp,%ebp
  100364:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100367:	8d 45 0c             	lea    0xc(%ebp),%eax
  10036a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10036d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100370:	89 44 24 04          	mov    %eax,0x4(%esp)
  100374:	8b 45 08             	mov    0x8(%ebp),%eax
  100377:	89 04 24             	mov    %eax,(%esp)
  10037a:	e8 ad ff ff ff       	call   10032c <vcprintf>
  10037f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100382:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100385:	89 ec                	mov    %ebp,%esp
  100387:	5d                   	pop    %ebp
  100388:	c3                   	ret    

00100389 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100389:	55                   	push   %ebp
  10038a:	89 e5                	mov    %esp,%ebp
  10038c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10038f:	8b 45 08             	mov    0x8(%ebp),%eax
  100392:	89 04 24             	mov    %eax,(%esp)
  100395:	e8 f4 12 00 00       	call   10168e <cons_putc>
}
  10039a:	90                   	nop
  10039b:	89 ec                	mov    %ebp,%esp
  10039d:	5d                   	pop    %ebp
  10039e:	c3                   	ret    

0010039f <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10039f:	55                   	push   %ebp
  1003a0:	89 e5                	mov    %esp,%ebp
  1003a2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1003a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1003ac:	eb 13                	jmp    1003c1 <cputs+0x22>
        cputch(c, &cnt);
  1003ae:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1003b2:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1003b5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1003b9:	89 04 24             	mov    %eax,(%esp)
  1003bc:	e8 48 ff ff ff       	call   100309 <cputch>
    while ((c = *str ++) != '\0') {
  1003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1003c4:	8d 50 01             	lea    0x1(%eax),%edx
  1003c7:	89 55 08             	mov    %edx,0x8(%ebp)
  1003ca:	0f b6 00             	movzbl (%eax),%eax
  1003cd:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003d0:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003d4:	75 d8                	jne    1003ae <cputs+0xf>
    }
    cputch('\n', &cnt);
  1003d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003dd:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003e4:	e8 20 ff ff ff       	call   100309 <cputch>
    return cnt;
  1003e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003ec:	89 ec                	mov    %ebp,%esp
  1003ee:	5d                   	pop    %ebp
  1003ef:	c3                   	ret    

001003f0 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003f0:	55                   	push   %ebp
  1003f1:	89 e5                	mov    %esp,%ebp
  1003f3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003f6:	90                   	nop
  1003f7:	e8 d1 12 00 00       	call   1016cd <cons_getc>
  1003fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100403:	74 f2                	je     1003f7 <getchar+0x7>
        /* do nothing */;
    return c;
  100405:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100408:	89 ec                	mov    %ebp,%esp
  10040a:	5d                   	pop    %ebp
  10040b:	c3                   	ret    

0010040c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  10040c:	55                   	push   %ebp
  10040d:	89 e5                	mov    %esp,%ebp
  10040f:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100412:	8b 45 0c             	mov    0xc(%ebp),%eax
  100415:	8b 00                	mov    (%eax),%eax
  100417:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10041a:	8b 45 10             	mov    0x10(%ebp),%eax
  10041d:	8b 00                	mov    (%eax),%eax
  10041f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100422:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100429:	e9 ca 00 00 00       	jmp    1004f8 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  10042e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100431:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100434:	01 d0                	add    %edx,%eax
  100436:	89 c2                	mov    %eax,%edx
  100438:	c1 ea 1f             	shr    $0x1f,%edx
  10043b:	01 d0                	add    %edx,%eax
  10043d:	d1 f8                	sar    %eax
  10043f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100442:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100445:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100448:	eb 03                	jmp    10044d <stab_binsearch+0x41>
            m --;
  10044a:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  10044d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100450:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100453:	7c 1f                	jl     100474 <stab_binsearch+0x68>
  100455:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100458:	89 d0                	mov    %edx,%eax
  10045a:	01 c0                	add    %eax,%eax
  10045c:	01 d0                	add    %edx,%eax
  10045e:	c1 e0 02             	shl    $0x2,%eax
  100461:	89 c2                	mov    %eax,%edx
  100463:	8b 45 08             	mov    0x8(%ebp),%eax
  100466:	01 d0                	add    %edx,%eax
  100468:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10046c:	0f b6 c0             	movzbl %al,%eax
  10046f:	39 45 14             	cmp    %eax,0x14(%ebp)
  100472:	75 d6                	jne    10044a <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100477:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10047a:	7d 09                	jge    100485 <stab_binsearch+0x79>
            l = true_m + 1;
  10047c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10047f:	40                   	inc    %eax
  100480:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100483:	eb 73                	jmp    1004f8 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  100485:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10048c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10048f:	89 d0                	mov    %edx,%eax
  100491:	01 c0                	add    %eax,%eax
  100493:	01 d0                	add    %edx,%eax
  100495:	c1 e0 02             	shl    $0x2,%eax
  100498:	89 c2                	mov    %eax,%edx
  10049a:	8b 45 08             	mov    0x8(%ebp),%eax
  10049d:	01 d0                	add    %edx,%eax
  10049f:	8b 40 08             	mov    0x8(%eax),%eax
  1004a2:	39 45 18             	cmp    %eax,0x18(%ebp)
  1004a5:	76 11                	jbe    1004b8 <stab_binsearch+0xac>
            *region_left = m;
  1004a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004ad:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  1004af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004b2:	40                   	inc    %eax
  1004b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004b6:	eb 40                	jmp    1004f8 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  1004b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004bb:	89 d0                	mov    %edx,%eax
  1004bd:	01 c0                	add    %eax,%eax
  1004bf:	01 d0                	add    %edx,%eax
  1004c1:	c1 e0 02             	shl    $0x2,%eax
  1004c4:	89 c2                	mov    %eax,%edx
  1004c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1004c9:	01 d0                	add    %edx,%eax
  1004cb:	8b 40 08             	mov    0x8(%eax),%eax
  1004ce:	39 45 18             	cmp    %eax,0x18(%ebp)
  1004d1:	73 14                	jae    1004e7 <stab_binsearch+0xdb>
            *region_right = m - 1;
  1004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004d9:	8b 45 10             	mov    0x10(%ebp),%eax
  1004dc:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004e1:	48                   	dec    %eax
  1004e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004e5:	eb 11                	jmp    1004f8 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004ed:	89 10                	mov    %edx,(%eax)
            l = m;
  1004ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004f5:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1004f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004fe:	0f 8e 2a ff ff ff    	jle    10042e <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  100504:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100508:	75 0f                	jne    100519 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  10050a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10050d:	8b 00                	mov    (%eax),%eax
  10050f:	8d 50 ff             	lea    -0x1(%eax),%edx
  100512:	8b 45 10             	mov    0x10(%ebp),%eax
  100515:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  100517:	eb 3e                	jmp    100557 <stab_binsearch+0x14b>
        l = *region_right;
  100519:	8b 45 10             	mov    0x10(%ebp),%eax
  10051c:	8b 00                	mov    (%eax),%eax
  10051e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100521:	eb 03                	jmp    100526 <stab_binsearch+0x11a>
  100523:	ff 4d fc             	decl   -0x4(%ebp)
  100526:	8b 45 0c             	mov    0xc(%ebp),%eax
  100529:	8b 00                	mov    (%eax),%eax
  10052b:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  10052e:	7e 1f                	jle    10054f <stab_binsearch+0x143>
  100530:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100533:	89 d0                	mov    %edx,%eax
  100535:	01 c0                	add    %eax,%eax
  100537:	01 d0                	add    %edx,%eax
  100539:	c1 e0 02             	shl    $0x2,%eax
  10053c:	89 c2                	mov    %eax,%edx
  10053e:	8b 45 08             	mov    0x8(%ebp),%eax
  100541:	01 d0                	add    %edx,%eax
  100543:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100547:	0f b6 c0             	movzbl %al,%eax
  10054a:	39 45 14             	cmp    %eax,0x14(%ebp)
  10054d:	75 d4                	jne    100523 <stab_binsearch+0x117>
        *region_left = l;
  10054f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100552:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100555:	89 10                	mov    %edx,(%eax)
}
  100557:	90                   	nop
  100558:	89 ec                	mov    %ebp,%esp
  10055a:	5d                   	pop    %ebp
  10055b:	c3                   	ret    

0010055c <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10055c:	55                   	push   %ebp
  10055d:	89 e5                	mov    %esp,%ebp
  10055f:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100562:	8b 45 0c             	mov    0xc(%ebp),%eax
  100565:	c7 00 2c 6e 10 00    	movl   $0x106e2c,(%eax)
    info->eip_line = 0;
  10056b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100575:	8b 45 0c             	mov    0xc(%ebp),%eax
  100578:	c7 40 08 2c 6e 10 00 	movl   $0x106e2c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10057f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100582:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100589:	8b 45 0c             	mov    0xc(%ebp),%eax
  10058c:	8b 55 08             	mov    0x8(%ebp),%edx
  10058f:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100592:	8b 45 0c             	mov    0xc(%ebp),%eax
  100595:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10059c:	c7 45 f4 2c 83 10 00 	movl   $0x10832c,-0xc(%ebp)
    stab_end = __STAB_END__;
  1005a3:	c7 45 f0 3c 4e 11 00 	movl   $0x114e3c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1005aa:	c7 45 ec 3d 4e 11 00 	movl   $0x114e3d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1005b1:	c7 45 e8 59 86 11 00 	movl   $0x118659,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  1005b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005bb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1005be:	76 0b                	jbe    1005cb <debuginfo_eip+0x6f>
  1005c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005c3:	48                   	dec    %eax
  1005c4:	0f b6 00             	movzbl (%eax),%eax
  1005c7:	84 c0                	test   %al,%al
  1005c9:	74 0a                	je     1005d5 <debuginfo_eip+0x79>
        return -1;
  1005cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005d0:	e9 ab 02 00 00       	jmp    100880 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005df:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1005e2:	c1 f8 02             	sar    $0x2,%eax
  1005e5:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005eb:	48                   	dec    %eax
  1005ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1005f2:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005f6:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005fd:	00 
  1005fe:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100601:	89 44 24 08          	mov    %eax,0x8(%esp)
  100605:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100608:	89 44 24 04          	mov    %eax,0x4(%esp)
  10060c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10060f:	89 04 24             	mov    %eax,(%esp)
  100612:	e8 f5 fd ff ff       	call   10040c <stab_binsearch>
    if (lfile == 0)
  100617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10061a:	85 c0                	test   %eax,%eax
  10061c:	75 0a                	jne    100628 <debuginfo_eip+0xcc>
        return -1;
  10061e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100623:	e9 58 02 00 00       	jmp    100880 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10062b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10062e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100631:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100634:	8b 45 08             	mov    0x8(%ebp),%eax
  100637:	89 44 24 10          	mov    %eax,0x10(%esp)
  10063b:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100642:	00 
  100643:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100646:	89 44 24 08          	mov    %eax,0x8(%esp)
  10064a:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10064d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100654:	89 04 24             	mov    %eax,(%esp)
  100657:	e8 b0 fd ff ff       	call   10040c <stab_binsearch>

    if (lfun <= rfun) {
  10065c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10065f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100662:	39 c2                	cmp    %eax,%edx
  100664:	7f 78                	jg     1006de <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100666:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100669:	89 c2                	mov    %eax,%edx
  10066b:	89 d0                	mov    %edx,%eax
  10066d:	01 c0                	add    %eax,%eax
  10066f:	01 d0                	add    %edx,%eax
  100671:	c1 e0 02             	shl    $0x2,%eax
  100674:	89 c2                	mov    %eax,%edx
  100676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100679:	01 d0                	add    %edx,%eax
  10067b:	8b 10                	mov    (%eax),%edx
  10067d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100680:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100683:	39 c2                	cmp    %eax,%edx
  100685:	73 22                	jae    1006a9 <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100687:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068a:	89 c2                	mov    %eax,%edx
  10068c:	89 d0                	mov    %edx,%eax
  10068e:	01 c0                	add    %eax,%eax
  100690:	01 d0                	add    %edx,%eax
  100692:	c1 e0 02             	shl    $0x2,%eax
  100695:	89 c2                	mov    %eax,%edx
  100697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069a:	01 d0                	add    %edx,%eax
  10069c:	8b 10                	mov    (%eax),%edx
  10069e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1006a1:	01 c2                	add    %eax,%edx
  1006a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a6:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  1006a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006ac:	89 c2                	mov    %eax,%edx
  1006ae:	89 d0                	mov    %edx,%eax
  1006b0:	01 c0                	add    %eax,%eax
  1006b2:	01 d0                	add    %edx,%eax
  1006b4:	c1 e0 02             	shl    $0x2,%eax
  1006b7:	89 c2                	mov    %eax,%edx
  1006b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006bc:	01 d0                	add    %edx,%eax
  1006be:	8b 50 08             	mov    0x8(%eax),%edx
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ca:	8b 40 10             	mov    0x10(%eax),%eax
  1006cd:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006d9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006dc:	eb 15                	jmp    1006f3 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006de:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e1:	8b 55 08             	mov    0x8(%ebp),%edx
  1006e4:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f6:	8b 40 08             	mov    0x8(%eax),%eax
  1006f9:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  100700:	00 
  100701:	89 04 24             	mov    %eax,(%esp)
  100704:	e8 5c 63 00 00       	call   106a65 <strfind>
  100709:	8b 55 0c             	mov    0xc(%ebp),%edx
  10070c:	8b 4a 08             	mov    0x8(%edx),%ecx
  10070f:	29 c8                	sub    %ecx,%eax
  100711:	89 c2                	mov    %eax,%edx
  100713:	8b 45 0c             	mov    0xc(%ebp),%eax
  100716:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100719:	8b 45 08             	mov    0x8(%ebp),%eax
  10071c:	89 44 24 10          	mov    %eax,0x10(%esp)
  100720:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  100727:	00 
  100728:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10072b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10072f:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100732:	89 44 24 04          	mov    %eax,0x4(%esp)
  100736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100739:	89 04 24             	mov    %eax,(%esp)
  10073c:	e8 cb fc ff ff       	call   10040c <stab_binsearch>
    if (lline <= rline) {
  100741:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100744:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100747:	39 c2                	cmp    %eax,%edx
  100749:	7f 23                	jg     10076e <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
  10074b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10074e:	89 c2                	mov    %eax,%edx
  100750:	89 d0                	mov    %edx,%eax
  100752:	01 c0                	add    %eax,%eax
  100754:	01 d0                	add    %edx,%eax
  100756:	c1 e0 02             	shl    $0x2,%eax
  100759:	89 c2                	mov    %eax,%edx
  10075b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075e:	01 d0                	add    %edx,%eax
  100760:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100764:	89 c2                	mov    %eax,%edx
  100766:	8b 45 0c             	mov    0xc(%ebp),%eax
  100769:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10076c:	eb 11                	jmp    10077f <debuginfo_eip+0x223>
        return -1;
  10076e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100773:	e9 08 01 00 00       	jmp    100880 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100778:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10077b:	48                   	dec    %eax
  10077c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10077f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100785:	39 c2                	cmp    %eax,%edx
  100787:	7c 56                	jl     1007df <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
  100789:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078c:	89 c2                	mov    %eax,%edx
  10078e:	89 d0                	mov    %edx,%eax
  100790:	01 c0                	add    %eax,%eax
  100792:	01 d0                	add    %edx,%eax
  100794:	c1 e0 02             	shl    $0x2,%eax
  100797:	89 c2                	mov    %eax,%edx
  100799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079c:	01 d0                	add    %edx,%eax
  10079e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a2:	3c 84                	cmp    $0x84,%al
  1007a4:	74 39                	je     1007df <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1007a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007a9:	89 c2                	mov    %eax,%edx
  1007ab:	89 d0                	mov    %edx,%eax
  1007ad:	01 c0                	add    %eax,%eax
  1007af:	01 d0                	add    %edx,%eax
  1007b1:	c1 e0 02             	shl    $0x2,%eax
  1007b4:	89 c2                	mov    %eax,%edx
  1007b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b9:	01 d0                	add    %edx,%eax
  1007bb:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007bf:	3c 64                	cmp    $0x64,%al
  1007c1:	75 b5                	jne    100778 <debuginfo_eip+0x21c>
  1007c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007c6:	89 c2                	mov    %eax,%edx
  1007c8:	89 d0                	mov    %edx,%eax
  1007ca:	01 c0                	add    %eax,%eax
  1007cc:	01 d0                	add    %edx,%eax
  1007ce:	c1 e0 02             	shl    $0x2,%eax
  1007d1:	89 c2                	mov    %eax,%edx
  1007d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007d6:	01 d0                	add    %edx,%eax
  1007d8:	8b 40 08             	mov    0x8(%eax),%eax
  1007db:	85 c0                	test   %eax,%eax
  1007dd:	74 99                	je     100778 <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007e5:	39 c2                	cmp    %eax,%edx
  1007e7:	7c 42                	jl     10082b <debuginfo_eip+0x2cf>
  1007e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ec:	89 c2                	mov    %eax,%edx
  1007ee:	89 d0                	mov    %edx,%eax
  1007f0:	01 c0                	add    %eax,%eax
  1007f2:	01 d0                	add    %edx,%eax
  1007f4:	c1 e0 02             	shl    $0x2,%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007fc:	01 d0                	add    %edx,%eax
  1007fe:	8b 10                	mov    (%eax),%edx
  100800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100803:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100806:	39 c2                	cmp    %eax,%edx
  100808:	73 21                	jae    10082b <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10080a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10080d:	89 c2                	mov    %eax,%edx
  10080f:	89 d0                	mov    %edx,%eax
  100811:	01 c0                	add    %eax,%eax
  100813:	01 d0                	add    %edx,%eax
  100815:	c1 e0 02             	shl    $0x2,%eax
  100818:	89 c2                	mov    %eax,%edx
  10081a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10081d:	01 d0                	add    %edx,%eax
  10081f:	8b 10                	mov    (%eax),%edx
  100821:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100824:	01 c2                	add    %eax,%edx
  100826:	8b 45 0c             	mov    0xc(%ebp),%eax
  100829:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  10082b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10082e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100831:	39 c2                	cmp    %eax,%edx
  100833:	7d 46                	jge    10087b <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  100835:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100838:	40                   	inc    %eax
  100839:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10083c:	eb 16                	jmp    100854 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10083e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100841:	8b 40 14             	mov    0x14(%eax),%eax
  100844:	8d 50 01             	lea    0x1(%eax),%edx
  100847:	8b 45 0c             	mov    0xc(%ebp),%eax
  10084a:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  10084d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100850:	40                   	inc    %eax
  100851:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100854:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100857:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10085a:	39 c2                	cmp    %eax,%edx
  10085c:	7d 1d                	jge    10087b <debuginfo_eip+0x31f>
  10085e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100861:	89 c2                	mov    %eax,%edx
  100863:	89 d0                	mov    %edx,%eax
  100865:	01 c0                	add    %eax,%eax
  100867:	01 d0                	add    %edx,%eax
  100869:	c1 e0 02             	shl    $0x2,%eax
  10086c:	89 c2                	mov    %eax,%edx
  10086e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100871:	01 d0                	add    %edx,%eax
  100873:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100877:	3c a0                	cmp    $0xa0,%al
  100879:	74 c3                	je     10083e <debuginfo_eip+0x2e2>
        }
    }
    return 0;
  10087b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100880:	89 ec                	mov    %ebp,%esp
  100882:	5d                   	pop    %ebp
  100883:	c3                   	ret    

00100884 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100884:	55                   	push   %ebp
  100885:	89 e5                	mov    %esp,%ebp
  100887:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10088a:	c7 04 24 36 6e 10 00 	movl   $0x106e36,(%esp)
  100891:	e8 cb fa ff ff       	call   100361 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100896:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 4f 6e 10 00 	movl   $0x106e4f,(%esp)
  1008a5:	e8 b7 fa ff ff       	call   100361 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008aa:	c7 44 24 04 79 6d 10 	movl   $0x106d79,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 67 6e 10 00 	movl   $0x106e67,(%esp)
  1008b9:	e8 a3 fa ff ff       	call   100361 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008be:	c7 44 24 04 36 ba 11 	movl   $0x11ba36,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 7f 6e 10 00 	movl   $0x106e7f,(%esp)
  1008cd:	e8 8f fa ff ff       	call   100361 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008d2:	c7 44 24 04 2c ef 11 	movl   $0x11ef2c,0x4(%esp)
  1008d9:	00 
  1008da:	c7 04 24 97 6e 10 00 	movl   $0x106e97,(%esp)
  1008e1:	e8 7b fa ff ff       	call   100361 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008e6:	b8 2c ef 11 00       	mov    $0x11ef2c,%eax
  1008eb:	2d 36 00 10 00       	sub    $0x100036,%eax
  1008f0:	05 ff 03 00 00       	add    $0x3ff,%eax
  1008f5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008fb:	85 c0                	test   %eax,%eax
  1008fd:	0f 48 c2             	cmovs  %edx,%eax
  100900:	c1 f8 0a             	sar    $0xa,%eax
  100903:	89 44 24 04          	mov    %eax,0x4(%esp)
  100907:	c7 04 24 b0 6e 10 00 	movl   $0x106eb0,(%esp)
  10090e:	e8 4e fa ff ff       	call   100361 <cprintf>
}
  100913:	90                   	nop
  100914:	89 ec                	mov    %ebp,%esp
  100916:	5d                   	pop    %ebp
  100917:	c3                   	ret    

00100918 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100918:	55                   	push   %ebp
  100919:	89 e5                	mov    %esp,%ebp
  10091b:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100921:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100924:	89 44 24 04          	mov    %eax,0x4(%esp)
  100928:	8b 45 08             	mov    0x8(%ebp),%eax
  10092b:	89 04 24             	mov    %eax,(%esp)
  10092e:	e8 29 fc ff ff       	call   10055c <debuginfo_eip>
  100933:	85 c0                	test   %eax,%eax
  100935:	74 15                	je     10094c <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100937:	8b 45 08             	mov    0x8(%ebp),%eax
  10093a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10093e:	c7 04 24 da 6e 10 00 	movl   $0x106eda,(%esp)
  100945:	e8 17 fa ff ff       	call   100361 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  10094a:	eb 6c                	jmp    1009b8 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10094c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100953:	eb 1b                	jmp    100970 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  100955:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10095b:	01 d0                	add    %edx,%eax
  10095d:	0f b6 10             	movzbl (%eax),%edx
  100960:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100969:	01 c8                	add    %ecx,%eax
  10096b:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10096d:	ff 45 f4             	incl   -0xc(%ebp)
  100970:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100973:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100976:	7c dd                	jl     100955 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100978:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10097e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100981:	01 d0                	add    %edx,%eax
  100983:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100986:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100989:	8b 45 08             	mov    0x8(%ebp),%eax
  10098c:	29 d0                	sub    %edx,%eax
  10098e:	89 c1                	mov    %eax,%ecx
  100990:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100993:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100996:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10099a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009a0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1009a4:	89 54 24 08          	mov    %edx,0x8(%esp)
  1009a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ac:	c7 04 24 f6 6e 10 00 	movl   $0x106ef6,(%esp)
  1009b3:	e8 a9 f9 ff ff       	call   100361 <cprintf>
}
  1009b8:	90                   	nop
  1009b9:	89 ec                	mov    %ebp,%esp
  1009bb:	5d                   	pop    %ebp
  1009bc:	c3                   	ret    

001009bd <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009bd:	55                   	push   %ebp
  1009be:	89 e5                	mov    %esp,%ebp
  1009c0:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009c3:	8b 45 04             	mov    0x4(%ebp),%eax
  1009c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009cc:	89 ec                	mov    %ebp,%esp
  1009ce:	5d                   	pop    %ebp
  1009cf:	c3                   	ret    

001009d0 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009d0:	55                   	push   %ebp
  1009d1:	89 e5                	mov    %esp,%ebp
  1009d3:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009d6:	89 e8                	mov    %ebp,%eax
  1009d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009db:	8b 45 e0             	mov    -0x20(%ebp),%eax
      */
    // ebp是第一个被调用函数的栈帧的base pointer，
    // eip是在该栈帧对应函数中调用下一个栈帧对应函数的指令的下一条指令的地址（return address）
    // args是传递给这第一个被调用的函数的参数
    // get ebp and eip
    uint32_t ebp = read_ebp(), eip = read_eip();
  1009de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1009e1:	e8 d7 ff ff ff       	call   1009bd <read_eip>
  1009e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // traverse all
    for(int i=0,j=0; ebp!=0 && i<STACKFRAME_DEPTH;i++){
  1009e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009f7:	e9 84 00 00 00       	jmp    100a80 <print_stackframe+0xb0>
        //print ebp & eip
        cprintf("ebp:0x%08x eip:0x%08x args:",ebp,eip);
  1009fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a06:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a0a:	c7 04 24 08 6f 10 00 	movl   $0x106f08,(%esp)
  100a11:	e8 4b f9 ff ff       	call   100361 <cprintf>
        //print args
        // +1 -> 返回地址
        // +2 -> 参数
        uint32_t *args =(uint32_t*)ebp+2;
  100a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a19:	83 c0 08             	add    $0x8,%eax
  100a1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for(j=0;j<4;j++){
  100a1f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a26:	eb 24                	jmp    100a4c <print_stackframe+0x7c>
            cprintf("0x%08x ",args[j]);
  100a28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a2b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a35:	01 d0                	add    %edx,%eax
  100a37:	8b 00                	mov    (%eax),%eax
  100a39:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a3d:	c7 04 24 24 6f 10 00 	movl   $0x106f24,(%esp)
  100a44:	e8 18 f9 ff ff       	call   100361 <cprintf>
        for(j=0;j<4;j++){
  100a49:	ff 45 e8             	incl   -0x18(%ebp)
  100a4c:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a50:	7e d6                	jle    100a28 <print_stackframe+0x58>
        }
        cprintf("\n");
  100a52:	c7 04 24 2c 6f 10 00 	movl   $0x106f2c,(%esp)
  100a59:	e8 03 f9 ff ff       	call   100361 <cprintf>
        // print the C calling function name and line number, etc
        print_debuginfo(eip - 1);
  100a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a61:	48                   	dec    %eax
  100a62:	89 04 24             	mov    %eax,(%esp)
  100a65:	e8 ae fe ff ff       	call   100918 <print_debuginfo>
        // get next func call
        // popup a calling stackframe
        // the calling funciton's return addr eip  = ss:[ebp+4]
        // the calling funciton's ebp = ss:[ebp]
        eip = ((uint32_t *)ebp)[1];
  100a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a6d:	83 c0 04             	add    $0x4,%eax
  100a70:	8b 00                	mov    (%eax),%eax
  100a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a78:	8b 00                	mov    (%eax),%eax
  100a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(int i=0,j=0; ebp!=0 && i<STACKFRAME_DEPTH;i++){
  100a7d:	ff 45 ec             	incl   -0x14(%ebp)
  100a80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a84:	74 0a                	je     100a90 <print_stackframe+0xc0>
  100a86:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a8a:	0f 8e 6c ff ff ff    	jle    1009fc <print_stackframe+0x2c>
    }
}
  100a90:	90                   	nop
  100a91:	89 ec                	mov    %ebp,%esp
  100a93:	5d                   	pop    %ebp
  100a94:	c3                   	ret    

00100a95 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a95:	55                   	push   %ebp
  100a96:	89 e5                	mov    %esp,%ebp
  100a98:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100aa2:	eb 0c                	jmp    100ab0 <parse+0x1b>
            *buf ++ = '\0';
  100aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa7:	8d 50 01             	lea    0x1(%eax),%edx
  100aaa:	89 55 08             	mov    %edx,0x8(%ebp)
  100aad:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  100ab3:	0f b6 00             	movzbl (%eax),%eax
  100ab6:	84 c0                	test   %al,%al
  100ab8:	74 1d                	je     100ad7 <parse+0x42>
  100aba:	8b 45 08             	mov    0x8(%ebp),%eax
  100abd:	0f b6 00             	movzbl (%eax),%eax
  100ac0:	0f be c0             	movsbl %al,%eax
  100ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ac7:	c7 04 24 b0 6f 10 00 	movl   $0x106fb0,(%esp)
  100ace:	e8 5e 5f 00 00       	call   106a31 <strchr>
  100ad3:	85 c0                	test   %eax,%eax
  100ad5:	75 cd                	jne    100aa4 <parse+0xf>
        }
        if (*buf == '\0') {
  100ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  100ada:	0f b6 00             	movzbl (%eax),%eax
  100add:	84 c0                	test   %al,%al
  100adf:	74 65                	je     100b46 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ae1:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ae5:	75 14                	jne    100afb <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ae7:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100aee:	00 
  100aef:	c7 04 24 b5 6f 10 00 	movl   $0x106fb5,(%esp)
  100af6:	e8 66 f8 ff ff       	call   100361 <cprintf>
        }
        argv[argc ++] = buf;
  100afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100afe:	8d 50 01             	lea    0x1(%eax),%edx
  100b01:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b04:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b0e:	01 c2                	add    %eax,%edx
  100b10:	8b 45 08             	mov    0x8(%ebp),%eax
  100b13:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b15:	eb 03                	jmp    100b1a <parse+0x85>
            buf ++;
  100b17:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b1d:	0f b6 00             	movzbl (%eax),%eax
  100b20:	84 c0                	test   %al,%al
  100b22:	74 8c                	je     100ab0 <parse+0x1b>
  100b24:	8b 45 08             	mov    0x8(%ebp),%eax
  100b27:	0f b6 00             	movzbl (%eax),%eax
  100b2a:	0f be c0             	movsbl %al,%eax
  100b2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b31:	c7 04 24 b0 6f 10 00 	movl   $0x106fb0,(%esp)
  100b38:	e8 f4 5e 00 00       	call   106a31 <strchr>
  100b3d:	85 c0                	test   %eax,%eax
  100b3f:	74 d6                	je     100b17 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b41:	e9 6a ff ff ff       	jmp    100ab0 <parse+0x1b>
            break;
  100b46:	90                   	nop
        }
    }
    return argc;
  100b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b4a:	89 ec                	mov    %ebp,%esp
  100b4c:	5d                   	pop    %ebp
  100b4d:	c3                   	ret    

00100b4e <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b4e:	55                   	push   %ebp
  100b4f:	89 e5                	mov    %esp,%ebp
  100b51:	83 ec 68             	sub    $0x68,%esp
  100b54:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b57:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b61:	89 04 24             	mov    %eax,(%esp)
  100b64:	e8 2c ff ff ff       	call   100a95 <parse>
  100b69:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b70:	75 0a                	jne    100b7c <runcmd+0x2e>
        return 0;
  100b72:	b8 00 00 00 00       	mov    $0x0,%eax
  100b77:	e9 83 00 00 00       	jmp    100bff <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b83:	eb 5a                	jmp    100bdf <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b85:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100b88:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100b8b:	89 c8                	mov    %ecx,%eax
  100b8d:	01 c0                	add    %eax,%eax
  100b8f:	01 c8                	add    %ecx,%eax
  100b91:	c1 e0 02             	shl    $0x2,%eax
  100b94:	05 00 b0 11 00       	add    $0x11b000,%eax
  100b99:	8b 00                	mov    (%eax),%eax
  100b9b:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b9f:	89 04 24             	mov    %eax,(%esp)
  100ba2:	e8 ee 5d 00 00       	call   106995 <strcmp>
  100ba7:	85 c0                	test   %eax,%eax
  100ba9:	75 31                	jne    100bdc <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
  100bab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bae:	89 d0                	mov    %edx,%eax
  100bb0:	01 c0                	add    %eax,%eax
  100bb2:	01 d0                	add    %edx,%eax
  100bb4:	c1 e0 02             	shl    $0x2,%eax
  100bb7:	05 08 b0 11 00       	add    $0x11b008,%eax
  100bbc:	8b 10                	mov    (%eax),%edx
  100bbe:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bc1:	83 c0 04             	add    $0x4,%eax
  100bc4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100bc7:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100bca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100bcd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd5:	89 1c 24             	mov    %ebx,(%esp)
  100bd8:	ff d2                	call   *%edx
  100bda:	eb 23                	jmp    100bff <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
  100bdc:	ff 45 f4             	incl   -0xc(%ebp)
  100bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100be2:	83 f8 02             	cmp    $0x2,%eax
  100be5:	76 9e                	jbe    100b85 <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100be7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bea:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bee:	c7 04 24 d3 6f 10 00 	movl   $0x106fd3,(%esp)
  100bf5:	e8 67 f7 ff ff       	call   100361 <cprintf>
    return 0;
  100bfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100c02:	89 ec                	mov    %ebp,%esp
  100c04:	5d                   	pop    %ebp
  100c05:	c3                   	ret    

00100c06 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c06:	55                   	push   %ebp
  100c07:	89 e5                	mov    %esp,%ebp
  100c09:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c0c:	c7 04 24 ec 6f 10 00 	movl   $0x106fec,(%esp)
  100c13:	e8 49 f7 ff ff       	call   100361 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c18:	c7 04 24 14 70 10 00 	movl   $0x107014,(%esp)
  100c1f:	e8 3d f7 ff ff       	call   100361 <cprintf>

    if (tf != NULL) {
  100c24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c28:	74 0b                	je     100c35 <kmonitor+0x2f>
        print_trapframe(tf);
  100c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  100c2d:	89 04 24             	mov    %eax,(%esp)
  100c30:	e8 73 0f 00 00       	call   101ba8 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c35:	c7 04 24 39 70 10 00 	movl   $0x107039,(%esp)
  100c3c:	e8 11 f6 ff ff       	call   100252 <readline>
  100c41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c48:	74 eb                	je     100c35 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  100c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c54:	89 04 24             	mov    %eax,(%esp)
  100c57:	e8 f2 fe ff ff       	call   100b4e <runcmd>
  100c5c:	85 c0                	test   %eax,%eax
  100c5e:	78 02                	js     100c62 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100c60:	eb d3                	jmp    100c35 <kmonitor+0x2f>
                break;
  100c62:	90                   	nop
            }
        }
    }
}
  100c63:	90                   	nop
  100c64:	89 ec                	mov    %ebp,%esp
  100c66:	5d                   	pop    %ebp
  100c67:	c3                   	ret    

00100c68 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c68:	55                   	push   %ebp
  100c69:	89 e5                	mov    %esp,%ebp
  100c6b:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c75:	eb 3d                	jmp    100cb4 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c7a:	89 d0                	mov    %edx,%eax
  100c7c:	01 c0                	add    %eax,%eax
  100c7e:	01 d0                	add    %edx,%eax
  100c80:	c1 e0 02             	shl    $0x2,%eax
  100c83:	05 04 b0 11 00       	add    $0x11b004,%eax
  100c88:	8b 10                	mov    (%eax),%edx
  100c8a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100c8d:	89 c8                	mov    %ecx,%eax
  100c8f:	01 c0                	add    %eax,%eax
  100c91:	01 c8                	add    %ecx,%eax
  100c93:	c1 e0 02             	shl    $0x2,%eax
  100c96:	05 00 b0 11 00       	add    $0x11b000,%eax
  100c9b:	8b 00                	mov    (%eax),%eax
  100c9d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100ca1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ca5:	c7 04 24 3d 70 10 00 	movl   $0x10703d,(%esp)
  100cac:	e8 b0 f6 ff ff       	call   100361 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100cb1:	ff 45 f4             	incl   -0xc(%ebp)
  100cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cb7:	83 f8 02             	cmp    $0x2,%eax
  100cba:	76 bb                	jbe    100c77 <mon_help+0xf>
    }
    return 0;
  100cbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cc1:	89 ec                	mov    %ebp,%esp
  100cc3:	5d                   	pop    %ebp
  100cc4:	c3                   	ret    

00100cc5 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100cc5:	55                   	push   %ebp
  100cc6:	89 e5                	mov    %esp,%ebp
  100cc8:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100ccb:	e8 b4 fb ff ff       	call   100884 <print_kerninfo>
    return 0;
  100cd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cd5:	89 ec                	mov    %ebp,%esp
  100cd7:	5d                   	pop    %ebp
  100cd8:	c3                   	ret    

00100cd9 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cd9:	55                   	push   %ebp
  100cda:	89 e5                	mov    %esp,%ebp
  100cdc:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cdf:	e8 ec fc ff ff       	call   1009d0 <print_stackframe>
    return 0;
  100ce4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ce9:	89 ec                	mov    %ebp,%esp
  100ceb:	5d                   	pop    %ebp
  100cec:	c3                   	ret    

00100ced <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ced:	55                   	push   %ebp
  100cee:	89 e5                	mov    %esp,%ebp
  100cf0:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cf3:	a1 20 e4 11 00       	mov    0x11e420,%eax
  100cf8:	85 c0                	test   %eax,%eax
  100cfa:	75 5b                	jne    100d57 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100cfc:	c7 05 20 e4 11 00 01 	movl   $0x1,0x11e420
  100d03:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100d06:	8d 45 14             	lea    0x14(%ebp),%eax
  100d09:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d0f:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d13:	8b 45 08             	mov    0x8(%ebp),%eax
  100d16:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d1a:	c7 04 24 46 70 10 00 	movl   $0x107046,(%esp)
  100d21:	e8 3b f6 ff ff       	call   100361 <cprintf>
    vcprintf(fmt, ap);
  100d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d29:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d2d:	8b 45 10             	mov    0x10(%ebp),%eax
  100d30:	89 04 24             	mov    %eax,(%esp)
  100d33:	e8 f4 f5 ff ff       	call   10032c <vcprintf>
    cprintf("\n");
  100d38:	c7 04 24 62 70 10 00 	movl   $0x107062,(%esp)
  100d3f:	e8 1d f6 ff ff       	call   100361 <cprintf>
    
    cprintf("stack trackback:\n");
  100d44:	c7 04 24 64 70 10 00 	movl   $0x107064,(%esp)
  100d4b:	e8 11 f6 ff ff       	call   100361 <cprintf>
    print_stackframe();
  100d50:	e8 7b fc ff ff       	call   1009d0 <print_stackframe>
  100d55:	eb 01                	jmp    100d58 <__panic+0x6b>
        goto panic_dead;
  100d57:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d58:	e8 e9 09 00 00       	call   101746 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d64:	e8 9d fe ff ff       	call   100c06 <kmonitor>
  100d69:	eb f2                	jmp    100d5d <__panic+0x70>

00100d6b <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d6b:	55                   	push   %ebp
  100d6c:	89 e5                	mov    %esp,%ebp
  100d6e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d71:	8d 45 14             	lea    0x14(%ebp),%eax
  100d74:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d7a:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  100d81:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d85:	c7 04 24 76 70 10 00 	movl   $0x107076,(%esp)
  100d8c:	e8 d0 f5 ff ff       	call   100361 <cprintf>
    vcprintf(fmt, ap);
  100d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d94:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d98:	8b 45 10             	mov    0x10(%ebp),%eax
  100d9b:	89 04 24             	mov    %eax,(%esp)
  100d9e:	e8 89 f5 ff ff       	call   10032c <vcprintf>
    cprintf("\n");
  100da3:	c7 04 24 62 70 10 00 	movl   $0x107062,(%esp)
  100daa:	e8 b2 f5 ff ff       	call   100361 <cprintf>
    va_end(ap);
}
  100daf:	90                   	nop
  100db0:	89 ec                	mov    %ebp,%esp
  100db2:	5d                   	pop    %ebp
  100db3:	c3                   	ret    

00100db4 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100db4:	55                   	push   %ebp
  100db5:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100db7:	a1 20 e4 11 00       	mov    0x11e420,%eax
}
  100dbc:	5d                   	pop    %ebp
  100dbd:	c3                   	ret    

00100dbe <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100dbe:	55                   	push   %ebp
  100dbf:	89 e5                	mov    %esp,%ebp
  100dc1:	83 ec 28             	sub    $0x28,%esp
  100dc4:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100dca:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100dce:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dd2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dd6:	ee                   	out    %al,(%dx)
}
  100dd7:	90                   	nop
  100dd8:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100dde:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100de2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100de6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dea:	ee                   	out    %al,(%dx)
}
  100deb:	90                   	nop
  100dec:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100df2:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100df6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100dfa:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dfe:	ee                   	out    %al,(%dx)
}
  100dff:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e00:	c7 05 24 e4 11 00 00 	movl   $0x0,0x11e424
  100e07:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e0a:	c7 04 24 94 70 10 00 	movl   $0x107094,(%esp)
  100e11:	e8 4b f5 ff ff       	call   100361 <cprintf>
    pic_enable(IRQ_TIMER);
  100e16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e1d:	e8 89 09 00 00       	call   1017ab <pic_enable>
}
  100e22:	90                   	nop
  100e23:	89 ec                	mov    %ebp,%esp
  100e25:	5d                   	pop    %ebp
  100e26:	c3                   	ret    

00100e27 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e27:	55                   	push   %ebp
  100e28:	89 e5                	mov    %esp,%ebp
  100e2a:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e2d:	9c                   	pushf  
  100e2e:	58                   	pop    %eax
  100e2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e35:	25 00 02 00 00       	and    $0x200,%eax
  100e3a:	85 c0                	test   %eax,%eax
  100e3c:	74 0c                	je     100e4a <__intr_save+0x23>
        intr_disable();
  100e3e:	e8 03 09 00 00       	call   101746 <intr_disable>
        return 1;
  100e43:	b8 01 00 00 00       	mov    $0x1,%eax
  100e48:	eb 05                	jmp    100e4f <__intr_save+0x28>
    }
    return 0;
  100e4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e4f:	89 ec                	mov    %ebp,%esp
  100e51:	5d                   	pop    %ebp
  100e52:	c3                   	ret    

00100e53 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e53:	55                   	push   %ebp
  100e54:	89 e5                	mov    %esp,%ebp
  100e56:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e5d:	74 05                	je     100e64 <__intr_restore+0x11>
        intr_enable();
  100e5f:	e8 da 08 00 00       	call   10173e <intr_enable>
    }
}
  100e64:	90                   	nop
  100e65:	89 ec                	mov    %ebp,%esp
  100e67:	5d                   	pop    %ebp
  100e68:	c3                   	ret    

00100e69 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e69:	55                   	push   %ebp
  100e6a:	89 e5                	mov    %esp,%ebp
  100e6c:	83 ec 10             	sub    $0x10,%esp
  100e6f:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e75:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e79:	89 c2                	mov    %eax,%edx
  100e7b:	ec                   	in     (%dx),%al
  100e7c:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e7f:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e85:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e89:	89 c2                	mov    %eax,%edx
  100e8b:	ec                   	in     (%dx),%al
  100e8c:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e8f:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e95:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e99:	89 c2                	mov    %eax,%edx
  100e9b:	ec                   	in     (%dx),%al
  100e9c:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e9f:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100ea5:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100ea9:	89 c2                	mov    %eax,%edx
  100eab:	ec                   	in     (%dx),%al
  100eac:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100eaf:	90                   	nop
  100eb0:	89 ec                	mov    %ebp,%esp
  100eb2:	5d                   	pop    %ebp
  100eb3:	c3                   	ret    

00100eb4 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100eb4:	55                   	push   %ebp
  100eb5:	89 e5                	mov    %esp,%ebp
  100eb7:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100eba:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec4:	0f b7 00             	movzwl (%eax),%eax
  100ec7:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100ecb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ece:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100ed3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed6:	0f b7 00             	movzwl (%eax),%eax
  100ed9:	0f b7 c0             	movzwl %ax,%eax
  100edc:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100ee1:	74 12                	je     100ef5 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100ee3:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100eea:	66 c7 05 46 e4 11 00 	movw   $0x3b4,0x11e446
  100ef1:	b4 03 
  100ef3:	eb 13                	jmp    100f08 <cga_init+0x54>
    } else {
        *cp = was;
  100ef5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ef8:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100efc:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eff:	66 c7 05 46 e4 11 00 	movw   $0x3d4,0x11e446
  100f06:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100f08:	0f b7 05 46 e4 11 00 	movzwl 0x11e446,%eax
  100f0f:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f13:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f17:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f1b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f1f:	ee                   	out    %al,(%dx)
}
  100f20:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100f21:	0f b7 05 46 e4 11 00 	movzwl 0x11e446,%eax
  100f28:	40                   	inc    %eax
  100f29:	0f b7 c0             	movzwl %ax,%eax
  100f2c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f30:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f34:	89 c2                	mov    %eax,%edx
  100f36:	ec                   	in     (%dx),%al
  100f37:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f3a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f3e:	0f b6 c0             	movzbl %al,%eax
  100f41:	c1 e0 08             	shl    $0x8,%eax
  100f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f47:	0f b7 05 46 e4 11 00 	movzwl 0x11e446,%eax
  100f4e:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f52:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f56:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f5a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f5e:	ee                   	out    %al,(%dx)
}
  100f5f:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100f60:	0f b7 05 46 e4 11 00 	movzwl 0x11e446,%eax
  100f67:	40                   	inc    %eax
  100f68:	0f b7 c0             	movzwl %ax,%eax
  100f6b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f6f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f73:	89 c2                	mov    %eax,%edx
  100f75:	ec                   	in     (%dx),%al
  100f76:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f79:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f7d:	0f b6 c0             	movzbl %al,%eax
  100f80:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f86:	a3 40 e4 11 00       	mov    %eax,0x11e440
    crt_pos = pos;
  100f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f8e:	0f b7 c0             	movzwl %ax,%eax
  100f91:	66 a3 44 e4 11 00    	mov    %ax,0x11e444
}
  100f97:	90                   	nop
  100f98:	89 ec                	mov    %ebp,%esp
  100f9a:	5d                   	pop    %ebp
  100f9b:	c3                   	ret    

00100f9c <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f9c:	55                   	push   %ebp
  100f9d:	89 e5                	mov    %esp,%ebp
  100f9f:	83 ec 48             	sub    $0x48,%esp
  100fa2:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100fa8:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fac:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100fb0:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100fb4:	ee                   	out    %al,(%dx)
}
  100fb5:	90                   	nop
  100fb6:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100fbc:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fc0:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100fc4:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100fc8:	ee                   	out    %al,(%dx)
}
  100fc9:	90                   	nop
  100fca:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100fd0:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fd4:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100fd8:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fdc:	ee                   	out    %al,(%dx)
}
  100fdd:	90                   	nop
  100fde:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fe4:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fe8:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fec:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100ff0:	ee                   	out    %al,(%dx)
}
  100ff1:	90                   	nop
  100ff2:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100ff8:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ffc:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101000:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101004:	ee                   	out    %al,(%dx)
}
  101005:	90                   	nop
  101006:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  10100c:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101010:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101014:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101018:	ee                   	out    %al,(%dx)
}
  101019:	90                   	nop
  10101a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  101020:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101024:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101028:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10102c:	ee                   	out    %al,(%dx)
}
  10102d:	90                   	nop
  10102e:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101034:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  101038:	89 c2                	mov    %eax,%edx
  10103a:	ec                   	in     (%dx),%al
  10103b:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  10103e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101042:	3c ff                	cmp    $0xff,%al
  101044:	0f 95 c0             	setne  %al
  101047:	0f b6 c0             	movzbl %al,%eax
  10104a:	a3 48 e4 11 00       	mov    %eax,0x11e448
  10104f:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101055:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101059:	89 c2                	mov    %eax,%edx
  10105b:	ec                   	in     (%dx),%al
  10105c:	88 45 f1             	mov    %al,-0xf(%ebp)
  10105f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101065:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101069:	89 c2                	mov    %eax,%edx
  10106b:	ec                   	in     (%dx),%al
  10106c:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10106f:	a1 48 e4 11 00       	mov    0x11e448,%eax
  101074:	85 c0                	test   %eax,%eax
  101076:	74 0c                	je     101084 <serial_init+0xe8>
        pic_enable(IRQ_COM1);
  101078:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10107f:	e8 27 07 00 00       	call   1017ab <pic_enable>
    }
}
  101084:	90                   	nop
  101085:	89 ec                	mov    %ebp,%esp
  101087:	5d                   	pop    %ebp
  101088:	c3                   	ret    

00101089 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101089:	55                   	push   %ebp
  10108a:	89 e5                	mov    %esp,%ebp
  10108c:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10108f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101096:	eb 08                	jmp    1010a0 <lpt_putc_sub+0x17>
        delay();
  101098:	e8 cc fd ff ff       	call   100e69 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10109d:	ff 45 fc             	incl   -0x4(%ebp)
  1010a0:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  1010a6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1010aa:	89 c2                	mov    %eax,%edx
  1010ac:	ec                   	in     (%dx),%al
  1010ad:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1010b0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1010b4:	84 c0                	test   %al,%al
  1010b6:	78 09                	js     1010c1 <lpt_putc_sub+0x38>
  1010b8:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1010bf:	7e d7                	jle    101098 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  1010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1010c4:	0f b6 c0             	movzbl %al,%eax
  1010c7:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  1010cd:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010d0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010d4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010d8:	ee                   	out    %al,(%dx)
}
  1010d9:	90                   	nop
  1010da:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010e0:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010e4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010e8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010ec:	ee                   	out    %al,(%dx)
}
  1010ed:	90                   	nop
  1010ee:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010f4:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010f8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010fc:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101100:	ee                   	out    %al,(%dx)
}
  101101:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101102:	90                   	nop
  101103:	89 ec                	mov    %ebp,%esp
  101105:	5d                   	pop    %ebp
  101106:	c3                   	ret    

00101107 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101107:	55                   	push   %ebp
  101108:	89 e5                	mov    %esp,%ebp
  10110a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10110d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101111:	74 0d                	je     101120 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101113:	8b 45 08             	mov    0x8(%ebp),%eax
  101116:	89 04 24             	mov    %eax,(%esp)
  101119:	e8 6b ff ff ff       	call   101089 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10111e:	eb 24                	jmp    101144 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  101120:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101127:	e8 5d ff ff ff       	call   101089 <lpt_putc_sub>
        lpt_putc_sub(' ');
  10112c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101133:	e8 51 ff ff ff       	call   101089 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101138:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10113f:	e8 45 ff ff ff       	call   101089 <lpt_putc_sub>
}
  101144:	90                   	nop
  101145:	89 ec                	mov    %ebp,%esp
  101147:	5d                   	pop    %ebp
  101148:	c3                   	ret    

00101149 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101149:	55                   	push   %ebp
  10114a:	89 e5                	mov    %esp,%ebp
  10114c:	83 ec 38             	sub    $0x38,%esp
  10114f:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
  101152:	8b 45 08             	mov    0x8(%ebp),%eax
  101155:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10115a:	85 c0                	test   %eax,%eax
  10115c:	75 07                	jne    101165 <cga_putc+0x1c>
        c |= 0x0700;
  10115e:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101165:	8b 45 08             	mov    0x8(%ebp),%eax
  101168:	0f b6 c0             	movzbl %al,%eax
  10116b:	83 f8 0d             	cmp    $0xd,%eax
  10116e:	74 72                	je     1011e2 <cga_putc+0x99>
  101170:	83 f8 0d             	cmp    $0xd,%eax
  101173:	0f 8f a3 00 00 00    	jg     10121c <cga_putc+0xd3>
  101179:	83 f8 08             	cmp    $0x8,%eax
  10117c:	74 0a                	je     101188 <cga_putc+0x3f>
  10117e:	83 f8 0a             	cmp    $0xa,%eax
  101181:	74 4c                	je     1011cf <cga_putc+0x86>
  101183:	e9 94 00 00 00       	jmp    10121c <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
  101188:	0f b7 05 44 e4 11 00 	movzwl 0x11e444,%eax
  10118f:	85 c0                	test   %eax,%eax
  101191:	0f 84 af 00 00 00    	je     101246 <cga_putc+0xfd>
            crt_pos --;
  101197:	0f b7 05 44 e4 11 00 	movzwl 0x11e444,%eax
  10119e:	48                   	dec    %eax
  10119f:	0f b7 c0             	movzwl %ax,%eax
  1011a2:	66 a3 44 e4 11 00    	mov    %ax,0x11e444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1011ab:	98                   	cwtl   
  1011ac:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1011b1:	98                   	cwtl   
  1011b2:	83 c8 20             	or     $0x20,%eax
  1011b5:	98                   	cwtl   
  1011b6:	8b 0d 40 e4 11 00    	mov    0x11e440,%ecx
  1011bc:	0f b7 15 44 e4 11 00 	movzwl 0x11e444,%edx
  1011c3:	01 d2                	add    %edx,%edx
  1011c5:	01 ca                	add    %ecx,%edx
  1011c7:	0f b7 c0             	movzwl %ax,%eax
  1011ca:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011cd:	eb 77                	jmp    101246 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
  1011cf:	0f b7 05 44 e4 11 00 	movzwl 0x11e444,%eax
  1011d6:	83 c0 50             	add    $0x50,%eax
  1011d9:	0f b7 c0             	movzwl %ax,%eax
  1011dc:	66 a3 44 e4 11 00    	mov    %ax,0x11e444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011e2:	0f b7 1d 44 e4 11 00 	movzwl 0x11e444,%ebx
  1011e9:	0f b7 0d 44 e4 11 00 	movzwl 0x11e444,%ecx
  1011f0:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1011f5:	89 c8                	mov    %ecx,%eax
  1011f7:	f7 e2                	mul    %edx
  1011f9:	c1 ea 06             	shr    $0x6,%edx
  1011fc:	89 d0                	mov    %edx,%eax
  1011fe:	c1 e0 02             	shl    $0x2,%eax
  101201:	01 d0                	add    %edx,%eax
  101203:	c1 e0 04             	shl    $0x4,%eax
  101206:	29 c1                	sub    %eax,%ecx
  101208:	89 ca                	mov    %ecx,%edx
  10120a:	0f b7 d2             	movzwl %dx,%edx
  10120d:	89 d8                	mov    %ebx,%eax
  10120f:	29 d0                	sub    %edx,%eax
  101211:	0f b7 c0             	movzwl %ax,%eax
  101214:	66 a3 44 e4 11 00    	mov    %ax,0x11e444
        break;
  10121a:	eb 2b                	jmp    101247 <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10121c:	8b 0d 40 e4 11 00    	mov    0x11e440,%ecx
  101222:	0f b7 05 44 e4 11 00 	movzwl 0x11e444,%eax
  101229:	8d 50 01             	lea    0x1(%eax),%edx
  10122c:	0f b7 d2             	movzwl %dx,%edx
  10122f:	66 89 15 44 e4 11 00 	mov    %dx,0x11e444
  101236:	01 c0                	add    %eax,%eax
  101238:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10123b:	8b 45 08             	mov    0x8(%ebp),%eax
  10123e:	0f b7 c0             	movzwl %ax,%eax
  101241:	66 89 02             	mov    %ax,(%edx)
        break;
  101244:	eb 01                	jmp    101247 <cga_putc+0xfe>
        break;
  101246:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101247:	0f b7 05 44 e4 11 00 	movzwl 0x11e444,%eax
  10124e:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101253:	76 5e                	jbe    1012b3 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101255:	a1 40 e4 11 00       	mov    0x11e440,%eax
  10125a:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101260:	a1 40 e4 11 00       	mov    0x11e440,%eax
  101265:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10126c:	00 
  10126d:	89 54 24 04          	mov    %edx,0x4(%esp)
  101271:	89 04 24             	mov    %eax,(%esp)
  101274:	e8 b6 59 00 00       	call   106c2f <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101279:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101280:	eb 15                	jmp    101297 <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
  101282:	8b 15 40 e4 11 00    	mov    0x11e440,%edx
  101288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10128b:	01 c0                	add    %eax,%eax
  10128d:	01 d0                	add    %edx,%eax
  10128f:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101294:	ff 45 f4             	incl   -0xc(%ebp)
  101297:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10129e:	7e e2                	jle    101282 <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
  1012a0:	0f b7 05 44 e4 11 00 	movzwl 0x11e444,%eax
  1012a7:	83 e8 50             	sub    $0x50,%eax
  1012aa:	0f b7 c0             	movzwl %ax,%eax
  1012ad:	66 a3 44 e4 11 00    	mov    %ax,0x11e444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012b3:	0f b7 05 46 e4 11 00 	movzwl 0x11e446,%eax
  1012ba:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1012be:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012c2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012c6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012ca:	ee                   	out    %al,(%dx)
}
  1012cb:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  1012cc:	0f b7 05 44 e4 11 00 	movzwl 0x11e444,%eax
  1012d3:	c1 e8 08             	shr    $0x8,%eax
  1012d6:	0f b7 c0             	movzwl %ax,%eax
  1012d9:	0f b6 c0             	movzbl %al,%eax
  1012dc:	0f b7 15 46 e4 11 00 	movzwl 0x11e446,%edx
  1012e3:	42                   	inc    %edx
  1012e4:	0f b7 d2             	movzwl %dx,%edx
  1012e7:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012eb:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012ee:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012f2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012f6:	ee                   	out    %al,(%dx)
}
  1012f7:	90                   	nop
    outb(addr_6845, 15);
  1012f8:	0f b7 05 46 e4 11 00 	movzwl 0x11e446,%eax
  1012ff:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101303:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101307:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10130b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10130f:	ee                   	out    %al,(%dx)
}
  101310:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  101311:	0f b7 05 44 e4 11 00 	movzwl 0x11e444,%eax
  101318:	0f b6 c0             	movzbl %al,%eax
  10131b:	0f b7 15 46 e4 11 00 	movzwl 0x11e446,%edx
  101322:	42                   	inc    %edx
  101323:	0f b7 d2             	movzwl %dx,%edx
  101326:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  10132a:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10132d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101331:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101335:	ee                   	out    %al,(%dx)
}
  101336:	90                   	nop
}
  101337:	90                   	nop
  101338:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10133b:	89 ec                	mov    %ebp,%esp
  10133d:	5d                   	pop    %ebp
  10133e:	c3                   	ret    

0010133f <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10133f:	55                   	push   %ebp
  101340:	89 e5                	mov    %esp,%ebp
  101342:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101345:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10134c:	eb 08                	jmp    101356 <serial_putc_sub+0x17>
        delay();
  10134e:	e8 16 fb ff ff       	call   100e69 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101353:	ff 45 fc             	incl   -0x4(%ebp)
  101356:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10135c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101360:	89 c2                	mov    %eax,%edx
  101362:	ec                   	in     (%dx),%al
  101363:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101366:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10136a:	0f b6 c0             	movzbl %al,%eax
  10136d:	83 e0 20             	and    $0x20,%eax
  101370:	85 c0                	test   %eax,%eax
  101372:	75 09                	jne    10137d <serial_putc_sub+0x3e>
  101374:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10137b:	7e d1                	jle    10134e <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  10137d:	8b 45 08             	mov    0x8(%ebp),%eax
  101380:	0f b6 c0             	movzbl %al,%eax
  101383:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101389:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10138c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101390:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101394:	ee                   	out    %al,(%dx)
}
  101395:	90                   	nop
}
  101396:	90                   	nop
  101397:	89 ec                	mov    %ebp,%esp
  101399:	5d                   	pop    %ebp
  10139a:	c3                   	ret    

0010139b <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10139b:	55                   	push   %ebp
  10139c:	89 e5                	mov    %esp,%ebp
  10139e:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1013a1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1013a5:	74 0d                	je     1013b4 <serial_putc+0x19>
        serial_putc_sub(c);
  1013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1013aa:	89 04 24             	mov    %eax,(%esp)
  1013ad:	e8 8d ff ff ff       	call   10133f <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1013b2:	eb 24                	jmp    1013d8 <serial_putc+0x3d>
        serial_putc_sub('\b');
  1013b4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013bb:	e8 7f ff ff ff       	call   10133f <serial_putc_sub>
        serial_putc_sub(' ');
  1013c0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1013c7:	e8 73 ff ff ff       	call   10133f <serial_putc_sub>
        serial_putc_sub('\b');
  1013cc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013d3:	e8 67 ff ff ff       	call   10133f <serial_putc_sub>
}
  1013d8:	90                   	nop
  1013d9:	89 ec                	mov    %ebp,%esp
  1013db:	5d                   	pop    %ebp
  1013dc:	c3                   	ret    

001013dd <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013dd:	55                   	push   %ebp
  1013de:	89 e5                	mov    %esp,%ebp
  1013e0:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013e3:	eb 33                	jmp    101418 <cons_intr+0x3b>
        if (c != 0) {
  1013e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013e9:	74 2d                	je     101418 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1013eb:	a1 64 e6 11 00       	mov    0x11e664,%eax
  1013f0:	8d 50 01             	lea    0x1(%eax),%edx
  1013f3:	89 15 64 e6 11 00    	mov    %edx,0x11e664
  1013f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013fc:	88 90 60 e4 11 00    	mov    %dl,0x11e460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101402:	a1 64 e6 11 00       	mov    0x11e664,%eax
  101407:	3d 00 02 00 00       	cmp    $0x200,%eax
  10140c:	75 0a                	jne    101418 <cons_intr+0x3b>
                cons.wpos = 0;
  10140e:	c7 05 64 e6 11 00 00 	movl   $0x0,0x11e664
  101415:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101418:	8b 45 08             	mov    0x8(%ebp),%eax
  10141b:	ff d0                	call   *%eax
  10141d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101420:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101424:	75 bf                	jne    1013e5 <cons_intr+0x8>
            }
        }
    }
}
  101426:	90                   	nop
  101427:	90                   	nop
  101428:	89 ec                	mov    %ebp,%esp
  10142a:	5d                   	pop    %ebp
  10142b:	c3                   	ret    

0010142c <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10142c:	55                   	push   %ebp
  10142d:	89 e5                	mov    %esp,%ebp
  10142f:	83 ec 10             	sub    $0x10,%esp
  101432:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101438:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10143c:	89 c2                	mov    %eax,%edx
  10143e:	ec                   	in     (%dx),%al
  10143f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101442:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101446:	0f b6 c0             	movzbl %al,%eax
  101449:	83 e0 01             	and    $0x1,%eax
  10144c:	85 c0                	test   %eax,%eax
  10144e:	75 07                	jne    101457 <serial_proc_data+0x2b>
        return -1;
  101450:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101455:	eb 2a                	jmp    101481 <serial_proc_data+0x55>
  101457:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10145d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101461:	89 c2                	mov    %eax,%edx
  101463:	ec                   	in     (%dx),%al
  101464:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101467:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10146b:	0f b6 c0             	movzbl %al,%eax
  10146e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101471:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101475:	75 07                	jne    10147e <serial_proc_data+0x52>
        c = '\b';
  101477:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10147e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101481:	89 ec                	mov    %ebp,%esp
  101483:	5d                   	pop    %ebp
  101484:	c3                   	ret    

00101485 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101485:	55                   	push   %ebp
  101486:	89 e5                	mov    %esp,%ebp
  101488:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10148b:	a1 48 e4 11 00       	mov    0x11e448,%eax
  101490:	85 c0                	test   %eax,%eax
  101492:	74 0c                	je     1014a0 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101494:	c7 04 24 2c 14 10 00 	movl   $0x10142c,(%esp)
  10149b:	e8 3d ff ff ff       	call   1013dd <cons_intr>
    }
}
  1014a0:	90                   	nop
  1014a1:	89 ec                	mov    %ebp,%esp
  1014a3:	5d                   	pop    %ebp
  1014a4:	c3                   	ret    

001014a5 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1014a5:	55                   	push   %ebp
  1014a6:	89 e5                	mov    %esp,%ebp
  1014a8:	83 ec 38             	sub    $0x38,%esp
  1014ab:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1014b4:	89 c2                	mov    %eax,%edx
  1014b6:	ec                   	in     (%dx),%al
  1014b7:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1014ba:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014be:	0f b6 c0             	movzbl %al,%eax
  1014c1:	83 e0 01             	and    $0x1,%eax
  1014c4:	85 c0                	test   %eax,%eax
  1014c6:	75 0a                	jne    1014d2 <kbd_proc_data+0x2d>
        return -1;
  1014c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014cd:	e9 56 01 00 00       	jmp    101628 <kbd_proc_data+0x183>
  1014d2:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1014db:	89 c2                	mov    %eax,%edx
  1014dd:	ec                   	in     (%dx),%al
  1014de:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014e1:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014e5:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014e8:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014ec:	75 17                	jne    101505 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  1014ee:	a1 68 e6 11 00       	mov    0x11e668,%eax
  1014f3:	83 c8 40             	or     $0x40,%eax
  1014f6:	a3 68 e6 11 00       	mov    %eax,0x11e668
        return 0;
  1014fb:	b8 00 00 00 00       	mov    $0x0,%eax
  101500:	e9 23 01 00 00       	jmp    101628 <kbd_proc_data+0x183>
    } else if (data & 0x80) {
  101505:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101509:	84 c0                	test   %al,%al
  10150b:	79 45                	jns    101552 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10150d:	a1 68 e6 11 00       	mov    0x11e668,%eax
  101512:	83 e0 40             	and    $0x40,%eax
  101515:	85 c0                	test   %eax,%eax
  101517:	75 08                	jne    101521 <kbd_proc_data+0x7c>
  101519:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10151d:	24 7f                	and    $0x7f,%al
  10151f:	eb 04                	jmp    101525 <kbd_proc_data+0x80>
  101521:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101525:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101528:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152c:	0f b6 80 40 b0 11 00 	movzbl 0x11b040(%eax),%eax
  101533:	0c 40                	or     $0x40,%al
  101535:	0f b6 c0             	movzbl %al,%eax
  101538:	f7 d0                	not    %eax
  10153a:	89 c2                	mov    %eax,%edx
  10153c:	a1 68 e6 11 00       	mov    0x11e668,%eax
  101541:	21 d0                	and    %edx,%eax
  101543:	a3 68 e6 11 00       	mov    %eax,0x11e668
        return 0;
  101548:	b8 00 00 00 00       	mov    $0x0,%eax
  10154d:	e9 d6 00 00 00       	jmp    101628 <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
  101552:	a1 68 e6 11 00       	mov    0x11e668,%eax
  101557:	83 e0 40             	and    $0x40,%eax
  10155a:	85 c0                	test   %eax,%eax
  10155c:	74 11                	je     10156f <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10155e:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101562:	a1 68 e6 11 00       	mov    0x11e668,%eax
  101567:	83 e0 bf             	and    $0xffffffbf,%eax
  10156a:	a3 68 e6 11 00       	mov    %eax,0x11e668
    }

    shift |= shiftcode[data];
  10156f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101573:	0f b6 80 40 b0 11 00 	movzbl 0x11b040(%eax),%eax
  10157a:	0f b6 d0             	movzbl %al,%edx
  10157d:	a1 68 e6 11 00       	mov    0x11e668,%eax
  101582:	09 d0                	or     %edx,%eax
  101584:	a3 68 e6 11 00       	mov    %eax,0x11e668
    shift ^= togglecode[data];
  101589:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10158d:	0f b6 80 40 b1 11 00 	movzbl 0x11b140(%eax),%eax
  101594:	0f b6 d0             	movzbl %al,%edx
  101597:	a1 68 e6 11 00       	mov    0x11e668,%eax
  10159c:	31 d0                	xor    %edx,%eax
  10159e:	a3 68 e6 11 00       	mov    %eax,0x11e668

    c = charcode[shift & (CTL | SHIFT)][data];
  1015a3:	a1 68 e6 11 00       	mov    0x11e668,%eax
  1015a8:	83 e0 03             	and    $0x3,%eax
  1015ab:	8b 14 85 40 b5 11 00 	mov    0x11b540(,%eax,4),%edx
  1015b2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015b6:	01 d0                	add    %edx,%eax
  1015b8:	0f b6 00             	movzbl (%eax),%eax
  1015bb:	0f b6 c0             	movzbl %al,%eax
  1015be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015c1:	a1 68 e6 11 00       	mov    0x11e668,%eax
  1015c6:	83 e0 08             	and    $0x8,%eax
  1015c9:	85 c0                	test   %eax,%eax
  1015cb:	74 22                	je     1015ef <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  1015cd:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015d1:	7e 0c                	jle    1015df <kbd_proc_data+0x13a>
  1015d3:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015d7:	7f 06                	jg     1015df <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  1015d9:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015dd:	eb 10                	jmp    1015ef <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  1015df:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015e3:	7e 0a                	jle    1015ef <kbd_proc_data+0x14a>
  1015e5:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015e9:	7f 04                	jg     1015ef <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  1015eb:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015ef:	a1 68 e6 11 00       	mov    0x11e668,%eax
  1015f4:	f7 d0                	not    %eax
  1015f6:	83 e0 06             	and    $0x6,%eax
  1015f9:	85 c0                	test   %eax,%eax
  1015fb:	75 28                	jne    101625 <kbd_proc_data+0x180>
  1015fd:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101604:	75 1f                	jne    101625 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
  101606:	c7 04 24 af 70 10 00 	movl   $0x1070af,(%esp)
  10160d:	e8 4f ed ff ff       	call   100361 <cprintf>
  101612:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101618:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10161c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101620:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101623:	ee                   	out    %al,(%dx)
}
  101624:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101625:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101628:	89 ec                	mov    %ebp,%esp
  10162a:	5d                   	pop    %ebp
  10162b:	c3                   	ret    

0010162c <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10162c:	55                   	push   %ebp
  10162d:	89 e5                	mov    %esp,%ebp
  10162f:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101632:	c7 04 24 a5 14 10 00 	movl   $0x1014a5,(%esp)
  101639:	e8 9f fd ff ff       	call   1013dd <cons_intr>
}
  10163e:	90                   	nop
  10163f:	89 ec                	mov    %ebp,%esp
  101641:	5d                   	pop    %ebp
  101642:	c3                   	ret    

00101643 <kbd_init>:

static void
kbd_init(void) {
  101643:	55                   	push   %ebp
  101644:	89 e5                	mov    %esp,%ebp
  101646:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101649:	e8 de ff ff ff       	call   10162c <kbd_intr>
    pic_enable(IRQ_KBD);
  10164e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101655:	e8 51 01 00 00       	call   1017ab <pic_enable>
}
  10165a:	90                   	nop
  10165b:	89 ec                	mov    %ebp,%esp
  10165d:	5d                   	pop    %ebp
  10165e:	c3                   	ret    

0010165f <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10165f:	55                   	push   %ebp
  101660:	89 e5                	mov    %esp,%ebp
  101662:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101665:	e8 4a f8 ff ff       	call   100eb4 <cga_init>
    serial_init();
  10166a:	e8 2d f9 ff ff       	call   100f9c <serial_init>
    kbd_init();
  10166f:	e8 cf ff ff ff       	call   101643 <kbd_init>
    if (!serial_exists) {
  101674:	a1 48 e4 11 00       	mov    0x11e448,%eax
  101679:	85 c0                	test   %eax,%eax
  10167b:	75 0c                	jne    101689 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10167d:	c7 04 24 bb 70 10 00 	movl   $0x1070bb,(%esp)
  101684:	e8 d8 ec ff ff       	call   100361 <cprintf>
    }
}
  101689:	90                   	nop
  10168a:	89 ec                	mov    %ebp,%esp
  10168c:	5d                   	pop    %ebp
  10168d:	c3                   	ret    

0010168e <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10168e:	55                   	push   %ebp
  10168f:	89 e5                	mov    %esp,%ebp
  101691:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101694:	e8 8e f7 ff ff       	call   100e27 <__intr_save>
  101699:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10169c:	8b 45 08             	mov    0x8(%ebp),%eax
  10169f:	89 04 24             	mov    %eax,(%esp)
  1016a2:	e8 60 fa ff ff       	call   101107 <lpt_putc>
        cga_putc(c);
  1016a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1016aa:	89 04 24             	mov    %eax,(%esp)
  1016ad:	e8 97 fa ff ff       	call   101149 <cga_putc>
        serial_putc(c);
  1016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b5:	89 04 24             	mov    %eax,(%esp)
  1016b8:	e8 de fc ff ff       	call   10139b <serial_putc>
    }
    local_intr_restore(intr_flag);
  1016bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016c0:	89 04 24             	mov    %eax,(%esp)
  1016c3:	e8 8b f7 ff ff       	call   100e53 <__intr_restore>
}
  1016c8:	90                   	nop
  1016c9:	89 ec                	mov    %ebp,%esp
  1016cb:	5d                   	pop    %ebp
  1016cc:	c3                   	ret    

001016cd <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1016cd:	55                   	push   %ebp
  1016ce:	89 e5                	mov    %esp,%ebp
  1016d0:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  1016d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  1016da:	e8 48 f7 ff ff       	call   100e27 <__intr_save>
  1016df:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  1016e2:	e8 9e fd ff ff       	call   101485 <serial_intr>
        kbd_intr();
  1016e7:	e8 40 ff ff ff       	call   10162c <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  1016ec:	8b 15 60 e6 11 00    	mov    0x11e660,%edx
  1016f2:	a1 64 e6 11 00       	mov    0x11e664,%eax
  1016f7:	39 c2                	cmp    %eax,%edx
  1016f9:	74 31                	je     10172c <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  1016fb:	a1 60 e6 11 00       	mov    0x11e660,%eax
  101700:	8d 50 01             	lea    0x1(%eax),%edx
  101703:	89 15 60 e6 11 00    	mov    %edx,0x11e660
  101709:	0f b6 80 60 e4 11 00 	movzbl 0x11e460(%eax),%eax
  101710:	0f b6 c0             	movzbl %al,%eax
  101713:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101716:	a1 60 e6 11 00       	mov    0x11e660,%eax
  10171b:	3d 00 02 00 00       	cmp    $0x200,%eax
  101720:	75 0a                	jne    10172c <cons_getc+0x5f>
                cons.rpos = 0;
  101722:	c7 05 60 e6 11 00 00 	movl   $0x0,0x11e660
  101729:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  10172c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10172f:	89 04 24             	mov    %eax,(%esp)
  101732:	e8 1c f7 ff ff       	call   100e53 <__intr_restore>
    return c;
  101737:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10173a:	89 ec                	mov    %ebp,%esp
  10173c:	5d                   	pop    %ebp
  10173d:	c3                   	ret    

0010173e <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10173e:	55                   	push   %ebp
  10173f:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  101741:	fb                   	sti    
}
  101742:	90                   	nop
    sti();
}
  101743:	90                   	nop
  101744:	5d                   	pop    %ebp
  101745:	c3                   	ret    

00101746 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101746:	55                   	push   %ebp
  101747:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  101749:	fa                   	cli    
}
  10174a:	90                   	nop
    cli();
}
  10174b:	90                   	nop
  10174c:	5d                   	pop    %ebp
  10174d:	c3                   	ret    

0010174e <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10174e:	55                   	push   %ebp
  10174f:	89 e5                	mov    %esp,%ebp
  101751:	83 ec 14             	sub    $0x14,%esp
  101754:	8b 45 08             	mov    0x8(%ebp),%eax
  101757:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  10175b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10175e:	66 a3 50 b5 11 00    	mov    %ax,0x11b550
    if (did_init) {
  101764:	a1 6c e6 11 00       	mov    0x11e66c,%eax
  101769:	85 c0                	test   %eax,%eax
  10176b:	74 39                	je     1017a6 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
  10176d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101770:	0f b6 c0             	movzbl %al,%eax
  101773:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101779:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10177c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101780:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101784:	ee                   	out    %al,(%dx)
}
  101785:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101786:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10178a:	c1 e8 08             	shr    $0x8,%eax
  10178d:	0f b7 c0             	movzwl %ax,%eax
  101790:	0f b6 c0             	movzbl %al,%eax
  101793:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101799:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10179c:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017a0:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017a4:	ee                   	out    %al,(%dx)
}
  1017a5:	90                   	nop
    }
}
  1017a6:	90                   	nop
  1017a7:	89 ec                	mov    %ebp,%esp
  1017a9:	5d                   	pop    %ebp
  1017aa:	c3                   	ret    

001017ab <pic_enable>:

void
pic_enable(unsigned int irq) {
  1017ab:	55                   	push   %ebp
  1017ac:	89 e5                	mov    %esp,%ebp
  1017ae:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1017b4:	ba 01 00 00 00       	mov    $0x1,%edx
  1017b9:	88 c1                	mov    %al,%cl
  1017bb:	d3 e2                	shl    %cl,%edx
  1017bd:	89 d0                	mov    %edx,%eax
  1017bf:	98                   	cwtl   
  1017c0:	f7 d0                	not    %eax
  1017c2:	0f bf d0             	movswl %ax,%edx
  1017c5:	0f b7 05 50 b5 11 00 	movzwl 0x11b550,%eax
  1017cc:	98                   	cwtl   
  1017cd:	21 d0                	and    %edx,%eax
  1017cf:	98                   	cwtl   
  1017d0:	0f b7 c0             	movzwl %ax,%eax
  1017d3:	89 04 24             	mov    %eax,(%esp)
  1017d6:	e8 73 ff ff ff       	call   10174e <pic_setmask>
}
  1017db:	90                   	nop
  1017dc:	89 ec                	mov    %ebp,%esp
  1017de:	5d                   	pop    %ebp
  1017df:	c3                   	ret    

001017e0 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1017e0:	55                   	push   %ebp
  1017e1:	89 e5                	mov    %esp,%ebp
  1017e3:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017e6:	c7 05 6c e6 11 00 01 	movl   $0x1,0x11e66c
  1017ed:	00 00 00 
  1017f0:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1017f6:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017fa:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017fe:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101802:	ee                   	out    %al,(%dx)
}
  101803:	90                   	nop
  101804:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  10180a:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10180e:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101812:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101816:	ee                   	out    %al,(%dx)
}
  101817:	90                   	nop
  101818:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10181e:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101822:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101826:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10182a:	ee                   	out    %al,(%dx)
}
  10182b:	90                   	nop
  10182c:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101832:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101836:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10183a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10183e:	ee                   	out    %al,(%dx)
}
  10183f:	90                   	nop
  101840:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101846:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10184a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10184e:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101852:	ee                   	out    %al,(%dx)
}
  101853:	90                   	nop
  101854:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  10185a:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10185e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101862:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101866:	ee                   	out    %al,(%dx)
}
  101867:	90                   	nop
  101868:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  10186e:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101872:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101876:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10187a:	ee                   	out    %al,(%dx)
}
  10187b:	90                   	nop
  10187c:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101882:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101886:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10188a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10188e:	ee                   	out    %al,(%dx)
}
  10188f:	90                   	nop
  101890:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101896:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10189a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10189e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1018a2:	ee                   	out    %al,(%dx)
}
  1018a3:	90                   	nop
  1018a4:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1018aa:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018ae:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1018b2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1018b6:	ee                   	out    %al,(%dx)
}
  1018b7:	90                   	nop
  1018b8:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  1018be:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018c2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1018c6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1018ca:	ee                   	out    %al,(%dx)
}
  1018cb:	90                   	nop
  1018cc:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1018d2:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018d6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1018da:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1018de:	ee                   	out    %al,(%dx)
}
  1018df:	90                   	nop
  1018e0:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1018e6:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018ea:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1018ee:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1018f2:	ee                   	out    %al,(%dx)
}
  1018f3:	90                   	nop
  1018f4:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1018fa:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018fe:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101902:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101906:	ee                   	out    %al,(%dx)
}
  101907:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101908:	0f b7 05 50 b5 11 00 	movzwl 0x11b550,%eax
  10190f:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101914:	74 0f                	je     101925 <pic_init+0x145>
        pic_setmask(irq_mask);
  101916:	0f b7 05 50 b5 11 00 	movzwl 0x11b550,%eax
  10191d:	89 04 24             	mov    %eax,(%esp)
  101920:	e8 29 fe ff ff       	call   10174e <pic_setmask>
    }
}
  101925:	90                   	nop
  101926:	89 ec                	mov    %ebp,%esp
  101928:	5d                   	pop    %ebp
  101929:	c3                   	ret    

0010192a <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10192a:	55                   	push   %ebp
  10192b:	89 e5                	mov    %esp,%ebp
  10192d:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101930:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101937:	00 
  101938:	c7 04 24 e0 70 10 00 	movl   $0x1070e0,(%esp)
  10193f:	e8 1d ea ff ff       	call   100361 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101944:	c7 04 24 ea 70 10 00 	movl   $0x1070ea,(%esp)
  10194b:	e8 11 ea ff ff       	call   100361 <cprintf>
    panic("EOT: kernel seems ok.");
  101950:	c7 44 24 08 f8 70 10 	movl   $0x1070f8,0x8(%esp)
  101957:	00 
  101958:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  10195f:	00 
  101960:	c7 04 24 0e 71 10 00 	movl   $0x10710e,(%esp)
  101967:	e8 81 f3 ff ff       	call   100ced <__panic>

0010196c <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10196c:	55                   	push   %ebp
  10196d:	89 e5                	mov    %esp,%ebp
  10196f:	83 ec 10             	sub    $0x10,%esp
    //然后使用lidt加载IDT即可，指令格式与LGDT类似；至此完成了中断描述符表的初始化过程；

    // entry adders of ISR(Interrupt Service Routine)
    extern uintptr_t __vectors[];
    // setup the entries of ISR in IDT(Interrupt Description Table)
    int n=sizeof(idt)/sizeof(struct gatedesc);
  101972:	c7 45 f8 00 01 00 00 	movl   $0x100,-0x8(%ebp)
    for(int i=0;i<n;i++){
  101979:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101980:	e9 c4 00 00 00       	jmp    101a49 <idt_init+0xdd>
        trap: 1 for a trap (= exception) gate, 0 for an interrupt gate
        sel: 段选择器
        off: 偏移
        dpl: 特权级
        * */
        SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
  101985:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101988:	8b 04 85 e0 b5 11 00 	mov    0x11b5e0(,%eax,4),%eax
  10198f:	0f b7 d0             	movzwl %ax,%edx
  101992:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101995:	66 89 14 c5 80 e6 11 	mov    %dx,0x11e680(,%eax,8)
  10199c:	00 
  10199d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a0:	66 c7 04 c5 82 e6 11 	movw   $0x8,0x11e682(,%eax,8)
  1019a7:	00 08 00 
  1019aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ad:	0f b6 14 c5 84 e6 11 	movzbl 0x11e684(,%eax,8),%edx
  1019b4:	00 
  1019b5:	80 e2 e0             	and    $0xe0,%dl
  1019b8:	88 14 c5 84 e6 11 00 	mov    %dl,0x11e684(,%eax,8)
  1019bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019c2:	0f b6 14 c5 84 e6 11 	movzbl 0x11e684(,%eax,8),%edx
  1019c9:	00 
  1019ca:	80 e2 1f             	and    $0x1f,%dl
  1019cd:	88 14 c5 84 e6 11 00 	mov    %dl,0x11e684(,%eax,8)
  1019d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d7:	0f b6 14 c5 85 e6 11 	movzbl 0x11e685(,%eax,8),%edx
  1019de:	00 
  1019df:	80 e2 f0             	and    $0xf0,%dl
  1019e2:	80 ca 0e             	or     $0xe,%dl
  1019e5:	88 14 c5 85 e6 11 00 	mov    %dl,0x11e685(,%eax,8)
  1019ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ef:	0f b6 14 c5 85 e6 11 	movzbl 0x11e685(,%eax,8),%edx
  1019f6:	00 
  1019f7:	80 e2 ef             	and    $0xef,%dl
  1019fa:	88 14 c5 85 e6 11 00 	mov    %dl,0x11e685(,%eax,8)
  101a01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a04:	0f b6 14 c5 85 e6 11 	movzbl 0x11e685(,%eax,8),%edx
  101a0b:	00 
  101a0c:	80 e2 9f             	and    $0x9f,%dl
  101a0f:	88 14 c5 85 e6 11 00 	mov    %dl,0x11e685(,%eax,8)
  101a16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a19:	0f b6 14 c5 85 e6 11 	movzbl 0x11e685(,%eax,8),%edx
  101a20:	00 
  101a21:	80 ca 80             	or     $0x80,%dl
  101a24:	88 14 c5 85 e6 11 00 	mov    %dl,0x11e685(,%eax,8)
  101a2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a2e:	8b 04 85 e0 b5 11 00 	mov    0x11b5e0(,%eax,4),%eax
  101a35:	c1 e8 10             	shr    $0x10,%eax
  101a38:	0f b7 d0             	movzwl %ax,%edx
  101a3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a3e:	66 89 14 c5 86 e6 11 	mov    %dx,0x11e686(,%eax,8)
  101a45:	00 
    for(int i=0;i<n;i++){
  101a46:	ff 45 fc             	incl   -0x4(%ebp)
  101a49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a4c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  101a4f:	0f 8c 30 ff ff ff    	jl     101985 <idt_init+0x19>
    }
    //系统调用中断
    //而ucore的应用程序处于特权级３，需要采用｀int 0x80`指令操作（软中断）来发出系统调用请求，并要能实现从特权级３到特权级０的转换
    //所以系统调用中断(T_SYSCALL)所对应的中断门描述符中的特权级（DPL）需要设置为３。
    SETGATE(idt[T_SYSCALL],1,GD_KTEXT,__vectors[T_SYSCALL],DPL_USER);
  101a55:	a1 e0 b7 11 00       	mov    0x11b7e0,%eax
  101a5a:	0f b7 c0             	movzwl %ax,%eax
  101a5d:	66 a3 80 ea 11 00    	mov    %ax,0x11ea80
  101a63:	66 c7 05 82 ea 11 00 	movw   $0x8,0x11ea82
  101a6a:	08 00 
  101a6c:	0f b6 05 84 ea 11 00 	movzbl 0x11ea84,%eax
  101a73:	24 e0                	and    $0xe0,%al
  101a75:	a2 84 ea 11 00       	mov    %al,0x11ea84
  101a7a:	0f b6 05 84 ea 11 00 	movzbl 0x11ea84,%eax
  101a81:	24 1f                	and    $0x1f,%al
  101a83:	a2 84 ea 11 00       	mov    %al,0x11ea84
  101a88:	0f b6 05 85 ea 11 00 	movzbl 0x11ea85,%eax
  101a8f:	0c 0f                	or     $0xf,%al
  101a91:	a2 85 ea 11 00       	mov    %al,0x11ea85
  101a96:	0f b6 05 85 ea 11 00 	movzbl 0x11ea85,%eax
  101a9d:	24 ef                	and    $0xef,%al
  101a9f:	a2 85 ea 11 00       	mov    %al,0x11ea85
  101aa4:	0f b6 05 85 ea 11 00 	movzbl 0x11ea85,%eax
  101aab:	0c 60                	or     $0x60,%al
  101aad:	a2 85 ea 11 00       	mov    %al,0x11ea85
  101ab2:	0f b6 05 85 ea 11 00 	movzbl 0x11ea85,%eax
  101ab9:	0c 80                	or     $0x80,%al
  101abb:	a2 85 ea 11 00       	mov    %al,0x11ea85
  101ac0:	a1 e0 b7 11 00       	mov    0x11b7e0,%eax
  101ac5:	c1 e8 10             	shr    $0x10,%eax
  101ac8:	0f b7 c0             	movzwl %ax,%eax
  101acb:	66 a3 86 ea 11 00    	mov    %ax,0x11ea86
    SETGATE(idt[T_SWITCH_TOK],0,GD_KTEXT,__vectors[T_SWITCH_TOK],DPL_USER);
  101ad1:	a1 c4 b7 11 00       	mov    0x11b7c4,%eax
  101ad6:	0f b7 c0             	movzwl %ax,%eax
  101ad9:	66 a3 48 ea 11 00    	mov    %ax,0x11ea48
  101adf:	66 c7 05 4a ea 11 00 	movw   $0x8,0x11ea4a
  101ae6:	08 00 
  101ae8:	0f b6 05 4c ea 11 00 	movzbl 0x11ea4c,%eax
  101aef:	24 e0                	and    $0xe0,%al
  101af1:	a2 4c ea 11 00       	mov    %al,0x11ea4c
  101af6:	0f b6 05 4c ea 11 00 	movzbl 0x11ea4c,%eax
  101afd:	24 1f                	and    $0x1f,%al
  101aff:	a2 4c ea 11 00       	mov    %al,0x11ea4c
  101b04:	0f b6 05 4d ea 11 00 	movzbl 0x11ea4d,%eax
  101b0b:	24 f0                	and    $0xf0,%al
  101b0d:	0c 0e                	or     $0xe,%al
  101b0f:	a2 4d ea 11 00       	mov    %al,0x11ea4d
  101b14:	0f b6 05 4d ea 11 00 	movzbl 0x11ea4d,%eax
  101b1b:	24 ef                	and    $0xef,%al
  101b1d:	a2 4d ea 11 00       	mov    %al,0x11ea4d
  101b22:	0f b6 05 4d ea 11 00 	movzbl 0x11ea4d,%eax
  101b29:	0c 60                	or     $0x60,%al
  101b2b:	a2 4d ea 11 00       	mov    %al,0x11ea4d
  101b30:	0f b6 05 4d ea 11 00 	movzbl 0x11ea4d,%eax
  101b37:	0c 80                	or     $0x80,%al
  101b39:	a2 4d ea 11 00       	mov    %al,0x11ea4d
  101b3e:	a1 c4 b7 11 00       	mov    0x11b7c4,%eax
  101b43:	c1 e8 10             	shr    $0x10,%eax
  101b46:	0f b7 c0             	movzwl %ax,%eax
  101b49:	66 a3 4e ea 11 00    	mov    %ax,0x11ea4e
  101b4f:	c7 45 f4 60 b5 11 00 	movl   $0x11b560,-0xc(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b59:	0f 01 18             	lidtl  (%eax)
}
  101b5c:	90                   	nop
    // load the IDT
    lidt(&idt_pd);
}
  101b5d:	90                   	nop
  101b5e:	89 ec                	mov    %ebp,%esp
  101b60:	5d                   	pop    %ebp
  101b61:	c3                   	ret    

00101b62 <trapname>:

static const char *
trapname(int trapno) {
  101b62:	55                   	push   %ebp
  101b63:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101b65:	8b 45 08             	mov    0x8(%ebp),%eax
  101b68:	83 f8 13             	cmp    $0x13,%eax
  101b6b:	77 0c                	ja     101b79 <trapname+0x17>
        return excnames[trapno];
  101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b70:	8b 04 85 60 74 10 00 	mov    0x107460(,%eax,4),%eax
  101b77:	eb 18                	jmp    101b91 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101b79:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b7d:	7e 0d                	jle    101b8c <trapname+0x2a>
  101b7f:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b83:	7f 07                	jg     101b8c <trapname+0x2a>
        return "Hardware Interrupt";
  101b85:	b8 1f 71 10 00       	mov    $0x10711f,%eax
  101b8a:	eb 05                	jmp    101b91 <trapname+0x2f>
    }
    return "(unknown trap)";
  101b8c:	b8 32 71 10 00       	mov    $0x107132,%eax
}
  101b91:	5d                   	pop    %ebp
  101b92:	c3                   	ret    

00101b93 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101b93:	55                   	push   %ebp
  101b94:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b96:	8b 45 08             	mov    0x8(%ebp),%eax
  101b99:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b9d:	83 f8 08             	cmp    $0x8,%eax
  101ba0:	0f 94 c0             	sete   %al
  101ba3:	0f b6 c0             	movzbl %al,%eax
}
  101ba6:	5d                   	pop    %ebp
  101ba7:	c3                   	ret    

00101ba8 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101ba8:	55                   	push   %ebp
  101ba9:	89 e5                	mov    %esp,%ebp
  101bab:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101bae:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb5:	c7 04 24 73 71 10 00 	movl   $0x107173,(%esp)
  101bbc:	e8 a0 e7 ff ff       	call   100361 <cprintf>
    print_regs(&tf->tf_regs);
  101bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc4:	89 04 24             	mov    %eax,(%esp)
  101bc7:	e8 8f 01 00 00       	call   101d5b <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  101bcf:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101bd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd7:	c7 04 24 84 71 10 00 	movl   $0x107184,(%esp)
  101bde:	e8 7e e7 ff ff       	call   100361 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101be3:	8b 45 08             	mov    0x8(%ebp),%eax
  101be6:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101bea:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bee:	c7 04 24 97 71 10 00 	movl   $0x107197,(%esp)
  101bf5:	e8 67 e7 ff ff       	call   100361 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfd:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101c01:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c05:	c7 04 24 aa 71 10 00 	movl   $0x1071aa,(%esp)
  101c0c:	e8 50 e7 ff ff       	call   100361 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101c11:	8b 45 08             	mov    0x8(%ebp),%eax
  101c14:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101c18:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c1c:	c7 04 24 bd 71 10 00 	movl   $0x1071bd,(%esp)
  101c23:	e8 39 e7 ff ff       	call   100361 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101c28:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2b:	8b 40 30             	mov    0x30(%eax),%eax
  101c2e:	89 04 24             	mov    %eax,(%esp)
  101c31:	e8 2c ff ff ff       	call   101b62 <trapname>
  101c36:	8b 55 08             	mov    0x8(%ebp),%edx
  101c39:	8b 52 30             	mov    0x30(%edx),%edx
  101c3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  101c40:	89 54 24 04          	mov    %edx,0x4(%esp)
  101c44:	c7 04 24 d0 71 10 00 	movl   $0x1071d0,(%esp)
  101c4b:	e8 11 e7 ff ff       	call   100361 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101c50:	8b 45 08             	mov    0x8(%ebp),%eax
  101c53:	8b 40 34             	mov    0x34(%eax),%eax
  101c56:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5a:	c7 04 24 e2 71 10 00 	movl   $0x1071e2,(%esp)
  101c61:	e8 fb e6 ff ff       	call   100361 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101c66:	8b 45 08             	mov    0x8(%ebp),%eax
  101c69:	8b 40 38             	mov    0x38(%eax),%eax
  101c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c70:	c7 04 24 f1 71 10 00 	movl   $0x1071f1,(%esp)
  101c77:	e8 e5 e6 ff ff       	call   100361 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c83:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c87:	c7 04 24 00 72 10 00 	movl   $0x107200,(%esp)
  101c8e:	e8 ce e6 ff ff       	call   100361 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c93:	8b 45 08             	mov    0x8(%ebp),%eax
  101c96:	8b 40 40             	mov    0x40(%eax),%eax
  101c99:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9d:	c7 04 24 13 72 10 00 	movl   $0x107213,(%esp)
  101ca4:	e8 b8 e6 ff ff       	call   100361 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ca9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101cb0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101cb7:	eb 3d                	jmp    101cf6 <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbc:	8b 50 40             	mov    0x40(%eax),%edx
  101cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101cc2:	21 d0                	and    %edx,%eax
  101cc4:	85 c0                	test   %eax,%eax
  101cc6:	74 28                	je     101cf0 <print_trapframe+0x148>
  101cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ccb:	8b 04 85 80 b5 11 00 	mov    0x11b580(,%eax,4),%eax
  101cd2:	85 c0                	test   %eax,%eax
  101cd4:	74 1a                	je     101cf0 <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
  101cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cd9:	8b 04 85 80 b5 11 00 	mov    0x11b580(,%eax,4),%eax
  101ce0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce4:	c7 04 24 22 72 10 00 	movl   $0x107222,(%esp)
  101ceb:	e8 71 e6 ff ff       	call   100361 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101cf0:	ff 45 f4             	incl   -0xc(%ebp)
  101cf3:	d1 65 f0             	shll   -0x10(%ebp)
  101cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cf9:	83 f8 17             	cmp    $0x17,%eax
  101cfc:	76 bb                	jbe    101cb9 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  101d01:	8b 40 40             	mov    0x40(%eax),%eax
  101d04:	c1 e8 0c             	shr    $0xc,%eax
  101d07:	83 e0 03             	and    $0x3,%eax
  101d0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d0e:	c7 04 24 26 72 10 00 	movl   $0x107226,(%esp)
  101d15:	e8 47 e6 ff ff       	call   100361 <cprintf>

    if (!trap_in_kernel(tf)) {
  101d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1d:	89 04 24             	mov    %eax,(%esp)
  101d20:	e8 6e fe ff ff       	call   101b93 <trap_in_kernel>
  101d25:	85 c0                	test   %eax,%eax
  101d27:	75 2d                	jne    101d56 <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101d29:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2c:	8b 40 44             	mov    0x44(%eax),%eax
  101d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d33:	c7 04 24 2f 72 10 00 	movl   $0x10722f,(%esp)
  101d3a:	e8 22 e6 ff ff       	call   100361 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d42:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101d46:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d4a:	c7 04 24 3e 72 10 00 	movl   $0x10723e,(%esp)
  101d51:	e8 0b e6 ff ff       	call   100361 <cprintf>
    }
}
  101d56:	90                   	nop
  101d57:	89 ec                	mov    %ebp,%esp
  101d59:	5d                   	pop    %ebp
  101d5a:	c3                   	ret    

00101d5b <print_regs>:

void
print_regs(struct pushregs *regs) {
  101d5b:	55                   	push   %ebp
  101d5c:	89 e5                	mov    %esp,%ebp
  101d5e:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101d61:	8b 45 08             	mov    0x8(%ebp),%eax
  101d64:	8b 00                	mov    (%eax),%eax
  101d66:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d6a:	c7 04 24 51 72 10 00 	movl   $0x107251,(%esp)
  101d71:	e8 eb e5 ff ff       	call   100361 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101d76:	8b 45 08             	mov    0x8(%ebp),%eax
  101d79:	8b 40 04             	mov    0x4(%eax),%eax
  101d7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d80:	c7 04 24 60 72 10 00 	movl   $0x107260,(%esp)
  101d87:	e8 d5 e5 ff ff       	call   100361 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d8f:	8b 40 08             	mov    0x8(%eax),%eax
  101d92:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d96:	c7 04 24 6f 72 10 00 	movl   $0x10726f,(%esp)
  101d9d:	e8 bf e5 ff ff       	call   100361 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101da2:	8b 45 08             	mov    0x8(%ebp),%eax
  101da5:	8b 40 0c             	mov    0xc(%eax),%eax
  101da8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dac:	c7 04 24 7e 72 10 00 	movl   $0x10727e,(%esp)
  101db3:	e8 a9 e5 ff ff       	call   100361 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101db8:	8b 45 08             	mov    0x8(%ebp),%eax
  101dbb:	8b 40 10             	mov    0x10(%eax),%eax
  101dbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dc2:	c7 04 24 8d 72 10 00 	movl   $0x10728d,(%esp)
  101dc9:	e8 93 e5 ff ff       	call   100361 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101dce:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd1:	8b 40 14             	mov    0x14(%eax),%eax
  101dd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dd8:	c7 04 24 9c 72 10 00 	movl   $0x10729c,(%esp)
  101ddf:	e8 7d e5 ff ff       	call   100361 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101de4:	8b 45 08             	mov    0x8(%ebp),%eax
  101de7:	8b 40 18             	mov    0x18(%eax),%eax
  101dea:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dee:	c7 04 24 ab 72 10 00 	movl   $0x1072ab,(%esp)
  101df5:	e8 67 e5 ff ff       	call   100361 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  101dfd:	8b 40 1c             	mov    0x1c(%eax),%eax
  101e00:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e04:	c7 04 24 ba 72 10 00 	movl   $0x1072ba,(%esp)
  101e0b:	e8 51 e5 ff ff       	call   100361 <cprintf>
}
  101e10:	90                   	nop
  101e11:	89 ec                	mov    %ebp,%esp
  101e13:	5d                   	pop    %ebp
  101e14:	c3                   	ret    

00101e15 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101e15:	55                   	push   %ebp
  101e16:	89 e5                	mov    %esp,%ebp
  101e18:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e1e:	8b 40 30             	mov    0x30(%eax),%eax
  101e21:	83 f8 79             	cmp    $0x79,%eax
  101e24:	0f 84 54 01 00 00    	je     101f7e <trap_dispatch+0x169>
  101e2a:	83 f8 79             	cmp    $0x79,%eax
  101e2d:	0f 87 ba 01 00 00    	ja     101fed <trap_dispatch+0x1d8>
  101e33:	83 f8 78             	cmp    $0x78,%eax
  101e36:	0f 84 d0 00 00 00    	je     101f0c <trap_dispatch+0xf7>
  101e3c:	83 f8 78             	cmp    $0x78,%eax
  101e3f:	0f 87 a8 01 00 00    	ja     101fed <trap_dispatch+0x1d8>
  101e45:	83 f8 2f             	cmp    $0x2f,%eax
  101e48:	0f 87 9f 01 00 00    	ja     101fed <trap_dispatch+0x1d8>
  101e4e:	83 f8 2e             	cmp    $0x2e,%eax
  101e51:	0f 83 cb 01 00 00    	jae    102022 <trap_dispatch+0x20d>
  101e57:	83 f8 24             	cmp    $0x24,%eax
  101e5a:	74 5e                	je     101eba <trap_dispatch+0xa5>
  101e5c:	83 f8 24             	cmp    $0x24,%eax
  101e5f:	0f 87 88 01 00 00    	ja     101fed <trap_dispatch+0x1d8>
  101e65:	83 f8 20             	cmp    $0x20,%eax
  101e68:	74 0a                	je     101e74 <trap_dispatch+0x5f>
  101e6a:	83 f8 21             	cmp    $0x21,%eax
  101e6d:	74 74                	je     101ee3 <trap_dispatch+0xce>
  101e6f:	e9 79 01 00 00       	jmp    101fed <trap_dispatch+0x1d8>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101e74:	a1 24 e4 11 00       	mov    0x11e424,%eax
  101e79:	40                   	inc    %eax
  101e7a:	a3 24 e4 11 00       	mov    %eax,0x11e424
        if(ticks%TICK_NUM==0){
  101e7f:	8b 0d 24 e4 11 00    	mov    0x11e424,%ecx
  101e85:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101e8a:	89 c8                	mov    %ecx,%eax
  101e8c:	f7 e2                	mul    %edx
  101e8e:	c1 ea 05             	shr    $0x5,%edx
  101e91:	89 d0                	mov    %edx,%eax
  101e93:	c1 e0 02             	shl    $0x2,%eax
  101e96:	01 d0                	add    %edx,%eax
  101e98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101e9f:	01 d0                	add    %edx,%eax
  101ea1:	c1 e0 02             	shl    $0x2,%eax
  101ea4:	29 c1                	sub    %eax,%ecx
  101ea6:	89 ca                	mov    %ecx,%edx
  101ea8:	85 d2                	test   %edx,%edx
  101eaa:	0f 85 75 01 00 00    	jne    102025 <trap_dispatch+0x210>
            //print ticks info
            print_ticks();
  101eb0:	e8 75 fa ff ff       	call   10192a <print_ticks>
        }
        break;
  101eb5:	e9 6b 01 00 00       	jmp    102025 <trap_dispatch+0x210>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101eba:	e8 0e f8 ff ff       	call   1016cd <cons_getc>
  101ebf:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ec2:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101ec6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101eca:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ece:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ed2:	c7 04 24 c9 72 10 00 	movl   $0x1072c9,(%esp)
  101ed9:	e8 83 e4 ff ff       	call   100361 <cprintf>
        break;
  101ede:	e9 49 01 00 00       	jmp    10202c <trap_dispatch+0x217>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101ee3:	e8 e5 f7 ff ff       	call   1016cd <cons_getc>
  101ee8:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101eeb:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101eef:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ef3:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101efb:	c7 04 24 db 72 10 00 	movl   $0x1072db,(%esp)
  101f02:	e8 5a e4 ff ff       	call   100361 <cprintf>
        break;
  101f07:	e9 20 01 00 00       	jmp    10202c <trap_dispatch+0x217>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f0f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f13:	83 f8 1b             	cmp    $0x1b,%eax
  101f16:	0f 84 0c 01 00 00    	je     102028 <trap_dispatch+0x213>
            //为了使得程序在低CPL的情况下仍然能够使用IO，需要将eflags中对应的IOPL位置成表示用户态的
            //if CPL > IOPL, then cpu will generate a general protection.
            tf->tf_eflags |= FL_IOPL_MASK;
  101f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f1f:	8b 40 40             	mov    0x40(%eax),%eax
  101f22:	0d 00 30 00 00       	or     $0x3000,%eax
  101f27:	89 c2                	mov    %eax,%edx
  101f29:	8b 45 08             	mov    0x8(%ebp),%eax
  101f2c:	89 50 40             	mov    %edx,0x40(%eax)
            //iret认定在发生中断的时候是否发生了PL的切换，是取决于CPL和最终跳转回的地址的cs选择子对应的段描述符处的CPL（也就是发生中断前的CPL）是否相等来决定的
            //因此将保存在trapframe中的原先的cs修改成指向用户态描述子的USER_CS
            tf->tf_cs = USER_CS;
  101f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f32:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            //为了使得中断返回之后能够正常访问数据，将其他的段选择子都修改为USER_DS
            tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = USER_DS;
  101f38:	8b 45 08             	mov    0x8(%ebp),%eax
  101f3b:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  101f41:	8b 45 08             	mov    0x8(%ebp),%eax
  101f44:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101f48:	8b 45 08             	mov    0x8(%ebp),%eax
  101f4b:	66 89 50 48          	mov    %dx,0x48(%eax)
  101f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f52:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101f56:	8b 45 08             	mov    0x8(%ebp),%eax
  101f59:	66 89 50 20          	mov    %dx,0x20(%eax)
  101f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101f60:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101f64:	8b 45 08             	mov    0x8(%ebp),%eax
  101f67:	66 89 50 28          	mov    %dx,0x28(%eax)
  101f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101f6e:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f72:	8b 45 08             	mov    0x8(%ebp),%eax
  101f75:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        }
        break;
  101f79:	e9 aa 00 00 00       	jmp    102028 <trap_dispatch+0x213>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f81:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f85:	83 f8 08             	cmp    $0x8,%eax
  101f88:	0f 84 9d 00 00 00    	je     10202b <trap_dispatch+0x216>
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f91:	8b 40 40             	mov    0x40(%eax),%eax
  101f94:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101f99:	89 c2                	mov    %eax,%edx
  101f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  101f9e:	89 50 40             	mov    %edx,0x40(%eax)
            tf->tf_cs = KERNEL_CS;
  101fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  101fa4:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = KERNEL_DS;
  101faa:	8b 45 08             	mov    0x8(%ebp),%eax
  101fad:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
  101fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  101fb6:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101fba:	8b 45 08             	mov    0x8(%ebp),%eax
  101fbd:	66 89 50 48          	mov    %dx,0x48(%eax)
  101fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  101fc4:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  101fcb:	66 89 50 20          	mov    %dx,0x20(%eax)
  101fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  101fd2:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  101fd9:	66 89 50 28          	mov    %dx,0x28(%eax)
  101fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  101fe0:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  101fe7:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        }
        //panic("T_SWITCH_** ??\n");
        break;
  101feb:	eb 3e                	jmp    10202b <trap_dispatch+0x216>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101fed:	8b 45 08             	mov    0x8(%ebp),%eax
  101ff0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ff4:	83 e0 03             	and    $0x3,%eax
  101ff7:	85 c0                	test   %eax,%eax
  101ff9:	75 31                	jne    10202c <trap_dispatch+0x217>
            print_trapframe(tf);
  101ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  101ffe:	89 04 24             	mov    %eax,(%esp)
  102001:	e8 a2 fb ff ff       	call   101ba8 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  102006:	c7 44 24 08 ea 72 10 	movl   $0x1072ea,0x8(%esp)
  10200d:	00 
  10200e:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  102015:	00 
  102016:	c7 04 24 0e 71 10 00 	movl   $0x10710e,(%esp)
  10201d:	e8 cb ec ff ff       	call   100ced <__panic>
        break;
  102022:	90                   	nop
  102023:	eb 07                	jmp    10202c <trap_dispatch+0x217>
        break;
  102025:	90                   	nop
  102026:	eb 04                	jmp    10202c <trap_dispatch+0x217>
        break;
  102028:	90                   	nop
  102029:	eb 01                	jmp    10202c <trap_dispatch+0x217>
        break;
  10202b:	90                   	nop
        }
    }
}
  10202c:	90                   	nop
  10202d:	89 ec                	mov    %ebp,%esp
  10202f:	5d                   	pop    %ebp
  102030:	c3                   	ret    

00102031 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  102031:	55                   	push   %ebp
  102032:	89 e5                	mov    %esp,%ebp
  102034:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  102037:	8b 45 08             	mov    0x8(%ebp),%eax
  10203a:	89 04 24             	mov    %eax,(%esp)
  10203d:	e8 d3 fd ff ff       	call   101e15 <trap_dispatch>
}
  102042:	90                   	nop
  102043:	89 ec                	mov    %ebp,%esp
  102045:	5d                   	pop    %ebp
  102046:	c3                   	ret    

00102047 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102047:	1e                   	push   %ds
    pushl %es
  102048:	06                   	push   %es
    pushl %fs
  102049:	0f a0                	push   %fs
    pushl %gs
  10204b:	0f a8                	push   %gs
    pushal
  10204d:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  10204e:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102053:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102055:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102057:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102058:	e8 d4 ff ff ff       	call   102031 <trap>

    # pop the pushed stack pointer
    popl %esp
  10205d:	5c                   	pop    %esp

0010205e <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  10205e:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  10205f:	0f a9                	pop    %gs
    popl %fs
  102061:	0f a1                	pop    %fs
    popl %es
  102063:	07                   	pop    %es
    popl %ds
  102064:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102065:	83 c4 08             	add    $0x8,%esp
    iret
  102068:	cf                   	iret   

00102069 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  102069:	6a 00                	push   $0x0
  pushl $0
  10206b:	6a 00                	push   $0x0
  jmp __alltraps
  10206d:	e9 d5 ff ff ff       	jmp    102047 <__alltraps>

00102072 <vector1>:
.globl vector1
vector1:
  pushl $0
  102072:	6a 00                	push   $0x0
  pushl $1
  102074:	6a 01                	push   $0x1
  jmp __alltraps
  102076:	e9 cc ff ff ff       	jmp    102047 <__alltraps>

0010207b <vector2>:
.globl vector2
vector2:
  pushl $0
  10207b:	6a 00                	push   $0x0
  pushl $2
  10207d:	6a 02                	push   $0x2
  jmp __alltraps
  10207f:	e9 c3 ff ff ff       	jmp    102047 <__alltraps>

00102084 <vector3>:
.globl vector3
vector3:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $3
  102086:	6a 03                	push   $0x3
  jmp __alltraps
  102088:	e9 ba ff ff ff       	jmp    102047 <__alltraps>

0010208d <vector4>:
.globl vector4
vector4:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $4
  10208f:	6a 04                	push   $0x4
  jmp __alltraps
  102091:	e9 b1 ff ff ff       	jmp    102047 <__alltraps>

00102096 <vector5>:
.globl vector5
vector5:
  pushl $0
  102096:	6a 00                	push   $0x0
  pushl $5
  102098:	6a 05                	push   $0x5
  jmp __alltraps
  10209a:	e9 a8 ff ff ff       	jmp    102047 <__alltraps>

0010209f <vector6>:
.globl vector6
vector6:
  pushl $0
  10209f:	6a 00                	push   $0x0
  pushl $6
  1020a1:	6a 06                	push   $0x6
  jmp __alltraps
  1020a3:	e9 9f ff ff ff       	jmp    102047 <__alltraps>

001020a8 <vector7>:
.globl vector7
vector7:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $7
  1020aa:	6a 07                	push   $0x7
  jmp __alltraps
  1020ac:	e9 96 ff ff ff       	jmp    102047 <__alltraps>

001020b1 <vector8>:
.globl vector8
vector8:
  pushl $8
  1020b1:	6a 08                	push   $0x8
  jmp __alltraps
  1020b3:	e9 8f ff ff ff       	jmp    102047 <__alltraps>

001020b8 <vector9>:
.globl vector9
vector9:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $9
  1020ba:	6a 09                	push   $0x9
  jmp __alltraps
  1020bc:	e9 86 ff ff ff       	jmp    102047 <__alltraps>

001020c1 <vector10>:
.globl vector10
vector10:
  pushl $10
  1020c1:	6a 0a                	push   $0xa
  jmp __alltraps
  1020c3:	e9 7f ff ff ff       	jmp    102047 <__alltraps>

001020c8 <vector11>:
.globl vector11
vector11:
  pushl $11
  1020c8:	6a 0b                	push   $0xb
  jmp __alltraps
  1020ca:	e9 78 ff ff ff       	jmp    102047 <__alltraps>

001020cf <vector12>:
.globl vector12
vector12:
  pushl $12
  1020cf:	6a 0c                	push   $0xc
  jmp __alltraps
  1020d1:	e9 71 ff ff ff       	jmp    102047 <__alltraps>

001020d6 <vector13>:
.globl vector13
vector13:
  pushl $13
  1020d6:	6a 0d                	push   $0xd
  jmp __alltraps
  1020d8:	e9 6a ff ff ff       	jmp    102047 <__alltraps>

001020dd <vector14>:
.globl vector14
vector14:
  pushl $14
  1020dd:	6a 0e                	push   $0xe
  jmp __alltraps
  1020df:	e9 63 ff ff ff       	jmp    102047 <__alltraps>

001020e4 <vector15>:
.globl vector15
vector15:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $15
  1020e6:	6a 0f                	push   $0xf
  jmp __alltraps
  1020e8:	e9 5a ff ff ff       	jmp    102047 <__alltraps>

001020ed <vector16>:
.globl vector16
vector16:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $16
  1020ef:	6a 10                	push   $0x10
  jmp __alltraps
  1020f1:	e9 51 ff ff ff       	jmp    102047 <__alltraps>

001020f6 <vector17>:
.globl vector17
vector17:
  pushl $17
  1020f6:	6a 11                	push   $0x11
  jmp __alltraps
  1020f8:	e9 4a ff ff ff       	jmp    102047 <__alltraps>

001020fd <vector18>:
.globl vector18
vector18:
  pushl $0
  1020fd:	6a 00                	push   $0x0
  pushl $18
  1020ff:	6a 12                	push   $0x12
  jmp __alltraps
  102101:	e9 41 ff ff ff       	jmp    102047 <__alltraps>

00102106 <vector19>:
.globl vector19
vector19:
  pushl $0
  102106:	6a 00                	push   $0x0
  pushl $19
  102108:	6a 13                	push   $0x13
  jmp __alltraps
  10210a:	e9 38 ff ff ff       	jmp    102047 <__alltraps>

0010210f <vector20>:
.globl vector20
vector20:
  pushl $0
  10210f:	6a 00                	push   $0x0
  pushl $20
  102111:	6a 14                	push   $0x14
  jmp __alltraps
  102113:	e9 2f ff ff ff       	jmp    102047 <__alltraps>

00102118 <vector21>:
.globl vector21
vector21:
  pushl $0
  102118:	6a 00                	push   $0x0
  pushl $21
  10211a:	6a 15                	push   $0x15
  jmp __alltraps
  10211c:	e9 26 ff ff ff       	jmp    102047 <__alltraps>

00102121 <vector22>:
.globl vector22
vector22:
  pushl $0
  102121:	6a 00                	push   $0x0
  pushl $22
  102123:	6a 16                	push   $0x16
  jmp __alltraps
  102125:	e9 1d ff ff ff       	jmp    102047 <__alltraps>

0010212a <vector23>:
.globl vector23
vector23:
  pushl $0
  10212a:	6a 00                	push   $0x0
  pushl $23
  10212c:	6a 17                	push   $0x17
  jmp __alltraps
  10212e:	e9 14 ff ff ff       	jmp    102047 <__alltraps>

00102133 <vector24>:
.globl vector24
vector24:
  pushl $0
  102133:	6a 00                	push   $0x0
  pushl $24
  102135:	6a 18                	push   $0x18
  jmp __alltraps
  102137:	e9 0b ff ff ff       	jmp    102047 <__alltraps>

0010213c <vector25>:
.globl vector25
vector25:
  pushl $0
  10213c:	6a 00                	push   $0x0
  pushl $25
  10213e:	6a 19                	push   $0x19
  jmp __alltraps
  102140:	e9 02 ff ff ff       	jmp    102047 <__alltraps>

00102145 <vector26>:
.globl vector26
vector26:
  pushl $0
  102145:	6a 00                	push   $0x0
  pushl $26
  102147:	6a 1a                	push   $0x1a
  jmp __alltraps
  102149:	e9 f9 fe ff ff       	jmp    102047 <__alltraps>

0010214e <vector27>:
.globl vector27
vector27:
  pushl $0
  10214e:	6a 00                	push   $0x0
  pushl $27
  102150:	6a 1b                	push   $0x1b
  jmp __alltraps
  102152:	e9 f0 fe ff ff       	jmp    102047 <__alltraps>

00102157 <vector28>:
.globl vector28
vector28:
  pushl $0
  102157:	6a 00                	push   $0x0
  pushl $28
  102159:	6a 1c                	push   $0x1c
  jmp __alltraps
  10215b:	e9 e7 fe ff ff       	jmp    102047 <__alltraps>

00102160 <vector29>:
.globl vector29
vector29:
  pushl $0
  102160:	6a 00                	push   $0x0
  pushl $29
  102162:	6a 1d                	push   $0x1d
  jmp __alltraps
  102164:	e9 de fe ff ff       	jmp    102047 <__alltraps>

00102169 <vector30>:
.globl vector30
vector30:
  pushl $0
  102169:	6a 00                	push   $0x0
  pushl $30
  10216b:	6a 1e                	push   $0x1e
  jmp __alltraps
  10216d:	e9 d5 fe ff ff       	jmp    102047 <__alltraps>

00102172 <vector31>:
.globl vector31
vector31:
  pushl $0
  102172:	6a 00                	push   $0x0
  pushl $31
  102174:	6a 1f                	push   $0x1f
  jmp __alltraps
  102176:	e9 cc fe ff ff       	jmp    102047 <__alltraps>

0010217b <vector32>:
.globl vector32
vector32:
  pushl $0
  10217b:	6a 00                	push   $0x0
  pushl $32
  10217d:	6a 20                	push   $0x20
  jmp __alltraps
  10217f:	e9 c3 fe ff ff       	jmp    102047 <__alltraps>

00102184 <vector33>:
.globl vector33
vector33:
  pushl $0
  102184:	6a 00                	push   $0x0
  pushl $33
  102186:	6a 21                	push   $0x21
  jmp __alltraps
  102188:	e9 ba fe ff ff       	jmp    102047 <__alltraps>

0010218d <vector34>:
.globl vector34
vector34:
  pushl $0
  10218d:	6a 00                	push   $0x0
  pushl $34
  10218f:	6a 22                	push   $0x22
  jmp __alltraps
  102191:	e9 b1 fe ff ff       	jmp    102047 <__alltraps>

00102196 <vector35>:
.globl vector35
vector35:
  pushl $0
  102196:	6a 00                	push   $0x0
  pushl $35
  102198:	6a 23                	push   $0x23
  jmp __alltraps
  10219a:	e9 a8 fe ff ff       	jmp    102047 <__alltraps>

0010219f <vector36>:
.globl vector36
vector36:
  pushl $0
  10219f:	6a 00                	push   $0x0
  pushl $36
  1021a1:	6a 24                	push   $0x24
  jmp __alltraps
  1021a3:	e9 9f fe ff ff       	jmp    102047 <__alltraps>

001021a8 <vector37>:
.globl vector37
vector37:
  pushl $0
  1021a8:	6a 00                	push   $0x0
  pushl $37
  1021aa:	6a 25                	push   $0x25
  jmp __alltraps
  1021ac:	e9 96 fe ff ff       	jmp    102047 <__alltraps>

001021b1 <vector38>:
.globl vector38
vector38:
  pushl $0
  1021b1:	6a 00                	push   $0x0
  pushl $38
  1021b3:	6a 26                	push   $0x26
  jmp __alltraps
  1021b5:	e9 8d fe ff ff       	jmp    102047 <__alltraps>

001021ba <vector39>:
.globl vector39
vector39:
  pushl $0
  1021ba:	6a 00                	push   $0x0
  pushl $39
  1021bc:	6a 27                	push   $0x27
  jmp __alltraps
  1021be:	e9 84 fe ff ff       	jmp    102047 <__alltraps>

001021c3 <vector40>:
.globl vector40
vector40:
  pushl $0
  1021c3:	6a 00                	push   $0x0
  pushl $40
  1021c5:	6a 28                	push   $0x28
  jmp __alltraps
  1021c7:	e9 7b fe ff ff       	jmp    102047 <__alltraps>

001021cc <vector41>:
.globl vector41
vector41:
  pushl $0
  1021cc:	6a 00                	push   $0x0
  pushl $41
  1021ce:	6a 29                	push   $0x29
  jmp __alltraps
  1021d0:	e9 72 fe ff ff       	jmp    102047 <__alltraps>

001021d5 <vector42>:
.globl vector42
vector42:
  pushl $0
  1021d5:	6a 00                	push   $0x0
  pushl $42
  1021d7:	6a 2a                	push   $0x2a
  jmp __alltraps
  1021d9:	e9 69 fe ff ff       	jmp    102047 <__alltraps>

001021de <vector43>:
.globl vector43
vector43:
  pushl $0
  1021de:	6a 00                	push   $0x0
  pushl $43
  1021e0:	6a 2b                	push   $0x2b
  jmp __alltraps
  1021e2:	e9 60 fe ff ff       	jmp    102047 <__alltraps>

001021e7 <vector44>:
.globl vector44
vector44:
  pushl $0
  1021e7:	6a 00                	push   $0x0
  pushl $44
  1021e9:	6a 2c                	push   $0x2c
  jmp __alltraps
  1021eb:	e9 57 fe ff ff       	jmp    102047 <__alltraps>

001021f0 <vector45>:
.globl vector45
vector45:
  pushl $0
  1021f0:	6a 00                	push   $0x0
  pushl $45
  1021f2:	6a 2d                	push   $0x2d
  jmp __alltraps
  1021f4:	e9 4e fe ff ff       	jmp    102047 <__alltraps>

001021f9 <vector46>:
.globl vector46
vector46:
  pushl $0
  1021f9:	6a 00                	push   $0x0
  pushl $46
  1021fb:	6a 2e                	push   $0x2e
  jmp __alltraps
  1021fd:	e9 45 fe ff ff       	jmp    102047 <__alltraps>

00102202 <vector47>:
.globl vector47
vector47:
  pushl $0
  102202:	6a 00                	push   $0x0
  pushl $47
  102204:	6a 2f                	push   $0x2f
  jmp __alltraps
  102206:	e9 3c fe ff ff       	jmp    102047 <__alltraps>

0010220b <vector48>:
.globl vector48
vector48:
  pushl $0
  10220b:	6a 00                	push   $0x0
  pushl $48
  10220d:	6a 30                	push   $0x30
  jmp __alltraps
  10220f:	e9 33 fe ff ff       	jmp    102047 <__alltraps>

00102214 <vector49>:
.globl vector49
vector49:
  pushl $0
  102214:	6a 00                	push   $0x0
  pushl $49
  102216:	6a 31                	push   $0x31
  jmp __alltraps
  102218:	e9 2a fe ff ff       	jmp    102047 <__alltraps>

0010221d <vector50>:
.globl vector50
vector50:
  pushl $0
  10221d:	6a 00                	push   $0x0
  pushl $50
  10221f:	6a 32                	push   $0x32
  jmp __alltraps
  102221:	e9 21 fe ff ff       	jmp    102047 <__alltraps>

00102226 <vector51>:
.globl vector51
vector51:
  pushl $0
  102226:	6a 00                	push   $0x0
  pushl $51
  102228:	6a 33                	push   $0x33
  jmp __alltraps
  10222a:	e9 18 fe ff ff       	jmp    102047 <__alltraps>

0010222f <vector52>:
.globl vector52
vector52:
  pushl $0
  10222f:	6a 00                	push   $0x0
  pushl $52
  102231:	6a 34                	push   $0x34
  jmp __alltraps
  102233:	e9 0f fe ff ff       	jmp    102047 <__alltraps>

00102238 <vector53>:
.globl vector53
vector53:
  pushl $0
  102238:	6a 00                	push   $0x0
  pushl $53
  10223a:	6a 35                	push   $0x35
  jmp __alltraps
  10223c:	e9 06 fe ff ff       	jmp    102047 <__alltraps>

00102241 <vector54>:
.globl vector54
vector54:
  pushl $0
  102241:	6a 00                	push   $0x0
  pushl $54
  102243:	6a 36                	push   $0x36
  jmp __alltraps
  102245:	e9 fd fd ff ff       	jmp    102047 <__alltraps>

0010224a <vector55>:
.globl vector55
vector55:
  pushl $0
  10224a:	6a 00                	push   $0x0
  pushl $55
  10224c:	6a 37                	push   $0x37
  jmp __alltraps
  10224e:	e9 f4 fd ff ff       	jmp    102047 <__alltraps>

00102253 <vector56>:
.globl vector56
vector56:
  pushl $0
  102253:	6a 00                	push   $0x0
  pushl $56
  102255:	6a 38                	push   $0x38
  jmp __alltraps
  102257:	e9 eb fd ff ff       	jmp    102047 <__alltraps>

0010225c <vector57>:
.globl vector57
vector57:
  pushl $0
  10225c:	6a 00                	push   $0x0
  pushl $57
  10225e:	6a 39                	push   $0x39
  jmp __alltraps
  102260:	e9 e2 fd ff ff       	jmp    102047 <__alltraps>

00102265 <vector58>:
.globl vector58
vector58:
  pushl $0
  102265:	6a 00                	push   $0x0
  pushl $58
  102267:	6a 3a                	push   $0x3a
  jmp __alltraps
  102269:	e9 d9 fd ff ff       	jmp    102047 <__alltraps>

0010226e <vector59>:
.globl vector59
vector59:
  pushl $0
  10226e:	6a 00                	push   $0x0
  pushl $59
  102270:	6a 3b                	push   $0x3b
  jmp __alltraps
  102272:	e9 d0 fd ff ff       	jmp    102047 <__alltraps>

00102277 <vector60>:
.globl vector60
vector60:
  pushl $0
  102277:	6a 00                	push   $0x0
  pushl $60
  102279:	6a 3c                	push   $0x3c
  jmp __alltraps
  10227b:	e9 c7 fd ff ff       	jmp    102047 <__alltraps>

00102280 <vector61>:
.globl vector61
vector61:
  pushl $0
  102280:	6a 00                	push   $0x0
  pushl $61
  102282:	6a 3d                	push   $0x3d
  jmp __alltraps
  102284:	e9 be fd ff ff       	jmp    102047 <__alltraps>

00102289 <vector62>:
.globl vector62
vector62:
  pushl $0
  102289:	6a 00                	push   $0x0
  pushl $62
  10228b:	6a 3e                	push   $0x3e
  jmp __alltraps
  10228d:	e9 b5 fd ff ff       	jmp    102047 <__alltraps>

00102292 <vector63>:
.globl vector63
vector63:
  pushl $0
  102292:	6a 00                	push   $0x0
  pushl $63
  102294:	6a 3f                	push   $0x3f
  jmp __alltraps
  102296:	e9 ac fd ff ff       	jmp    102047 <__alltraps>

0010229b <vector64>:
.globl vector64
vector64:
  pushl $0
  10229b:	6a 00                	push   $0x0
  pushl $64
  10229d:	6a 40                	push   $0x40
  jmp __alltraps
  10229f:	e9 a3 fd ff ff       	jmp    102047 <__alltraps>

001022a4 <vector65>:
.globl vector65
vector65:
  pushl $0
  1022a4:	6a 00                	push   $0x0
  pushl $65
  1022a6:	6a 41                	push   $0x41
  jmp __alltraps
  1022a8:	e9 9a fd ff ff       	jmp    102047 <__alltraps>

001022ad <vector66>:
.globl vector66
vector66:
  pushl $0
  1022ad:	6a 00                	push   $0x0
  pushl $66
  1022af:	6a 42                	push   $0x42
  jmp __alltraps
  1022b1:	e9 91 fd ff ff       	jmp    102047 <__alltraps>

001022b6 <vector67>:
.globl vector67
vector67:
  pushl $0
  1022b6:	6a 00                	push   $0x0
  pushl $67
  1022b8:	6a 43                	push   $0x43
  jmp __alltraps
  1022ba:	e9 88 fd ff ff       	jmp    102047 <__alltraps>

001022bf <vector68>:
.globl vector68
vector68:
  pushl $0
  1022bf:	6a 00                	push   $0x0
  pushl $68
  1022c1:	6a 44                	push   $0x44
  jmp __alltraps
  1022c3:	e9 7f fd ff ff       	jmp    102047 <__alltraps>

001022c8 <vector69>:
.globl vector69
vector69:
  pushl $0
  1022c8:	6a 00                	push   $0x0
  pushl $69
  1022ca:	6a 45                	push   $0x45
  jmp __alltraps
  1022cc:	e9 76 fd ff ff       	jmp    102047 <__alltraps>

001022d1 <vector70>:
.globl vector70
vector70:
  pushl $0
  1022d1:	6a 00                	push   $0x0
  pushl $70
  1022d3:	6a 46                	push   $0x46
  jmp __alltraps
  1022d5:	e9 6d fd ff ff       	jmp    102047 <__alltraps>

001022da <vector71>:
.globl vector71
vector71:
  pushl $0
  1022da:	6a 00                	push   $0x0
  pushl $71
  1022dc:	6a 47                	push   $0x47
  jmp __alltraps
  1022de:	e9 64 fd ff ff       	jmp    102047 <__alltraps>

001022e3 <vector72>:
.globl vector72
vector72:
  pushl $0
  1022e3:	6a 00                	push   $0x0
  pushl $72
  1022e5:	6a 48                	push   $0x48
  jmp __alltraps
  1022e7:	e9 5b fd ff ff       	jmp    102047 <__alltraps>

001022ec <vector73>:
.globl vector73
vector73:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $73
  1022ee:	6a 49                	push   $0x49
  jmp __alltraps
  1022f0:	e9 52 fd ff ff       	jmp    102047 <__alltraps>

001022f5 <vector74>:
.globl vector74
vector74:
  pushl $0
  1022f5:	6a 00                	push   $0x0
  pushl $74
  1022f7:	6a 4a                	push   $0x4a
  jmp __alltraps
  1022f9:	e9 49 fd ff ff       	jmp    102047 <__alltraps>

001022fe <vector75>:
.globl vector75
vector75:
  pushl $0
  1022fe:	6a 00                	push   $0x0
  pushl $75
  102300:	6a 4b                	push   $0x4b
  jmp __alltraps
  102302:	e9 40 fd ff ff       	jmp    102047 <__alltraps>

00102307 <vector76>:
.globl vector76
vector76:
  pushl $0
  102307:	6a 00                	push   $0x0
  pushl $76
  102309:	6a 4c                	push   $0x4c
  jmp __alltraps
  10230b:	e9 37 fd ff ff       	jmp    102047 <__alltraps>

00102310 <vector77>:
.globl vector77
vector77:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $77
  102312:	6a 4d                	push   $0x4d
  jmp __alltraps
  102314:	e9 2e fd ff ff       	jmp    102047 <__alltraps>

00102319 <vector78>:
.globl vector78
vector78:
  pushl $0
  102319:	6a 00                	push   $0x0
  pushl $78
  10231b:	6a 4e                	push   $0x4e
  jmp __alltraps
  10231d:	e9 25 fd ff ff       	jmp    102047 <__alltraps>

00102322 <vector79>:
.globl vector79
vector79:
  pushl $0
  102322:	6a 00                	push   $0x0
  pushl $79
  102324:	6a 4f                	push   $0x4f
  jmp __alltraps
  102326:	e9 1c fd ff ff       	jmp    102047 <__alltraps>

0010232b <vector80>:
.globl vector80
vector80:
  pushl $0
  10232b:	6a 00                	push   $0x0
  pushl $80
  10232d:	6a 50                	push   $0x50
  jmp __alltraps
  10232f:	e9 13 fd ff ff       	jmp    102047 <__alltraps>

00102334 <vector81>:
.globl vector81
vector81:
  pushl $0
  102334:	6a 00                	push   $0x0
  pushl $81
  102336:	6a 51                	push   $0x51
  jmp __alltraps
  102338:	e9 0a fd ff ff       	jmp    102047 <__alltraps>

0010233d <vector82>:
.globl vector82
vector82:
  pushl $0
  10233d:	6a 00                	push   $0x0
  pushl $82
  10233f:	6a 52                	push   $0x52
  jmp __alltraps
  102341:	e9 01 fd ff ff       	jmp    102047 <__alltraps>

00102346 <vector83>:
.globl vector83
vector83:
  pushl $0
  102346:	6a 00                	push   $0x0
  pushl $83
  102348:	6a 53                	push   $0x53
  jmp __alltraps
  10234a:	e9 f8 fc ff ff       	jmp    102047 <__alltraps>

0010234f <vector84>:
.globl vector84
vector84:
  pushl $0
  10234f:	6a 00                	push   $0x0
  pushl $84
  102351:	6a 54                	push   $0x54
  jmp __alltraps
  102353:	e9 ef fc ff ff       	jmp    102047 <__alltraps>

00102358 <vector85>:
.globl vector85
vector85:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $85
  10235a:	6a 55                	push   $0x55
  jmp __alltraps
  10235c:	e9 e6 fc ff ff       	jmp    102047 <__alltraps>

00102361 <vector86>:
.globl vector86
vector86:
  pushl $0
  102361:	6a 00                	push   $0x0
  pushl $86
  102363:	6a 56                	push   $0x56
  jmp __alltraps
  102365:	e9 dd fc ff ff       	jmp    102047 <__alltraps>

0010236a <vector87>:
.globl vector87
vector87:
  pushl $0
  10236a:	6a 00                	push   $0x0
  pushl $87
  10236c:	6a 57                	push   $0x57
  jmp __alltraps
  10236e:	e9 d4 fc ff ff       	jmp    102047 <__alltraps>

00102373 <vector88>:
.globl vector88
vector88:
  pushl $0
  102373:	6a 00                	push   $0x0
  pushl $88
  102375:	6a 58                	push   $0x58
  jmp __alltraps
  102377:	e9 cb fc ff ff       	jmp    102047 <__alltraps>

0010237c <vector89>:
.globl vector89
vector89:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $89
  10237e:	6a 59                	push   $0x59
  jmp __alltraps
  102380:	e9 c2 fc ff ff       	jmp    102047 <__alltraps>

00102385 <vector90>:
.globl vector90
vector90:
  pushl $0
  102385:	6a 00                	push   $0x0
  pushl $90
  102387:	6a 5a                	push   $0x5a
  jmp __alltraps
  102389:	e9 b9 fc ff ff       	jmp    102047 <__alltraps>

0010238e <vector91>:
.globl vector91
vector91:
  pushl $0
  10238e:	6a 00                	push   $0x0
  pushl $91
  102390:	6a 5b                	push   $0x5b
  jmp __alltraps
  102392:	e9 b0 fc ff ff       	jmp    102047 <__alltraps>

00102397 <vector92>:
.globl vector92
vector92:
  pushl $0
  102397:	6a 00                	push   $0x0
  pushl $92
  102399:	6a 5c                	push   $0x5c
  jmp __alltraps
  10239b:	e9 a7 fc ff ff       	jmp    102047 <__alltraps>

001023a0 <vector93>:
.globl vector93
vector93:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $93
  1023a2:	6a 5d                	push   $0x5d
  jmp __alltraps
  1023a4:	e9 9e fc ff ff       	jmp    102047 <__alltraps>

001023a9 <vector94>:
.globl vector94
vector94:
  pushl $0
  1023a9:	6a 00                	push   $0x0
  pushl $94
  1023ab:	6a 5e                	push   $0x5e
  jmp __alltraps
  1023ad:	e9 95 fc ff ff       	jmp    102047 <__alltraps>

001023b2 <vector95>:
.globl vector95
vector95:
  pushl $0
  1023b2:	6a 00                	push   $0x0
  pushl $95
  1023b4:	6a 5f                	push   $0x5f
  jmp __alltraps
  1023b6:	e9 8c fc ff ff       	jmp    102047 <__alltraps>

001023bb <vector96>:
.globl vector96
vector96:
  pushl $0
  1023bb:	6a 00                	push   $0x0
  pushl $96
  1023bd:	6a 60                	push   $0x60
  jmp __alltraps
  1023bf:	e9 83 fc ff ff       	jmp    102047 <__alltraps>

001023c4 <vector97>:
.globl vector97
vector97:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $97
  1023c6:	6a 61                	push   $0x61
  jmp __alltraps
  1023c8:	e9 7a fc ff ff       	jmp    102047 <__alltraps>

001023cd <vector98>:
.globl vector98
vector98:
  pushl $0
  1023cd:	6a 00                	push   $0x0
  pushl $98
  1023cf:	6a 62                	push   $0x62
  jmp __alltraps
  1023d1:	e9 71 fc ff ff       	jmp    102047 <__alltraps>

001023d6 <vector99>:
.globl vector99
vector99:
  pushl $0
  1023d6:	6a 00                	push   $0x0
  pushl $99
  1023d8:	6a 63                	push   $0x63
  jmp __alltraps
  1023da:	e9 68 fc ff ff       	jmp    102047 <__alltraps>

001023df <vector100>:
.globl vector100
vector100:
  pushl $0
  1023df:	6a 00                	push   $0x0
  pushl $100
  1023e1:	6a 64                	push   $0x64
  jmp __alltraps
  1023e3:	e9 5f fc ff ff       	jmp    102047 <__alltraps>

001023e8 <vector101>:
.globl vector101
vector101:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $101
  1023ea:	6a 65                	push   $0x65
  jmp __alltraps
  1023ec:	e9 56 fc ff ff       	jmp    102047 <__alltraps>

001023f1 <vector102>:
.globl vector102
vector102:
  pushl $0
  1023f1:	6a 00                	push   $0x0
  pushl $102
  1023f3:	6a 66                	push   $0x66
  jmp __alltraps
  1023f5:	e9 4d fc ff ff       	jmp    102047 <__alltraps>

001023fa <vector103>:
.globl vector103
vector103:
  pushl $0
  1023fa:	6a 00                	push   $0x0
  pushl $103
  1023fc:	6a 67                	push   $0x67
  jmp __alltraps
  1023fe:	e9 44 fc ff ff       	jmp    102047 <__alltraps>

00102403 <vector104>:
.globl vector104
vector104:
  pushl $0
  102403:	6a 00                	push   $0x0
  pushl $104
  102405:	6a 68                	push   $0x68
  jmp __alltraps
  102407:	e9 3b fc ff ff       	jmp    102047 <__alltraps>

0010240c <vector105>:
.globl vector105
vector105:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $105
  10240e:	6a 69                	push   $0x69
  jmp __alltraps
  102410:	e9 32 fc ff ff       	jmp    102047 <__alltraps>

00102415 <vector106>:
.globl vector106
vector106:
  pushl $0
  102415:	6a 00                	push   $0x0
  pushl $106
  102417:	6a 6a                	push   $0x6a
  jmp __alltraps
  102419:	e9 29 fc ff ff       	jmp    102047 <__alltraps>

0010241e <vector107>:
.globl vector107
vector107:
  pushl $0
  10241e:	6a 00                	push   $0x0
  pushl $107
  102420:	6a 6b                	push   $0x6b
  jmp __alltraps
  102422:	e9 20 fc ff ff       	jmp    102047 <__alltraps>

00102427 <vector108>:
.globl vector108
vector108:
  pushl $0
  102427:	6a 00                	push   $0x0
  pushl $108
  102429:	6a 6c                	push   $0x6c
  jmp __alltraps
  10242b:	e9 17 fc ff ff       	jmp    102047 <__alltraps>

00102430 <vector109>:
.globl vector109
vector109:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $109
  102432:	6a 6d                	push   $0x6d
  jmp __alltraps
  102434:	e9 0e fc ff ff       	jmp    102047 <__alltraps>

00102439 <vector110>:
.globl vector110
vector110:
  pushl $0
  102439:	6a 00                	push   $0x0
  pushl $110
  10243b:	6a 6e                	push   $0x6e
  jmp __alltraps
  10243d:	e9 05 fc ff ff       	jmp    102047 <__alltraps>

00102442 <vector111>:
.globl vector111
vector111:
  pushl $0
  102442:	6a 00                	push   $0x0
  pushl $111
  102444:	6a 6f                	push   $0x6f
  jmp __alltraps
  102446:	e9 fc fb ff ff       	jmp    102047 <__alltraps>

0010244b <vector112>:
.globl vector112
vector112:
  pushl $0
  10244b:	6a 00                	push   $0x0
  pushl $112
  10244d:	6a 70                	push   $0x70
  jmp __alltraps
  10244f:	e9 f3 fb ff ff       	jmp    102047 <__alltraps>

00102454 <vector113>:
.globl vector113
vector113:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $113
  102456:	6a 71                	push   $0x71
  jmp __alltraps
  102458:	e9 ea fb ff ff       	jmp    102047 <__alltraps>

0010245d <vector114>:
.globl vector114
vector114:
  pushl $0
  10245d:	6a 00                	push   $0x0
  pushl $114
  10245f:	6a 72                	push   $0x72
  jmp __alltraps
  102461:	e9 e1 fb ff ff       	jmp    102047 <__alltraps>

00102466 <vector115>:
.globl vector115
vector115:
  pushl $0
  102466:	6a 00                	push   $0x0
  pushl $115
  102468:	6a 73                	push   $0x73
  jmp __alltraps
  10246a:	e9 d8 fb ff ff       	jmp    102047 <__alltraps>

0010246f <vector116>:
.globl vector116
vector116:
  pushl $0
  10246f:	6a 00                	push   $0x0
  pushl $116
  102471:	6a 74                	push   $0x74
  jmp __alltraps
  102473:	e9 cf fb ff ff       	jmp    102047 <__alltraps>

00102478 <vector117>:
.globl vector117
vector117:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $117
  10247a:	6a 75                	push   $0x75
  jmp __alltraps
  10247c:	e9 c6 fb ff ff       	jmp    102047 <__alltraps>

00102481 <vector118>:
.globl vector118
vector118:
  pushl $0
  102481:	6a 00                	push   $0x0
  pushl $118
  102483:	6a 76                	push   $0x76
  jmp __alltraps
  102485:	e9 bd fb ff ff       	jmp    102047 <__alltraps>

0010248a <vector119>:
.globl vector119
vector119:
  pushl $0
  10248a:	6a 00                	push   $0x0
  pushl $119
  10248c:	6a 77                	push   $0x77
  jmp __alltraps
  10248e:	e9 b4 fb ff ff       	jmp    102047 <__alltraps>

00102493 <vector120>:
.globl vector120
vector120:
  pushl $0
  102493:	6a 00                	push   $0x0
  pushl $120
  102495:	6a 78                	push   $0x78
  jmp __alltraps
  102497:	e9 ab fb ff ff       	jmp    102047 <__alltraps>

0010249c <vector121>:
.globl vector121
vector121:
  pushl $0
  10249c:	6a 00                	push   $0x0
  pushl $121
  10249e:	6a 79                	push   $0x79
  jmp __alltraps
  1024a0:	e9 a2 fb ff ff       	jmp    102047 <__alltraps>

001024a5 <vector122>:
.globl vector122
vector122:
  pushl $0
  1024a5:	6a 00                	push   $0x0
  pushl $122
  1024a7:	6a 7a                	push   $0x7a
  jmp __alltraps
  1024a9:	e9 99 fb ff ff       	jmp    102047 <__alltraps>

001024ae <vector123>:
.globl vector123
vector123:
  pushl $0
  1024ae:	6a 00                	push   $0x0
  pushl $123
  1024b0:	6a 7b                	push   $0x7b
  jmp __alltraps
  1024b2:	e9 90 fb ff ff       	jmp    102047 <__alltraps>

001024b7 <vector124>:
.globl vector124
vector124:
  pushl $0
  1024b7:	6a 00                	push   $0x0
  pushl $124
  1024b9:	6a 7c                	push   $0x7c
  jmp __alltraps
  1024bb:	e9 87 fb ff ff       	jmp    102047 <__alltraps>

001024c0 <vector125>:
.globl vector125
vector125:
  pushl $0
  1024c0:	6a 00                	push   $0x0
  pushl $125
  1024c2:	6a 7d                	push   $0x7d
  jmp __alltraps
  1024c4:	e9 7e fb ff ff       	jmp    102047 <__alltraps>

001024c9 <vector126>:
.globl vector126
vector126:
  pushl $0
  1024c9:	6a 00                	push   $0x0
  pushl $126
  1024cb:	6a 7e                	push   $0x7e
  jmp __alltraps
  1024cd:	e9 75 fb ff ff       	jmp    102047 <__alltraps>

001024d2 <vector127>:
.globl vector127
vector127:
  pushl $0
  1024d2:	6a 00                	push   $0x0
  pushl $127
  1024d4:	6a 7f                	push   $0x7f
  jmp __alltraps
  1024d6:	e9 6c fb ff ff       	jmp    102047 <__alltraps>

001024db <vector128>:
.globl vector128
vector128:
  pushl $0
  1024db:	6a 00                	push   $0x0
  pushl $128
  1024dd:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1024e2:	e9 60 fb ff ff       	jmp    102047 <__alltraps>

001024e7 <vector129>:
.globl vector129
vector129:
  pushl $0
  1024e7:	6a 00                	push   $0x0
  pushl $129
  1024e9:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1024ee:	e9 54 fb ff ff       	jmp    102047 <__alltraps>

001024f3 <vector130>:
.globl vector130
vector130:
  pushl $0
  1024f3:	6a 00                	push   $0x0
  pushl $130
  1024f5:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1024fa:	e9 48 fb ff ff       	jmp    102047 <__alltraps>

001024ff <vector131>:
.globl vector131
vector131:
  pushl $0
  1024ff:	6a 00                	push   $0x0
  pushl $131
  102501:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102506:	e9 3c fb ff ff       	jmp    102047 <__alltraps>

0010250b <vector132>:
.globl vector132
vector132:
  pushl $0
  10250b:	6a 00                	push   $0x0
  pushl $132
  10250d:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102512:	e9 30 fb ff ff       	jmp    102047 <__alltraps>

00102517 <vector133>:
.globl vector133
vector133:
  pushl $0
  102517:	6a 00                	push   $0x0
  pushl $133
  102519:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10251e:	e9 24 fb ff ff       	jmp    102047 <__alltraps>

00102523 <vector134>:
.globl vector134
vector134:
  pushl $0
  102523:	6a 00                	push   $0x0
  pushl $134
  102525:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10252a:	e9 18 fb ff ff       	jmp    102047 <__alltraps>

0010252f <vector135>:
.globl vector135
vector135:
  pushl $0
  10252f:	6a 00                	push   $0x0
  pushl $135
  102531:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102536:	e9 0c fb ff ff       	jmp    102047 <__alltraps>

0010253b <vector136>:
.globl vector136
vector136:
  pushl $0
  10253b:	6a 00                	push   $0x0
  pushl $136
  10253d:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102542:	e9 00 fb ff ff       	jmp    102047 <__alltraps>

00102547 <vector137>:
.globl vector137
vector137:
  pushl $0
  102547:	6a 00                	push   $0x0
  pushl $137
  102549:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10254e:	e9 f4 fa ff ff       	jmp    102047 <__alltraps>

00102553 <vector138>:
.globl vector138
vector138:
  pushl $0
  102553:	6a 00                	push   $0x0
  pushl $138
  102555:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10255a:	e9 e8 fa ff ff       	jmp    102047 <__alltraps>

0010255f <vector139>:
.globl vector139
vector139:
  pushl $0
  10255f:	6a 00                	push   $0x0
  pushl $139
  102561:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102566:	e9 dc fa ff ff       	jmp    102047 <__alltraps>

0010256b <vector140>:
.globl vector140
vector140:
  pushl $0
  10256b:	6a 00                	push   $0x0
  pushl $140
  10256d:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102572:	e9 d0 fa ff ff       	jmp    102047 <__alltraps>

00102577 <vector141>:
.globl vector141
vector141:
  pushl $0
  102577:	6a 00                	push   $0x0
  pushl $141
  102579:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10257e:	e9 c4 fa ff ff       	jmp    102047 <__alltraps>

00102583 <vector142>:
.globl vector142
vector142:
  pushl $0
  102583:	6a 00                	push   $0x0
  pushl $142
  102585:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10258a:	e9 b8 fa ff ff       	jmp    102047 <__alltraps>

0010258f <vector143>:
.globl vector143
vector143:
  pushl $0
  10258f:	6a 00                	push   $0x0
  pushl $143
  102591:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102596:	e9 ac fa ff ff       	jmp    102047 <__alltraps>

0010259b <vector144>:
.globl vector144
vector144:
  pushl $0
  10259b:	6a 00                	push   $0x0
  pushl $144
  10259d:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1025a2:	e9 a0 fa ff ff       	jmp    102047 <__alltraps>

001025a7 <vector145>:
.globl vector145
vector145:
  pushl $0
  1025a7:	6a 00                	push   $0x0
  pushl $145
  1025a9:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1025ae:	e9 94 fa ff ff       	jmp    102047 <__alltraps>

001025b3 <vector146>:
.globl vector146
vector146:
  pushl $0
  1025b3:	6a 00                	push   $0x0
  pushl $146
  1025b5:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1025ba:	e9 88 fa ff ff       	jmp    102047 <__alltraps>

001025bf <vector147>:
.globl vector147
vector147:
  pushl $0
  1025bf:	6a 00                	push   $0x0
  pushl $147
  1025c1:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1025c6:	e9 7c fa ff ff       	jmp    102047 <__alltraps>

001025cb <vector148>:
.globl vector148
vector148:
  pushl $0
  1025cb:	6a 00                	push   $0x0
  pushl $148
  1025cd:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1025d2:	e9 70 fa ff ff       	jmp    102047 <__alltraps>

001025d7 <vector149>:
.globl vector149
vector149:
  pushl $0
  1025d7:	6a 00                	push   $0x0
  pushl $149
  1025d9:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1025de:	e9 64 fa ff ff       	jmp    102047 <__alltraps>

001025e3 <vector150>:
.globl vector150
vector150:
  pushl $0
  1025e3:	6a 00                	push   $0x0
  pushl $150
  1025e5:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1025ea:	e9 58 fa ff ff       	jmp    102047 <__alltraps>

001025ef <vector151>:
.globl vector151
vector151:
  pushl $0
  1025ef:	6a 00                	push   $0x0
  pushl $151
  1025f1:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1025f6:	e9 4c fa ff ff       	jmp    102047 <__alltraps>

001025fb <vector152>:
.globl vector152
vector152:
  pushl $0
  1025fb:	6a 00                	push   $0x0
  pushl $152
  1025fd:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102602:	e9 40 fa ff ff       	jmp    102047 <__alltraps>

00102607 <vector153>:
.globl vector153
vector153:
  pushl $0
  102607:	6a 00                	push   $0x0
  pushl $153
  102609:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10260e:	e9 34 fa ff ff       	jmp    102047 <__alltraps>

00102613 <vector154>:
.globl vector154
vector154:
  pushl $0
  102613:	6a 00                	push   $0x0
  pushl $154
  102615:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10261a:	e9 28 fa ff ff       	jmp    102047 <__alltraps>

0010261f <vector155>:
.globl vector155
vector155:
  pushl $0
  10261f:	6a 00                	push   $0x0
  pushl $155
  102621:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102626:	e9 1c fa ff ff       	jmp    102047 <__alltraps>

0010262b <vector156>:
.globl vector156
vector156:
  pushl $0
  10262b:	6a 00                	push   $0x0
  pushl $156
  10262d:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102632:	e9 10 fa ff ff       	jmp    102047 <__alltraps>

00102637 <vector157>:
.globl vector157
vector157:
  pushl $0
  102637:	6a 00                	push   $0x0
  pushl $157
  102639:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10263e:	e9 04 fa ff ff       	jmp    102047 <__alltraps>

00102643 <vector158>:
.globl vector158
vector158:
  pushl $0
  102643:	6a 00                	push   $0x0
  pushl $158
  102645:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10264a:	e9 f8 f9 ff ff       	jmp    102047 <__alltraps>

0010264f <vector159>:
.globl vector159
vector159:
  pushl $0
  10264f:	6a 00                	push   $0x0
  pushl $159
  102651:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102656:	e9 ec f9 ff ff       	jmp    102047 <__alltraps>

0010265b <vector160>:
.globl vector160
vector160:
  pushl $0
  10265b:	6a 00                	push   $0x0
  pushl $160
  10265d:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102662:	e9 e0 f9 ff ff       	jmp    102047 <__alltraps>

00102667 <vector161>:
.globl vector161
vector161:
  pushl $0
  102667:	6a 00                	push   $0x0
  pushl $161
  102669:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10266e:	e9 d4 f9 ff ff       	jmp    102047 <__alltraps>

00102673 <vector162>:
.globl vector162
vector162:
  pushl $0
  102673:	6a 00                	push   $0x0
  pushl $162
  102675:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10267a:	e9 c8 f9 ff ff       	jmp    102047 <__alltraps>

0010267f <vector163>:
.globl vector163
vector163:
  pushl $0
  10267f:	6a 00                	push   $0x0
  pushl $163
  102681:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102686:	e9 bc f9 ff ff       	jmp    102047 <__alltraps>

0010268b <vector164>:
.globl vector164
vector164:
  pushl $0
  10268b:	6a 00                	push   $0x0
  pushl $164
  10268d:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102692:	e9 b0 f9 ff ff       	jmp    102047 <__alltraps>

00102697 <vector165>:
.globl vector165
vector165:
  pushl $0
  102697:	6a 00                	push   $0x0
  pushl $165
  102699:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10269e:	e9 a4 f9 ff ff       	jmp    102047 <__alltraps>

001026a3 <vector166>:
.globl vector166
vector166:
  pushl $0
  1026a3:	6a 00                	push   $0x0
  pushl $166
  1026a5:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1026aa:	e9 98 f9 ff ff       	jmp    102047 <__alltraps>

001026af <vector167>:
.globl vector167
vector167:
  pushl $0
  1026af:	6a 00                	push   $0x0
  pushl $167
  1026b1:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1026b6:	e9 8c f9 ff ff       	jmp    102047 <__alltraps>

001026bb <vector168>:
.globl vector168
vector168:
  pushl $0
  1026bb:	6a 00                	push   $0x0
  pushl $168
  1026bd:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1026c2:	e9 80 f9 ff ff       	jmp    102047 <__alltraps>

001026c7 <vector169>:
.globl vector169
vector169:
  pushl $0
  1026c7:	6a 00                	push   $0x0
  pushl $169
  1026c9:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1026ce:	e9 74 f9 ff ff       	jmp    102047 <__alltraps>

001026d3 <vector170>:
.globl vector170
vector170:
  pushl $0
  1026d3:	6a 00                	push   $0x0
  pushl $170
  1026d5:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1026da:	e9 68 f9 ff ff       	jmp    102047 <__alltraps>

001026df <vector171>:
.globl vector171
vector171:
  pushl $0
  1026df:	6a 00                	push   $0x0
  pushl $171
  1026e1:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1026e6:	e9 5c f9 ff ff       	jmp    102047 <__alltraps>

001026eb <vector172>:
.globl vector172
vector172:
  pushl $0
  1026eb:	6a 00                	push   $0x0
  pushl $172
  1026ed:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1026f2:	e9 50 f9 ff ff       	jmp    102047 <__alltraps>

001026f7 <vector173>:
.globl vector173
vector173:
  pushl $0
  1026f7:	6a 00                	push   $0x0
  pushl $173
  1026f9:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1026fe:	e9 44 f9 ff ff       	jmp    102047 <__alltraps>

00102703 <vector174>:
.globl vector174
vector174:
  pushl $0
  102703:	6a 00                	push   $0x0
  pushl $174
  102705:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10270a:	e9 38 f9 ff ff       	jmp    102047 <__alltraps>

0010270f <vector175>:
.globl vector175
vector175:
  pushl $0
  10270f:	6a 00                	push   $0x0
  pushl $175
  102711:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102716:	e9 2c f9 ff ff       	jmp    102047 <__alltraps>

0010271b <vector176>:
.globl vector176
vector176:
  pushl $0
  10271b:	6a 00                	push   $0x0
  pushl $176
  10271d:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102722:	e9 20 f9 ff ff       	jmp    102047 <__alltraps>

00102727 <vector177>:
.globl vector177
vector177:
  pushl $0
  102727:	6a 00                	push   $0x0
  pushl $177
  102729:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10272e:	e9 14 f9 ff ff       	jmp    102047 <__alltraps>

00102733 <vector178>:
.globl vector178
vector178:
  pushl $0
  102733:	6a 00                	push   $0x0
  pushl $178
  102735:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10273a:	e9 08 f9 ff ff       	jmp    102047 <__alltraps>

0010273f <vector179>:
.globl vector179
vector179:
  pushl $0
  10273f:	6a 00                	push   $0x0
  pushl $179
  102741:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102746:	e9 fc f8 ff ff       	jmp    102047 <__alltraps>

0010274b <vector180>:
.globl vector180
vector180:
  pushl $0
  10274b:	6a 00                	push   $0x0
  pushl $180
  10274d:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102752:	e9 f0 f8 ff ff       	jmp    102047 <__alltraps>

00102757 <vector181>:
.globl vector181
vector181:
  pushl $0
  102757:	6a 00                	push   $0x0
  pushl $181
  102759:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10275e:	e9 e4 f8 ff ff       	jmp    102047 <__alltraps>

00102763 <vector182>:
.globl vector182
vector182:
  pushl $0
  102763:	6a 00                	push   $0x0
  pushl $182
  102765:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10276a:	e9 d8 f8 ff ff       	jmp    102047 <__alltraps>

0010276f <vector183>:
.globl vector183
vector183:
  pushl $0
  10276f:	6a 00                	push   $0x0
  pushl $183
  102771:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102776:	e9 cc f8 ff ff       	jmp    102047 <__alltraps>

0010277b <vector184>:
.globl vector184
vector184:
  pushl $0
  10277b:	6a 00                	push   $0x0
  pushl $184
  10277d:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102782:	e9 c0 f8 ff ff       	jmp    102047 <__alltraps>

00102787 <vector185>:
.globl vector185
vector185:
  pushl $0
  102787:	6a 00                	push   $0x0
  pushl $185
  102789:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10278e:	e9 b4 f8 ff ff       	jmp    102047 <__alltraps>

00102793 <vector186>:
.globl vector186
vector186:
  pushl $0
  102793:	6a 00                	push   $0x0
  pushl $186
  102795:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10279a:	e9 a8 f8 ff ff       	jmp    102047 <__alltraps>

0010279f <vector187>:
.globl vector187
vector187:
  pushl $0
  10279f:	6a 00                	push   $0x0
  pushl $187
  1027a1:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1027a6:	e9 9c f8 ff ff       	jmp    102047 <__alltraps>

001027ab <vector188>:
.globl vector188
vector188:
  pushl $0
  1027ab:	6a 00                	push   $0x0
  pushl $188
  1027ad:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1027b2:	e9 90 f8 ff ff       	jmp    102047 <__alltraps>

001027b7 <vector189>:
.globl vector189
vector189:
  pushl $0
  1027b7:	6a 00                	push   $0x0
  pushl $189
  1027b9:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1027be:	e9 84 f8 ff ff       	jmp    102047 <__alltraps>

001027c3 <vector190>:
.globl vector190
vector190:
  pushl $0
  1027c3:	6a 00                	push   $0x0
  pushl $190
  1027c5:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1027ca:	e9 78 f8 ff ff       	jmp    102047 <__alltraps>

001027cf <vector191>:
.globl vector191
vector191:
  pushl $0
  1027cf:	6a 00                	push   $0x0
  pushl $191
  1027d1:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1027d6:	e9 6c f8 ff ff       	jmp    102047 <__alltraps>

001027db <vector192>:
.globl vector192
vector192:
  pushl $0
  1027db:	6a 00                	push   $0x0
  pushl $192
  1027dd:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1027e2:	e9 60 f8 ff ff       	jmp    102047 <__alltraps>

001027e7 <vector193>:
.globl vector193
vector193:
  pushl $0
  1027e7:	6a 00                	push   $0x0
  pushl $193
  1027e9:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1027ee:	e9 54 f8 ff ff       	jmp    102047 <__alltraps>

001027f3 <vector194>:
.globl vector194
vector194:
  pushl $0
  1027f3:	6a 00                	push   $0x0
  pushl $194
  1027f5:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1027fa:	e9 48 f8 ff ff       	jmp    102047 <__alltraps>

001027ff <vector195>:
.globl vector195
vector195:
  pushl $0
  1027ff:	6a 00                	push   $0x0
  pushl $195
  102801:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102806:	e9 3c f8 ff ff       	jmp    102047 <__alltraps>

0010280b <vector196>:
.globl vector196
vector196:
  pushl $0
  10280b:	6a 00                	push   $0x0
  pushl $196
  10280d:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102812:	e9 30 f8 ff ff       	jmp    102047 <__alltraps>

00102817 <vector197>:
.globl vector197
vector197:
  pushl $0
  102817:	6a 00                	push   $0x0
  pushl $197
  102819:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10281e:	e9 24 f8 ff ff       	jmp    102047 <__alltraps>

00102823 <vector198>:
.globl vector198
vector198:
  pushl $0
  102823:	6a 00                	push   $0x0
  pushl $198
  102825:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10282a:	e9 18 f8 ff ff       	jmp    102047 <__alltraps>

0010282f <vector199>:
.globl vector199
vector199:
  pushl $0
  10282f:	6a 00                	push   $0x0
  pushl $199
  102831:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102836:	e9 0c f8 ff ff       	jmp    102047 <__alltraps>

0010283b <vector200>:
.globl vector200
vector200:
  pushl $0
  10283b:	6a 00                	push   $0x0
  pushl $200
  10283d:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102842:	e9 00 f8 ff ff       	jmp    102047 <__alltraps>

00102847 <vector201>:
.globl vector201
vector201:
  pushl $0
  102847:	6a 00                	push   $0x0
  pushl $201
  102849:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10284e:	e9 f4 f7 ff ff       	jmp    102047 <__alltraps>

00102853 <vector202>:
.globl vector202
vector202:
  pushl $0
  102853:	6a 00                	push   $0x0
  pushl $202
  102855:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10285a:	e9 e8 f7 ff ff       	jmp    102047 <__alltraps>

0010285f <vector203>:
.globl vector203
vector203:
  pushl $0
  10285f:	6a 00                	push   $0x0
  pushl $203
  102861:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102866:	e9 dc f7 ff ff       	jmp    102047 <__alltraps>

0010286b <vector204>:
.globl vector204
vector204:
  pushl $0
  10286b:	6a 00                	push   $0x0
  pushl $204
  10286d:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102872:	e9 d0 f7 ff ff       	jmp    102047 <__alltraps>

00102877 <vector205>:
.globl vector205
vector205:
  pushl $0
  102877:	6a 00                	push   $0x0
  pushl $205
  102879:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10287e:	e9 c4 f7 ff ff       	jmp    102047 <__alltraps>

00102883 <vector206>:
.globl vector206
vector206:
  pushl $0
  102883:	6a 00                	push   $0x0
  pushl $206
  102885:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10288a:	e9 b8 f7 ff ff       	jmp    102047 <__alltraps>

0010288f <vector207>:
.globl vector207
vector207:
  pushl $0
  10288f:	6a 00                	push   $0x0
  pushl $207
  102891:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102896:	e9 ac f7 ff ff       	jmp    102047 <__alltraps>

0010289b <vector208>:
.globl vector208
vector208:
  pushl $0
  10289b:	6a 00                	push   $0x0
  pushl $208
  10289d:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1028a2:	e9 a0 f7 ff ff       	jmp    102047 <__alltraps>

001028a7 <vector209>:
.globl vector209
vector209:
  pushl $0
  1028a7:	6a 00                	push   $0x0
  pushl $209
  1028a9:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1028ae:	e9 94 f7 ff ff       	jmp    102047 <__alltraps>

001028b3 <vector210>:
.globl vector210
vector210:
  pushl $0
  1028b3:	6a 00                	push   $0x0
  pushl $210
  1028b5:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1028ba:	e9 88 f7 ff ff       	jmp    102047 <__alltraps>

001028bf <vector211>:
.globl vector211
vector211:
  pushl $0
  1028bf:	6a 00                	push   $0x0
  pushl $211
  1028c1:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1028c6:	e9 7c f7 ff ff       	jmp    102047 <__alltraps>

001028cb <vector212>:
.globl vector212
vector212:
  pushl $0
  1028cb:	6a 00                	push   $0x0
  pushl $212
  1028cd:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1028d2:	e9 70 f7 ff ff       	jmp    102047 <__alltraps>

001028d7 <vector213>:
.globl vector213
vector213:
  pushl $0
  1028d7:	6a 00                	push   $0x0
  pushl $213
  1028d9:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1028de:	e9 64 f7 ff ff       	jmp    102047 <__alltraps>

001028e3 <vector214>:
.globl vector214
vector214:
  pushl $0
  1028e3:	6a 00                	push   $0x0
  pushl $214
  1028e5:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1028ea:	e9 58 f7 ff ff       	jmp    102047 <__alltraps>

001028ef <vector215>:
.globl vector215
vector215:
  pushl $0
  1028ef:	6a 00                	push   $0x0
  pushl $215
  1028f1:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1028f6:	e9 4c f7 ff ff       	jmp    102047 <__alltraps>

001028fb <vector216>:
.globl vector216
vector216:
  pushl $0
  1028fb:	6a 00                	push   $0x0
  pushl $216
  1028fd:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102902:	e9 40 f7 ff ff       	jmp    102047 <__alltraps>

00102907 <vector217>:
.globl vector217
vector217:
  pushl $0
  102907:	6a 00                	push   $0x0
  pushl $217
  102909:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10290e:	e9 34 f7 ff ff       	jmp    102047 <__alltraps>

00102913 <vector218>:
.globl vector218
vector218:
  pushl $0
  102913:	6a 00                	push   $0x0
  pushl $218
  102915:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10291a:	e9 28 f7 ff ff       	jmp    102047 <__alltraps>

0010291f <vector219>:
.globl vector219
vector219:
  pushl $0
  10291f:	6a 00                	push   $0x0
  pushl $219
  102921:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102926:	e9 1c f7 ff ff       	jmp    102047 <__alltraps>

0010292b <vector220>:
.globl vector220
vector220:
  pushl $0
  10292b:	6a 00                	push   $0x0
  pushl $220
  10292d:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102932:	e9 10 f7 ff ff       	jmp    102047 <__alltraps>

00102937 <vector221>:
.globl vector221
vector221:
  pushl $0
  102937:	6a 00                	push   $0x0
  pushl $221
  102939:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10293e:	e9 04 f7 ff ff       	jmp    102047 <__alltraps>

00102943 <vector222>:
.globl vector222
vector222:
  pushl $0
  102943:	6a 00                	push   $0x0
  pushl $222
  102945:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10294a:	e9 f8 f6 ff ff       	jmp    102047 <__alltraps>

0010294f <vector223>:
.globl vector223
vector223:
  pushl $0
  10294f:	6a 00                	push   $0x0
  pushl $223
  102951:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102956:	e9 ec f6 ff ff       	jmp    102047 <__alltraps>

0010295b <vector224>:
.globl vector224
vector224:
  pushl $0
  10295b:	6a 00                	push   $0x0
  pushl $224
  10295d:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102962:	e9 e0 f6 ff ff       	jmp    102047 <__alltraps>

00102967 <vector225>:
.globl vector225
vector225:
  pushl $0
  102967:	6a 00                	push   $0x0
  pushl $225
  102969:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10296e:	e9 d4 f6 ff ff       	jmp    102047 <__alltraps>

00102973 <vector226>:
.globl vector226
vector226:
  pushl $0
  102973:	6a 00                	push   $0x0
  pushl $226
  102975:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10297a:	e9 c8 f6 ff ff       	jmp    102047 <__alltraps>

0010297f <vector227>:
.globl vector227
vector227:
  pushl $0
  10297f:	6a 00                	push   $0x0
  pushl $227
  102981:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102986:	e9 bc f6 ff ff       	jmp    102047 <__alltraps>

0010298b <vector228>:
.globl vector228
vector228:
  pushl $0
  10298b:	6a 00                	push   $0x0
  pushl $228
  10298d:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102992:	e9 b0 f6 ff ff       	jmp    102047 <__alltraps>

00102997 <vector229>:
.globl vector229
vector229:
  pushl $0
  102997:	6a 00                	push   $0x0
  pushl $229
  102999:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10299e:	e9 a4 f6 ff ff       	jmp    102047 <__alltraps>

001029a3 <vector230>:
.globl vector230
vector230:
  pushl $0
  1029a3:	6a 00                	push   $0x0
  pushl $230
  1029a5:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1029aa:	e9 98 f6 ff ff       	jmp    102047 <__alltraps>

001029af <vector231>:
.globl vector231
vector231:
  pushl $0
  1029af:	6a 00                	push   $0x0
  pushl $231
  1029b1:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1029b6:	e9 8c f6 ff ff       	jmp    102047 <__alltraps>

001029bb <vector232>:
.globl vector232
vector232:
  pushl $0
  1029bb:	6a 00                	push   $0x0
  pushl $232
  1029bd:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1029c2:	e9 80 f6 ff ff       	jmp    102047 <__alltraps>

001029c7 <vector233>:
.globl vector233
vector233:
  pushl $0
  1029c7:	6a 00                	push   $0x0
  pushl $233
  1029c9:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1029ce:	e9 74 f6 ff ff       	jmp    102047 <__alltraps>

001029d3 <vector234>:
.globl vector234
vector234:
  pushl $0
  1029d3:	6a 00                	push   $0x0
  pushl $234
  1029d5:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1029da:	e9 68 f6 ff ff       	jmp    102047 <__alltraps>

001029df <vector235>:
.globl vector235
vector235:
  pushl $0
  1029df:	6a 00                	push   $0x0
  pushl $235
  1029e1:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1029e6:	e9 5c f6 ff ff       	jmp    102047 <__alltraps>

001029eb <vector236>:
.globl vector236
vector236:
  pushl $0
  1029eb:	6a 00                	push   $0x0
  pushl $236
  1029ed:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1029f2:	e9 50 f6 ff ff       	jmp    102047 <__alltraps>

001029f7 <vector237>:
.globl vector237
vector237:
  pushl $0
  1029f7:	6a 00                	push   $0x0
  pushl $237
  1029f9:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1029fe:	e9 44 f6 ff ff       	jmp    102047 <__alltraps>

00102a03 <vector238>:
.globl vector238
vector238:
  pushl $0
  102a03:	6a 00                	push   $0x0
  pushl $238
  102a05:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102a0a:	e9 38 f6 ff ff       	jmp    102047 <__alltraps>

00102a0f <vector239>:
.globl vector239
vector239:
  pushl $0
  102a0f:	6a 00                	push   $0x0
  pushl $239
  102a11:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102a16:	e9 2c f6 ff ff       	jmp    102047 <__alltraps>

00102a1b <vector240>:
.globl vector240
vector240:
  pushl $0
  102a1b:	6a 00                	push   $0x0
  pushl $240
  102a1d:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102a22:	e9 20 f6 ff ff       	jmp    102047 <__alltraps>

00102a27 <vector241>:
.globl vector241
vector241:
  pushl $0
  102a27:	6a 00                	push   $0x0
  pushl $241
  102a29:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102a2e:	e9 14 f6 ff ff       	jmp    102047 <__alltraps>

00102a33 <vector242>:
.globl vector242
vector242:
  pushl $0
  102a33:	6a 00                	push   $0x0
  pushl $242
  102a35:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102a3a:	e9 08 f6 ff ff       	jmp    102047 <__alltraps>

00102a3f <vector243>:
.globl vector243
vector243:
  pushl $0
  102a3f:	6a 00                	push   $0x0
  pushl $243
  102a41:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102a46:	e9 fc f5 ff ff       	jmp    102047 <__alltraps>

00102a4b <vector244>:
.globl vector244
vector244:
  pushl $0
  102a4b:	6a 00                	push   $0x0
  pushl $244
  102a4d:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102a52:	e9 f0 f5 ff ff       	jmp    102047 <__alltraps>

00102a57 <vector245>:
.globl vector245
vector245:
  pushl $0
  102a57:	6a 00                	push   $0x0
  pushl $245
  102a59:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102a5e:	e9 e4 f5 ff ff       	jmp    102047 <__alltraps>

00102a63 <vector246>:
.globl vector246
vector246:
  pushl $0
  102a63:	6a 00                	push   $0x0
  pushl $246
  102a65:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102a6a:	e9 d8 f5 ff ff       	jmp    102047 <__alltraps>

00102a6f <vector247>:
.globl vector247
vector247:
  pushl $0
  102a6f:	6a 00                	push   $0x0
  pushl $247
  102a71:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102a76:	e9 cc f5 ff ff       	jmp    102047 <__alltraps>

00102a7b <vector248>:
.globl vector248
vector248:
  pushl $0
  102a7b:	6a 00                	push   $0x0
  pushl $248
  102a7d:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102a82:	e9 c0 f5 ff ff       	jmp    102047 <__alltraps>

00102a87 <vector249>:
.globl vector249
vector249:
  pushl $0
  102a87:	6a 00                	push   $0x0
  pushl $249
  102a89:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102a8e:	e9 b4 f5 ff ff       	jmp    102047 <__alltraps>

00102a93 <vector250>:
.globl vector250
vector250:
  pushl $0
  102a93:	6a 00                	push   $0x0
  pushl $250
  102a95:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102a9a:	e9 a8 f5 ff ff       	jmp    102047 <__alltraps>

00102a9f <vector251>:
.globl vector251
vector251:
  pushl $0
  102a9f:	6a 00                	push   $0x0
  pushl $251
  102aa1:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102aa6:	e9 9c f5 ff ff       	jmp    102047 <__alltraps>

00102aab <vector252>:
.globl vector252
vector252:
  pushl $0
  102aab:	6a 00                	push   $0x0
  pushl $252
  102aad:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102ab2:	e9 90 f5 ff ff       	jmp    102047 <__alltraps>

00102ab7 <vector253>:
.globl vector253
vector253:
  pushl $0
  102ab7:	6a 00                	push   $0x0
  pushl $253
  102ab9:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102abe:	e9 84 f5 ff ff       	jmp    102047 <__alltraps>

00102ac3 <vector254>:
.globl vector254
vector254:
  pushl $0
  102ac3:	6a 00                	push   $0x0
  pushl $254
  102ac5:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102aca:	e9 78 f5 ff ff       	jmp    102047 <__alltraps>

00102acf <vector255>:
.globl vector255
vector255:
  pushl $0
  102acf:	6a 00                	push   $0x0
  pushl $255
  102ad1:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102ad6:	e9 6c f5 ff ff       	jmp    102047 <__alltraps>

00102adb <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102adb:	55                   	push   %ebp
  102adc:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102ade:	8b 15 a0 ee 11 00    	mov    0x11eea0,%edx
  102ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae7:	29 d0                	sub    %edx,%eax
  102ae9:	c1 f8 02             	sar    $0x2,%eax
  102aec:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102af2:	5d                   	pop    %ebp
  102af3:	c3                   	ret    

00102af4 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102af4:	55                   	push   %ebp
  102af5:	89 e5                	mov    %esp,%ebp
  102af7:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102afa:	8b 45 08             	mov    0x8(%ebp),%eax
  102afd:	89 04 24             	mov    %eax,(%esp)
  102b00:	e8 d6 ff ff ff       	call   102adb <page2ppn>
  102b05:	c1 e0 0c             	shl    $0xc,%eax
}
  102b08:	89 ec                	mov    %ebp,%esp
  102b0a:	5d                   	pop    %ebp
  102b0b:	c3                   	ret    

00102b0c <set_page_ref>:
page_ref(struct Page *page) {
    return page->ref;
}

static inline void
set_page_ref(struct Page *page, int val) {
  102b0c:	55                   	push   %ebp
  102b0d:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b12:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b15:	89 10                	mov    %edx,(%eax)
}
  102b17:	90                   	nop
  102b18:	5d                   	pop    %ebp
  102b19:	c3                   	ret    

00102b1a <buddy_init>:
static unsigned int buddy_page_num;
static unsigned int useable_page_num;
static struct Page* useable_page_base;

static void
buddy_init(void) {
  102b1a:	55                   	push   %ebp
  102b1b:	89 e5                	mov    %esp,%ebp
    /* do nothing */
}
  102b1d:	90                   	nop
  102b1e:	5d                   	pop    %ebp
  102b1f:	c3                   	ret    

00102b20 <buddy_init_memmap>:

static void
buddy_init_memmap(struct Page *base, size_t n) {
  102b20:	55                   	push   %ebp
  102b21:	89 e5                	mov    %esp,%ebp
  102b23:	83 ec 58             	sub    $0x58,%esp
    // 检查参数
    assert((n > 0));// && IS_POWER_OF_2(n)
  102b26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102b2a:	75 24                	jne    102b50 <buddy_init_memmap+0x30>
  102b2c:	c7 44 24 0c b0 74 10 	movl   $0x1074b0,0xc(%esp)
  102b33:	00 
  102b34:	c7 44 24 08 b8 74 10 	movl   $0x1074b8,0x8(%esp)
  102b3b:	00 
  102b3c:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
  102b43:	00 
  102b44:	c7 04 24 cd 74 10 00 	movl   $0x1074cd,(%esp)
  102b4b:	e8 9d e1 ff ff       	call   100ced <__panic>
    // 获得伙伴系统的各参数
    // 可使用内存页数 && 管理内存页数
    useable_page_num = 1;
  102b50:	c7 05 88 ee 11 00 01 	movl   $0x1,0x11ee88
  102b57:	00 00 00 
    for (int i = 1;
  102b5a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  102b61:	eb 0f                	jmp    102b72 <buddy_init_memmap+0x52>
         (i < BUDDY_MAX_DEPTH) && (useable_page_num + (useable_page_num >> 9) < n);
         i++, useable_page_num <<= 1)
  102b63:	ff 45 f4             	incl   -0xc(%ebp)
  102b66:	a1 88 ee 11 00       	mov    0x11ee88,%eax
  102b6b:	01 c0                	add    %eax,%eax
  102b6d:	a3 88 ee 11 00       	mov    %eax,0x11ee88
         (i < BUDDY_MAX_DEPTH) && (useable_page_num + (useable_page_num >> 9) < n);
  102b72:	83 7d f4 1d          	cmpl   $0x1d,-0xc(%ebp)
  102b76:	7f 16                	jg     102b8e <buddy_init_memmap+0x6e>
  102b78:	a1 88 ee 11 00       	mov    0x11ee88,%eax
  102b7d:	c1 e8 09             	shr    $0x9,%eax
  102b80:	89 c2                	mov    %eax,%edx
  102b82:	a1 88 ee 11 00       	mov    0x11ee88,%eax
  102b87:	01 d0                	add    %edx,%eax
  102b89:	39 45 0c             	cmp    %eax,0xc(%ebp)
  102b8c:	77 d5                	ja     102b63 <buddy_init_memmap+0x43>
        /* do nothing */;
    useable_page_num >>= 1;
  102b8e:	a1 88 ee 11 00       	mov    0x11ee88,%eax
  102b93:	d1 e8                	shr    %eax
  102b95:	a3 88 ee 11 00       	mov    %eax,0x11ee88
    buddy_page_num = (useable_page_num >> 9) + 1;
  102b9a:	a1 88 ee 11 00       	mov    0x11ee88,%eax
  102b9f:	c1 e8 09             	shr    $0x9,%eax
  102ba2:	40                   	inc    %eax
  102ba3:	a3 84 ee 11 00       	mov    %eax,0x11ee84
    // 可使用内存页基址
    useable_page_base = base + buddy_page_num;
  102ba8:	8b 15 84 ee 11 00    	mov    0x11ee84,%edx
  102bae:	89 d0                	mov    %edx,%eax
  102bb0:	c1 e0 02             	shl    $0x2,%eax
  102bb3:	01 d0                	add    %edx,%eax
  102bb5:	c1 e0 02             	shl    $0x2,%eax
  102bb8:	89 c2                	mov    %eax,%edx
  102bba:	8b 45 08             	mov    0x8(%ebp),%eax
  102bbd:	01 d0                	add    %edx,%eax
  102bbf:	a3 8c ee 11 00       	mov    %eax,0x11ee8c
    // 初始化所有页权限
    for (int i = 0; i != buddy_page_num; i++){
  102bc4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102bcb:	eb 2e                	jmp    102bfb <buddy_init_memmap+0xdb>
        SetPageReserved(base + i);
  102bcd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102bd0:	89 d0                	mov    %edx,%eax
  102bd2:	c1 e0 02             	shl    $0x2,%eax
  102bd5:	01 d0                	add    %edx,%eax
  102bd7:	c1 e0 02             	shl    $0x2,%eax
  102bda:	89 c2                	mov    %eax,%edx
  102bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  102bdf:	01 d0                	add    %edx,%eax
  102be1:	83 c0 04             	add    $0x4,%eax
  102be4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  102beb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102bee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102bf1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102bf4:	0f ab 10             	bts    %edx,(%eax)
}
  102bf7:	90                   	nop
    for (int i = 0; i != buddy_page_num; i++){
  102bf8:	ff 45 f0             	incl   -0x10(%ebp)
  102bfb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102bfe:	a1 84 ee 11 00       	mov    0x11ee84,%eax
  102c03:	39 c2                	cmp    %eax,%edx
  102c05:	75 c6                	jne    102bcd <buddy_init_memmap+0xad>
    }
    for (int i = buddy_page_num; i != n; i++){
  102c07:	a1 84 ee 11 00       	mov    0x11ee84,%eax
  102c0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102c0f:	eb 7d                	jmp    102c8e <buddy_init_memmap+0x16e>
        ClearPageReserved(base + i);
  102c11:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c14:	89 d0                	mov    %edx,%eax
  102c16:	c1 e0 02             	shl    $0x2,%eax
  102c19:	01 d0                	add    %edx,%eax
  102c1b:	c1 e0 02             	shl    $0x2,%eax
  102c1e:	89 c2                	mov    %eax,%edx
  102c20:	8b 45 08             	mov    0x8(%ebp),%eax
  102c23:	01 d0                	add    %edx,%eax
  102c25:	83 c0 04             	add    $0x4,%eax
  102c28:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  102c2f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102c32:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102c35:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102c38:	0f b3 10             	btr    %edx,(%eax)
}
  102c3b:	90                   	nop
        SetPageProperty(base + i);
  102c3c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c3f:	89 d0                	mov    %edx,%eax
  102c41:	c1 e0 02             	shl    $0x2,%eax
  102c44:	01 d0                	add    %edx,%eax
  102c46:	c1 e0 02             	shl    $0x2,%eax
  102c49:	89 c2                	mov    %eax,%edx
  102c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c4e:	01 d0                	add    %edx,%eax
  102c50:	83 c0 04             	add    $0x4,%eax
  102c53:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  102c5a:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102c5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102c60:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102c63:	0f ab 10             	bts    %edx,(%eax)
}
  102c66:	90                   	nop
        set_page_ref(base + i, 0);
  102c67:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c6a:	89 d0                	mov    %edx,%eax
  102c6c:	c1 e0 02             	shl    $0x2,%eax
  102c6f:	01 d0                	add    %edx,%eax
  102c71:	c1 e0 02             	shl    $0x2,%eax
  102c74:	89 c2                	mov    %eax,%edx
  102c76:	8b 45 08             	mov    0x8(%ebp),%eax
  102c79:	01 d0                	add    %edx,%eax
  102c7b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102c82:	00 
  102c83:	89 04 24             	mov    %eax,(%esp)
  102c86:	e8 81 fe ff ff       	call   102b0c <set_page_ref>
    for (int i = buddy_page_num; i != n; i++){
  102c8b:	ff 45 ec             	incl   -0x14(%ebp)
  102c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c91:	39 45 0c             	cmp    %eax,0xc(%ebp)
  102c94:	0f 85 77 ff ff ff    	jne    102c11 <buddy_init_memmap+0xf1>
    }
    // 初始化管理页 (自底向上)
    buddy_page = (unsigned int*)KADDR(page2pa(base));
  102c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9d:	89 04 24             	mov    %eax,(%esp)
  102ca0:	e8 4f fe ff ff       	call   102af4 <page2pa>
  102ca5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102ca8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cab:	c1 e8 0c             	shr    $0xc,%eax
  102cae:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102cb1:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  102cb6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102cb9:	72 23                	jb     102cde <buddy_init_memmap+0x1be>
  102cbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cbe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102cc2:	c7 44 24 08 e4 74 10 	movl   $0x1074e4,0x8(%esp)
  102cc9:	00 
  102cca:	c7 44 24 04 31 00 00 	movl   $0x31,0x4(%esp)
  102cd1:	00 
  102cd2:	c7 04 24 cd 74 10 00 	movl   $0x1074cd,(%esp)
  102cd9:	e8 0f e0 ff ff       	call   100ced <__panic>
  102cde:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ce1:	2d 00 00 00 40       	sub    $0x40000000,%eax
  102ce6:	a3 80 ee 11 00       	mov    %eax,0x11ee80
    for (int i = useable_page_num; i < useable_page_num << 1; i++){
  102ceb:	a1 88 ee 11 00       	mov    0x11ee88,%eax
  102cf0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102cf3:	eb 17                	jmp    102d0c <buddy_init_memmap+0x1ec>
        buddy_page[i] = 1;
  102cf5:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  102cfb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102cfe:	c1 e0 02             	shl    $0x2,%eax
  102d01:	01 d0                	add    %edx,%eax
  102d03:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    for (int i = useable_page_num; i < useable_page_num << 1; i++){
  102d09:	ff 45 e8             	incl   -0x18(%ebp)
  102d0c:	a1 88 ee 11 00       	mov    0x11ee88,%eax
  102d11:	8d 14 00             	lea    (%eax,%eax,1),%edx
  102d14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d17:	39 c2                	cmp    %eax,%edx
  102d19:	77 da                	ja     102cf5 <buddy_init_memmap+0x1d5>
    }
    for (int i = useable_page_num - 1; i > 0; i--){
  102d1b:	a1 88 ee 11 00       	mov    0x11ee88,%eax
  102d20:	48                   	dec    %eax
  102d21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102d24:	eb 27                	jmp    102d4d <buddy_init_memmap+0x22d>
        buddy_page[i] = buddy_page[i << 1] << 1;
  102d26:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  102d2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d2f:	01 c0                	add    %eax,%eax
  102d31:	c1 e0 02             	shl    $0x2,%eax
  102d34:	01 d0                	add    %edx,%eax
  102d36:	8b 10                	mov    (%eax),%edx
  102d38:	8b 0d 80 ee 11 00    	mov    0x11ee80,%ecx
  102d3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d41:	c1 e0 02             	shl    $0x2,%eax
  102d44:	01 c8                	add    %ecx,%eax
  102d46:	01 d2                	add    %edx,%edx
  102d48:	89 10                	mov    %edx,(%eax)
    for (int i = useable_page_num - 1; i > 0; i--){
  102d4a:	ff 4d e4             	decl   -0x1c(%ebp)
  102d4d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d51:	7f d3                	jg     102d26 <buddy_init_memmap+0x206>
    }
    // 输出信息
    cprintf("buddy init: Total %d, Buddy %d, Useable %d\n",
  102d53:	8b 15 88 ee 11 00    	mov    0x11ee88,%edx
  102d59:	a1 84 ee 11 00       	mov    0x11ee84,%eax
  102d5e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102d62:	89 44 24 08          	mov    %eax,0x8(%esp)
  102d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d69:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d6d:	c7 04 24 08 75 10 00 	movl   $0x107508,(%esp)
  102d74:	e8 e8 d5 ff ff       	call   100361 <cprintf>
            n, buddy_page_num, useable_page_num);
}
  102d79:	90                   	nop
  102d7a:	89 ec                	mov    %ebp,%esp
  102d7c:	5d                   	pop    %ebp
  102d7d:	c3                   	ret    

00102d7e <buddy_alloc_pages>:

static struct
Page* buddy_alloc_pages(size_t n) {
  102d7e:	55                   	push   %ebp
  102d7f:	89 e5                	mov    %esp,%ebp
  102d81:	83 ec 38             	sub    $0x38,%esp
  102d84:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // 检查参数
    assert(n > 0);
  102d87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102d8b:	75 24                	jne    102db1 <buddy_alloc_pages+0x33>
  102d8d:	c7 44 24 0c 34 75 10 	movl   $0x107534,0xc(%esp)
  102d94:	00 
  102d95:	c7 44 24 08 b8 74 10 	movl   $0x1074b8,0x8(%esp)
  102d9c:	00 
  102d9d:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  102da4:	00 
  102da5:	c7 04 24 cd 74 10 00 	movl   $0x1074cd,(%esp)
  102dac:	e8 3c df ff ff       	call   100ced <__panic>
    // 需要的页数太大, 返回NULL(分配失败)
    if (n > buddy_page[1]){
  102db1:	a1 80 ee 11 00       	mov    0x11ee80,%eax
  102db6:	83 c0 04             	add    $0x4,%eax
  102db9:	8b 00                	mov    (%eax),%eax
  102dbb:	39 45 08             	cmp    %eax,0x8(%ebp)
  102dbe:	76 0a                	jbe    102dca <buddy_alloc_pages+0x4c>
        return NULL;
  102dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  102dc5:	e9 2d 01 00 00       	jmp    102ef7 <buddy_alloc_pages+0x179>
    }
    // 找到需要的页区
    unsigned int index = 1;
  102dca:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    while(1){
        if (buddy_page[LEFT_CHILD(index)] >= n){
  102dd1:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  102dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dda:	c1 e0 03             	shl    $0x3,%eax
  102ddd:	01 d0                	add    %edx,%eax
  102ddf:	8b 00                	mov    (%eax),%eax
  102de1:	39 45 08             	cmp    %eax,0x8(%ebp)
  102de4:	77 05                	ja     102deb <buddy_alloc_pages+0x6d>
            index = LEFT_CHILD(index);
  102de6:	d1 65 f4             	shll   -0xc(%ebp)
  102de9:	eb e6                	jmp    102dd1 <buddy_alloc_pages+0x53>
        }
        else if (buddy_page[RIGHT_CHILD(index)] >= n){
  102deb:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  102df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102df4:	c1 e0 03             	shl    $0x3,%eax
  102df7:	83 c0 04             	add    $0x4,%eax
  102dfa:	01 d0                	add    %edx,%eax
  102dfc:	8b 00                	mov    (%eax),%eax
  102dfe:	39 45 08             	cmp    %eax,0x8(%ebp)
  102e01:	77 0b                	ja     102e0e <buddy_alloc_pages+0x90>
            index = RIGHT_CHILD(index);
  102e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e06:	01 c0                	add    %eax,%eax
  102e08:	40                   	inc    %eax
  102e09:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (buddy_page[LEFT_CHILD(index)] >= n){
  102e0c:	eb c3                	jmp    102dd1 <buddy_alloc_pages+0x53>
        }
        else{
            break;
  102e0e:	90                   	nop
        }
    }
    // 分配
    unsigned int size = buddy_page[index];
  102e0f:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  102e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e18:	c1 e0 02             	shl    $0x2,%eax
  102e1b:	01 d0                	add    %edx,%eax
  102e1d:	8b 00                	mov    (%eax),%eax
  102e1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    buddy_page[index] = 0;
  102e22:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  102e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e2b:	c1 e0 02             	shl    $0x2,%eax
  102e2e:	01 d0                	add    %edx,%eax
  102e30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            ..............
         *    *       *    *
        / \  / \ ... / \  / \
       *  * *  *    *  * *  *
    */
    struct Page* new_page = &useable_page_base[index * size - useable_page_num];
  102e36:	8b 0d 8c ee 11 00    	mov    0x11ee8c,%ecx
  102e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e3f:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  102e43:	8b 1d 88 ee 11 00    	mov    0x11ee88,%ebx
  102e49:	29 d8                	sub    %ebx,%eax
  102e4b:	89 c2                	mov    %eax,%edx
  102e4d:	89 d0                	mov    %edx,%eax
  102e4f:	c1 e0 02             	shl    $0x2,%eax
  102e52:	01 d0                	add    %edx,%eax
  102e54:	c1 e0 02             	shl    $0x2,%eax
  102e57:	01 c8                	add    %ecx,%eax
  102e59:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for (struct Page* p = new_page; p != new_page + size; p++){
  102e5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e62:	eb 31                	jmp    102e95 <buddy_alloc_pages+0x117>
        ClearPageProperty(p);
  102e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e67:	83 c0 04             	add    $0x4,%eax
  102e6a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102e71:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102e74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102e7a:	0f b3 10             	btr    %edx,(%eax)
}
  102e7d:	90                   	nop
        set_page_ref(p, 0);
  102e7e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102e85:	00 
  102e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e89:	89 04 24             	mov    %eax,(%esp)
  102e8c:	e8 7b fc ff ff       	call   102b0c <set_page_ref>
    for (struct Page* p = new_page; p != new_page + size; p++){
  102e91:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
  102e95:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102e98:	89 d0                	mov    %edx,%eax
  102e9a:	c1 e0 02             	shl    $0x2,%eax
  102e9d:	01 d0                	add    %edx,%eax
  102e9f:	c1 e0 02             	shl    $0x2,%eax
  102ea2:	89 c2                	mov    %eax,%edx
  102ea4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ea7:	01 d0                	add    %edx,%eax
  102ea9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102eac:	75 b6                	jne    102e64 <buddy_alloc_pages+0xe6>
    }
    // 更新上方节点
    index = PARENT(index);
  102eae:	d1 6d f4             	shrl   -0xc(%ebp)
    while(index > 0){
  102eb1:	eb 3b                	jmp    102eee <buddy_alloc_pages+0x170>
        buddy_page[index] = MAX(buddy_page[LEFT_CHILD(index)], buddy_page[RIGHT_CHILD(index)]);
  102eb3:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  102eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ebc:	c1 e0 03             	shl    $0x3,%eax
  102ebf:	83 c0 04             	add    $0x4,%eax
  102ec2:	01 d0                	add    %edx,%eax
  102ec4:	8b 10                	mov    (%eax),%edx
  102ec6:	8b 0d 80 ee 11 00    	mov    0x11ee80,%ecx
  102ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ecf:	c1 e0 03             	shl    $0x3,%eax
  102ed2:	01 c8                	add    %ecx,%eax
  102ed4:	8b 00                	mov    (%eax),%eax
  102ed6:	8b 1d 80 ee 11 00    	mov    0x11ee80,%ebx
  102edc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  102edf:	c1 e1 02             	shl    $0x2,%ecx
  102ee2:	01 d9                	add    %ebx,%ecx
  102ee4:	39 c2                	cmp    %eax,%edx
  102ee6:	0f 43 c2             	cmovae %edx,%eax
  102ee9:	89 01                	mov    %eax,(%ecx)
        index = PARENT(index);
  102eeb:	d1 6d f4             	shrl   -0xc(%ebp)
    while(index > 0){
  102eee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102ef2:	75 bf                	jne    102eb3 <buddy_alloc_pages+0x135>
    }
    // 返回分配到的page
    return new_page;
  102ef4:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  102ef7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  102efa:	89 ec                	mov    %ebp,%esp
  102efc:	5d                   	pop    %ebp
  102efd:	c3                   	ret    

00102efe <buddy_free_pages>:

static void
buddy_free_pages(struct Page *base, size_t n) {
  102efe:	55                   	push   %ebp
  102eff:	89 e5                	mov    %esp,%ebp
  102f01:	83 ec 48             	sub    $0x48,%esp
  102f04:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // 检查参数
    assert(n > 0);
  102f07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f0b:	75 24                	jne    102f31 <buddy_free_pages+0x33>
  102f0d:	c7 44 24 0c 34 75 10 	movl   $0x107534,0xc(%esp)
  102f14:	00 
  102f15:	c7 44 24 08 b8 74 10 	movl   $0x1074b8,0x8(%esp)
  102f1c:	00 
  102f1d:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  102f24:	00 
  102f25:	c7 04 24 cd 74 10 00 	movl   $0x1074cd,(%esp)
  102f2c:	e8 bc dd ff ff       	call   100ced <__panic>
    // 释放
    for (struct Page *p = base; p != base + n; p++) {
  102f31:	8b 45 08             	mov    0x8(%ebp),%eax
  102f34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f37:	e9 ad 00 00 00       	jmp    102fe9 <buddy_free_pages+0xeb>
        assert(!PageReserved(p) && !PageProperty(p));
  102f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f3f:	83 c0 04             	add    $0x4,%eax
  102f42:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  102f49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102f4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102f4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102f52:	0f a3 10             	bt     %edx,(%eax)
  102f55:	19 c0                	sbb    %eax,%eax
  102f57:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
  102f5a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  102f5e:	0f 95 c0             	setne  %al
  102f61:	0f b6 c0             	movzbl %al,%eax
  102f64:	85 c0                	test   %eax,%eax
  102f66:	75 2c                	jne    102f94 <buddy_free_pages+0x96>
  102f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f6b:	83 c0 04             	add    $0x4,%eax
  102f6e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  102f75:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102f78:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102f7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f7e:	0f a3 10             	bt     %edx,(%eax)
  102f81:	19 c0                	sbb    %eax,%eax
  102f83:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
  102f86:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  102f8a:	0f 95 c0             	setne  %al
  102f8d:	0f b6 c0             	movzbl %al,%eax
  102f90:	85 c0                	test   %eax,%eax
  102f92:	74 24                	je     102fb8 <buddy_free_pages+0xba>
  102f94:	c7 44 24 0c 3c 75 10 	movl   $0x10753c,0xc(%esp)
  102f9b:	00 
  102f9c:	c7 44 24 08 b8 74 10 	movl   $0x1074b8,0x8(%esp)
  102fa3:	00 
  102fa4:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
  102fab:	00 
  102fac:	c7 04 24 cd 74 10 00 	movl   $0x1074cd,(%esp)
  102fb3:	e8 35 dd ff ff       	call   100ced <__panic>
        SetPageProperty(p);
  102fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fbb:	83 c0 04             	add    $0x4,%eax
  102fbe:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  102fc5:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102fc8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102fcb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102fce:	0f ab 10             	bts    %edx,(%eax)
}
  102fd1:	90                   	nop
        set_page_ref(p, 0);
  102fd2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102fd9:	00 
  102fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fdd:	89 04 24             	mov    %eax,(%esp)
  102fe0:	e8 27 fb ff ff       	call   102b0c <set_page_ref>
    for (struct Page *p = base; p != base + n; p++) {
  102fe5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102fe9:	8b 55 0c             	mov    0xc(%ebp),%edx
  102fec:	89 d0                	mov    %edx,%eax
  102fee:	c1 e0 02             	shl    $0x2,%eax
  102ff1:	01 d0                	add    %edx,%eax
  102ff3:	c1 e0 02             	shl    $0x2,%eax
  102ff6:	89 c2                	mov    %eax,%edx
  102ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  102ffb:	01 d0                	add    %edx,%eax
  102ffd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103000:	0f 85 36 ff ff ff    	jne    102f3c <buddy_free_pages+0x3e>
    }
    // 维护
    unsigned int index = useable_page_num + (unsigned int)(base - useable_page_base), size = 1;
  103006:	8b 15 8c ee 11 00    	mov    0x11ee8c,%edx
  10300c:	8b 45 08             	mov    0x8(%ebp),%eax
  10300f:	29 d0                	sub    %edx,%eax
  103011:	c1 f8 02             	sar    $0x2,%eax
  103014:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
  10301a:	89 c2                	mov    %eax,%edx
  10301c:	a1 88 ee 11 00       	mov    0x11ee88,%eax
  103021:	01 d0                	add    %edx,%eax
  103023:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103026:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
    while(buddy_page[index] > 0){
  10302d:	eb 06                	jmp    103035 <buddy_free_pages+0x137>
        index=PARENT(index);
  10302f:	d1 6d f0             	shrl   -0x10(%ebp)
        size <<= 1;
  103032:	d1 65 ec             	shll   -0x14(%ebp)
    while(buddy_page[index] > 0){
  103035:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  10303b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10303e:	c1 e0 02             	shl    $0x2,%eax
  103041:	01 d0                	add    %edx,%eax
  103043:	8b 00                	mov    (%eax),%eax
  103045:	85 c0                	test   %eax,%eax
  103047:	75 e6                	jne    10302f <buddy_free_pages+0x131>
    }
    buddy_page[index] = size;
  103049:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  10304f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103052:	c1 e0 02             	shl    $0x2,%eax
  103055:	01 c2                	add    %eax,%edx
  103057:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10305a:	89 02                	mov    %eax,(%edx)
    while((index = PARENT(index)) > 0){
  10305c:	eb 7a                	jmp    1030d8 <buddy_free_pages+0x1da>
        size <<= 1;
  10305e:	d1 65 ec             	shll   -0x14(%ebp)
        if(buddy_page[LEFT_CHILD(index)] + buddy_page[RIGHT_CHILD(index)] == size){
  103061:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  103067:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10306a:	c1 e0 03             	shl    $0x3,%eax
  10306d:	01 d0                	add    %edx,%eax
  10306f:	8b 10                	mov    (%eax),%edx
  103071:	8b 0d 80 ee 11 00    	mov    0x11ee80,%ecx
  103077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10307a:	c1 e0 03             	shl    $0x3,%eax
  10307d:	83 c0 04             	add    $0x4,%eax
  103080:	01 c8                	add    %ecx,%eax
  103082:	8b 00                	mov    (%eax),%eax
  103084:	01 d0                	add    %edx,%eax
  103086:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103089:	75 15                	jne    1030a0 <buddy_free_pages+0x1a2>
            buddy_page[index] = size;
  10308b:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  103091:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103094:	c1 e0 02             	shl    $0x2,%eax
  103097:	01 c2                	add    %eax,%edx
  103099:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10309c:	89 02                	mov    %eax,(%edx)
  10309e:	eb 38                	jmp    1030d8 <buddy_free_pages+0x1da>
        }
        else{
            buddy_page[index] = MAX(buddy_page[LEFT_CHILD(index)], buddy_page[RIGHT_CHILD(index)]);
  1030a0:	8b 15 80 ee 11 00    	mov    0x11ee80,%edx
  1030a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030a9:	c1 e0 03             	shl    $0x3,%eax
  1030ac:	83 c0 04             	add    $0x4,%eax
  1030af:	01 d0                	add    %edx,%eax
  1030b1:	8b 10                	mov    (%eax),%edx
  1030b3:	8b 0d 80 ee 11 00    	mov    0x11ee80,%ecx
  1030b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030bc:	c1 e0 03             	shl    $0x3,%eax
  1030bf:	01 c8                	add    %ecx,%eax
  1030c1:	8b 00                	mov    (%eax),%eax
  1030c3:	8b 1d 80 ee 11 00    	mov    0x11ee80,%ebx
  1030c9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1030cc:	c1 e1 02             	shl    $0x2,%ecx
  1030cf:	01 d9                	add    %ebx,%ecx
  1030d1:	39 c2                	cmp    %eax,%edx
  1030d3:	0f 43 c2             	cmovae %edx,%eax
  1030d6:	89 01                	mov    %eax,(%ecx)
    while((index = PARENT(index)) > 0){
  1030d8:	d1 6d f0             	shrl   -0x10(%ebp)
  1030db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1030df:	0f 85 79 ff ff ff    	jne    10305e <buddy_free_pages+0x160>
        }
    }
}
  1030e5:	90                   	nop
  1030e6:	90                   	nop
  1030e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1030ea:	89 ec                	mov    %ebp,%esp
  1030ec:	5d                   	pop    %ebp
  1030ed:	c3                   	ret    

001030ee <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void) {
  1030ee:	55                   	push   %ebp
  1030ef:	89 e5                	mov    %esp,%ebp
    return buddy_page[1];
  1030f1:	a1 80 ee 11 00       	mov    0x11ee80,%eax
  1030f6:	83 c0 04             	add    $0x4,%eax
  1030f9:	8b 00                	mov    (%eax),%eax
}
  1030fb:	5d                   	pop    %ebp
  1030fc:	c3                   	ret    

001030fd <buddy_check>:

static void
buddy_check(void) {
  1030fd:	55                   	push   %ebp
  1030fe:	89 e5                	mov    %esp,%ebp
  103100:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int all_pages = nr_free_pages();
  103106:	e8 f9 1a 00 00       	call   104c04 <nr_free_pages>
  10310b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    struct Page* p0, *p1, *p2, *p3;
    // 分配过大的页数
    assert(alloc_pages(all_pages + 1) == NULL);
  10310e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103111:	40                   	inc    %eax
  103112:	89 04 24             	mov    %eax,(%esp)
  103115:	e8 7b 1a 00 00       	call   104b95 <alloc_pages>
  10311a:	85 c0                	test   %eax,%eax
  10311c:	74 24                	je     103142 <buddy_check+0x45>
  10311e:	c7 44 24 0c 64 75 10 	movl   $0x107564,0xc(%esp)
  103125:	00 
  103126:	c7 44 24 08 b8 74 10 	movl   $0x1074b8,0x8(%esp)
  10312d:	00 
  10312e:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
  103135:	00 
  103136:	c7 04 24 cd 74 10 00 	movl   $0x1074cd,(%esp)
  10313d:	e8 ab db ff ff       	call   100ced <__panic>
    // 分配两个组页
    p0 = alloc_pages(1);
  103142:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103149:	e8 47 1a 00 00       	call   104b95 <alloc_pages>
  10314e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(p0 != NULL);
  103151:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103155:	75 24                	jne    10317b <buddy_check+0x7e>
  103157:	c7 44 24 0c 87 75 10 	movl   $0x107587,0xc(%esp)
  10315e:	00 
  10315f:	c7 44 24 08 b8 74 10 	movl   $0x1074b8,0x8(%esp)
  103166:	00 
  103167:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
  10316e:	00 
  10316f:	c7 04 24 cd 74 10 00 	movl   $0x1074cd,(%esp)
  103176:	e8 72 db ff ff       	call   100ced <__panic>
    p1 = alloc_pages(2);
  10317b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103182:	e8 0e 1a 00 00       	call   104b95 <alloc_pages>
  103187:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(p1 == p0 + 2);
  10318a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10318d:	83 c0 28             	add    $0x28,%eax
  103190:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103193:	74 24                	je     1031b9 <buddy_check+0xbc>
  103195:	c7 44 24 0c 92 75 10 	movl   $0x107592,0xc(%esp)
  10319c:	00 
  10319d:	c7 44 24 08 b8 74 10 	movl   $0x1074b8,0x8(%esp)
  1031a4:	00 
  1031a5:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
  1031ac:	00 
  1031ad:	c7 04 24 cd 74 10 00 	movl   $0x1074cd,(%esp)
  1031b4:	e8 34 db ff ff       	call   100ced <__panic>
    assert(!PageReserved(p0) && !PageProperty(p0));
  1031b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031bc:	83 c0 04             	add    $0x4,%eax
  1031bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  1031c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1031c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1031cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1031cf:	0f a3 10             	bt     %edx,(%eax)
  1031d2:	19 c0                	sbb    %eax,%eax
  1031d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  1031d7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  1031db:	0f 95 c0             	setne  %al
  1031de:	0f b6 c0             	movzbl %al,%eax
  1031e1:	85 c0                	test   %eax,%eax
  1031e3:	75 2c                	jne    103211 <buddy_check+0x114>
  1031e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031e8:	83 c0 04             	add    $0x4,%eax
  1031eb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  1031f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1031f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1031f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1031fb:	0f a3 10             	bt     %edx,(%eax)
  1031fe:	19 c0                	sbb    %eax,%eax
  103200:	89 45 cc             	mov    %eax,-0x34(%ebp)
    return oldbit != 0;
  103203:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103207:	0f 95 c0             	setne  %al
  10320a:	0f b6 c0             	movzbl %al,%eax
  10320d:	85 c0                	test   %eax,%eax
  10320f:	74 24                	je     103235 <buddy_check+0x138>
  103211:	c7 44 24 0c a0 75 10 	movl   $0x1075a0,0xc(%esp)
  103218:	00 
  103219:	c7 44 24 08 b8 74 10 	movl   $0x1074b8,0x8(%esp)
  103220:	00 
  103221:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  103228:	00 
  103229:	c7 04 24 cd 74 10 00 	movl   $0x1074cd,(%esp)
  103230:	e8 b8 da ff ff       	call   100ced <__panic>
    assert(!PageReserved(p1) && !PageProperty(p1));
  103235:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103238:	83 c0 04             	add    $0x4,%eax
  10323b:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  103242:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103245:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103248:	8b 55 c8             	mov    -0x38(%ebp),%edx
  10324b:	0f a3 10             	bt     %edx,(%eax)
  10324e:	19 c0                	sbb    %eax,%eax
  103250:	89 45 c0             	mov    %eax,-0x40(%ebp)
    return oldbit != 0;
  103253:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  103257:	0f 95 c0             	setne  %al
  10325a:	0f b6 c0             	movzbl %al,%eax
  10325d:	85 c0                	test   %eax,%eax
  10325f:	75 2c                	jne    10328d <buddy_check+0x190>
  103261:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103264:	83 c0 04             	add    $0x4,%eax
  103267:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  10326e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103271:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103274:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103277:	0f a3 10             	bt     %edx,(%eax)
  10327a:	19 c0                	sbb    %eax,%eax
  10327c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return oldbit != 0;
  10327f:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  103283:	0f 95 c0             	setne  %al
  103286:	0f b6 c0             	movzbl %al,%eax
  103289:	85 c0                	test   %eax,%eax
  10328b:	74 24                	je     1032b1 <buddy_check+0x1b4>
  10328d:	c7 44 24 0c c8 75 10 	movl   $0x1075c8,0xc(%esp)
  103294:	00 
  103295:	c7 44 24 08 b8 74 10 	movl   $0x1074b8,0x8(%esp)
  10329c:	00 
  10329d:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  1032a4:	00 
  1032a5:	c7 04 24 cd 74 10 00 	movl   $0x1074cd,(%esp)
  1032ac:	e8 3c da ff ff       	call   100ced <__panic>
    // 再分配两个组页
    p2 = alloc_pages(1);
  1032b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032b8:	e8 d8 18 00 00       	call   104b95 <alloc_pages>
  1032bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p2 == p0 + 1);
  1032c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032c3:	83 c0 14             	add    $0x14,%eax
  1032c6:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1032c9:	74 24                	je     1032ef <buddy_check+0x1f2>
  1032cb:	c7 44 24 0c ef 75 10 	movl   $0x1075ef,0xc(%esp)
  1032d2:	00 
  1032d3:	c7 44 24 08 b8 74 10 	movl   $0x1074b8,0x8(%esp)
  1032da:	00 
  1032db:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  1032e2:	00 
  1032e3:	c7 04 24 cd 74 10 00 	movl   $0x1074cd,(%esp)
  1032ea:	e8 fe d9 ff ff       	call   100ced <__panic>
    p3 = alloc_pages(8);
  1032ef:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1032f6:	e8 9a 18 00 00       	call   104b95 <alloc_pages>
  1032fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p3 == p0 + 8);
  1032fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103301:	05 a0 00 00 00       	add    $0xa0,%eax
  103306:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103309:	74 24                	je     10332f <buddy_check+0x232>
  10330b:	c7 44 24 0c fc 75 10 	movl   $0x1075fc,0xc(%esp)
  103312:	00 
  103313:	c7 44 24 08 b8 74 10 	movl   $0x1074b8,0x8(%esp)
  10331a:	00 
  10331b:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
  103322:	00 
  103323:	c7 04 24 cd 74 10 00 	movl   $0x1074cd,(%esp)
  10332a:	e8 be d9 ff ff       	call   100ced <__panic>
    assert(!PageProperty(p3) && !PageProperty(p3 + 7) && PageProperty(p3 + 8));
  10332f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103332:	83 c0 04             	add    $0x4,%eax
  103335:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  10333c:	89 45 ac             	mov    %eax,-0x54(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10333f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103342:	8b 55 b0             	mov    -0x50(%ebp),%edx
  103345:	0f a3 10             	bt     %edx,(%eax)
  103348:	19 c0                	sbb    %eax,%eax
  10334a:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
  10334d:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
  103351:	0f 95 c0             	setne  %al
  103354:	0f b6 c0             	movzbl %al,%eax
  103357:	85 c0                	test   %eax,%eax
  103359:	75 62                	jne    1033bd <buddy_check+0x2c0>
  10335b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10335e:	05 8c 00 00 00       	add    $0x8c,%eax
  103363:	83 c0 04             	add    $0x4,%eax
  103366:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  10336d:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103370:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103373:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  103376:	0f a3 10             	bt     %edx,(%eax)
  103379:	19 c0                	sbb    %eax,%eax
  10337b:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return oldbit != 0;
  10337e:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  103382:	0f 95 c0             	setne  %al
  103385:	0f b6 c0             	movzbl %al,%eax
  103388:	85 c0                	test   %eax,%eax
  10338a:	75 31                	jne    1033bd <buddy_check+0x2c0>
  10338c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10338f:	05 a0 00 00 00       	add    $0xa0,%eax
  103394:	83 c0 04             	add    $0x4,%eax
  103397:	c7 45 98 01 00 00 00 	movl   $0x1,-0x68(%ebp)
  10339e:	89 45 94             	mov    %eax,-0x6c(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1033a1:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1033a4:	8b 55 98             	mov    -0x68(%ebp),%edx
  1033a7:	0f a3 10             	bt     %edx,(%eax)
  1033aa:	19 c0                	sbb    %eax,%eax
  1033ac:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
  1033af:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
  1033b3:	0f 95 c0             	setne  %al
  1033b6:	0f b6 c0             	movzbl %al,%eax
  1033b9:	85 c0                	test   %eax,%eax
  1033bb:	75 24                	jne    1033e1 <buddy_check+0x2e4>
  1033bd:	c7 44 24 0c 0c 76 10 	movl   $0x10760c,0xc(%esp)
  1033c4:	00 
  1033c5:	c7 44 24 08 b8 74 10 	movl   $0x1074b8,0x8(%esp)
  1033cc:	00 
  1033cd:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
  1033d4:	00 
  1033d5:	c7 04 24 cd 74 10 00 	movl   $0x1074cd,(%esp)
  1033dc:	e8 0c d9 ff ff       	call   100ced <__panic>
    // 回收页
    free_pages(p1, 2);
  1033e1:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1033e8:	00 
  1033e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033ec:	89 04 24             	mov    %eax,(%esp)
  1033ef:	e8 db 17 00 00       	call   104bcf <free_pages>
    assert(PageProperty(p1) && PageProperty(p1 + 1));
  1033f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033f7:	83 c0 04             	add    $0x4,%eax
  1033fa:	c7 45 8c 01 00 00 00 	movl   $0x1,-0x74(%ebp)
  103401:	89 45 88             	mov    %eax,-0x78(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103404:	8b 45 88             	mov    -0x78(%ebp),%eax
  103407:	8b 55 8c             	mov    -0x74(%ebp),%edx
  10340a:	0f a3 10             	bt     %edx,(%eax)
  10340d:	19 c0                	sbb    %eax,%eax
  10340f:	89 45 84             	mov    %eax,-0x7c(%ebp)
    return oldbit != 0;
  103412:	83 7d 84 00          	cmpl   $0x0,-0x7c(%ebp)
  103416:	0f 95 c0             	setne  %al
  103419:	0f b6 c0             	movzbl %al,%eax
  10341c:	85 c0                	test   %eax,%eax
  10341e:	74 3b                	je     10345b <buddy_check+0x35e>
  103420:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103423:	83 c0 14             	add    $0x14,%eax
  103426:	83 c0 04             	add    $0x4,%eax
  103429:	c7 45 80 01 00 00 00 	movl   $0x1,-0x80(%ebp)
  103430:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103436:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  10343c:	8b 55 80             	mov    -0x80(%ebp),%edx
  10343f:	0f a3 10             	bt     %edx,(%eax)
  103442:	19 c0                	sbb    %eax,%eax
  103444:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
    return oldbit != 0;
  10344a:	83 bd 78 ff ff ff 00 	cmpl   $0x0,-0x88(%ebp)
  103451:	0f 95 c0             	setne  %al
  103454:	0f b6 c0             	movzbl %al,%eax
  103457:	85 c0                	test   %eax,%eax
  103459:	75 24                	jne    10347f <buddy_check+0x382>
  10345b:	c7 44 24 0c 50 76 10 	movl   $0x107650,0xc(%esp)
  103462:	00 
  103463:	c7 44 24 08 b8 74 10 	movl   $0x1074b8,0x8(%esp)
  10346a:	00 
  10346b:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
  103472:	00 
  103473:	c7 04 24 cd 74 10 00 	movl   $0x1074cd,(%esp)
  10347a:	e8 6e d8 ff ff       	call   100ced <__panic>
    assert(p1->ref == 0);
  10347f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103482:	8b 00                	mov    (%eax),%eax
  103484:	85 c0                	test   %eax,%eax
  103486:	74 24                	je     1034ac <buddy_check+0x3af>
  103488:	c7 44 24 0c 79 76 10 	movl   $0x107679,0xc(%esp)
  10348f:	00 
  103490:	c7 44 24 08 b8 74 10 	movl   $0x1074b8,0x8(%esp)
  103497:	00 
  103498:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
  10349f:	00 
  1034a0:	c7 04 24 cd 74 10 00 	movl   $0x1074cd,(%esp)
  1034a7:	e8 41 d8 ff ff       	call   100ced <__panic>
    free_pages(p0, 1);
  1034ac:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1034b3:	00 
  1034b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034b7:	89 04 24             	mov    %eax,(%esp)
  1034ba:	e8 10 17 00 00       	call   104bcf <free_pages>
    free_pages(p2, 1);
  1034bf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1034c6:	00 
  1034c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034ca:	89 04 24             	mov    %eax,(%esp)
  1034cd:	e8 fd 16 00 00       	call   104bcf <free_pages>
    // 回收后再分配
    p2 = alloc_pages(3);
  1034d2:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  1034d9:	e8 b7 16 00 00       	call   104b95 <alloc_pages>
  1034de:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p2 == p0);
  1034e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1034e7:	74 24                	je     10350d <buddy_check+0x410>
  1034e9:	c7 44 24 0c 86 76 10 	movl   $0x107686,0xc(%esp)
  1034f0:	00 
  1034f1:	c7 44 24 08 b8 74 10 	movl   $0x1074b8,0x8(%esp)
  1034f8:	00 
  1034f9:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
  103500:	00 
  103501:	c7 04 24 cd 74 10 00 	movl   $0x1074cd,(%esp)
  103508:	e8 e0 d7 ff ff       	call   100ced <__panic>
    free_pages(p2, 3);
  10350d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103514:	00 
  103515:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103518:	89 04 24             	mov    %eax,(%esp)
  10351b:	e8 af 16 00 00       	call   104bcf <free_pages>
    assert((p2 + 2)->ref == 0);
  103520:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103523:	83 c0 28             	add    $0x28,%eax
  103526:	8b 00                	mov    (%eax),%eax
  103528:	85 c0                	test   %eax,%eax
  10352a:	74 24                	je     103550 <buddy_check+0x453>
  10352c:	c7 44 24 0c 8f 76 10 	movl   $0x10768f,0xc(%esp)
  103533:	00 
  103534:	c7 44 24 08 b8 74 10 	movl   $0x1074b8,0x8(%esp)
  10353b:	00 
  10353c:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  103543:	00 
  103544:	c7 04 24 cd 74 10 00 	movl   $0x1074cd,(%esp)
  10354b:	e8 9d d7 ff ff       	call   100ced <__panic>
    assert(nr_free_pages() == all_pages >> 1);
  103550:	e8 af 16 00 00       	call   104c04 <nr_free_pages>
  103555:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103558:	d1 fa                	sar    %edx
  10355a:	39 d0                	cmp    %edx,%eax
  10355c:	74 24                	je     103582 <buddy_check+0x485>
  10355e:	c7 44 24 0c a4 76 10 	movl   $0x1076a4,0xc(%esp)
  103565:	00 
  103566:	c7 44 24 08 b8 74 10 	movl   $0x1074b8,0x8(%esp)
  10356d:	00 
  10356e:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  103575:	00 
  103576:	c7 04 24 cd 74 10 00 	movl   $0x1074cd,(%esp)
  10357d:	e8 6b d7 ff ff       	call   100ced <__panic>

    p1 = alloc_pages(129);
  103582:	c7 04 24 81 00 00 00 	movl   $0x81,(%esp)
  103589:	e8 07 16 00 00       	call   104b95 <alloc_pages>
  10358e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(p1 == p0 + 256);
  103591:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103594:	05 00 14 00 00       	add    $0x1400,%eax
  103599:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  10359c:	74 24                	je     1035c2 <buddy_check+0x4c5>
  10359e:	c7 44 24 0c c6 76 10 	movl   $0x1076c6,0xc(%esp)
  1035a5:	00 
  1035a6:	c7 44 24 08 b8 74 10 	movl   $0x1074b8,0x8(%esp)
  1035ad:	00 
  1035ae:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  1035b5:	00 
  1035b6:	c7 04 24 cd 74 10 00 	movl   $0x1074cd,(%esp)
  1035bd:	e8 2b d7 ff ff       	call   100ced <__panic>
    free_pages(p1, 256);
  1035c2:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  1035c9:	00 
  1035ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035cd:	89 04 24             	mov    %eax,(%esp)
  1035d0:	e8 fa 15 00 00       	call   104bcf <free_pages>
    free_pages(p3, 8);
  1035d5:	c7 44 24 04 08 00 00 	movl   $0x8,0x4(%esp)
  1035dc:	00 
  1035dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035e0:	89 04 24             	mov    %eax,(%esp)
  1035e3:	e8 e7 15 00 00       	call   104bcf <free_pages>
}
  1035e8:	90                   	nop
  1035e9:	89 ec                	mov    %ebp,%esp
  1035eb:	5d                   	pop    %ebp
  1035ec:	c3                   	ret    

001035ed <page2ppn>:
page2ppn(struct Page *page) {
  1035ed:	55                   	push   %ebp
  1035ee:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1035f0:	8b 15 a0 ee 11 00    	mov    0x11eea0,%edx
  1035f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1035f9:	29 d0                	sub    %edx,%eax
  1035fb:	c1 f8 02             	sar    $0x2,%eax
  1035fe:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103604:	5d                   	pop    %ebp
  103605:	c3                   	ret    

00103606 <page2pa>:
page2pa(struct Page *page) {
  103606:	55                   	push   %ebp
  103607:	89 e5                	mov    %esp,%ebp
  103609:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  10360c:	8b 45 08             	mov    0x8(%ebp),%eax
  10360f:	89 04 24             	mov    %eax,(%esp)
  103612:	e8 d6 ff ff ff       	call   1035ed <page2ppn>
  103617:	c1 e0 0c             	shl    $0xc,%eax
}
  10361a:	89 ec                	mov    %ebp,%esp
  10361c:	5d                   	pop    %ebp
  10361d:	c3                   	ret    

0010361e <page_ref>:
page_ref(struct Page *page) {
  10361e:	55                   	push   %ebp
  10361f:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103621:	8b 45 08             	mov    0x8(%ebp),%eax
  103624:	8b 00                	mov    (%eax),%eax
}
  103626:	5d                   	pop    %ebp
  103627:	c3                   	ret    

00103628 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  103628:	55                   	push   %ebp
  103629:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  10362b:	8b 45 08             	mov    0x8(%ebp),%eax
  10362e:	8b 55 0c             	mov    0xc(%ebp),%edx
  103631:	89 10                	mov    %edx,(%eax)
}
  103633:	90                   	nop
  103634:	5d                   	pop    %ebp
  103635:	c3                   	ret    

00103636 <default_init>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

// 初始化空闲内存*块*链表
static void
default_init(void) {
  103636:	55                   	push   %ebp
  103637:	89 e5                	mov    %esp,%ebp
  103639:	83 ec 10             	sub    $0x10,%esp
  10363c:	c7 45 fc 90 ee 11 00 	movl   $0x11ee90,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103643:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103646:	8b 55 fc             	mov    -0x4(%ebp),%edx
  103649:	89 50 04             	mov    %edx,0x4(%eax)
  10364c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10364f:	8b 50 04             	mov    0x4(%eax),%edx
  103652:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103655:	89 10                	mov    %edx,(%eax)
}
  103657:	90                   	nop
    // 对空闲内存块链表初始化
    list_init(&free_list);
    // 将总空闲数目置零
    nr_free = 0;
  103658:	c7 05 98 ee 11 00 00 	movl   $0x0,0x11ee98
  10365f:	00 00 00 
}
  103662:	90                   	nop
  103663:	89 ec                	mov    %ebp,%esp
  103665:	5d                   	pop    %ebp
  103666:	c3                   	ret    

00103667 <default_init_memmap>:

// 初始化*块*, 对其每一*页*进行初始化
static void
default_init_memmap(struct Page *base, size_t n) {
  103667:	55                   	push   %ebp
  103668:	89 e5                	mov    %esp,%ebp
  10366a:	83 ec 48             	sub    $0x48,%esp
    // 检查: 参数合法性
    assert(n > 0);
  10366d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103671:	75 24                	jne    103697 <default_init_memmap+0x30>
  103673:	c7 44 24 0c 04 77 10 	movl   $0x107704,0xc(%esp)
  10367a:	00 
  10367b:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  103682:	00 
  103683:	c7 44 24 04 72 00 00 	movl   $0x72,0x4(%esp)
  10368a:	00 
  10368b:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  103692:	e8 56 d6 ff ff       	call   100ced <__panic>
    // 初始化: 所有*页*
    // 遍历所有*页*
    struct Page *p = base;
  103697:	8b 45 08             	mov    0x8(%ebp),%eax
  10369a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  10369d:	e9 95 00 00 00       	jmp    103737 <default_init_memmap+0xd0>
        // 检查当前页是否是保留的
        assert(PageReserved(p));
  1036a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036a5:	83 c0 04             	add    $0x4,%eax
  1036a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1036af:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1036b8:	0f a3 10             	bt     %edx,(%eax)
  1036bb:	19 c0                	sbb    %eax,%eax
  1036bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1036c0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1036c4:	0f 95 c0             	setne  %al
  1036c7:	0f b6 c0             	movzbl %al,%eax
  1036ca:	85 c0                	test   %eax,%eax
  1036cc:	75 24                	jne    1036f2 <default_init_memmap+0x8b>
  1036ce:	c7 44 24 0c 35 77 10 	movl   $0x107735,0xc(%esp)
  1036d5:	00 
  1036d6:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  1036dd:	00 
  1036de:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
  1036e5:	00 
  1036e6:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  1036ed:	e8 fb d5 ff ff       	call   100ced <__panic>
        // 标记位清空
        p->flags = 0;
  1036f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        // 空闲块数置零(即无效)
        p->property = 0;
  1036fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036ff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        // 清空引用计数
        set_page_ref(p, 0);
  103706:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10370d:	00 
  10370e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103711:	89 04 24             	mov    %eax,(%esp)
  103714:	e8 0f ff ff ff       	call   103628 <set_page_ref>
        // 启用property属性(即, 将页设为空闲)
        SetPageProperty(p);
  103719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10371c:	83 c0 04             	add    $0x4,%eax
  10371f:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  103726:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103729:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10372c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10372f:	0f ab 10             	bts    %edx,(%eax)
}
  103732:	90                   	nop
    for (; p != base + n; p ++) {
  103733:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  103737:	8b 55 0c             	mov    0xc(%ebp),%edx
  10373a:	89 d0                	mov    %edx,%eax
  10373c:	c1 e0 02             	shl    $0x2,%eax
  10373f:	01 d0                	add    %edx,%eax
  103741:	c1 e0 02             	shl    $0x2,%eax
  103744:	89 c2                	mov    %eax,%edx
  103746:	8b 45 08             	mov    0x8(%ebp),%eax
  103749:	01 d0                	add    %edx,%eax
  10374b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10374e:	0f 85 4e ff ff ff    	jne    1036a2 <default_init_memmap+0x3b>
    }
    // 初始化: 第一*页*
    // 当前块的空闲页数置为n(即, 设置当前块的大小为n, 单位为页)
    base->property = n;
  103754:	8b 45 08             	mov    0x8(%ebp),%eax
  103757:	8b 55 0c             	mov    0xc(%ebp),%edx
  10375a:	89 50 08             	mov    %edx,0x8(%eax)
    // 更新总空页数
    nr_free += n;
  10375d:	8b 15 98 ee 11 00    	mov    0x11ee98,%edx
  103763:	8b 45 0c             	mov    0xc(%ebp),%eax
  103766:	01 d0                	add    %edx,%eax
  103768:	a3 98 ee 11 00       	mov    %eax,0x11ee98
    // 将这个空闲*块*插入到空闲内存*块*链表的最后
    list_add_before(&free_list, &(base->page_link));
  10376d:	8b 45 08             	mov    0x8(%ebp),%eax
  103770:	83 c0 0c             	add    $0xc,%eax
  103773:	c7 45 dc 90 ee 11 00 	movl   $0x11ee90,-0x24(%ebp)
  10377a:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  10377d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103780:	8b 00                	mov    (%eax),%eax
  103782:	8b 55 d8             	mov    -0x28(%ebp),%edx
  103785:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103788:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10378b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10378e:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  103791:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103794:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103797:	89 10                	mov    %edx,(%eax)
  103799:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10379c:	8b 10                	mov    (%eax),%edx
  10379e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1037a1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1037a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1037a7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1037aa:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1037ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1037b0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1037b3:	89 10                	mov    %edx,(%eax)
}
  1037b5:	90                   	nop
}
  1037b6:	90                   	nop
}
  1037b7:	90                   	nop
  1037b8:	89 ec                	mov    %ebp,%esp
  1037ba:	5d                   	pop    %ebp
  1037bb:	c3                   	ret    

001037bc <default_alloc_pages>:

// 分配指定页数的连续空闲物理空间, 并且返回分配到的首页指针
static struct Page *
default_alloc_pages(size_t n) {
  1037bc:	55                   	push   %ebp
  1037bd:	89 e5                	mov    %esp,%ebp
  1037bf:	83 ec 68             	sub    $0x68,%esp
    // 检查: 参数合法性
    assert(n > 0);
  1037c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1037c6:	75 24                	jne    1037ec <default_alloc_pages+0x30>
  1037c8:	c7 44 24 0c 04 77 10 	movl   $0x107704,0xc(%esp)
  1037cf:	00 
  1037d0:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  1037d7:	00 
  1037d8:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  1037df:	00 
  1037e0:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  1037e7:	e8 01 d5 ff ff       	call   100ced <__panic>
    // 检查: 总的空闲物理页数目是否足够, 不够则返回NULL(分配失败)
    if (n > nr_free) {
  1037ec:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  1037f1:	39 45 08             	cmp    %eax,0x8(%ebp)
  1037f4:	76 0a                	jbe    103800 <default_alloc_pages+0x44>
        return NULL;
  1037f6:	b8 00 00 00 00       	mov    $0x0,%eax
  1037fb:	e9 5d 01 00 00       	jmp    10395d <default_alloc_pages+0x1a1>
    }
    // 查找: 符合的块
    struct Page *page = NULL;
  103800:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103807:	c7 45 e0 90 ee 11 00 	movl   $0x11ee90,-0x20(%ebp)
    return listelm->next;
  10380e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103811:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  103814:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 按照物理地址的从小到大顺序遍历空闲内存*块*链表
    while (le != &free_list) {
  103817:	eb 2b                	jmp    103844 <default_alloc_pages+0x88>
        struct Page *p = le2page(le, page_link);
  103819:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10381c:	83 e8 0c             	sub    $0xc,%eax
  10381f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        // 如果找到第一个不小于需要的大小连续内存块, 则成功分配
        if (p->property >= n) {
  103822:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103825:	8b 40 08             	mov    0x8(%eax),%eax
  103828:	39 45 08             	cmp    %eax,0x8(%ebp)
  10382b:	77 08                	ja     103835 <default_alloc_pages+0x79>
            page = p;
  10382d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103830:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  103833:	eb 18                	jmp    10384d <default_alloc_pages+0x91>
  103835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103838:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10383b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10383e:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le = list_next(le);
  103841:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  103844:	81 7d f0 90 ee 11 00 	cmpl   $0x11ee90,-0x10(%ebp)
  10384b:	75 cc                	jne    103819 <default_alloc_pages+0x5d>
    }
    // 处理:
    if (page != NULL) {
  10384d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103851:	0f 84 03 01 00 00    	je     10395a <default_alloc_pages+0x19e>
        // 该内存块的大小大于需要的内存大小, 将空闲内存块分裂成两块
        if (page->property > n) {
  103857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10385a:	8b 40 08             	mov    0x8(%eax),%eax
  10385d:	39 45 08             	cmp    %eax,0x8(%ebp)
  103860:	73 75                	jae    1038d7 <default_alloc_pages+0x11b>
            // 放回 物理地址较大的块
            struct Page *p = page + n;
  103862:	8b 55 08             	mov    0x8(%ebp),%edx
  103865:	89 d0                	mov    %edx,%eax
  103867:	c1 e0 02             	shl    $0x2,%eax
  10386a:	01 d0                	add    %edx,%eax
  10386c:	c1 e0 02             	shl    $0x2,%eax
  10386f:	89 c2                	mov    %eax,%edx
  103871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103874:	01 d0                	add    %edx,%eax
  103876:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            // 重新进行初始化
            p->property = page->property - n;
  103879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10387c:	8b 40 08             	mov    0x8(%eax),%eax
  10387f:	2b 45 08             	sub    0x8(%ebp),%eax
  103882:	89 c2                	mov    %eax,%edx
  103884:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103887:	89 50 08             	mov    %edx,0x8(%eax)
            // 插入到原块之后
            list_add_after(&(page->page_link), &(p->page_link));
  10388a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10388d:	83 c0 0c             	add    $0xc,%eax
  103890:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103893:	83 c2 0c             	add    $0xc,%edx
  103896:	89 55 d8             	mov    %edx,-0x28(%ebp)
  103899:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
  10389c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10389f:	8b 40 04             	mov    0x4(%eax),%eax
  1038a2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1038a5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  1038a8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1038ab:	89 55 cc             	mov    %edx,-0x34(%ebp)
  1038ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
  1038b1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1038b4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1038b7:	89 10                	mov    %edx,(%eax)
  1038b9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1038bc:	8b 10                	mov    (%eax),%edx
  1038be:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1038c1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1038c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1038c7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1038ca:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1038cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1038d0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1038d3:	89 10                	mov    %edx,(%eax)
}
  1038d5:	90                   	nop
}
  1038d6:	90                   	nop
        }
        // 取用 取到的块 或 分裂出来物理地址较小的块
        // 设为非空闲
        for (struct Page *p = page; p != page + n; p++) {
  1038d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038da:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1038dd:	eb 1e                	jmp    1038fd <default_alloc_pages+0x141>
            ClearPageProperty(p);
  1038df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1038e2:	83 c0 04             	add    $0x4,%eax
  1038e5:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  1038ec:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1038ef:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1038f2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1038f5:	0f b3 10             	btr    %edx,(%eax)
}
  1038f8:	90                   	nop
        for (struct Page *p = page; p != page + n; p++) {
  1038f9:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
  1038fd:	8b 55 08             	mov    0x8(%ebp),%edx
  103900:	89 d0                	mov    %edx,%eax
  103902:	c1 e0 02             	shl    $0x2,%eax
  103905:	01 d0                	add    %edx,%eax
  103907:	c1 e0 02             	shl    $0x2,%eax
  10390a:	89 c2                	mov    %eax,%edx
  10390c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10390f:	01 d0                	add    %edx,%eax
  103911:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103914:	75 c9                	jne    1038df <default_alloc_pages+0x123>
        }
        // 从链表中取出
        list_del(&(page->page_link));
  103916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103919:	83 c0 0c             	add    $0xc,%eax
  10391c:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  10391f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103922:	8b 40 04             	mov    0x4(%eax),%eax
  103925:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103928:	8b 12                	mov    (%edx),%edx
  10392a:	89 55 b8             	mov    %edx,-0x48(%ebp)
  10392d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  103930:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103933:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103936:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  103939:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10393c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  10393f:	89 10                	mov    %edx,(%eax)
}
  103941:	90                   	nop
}
  103942:	90                   	nop
        page->property = 0;
  103943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103946:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        // 更新总空页数
        nr_free -= n;
  10394d:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  103952:	2b 45 08             	sub    0x8(%ebp),%eax
  103955:	a3 98 ee 11 00       	mov    %eax,0x11ee98
    }
    //返回: 分配到的页指针
    return page;
  10395a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10395d:	89 ec                	mov    %ebp,%esp
  10395f:	5d                   	pop    %ebp
  103960:	c3                   	ret    

00103961 <default_free_pages>:

// 释放指定的某一物理页开始的若干个连续物理页，并完成first-fit算法中需要信息的维护
static void
default_free_pages(struct Page *base, size_t n) {
  103961:	55                   	push   %ebp
  103962:	89 e5                	mov    %esp,%ebp
  103964:	81 ec 98 00 00 00    	sub    $0x98,%esp
    // 检查: 参数合法性
    assert(n > 0);
  10396a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10396e:	75 24                	jne    103994 <default_free_pages+0x33>
  103970:	c7 44 24 0c 04 77 10 	movl   $0x107704,0xc(%esp)
  103977:	00 
  103978:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  10397f:	00 
  103980:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
  103987:	00 
  103988:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  10398f:	e8 59 d3 ff ff       	call   100ced <__panic>
    // 检查: 所有页 是否是保留的 或 原本就是空闲的
    struct Page *p = base, *p_next = NULL;
  103994:	8b 45 08             	mov    0x8(%ebp),%eax
  103997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10399a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (; p != base + n; p++) {
  1039a1:	e9 c1 00 00 00       	jmp    103a67 <default_free_pages+0x106>
        assert(!PageReserved(p) && !PageProperty(p));
  1039a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039a9:	83 c0 04             	add    $0x4,%eax
  1039ac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1039b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1039b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1039b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1039bc:	0f a3 10             	bt     %edx,(%eax)
  1039bf:	19 c0                	sbb    %eax,%eax
  1039c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
  1039c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1039c8:	0f 95 c0             	setne  %al
  1039cb:	0f b6 c0             	movzbl %al,%eax
  1039ce:	85 c0                	test   %eax,%eax
  1039d0:	75 2c                	jne    1039fe <default_free_pages+0x9d>
  1039d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039d5:	83 c0 04             	add    $0x4,%eax
  1039d8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  1039df:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1039e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1039e5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1039e8:	0f a3 10             	bt     %edx,(%eax)
  1039eb:	19 c0                	sbb    %eax,%eax
  1039ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
  1039f0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  1039f4:	0f 95 c0             	setne  %al
  1039f7:	0f b6 c0             	movzbl %al,%eax
  1039fa:	85 c0                	test   %eax,%eax
  1039fc:	74 24                	je     103a22 <default_free_pages+0xc1>
  1039fe:	c7 44 24 0c 48 77 10 	movl   $0x107748,0xc(%esp)
  103a05:	00 
  103a06:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  103a0d:	00 
  103a0e:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
  103a15:	00 
  103a16:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  103a1d:	e8 cb d2 ff ff       	call   100ced <__panic>
        // 清空标志位
        p->flags = 0;
  103a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        // 恢复为空闲状态
        SetPageProperty(p);
  103a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a2f:	83 c0 04             	add    $0x4,%eax
  103a32:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103a39:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103a3c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103a3f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103a42:	0f ab 10             	bts    %edx,(%eax)
}
  103a45:	90                   	nop
        // 清空引用计数
        set_page_ref(p, 0);
  103a46:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103a4d:	00 
  103a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a51:	89 04 24             	mov    %eax,(%esp)
  103a54:	e8 cf fb ff ff       	call   103628 <set_page_ref>
        p->property = 0;
  103a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a5c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    for (; p != base + n; p++) {
  103a63:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  103a67:	8b 55 0c             	mov    0xc(%ebp),%edx
  103a6a:	89 d0                	mov    %edx,%eax
  103a6c:	c1 e0 02             	shl    $0x2,%eax
  103a6f:	01 d0                	add    %edx,%eax
  103a71:	c1 e0 02             	shl    $0x2,%eax
  103a74:	89 c2                	mov    %eax,%edx
  103a76:	8b 45 08             	mov    0x8(%ebp),%eax
  103a79:	01 d0                	add    %edx,%eax
  103a7b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103a7e:	0f 85 22 ff ff ff    	jne    1039a6 <default_free_pages+0x45>
    }
    // 恢复:
    // 标记该空闲块大小
    base->property = n;
  103a84:	8b 45 08             	mov    0x8(%ebp),%eax
  103a87:	8b 55 0c             	mov    0xc(%ebp),%edx
  103a8a:	89 50 08             	mov    %edx,0x8(%eax)
  103a8d:	c7 45 c8 90 ee 11 00 	movl   $0x11ee90,-0x38(%ebp)
    return listelm->next;
  103a94:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103a97:	8b 40 04             	mov    0x4(%eax),%eax
    // 顺序遍历. 找到恰好大于该块位置的空块
    list_entry_t *le = list_next(&free_list);
  103a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(le != &free_list && le < &(base->page_link)){
  103a9d:	eb 0f                	jmp    103aae <default_free_pages+0x14d>
  103a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103aa2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  103aa5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103aa8:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  103aab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(le != &free_list && le < &(base->page_link)){
  103aae:	81 7d f0 90 ee 11 00 	cmpl   $0x11ee90,-0x10(%ebp)
  103ab5:	74 0b                	je     103ac2 <default_free_pages+0x161>
  103ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  103aba:	83 c0 0c             	add    $0xc,%eax
  103abd:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103ac0:	72 dd                	jb     103a9f <default_free_pages+0x13e>
    }
    // 插入到块链表中
    list_add_before(le,&(base->page_link));
  103ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  103ac5:	8d 50 0c             	lea    0xc(%eax),%edx
  103ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103acb:	89 45 bc             	mov    %eax,-0x44(%ebp)
  103ace:	89 55 b8             	mov    %edx,-0x48(%ebp)
    __list_add(elm, listelm->prev, listelm);
  103ad1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103ad4:	8b 00                	mov    (%eax),%eax
  103ad6:	8b 55 b8             	mov    -0x48(%ebp),%edx
  103ad9:	89 55 b4             	mov    %edx,-0x4c(%ebp)
  103adc:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103adf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103ae2:	89 45 ac             	mov    %eax,-0x54(%ebp)
    prev->next = next->prev = elm;
  103ae5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103ae8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103aeb:	89 10                	mov    %edx,(%eax)
  103aed:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103af0:	8b 10                	mov    (%eax),%edx
  103af2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103af5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  103af8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103afb:	8b 55 ac             	mov    -0x54(%ebp),%edx
  103afe:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  103b01:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103b04:	8b 55 b0             	mov    -0x50(%ebp),%edx
  103b07:	89 10                	mov    %edx,(%eax)
}
  103b09:	90                   	nop
}
  103b0a:	90                   	nop
    // 更新总空页数
    nr_free += n;
  103b0b:	8b 15 98 ee 11 00    	mov    0x11ee98,%edx
  103b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  103b14:	01 d0                	add    %edx,%eax
  103b16:	a3 98 ee 11 00       	mov    %eax,0x11ee98
    // 合并:
    // 不是最后一个块, 向后合并
    for(le = list_next(&(base->page_link));
  103b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  103b1e:	83 c0 0c             	add    $0xc,%eax
  103b21:	89 45 c0             	mov    %eax,-0x40(%ebp)
    return listelm->next;
  103b24:	8b 45 c0             	mov    -0x40(%ebp),%eax
  103b27:	8b 40 04             	mov    0x4(%eax),%eax
  103b2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b2d:	eb 7f                	jmp    103bae <default_free_pages+0x24d>
        le != &free_list;
        le = list_next(&(base->page_link))){
        p = le2page(le, page_link);
  103b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b32:	83 e8 0c             	sub    $0xc,%eax
  103b35:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // 后一个空闲块 不相邻就退出, 相邻就继续合并
        if(base + base->property != p)
  103b38:	8b 45 08             	mov    0x8(%ebp),%eax
  103b3b:	8b 50 08             	mov    0x8(%eax),%edx
  103b3e:	89 d0                	mov    %edx,%eax
  103b40:	c1 e0 02             	shl    $0x2,%eax
  103b43:	01 d0                	add    %edx,%eax
  103b45:	c1 e0 02             	shl    $0x2,%eax
  103b48:	89 c2                	mov    %eax,%edx
  103b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  103b4d:	01 d0                	add    %edx,%eax
  103b4f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103b52:	75 69                	jne    103bbd <default_free_pages+0x25c>
            break;
        base->property += p->property;
  103b54:	8b 45 08             	mov    0x8(%ebp),%eax
  103b57:	8b 50 08             	mov    0x8(%eax),%edx
  103b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b5d:	8b 40 08             	mov    0x8(%eax),%eax
  103b60:	01 c2                	add    %eax,%edx
  103b62:	8b 45 08             	mov    0x8(%ebp),%eax
  103b65:	89 50 08             	mov    %edx,0x8(%eax)
        p->property = 0;
  103b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b6b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  103b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b75:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    __list_del(listelm->prev, listelm->next);
  103b78:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103b7b:	8b 40 04             	mov    0x4(%eax),%eax
  103b7e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  103b81:	8b 12                	mov    (%edx),%edx
  103b83:	89 55 a0             	mov    %edx,-0x60(%ebp)
  103b86:	89 45 9c             	mov    %eax,-0x64(%ebp)
    prev->next = next;
  103b89:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103b8c:	8b 55 9c             	mov    -0x64(%ebp),%edx
  103b8f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  103b92:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103b95:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103b98:	89 10                	mov    %edx,(%eax)
}
  103b9a:	90                   	nop
}
  103b9b:	90                   	nop
        le = list_next(&(base->page_link))){
  103b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  103b9f:	83 c0 0c             	add    $0xc,%eax
  103ba2:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return listelm->next;
  103ba5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103ba8:	8b 40 04             	mov    0x4(%eax),%eax
  103bab:	89 45 f0             	mov    %eax,-0x10(%ebp)
        le != &free_list;
  103bae:	81 7d f0 90 ee 11 00 	cmpl   $0x11ee90,-0x10(%ebp)
  103bb5:	0f 85 74 ff ff ff    	jne    103b2f <default_free_pages+0x1ce>
  103bbb:	eb 01                	jmp    103bbe <default_free_pages+0x25d>
            break;
  103bbd:	90                   	nop
        list_del(le);
    }
    // 不是第一个块, 向前合并
    for(le = list_prev(&(base->page_link));
  103bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  103bc1:	83 c0 0c             	add    $0xc,%eax
  103bc4:	89 45 98             	mov    %eax,-0x68(%ebp)
    return listelm->prev;
  103bc7:	8b 45 98             	mov    -0x68(%ebp),%eax
  103bca:	8b 00                	mov    (%eax),%eax
  103bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103bcf:	e9 90 00 00 00       	jmp    103c64 <default_free_pages+0x303>
        le != &free_list;
        le = list_prev(le)){
        p = le2page(le, page_link);
  103bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103bd7:	83 e8 0c             	sub    $0xc,%eax
  103bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103be0:	89 45 94             	mov    %eax,-0x6c(%ebp)
    return listelm->next;
  103be3:	8b 45 94             	mov    -0x6c(%ebp),%eax
  103be6:	8b 40 04             	mov    0x4(%eax),%eax
        p_next = le2page(list_next(le), page_link);
  103be9:	83 e8 0c             	sub    $0xc,%eax
  103bec:	89 45 ec             	mov    %eax,-0x14(%ebp)
        // 前一个空闲块 不相邻就退出, 相邻就继续合并
        if(p + p->property != p_next)
  103bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103bf2:	8b 50 08             	mov    0x8(%eax),%edx
  103bf5:	89 d0                	mov    %edx,%eax
  103bf7:	c1 e0 02             	shl    $0x2,%eax
  103bfa:	01 d0                	add    %edx,%eax
  103bfc:	c1 e0 02             	shl    $0x2,%eax
  103bff:	89 c2                	mov    %eax,%edx
  103c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c04:	01 d0                	add    %edx,%eax
  103c06:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103c09:	75 68                	jne    103c73 <default_free_pages+0x312>
            break;
        p->property += p_next->property;
  103c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c0e:	8b 50 08             	mov    0x8(%eax),%edx
  103c11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103c14:	8b 40 08             	mov    0x8(%eax),%eax
  103c17:	01 c2                	add    %eax,%edx
  103c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c1c:	89 50 08             	mov    %edx,0x8(%eax)
        p_next->property = 0;
  103c1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103c22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        list_del(&(p_next->page_link));
  103c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103c2c:	83 c0 0c             	add    $0xc,%eax
  103c2f:	89 45 8c             	mov    %eax,-0x74(%ebp)
    __list_del(listelm->prev, listelm->next);
  103c32:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103c35:	8b 40 04             	mov    0x4(%eax),%eax
  103c38:	8b 55 8c             	mov    -0x74(%ebp),%edx
  103c3b:	8b 12                	mov    (%edx),%edx
  103c3d:	89 55 88             	mov    %edx,-0x78(%ebp)
  103c40:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next;
  103c43:	8b 45 88             	mov    -0x78(%ebp),%eax
  103c46:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103c49:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  103c4c:	8b 45 84             	mov    -0x7c(%ebp),%eax
  103c4f:	8b 55 88             	mov    -0x78(%ebp),%edx
  103c52:	89 10                	mov    %edx,(%eax)
}
  103c54:	90                   	nop
}
  103c55:	90                   	nop
  103c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c59:	89 45 90             	mov    %eax,-0x70(%ebp)
    return listelm->prev;
  103c5c:	8b 45 90             	mov    -0x70(%ebp),%eax
  103c5f:	8b 00                	mov    (%eax),%eax
        le = list_prev(le)){
  103c61:	89 45 f0             	mov    %eax,-0x10(%ebp)
        le != &free_list;
  103c64:	81 7d f0 90 ee 11 00 	cmpl   $0x11ee90,-0x10(%ebp)
  103c6b:	0f 85 63 ff ff ff    	jne    103bd4 <default_free_pages+0x273>
    }
}
  103c71:	eb 01                	jmp    103c74 <default_free_pages+0x313>
            break;
  103c73:	90                   	nop
}
  103c74:	90                   	nop
  103c75:	89 ec                	mov    %ebp,%esp
  103c77:	5d                   	pop    %ebp
  103c78:	c3                   	ret    

00103c79 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  103c79:	55                   	push   %ebp
  103c7a:	89 e5                	mov    %esp,%ebp
    return nr_free;
  103c7c:	a1 98 ee 11 00       	mov    0x11ee98,%eax
}
  103c81:	5d                   	pop    %ebp
  103c82:	c3                   	ret    

00103c83 <basic_check>:

static void
basic_check(void) {
  103c83:	55                   	push   %ebp
  103c84:	89 e5                	mov    %esp,%ebp
  103c86:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  103c89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c99:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  103c9c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103ca3:	e8 ed 0e 00 00       	call   104b95 <alloc_pages>
  103ca8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103cab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103caf:	75 24                	jne    103cd5 <basic_check+0x52>
  103cb1:	c7 44 24 0c 6d 77 10 	movl   $0x10776d,0xc(%esp)
  103cb8:	00 
  103cb9:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  103cc0:	00 
  103cc1:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  103cc8:	00 
  103cc9:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  103cd0:	e8 18 d0 ff ff       	call   100ced <__panic>
    assert((p1 = alloc_page()) != NULL);
  103cd5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103cdc:	e8 b4 0e 00 00       	call   104b95 <alloc_pages>
  103ce1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103ce4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103ce8:	75 24                	jne    103d0e <basic_check+0x8b>
  103cea:	c7 44 24 0c 89 77 10 	movl   $0x107789,0xc(%esp)
  103cf1:	00 
  103cf2:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  103cf9:	00 
  103cfa:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  103d01:	00 
  103d02:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  103d09:	e8 df cf ff ff       	call   100ced <__panic>
    assert((p2 = alloc_page()) != NULL);
  103d0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103d15:	e8 7b 0e 00 00       	call   104b95 <alloc_pages>
  103d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103d1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103d21:	75 24                	jne    103d47 <basic_check+0xc4>
  103d23:	c7 44 24 0c a5 77 10 	movl   $0x1077a5,0xc(%esp)
  103d2a:	00 
  103d2b:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  103d32:	00 
  103d33:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  103d3a:	00 
  103d3b:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  103d42:	e8 a6 cf ff ff       	call   100ced <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  103d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d4a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103d4d:	74 10                	je     103d5f <basic_check+0xdc>
  103d4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d52:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103d55:	74 08                	je     103d5f <basic_check+0xdc>
  103d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d5a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103d5d:	75 24                	jne    103d83 <basic_check+0x100>
  103d5f:	c7 44 24 0c c4 77 10 	movl   $0x1077c4,0xc(%esp)
  103d66:	00 
  103d67:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  103d6e:	00 
  103d6f:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  103d76:	00 
  103d77:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  103d7e:	e8 6a cf ff ff       	call   100ced <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  103d83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d86:	89 04 24             	mov    %eax,(%esp)
  103d89:	e8 90 f8 ff ff       	call   10361e <page_ref>
  103d8e:	85 c0                	test   %eax,%eax
  103d90:	75 1e                	jne    103db0 <basic_check+0x12d>
  103d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d95:	89 04 24             	mov    %eax,(%esp)
  103d98:	e8 81 f8 ff ff       	call   10361e <page_ref>
  103d9d:	85 c0                	test   %eax,%eax
  103d9f:	75 0f                	jne    103db0 <basic_check+0x12d>
  103da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103da4:	89 04 24             	mov    %eax,(%esp)
  103da7:	e8 72 f8 ff ff       	call   10361e <page_ref>
  103dac:	85 c0                	test   %eax,%eax
  103dae:	74 24                	je     103dd4 <basic_check+0x151>
  103db0:	c7 44 24 0c e8 77 10 	movl   $0x1077e8,0xc(%esp)
  103db7:	00 
  103db8:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  103dbf:	00 
  103dc0:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  103dc7:	00 
  103dc8:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  103dcf:	e8 19 cf ff ff       	call   100ced <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  103dd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103dd7:	89 04 24             	mov    %eax,(%esp)
  103dda:	e8 27 f8 ff ff       	call   103606 <page2pa>
  103ddf:	8b 15 a4 ee 11 00    	mov    0x11eea4,%edx
  103de5:	c1 e2 0c             	shl    $0xc,%edx
  103de8:	39 d0                	cmp    %edx,%eax
  103dea:	72 24                	jb     103e10 <basic_check+0x18d>
  103dec:	c7 44 24 0c 24 78 10 	movl   $0x107824,0xc(%esp)
  103df3:	00 
  103df4:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  103dfb:	00 
  103dfc:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  103e03:	00 
  103e04:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  103e0b:	e8 dd ce ff ff       	call   100ced <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  103e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e13:	89 04 24             	mov    %eax,(%esp)
  103e16:	e8 eb f7 ff ff       	call   103606 <page2pa>
  103e1b:	8b 15 a4 ee 11 00    	mov    0x11eea4,%edx
  103e21:	c1 e2 0c             	shl    $0xc,%edx
  103e24:	39 d0                	cmp    %edx,%eax
  103e26:	72 24                	jb     103e4c <basic_check+0x1c9>
  103e28:	c7 44 24 0c 41 78 10 	movl   $0x107841,0xc(%esp)
  103e2f:	00 
  103e30:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  103e37:	00 
  103e38:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  103e3f:	00 
  103e40:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  103e47:	e8 a1 ce ff ff       	call   100ced <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  103e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e4f:	89 04 24             	mov    %eax,(%esp)
  103e52:	e8 af f7 ff ff       	call   103606 <page2pa>
  103e57:	8b 15 a4 ee 11 00    	mov    0x11eea4,%edx
  103e5d:	c1 e2 0c             	shl    $0xc,%edx
  103e60:	39 d0                	cmp    %edx,%eax
  103e62:	72 24                	jb     103e88 <basic_check+0x205>
  103e64:	c7 44 24 0c 5e 78 10 	movl   $0x10785e,0xc(%esp)
  103e6b:	00 
  103e6c:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  103e73:	00 
  103e74:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  103e7b:	00 
  103e7c:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  103e83:	e8 65 ce ff ff       	call   100ced <__panic>

    list_entry_t free_list_store = free_list;
  103e88:	a1 90 ee 11 00       	mov    0x11ee90,%eax
  103e8d:	8b 15 94 ee 11 00    	mov    0x11ee94,%edx
  103e93:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103e96:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103e99:	c7 45 dc 90 ee 11 00 	movl   $0x11ee90,-0x24(%ebp)
    elm->prev = elm->next = elm;
  103ea0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103ea3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ea6:	89 50 04             	mov    %edx,0x4(%eax)
  103ea9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103eac:	8b 50 04             	mov    0x4(%eax),%edx
  103eaf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103eb2:	89 10                	mov    %edx,(%eax)
}
  103eb4:	90                   	nop
  103eb5:	c7 45 e0 90 ee 11 00 	movl   $0x11ee90,-0x20(%ebp)
    return list->next == list;
  103ebc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103ebf:	8b 40 04             	mov    0x4(%eax),%eax
  103ec2:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103ec5:	0f 94 c0             	sete   %al
  103ec8:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103ecb:	85 c0                	test   %eax,%eax
  103ecd:	75 24                	jne    103ef3 <basic_check+0x270>
  103ecf:	c7 44 24 0c 7b 78 10 	movl   $0x10787b,0xc(%esp)
  103ed6:	00 
  103ed7:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  103ede:	00 
  103edf:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  103ee6:	00 
  103ee7:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  103eee:	e8 fa cd ff ff       	call   100ced <__panic>

    unsigned int nr_free_store = nr_free;
  103ef3:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  103ef8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  103efb:	c7 05 98 ee 11 00 00 	movl   $0x0,0x11ee98
  103f02:	00 00 00 

    assert(alloc_page() == NULL);
  103f05:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103f0c:	e8 84 0c 00 00       	call   104b95 <alloc_pages>
  103f11:	85 c0                	test   %eax,%eax
  103f13:	74 24                	je     103f39 <basic_check+0x2b6>
  103f15:	c7 44 24 0c 92 78 10 	movl   $0x107892,0xc(%esp)
  103f1c:	00 
  103f1d:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  103f24:	00 
  103f25:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  103f2c:	00 
  103f2d:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  103f34:	e8 b4 cd ff ff       	call   100ced <__panic>

    free_page(p0);
  103f39:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103f40:	00 
  103f41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103f44:	89 04 24             	mov    %eax,(%esp)
  103f47:	e8 83 0c 00 00       	call   104bcf <free_pages>
    free_page(p1);
  103f4c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103f53:	00 
  103f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f57:	89 04 24             	mov    %eax,(%esp)
  103f5a:	e8 70 0c 00 00       	call   104bcf <free_pages>
    free_page(p2);
  103f5f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103f66:	00 
  103f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f6a:	89 04 24             	mov    %eax,(%esp)
  103f6d:	e8 5d 0c 00 00       	call   104bcf <free_pages>
    assert(nr_free == 3);
  103f72:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  103f77:	83 f8 03             	cmp    $0x3,%eax
  103f7a:	74 24                	je     103fa0 <basic_check+0x31d>
  103f7c:	c7 44 24 0c a7 78 10 	movl   $0x1078a7,0xc(%esp)
  103f83:	00 
  103f84:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  103f8b:	00 
  103f8c:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
  103f93:	00 
  103f94:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  103f9b:	e8 4d cd ff ff       	call   100ced <__panic>

    assert((p0 = alloc_page()) != NULL);
  103fa0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103fa7:	e8 e9 0b 00 00       	call   104b95 <alloc_pages>
  103fac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103faf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103fb3:	75 24                	jne    103fd9 <basic_check+0x356>
  103fb5:	c7 44 24 0c 6d 77 10 	movl   $0x10776d,0xc(%esp)
  103fbc:	00 
  103fbd:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  103fc4:	00 
  103fc5:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  103fcc:	00 
  103fcd:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  103fd4:	e8 14 cd ff ff       	call   100ced <__panic>
    assert((p1 = alloc_page()) != NULL);
  103fd9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103fe0:	e8 b0 0b 00 00       	call   104b95 <alloc_pages>
  103fe5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103fe8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103fec:	75 24                	jne    104012 <basic_check+0x38f>
  103fee:	c7 44 24 0c 89 77 10 	movl   $0x107789,0xc(%esp)
  103ff5:	00 
  103ff6:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  103ffd:	00 
  103ffe:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  104005:	00 
  104006:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  10400d:	e8 db cc ff ff       	call   100ced <__panic>
    assert((p2 = alloc_page()) != NULL);
  104012:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104019:	e8 77 0b 00 00       	call   104b95 <alloc_pages>
  10401e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104021:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104025:	75 24                	jne    10404b <basic_check+0x3c8>
  104027:	c7 44 24 0c a5 77 10 	movl   $0x1077a5,0xc(%esp)
  10402e:	00 
  10402f:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  104036:	00 
  104037:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  10403e:	00 
  10403f:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  104046:	e8 a2 cc ff ff       	call   100ced <__panic>

    assert(alloc_page() == NULL);
  10404b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104052:	e8 3e 0b 00 00       	call   104b95 <alloc_pages>
  104057:	85 c0                	test   %eax,%eax
  104059:	74 24                	je     10407f <basic_check+0x3fc>
  10405b:	c7 44 24 0c 92 78 10 	movl   $0x107892,0xc(%esp)
  104062:	00 
  104063:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  10406a:	00 
  10406b:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
  104072:	00 
  104073:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  10407a:	e8 6e cc ff ff       	call   100ced <__panic>

    free_page(p0);
  10407f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104086:	00 
  104087:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10408a:	89 04 24             	mov    %eax,(%esp)
  10408d:	e8 3d 0b 00 00       	call   104bcf <free_pages>
  104092:	c7 45 d8 90 ee 11 00 	movl   $0x11ee90,-0x28(%ebp)
  104099:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10409c:	8b 40 04             	mov    0x4(%eax),%eax
  10409f:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  1040a2:	0f 94 c0             	sete   %al
  1040a5:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  1040a8:	85 c0                	test   %eax,%eax
  1040aa:	74 24                	je     1040d0 <basic_check+0x44d>
  1040ac:	c7 44 24 0c b4 78 10 	movl   $0x1078b4,0xc(%esp)
  1040b3:	00 
  1040b4:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  1040bb:	00 
  1040bc:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
  1040c3:	00 
  1040c4:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  1040cb:	e8 1d cc ff ff       	call   100ced <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1040d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1040d7:	e8 b9 0a 00 00       	call   104b95 <alloc_pages>
  1040dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1040df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1040e2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1040e5:	74 24                	je     10410b <basic_check+0x488>
  1040e7:	c7 44 24 0c cc 78 10 	movl   $0x1078cc,0xc(%esp)
  1040ee:	00 
  1040ef:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  1040f6:	00 
  1040f7:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
  1040fe:	00 
  1040ff:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  104106:	e8 e2 cb ff ff       	call   100ced <__panic>
    assert(alloc_page() == NULL);
  10410b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104112:	e8 7e 0a 00 00       	call   104b95 <alloc_pages>
  104117:	85 c0                	test   %eax,%eax
  104119:	74 24                	je     10413f <basic_check+0x4bc>
  10411b:	c7 44 24 0c 92 78 10 	movl   $0x107892,0xc(%esp)
  104122:	00 
  104123:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  10412a:	00 
  10412b:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
  104132:	00 
  104133:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  10413a:	e8 ae cb ff ff       	call   100ced <__panic>

    assert(nr_free == 0);
  10413f:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  104144:	85 c0                	test   %eax,%eax
  104146:	74 24                	je     10416c <basic_check+0x4e9>
  104148:	c7 44 24 0c e5 78 10 	movl   $0x1078e5,0xc(%esp)
  10414f:	00 
  104150:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  104157:	00 
  104158:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  10415f:	00 
  104160:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  104167:	e8 81 cb ff ff       	call   100ced <__panic>
    free_list = free_list_store;
  10416c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10416f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104172:	a3 90 ee 11 00       	mov    %eax,0x11ee90
  104177:	89 15 94 ee 11 00    	mov    %edx,0x11ee94
    nr_free = nr_free_store;
  10417d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104180:	a3 98 ee 11 00       	mov    %eax,0x11ee98

    free_page(p);
  104185:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10418c:	00 
  10418d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104190:	89 04 24             	mov    %eax,(%esp)
  104193:	e8 37 0a 00 00       	call   104bcf <free_pages>
    free_page(p1);
  104198:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10419f:	00 
  1041a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041a3:	89 04 24             	mov    %eax,(%esp)
  1041a6:	e8 24 0a 00 00       	call   104bcf <free_pages>
    free_page(p2);
  1041ab:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1041b2:	00 
  1041b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041b6:	89 04 24             	mov    %eax,(%esp)
  1041b9:	e8 11 0a 00 00       	call   104bcf <free_pages>
}
  1041be:	90                   	nop
  1041bf:	89 ec                	mov    %ebp,%esp
  1041c1:	5d                   	pop    %ebp
  1041c2:	c3                   	ret    

001041c3 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  1041c3:	55                   	push   %ebp
  1041c4:	89 e5                	mov    %esp,%ebp
  1041c6:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  1041cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1041d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1041da:	c7 45 ec 90 ee 11 00 	movl   $0x11ee90,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1041e1:	eb 6a                	jmp    10424d <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
  1041e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1041e6:	83 e8 0c             	sub    $0xc,%eax
  1041e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  1041ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1041ef:	83 c0 04             	add    $0x4,%eax
  1041f2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1041f9:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1041fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1041ff:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104202:	0f a3 10             	bt     %edx,(%eax)
  104205:	19 c0                	sbb    %eax,%eax
  104207:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  10420a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  10420e:	0f 95 c0             	setne  %al
  104211:	0f b6 c0             	movzbl %al,%eax
  104214:	85 c0                	test   %eax,%eax
  104216:	75 24                	jne    10423c <default_check+0x79>
  104218:	c7 44 24 0c f2 78 10 	movl   $0x1078f2,0xc(%esp)
  10421f:	00 
  104220:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  104227:	00 
  104228:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
  10422f:	00 
  104230:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  104237:	e8 b1 ca ff ff       	call   100ced <__panic>
        count ++, total += p->property;
  10423c:	ff 45 f4             	incl   -0xc(%ebp)
  10423f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104242:	8b 50 08             	mov    0x8(%eax),%edx
  104245:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104248:	01 d0                	add    %edx,%eax
  10424a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10424d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104250:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  104253:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104256:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  104259:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10425c:	81 7d ec 90 ee 11 00 	cmpl   $0x11ee90,-0x14(%ebp)
  104263:	0f 85 7a ff ff ff    	jne    1041e3 <default_check+0x20>
    }
    assert(total == nr_free_pages());
  104269:	e8 96 09 00 00       	call   104c04 <nr_free_pages>
  10426e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104271:	39 d0                	cmp    %edx,%eax
  104273:	74 24                	je     104299 <default_check+0xd6>
  104275:	c7 44 24 0c 02 79 10 	movl   $0x107902,0xc(%esp)
  10427c:	00 
  10427d:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  104284:	00 
  104285:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
  10428c:	00 
  10428d:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  104294:	e8 54 ca ff ff       	call   100ced <__panic>

    basic_check();
  104299:	e8 e5 f9 ff ff       	call   103c83 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  10429e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1042a5:	e8 eb 08 00 00       	call   104b95 <alloc_pages>
  1042aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  1042ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1042b1:	75 24                	jne    1042d7 <default_check+0x114>
  1042b3:	c7 44 24 0c 1b 79 10 	movl   $0x10791b,0xc(%esp)
  1042ba:	00 
  1042bb:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  1042c2:	00 
  1042c3:	c7 44 24 04 3c 01 00 	movl   $0x13c,0x4(%esp)
  1042ca:	00 
  1042cb:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  1042d2:	e8 16 ca ff ff       	call   100ced <__panic>
    assert(!PageProperty(p0));
  1042d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1042da:	83 c0 04             	add    $0x4,%eax
  1042dd:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1042e4:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1042e7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1042ea:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1042ed:	0f a3 10             	bt     %edx,(%eax)
  1042f0:	19 c0                	sbb    %eax,%eax
  1042f2:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1042f5:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1042f9:	0f 95 c0             	setne  %al
  1042fc:	0f b6 c0             	movzbl %al,%eax
  1042ff:	85 c0                	test   %eax,%eax
  104301:	74 24                	je     104327 <default_check+0x164>
  104303:	c7 44 24 0c 26 79 10 	movl   $0x107926,0xc(%esp)
  10430a:	00 
  10430b:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  104312:	00 
  104313:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
  10431a:	00 
  10431b:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  104322:	e8 c6 c9 ff ff       	call   100ced <__panic>

    list_entry_t free_list_store = free_list;
  104327:	a1 90 ee 11 00       	mov    0x11ee90,%eax
  10432c:	8b 15 94 ee 11 00    	mov    0x11ee94,%edx
  104332:	89 45 80             	mov    %eax,-0x80(%ebp)
  104335:	89 55 84             	mov    %edx,-0x7c(%ebp)
  104338:	c7 45 b0 90 ee 11 00 	movl   $0x11ee90,-0x50(%ebp)
    elm->prev = elm->next = elm;
  10433f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104342:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104345:	89 50 04             	mov    %edx,0x4(%eax)
  104348:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10434b:	8b 50 04             	mov    0x4(%eax),%edx
  10434e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104351:	89 10                	mov    %edx,(%eax)
}
  104353:	90                   	nop
  104354:	c7 45 b4 90 ee 11 00 	movl   $0x11ee90,-0x4c(%ebp)
    return list->next == list;
  10435b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10435e:	8b 40 04             	mov    0x4(%eax),%eax
  104361:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  104364:	0f 94 c0             	sete   %al
  104367:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10436a:	85 c0                	test   %eax,%eax
  10436c:	75 24                	jne    104392 <default_check+0x1cf>
  10436e:	c7 44 24 0c 7b 78 10 	movl   $0x10787b,0xc(%esp)
  104375:	00 
  104376:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  10437d:	00 
  10437e:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
  104385:	00 
  104386:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  10438d:	e8 5b c9 ff ff       	call   100ced <__panic>
    assert(alloc_page() == NULL);
  104392:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104399:	e8 f7 07 00 00       	call   104b95 <alloc_pages>
  10439e:	85 c0                	test   %eax,%eax
  1043a0:	74 24                	je     1043c6 <default_check+0x203>
  1043a2:	c7 44 24 0c 92 78 10 	movl   $0x107892,0xc(%esp)
  1043a9:	00 
  1043aa:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  1043b1:	00 
  1043b2:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
  1043b9:	00 
  1043ba:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  1043c1:	e8 27 c9 ff ff       	call   100ced <__panic>

    unsigned int nr_free_store = nr_free;
  1043c6:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  1043cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  1043ce:	c7 05 98 ee 11 00 00 	movl   $0x0,0x11ee98
  1043d5:	00 00 00 

    free_pages(p0 + 2, 3);
  1043d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1043db:	83 c0 28             	add    $0x28,%eax
  1043de:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1043e5:	00 
  1043e6:	89 04 24             	mov    %eax,(%esp)
  1043e9:	e8 e1 07 00 00       	call   104bcf <free_pages>
    assert(alloc_pages(4) == NULL);
  1043ee:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1043f5:	e8 9b 07 00 00       	call   104b95 <alloc_pages>
  1043fa:	85 c0                	test   %eax,%eax
  1043fc:	74 24                	je     104422 <default_check+0x25f>
  1043fe:	c7 44 24 0c 38 79 10 	movl   $0x107938,0xc(%esp)
  104405:	00 
  104406:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  10440d:	00 
  10440e:	c7 44 24 04 48 01 00 	movl   $0x148,0x4(%esp)
  104415:	00 
  104416:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  10441d:	e8 cb c8 ff ff       	call   100ced <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  104422:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104425:	83 c0 28             	add    $0x28,%eax
  104428:	83 c0 04             	add    $0x4,%eax
  10442b:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  104432:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104435:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104438:	8b 55 ac             	mov    -0x54(%ebp),%edx
  10443b:	0f a3 10             	bt     %edx,(%eax)
  10443e:	19 c0                	sbb    %eax,%eax
  104440:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  104443:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  104447:	0f 95 c0             	setne  %al
  10444a:	0f b6 c0             	movzbl %al,%eax
  10444d:	85 c0                	test   %eax,%eax
  10444f:	74 0e                	je     10445f <default_check+0x29c>
  104451:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104454:	83 c0 28             	add    $0x28,%eax
  104457:	8b 40 08             	mov    0x8(%eax),%eax
  10445a:	83 f8 03             	cmp    $0x3,%eax
  10445d:	74 24                	je     104483 <default_check+0x2c0>
  10445f:	c7 44 24 0c 50 79 10 	movl   $0x107950,0xc(%esp)
  104466:	00 
  104467:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  10446e:	00 
  10446f:	c7 44 24 04 49 01 00 	movl   $0x149,0x4(%esp)
  104476:	00 
  104477:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  10447e:	e8 6a c8 ff ff       	call   100ced <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  104483:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10448a:	e8 06 07 00 00       	call   104b95 <alloc_pages>
  10448f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104492:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104496:	75 24                	jne    1044bc <default_check+0x2f9>
  104498:	c7 44 24 0c 7c 79 10 	movl   $0x10797c,0xc(%esp)
  10449f:	00 
  1044a0:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  1044a7:	00 
  1044a8:	c7 44 24 04 4a 01 00 	movl   $0x14a,0x4(%esp)
  1044af:	00 
  1044b0:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  1044b7:	e8 31 c8 ff ff       	call   100ced <__panic>
    assert(alloc_page() == NULL);
  1044bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1044c3:	e8 cd 06 00 00       	call   104b95 <alloc_pages>
  1044c8:	85 c0                	test   %eax,%eax
  1044ca:	74 24                	je     1044f0 <default_check+0x32d>
  1044cc:	c7 44 24 0c 92 78 10 	movl   $0x107892,0xc(%esp)
  1044d3:	00 
  1044d4:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  1044db:	00 
  1044dc:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
  1044e3:	00 
  1044e4:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  1044eb:	e8 fd c7 ff ff       	call   100ced <__panic>
    assert(p0 + 2 == p1);
  1044f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044f3:	83 c0 28             	add    $0x28,%eax
  1044f6:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1044f9:	74 24                	je     10451f <default_check+0x35c>
  1044fb:	c7 44 24 0c 9a 79 10 	movl   $0x10799a,0xc(%esp)
  104502:	00 
  104503:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  10450a:	00 
  10450b:	c7 44 24 04 4c 01 00 	movl   $0x14c,0x4(%esp)
  104512:	00 
  104513:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  10451a:	e8 ce c7 ff ff       	call   100ced <__panic>

    p2 = p0 + 1;
  10451f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104522:	83 c0 14             	add    $0x14,%eax
  104525:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  104528:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10452f:	00 
  104530:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104533:	89 04 24             	mov    %eax,(%esp)
  104536:	e8 94 06 00 00       	call   104bcf <free_pages>
    free_pages(p1, 3);
  10453b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  104542:	00 
  104543:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104546:	89 04 24             	mov    %eax,(%esp)
  104549:	e8 81 06 00 00       	call   104bcf <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  10454e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104551:	83 c0 04             	add    $0x4,%eax
  104554:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  10455b:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10455e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104561:	8b 55 a0             	mov    -0x60(%ebp),%edx
  104564:	0f a3 10             	bt     %edx,(%eax)
  104567:	19 c0                	sbb    %eax,%eax
  104569:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10456c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  104570:	0f 95 c0             	setne  %al
  104573:	0f b6 c0             	movzbl %al,%eax
  104576:	85 c0                	test   %eax,%eax
  104578:	74 0b                	je     104585 <default_check+0x3c2>
  10457a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10457d:	8b 40 08             	mov    0x8(%eax),%eax
  104580:	83 f8 01             	cmp    $0x1,%eax
  104583:	74 24                	je     1045a9 <default_check+0x3e6>
  104585:	c7 44 24 0c a8 79 10 	movl   $0x1079a8,0xc(%esp)
  10458c:	00 
  10458d:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  104594:	00 
  104595:	c7 44 24 04 51 01 00 	movl   $0x151,0x4(%esp)
  10459c:	00 
  10459d:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  1045a4:	e8 44 c7 ff ff       	call   100ced <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1045a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045ac:	83 c0 04             	add    $0x4,%eax
  1045af:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  1045b6:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1045b9:	8b 45 90             	mov    -0x70(%ebp),%eax
  1045bc:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1045bf:	0f a3 10             	bt     %edx,(%eax)
  1045c2:	19 c0                	sbb    %eax,%eax
  1045c4:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1045c7:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1045cb:	0f 95 c0             	setne  %al
  1045ce:	0f b6 c0             	movzbl %al,%eax
  1045d1:	85 c0                	test   %eax,%eax
  1045d3:	74 0b                	je     1045e0 <default_check+0x41d>
  1045d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045d8:	8b 40 08             	mov    0x8(%eax),%eax
  1045db:	83 f8 03             	cmp    $0x3,%eax
  1045de:	74 24                	je     104604 <default_check+0x441>
  1045e0:	c7 44 24 0c d0 79 10 	movl   $0x1079d0,0xc(%esp)
  1045e7:	00 
  1045e8:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  1045ef:	00 
  1045f0:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
  1045f7:	00 
  1045f8:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  1045ff:	e8 e9 c6 ff ff       	call   100ced <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  104604:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10460b:	e8 85 05 00 00       	call   104b95 <alloc_pages>
  104610:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104613:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104616:	83 e8 14             	sub    $0x14,%eax
  104619:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10461c:	74 24                	je     104642 <default_check+0x47f>
  10461e:	c7 44 24 0c f6 79 10 	movl   $0x1079f6,0xc(%esp)
  104625:	00 
  104626:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  10462d:	00 
  10462e:	c7 44 24 04 54 01 00 	movl   $0x154,0x4(%esp)
  104635:	00 
  104636:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  10463d:	e8 ab c6 ff ff       	call   100ced <__panic>
    free_page(p0);
  104642:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104649:	00 
  10464a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10464d:	89 04 24             	mov    %eax,(%esp)
  104650:	e8 7a 05 00 00       	call   104bcf <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  104655:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10465c:	e8 34 05 00 00       	call   104b95 <alloc_pages>
  104661:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104664:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104667:	83 c0 14             	add    $0x14,%eax
  10466a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10466d:	74 24                	je     104693 <default_check+0x4d0>
  10466f:	c7 44 24 0c 14 7a 10 	movl   $0x107a14,0xc(%esp)
  104676:	00 
  104677:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  10467e:	00 
  10467f:	c7 44 24 04 56 01 00 	movl   $0x156,0x4(%esp)
  104686:	00 
  104687:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  10468e:	e8 5a c6 ff ff       	call   100ced <__panic>

    free_pages(p0, 2);
  104693:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10469a:	00 
  10469b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10469e:	89 04 24             	mov    %eax,(%esp)
  1046a1:	e8 29 05 00 00       	call   104bcf <free_pages>
    free_page(p2);
  1046a6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1046ad:	00 
  1046ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1046b1:	89 04 24             	mov    %eax,(%esp)
  1046b4:	e8 16 05 00 00       	call   104bcf <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  1046b9:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1046c0:	e8 d0 04 00 00       	call   104b95 <alloc_pages>
  1046c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1046c8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1046cc:	75 24                	jne    1046f2 <default_check+0x52f>
  1046ce:	c7 44 24 0c 34 7a 10 	movl   $0x107a34,0xc(%esp)
  1046d5:	00 
  1046d6:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  1046dd:	00 
  1046de:	c7 44 24 04 5b 01 00 	movl   $0x15b,0x4(%esp)
  1046e5:	00 
  1046e6:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  1046ed:	e8 fb c5 ff ff       	call   100ced <__panic>
    assert(alloc_page() == NULL);
  1046f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1046f9:	e8 97 04 00 00       	call   104b95 <alloc_pages>
  1046fe:	85 c0                	test   %eax,%eax
  104700:	74 24                	je     104726 <default_check+0x563>
  104702:	c7 44 24 0c 92 78 10 	movl   $0x107892,0xc(%esp)
  104709:	00 
  10470a:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  104711:	00 
  104712:	c7 44 24 04 5c 01 00 	movl   $0x15c,0x4(%esp)
  104719:	00 
  10471a:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  104721:	e8 c7 c5 ff ff       	call   100ced <__panic>

    assert(nr_free == 0);
  104726:	a1 98 ee 11 00       	mov    0x11ee98,%eax
  10472b:	85 c0                	test   %eax,%eax
  10472d:	74 24                	je     104753 <default_check+0x590>
  10472f:	c7 44 24 0c e5 78 10 	movl   $0x1078e5,0xc(%esp)
  104736:	00 
  104737:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  10473e:	00 
  10473f:	c7 44 24 04 5e 01 00 	movl   $0x15e,0x4(%esp)
  104746:	00 
  104747:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  10474e:	e8 9a c5 ff ff       	call   100ced <__panic>
    nr_free = nr_free_store;
  104753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104756:	a3 98 ee 11 00       	mov    %eax,0x11ee98

    free_list = free_list_store;
  10475b:	8b 45 80             	mov    -0x80(%ebp),%eax
  10475e:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104761:	a3 90 ee 11 00       	mov    %eax,0x11ee90
  104766:	89 15 94 ee 11 00    	mov    %edx,0x11ee94
    free_pages(p0, 5);
  10476c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  104773:	00 
  104774:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104777:	89 04 24             	mov    %eax,(%esp)
  10477a:	e8 50 04 00 00       	call   104bcf <free_pages>

    le = &free_list;
  10477f:	c7 45 ec 90 ee 11 00 	movl   $0x11ee90,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104786:	eb 5a                	jmp    1047e2 <default_check+0x61f>
        assert(le->next->prev == le && le->prev->next == le);
  104788:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10478b:	8b 40 04             	mov    0x4(%eax),%eax
  10478e:	8b 00                	mov    (%eax),%eax
  104790:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104793:	75 0d                	jne    1047a2 <default_check+0x5df>
  104795:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104798:	8b 00                	mov    (%eax),%eax
  10479a:	8b 40 04             	mov    0x4(%eax),%eax
  10479d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1047a0:	74 24                	je     1047c6 <default_check+0x603>
  1047a2:	c7 44 24 0c 54 7a 10 	movl   $0x107a54,0xc(%esp)
  1047a9:	00 
  1047aa:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  1047b1:	00 
  1047b2:	c7 44 24 04 66 01 00 	movl   $0x166,0x4(%esp)
  1047b9:	00 
  1047ba:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  1047c1:	e8 27 c5 ff ff       	call   100ced <__panic>
        struct Page *p = le2page(le, page_link);
  1047c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047c9:	83 e8 0c             	sub    $0xc,%eax
  1047cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  1047cf:	ff 4d f4             	decl   -0xc(%ebp)
  1047d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1047d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1047d8:	8b 48 08             	mov    0x8(%eax),%ecx
  1047db:	89 d0                	mov    %edx,%eax
  1047dd:	29 c8                	sub    %ecx,%eax
  1047df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1047e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047e5:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  1047e8:	8b 45 88             	mov    -0x78(%ebp),%eax
  1047eb:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1047ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1047f1:	81 7d ec 90 ee 11 00 	cmpl   $0x11ee90,-0x14(%ebp)
  1047f8:	75 8e                	jne    104788 <default_check+0x5c5>
    }
    assert(count == 0);
  1047fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1047fe:	74 24                	je     104824 <default_check+0x661>
  104800:	c7 44 24 0c 81 7a 10 	movl   $0x107a81,0xc(%esp)
  104807:	00 
  104808:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  10480f:	00 
  104810:	c7 44 24 04 6a 01 00 	movl   $0x16a,0x4(%esp)
  104817:	00 
  104818:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  10481f:	e8 c9 c4 ff ff       	call   100ced <__panic>
    assert(total == 0);
  104824:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104828:	74 24                	je     10484e <default_check+0x68b>
  10482a:	c7 44 24 0c 8c 7a 10 	movl   $0x107a8c,0xc(%esp)
  104831:	00 
  104832:	c7 44 24 08 0a 77 10 	movl   $0x10770a,0x8(%esp)
  104839:	00 
  10483a:	c7 44 24 04 6b 01 00 	movl   $0x16b,0x4(%esp)
  104841:	00 
  104842:	c7 04 24 1f 77 10 00 	movl   $0x10771f,(%esp)
  104849:	e8 9f c4 ff ff       	call   100ced <__panic>
}
  10484e:	90                   	nop
  10484f:	89 ec                	mov    %ebp,%esp
  104851:	5d                   	pop    %ebp
  104852:	c3                   	ret    

00104853 <page2ppn>:
page2ppn(struct Page *page) {
  104853:	55                   	push   %ebp
  104854:	89 e5                	mov    %esp,%ebp
    return page - pages;
  104856:	8b 15 a0 ee 11 00    	mov    0x11eea0,%edx
  10485c:	8b 45 08             	mov    0x8(%ebp),%eax
  10485f:	29 d0                	sub    %edx,%eax
  104861:	c1 f8 02             	sar    $0x2,%eax
  104864:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10486a:	5d                   	pop    %ebp
  10486b:	c3                   	ret    

0010486c <page2pa>:
page2pa(struct Page *page) {
  10486c:	55                   	push   %ebp
  10486d:	89 e5                	mov    %esp,%ebp
  10486f:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  104872:	8b 45 08             	mov    0x8(%ebp),%eax
  104875:	89 04 24             	mov    %eax,(%esp)
  104878:	e8 d6 ff ff ff       	call   104853 <page2ppn>
  10487d:	c1 e0 0c             	shl    $0xc,%eax
}
  104880:	89 ec                	mov    %ebp,%esp
  104882:	5d                   	pop    %ebp
  104883:	c3                   	ret    

00104884 <pa2page>:
pa2page(uintptr_t pa) {
  104884:	55                   	push   %ebp
  104885:	89 e5                	mov    %esp,%ebp
  104887:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  10488a:	8b 45 08             	mov    0x8(%ebp),%eax
  10488d:	c1 e8 0c             	shr    $0xc,%eax
  104890:	89 c2                	mov    %eax,%edx
  104892:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  104897:	39 c2                	cmp    %eax,%edx
  104899:	72 1c                	jb     1048b7 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  10489b:	c7 44 24 08 c8 7a 10 	movl   $0x107ac8,0x8(%esp)
  1048a2:	00 
  1048a3:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  1048aa:	00 
  1048ab:	c7 04 24 e7 7a 10 00 	movl   $0x107ae7,(%esp)
  1048b2:	e8 36 c4 ff ff       	call   100ced <__panic>
    return &pages[PPN(pa)];
  1048b7:	8b 0d a0 ee 11 00    	mov    0x11eea0,%ecx
  1048bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1048c0:	c1 e8 0c             	shr    $0xc,%eax
  1048c3:	89 c2                	mov    %eax,%edx
  1048c5:	89 d0                	mov    %edx,%eax
  1048c7:	c1 e0 02             	shl    $0x2,%eax
  1048ca:	01 d0                	add    %edx,%eax
  1048cc:	c1 e0 02             	shl    $0x2,%eax
  1048cf:	01 c8                	add    %ecx,%eax
}
  1048d1:	89 ec                	mov    %ebp,%esp
  1048d3:	5d                   	pop    %ebp
  1048d4:	c3                   	ret    

001048d5 <page2kva>:
page2kva(struct Page *page) {
  1048d5:	55                   	push   %ebp
  1048d6:	89 e5                	mov    %esp,%ebp
  1048d8:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  1048db:	8b 45 08             	mov    0x8(%ebp),%eax
  1048de:	89 04 24             	mov    %eax,(%esp)
  1048e1:	e8 86 ff ff ff       	call   10486c <page2pa>
  1048e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1048e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048ec:	c1 e8 0c             	shr    $0xc,%eax
  1048ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1048f2:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  1048f7:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1048fa:	72 23                	jb     10491f <page2kva+0x4a>
  1048fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104903:	c7 44 24 08 f8 7a 10 	movl   $0x107af8,0x8(%esp)
  10490a:	00 
  10490b:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  104912:	00 
  104913:	c7 04 24 e7 7a 10 00 	movl   $0x107ae7,(%esp)
  10491a:	e8 ce c3 ff ff       	call   100ced <__panic>
  10491f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104922:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  104927:	89 ec                	mov    %ebp,%esp
  104929:	5d                   	pop    %ebp
  10492a:	c3                   	ret    

0010492b <pte2page>:
pte2page(pte_t pte) {
  10492b:	55                   	push   %ebp
  10492c:	89 e5                	mov    %esp,%ebp
  10492e:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  104931:	8b 45 08             	mov    0x8(%ebp),%eax
  104934:	83 e0 01             	and    $0x1,%eax
  104937:	85 c0                	test   %eax,%eax
  104939:	75 1c                	jne    104957 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  10493b:	c7 44 24 08 1c 7b 10 	movl   $0x107b1c,0x8(%esp)
  104942:	00 
  104943:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  10494a:	00 
  10494b:	c7 04 24 e7 7a 10 00 	movl   $0x107ae7,(%esp)
  104952:	e8 96 c3 ff ff       	call   100ced <__panic>
    return pa2page(PTE_ADDR(pte));
  104957:	8b 45 08             	mov    0x8(%ebp),%eax
  10495a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10495f:	89 04 24             	mov    %eax,(%esp)
  104962:	e8 1d ff ff ff       	call   104884 <pa2page>
}
  104967:	89 ec                	mov    %ebp,%esp
  104969:	5d                   	pop    %ebp
  10496a:	c3                   	ret    

0010496b <pde2page>:
pde2page(pde_t pde) {
  10496b:	55                   	push   %ebp
  10496c:	89 e5                	mov    %esp,%ebp
  10496e:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  104971:	8b 45 08             	mov    0x8(%ebp),%eax
  104974:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104979:	89 04 24             	mov    %eax,(%esp)
  10497c:	e8 03 ff ff ff       	call   104884 <pa2page>
}
  104981:	89 ec                	mov    %ebp,%esp
  104983:	5d                   	pop    %ebp
  104984:	c3                   	ret    

00104985 <page_ref>:
page_ref(struct Page *page) {
  104985:	55                   	push   %ebp
  104986:	89 e5                	mov    %esp,%ebp
    return page->ref;
  104988:	8b 45 08             	mov    0x8(%ebp),%eax
  10498b:	8b 00                	mov    (%eax),%eax
}
  10498d:	5d                   	pop    %ebp
  10498e:	c3                   	ret    

0010498f <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  10498f:	55                   	push   %ebp
  104990:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  104992:	8b 45 08             	mov    0x8(%ebp),%eax
  104995:	8b 55 0c             	mov    0xc(%ebp),%edx
  104998:	89 10                	mov    %edx,(%eax)
}
  10499a:	90                   	nop
  10499b:	5d                   	pop    %ebp
  10499c:	c3                   	ret    

0010499d <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  10499d:	55                   	push   %ebp
  10499e:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  1049a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1049a3:	8b 00                	mov    (%eax),%eax
  1049a5:	8d 50 01             	lea    0x1(%eax),%edx
  1049a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1049ab:	89 10                	mov    %edx,(%eax)
    return page->ref;
  1049ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1049b0:	8b 00                	mov    (%eax),%eax
}
  1049b2:	5d                   	pop    %ebp
  1049b3:	c3                   	ret    

001049b4 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  1049b4:	55                   	push   %ebp
  1049b5:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  1049b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1049ba:	8b 00                	mov    (%eax),%eax
  1049bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  1049bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1049c2:	89 10                	mov    %edx,(%eax)
    return page->ref;
  1049c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1049c7:	8b 00                	mov    (%eax),%eax
}
  1049c9:	5d                   	pop    %ebp
  1049ca:	c3                   	ret    

001049cb <__intr_save>:
__intr_save(void) {
  1049cb:	55                   	push   %ebp
  1049cc:	89 e5                	mov    %esp,%ebp
  1049ce:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  1049d1:	9c                   	pushf  
  1049d2:	58                   	pop    %eax
  1049d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  1049d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  1049d9:	25 00 02 00 00       	and    $0x200,%eax
  1049de:	85 c0                	test   %eax,%eax
  1049e0:	74 0c                	je     1049ee <__intr_save+0x23>
        intr_disable();
  1049e2:	e8 5f cd ff ff       	call   101746 <intr_disable>
        return 1;
  1049e7:	b8 01 00 00 00       	mov    $0x1,%eax
  1049ec:	eb 05                	jmp    1049f3 <__intr_save+0x28>
    return 0;
  1049ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1049f3:	89 ec                	mov    %ebp,%esp
  1049f5:	5d                   	pop    %ebp
  1049f6:	c3                   	ret    

001049f7 <__intr_restore>:
__intr_restore(bool flag) {
  1049f7:	55                   	push   %ebp
  1049f8:	89 e5                	mov    %esp,%ebp
  1049fa:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  1049fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104a01:	74 05                	je     104a08 <__intr_restore+0x11>
        intr_enable();
  104a03:	e8 36 cd ff ff       	call   10173e <intr_enable>
}
  104a08:	90                   	nop
  104a09:	89 ec                	mov    %ebp,%esp
  104a0b:	5d                   	pop    %ebp
  104a0c:	c3                   	ret    

00104a0d <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  104a0d:	55                   	push   %ebp
  104a0e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  104a10:	8b 45 08             	mov    0x8(%ebp),%eax
  104a13:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  104a16:	b8 23 00 00 00       	mov    $0x23,%eax
  104a1b:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  104a1d:	b8 23 00 00 00       	mov    $0x23,%eax
  104a22:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  104a24:	b8 10 00 00 00       	mov    $0x10,%eax
  104a29:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  104a2b:	b8 10 00 00 00       	mov    $0x10,%eax
  104a30:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  104a32:	b8 10 00 00 00       	mov    $0x10,%eax
  104a37:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  104a39:	ea 40 4a 10 00 08 00 	ljmp   $0x8,$0x104a40
}
  104a40:	90                   	nop
  104a41:	5d                   	pop    %ebp
  104a42:	c3                   	ret    

00104a43 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  104a43:	55                   	push   %ebp
  104a44:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  104a46:	8b 45 08             	mov    0x8(%ebp),%eax
  104a49:	a3 c4 ee 11 00       	mov    %eax,0x11eec4
}
  104a4e:	90                   	nop
  104a4f:	5d                   	pop    %ebp
  104a50:	c3                   	ret    

00104a51 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  104a51:	55                   	push   %ebp
  104a52:	89 e5                	mov    %esp,%ebp
  104a54:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  104a57:	b8 00 b0 11 00       	mov    $0x11b000,%eax
  104a5c:	89 04 24             	mov    %eax,(%esp)
  104a5f:	e8 df ff ff ff       	call   104a43 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  104a64:	66 c7 05 c8 ee 11 00 	movw   $0x10,0x11eec8
  104a6b:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  104a6d:	66 c7 05 28 ba 11 00 	movw   $0x68,0x11ba28
  104a74:	68 00 
  104a76:	b8 c0 ee 11 00       	mov    $0x11eec0,%eax
  104a7b:	0f b7 c0             	movzwl %ax,%eax
  104a7e:	66 a3 2a ba 11 00    	mov    %ax,0x11ba2a
  104a84:	b8 c0 ee 11 00       	mov    $0x11eec0,%eax
  104a89:	c1 e8 10             	shr    $0x10,%eax
  104a8c:	a2 2c ba 11 00       	mov    %al,0x11ba2c
  104a91:	0f b6 05 2d ba 11 00 	movzbl 0x11ba2d,%eax
  104a98:	24 f0                	and    $0xf0,%al
  104a9a:	0c 09                	or     $0x9,%al
  104a9c:	a2 2d ba 11 00       	mov    %al,0x11ba2d
  104aa1:	0f b6 05 2d ba 11 00 	movzbl 0x11ba2d,%eax
  104aa8:	24 ef                	and    $0xef,%al
  104aaa:	a2 2d ba 11 00       	mov    %al,0x11ba2d
  104aaf:	0f b6 05 2d ba 11 00 	movzbl 0x11ba2d,%eax
  104ab6:	24 9f                	and    $0x9f,%al
  104ab8:	a2 2d ba 11 00       	mov    %al,0x11ba2d
  104abd:	0f b6 05 2d ba 11 00 	movzbl 0x11ba2d,%eax
  104ac4:	0c 80                	or     $0x80,%al
  104ac6:	a2 2d ba 11 00       	mov    %al,0x11ba2d
  104acb:	0f b6 05 2e ba 11 00 	movzbl 0x11ba2e,%eax
  104ad2:	24 f0                	and    $0xf0,%al
  104ad4:	a2 2e ba 11 00       	mov    %al,0x11ba2e
  104ad9:	0f b6 05 2e ba 11 00 	movzbl 0x11ba2e,%eax
  104ae0:	24 ef                	and    $0xef,%al
  104ae2:	a2 2e ba 11 00       	mov    %al,0x11ba2e
  104ae7:	0f b6 05 2e ba 11 00 	movzbl 0x11ba2e,%eax
  104aee:	24 df                	and    $0xdf,%al
  104af0:	a2 2e ba 11 00       	mov    %al,0x11ba2e
  104af5:	0f b6 05 2e ba 11 00 	movzbl 0x11ba2e,%eax
  104afc:	0c 40                	or     $0x40,%al
  104afe:	a2 2e ba 11 00       	mov    %al,0x11ba2e
  104b03:	0f b6 05 2e ba 11 00 	movzbl 0x11ba2e,%eax
  104b0a:	24 7f                	and    $0x7f,%al
  104b0c:	a2 2e ba 11 00       	mov    %al,0x11ba2e
  104b11:	b8 c0 ee 11 00       	mov    $0x11eec0,%eax
  104b16:	c1 e8 18             	shr    $0x18,%eax
  104b19:	a2 2f ba 11 00       	mov    %al,0x11ba2f

    // reload all segment registers
    lgdt(&gdt_pd);
  104b1e:	c7 04 24 30 ba 11 00 	movl   $0x11ba30,(%esp)
  104b25:	e8 e3 fe ff ff       	call   104a0d <lgdt>
  104b2a:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  104b30:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  104b34:	0f 00 d8             	ltr    %ax
}
  104b37:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  104b38:	90                   	nop
  104b39:	89 ec                	mov    %ebp,%esp
  104b3b:	5d                   	pop    %ebp
  104b3c:	c3                   	ret    

00104b3d <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  104b3d:	55                   	push   %ebp
  104b3e:	89 e5                	mov    %esp,%ebp
  104b40:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &buddy_pmm_manager;
  104b43:	c7 05 ac ee 11 00 e8 	movl   $0x1076e8,0x11eeac
  104b4a:	76 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  104b4d:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  104b52:	8b 00                	mov    (%eax),%eax
  104b54:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b58:	c7 04 24 48 7b 10 00 	movl   $0x107b48,(%esp)
  104b5f:	e8 fd b7 ff ff       	call   100361 <cprintf>
    pmm_manager->init();
  104b64:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  104b69:	8b 40 04             	mov    0x4(%eax),%eax
  104b6c:	ff d0                	call   *%eax
}
  104b6e:	90                   	nop
  104b6f:	89 ec                	mov    %ebp,%esp
  104b71:	5d                   	pop    %ebp
  104b72:	c3                   	ret    

00104b73 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  104b73:	55                   	push   %ebp
  104b74:	89 e5                	mov    %esp,%ebp
  104b76:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  104b79:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  104b7e:	8b 40 08             	mov    0x8(%eax),%eax
  104b81:	8b 55 0c             	mov    0xc(%ebp),%edx
  104b84:	89 54 24 04          	mov    %edx,0x4(%esp)
  104b88:	8b 55 08             	mov    0x8(%ebp),%edx
  104b8b:	89 14 24             	mov    %edx,(%esp)
  104b8e:	ff d0                	call   *%eax
}
  104b90:	90                   	nop
  104b91:	89 ec                	mov    %ebp,%esp
  104b93:	5d                   	pop    %ebp
  104b94:	c3                   	ret    

00104b95 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  104b95:	55                   	push   %ebp
  104b96:	89 e5                	mov    %esp,%ebp
  104b98:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  104b9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  104ba2:	e8 24 fe ff ff       	call   1049cb <__intr_save>
  104ba7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  104baa:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  104baf:	8b 40 0c             	mov    0xc(%eax),%eax
  104bb2:	8b 55 08             	mov    0x8(%ebp),%edx
  104bb5:	89 14 24             	mov    %edx,(%esp)
  104bb8:	ff d0                	call   *%eax
  104bba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  104bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104bc0:	89 04 24             	mov    %eax,(%esp)
  104bc3:	e8 2f fe ff ff       	call   1049f7 <__intr_restore>
    return page;
  104bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  104bcb:	89 ec                	mov    %ebp,%esp
  104bcd:	5d                   	pop    %ebp
  104bce:	c3                   	ret    

00104bcf <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  104bcf:	55                   	push   %ebp
  104bd0:	89 e5                	mov    %esp,%ebp
  104bd2:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  104bd5:	e8 f1 fd ff ff       	call   1049cb <__intr_save>
  104bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  104bdd:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  104be2:	8b 40 10             	mov    0x10(%eax),%eax
  104be5:	8b 55 0c             	mov    0xc(%ebp),%edx
  104be8:	89 54 24 04          	mov    %edx,0x4(%esp)
  104bec:	8b 55 08             	mov    0x8(%ebp),%edx
  104bef:	89 14 24             	mov    %edx,(%esp)
  104bf2:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  104bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bf7:	89 04 24             	mov    %eax,(%esp)
  104bfa:	e8 f8 fd ff ff       	call   1049f7 <__intr_restore>
}
  104bff:	90                   	nop
  104c00:	89 ec                	mov    %ebp,%esp
  104c02:	5d                   	pop    %ebp
  104c03:	c3                   	ret    

00104c04 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  104c04:	55                   	push   %ebp
  104c05:	89 e5                	mov    %esp,%ebp
  104c07:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  104c0a:	e8 bc fd ff ff       	call   1049cb <__intr_save>
  104c0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  104c12:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  104c17:	8b 40 14             	mov    0x14(%eax),%eax
  104c1a:	ff d0                	call   *%eax
  104c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  104c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c22:	89 04 24             	mov    %eax,(%esp)
  104c25:	e8 cd fd ff ff       	call   1049f7 <__intr_restore>
    return ret;
  104c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  104c2d:	89 ec                	mov    %ebp,%esp
  104c2f:	5d                   	pop    %ebp
  104c30:	c3                   	ret    

00104c31 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  104c31:	55                   	push   %ebp
  104c32:	89 e5                	mov    %esp,%ebp
  104c34:	57                   	push   %edi
  104c35:	56                   	push   %esi
  104c36:	53                   	push   %ebx
  104c37:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  104c3d:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  104c44:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  104c4b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  104c52:	c7 04 24 5f 7b 10 00 	movl   $0x107b5f,(%esp)
  104c59:	e8 03 b7 ff ff       	call   100361 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  104c5e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104c65:	e9 0c 01 00 00       	jmp    104d76 <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  104c6a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104c6d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104c70:	89 d0                	mov    %edx,%eax
  104c72:	c1 e0 02             	shl    $0x2,%eax
  104c75:	01 d0                	add    %edx,%eax
  104c77:	c1 e0 02             	shl    $0x2,%eax
  104c7a:	01 c8                	add    %ecx,%eax
  104c7c:	8b 50 08             	mov    0x8(%eax),%edx
  104c7f:	8b 40 04             	mov    0x4(%eax),%eax
  104c82:	89 45 a0             	mov    %eax,-0x60(%ebp)
  104c85:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  104c88:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104c8b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104c8e:	89 d0                	mov    %edx,%eax
  104c90:	c1 e0 02             	shl    $0x2,%eax
  104c93:	01 d0                	add    %edx,%eax
  104c95:	c1 e0 02             	shl    $0x2,%eax
  104c98:	01 c8                	add    %ecx,%eax
  104c9a:	8b 48 0c             	mov    0xc(%eax),%ecx
  104c9d:	8b 58 10             	mov    0x10(%eax),%ebx
  104ca0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104ca3:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104ca6:	01 c8                	add    %ecx,%eax
  104ca8:	11 da                	adc    %ebx,%edx
  104caa:	89 45 98             	mov    %eax,-0x68(%ebp)
  104cad:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  104cb0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104cb3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104cb6:	89 d0                	mov    %edx,%eax
  104cb8:	c1 e0 02             	shl    $0x2,%eax
  104cbb:	01 d0                	add    %edx,%eax
  104cbd:	c1 e0 02             	shl    $0x2,%eax
  104cc0:	01 c8                	add    %ecx,%eax
  104cc2:	83 c0 14             	add    $0x14,%eax
  104cc5:	8b 00                	mov    (%eax),%eax
  104cc7:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  104ccd:	8b 45 98             	mov    -0x68(%ebp),%eax
  104cd0:	8b 55 9c             	mov    -0x64(%ebp),%edx
  104cd3:	83 c0 ff             	add    $0xffffffff,%eax
  104cd6:	83 d2 ff             	adc    $0xffffffff,%edx
  104cd9:	89 c6                	mov    %eax,%esi
  104cdb:	89 d7                	mov    %edx,%edi
  104cdd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104ce0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104ce3:	89 d0                	mov    %edx,%eax
  104ce5:	c1 e0 02             	shl    $0x2,%eax
  104ce8:	01 d0                	add    %edx,%eax
  104cea:	c1 e0 02             	shl    $0x2,%eax
  104ced:	01 c8                	add    %ecx,%eax
  104cef:	8b 48 0c             	mov    0xc(%eax),%ecx
  104cf2:	8b 58 10             	mov    0x10(%eax),%ebx
  104cf5:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  104cfb:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  104cff:	89 74 24 14          	mov    %esi,0x14(%esp)
  104d03:	89 7c 24 18          	mov    %edi,0x18(%esp)
  104d07:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104d0a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104d0d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104d11:	89 54 24 10          	mov    %edx,0x10(%esp)
  104d15:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  104d19:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104d1d:	c7 04 24 6c 7b 10 00 	movl   $0x107b6c,(%esp)
  104d24:	e8 38 b6 ff ff       	call   100361 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  104d29:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104d2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104d2f:	89 d0                	mov    %edx,%eax
  104d31:	c1 e0 02             	shl    $0x2,%eax
  104d34:	01 d0                	add    %edx,%eax
  104d36:	c1 e0 02             	shl    $0x2,%eax
  104d39:	01 c8                	add    %ecx,%eax
  104d3b:	83 c0 14             	add    $0x14,%eax
  104d3e:	8b 00                	mov    (%eax),%eax
  104d40:	83 f8 01             	cmp    $0x1,%eax
  104d43:	75 2e                	jne    104d73 <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
  104d45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104d48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104d4b:	3b 45 98             	cmp    -0x68(%ebp),%eax
  104d4e:	89 d0                	mov    %edx,%eax
  104d50:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  104d53:	73 1e                	jae    104d73 <page_init+0x142>
  104d55:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  104d5a:	b8 00 00 00 00       	mov    $0x0,%eax
  104d5f:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  104d62:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  104d65:	72 0c                	jb     104d73 <page_init+0x142>
                maxpa = end;
  104d67:	8b 45 98             	mov    -0x68(%ebp),%eax
  104d6a:	8b 55 9c             	mov    -0x64(%ebp),%edx
  104d6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104d70:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  104d73:	ff 45 dc             	incl   -0x24(%ebp)
  104d76:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104d79:	8b 00                	mov    (%eax),%eax
  104d7b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104d7e:	0f 8c e6 fe ff ff    	jl     104c6a <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  104d84:	ba 00 00 00 38       	mov    $0x38000000,%edx
  104d89:	b8 00 00 00 00       	mov    $0x0,%eax
  104d8e:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  104d91:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  104d94:	73 0e                	jae    104da4 <page_init+0x173>
        maxpa = KMEMSIZE;
  104d96:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  104d9d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  104da4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104da7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104daa:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104dae:	c1 ea 0c             	shr    $0xc,%edx
  104db1:	a3 a4 ee 11 00       	mov    %eax,0x11eea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  104db6:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  104dbd:	b8 2c ef 11 00       	mov    $0x11ef2c,%eax
  104dc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  104dc5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104dc8:	01 d0                	add    %edx,%eax
  104dca:	89 45 bc             	mov    %eax,-0x44(%ebp)
  104dcd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104dd0:	ba 00 00 00 00       	mov    $0x0,%edx
  104dd5:	f7 75 c0             	divl   -0x40(%ebp)
  104dd8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104ddb:	29 d0                	sub    %edx,%eax
  104ddd:	a3 a0 ee 11 00       	mov    %eax,0x11eea0

    for (i = 0; i < npage; i ++) {
  104de2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104de9:	eb 2f                	jmp    104e1a <page_init+0x1e9>
        SetPageReserved(pages + i);
  104deb:	8b 0d a0 ee 11 00    	mov    0x11eea0,%ecx
  104df1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104df4:	89 d0                	mov    %edx,%eax
  104df6:	c1 e0 02             	shl    $0x2,%eax
  104df9:	01 d0                	add    %edx,%eax
  104dfb:	c1 e0 02             	shl    $0x2,%eax
  104dfe:	01 c8                	add    %ecx,%eax
  104e00:	83 c0 04             	add    $0x4,%eax
  104e03:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  104e0a:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104e0d:	8b 45 90             	mov    -0x70(%ebp),%eax
  104e10:	8b 55 94             	mov    -0x6c(%ebp),%edx
  104e13:	0f ab 10             	bts    %edx,(%eax)
}
  104e16:	90                   	nop
    for (i = 0; i < npage; i ++) {
  104e17:	ff 45 dc             	incl   -0x24(%ebp)
  104e1a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104e1d:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  104e22:	39 c2                	cmp    %eax,%edx
  104e24:	72 c5                	jb     104deb <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  104e26:	8b 15 a4 ee 11 00    	mov    0x11eea4,%edx
  104e2c:	89 d0                	mov    %edx,%eax
  104e2e:	c1 e0 02             	shl    $0x2,%eax
  104e31:	01 d0                	add    %edx,%eax
  104e33:	c1 e0 02             	shl    $0x2,%eax
  104e36:	89 c2                	mov    %eax,%edx
  104e38:	a1 a0 ee 11 00       	mov    0x11eea0,%eax
  104e3d:	01 d0                	add    %edx,%eax
  104e3f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  104e42:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  104e49:	77 23                	ja     104e6e <page_init+0x23d>
  104e4b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104e4e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104e52:	c7 44 24 08 9c 7b 10 	movl   $0x107b9c,0x8(%esp)
  104e59:	00 
  104e5a:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  104e61:	00 
  104e62:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  104e69:	e8 7f be ff ff       	call   100ced <__panic>
  104e6e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104e71:	05 00 00 00 40       	add    $0x40000000,%eax
  104e76:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  104e79:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104e80:	e9 53 01 00 00       	jmp    104fd8 <page_init+0x3a7>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  104e85:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104e88:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104e8b:	89 d0                	mov    %edx,%eax
  104e8d:	c1 e0 02             	shl    $0x2,%eax
  104e90:	01 d0                	add    %edx,%eax
  104e92:	c1 e0 02             	shl    $0x2,%eax
  104e95:	01 c8                	add    %ecx,%eax
  104e97:	8b 50 08             	mov    0x8(%eax),%edx
  104e9a:	8b 40 04             	mov    0x4(%eax),%eax
  104e9d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104ea0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104ea3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104ea6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104ea9:	89 d0                	mov    %edx,%eax
  104eab:	c1 e0 02             	shl    $0x2,%eax
  104eae:	01 d0                	add    %edx,%eax
  104eb0:	c1 e0 02             	shl    $0x2,%eax
  104eb3:	01 c8                	add    %ecx,%eax
  104eb5:	8b 48 0c             	mov    0xc(%eax),%ecx
  104eb8:	8b 58 10             	mov    0x10(%eax),%ebx
  104ebb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104ebe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104ec1:	01 c8                	add    %ecx,%eax
  104ec3:	11 da                	adc    %ebx,%edx
  104ec5:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104ec8:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  104ecb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104ece:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104ed1:	89 d0                	mov    %edx,%eax
  104ed3:	c1 e0 02             	shl    $0x2,%eax
  104ed6:	01 d0                	add    %edx,%eax
  104ed8:	c1 e0 02             	shl    $0x2,%eax
  104edb:	01 c8                	add    %ecx,%eax
  104edd:	83 c0 14             	add    $0x14,%eax
  104ee0:	8b 00                	mov    (%eax),%eax
  104ee2:	83 f8 01             	cmp    $0x1,%eax
  104ee5:	0f 85 ea 00 00 00    	jne    104fd5 <page_init+0x3a4>
            if (begin < freemem) {
  104eeb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104eee:	ba 00 00 00 00       	mov    $0x0,%edx
  104ef3:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  104ef6:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  104ef9:	19 d1                	sbb    %edx,%ecx
  104efb:	73 0d                	jae    104f0a <page_init+0x2d9>
                begin = freemem;
  104efd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104f00:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104f03:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  104f0a:	ba 00 00 00 38       	mov    $0x38000000,%edx
  104f0f:	b8 00 00 00 00       	mov    $0x0,%eax
  104f14:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  104f17:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  104f1a:	73 0e                	jae    104f2a <page_init+0x2f9>
                end = KMEMSIZE;
  104f1c:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  104f23:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  104f2a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104f2d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104f30:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104f33:	89 d0                	mov    %edx,%eax
  104f35:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  104f38:	0f 83 97 00 00 00    	jae    104fd5 <page_init+0x3a4>
                begin = ROUNDUP(begin, PGSIZE);
  104f3e:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  104f45:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104f48:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104f4b:	01 d0                	add    %edx,%eax
  104f4d:	48                   	dec    %eax
  104f4e:	89 45 ac             	mov    %eax,-0x54(%ebp)
  104f51:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104f54:	ba 00 00 00 00       	mov    $0x0,%edx
  104f59:	f7 75 b0             	divl   -0x50(%ebp)
  104f5c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104f5f:	29 d0                	sub    %edx,%eax
  104f61:	ba 00 00 00 00       	mov    $0x0,%edx
  104f66:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104f69:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  104f6c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104f6f:	89 45 a8             	mov    %eax,-0x58(%ebp)
  104f72:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104f75:	ba 00 00 00 00       	mov    $0x0,%edx
  104f7a:	89 c7                	mov    %eax,%edi
  104f7c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  104f82:	89 7d 80             	mov    %edi,-0x80(%ebp)
  104f85:	89 d0                	mov    %edx,%eax
  104f87:	83 e0 00             	and    $0x0,%eax
  104f8a:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104f8d:	8b 45 80             	mov    -0x80(%ebp),%eax
  104f90:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104f93:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104f96:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  104f99:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104f9c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104f9f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104fa2:	89 d0                	mov    %edx,%eax
  104fa4:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  104fa7:	73 2c                	jae    104fd5 <page_init+0x3a4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  104fa9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104fac:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104faf:	2b 45 d0             	sub    -0x30(%ebp),%eax
  104fb2:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  104fb5:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104fb9:	c1 ea 0c             	shr    $0xc,%edx
  104fbc:	89 c3                	mov    %eax,%ebx
  104fbe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104fc1:	89 04 24             	mov    %eax,(%esp)
  104fc4:	e8 bb f8 ff ff       	call   104884 <pa2page>
  104fc9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104fcd:	89 04 24             	mov    %eax,(%esp)
  104fd0:	e8 9e fb ff ff       	call   104b73 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  104fd5:	ff 45 dc             	incl   -0x24(%ebp)
  104fd8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104fdb:	8b 00                	mov    (%eax),%eax
  104fdd:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104fe0:	0f 8c 9f fe ff ff    	jl     104e85 <page_init+0x254>
                }
            }
        }
    }
}
  104fe6:	90                   	nop
  104fe7:	90                   	nop
  104fe8:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104fee:	5b                   	pop    %ebx
  104fef:	5e                   	pop    %esi
  104ff0:	5f                   	pop    %edi
  104ff1:	5d                   	pop    %ebp
  104ff2:	c3                   	ret    

00104ff3 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  104ff3:	55                   	push   %ebp
  104ff4:	89 e5                	mov    %esp,%ebp
  104ff6:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  104ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
  104ffc:	33 45 14             	xor    0x14(%ebp),%eax
  104fff:	25 ff 0f 00 00       	and    $0xfff,%eax
  105004:	85 c0                	test   %eax,%eax
  105006:	74 24                	je     10502c <boot_map_segment+0x39>
  105008:	c7 44 24 0c ce 7b 10 	movl   $0x107bce,0xc(%esp)
  10500f:	00 
  105010:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105017:	00 
  105018:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  10501f:	00 
  105020:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105027:	e8 c1 bc ff ff       	call   100ced <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  10502c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  105033:	8b 45 0c             	mov    0xc(%ebp),%eax
  105036:	25 ff 0f 00 00       	and    $0xfff,%eax
  10503b:	89 c2                	mov    %eax,%edx
  10503d:	8b 45 10             	mov    0x10(%ebp),%eax
  105040:	01 c2                	add    %eax,%edx
  105042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105045:	01 d0                	add    %edx,%eax
  105047:	48                   	dec    %eax
  105048:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10504b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10504e:	ba 00 00 00 00       	mov    $0x0,%edx
  105053:	f7 75 f0             	divl   -0x10(%ebp)
  105056:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105059:	29 d0                	sub    %edx,%eax
  10505b:	c1 e8 0c             	shr    $0xc,%eax
  10505e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  105061:	8b 45 0c             	mov    0xc(%ebp),%eax
  105064:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105067:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10506a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10506f:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  105072:	8b 45 14             	mov    0x14(%ebp),%eax
  105075:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105078:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10507b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105080:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  105083:	eb 68                	jmp    1050ed <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
  105085:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10508c:	00 
  10508d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105090:	89 44 24 04          	mov    %eax,0x4(%esp)
  105094:	8b 45 08             	mov    0x8(%ebp),%eax
  105097:	89 04 24             	mov    %eax,(%esp)
  10509a:	e8 88 01 00 00       	call   105227 <get_pte>
  10509f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1050a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1050a6:	75 24                	jne    1050cc <boot_map_segment+0xd9>
  1050a8:	c7 44 24 0c fa 7b 10 	movl   $0x107bfa,0xc(%esp)
  1050af:	00 
  1050b0:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  1050b7:	00 
  1050b8:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  1050bf:	00 
  1050c0:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  1050c7:	e8 21 bc ff ff       	call   100ced <__panic>
        *ptep = pa | PTE_P | perm;
  1050cc:	8b 45 14             	mov    0x14(%ebp),%eax
  1050cf:	0b 45 18             	or     0x18(%ebp),%eax
  1050d2:	83 c8 01             	or     $0x1,%eax
  1050d5:	89 c2                	mov    %eax,%edx
  1050d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1050da:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1050dc:	ff 4d f4             	decl   -0xc(%ebp)
  1050df:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1050e6:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1050ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1050f1:	75 92                	jne    105085 <boot_map_segment+0x92>
    }
}
  1050f3:	90                   	nop
  1050f4:	90                   	nop
  1050f5:	89 ec                	mov    %ebp,%esp
  1050f7:	5d                   	pop    %ebp
  1050f8:	c3                   	ret    

001050f9 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1050f9:	55                   	push   %ebp
  1050fa:	89 e5                	mov    %esp,%ebp
  1050fc:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1050ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105106:	e8 8a fa ff ff       	call   104b95 <alloc_pages>
  10510b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  10510e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105112:	75 1c                	jne    105130 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  105114:	c7 44 24 08 07 7c 10 	movl   $0x107c07,0x8(%esp)
  10511b:	00 
  10511c:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  105123:	00 
  105124:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  10512b:	e8 bd bb ff ff       	call   100ced <__panic>
    }
    return page2kva(p);
  105130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105133:	89 04 24             	mov    %eax,(%esp)
  105136:	e8 9a f7 ff ff       	call   1048d5 <page2kva>
}
  10513b:	89 ec                	mov    %ebp,%esp
  10513d:	5d                   	pop    %ebp
  10513e:	c3                   	ret    

0010513f <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  10513f:	55                   	push   %ebp
  105140:	89 e5                	mov    %esp,%ebp
  105142:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  105145:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  10514a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10514d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  105154:	77 23                	ja     105179 <pmm_init+0x3a>
  105156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105159:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10515d:	c7 44 24 08 9c 7b 10 	movl   $0x107b9c,0x8(%esp)
  105164:	00 
  105165:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  10516c:	00 
  10516d:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105174:	e8 74 bb ff ff       	call   100ced <__panic>
  105179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10517c:	05 00 00 00 40       	add    $0x40000000,%eax
  105181:	a3 a8 ee 11 00       	mov    %eax,0x11eea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  105186:	e8 b2 f9 ff ff       	call   104b3d <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10518b:	e8 a1 fa ff ff       	call   104c31 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  105190:	e8 12 04 00 00       	call   1055a7 <check_alloc_page>

    check_pgdir();
  105195:	e8 2e 04 00 00       	call   1055c8 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  10519a:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  10519f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1051a2:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1051a9:	77 23                	ja     1051ce <pmm_init+0x8f>
  1051ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1051ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1051b2:	c7 44 24 08 9c 7b 10 	movl   $0x107b9c,0x8(%esp)
  1051b9:	00 
  1051ba:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
  1051c1:	00 
  1051c2:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  1051c9:	e8 1f bb ff ff       	call   100ced <__panic>
  1051ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1051d1:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  1051d7:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  1051dc:	05 ac 0f 00 00       	add    $0xfac,%eax
  1051e1:	83 ca 03             	or     $0x3,%edx
  1051e4:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1051e6:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  1051eb:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1051f2:	00 
  1051f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1051fa:	00 
  1051fb:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  105202:	38 
  105203:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  10520a:	c0 
  10520b:	89 04 24             	mov    %eax,(%esp)
  10520e:	e8 e0 fd ff ff       	call   104ff3 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  105213:	e8 39 f8 ff ff       	call   104a51 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  105218:	e8 49 0a 00 00       	call   105c66 <check_boot_pgdir>

    print_pgdir();
  10521d:	e8 c6 0e 00 00       	call   1060e8 <print_pgdir>

}
  105222:	90                   	nop
  105223:	89 ec                	mov    %ebp,%esp
  105225:	5d                   	pop    %ebp
  105226:	c3                   	ret    

00105227 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  105227:	55                   	push   %ebp
  105228:	89 e5                	mov    %esp,%ebp
  10522a:	83 ec 38             	sub    $0x38,%esp
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
#if 1
    // (1) find page directory entry
    // 获取页目录表中给定线性地址对应到的页目录项
    pde_t *pdep = pgdir + PDX(la);
  10522d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105230:	c1 e8 16             	shr    $0x16,%eax
  105233:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10523a:	8b 45 08             	mov    0x8(%ebp),%eax
  10523d:	01 d0                	add    %edx,%eax
  10523f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // 获取到该物理页的虚拟地址
    pte_t *ptep = (pte_t *)(KADDR(*pdep & ~0XFFF)); 
  105242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105245:	8b 00                	mov    (%eax),%eax
  105247:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10524c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10524f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105252:	c1 e8 0c             	shr    $0xc,%eax
  105255:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105258:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  10525d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  105260:	72 23                	jb     105285 <get_pte+0x5e>
  105262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105265:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105269:	c7 44 24 08 f8 7a 10 	movl   $0x107af8,0x8(%esp)
  105270:	00 
  105271:	c7 44 24 04 64 01 00 	movl   $0x164,0x4(%esp)
  105278:	00 
  105279:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105280:	e8 68 ba ff ff       	call   100ced <__panic>
  105285:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105288:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10528d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // (2) check if entry is not present
    // 判断页目录项是否不存在
    if (!(*pdep & PTE_P)) {
  105290:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105293:	8b 00                	mov    (%eax),%eax
  105295:	83 e0 01             	and    $0x1,%eax
  105298:	85 c0                	test   %eax,%eax
  10529a:	0f 85 c6 00 00 00    	jne    105366 <get_pte+0x13f>
        // (3) check if creating is needed, then alloc page for page table
        // CAUTION: this page is used for page table, not for common data page
        // 判断是否需要创建新的页表, 不需要则返回NULL
        if (!create){
  1052a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1052a4:	75 0a                	jne    1052b0 <get_pte+0x89>
            return NULL;
  1052a6:	b8 00 00 00 00       	mov    $0x0,%eax
  1052ab:	e9 cd 00 00 00       	jmp    10537d <get_pte+0x156>
        }
        // 分配一个页, 如果物理空间不足则返回NULL
        struct Page* pt = alloc_page(); 
  1052b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1052b7:	e8 d9 f8 ff ff       	call   104b95 <alloc_pages>
  1052bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (pt == NULL){
  1052bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1052c3:	75 0a                	jne    1052cf <get_pte+0xa8>
            return NULL;
  1052c5:	b8 00 00 00 00       	mov    $0x0,%eax
  1052ca:	e9 ae 00 00 00       	jmp    10537d <get_pte+0x156>
        }
        // (4) set page reference
        // 更新该物理页的引用计数
        set_page_ref(pt, 1);
  1052cf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1052d6:	00 
  1052d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1052da:	89 04 24             	mov    %eax,(%esp)
  1052dd:	e8 ad f6 ff ff       	call   10498f <set_page_ref>
        // (5) get linear address of page
        // 获取到该物理页的虚拟地址(此时已经启动了page机制，内核地址空间)(CPU执行的指令中使用的已经是虚拟地址了)
        ptep = KADDR(page2pa(pt));
  1052e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1052e5:	89 04 24             	mov    %eax,(%esp)
  1052e8:	e8 7f f5 ff ff       	call   10486c <page2pa>
  1052ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1052f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052f3:	c1 e8 0c             	shr    $0xc,%eax
  1052f6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1052f9:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  1052fe:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  105301:	72 23                	jb     105326 <get_pte+0xff>
  105303:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105306:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10530a:	c7 44 24 08 f8 7a 10 	movl   $0x107af8,0x8(%esp)
  105311:	00 
  105312:	c7 44 24 04 78 01 00 	movl   $0x178,0x4(%esp)
  105319:	00 
  10531a:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105321:	e8 c7 b9 ff ff       	call   100ced <__panic>
  105326:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105329:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10532e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // (6) clear page content using memset
        // 对新创建的页表进行初始化
        memset(ptep, 0, PGSIZE);
  105331:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  105338:	00 
  105339:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105340:	00 
  105341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105344:	89 04 24             	mov    %eax,(%esp)
  105347:	e8 a1 18 00 00       	call   106bed <memset>
        // (7) set page directory entry's permission
        // 对原先的页目录项进行设置: 对应页表的物理地址, 标志位(存在位, 读写位, 特权级)
        *pdep = (page2pa(pt) & ~0XFFF) | PTE_USER;
  10534c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10534f:	89 04 24             	mov    %eax,(%esp)
  105352:	e8 15 f5 ff ff       	call   10486c <page2pa>
  105357:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10535c:	83 c8 07             	or     $0x7,%eax
  10535f:	89 c2                	mov    %eax,%edx
  105361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105364:	89 10                	mov    %edx,(%eax)
    }
    // (8) return page table entry
    // 返回线性地址对应的页表项
    return ptep + PTX(la);
  105366:	8b 45 0c             	mov    0xc(%ebp),%eax
  105369:	c1 e8 0c             	shr    $0xc,%eax
  10536c:	25 ff 03 00 00       	and    $0x3ff,%eax
  105371:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10537b:	01 d0                	add    %edx,%eax
#endif
}
  10537d:	89 ec                	mov    %ebp,%esp
  10537f:	5d                   	pop    %ebp
  105380:	c3                   	ret    

00105381 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  105381:	55                   	push   %ebp
  105382:	89 e5                	mov    %esp,%ebp
  105384:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  105387:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10538e:	00 
  10538f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105392:	89 44 24 04          	mov    %eax,0x4(%esp)
  105396:	8b 45 08             	mov    0x8(%ebp),%eax
  105399:	89 04 24             	mov    %eax,(%esp)
  10539c:	e8 86 fe ff ff       	call   105227 <get_pte>
  1053a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1053a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1053a8:	74 08                	je     1053b2 <get_page+0x31>
        *ptep_store = ptep;
  1053aa:	8b 45 10             	mov    0x10(%ebp),%eax
  1053ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1053b0:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1053b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1053b6:	74 1b                	je     1053d3 <get_page+0x52>
  1053b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1053bb:	8b 00                	mov    (%eax),%eax
  1053bd:	83 e0 01             	and    $0x1,%eax
  1053c0:	85 c0                	test   %eax,%eax
  1053c2:	74 0f                	je     1053d3 <get_page+0x52>
        return pte2page(*ptep);
  1053c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1053c7:	8b 00                	mov    (%eax),%eax
  1053c9:	89 04 24             	mov    %eax,(%esp)
  1053cc:	e8 5a f5 ff ff       	call   10492b <pte2page>
  1053d1:	eb 05                	jmp    1053d8 <get_page+0x57>
    }
    return NULL;
  1053d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1053d8:	89 ec                	mov    %ebp,%esp
  1053da:	5d                   	pop    %ebp
  1053db:	c3                   	ret    

001053dc <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1053dc:	55                   	push   %ebp
  1053dd:	89 e5                	mov    %esp,%ebp
  1053df:	83 ec 28             	sub    $0x28,%esp
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
#if 1
    // (1) check if this page table entry is present
    // 如果二级表项存在
    if (*ptep & PTE_P) {
  1053e2:	8b 45 10             	mov    0x10(%ebp),%eax
  1053e5:	8b 00                	mov    (%eax),%eax
  1053e7:	83 e0 01             	and    $0x1,%eax
  1053ea:	85 c0                	test   %eax,%eax
  1053ec:	74 53                	je     105441 <page_remove_pte+0x65>
        // (2) find corresponding page to pte
        // 获取物理页对应的Page结构
        struct Page *page = pte2page(*ptep);
  1053ee:	8b 45 10             	mov    0x10(%ebp),%eax
  1053f1:	8b 00                	mov    (%eax),%eax
  1053f3:	89 04 24             	mov    %eax,(%esp)
  1053f6:	e8 30 f5 ff ff       	call   10492b <pte2page>
  1053fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // (3) decrease page reference
        // (4) and free this page when page reference reachs 0
        // 减少引用计数, 如果该页的引用计数变成0，释放该物理页
        if (page_ref_dec(page)==0){
  1053fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105401:	89 04 24             	mov    %eax,(%esp)
  105404:	e8 ab f5 ff ff       	call   1049b4 <page_ref_dec>
  105409:	85 c0                	test   %eax,%eax
  10540b:	75 13                	jne    105420 <page_remove_pte+0x44>
            free_page(page);
  10540d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105414:	00 
  105415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105418:	89 04 24             	mov    %eax,(%esp)
  10541b:	e8 af f7 ff ff       	call   104bcf <free_pages>
        }
        // (5) clear second page table entry
        // 将PTE的存在位设置为0(表示该映射关系无效)
        *ptep &= (~PTE_P); 
  105420:	8b 45 10             	mov    0x10(%ebp),%eax
  105423:	8b 00                	mov    (%eax),%eax
  105425:	83 e0 fe             	and    $0xfffffffe,%eax
  105428:	89 c2                	mov    %eax,%edx
  10542a:	8b 45 10             	mov    0x10(%ebp),%eax
  10542d:	89 10                	mov    %edx,(%eax)
        // (6) flush tlb
        // 刷新TLB(保证TLB中的缓存不会有错误的映射关系)
        tlb_invalidate(pgdir, la);
  10542f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105432:	89 44 24 04          	mov    %eax,0x4(%esp)
  105436:	8b 45 08             	mov    0x8(%ebp),%eax
  105439:	89 04 24             	mov    %eax,(%esp)
  10543c:	e8 07 01 00 00       	call   105548 <tlb_invalidate>
    }
#endif
}
  105441:	90                   	nop
  105442:	89 ec                	mov    %ebp,%esp
  105444:	5d                   	pop    %ebp
  105445:	c3                   	ret    

00105446 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  105446:	55                   	push   %ebp
  105447:	89 e5                	mov    %esp,%ebp
  105449:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10544c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105453:	00 
  105454:	8b 45 0c             	mov    0xc(%ebp),%eax
  105457:	89 44 24 04          	mov    %eax,0x4(%esp)
  10545b:	8b 45 08             	mov    0x8(%ebp),%eax
  10545e:	89 04 24             	mov    %eax,(%esp)
  105461:	e8 c1 fd ff ff       	call   105227 <get_pte>
  105466:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  105469:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10546d:	74 19                	je     105488 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  10546f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105472:	89 44 24 08          	mov    %eax,0x8(%esp)
  105476:	8b 45 0c             	mov    0xc(%ebp),%eax
  105479:	89 44 24 04          	mov    %eax,0x4(%esp)
  10547d:	8b 45 08             	mov    0x8(%ebp),%eax
  105480:	89 04 24             	mov    %eax,(%esp)
  105483:	e8 54 ff ff ff       	call   1053dc <page_remove_pte>
    }
}
  105488:	90                   	nop
  105489:	89 ec                	mov    %ebp,%esp
  10548b:	5d                   	pop    %ebp
  10548c:	c3                   	ret    

0010548d <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10548d:	55                   	push   %ebp
  10548e:	89 e5                	mov    %esp,%ebp
  105490:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  105493:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10549a:	00 
  10549b:	8b 45 10             	mov    0x10(%ebp),%eax
  10549e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1054a5:	89 04 24             	mov    %eax,(%esp)
  1054a8:	e8 7a fd ff ff       	call   105227 <get_pte>
  1054ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1054b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1054b4:	75 0a                	jne    1054c0 <page_insert+0x33>
        return -E_NO_MEM;
  1054b6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1054bb:	e9 84 00 00 00       	jmp    105544 <page_insert+0xb7>
    }
    page_ref_inc(page);
  1054c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054c3:	89 04 24             	mov    %eax,(%esp)
  1054c6:	e8 d2 f4 ff ff       	call   10499d <page_ref_inc>
    if (*ptep & PTE_P) {
  1054cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1054ce:	8b 00                	mov    (%eax),%eax
  1054d0:	83 e0 01             	and    $0x1,%eax
  1054d3:	85 c0                	test   %eax,%eax
  1054d5:	74 3e                	je     105515 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1054d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1054da:	8b 00                	mov    (%eax),%eax
  1054dc:	89 04 24             	mov    %eax,(%esp)
  1054df:	e8 47 f4 ff ff       	call   10492b <pte2page>
  1054e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1054e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1054ed:	75 0d                	jne    1054fc <page_insert+0x6f>
            page_ref_dec(page);
  1054ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054f2:	89 04 24             	mov    %eax,(%esp)
  1054f5:	e8 ba f4 ff ff       	call   1049b4 <page_ref_dec>
  1054fa:	eb 19                	jmp    105515 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1054fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1054ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  105503:	8b 45 10             	mov    0x10(%ebp),%eax
  105506:	89 44 24 04          	mov    %eax,0x4(%esp)
  10550a:	8b 45 08             	mov    0x8(%ebp),%eax
  10550d:	89 04 24             	mov    %eax,(%esp)
  105510:	e8 c7 fe ff ff       	call   1053dc <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  105515:	8b 45 0c             	mov    0xc(%ebp),%eax
  105518:	89 04 24             	mov    %eax,(%esp)
  10551b:	e8 4c f3 ff ff       	call   10486c <page2pa>
  105520:	0b 45 14             	or     0x14(%ebp),%eax
  105523:	83 c8 01             	or     $0x1,%eax
  105526:	89 c2                	mov    %eax,%edx
  105528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10552b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10552d:	8b 45 10             	mov    0x10(%ebp),%eax
  105530:	89 44 24 04          	mov    %eax,0x4(%esp)
  105534:	8b 45 08             	mov    0x8(%ebp),%eax
  105537:	89 04 24             	mov    %eax,(%esp)
  10553a:	e8 09 00 00 00       	call   105548 <tlb_invalidate>
    return 0;
  10553f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105544:	89 ec                	mov    %ebp,%esp
  105546:	5d                   	pop    %ebp
  105547:	c3                   	ret    

00105548 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  105548:	55                   	push   %ebp
  105549:	89 e5                	mov    %esp,%ebp
  10554b:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10554e:	0f 20 d8             	mov    %cr3,%eax
  105551:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  105554:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  105557:	8b 45 08             	mov    0x8(%ebp),%eax
  10555a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10555d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  105564:	77 23                	ja     105589 <tlb_invalidate+0x41>
  105566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105569:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10556d:	c7 44 24 08 9c 7b 10 	movl   $0x107b9c,0x8(%esp)
  105574:	00 
  105575:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
  10557c:	00 
  10557d:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105584:	e8 64 b7 ff ff       	call   100ced <__panic>
  105589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10558c:	05 00 00 00 40       	add    $0x40000000,%eax
  105591:	39 d0                	cmp    %edx,%eax
  105593:	75 0d                	jne    1055a2 <tlb_invalidate+0x5a>
        invlpg((void *)la);
  105595:	8b 45 0c             	mov    0xc(%ebp),%eax
  105598:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10559b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10559e:	0f 01 38             	invlpg (%eax)
}
  1055a1:	90                   	nop
    }
}
  1055a2:	90                   	nop
  1055a3:	89 ec                	mov    %ebp,%esp
  1055a5:	5d                   	pop    %ebp
  1055a6:	c3                   	ret    

001055a7 <check_alloc_page>:

static void
check_alloc_page(void) {
  1055a7:	55                   	push   %ebp
  1055a8:	89 e5                	mov    %esp,%ebp
  1055aa:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1055ad:	a1 ac ee 11 00       	mov    0x11eeac,%eax
  1055b2:	8b 40 18             	mov    0x18(%eax),%eax
  1055b5:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1055b7:	c7 04 24 20 7c 10 00 	movl   $0x107c20,(%esp)
  1055be:	e8 9e ad ff ff       	call   100361 <cprintf>
}
  1055c3:	90                   	nop
  1055c4:	89 ec                	mov    %ebp,%esp
  1055c6:	5d                   	pop    %ebp
  1055c7:	c3                   	ret    

001055c8 <check_pgdir>:

static void
check_pgdir(void) {
  1055c8:	55                   	push   %ebp
  1055c9:	89 e5                	mov    %esp,%ebp
  1055cb:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1055ce:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  1055d3:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1055d8:	76 24                	jbe    1055fe <check_pgdir+0x36>
  1055da:	c7 44 24 0c 3f 7c 10 	movl   $0x107c3f,0xc(%esp)
  1055e1:	00 
  1055e2:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  1055e9:	00 
  1055ea:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  1055f1:	00 
  1055f2:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  1055f9:	e8 ef b6 ff ff       	call   100ced <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1055fe:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105603:	85 c0                	test   %eax,%eax
  105605:	74 0e                	je     105615 <check_pgdir+0x4d>
  105607:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  10560c:	25 ff 0f 00 00       	and    $0xfff,%eax
  105611:	85 c0                	test   %eax,%eax
  105613:	74 24                	je     105639 <check_pgdir+0x71>
  105615:	c7 44 24 0c 5c 7c 10 	movl   $0x107c5c,0xc(%esp)
  10561c:	00 
  10561d:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105624:	00 
  105625:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  10562c:	00 
  10562d:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105634:	e8 b4 b6 ff ff       	call   100ced <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  105639:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  10563e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105645:	00 
  105646:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10564d:	00 
  10564e:	89 04 24             	mov    %eax,(%esp)
  105651:	e8 2b fd ff ff       	call   105381 <get_page>
  105656:	85 c0                	test   %eax,%eax
  105658:	74 24                	je     10567e <check_pgdir+0xb6>
  10565a:	c7 44 24 0c 94 7c 10 	movl   $0x107c94,0xc(%esp)
  105661:	00 
  105662:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105669:	00 
  10566a:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  105671:	00 
  105672:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105679:	e8 6f b6 ff ff       	call   100ced <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  10567e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105685:	e8 0b f5 ff ff       	call   104b95 <alloc_pages>
  10568a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  10568d:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105692:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  105699:	00 
  10569a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1056a1:	00 
  1056a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1056a5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1056a9:	89 04 24             	mov    %eax,(%esp)
  1056ac:	e8 dc fd ff ff       	call   10548d <page_insert>
  1056b1:	85 c0                	test   %eax,%eax
  1056b3:	74 24                	je     1056d9 <check_pgdir+0x111>
  1056b5:	c7 44 24 0c bc 7c 10 	movl   $0x107cbc,0xc(%esp)
  1056bc:	00 
  1056bd:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  1056c4:	00 
  1056c5:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  1056cc:	00 
  1056cd:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  1056d4:	e8 14 b6 ff ff       	call   100ced <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1056d9:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  1056de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1056e5:	00 
  1056e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1056ed:	00 
  1056ee:	89 04 24             	mov    %eax,(%esp)
  1056f1:	e8 31 fb ff ff       	call   105227 <get_pte>
  1056f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1056f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1056fd:	75 24                	jne    105723 <check_pgdir+0x15b>
  1056ff:	c7 44 24 0c e8 7c 10 	movl   $0x107ce8,0xc(%esp)
  105706:	00 
  105707:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  10570e:	00 
  10570f:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  105716:	00 
  105717:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  10571e:	e8 ca b5 ff ff       	call   100ced <__panic>
    assert(pte2page(*ptep) == p1);
  105723:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105726:	8b 00                	mov    (%eax),%eax
  105728:	89 04 24             	mov    %eax,(%esp)
  10572b:	e8 fb f1 ff ff       	call   10492b <pte2page>
  105730:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  105733:	74 24                	je     105759 <check_pgdir+0x191>
  105735:	c7 44 24 0c 15 7d 10 	movl   $0x107d15,0xc(%esp)
  10573c:	00 
  10573d:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105744:	00 
  105745:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  10574c:	00 
  10574d:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105754:	e8 94 b5 ff ff       	call   100ced <__panic>
    assert(page_ref(p1) == 1);
  105759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10575c:	89 04 24             	mov    %eax,(%esp)
  10575f:	e8 21 f2 ff ff       	call   104985 <page_ref>
  105764:	83 f8 01             	cmp    $0x1,%eax
  105767:	74 24                	je     10578d <check_pgdir+0x1c5>
  105769:	c7 44 24 0c 2b 7d 10 	movl   $0x107d2b,0xc(%esp)
  105770:	00 
  105771:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105778:	00 
  105779:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  105780:	00 
  105781:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105788:	e8 60 b5 ff ff       	call   100ced <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  10578d:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105792:	8b 00                	mov    (%eax),%eax
  105794:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105799:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10579c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10579f:	c1 e8 0c             	shr    $0xc,%eax
  1057a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1057a5:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  1057aa:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1057ad:	72 23                	jb     1057d2 <check_pgdir+0x20a>
  1057af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1057b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1057b6:	c7 44 24 08 f8 7a 10 	movl   $0x107af8,0x8(%esp)
  1057bd:	00 
  1057be:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  1057c5:	00 
  1057c6:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  1057cd:	e8 1b b5 ff ff       	call   100ced <__panic>
  1057d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1057d5:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1057da:	83 c0 04             	add    $0x4,%eax
  1057dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1057e0:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  1057e5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1057ec:	00 
  1057ed:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1057f4:	00 
  1057f5:	89 04 24             	mov    %eax,(%esp)
  1057f8:	e8 2a fa ff ff       	call   105227 <get_pte>
  1057fd:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  105800:	74 24                	je     105826 <check_pgdir+0x25e>
  105802:	c7 44 24 0c 40 7d 10 	movl   $0x107d40,0xc(%esp)
  105809:	00 
  10580a:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105811:	00 
  105812:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  105819:	00 
  10581a:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105821:	e8 c7 b4 ff ff       	call   100ced <__panic>

    p2 = alloc_page();
  105826:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10582d:	e8 63 f3 ff ff       	call   104b95 <alloc_pages>
  105832:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  105835:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  10583a:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  105841:	00 
  105842:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  105849:	00 
  10584a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10584d:	89 54 24 04          	mov    %edx,0x4(%esp)
  105851:	89 04 24             	mov    %eax,(%esp)
  105854:	e8 34 fc ff ff       	call   10548d <page_insert>
  105859:	85 c0                	test   %eax,%eax
  10585b:	74 24                	je     105881 <check_pgdir+0x2b9>
  10585d:	c7 44 24 0c 68 7d 10 	movl   $0x107d68,0xc(%esp)
  105864:	00 
  105865:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  10586c:	00 
  10586d:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  105874:	00 
  105875:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  10587c:	e8 6c b4 ff ff       	call   100ced <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  105881:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105886:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10588d:	00 
  10588e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  105895:	00 
  105896:	89 04 24             	mov    %eax,(%esp)
  105899:	e8 89 f9 ff ff       	call   105227 <get_pte>
  10589e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1058a5:	75 24                	jne    1058cb <check_pgdir+0x303>
  1058a7:	c7 44 24 0c a0 7d 10 	movl   $0x107da0,0xc(%esp)
  1058ae:	00 
  1058af:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  1058b6:	00 
  1058b7:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  1058be:	00 
  1058bf:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  1058c6:	e8 22 b4 ff ff       	call   100ced <__panic>
    assert(*ptep & PTE_U);
  1058cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058ce:	8b 00                	mov    (%eax),%eax
  1058d0:	83 e0 04             	and    $0x4,%eax
  1058d3:	85 c0                	test   %eax,%eax
  1058d5:	75 24                	jne    1058fb <check_pgdir+0x333>
  1058d7:	c7 44 24 0c d0 7d 10 	movl   $0x107dd0,0xc(%esp)
  1058de:	00 
  1058df:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  1058e6:	00 
  1058e7:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  1058ee:	00 
  1058ef:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  1058f6:	e8 f2 b3 ff ff       	call   100ced <__panic>
    assert(*ptep & PTE_W);
  1058fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058fe:	8b 00                	mov    (%eax),%eax
  105900:	83 e0 02             	and    $0x2,%eax
  105903:	85 c0                	test   %eax,%eax
  105905:	75 24                	jne    10592b <check_pgdir+0x363>
  105907:	c7 44 24 0c de 7d 10 	movl   $0x107dde,0xc(%esp)
  10590e:	00 
  10590f:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105916:	00 
  105917:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  10591e:	00 
  10591f:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105926:	e8 c2 b3 ff ff       	call   100ced <__panic>
    assert(boot_pgdir[0] & PTE_U);
  10592b:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105930:	8b 00                	mov    (%eax),%eax
  105932:	83 e0 04             	and    $0x4,%eax
  105935:	85 c0                	test   %eax,%eax
  105937:	75 24                	jne    10595d <check_pgdir+0x395>
  105939:	c7 44 24 0c ec 7d 10 	movl   $0x107dec,0xc(%esp)
  105940:	00 
  105941:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105948:	00 
  105949:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  105950:	00 
  105951:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105958:	e8 90 b3 ff ff       	call   100ced <__panic>
    assert(page_ref(p2) == 1);
  10595d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105960:	89 04 24             	mov    %eax,(%esp)
  105963:	e8 1d f0 ff ff       	call   104985 <page_ref>
  105968:	83 f8 01             	cmp    $0x1,%eax
  10596b:	74 24                	je     105991 <check_pgdir+0x3c9>
  10596d:	c7 44 24 0c 02 7e 10 	movl   $0x107e02,0xc(%esp)
  105974:	00 
  105975:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  10597c:	00 
  10597d:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  105984:	00 
  105985:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  10598c:	e8 5c b3 ff ff       	call   100ced <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  105991:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105996:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10599d:	00 
  10599e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1059a5:	00 
  1059a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1059ad:	89 04 24             	mov    %eax,(%esp)
  1059b0:	e8 d8 fa ff ff       	call   10548d <page_insert>
  1059b5:	85 c0                	test   %eax,%eax
  1059b7:	74 24                	je     1059dd <check_pgdir+0x415>
  1059b9:	c7 44 24 0c 14 7e 10 	movl   $0x107e14,0xc(%esp)
  1059c0:	00 
  1059c1:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  1059c8:	00 
  1059c9:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  1059d0:	00 
  1059d1:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  1059d8:	e8 10 b3 ff ff       	call   100ced <__panic>
    assert(page_ref(p1) == 2);
  1059dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1059e0:	89 04 24             	mov    %eax,(%esp)
  1059e3:	e8 9d ef ff ff       	call   104985 <page_ref>
  1059e8:	83 f8 02             	cmp    $0x2,%eax
  1059eb:	74 24                	je     105a11 <check_pgdir+0x449>
  1059ed:	c7 44 24 0c 40 7e 10 	movl   $0x107e40,0xc(%esp)
  1059f4:	00 
  1059f5:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  1059fc:	00 
  1059fd:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  105a04:	00 
  105a05:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105a0c:	e8 dc b2 ff ff       	call   100ced <__panic>
    assert(page_ref(p2) == 0);
  105a11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105a14:	89 04 24             	mov    %eax,(%esp)
  105a17:	e8 69 ef ff ff       	call   104985 <page_ref>
  105a1c:	85 c0                	test   %eax,%eax
  105a1e:	74 24                	je     105a44 <check_pgdir+0x47c>
  105a20:	c7 44 24 0c 52 7e 10 	movl   $0x107e52,0xc(%esp)
  105a27:	00 
  105a28:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105a2f:	00 
  105a30:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  105a37:	00 
  105a38:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105a3f:	e8 a9 b2 ff ff       	call   100ced <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  105a44:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105a49:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105a50:	00 
  105a51:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  105a58:	00 
  105a59:	89 04 24             	mov    %eax,(%esp)
  105a5c:	e8 c6 f7 ff ff       	call   105227 <get_pte>
  105a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105a68:	75 24                	jne    105a8e <check_pgdir+0x4c6>
  105a6a:	c7 44 24 0c a0 7d 10 	movl   $0x107da0,0xc(%esp)
  105a71:	00 
  105a72:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105a79:	00 
  105a7a:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  105a81:	00 
  105a82:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105a89:	e8 5f b2 ff ff       	call   100ced <__panic>
    assert(pte2page(*ptep) == p1);
  105a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a91:	8b 00                	mov    (%eax),%eax
  105a93:	89 04 24             	mov    %eax,(%esp)
  105a96:	e8 90 ee ff ff       	call   10492b <pte2page>
  105a9b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  105a9e:	74 24                	je     105ac4 <check_pgdir+0x4fc>
  105aa0:	c7 44 24 0c 15 7d 10 	movl   $0x107d15,0xc(%esp)
  105aa7:	00 
  105aa8:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105aaf:	00 
  105ab0:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  105ab7:	00 
  105ab8:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105abf:	e8 29 b2 ff ff       	call   100ced <__panic>
    assert((*ptep & PTE_U) == 0);
  105ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ac7:	8b 00                	mov    (%eax),%eax
  105ac9:	83 e0 04             	and    $0x4,%eax
  105acc:	85 c0                	test   %eax,%eax
  105ace:	74 24                	je     105af4 <check_pgdir+0x52c>
  105ad0:	c7 44 24 0c 64 7e 10 	movl   $0x107e64,0xc(%esp)
  105ad7:	00 
  105ad8:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105adf:	00 
  105ae0:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  105ae7:	00 
  105ae8:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105aef:	e8 f9 b1 ff ff       	call   100ced <__panic>

    page_remove(boot_pgdir, 0x0);
  105af4:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105af9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105b00:	00 
  105b01:	89 04 24             	mov    %eax,(%esp)
  105b04:	e8 3d f9 ff ff       	call   105446 <page_remove>
    assert(page_ref(p1) == 1);
  105b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b0c:	89 04 24             	mov    %eax,(%esp)
  105b0f:	e8 71 ee ff ff       	call   104985 <page_ref>
  105b14:	83 f8 01             	cmp    $0x1,%eax
  105b17:	74 24                	je     105b3d <check_pgdir+0x575>
  105b19:	c7 44 24 0c 2b 7d 10 	movl   $0x107d2b,0xc(%esp)
  105b20:	00 
  105b21:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105b28:	00 
  105b29:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  105b30:	00 
  105b31:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105b38:	e8 b0 b1 ff ff       	call   100ced <__panic>
    assert(page_ref(p2) == 0);
  105b3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105b40:	89 04 24             	mov    %eax,(%esp)
  105b43:	e8 3d ee ff ff       	call   104985 <page_ref>
  105b48:	85 c0                	test   %eax,%eax
  105b4a:	74 24                	je     105b70 <check_pgdir+0x5a8>
  105b4c:	c7 44 24 0c 52 7e 10 	movl   $0x107e52,0xc(%esp)
  105b53:	00 
  105b54:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105b5b:	00 
  105b5c:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  105b63:	00 
  105b64:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105b6b:	e8 7d b1 ff ff       	call   100ced <__panic>

    page_remove(boot_pgdir, PGSIZE);
  105b70:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105b75:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  105b7c:	00 
  105b7d:	89 04 24             	mov    %eax,(%esp)
  105b80:	e8 c1 f8 ff ff       	call   105446 <page_remove>
    assert(page_ref(p1) == 0);
  105b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b88:	89 04 24             	mov    %eax,(%esp)
  105b8b:	e8 f5 ed ff ff       	call   104985 <page_ref>
  105b90:	85 c0                	test   %eax,%eax
  105b92:	74 24                	je     105bb8 <check_pgdir+0x5f0>
  105b94:	c7 44 24 0c 79 7e 10 	movl   $0x107e79,0xc(%esp)
  105b9b:	00 
  105b9c:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105ba3:	00 
  105ba4:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  105bab:	00 
  105bac:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105bb3:	e8 35 b1 ff ff       	call   100ced <__panic>
    assert(page_ref(p2) == 0);
  105bb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105bbb:	89 04 24             	mov    %eax,(%esp)
  105bbe:	e8 c2 ed ff ff       	call   104985 <page_ref>
  105bc3:	85 c0                	test   %eax,%eax
  105bc5:	74 24                	je     105beb <check_pgdir+0x623>
  105bc7:	c7 44 24 0c 52 7e 10 	movl   $0x107e52,0xc(%esp)
  105bce:	00 
  105bcf:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105bd6:	00 
  105bd7:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  105bde:	00 
  105bdf:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105be6:	e8 02 b1 ff ff       	call   100ced <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  105beb:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105bf0:	8b 00                	mov    (%eax),%eax
  105bf2:	89 04 24             	mov    %eax,(%esp)
  105bf5:	e8 71 ed ff ff       	call   10496b <pde2page>
  105bfa:	89 04 24             	mov    %eax,(%esp)
  105bfd:	e8 83 ed ff ff       	call   104985 <page_ref>
  105c02:	83 f8 01             	cmp    $0x1,%eax
  105c05:	74 24                	je     105c2b <check_pgdir+0x663>
  105c07:	c7 44 24 0c 8c 7e 10 	movl   $0x107e8c,0xc(%esp)
  105c0e:	00 
  105c0f:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105c16:	00 
  105c17:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  105c1e:	00 
  105c1f:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105c26:	e8 c2 b0 ff ff       	call   100ced <__panic>
    free_page(pde2page(boot_pgdir[0]));
  105c2b:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105c30:	8b 00                	mov    (%eax),%eax
  105c32:	89 04 24             	mov    %eax,(%esp)
  105c35:	e8 31 ed ff ff       	call   10496b <pde2page>
  105c3a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105c41:	00 
  105c42:	89 04 24             	mov    %eax,(%esp)
  105c45:	e8 85 ef ff ff       	call   104bcf <free_pages>
    boot_pgdir[0] = 0;
  105c4a:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105c4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  105c55:	c7 04 24 b3 7e 10 00 	movl   $0x107eb3,(%esp)
  105c5c:	e8 00 a7 ff ff       	call   100361 <cprintf>
}
  105c61:	90                   	nop
  105c62:	89 ec                	mov    %ebp,%esp
  105c64:	5d                   	pop    %ebp
  105c65:	c3                   	ret    

00105c66 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  105c66:	55                   	push   %ebp
  105c67:	89 e5                	mov    %esp,%ebp
  105c69:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  105c6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  105c73:	e9 ca 00 00 00       	jmp    105d42 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  105c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105c7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105c81:	c1 e8 0c             	shr    $0xc,%eax
  105c84:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105c87:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  105c8c:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  105c8f:	72 23                	jb     105cb4 <check_boot_pgdir+0x4e>
  105c91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105c94:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105c98:	c7 44 24 08 f8 7a 10 	movl   $0x107af8,0x8(%esp)
  105c9f:	00 
  105ca0:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  105ca7:	00 
  105ca8:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105caf:	e8 39 b0 ff ff       	call   100ced <__panic>
  105cb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105cb7:	2d 00 00 00 40       	sub    $0x40000000,%eax
  105cbc:	89 c2                	mov    %eax,%edx
  105cbe:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105cc3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105cca:	00 
  105ccb:	89 54 24 04          	mov    %edx,0x4(%esp)
  105ccf:	89 04 24             	mov    %eax,(%esp)
  105cd2:	e8 50 f5 ff ff       	call   105227 <get_pte>
  105cd7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  105cda:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105cde:	75 24                	jne    105d04 <check_boot_pgdir+0x9e>
  105ce0:	c7 44 24 0c d0 7e 10 	movl   $0x107ed0,0xc(%esp)
  105ce7:	00 
  105ce8:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105cef:	00 
  105cf0:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  105cf7:	00 
  105cf8:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105cff:	e8 e9 af ff ff       	call   100ced <__panic>
        assert(PTE_ADDR(*ptep) == i);
  105d04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105d07:	8b 00                	mov    (%eax),%eax
  105d09:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105d0e:	89 c2                	mov    %eax,%edx
  105d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d13:	39 c2                	cmp    %eax,%edx
  105d15:	74 24                	je     105d3b <check_boot_pgdir+0xd5>
  105d17:	c7 44 24 0c 0d 7f 10 	movl   $0x107f0d,0xc(%esp)
  105d1e:	00 
  105d1f:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105d26:	00 
  105d27:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  105d2e:	00 
  105d2f:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105d36:	e8 b2 af ff ff       	call   100ced <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  105d3b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  105d42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d45:	a1 a4 ee 11 00       	mov    0x11eea4,%eax
  105d4a:	39 c2                	cmp    %eax,%edx
  105d4c:	0f 82 26 ff ff ff    	jb     105c78 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  105d52:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105d57:	05 ac 0f 00 00       	add    $0xfac,%eax
  105d5c:	8b 00                	mov    (%eax),%eax
  105d5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105d63:	89 c2                	mov    %eax,%edx
  105d65:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105d6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d6d:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  105d74:	77 23                	ja     105d99 <check_boot_pgdir+0x133>
  105d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d79:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105d7d:	c7 44 24 08 9c 7b 10 	movl   $0x107b9c,0x8(%esp)
  105d84:	00 
  105d85:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  105d8c:	00 
  105d8d:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105d94:	e8 54 af ff ff       	call   100ced <__panic>
  105d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d9c:	05 00 00 00 40       	add    $0x40000000,%eax
  105da1:	39 d0                	cmp    %edx,%eax
  105da3:	74 24                	je     105dc9 <check_boot_pgdir+0x163>
  105da5:	c7 44 24 0c 24 7f 10 	movl   $0x107f24,0xc(%esp)
  105dac:	00 
  105dad:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105db4:	00 
  105db5:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  105dbc:	00 
  105dbd:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105dc4:	e8 24 af ff ff       	call   100ced <__panic>

    assert(boot_pgdir[0] == 0);
  105dc9:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105dce:	8b 00                	mov    (%eax),%eax
  105dd0:	85 c0                	test   %eax,%eax
  105dd2:	74 24                	je     105df8 <check_boot_pgdir+0x192>
  105dd4:	c7 44 24 0c 58 7f 10 	movl   $0x107f58,0xc(%esp)
  105ddb:	00 
  105ddc:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105de3:	00 
  105de4:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
  105deb:	00 
  105dec:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105df3:	e8 f5 ae ff ff       	call   100ced <__panic>

    struct Page *p;
    p = alloc_page();
  105df8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105dff:	e8 91 ed ff ff       	call   104b95 <alloc_pages>
  105e04:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  105e07:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105e0c:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105e13:	00 
  105e14:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  105e1b:	00 
  105e1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105e1f:	89 54 24 04          	mov    %edx,0x4(%esp)
  105e23:	89 04 24             	mov    %eax,(%esp)
  105e26:	e8 62 f6 ff ff       	call   10548d <page_insert>
  105e2b:	85 c0                	test   %eax,%eax
  105e2d:	74 24                	je     105e53 <check_boot_pgdir+0x1ed>
  105e2f:	c7 44 24 0c 6c 7f 10 	movl   $0x107f6c,0xc(%esp)
  105e36:	00 
  105e37:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105e3e:	00 
  105e3f:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
  105e46:	00 
  105e47:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105e4e:	e8 9a ae ff ff       	call   100ced <__panic>
    assert(page_ref(p) == 1);
  105e53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e56:	89 04 24             	mov    %eax,(%esp)
  105e59:	e8 27 eb ff ff       	call   104985 <page_ref>
  105e5e:	83 f8 01             	cmp    $0x1,%eax
  105e61:	74 24                	je     105e87 <check_boot_pgdir+0x221>
  105e63:	c7 44 24 0c 9a 7f 10 	movl   $0x107f9a,0xc(%esp)
  105e6a:	00 
  105e6b:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105e72:	00 
  105e73:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
  105e7a:	00 
  105e7b:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105e82:	e8 66 ae ff ff       	call   100ced <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  105e87:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105e8c:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105e93:	00 
  105e94:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  105e9b:	00 
  105e9c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105e9f:	89 54 24 04          	mov    %edx,0x4(%esp)
  105ea3:	89 04 24             	mov    %eax,(%esp)
  105ea6:	e8 e2 f5 ff ff       	call   10548d <page_insert>
  105eab:	85 c0                	test   %eax,%eax
  105ead:	74 24                	je     105ed3 <check_boot_pgdir+0x26d>
  105eaf:	c7 44 24 0c ac 7f 10 	movl   $0x107fac,0xc(%esp)
  105eb6:	00 
  105eb7:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105ebe:	00 
  105ebf:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
  105ec6:	00 
  105ec7:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105ece:	e8 1a ae ff ff       	call   100ced <__panic>
    assert(page_ref(p) == 2);
  105ed3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ed6:	89 04 24             	mov    %eax,(%esp)
  105ed9:	e8 a7 ea ff ff       	call   104985 <page_ref>
  105ede:	83 f8 02             	cmp    $0x2,%eax
  105ee1:	74 24                	je     105f07 <check_boot_pgdir+0x2a1>
  105ee3:	c7 44 24 0c e3 7f 10 	movl   $0x107fe3,0xc(%esp)
  105eea:	00 
  105eeb:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105ef2:	00 
  105ef3:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  105efa:	00 
  105efb:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105f02:	e8 e6 ad ff ff       	call   100ced <__panic>

    const char *str = "ucore: Hello world!!";
  105f07:	c7 45 e8 f4 7f 10 00 	movl   $0x107ff4,-0x18(%ebp)
    strcpy((void *)0x100, str);
  105f0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f11:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f15:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105f1c:	e8 fc 09 00 00       	call   10691d <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  105f21:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  105f28:	00 
  105f29:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105f30:	e8 60 0a 00 00       	call   106995 <strcmp>
  105f35:	85 c0                	test   %eax,%eax
  105f37:	74 24                	je     105f5d <check_boot_pgdir+0x2f7>
  105f39:	c7 44 24 0c 0c 80 10 	movl   $0x10800c,0xc(%esp)
  105f40:	00 
  105f41:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105f48:	00 
  105f49:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
  105f50:	00 
  105f51:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105f58:	e8 90 ad ff ff       	call   100ced <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  105f5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f60:	89 04 24             	mov    %eax,(%esp)
  105f63:	e8 6d e9 ff ff       	call   1048d5 <page2kva>
  105f68:	05 00 01 00 00       	add    $0x100,%eax
  105f6d:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  105f70:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105f77:	e8 47 09 00 00       	call   1068c3 <strlen>
  105f7c:	85 c0                	test   %eax,%eax
  105f7e:	74 24                	je     105fa4 <check_boot_pgdir+0x33e>
  105f80:	c7 44 24 0c 44 80 10 	movl   $0x108044,0xc(%esp)
  105f87:	00 
  105f88:	c7 44 24 08 e5 7b 10 	movl   $0x107be5,0x8(%esp)
  105f8f:	00 
  105f90:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  105f97:	00 
  105f98:	c7 04 24 c0 7b 10 00 	movl   $0x107bc0,(%esp)
  105f9f:	e8 49 ad ff ff       	call   100ced <__panic>

    free_page(p);
  105fa4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105fab:	00 
  105fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105faf:	89 04 24             	mov    %eax,(%esp)
  105fb2:	e8 18 ec ff ff       	call   104bcf <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  105fb7:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105fbc:	8b 00                	mov    (%eax),%eax
  105fbe:	89 04 24             	mov    %eax,(%esp)
  105fc1:	e8 a5 e9 ff ff       	call   10496b <pde2page>
  105fc6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105fcd:	00 
  105fce:	89 04 24             	mov    %eax,(%esp)
  105fd1:	e8 f9 eb ff ff       	call   104bcf <free_pages>
    boot_pgdir[0] = 0;
  105fd6:	a1 e0 b9 11 00       	mov    0x11b9e0,%eax
  105fdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  105fe1:	c7 04 24 68 80 10 00 	movl   $0x108068,(%esp)
  105fe8:	e8 74 a3 ff ff       	call   100361 <cprintf>
}
  105fed:	90                   	nop
  105fee:	89 ec                	mov    %ebp,%esp
  105ff0:	5d                   	pop    %ebp
  105ff1:	c3                   	ret    

00105ff2 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  105ff2:	55                   	push   %ebp
  105ff3:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  105ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ff8:	83 e0 04             	and    $0x4,%eax
  105ffb:	85 c0                	test   %eax,%eax
  105ffd:	74 04                	je     106003 <perm2str+0x11>
  105fff:	b0 75                	mov    $0x75,%al
  106001:	eb 02                	jmp    106005 <perm2str+0x13>
  106003:	b0 2d                	mov    $0x2d,%al
  106005:	a2 28 ef 11 00       	mov    %al,0x11ef28
    str[1] = 'r';
  10600a:	c6 05 29 ef 11 00 72 	movb   $0x72,0x11ef29
    str[2] = (perm & PTE_W) ? 'w' : '-';
  106011:	8b 45 08             	mov    0x8(%ebp),%eax
  106014:	83 e0 02             	and    $0x2,%eax
  106017:	85 c0                	test   %eax,%eax
  106019:	74 04                	je     10601f <perm2str+0x2d>
  10601b:	b0 77                	mov    $0x77,%al
  10601d:	eb 02                	jmp    106021 <perm2str+0x2f>
  10601f:	b0 2d                	mov    $0x2d,%al
  106021:	a2 2a ef 11 00       	mov    %al,0x11ef2a
    str[3] = '\0';
  106026:	c6 05 2b ef 11 00 00 	movb   $0x0,0x11ef2b
    return str;
  10602d:	b8 28 ef 11 00       	mov    $0x11ef28,%eax
}
  106032:	5d                   	pop    %ebp
  106033:	c3                   	ret    

00106034 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  106034:	55                   	push   %ebp
  106035:	89 e5                	mov    %esp,%ebp
  106037:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  10603a:	8b 45 10             	mov    0x10(%ebp),%eax
  10603d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  106040:	72 0d                	jb     10604f <get_pgtable_items+0x1b>
        return 0;
  106042:	b8 00 00 00 00       	mov    $0x0,%eax
  106047:	e9 98 00 00 00       	jmp    1060e4 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  10604c:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  10604f:	8b 45 10             	mov    0x10(%ebp),%eax
  106052:	3b 45 0c             	cmp    0xc(%ebp),%eax
  106055:	73 18                	jae    10606f <get_pgtable_items+0x3b>
  106057:	8b 45 10             	mov    0x10(%ebp),%eax
  10605a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  106061:	8b 45 14             	mov    0x14(%ebp),%eax
  106064:	01 d0                	add    %edx,%eax
  106066:	8b 00                	mov    (%eax),%eax
  106068:	83 e0 01             	and    $0x1,%eax
  10606b:	85 c0                	test   %eax,%eax
  10606d:	74 dd                	je     10604c <get_pgtable_items+0x18>
    }
    if (start < right) {
  10606f:	8b 45 10             	mov    0x10(%ebp),%eax
  106072:	3b 45 0c             	cmp    0xc(%ebp),%eax
  106075:	73 68                	jae    1060df <get_pgtable_items+0xab>
        if (left_store != NULL) {
  106077:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  10607b:	74 08                	je     106085 <get_pgtable_items+0x51>
            *left_store = start;
  10607d:	8b 45 18             	mov    0x18(%ebp),%eax
  106080:	8b 55 10             	mov    0x10(%ebp),%edx
  106083:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  106085:	8b 45 10             	mov    0x10(%ebp),%eax
  106088:	8d 50 01             	lea    0x1(%eax),%edx
  10608b:	89 55 10             	mov    %edx,0x10(%ebp)
  10608e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  106095:	8b 45 14             	mov    0x14(%ebp),%eax
  106098:	01 d0                	add    %edx,%eax
  10609a:	8b 00                	mov    (%eax),%eax
  10609c:	83 e0 07             	and    $0x7,%eax
  10609f:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1060a2:	eb 03                	jmp    1060a7 <get_pgtable_items+0x73>
            start ++;
  1060a4:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1060a7:	8b 45 10             	mov    0x10(%ebp),%eax
  1060aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1060ad:	73 1d                	jae    1060cc <get_pgtable_items+0x98>
  1060af:	8b 45 10             	mov    0x10(%ebp),%eax
  1060b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1060b9:	8b 45 14             	mov    0x14(%ebp),%eax
  1060bc:	01 d0                	add    %edx,%eax
  1060be:	8b 00                	mov    (%eax),%eax
  1060c0:	83 e0 07             	and    $0x7,%eax
  1060c3:	89 c2                	mov    %eax,%edx
  1060c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1060c8:	39 c2                	cmp    %eax,%edx
  1060ca:	74 d8                	je     1060a4 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
  1060cc:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1060d0:	74 08                	je     1060da <get_pgtable_items+0xa6>
            *right_store = start;
  1060d2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1060d5:	8b 55 10             	mov    0x10(%ebp),%edx
  1060d8:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1060da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1060dd:	eb 05                	jmp    1060e4 <get_pgtable_items+0xb0>
    }
    return 0;
  1060df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1060e4:	89 ec                	mov    %ebp,%esp
  1060e6:	5d                   	pop    %ebp
  1060e7:	c3                   	ret    

001060e8 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1060e8:	55                   	push   %ebp
  1060e9:	89 e5                	mov    %esp,%ebp
  1060eb:	57                   	push   %edi
  1060ec:	56                   	push   %esi
  1060ed:	53                   	push   %ebx
  1060ee:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1060f1:	c7 04 24 88 80 10 00 	movl   $0x108088,(%esp)
  1060f8:	e8 64 a2 ff ff       	call   100361 <cprintf>
    size_t left, right = 0, perm;
  1060fd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  106104:	e9 f2 00 00 00       	jmp    1061fb <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  106109:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10610c:	89 04 24             	mov    %eax,(%esp)
  10610f:	e8 de fe ff ff       	call   105ff2 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  106114:	8b 55 dc             	mov    -0x24(%ebp),%edx
  106117:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  10611a:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10611c:	89 d6                	mov    %edx,%esi
  10611e:	c1 e6 16             	shl    $0x16,%esi
  106121:	8b 55 dc             	mov    -0x24(%ebp),%edx
  106124:	89 d3                	mov    %edx,%ebx
  106126:	c1 e3 16             	shl    $0x16,%ebx
  106129:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10612c:	89 d1                	mov    %edx,%ecx
  10612e:	c1 e1 16             	shl    $0x16,%ecx
  106131:	8b 55 dc             	mov    -0x24(%ebp),%edx
  106134:	8b 7d e0             	mov    -0x20(%ebp),%edi
  106137:	29 fa                	sub    %edi,%edx
  106139:	89 44 24 14          	mov    %eax,0x14(%esp)
  10613d:	89 74 24 10          	mov    %esi,0x10(%esp)
  106141:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  106145:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  106149:	89 54 24 04          	mov    %edx,0x4(%esp)
  10614d:	c7 04 24 b9 80 10 00 	movl   $0x1080b9,(%esp)
  106154:	e8 08 a2 ff ff       	call   100361 <cprintf>
        size_t l, r = left * NPTEENTRY;
  106159:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10615c:	c1 e0 0a             	shl    $0xa,%eax
  10615f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  106162:	eb 50                	jmp    1061b4 <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  106164:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106167:	89 04 24             	mov    %eax,(%esp)
  10616a:	e8 83 fe ff ff       	call   105ff2 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  10616f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  106172:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  106175:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  106177:	89 d6                	mov    %edx,%esi
  106179:	c1 e6 0c             	shl    $0xc,%esi
  10617c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10617f:	89 d3                	mov    %edx,%ebx
  106181:	c1 e3 0c             	shl    $0xc,%ebx
  106184:	8b 55 d8             	mov    -0x28(%ebp),%edx
  106187:	89 d1                	mov    %edx,%ecx
  106189:	c1 e1 0c             	shl    $0xc,%ecx
  10618c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10618f:	8b 7d d8             	mov    -0x28(%ebp),%edi
  106192:	29 fa                	sub    %edi,%edx
  106194:	89 44 24 14          	mov    %eax,0x14(%esp)
  106198:	89 74 24 10          	mov    %esi,0x10(%esp)
  10619c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1061a0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1061a4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1061a8:	c7 04 24 d8 80 10 00 	movl   $0x1080d8,(%esp)
  1061af:	e8 ad a1 ff ff       	call   100361 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1061b4:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  1061b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1061bc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1061bf:	89 d3                	mov    %edx,%ebx
  1061c1:	c1 e3 0a             	shl    $0xa,%ebx
  1061c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1061c7:	89 d1                	mov    %edx,%ecx
  1061c9:	c1 e1 0a             	shl    $0xa,%ecx
  1061cc:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  1061cf:	89 54 24 14          	mov    %edx,0x14(%esp)
  1061d3:	8d 55 d8             	lea    -0x28(%ebp),%edx
  1061d6:	89 54 24 10          	mov    %edx,0x10(%esp)
  1061da:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1061de:	89 44 24 08          	mov    %eax,0x8(%esp)
  1061e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1061e6:	89 0c 24             	mov    %ecx,(%esp)
  1061e9:	e8 46 fe ff ff       	call   106034 <get_pgtable_items>
  1061ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1061f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1061f5:	0f 85 69 ff ff ff    	jne    106164 <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1061fb:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  106200:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106203:	8d 55 dc             	lea    -0x24(%ebp),%edx
  106206:	89 54 24 14          	mov    %edx,0x14(%esp)
  10620a:	8d 55 e0             	lea    -0x20(%ebp),%edx
  10620d:	89 54 24 10          	mov    %edx,0x10(%esp)
  106211:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  106215:	89 44 24 08          	mov    %eax,0x8(%esp)
  106219:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  106220:	00 
  106221:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  106228:	e8 07 fe ff ff       	call   106034 <get_pgtable_items>
  10622d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106230:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106234:	0f 85 cf fe ff ff    	jne    106109 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  10623a:	c7 04 24 fc 80 10 00 	movl   $0x1080fc,(%esp)
  106241:	e8 1b a1 ff ff       	call   100361 <cprintf>
}
  106246:	90                   	nop
  106247:	83 c4 4c             	add    $0x4c,%esp
  10624a:	5b                   	pop    %ebx
  10624b:	5e                   	pop    %esi
  10624c:	5f                   	pop    %edi
  10624d:	5d                   	pop    %ebp
  10624e:	c3                   	ret    

0010624f <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10624f:	55                   	push   %ebp
  106250:	89 e5                	mov    %esp,%ebp
  106252:	83 ec 58             	sub    $0x58,%esp
  106255:	8b 45 10             	mov    0x10(%ebp),%eax
  106258:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10625b:	8b 45 14             	mov    0x14(%ebp),%eax
  10625e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  106261:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106264:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  106267:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10626a:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10626d:	8b 45 18             	mov    0x18(%ebp),%eax
  106270:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106273:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106276:	8b 55 ec             	mov    -0x14(%ebp),%edx
  106279:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10627c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10627f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106282:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106285:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  106289:	74 1c                	je     1062a7 <printnum+0x58>
  10628b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10628e:	ba 00 00 00 00       	mov    $0x0,%edx
  106293:	f7 75 e4             	divl   -0x1c(%ebp)
  106296:	89 55 f4             	mov    %edx,-0xc(%ebp)
  106299:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10629c:	ba 00 00 00 00       	mov    $0x0,%edx
  1062a1:	f7 75 e4             	divl   -0x1c(%ebp)
  1062a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1062a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1062aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1062ad:	f7 75 e4             	divl   -0x1c(%ebp)
  1062b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1062b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1062b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1062b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1062bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1062bf:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1062c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1062c5:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1062c8:	8b 45 18             	mov    0x18(%ebp),%eax
  1062cb:	ba 00 00 00 00       	mov    $0x0,%edx
  1062d0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1062d3:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1062d6:	19 d1                	sbb    %edx,%ecx
  1062d8:	72 4c                	jb     106326 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
  1062da:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1062dd:	8d 50 ff             	lea    -0x1(%eax),%edx
  1062e0:	8b 45 20             	mov    0x20(%ebp),%eax
  1062e3:	89 44 24 18          	mov    %eax,0x18(%esp)
  1062e7:	89 54 24 14          	mov    %edx,0x14(%esp)
  1062eb:	8b 45 18             	mov    0x18(%ebp),%eax
  1062ee:	89 44 24 10          	mov    %eax,0x10(%esp)
  1062f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1062f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1062f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1062fc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106300:	8b 45 0c             	mov    0xc(%ebp),%eax
  106303:	89 44 24 04          	mov    %eax,0x4(%esp)
  106307:	8b 45 08             	mov    0x8(%ebp),%eax
  10630a:	89 04 24             	mov    %eax,(%esp)
  10630d:	e8 3d ff ff ff       	call   10624f <printnum>
  106312:	eb 1b                	jmp    10632f <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  106314:	8b 45 0c             	mov    0xc(%ebp),%eax
  106317:	89 44 24 04          	mov    %eax,0x4(%esp)
  10631b:	8b 45 20             	mov    0x20(%ebp),%eax
  10631e:	89 04 24             	mov    %eax,(%esp)
  106321:	8b 45 08             	mov    0x8(%ebp),%eax
  106324:	ff d0                	call   *%eax
        while (-- width > 0)
  106326:	ff 4d 1c             	decl   0x1c(%ebp)
  106329:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10632d:	7f e5                	jg     106314 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10632f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  106332:	05 b0 81 10 00       	add    $0x1081b0,%eax
  106337:	0f b6 00             	movzbl (%eax),%eax
  10633a:	0f be c0             	movsbl %al,%eax
  10633d:	8b 55 0c             	mov    0xc(%ebp),%edx
  106340:	89 54 24 04          	mov    %edx,0x4(%esp)
  106344:	89 04 24             	mov    %eax,(%esp)
  106347:	8b 45 08             	mov    0x8(%ebp),%eax
  10634a:	ff d0                	call   *%eax
}
  10634c:	90                   	nop
  10634d:	89 ec                	mov    %ebp,%esp
  10634f:	5d                   	pop    %ebp
  106350:	c3                   	ret    

00106351 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  106351:	55                   	push   %ebp
  106352:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  106354:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  106358:	7e 14                	jle    10636e <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  10635a:	8b 45 08             	mov    0x8(%ebp),%eax
  10635d:	8b 00                	mov    (%eax),%eax
  10635f:	8d 48 08             	lea    0x8(%eax),%ecx
  106362:	8b 55 08             	mov    0x8(%ebp),%edx
  106365:	89 0a                	mov    %ecx,(%edx)
  106367:	8b 50 04             	mov    0x4(%eax),%edx
  10636a:	8b 00                	mov    (%eax),%eax
  10636c:	eb 30                	jmp    10639e <getuint+0x4d>
    }
    else if (lflag) {
  10636e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106372:	74 16                	je     10638a <getuint+0x39>
        return va_arg(*ap, unsigned long);
  106374:	8b 45 08             	mov    0x8(%ebp),%eax
  106377:	8b 00                	mov    (%eax),%eax
  106379:	8d 48 04             	lea    0x4(%eax),%ecx
  10637c:	8b 55 08             	mov    0x8(%ebp),%edx
  10637f:	89 0a                	mov    %ecx,(%edx)
  106381:	8b 00                	mov    (%eax),%eax
  106383:	ba 00 00 00 00       	mov    $0x0,%edx
  106388:	eb 14                	jmp    10639e <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  10638a:	8b 45 08             	mov    0x8(%ebp),%eax
  10638d:	8b 00                	mov    (%eax),%eax
  10638f:	8d 48 04             	lea    0x4(%eax),%ecx
  106392:	8b 55 08             	mov    0x8(%ebp),%edx
  106395:	89 0a                	mov    %ecx,(%edx)
  106397:	8b 00                	mov    (%eax),%eax
  106399:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10639e:	5d                   	pop    %ebp
  10639f:	c3                   	ret    

001063a0 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1063a0:	55                   	push   %ebp
  1063a1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1063a3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1063a7:	7e 14                	jle    1063bd <getint+0x1d>
        return va_arg(*ap, long long);
  1063a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1063ac:	8b 00                	mov    (%eax),%eax
  1063ae:	8d 48 08             	lea    0x8(%eax),%ecx
  1063b1:	8b 55 08             	mov    0x8(%ebp),%edx
  1063b4:	89 0a                	mov    %ecx,(%edx)
  1063b6:	8b 50 04             	mov    0x4(%eax),%edx
  1063b9:	8b 00                	mov    (%eax),%eax
  1063bb:	eb 28                	jmp    1063e5 <getint+0x45>
    }
    else if (lflag) {
  1063bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1063c1:	74 12                	je     1063d5 <getint+0x35>
        return va_arg(*ap, long);
  1063c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1063c6:	8b 00                	mov    (%eax),%eax
  1063c8:	8d 48 04             	lea    0x4(%eax),%ecx
  1063cb:	8b 55 08             	mov    0x8(%ebp),%edx
  1063ce:	89 0a                	mov    %ecx,(%edx)
  1063d0:	8b 00                	mov    (%eax),%eax
  1063d2:	99                   	cltd   
  1063d3:	eb 10                	jmp    1063e5 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1063d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1063d8:	8b 00                	mov    (%eax),%eax
  1063da:	8d 48 04             	lea    0x4(%eax),%ecx
  1063dd:	8b 55 08             	mov    0x8(%ebp),%edx
  1063e0:	89 0a                	mov    %ecx,(%edx)
  1063e2:	8b 00                	mov    (%eax),%eax
  1063e4:	99                   	cltd   
    }
}
  1063e5:	5d                   	pop    %ebp
  1063e6:	c3                   	ret    

001063e7 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1063e7:	55                   	push   %ebp
  1063e8:	89 e5                	mov    %esp,%ebp
  1063ea:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1063ed:	8d 45 14             	lea    0x14(%ebp),%eax
  1063f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1063f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1063f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1063fa:	8b 45 10             	mov    0x10(%ebp),%eax
  1063fd:	89 44 24 08          	mov    %eax,0x8(%esp)
  106401:	8b 45 0c             	mov    0xc(%ebp),%eax
  106404:	89 44 24 04          	mov    %eax,0x4(%esp)
  106408:	8b 45 08             	mov    0x8(%ebp),%eax
  10640b:	89 04 24             	mov    %eax,(%esp)
  10640e:	e8 05 00 00 00       	call   106418 <vprintfmt>
    va_end(ap);
}
  106413:	90                   	nop
  106414:	89 ec                	mov    %ebp,%esp
  106416:	5d                   	pop    %ebp
  106417:	c3                   	ret    

00106418 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  106418:	55                   	push   %ebp
  106419:	89 e5                	mov    %esp,%ebp
  10641b:	56                   	push   %esi
  10641c:	53                   	push   %ebx
  10641d:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  106420:	eb 17                	jmp    106439 <vprintfmt+0x21>
            if (ch == '\0') {
  106422:	85 db                	test   %ebx,%ebx
  106424:	0f 84 bf 03 00 00    	je     1067e9 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  10642a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10642d:	89 44 24 04          	mov    %eax,0x4(%esp)
  106431:	89 1c 24             	mov    %ebx,(%esp)
  106434:	8b 45 08             	mov    0x8(%ebp),%eax
  106437:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  106439:	8b 45 10             	mov    0x10(%ebp),%eax
  10643c:	8d 50 01             	lea    0x1(%eax),%edx
  10643f:	89 55 10             	mov    %edx,0x10(%ebp)
  106442:	0f b6 00             	movzbl (%eax),%eax
  106445:	0f b6 d8             	movzbl %al,%ebx
  106448:	83 fb 25             	cmp    $0x25,%ebx
  10644b:	75 d5                	jne    106422 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  10644d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  106451:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  106458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10645b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10645e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  106465:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106468:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10646b:	8b 45 10             	mov    0x10(%ebp),%eax
  10646e:	8d 50 01             	lea    0x1(%eax),%edx
  106471:	89 55 10             	mov    %edx,0x10(%ebp)
  106474:	0f b6 00             	movzbl (%eax),%eax
  106477:	0f b6 d8             	movzbl %al,%ebx
  10647a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10647d:	83 f8 55             	cmp    $0x55,%eax
  106480:	0f 87 37 03 00 00    	ja     1067bd <vprintfmt+0x3a5>
  106486:	8b 04 85 d4 81 10 00 	mov    0x1081d4(,%eax,4),%eax
  10648d:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10648f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  106493:	eb d6                	jmp    10646b <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  106495:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  106499:	eb d0                	jmp    10646b <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10649b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1064a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1064a5:	89 d0                	mov    %edx,%eax
  1064a7:	c1 e0 02             	shl    $0x2,%eax
  1064aa:	01 d0                	add    %edx,%eax
  1064ac:	01 c0                	add    %eax,%eax
  1064ae:	01 d8                	add    %ebx,%eax
  1064b0:	83 e8 30             	sub    $0x30,%eax
  1064b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1064b6:	8b 45 10             	mov    0x10(%ebp),%eax
  1064b9:	0f b6 00             	movzbl (%eax),%eax
  1064bc:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1064bf:	83 fb 2f             	cmp    $0x2f,%ebx
  1064c2:	7e 38                	jle    1064fc <vprintfmt+0xe4>
  1064c4:	83 fb 39             	cmp    $0x39,%ebx
  1064c7:	7f 33                	jg     1064fc <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  1064c9:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1064cc:	eb d4                	jmp    1064a2 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1064ce:	8b 45 14             	mov    0x14(%ebp),%eax
  1064d1:	8d 50 04             	lea    0x4(%eax),%edx
  1064d4:	89 55 14             	mov    %edx,0x14(%ebp)
  1064d7:	8b 00                	mov    (%eax),%eax
  1064d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1064dc:	eb 1f                	jmp    1064fd <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  1064de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1064e2:	79 87                	jns    10646b <vprintfmt+0x53>
                width = 0;
  1064e4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1064eb:	e9 7b ff ff ff       	jmp    10646b <vprintfmt+0x53>

        case '#':
            altflag = 1;
  1064f0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1064f7:	e9 6f ff ff ff       	jmp    10646b <vprintfmt+0x53>
            goto process_precision;
  1064fc:	90                   	nop

        process_precision:
            if (width < 0)
  1064fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106501:	0f 89 64 ff ff ff    	jns    10646b <vprintfmt+0x53>
                width = precision, precision = -1;
  106507:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10650a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10650d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  106514:	e9 52 ff ff ff       	jmp    10646b <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  106519:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  10651c:	e9 4a ff ff ff       	jmp    10646b <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  106521:	8b 45 14             	mov    0x14(%ebp),%eax
  106524:	8d 50 04             	lea    0x4(%eax),%edx
  106527:	89 55 14             	mov    %edx,0x14(%ebp)
  10652a:	8b 00                	mov    (%eax),%eax
  10652c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10652f:	89 54 24 04          	mov    %edx,0x4(%esp)
  106533:	89 04 24             	mov    %eax,(%esp)
  106536:	8b 45 08             	mov    0x8(%ebp),%eax
  106539:	ff d0                	call   *%eax
            break;
  10653b:	e9 a4 02 00 00       	jmp    1067e4 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  106540:	8b 45 14             	mov    0x14(%ebp),%eax
  106543:	8d 50 04             	lea    0x4(%eax),%edx
  106546:	89 55 14             	mov    %edx,0x14(%ebp)
  106549:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10654b:	85 db                	test   %ebx,%ebx
  10654d:	79 02                	jns    106551 <vprintfmt+0x139>
                err = -err;
  10654f:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  106551:	83 fb 06             	cmp    $0x6,%ebx
  106554:	7f 0b                	jg     106561 <vprintfmt+0x149>
  106556:	8b 34 9d 94 81 10 00 	mov    0x108194(,%ebx,4),%esi
  10655d:	85 f6                	test   %esi,%esi
  10655f:	75 23                	jne    106584 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  106561:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  106565:	c7 44 24 08 c1 81 10 	movl   $0x1081c1,0x8(%esp)
  10656c:	00 
  10656d:	8b 45 0c             	mov    0xc(%ebp),%eax
  106570:	89 44 24 04          	mov    %eax,0x4(%esp)
  106574:	8b 45 08             	mov    0x8(%ebp),%eax
  106577:	89 04 24             	mov    %eax,(%esp)
  10657a:	e8 68 fe ff ff       	call   1063e7 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10657f:	e9 60 02 00 00       	jmp    1067e4 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  106584:	89 74 24 0c          	mov    %esi,0xc(%esp)
  106588:	c7 44 24 08 ca 81 10 	movl   $0x1081ca,0x8(%esp)
  10658f:	00 
  106590:	8b 45 0c             	mov    0xc(%ebp),%eax
  106593:	89 44 24 04          	mov    %eax,0x4(%esp)
  106597:	8b 45 08             	mov    0x8(%ebp),%eax
  10659a:	89 04 24             	mov    %eax,(%esp)
  10659d:	e8 45 fe ff ff       	call   1063e7 <printfmt>
            break;
  1065a2:	e9 3d 02 00 00       	jmp    1067e4 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1065a7:	8b 45 14             	mov    0x14(%ebp),%eax
  1065aa:	8d 50 04             	lea    0x4(%eax),%edx
  1065ad:	89 55 14             	mov    %edx,0x14(%ebp)
  1065b0:	8b 30                	mov    (%eax),%esi
  1065b2:	85 f6                	test   %esi,%esi
  1065b4:	75 05                	jne    1065bb <vprintfmt+0x1a3>
                p = "(null)";
  1065b6:	be cd 81 10 00       	mov    $0x1081cd,%esi
            }
            if (width > 0 && padc != '-') {
  1065bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1065bf:	7e 76                	jle    106637 <vprintfmt+0x21f>
  1065c1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1065c5:	74 70                	je     106637 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1065c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1065ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1065ce:	89 34 24             	mov    %esi,(%esp)
  1065d1:	e8 16 03 00 00       	call   1068ec <strnlen>
  1065d6:	89 c2                	mov    %eax,%edx
  1065d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1065db:	29 d0                	sub    %edx,%eax
  1065dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1065e0:	eb 16                	jmp    1065f8 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  1065e2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1065e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1065e9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1065ed:	89 04 24             	mov    %eax,(%esp)
  1065f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1065f3:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  1065f5:	ff 4d e8             	decl   -0x18(%ebp)
  1065f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1065fc:	7f e4                	jg     1065e2 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1065fe:	eb 37                	jmp    106637 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  106600:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  106604:	74 1f                	je     106625 <vprintfmt+0x20d>
  106606:	83 fb 1f             	cmp    $0x1f,%ebx
  106609:	7e 05                	jle    106610 <vprintfmt+0x1f8>
  10660b:	83 fb 7e             	cmp    $0x7e,%ebx
  10660e:	7e 15                	jle    106625 <vprintfmt+0x20d>
                    putch('?', putdat);
  106610:	8b 45 0c             	mov    0xc(%ebp),%eax
  106613:	89 44 24 04          	mov    %eax,0x4(%esp)
  106617:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10661e:	8b 45 08             	mov    0x8(%ebp),%eax
  106621:	ff d0                	call   *%eax
  106623:	eb 0f                	jmp    106634 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  106625:	8b 45 0c             	mov    0xc(%ebp),%eax
  106628:	89 44 24 04          	mov    %eax,0x4(%esp)
  10662c:	89 1c 24             	mov    %ebx,(%esp)
  10662f:	8b 45 08             	mov    0x8(%ebp),%eax
  106632:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  106634:	ff 4d e8             	decl   -0x18(%ebp)
  106637:	89 f0                	mov    %esi,%eax
  106639:	8d 70 01             	lea    0x1(%eax),%esi
  10663c:	0f b6 00             	movzbl (%eax),%eax
  10663f:	0f be d8             	movsbl %al,%ebx
  106642:	85 db                	test   %ebx,%ebx
  106644:	74 27                	je     10666d <vprintfmt+0x255>
  106646:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10664a:	78 b4                	js     106600 <vprintfmt+0x1e8>
  10664c:	ff 4d e4             	decl   -0x1c(%ebp)
  10664f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106653:	79 ab                	jns    106600 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  106655:	eb 16                	jmp    10666d <vprintfmt+0x255>
                putch(' ', putdat);
  106657:	8b 45 0c             	mov    0xc(%ebp),%eax
  10665a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10665e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  106665:	8b 45 08             	mov    0x8(%ebp),%eax
  106668:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  10666a:	ff 4d e8             	decl   -0x18(%ebp)
  10666d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106671:	7f e4                	jg     106657 <vprintfmt+0x23f>
            }
            break;
  106673:	e9 6c 01 00 00       	jmp    1067e4 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  106678:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10667b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10667f:	8d 45 14             	lea    0x14(%ebp),%eax
  106682:	89 04 24             	mov    %eax,(%esp)
  106685:	e8 16 fd ff ff       	call   1063a0 <getint>
  10668a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10668d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  106690:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106693:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106696:	85 d2                	test   %edx,%edx
  106698:	79 26                	jns    1066c0 <vprintfmt+0x2a8>
                putch('-', putdat);
  10669a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10669d:	89 44 24 04          	mov    %eax,0x4(%esp)
  1066a1:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1066a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1066ab:	ff d0                	call   *%eax
                num = -(long long)num;
  1066ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1066b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1066b3:	f7 d8                	neg    %eax
  1066b5:	83 d2 00             	adc    $0x0,%edx
  1066b8:	f7 da                	neg    %edx
  1066ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1066bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1066c0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1066c7:	e9 a8 00 00 00       	jmp    106774 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1066cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1066cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1066d3:	8d 45 14             	lea    0x14(%ebp),%eax
  1066d6:	89 04 24             	mov    %eax,(%esp)
  1066d9:	e8 73 fc ff ff       	call   106351 <getuint>
  1066de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1066e1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1066e4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1066eb:	e9 84 00 00 00       	jmp    106774 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1066f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1066f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1066f7:	8d 45 14             	lea    0x14(%ebp),%eax
  1066fa:	89 04 24             	mov    %eax,(%esp)
  1066fd:	e8 4f fc ff ff       	call   106351 <getuint>
  106702:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106705:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  106708:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10670f:	eb 63                	jmp    106774 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  106711:	8b 45 0c             	mov    0xc(%ebp),%eax
  106714:	89 44 24 04          	mov    %eax,0x4(%esp)
  106718:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  10671f:	8b 45 08             	mov    0x8(%ebp),%eax
  106722:	ff d0                	call   *%eax
            putch('x', putdat);
  106724:	8b 45 0c             	mov    0xc(%ebp),%eax
  106727:	89 44 24 04          	mov    %eax,0x4(%esp)
  10672b:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  106732:	8b 45 08             	mov    0x8(%ebp),%eax
  106735:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  106737:	8b 45 14             	mov    0x14(%ebp),%eax
  10673a:	8d 50 04             	lea    0x4(%eax),%edx
  10673d:	89 55 14             	mov    %edx,0x14(%ebp)
  106740:	8b 00                	mov    (%eax),%eax
  106742:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106745:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10674c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  106753:	eb 1f                	jmp    106774 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  106755:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106758:	89 44 24 04          	mov    %eax,0x4(%esp)
  10675c:	8d 45 14             	lea    0x14(%ebp),%eax
  10675f:	89 04 24             	mov    %eax,(%esp)
  106762:	e8 ea fb ff ff       	call   106351 <getuint>
  106767:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10676a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10676d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  106774:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  106778:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10677b:	89 54 24 18          	mov    %edx,0x18(%esp)
  10677f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  106782:	89 54 24 14          	mov    %edx,0x14(%esp)
  106786:	89 44 24 10          	mov    %eax,0x10(%esp)
  10678a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10678d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106790:	89 44 24 08          	mov    %eax,0x8(%esp)
  106794:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106798:	8b 45 0c             	mov    0xc(%ebp),%eax
  10679b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10679f:	8b 45 08             	mov    0x8(%ebp),%eax
  1067a2:	89 04 24             	mov    %eax,(%esp)
  1067a5:	e8 a5 fa ff ff       	call   10624f <printnum>
            break;
  1067aa:	eb 38                	jmp    1067e4 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1067ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1067af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1067b3:	89 1c 24             	mov    %ebx,(%esp)
  1067b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1067b9:	ff d0                	call   *%eax
            break;
  1067bb:	eb 27                	jmp    1067e4 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1067bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1067c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1067c4:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1067cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1067ce:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1067d0:	ff 4d 10             	decl   0x10(%ebp)
  1067d3:	eb 03                	jmp    1067d8 <vprintfmt+0x3c0>
  1067d5:	ff 4d 10             	decl   0x10(%ebp)
  1067d8:	8b 45 10             	mov    0x10(%ebp),%eax
  1067db:	48                   	dec    %eax
  1067dc:	0f b6 00             	movzbl (%eax),%eax
  1067df:	3c 25                	cmp    $0x25,%al
  1067e1:	75 f2                	jne    1067d5 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  1067e3:	90                   	nop
    while (1) {
  1067e4:	e9 37 fc ff ff       	jmp    106420 <vprintfmt+0x8>
                return;
  1067e9:	90                   	nop
        }
    }
}
  1067ea:	83 c4 40             	add    $0x40,%esp
  1067ed:	5b                   	pop    %ebx
  1067ee:	5e                   	pop    %esi
  1067ef:	5d                   	pop    %ebp
  1067f0:	c3                   	ret    

001067f1 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1067f1:	55                   	push   %ebp
  1067f2:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1067f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1067f7:	8b 40 08             	mov    0x8(%eax),%eax
  1067fa:	8d 50 01             	lea    0x1(%eax),%edx
  1067fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  106800:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  106803:	8b 45 0c             	mov    0xc(%ebp),%eax
  106806:	8b 10                	mov    (%eax),%edx
  106808:	8b 45 0c             	mov    0xc(%ebp),%eax
  10680b:	8b 40 04             	mov    0x4(%eax),%eax
  10680e:	39 c2                	cmp    %eax,%edx
  106810:	73 12                	jae    106824 <sprintputch+0x33>
        *b->buf ++ = ch;
  106812:	8b 45 0c             	mov    0xc(%ebp),%eax
  106815:	8b 00                	mov    (%eax),%eax
  106817:	8d 48 01             	lea    0x1(%eax),%ecx
  10681a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10681d:	89 0a                	mov    %ecx,(%edx)
  10681f:	8b 55 08             	mov    0x8(%ebp),%edx
  106822:	88 10                	mov    %dl,(%eax)
    }
}
  106824:	90                   	nop
  106825:	5d                   	pop    %ebp
  106826:	c3                   	ret    

00106827 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  106827:	55                   	push   %ebp
  106828:	89 e5                	mov    %esp,%ebp
  10682a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10682d:	8d 45 14             	lea    0x14(%ebp),%eax
  106830:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  106833:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106836:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10683a:	8b 45 10             	mov    0x10(%ebp),%eax
  10683d:	89 44 24 08          	mov    %eax,0x8(%esp)
  106841:	8b 45 0c             	mov    0xc(%ebp),%eax
  106844:	89 44 24 04          	mov    %eax,0x4(%esp)
  106848:	8b 45 08             	mov    0x8(%ebp),%eax
  10684b:	89 04 24             	mov    %eax,(%esp)
  10684e:	e8 0a 00 00 00       	call   10685d <vsnprintf>
  106853:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  106856:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106859:	89 ec                	mov    %ebp,%esp
  10685b:	5d                   	pop    %ebp
  10685c:	c3                   	ret    

0010685d <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10685d:	55                   	push   %ebp
  10685e:	89 e5                	mov    %esp,%ebp
  106860:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  106863:	8b 45 08             	mov    0x8(%ebp),%eax
  106866:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106869:	8b 45 0c             	mov    0xc(%ebp),%eax
  10686c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10686f:	8b 45 08             	mov    0x8(%ebp),%eax
  106872:	01 d0                	add    %edx,%eax
  106874:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106877:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  10687e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  106882:	74 0a                	je     10688e <vsnprintf+0x31>
  106884:	8b 55 ec             	mov    -0x14(%ebp),%edx
  106887:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10688a:	39 c2                	cmp    %eax,%edx
  10688c:	76 07                	jbe    106895 <vsnprintf+0x38>
        return -E_INVAL;
  10688e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  106893:	eb 2a                	jmp    1068bf <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  106895:	8b 45 14             	mov    0x14(%ebp),%eax
  106898:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10689c:	8b 45 10             	mov    0x10(%ebp),%eax
  10689f:	89 44 24 08          	mov    %eax,0x8(%esp)
  1068a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1068a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1068aa:	c7 04 24 f1 67 10 00 	movl   $0x1067f1,(%esp)
  1068b1:	e8 62 fb ff ff       	call   106418 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1068b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1068b9:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1068bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1068bf:	89 ec                	mov    %ebp,%esp
  1068c1:	5d                   	pop    %ebp
  1068c2:	c3                   	ret    

001068c3 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1068c3:	55                   	push   %ebp
  1068c4:	89 e5                	mov    %esp,%ebp
  1068c6:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1068c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1068d0:	eb 03                	jmp    1068d5 <strlen+0x12>
        cnt ++;
  1068d2:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  1068d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1068d8:	8d 50 01             	lea    0x1(%eax),%edx
  1068db:	89 55 08             	mov    %edx,0x8(%ebp)
  1068de:	0f b6 00             	movzbl (%eax),%eax
  1068e1:	84 c0                	test   %al,%al
  1068e3:	75 ed                	jne    1068d2 <strlen+0xf>
    }
    return cnt;
  1068e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1068e8:	89 ec                	mov    %ebp,%esp
  1068ea:	5d                   	pop    %ebp
  1068eb:	c3                   	ret    

001068ec <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1068ec:	55                   	push   %ebp
  1068ed:	89 e5                	mov    %esp,%ebp
  1068ef:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1068f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1068f9:	eb 03                	jmp    1068fe <strnlen+0x12>
        cnt ++;
  1068fb:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1068fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106901:	3b 45 0c             	cmp    0xc(%ebp),%eax
  106904:	73 10                	jae    106916 <strnlen+0x2a>
  106906:	8b 45 08             	mov    0x8(%ebp),%eax
  106909:	8d 50 01             	lea    0x1(%eax),%edx
  10690c:	89 55 08             	mov    %edx,0x8(%ebp)
  10690f:	0f b6 00             	movzbl (%eax),%eax
  106912:	84 c0                	test   %al,%al
  106914:	75 e5                	jne    1068fb <strnlen+0xf>
    }
    return cnt;
  106916:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  106919:	89 ec                	mov    %ebp,%esp
  10691b:	5d                   	pop    %ebp
  10691c:	c3                   	ret    

0010691d <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  10691d:	55                   	push   %ebp
  10691e:	89 e5                	mov    %esp,%ebp
  106920:	57                   	push   %edi
  106921:	56                   	push   %esi
  106922:	83 ec 20             	sub    $0x20,%esp
  106925:	8b 45 08             	mov    0x8(%ebp),%eax
  106928:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10692b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10692e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  106931:	8b 55 f0             	mov    -0x10(%ebp),%edx
  106934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106937:	89 d1                	mov    %edx,%ecx
  106939:	89 c2                	mov    %eax,%edx
  10693b:	89 ce                	mov    %ecx,%esi
  10693d:	89 d7                	mov    %edx,%edi
  10693f:	ac                   	lods   %ds:(%esi),%al
  106940:	aa                   	stos   %al,%es:(%edi)
  106941:	84 c0                	test   %al,%al
  106943:	75 fa                	jne    10693f <strcpy+0x22>
  106945:	89 fa                	mov    %edi,%edx
  106947:	89 f1                	mov    %esi,%ecx
  106949:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10694c:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10694f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  106952:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  106955:	83 c4 20             	add    $0x20,%esp
  106958:	5e                   	pop    %esi
  106959:	5f                   	pop    %edi
  10695a:	5d                   	pop    %ebp
  10695b:	c3                   	ret    

0010695c <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  10695c:	55                   	push   %ebp
  10695d:	89 e5                	mov    %esp,%ebp
  10695f:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  106962:	8b 45 08             	mov    0x8(%ebp),%eax
  106965:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  106968:	eb 1e                	jmp    106988 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  10696a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10696d:	0f b6 10             	movzbl (%eax),%edx
  106970:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106973:	88 10                	mov    %dl,(%eax)
  106975:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106978:	0f b6 00             	movzbl (%eax),%eax
  10697b:	84 c0                	test   %al,%al
  10697d:	74 03                	je     106982 <strncpy+0x26>
            src ++;
  10697f:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  106982:	ff 45 fc             	incl   -0x4(%ebp)
  106985:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  106988:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10698c:	75 dc                	jne    10696a <strncpy+0xe>
    }
    return dst;
  10698e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  106991:	89 ec                	mov    %ebp,%esp
  106993:	5d                   	pop    %ebp
  106994:	c3                   	ret    

00106995 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  106995:	55                   	push   %ebp
  106996:	89 e5                	mov    %esp,%ebp
  106998:	57                   	push   %edi
  106999:	56                   	push   %esi
  10699a:	83 ec 20             	sub    $0x20,%esp
  10699d:	8b 45 08             	mov    0x8(%ebp),%eax
  1069a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1069a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1069a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  1069a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1069ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1069af:	89 d1                	mov    %edx,%ecx
  1069b1:	89 c2                	mov    %eax,%edx
  1069b3:	89 ce                	mov    %ecx,%esi
  1069b5:	89 d7                	mov    %edx,%edi
  1069b7:	ac                   	lods   %ds:(%esi),%al
  1069b8:	ae                   	scas   %es:(%edi),%al
  1069b9:	75 08                	jne    1069c3 <strcmp+0x2e>
  1069bb:	84 c0                	test   %al,%al
  1069bd:	75 f8                	jne    1069b7 <strcmp+0x22>
  1069bf:	31 c0                	xor    %eax,%eax
  1069c1:	eb 04                	jmp    1069c7 <strcmp+0x32>
  1069c3:	19 c0                	sbb    %eax,%eax
  1069c5:	0c 01                	or     $0x1,%al
  1069c7:	89 fa                	mov    %edi,%edx
  1069c9:	89 f1                	mov    %esi,%ecx
  1069cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1069ce:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1069d1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1069d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1069d7:	83 c4 20             	add    $0x20,%esp
  1069da:	5e                   	pop    %esi
  1069db:	5f                   	pop    %edi
  1069dc:	5d                   	pop    %ebp
  1069dd:	c3                   	ret    

001069de <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1069de:	55                   	push   %ebp
  1069df:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1069e1:	eb 09                	jmp    1069ec <strncmp+0xe>
        n --, s1 ++, s2 ++;
  1069e3:	ff 4d 10             	decl   0x10(%ebp)
  1069e6:	ff 45 08             	incl   0x8(%ebp)
  1069e9:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1069ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1069f0:	74 1a                	je     106a0c <strncmp+0x2e>
  1069f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1069f5:	0f b6 00             	movzbl (%eax),%eax
  1069f8:	84 c0                	test   %al,%al
  1069fa:	74 10                	je     106a0c <strncmp+0x2e>
  1069fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1069ff:	0f b6 10             	movzbl (%eax),%edx
  106a02:	8b 45 0c             	mov    0xc(%ebp),%eax
  106a05:	0f b6 00             	movzbl (%eax),%eax
  106a08:	38 c2                	cmp    %al,%dl
  106a0a:	74 d7                	je     1069e3 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  106a0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106a10:	74 18                	je     106a2a <strncmp+0x4c>
  106a12:	8b 45 08             	mov    0x8(%ebp),%eax
  106a15:	0f b6 00             	movzbl (%eax),%eax
  106a18:	0f b6 d0             	movzbl %al,%edx
  106a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  106a1e:	0f b6 00             	movzbl (%eax),%eax
  106a21:	0f b6 c8             	movzbl %al,%ecx
  106a24:	89 d0                	mov    %edx,%eax
  106a26:	29 c8                	sub    %ecx,%eax
  106a28:	eb 05                	jmp    106a2f <strncmp+0x51>
  106a2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106a2f:	5d                   	pop    %ebp
  106a30:	c3                   	ret    

00106a31 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  106a31:	55                   	push   %ebp
  106a32:	89 e5                	mov    %esp,%ebp
  106a34:	83 ec 04             	sub    $0x4,%esp
  106a37:	8b 45 0c             	mov    0xc(%ebp),%eax
  106a3a:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  106a3d:	eb 13                	jmp    106a52 <strchr+0x21>
        if (*s == c) {
  106a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  106a42:	0f b6 00             	movzbl (%eax),%eax
  106a45:	38 45 fc             	cmp    %al,-0x4(%ebp)
  106a48:	75 05                	jne    106a4f <strchr+0x1e>
            return (char *)s;
  106a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  106a4d:	eb 12                	jmp    106a61 <strchr+0x30>
        }
        s ++;
  106a4f:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  106a52:	8b 45 08             	mov    0x8(%ebp),%eax
  106a55:	0f b6 00             	movzbl (%eax),%eax
  106a58:	84 c0                	test   %al,%al
  106a5a:	75 e3                	jne    106a3f <strchr+0xe>
    }
    return NULL;
  106a5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106a61:	89 ec                	mov    %ebp,%esp
  106a63:	5d                   	pop    %ebp
  106a64:	c3                   	ret    

00106a65 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  106a65:	55                   	push   %ebp
  106a66:	89 e5                	mov    %esp,%ebp
  106a68:	83 ec 04             	sub    $0x4,%esp
  106a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  106a6e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  106a71:	eb 0e                	jmp    106a81 <strfind+0x1c>
        if (*s == c) {
  106a73:	8b 45 08             	mov    0x8(%ebp),%eax
  106a76:	0f b6 00             	movzbl (%eax),%eax
  106a79:	38 45 fc             	cmp    %al,-0x4(%ebp)
  106a7c:	74 0f                	je     106a8d <strfind+0x28>
            break;
        }
        s ++;
  106a7e:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  106a81:	8b 45 08             	mov    0x8(%ebp),%eax
  106a84:	0f b6 00             	movzbl (%eax),%eax
  106a87:	84 c0                	test   %al,%al
  106a89:	75 e8                	jne    106a73 <strfind+0xe>
  106a8b:	eb 01                	jmp    106a8e <strfind+0x29>
            break;
  106a8d:	90                   	nop
    }
    return (char *)s;
  106a8e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  106a91:	89 ec                	mov    %ebp,%esp
  106a93:	5d                   	pop    %ebp
  106a94:	c3                   	ret    

00106a95 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  106a95:	55                   	push   %ebp
  106a96:	89 e5                	mov    %esp,%ebp
  106a98:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  106a9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  106aa2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  106aa9:	eb 03                	jmp    106aae <strtol+0x19>
        s ++;
  106aab:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  106aae:	8b 45 08             	mov    0x8(%ebp),%eax
  106ab1:	0f b6 00             	movzbl (%eax),%eax
  106ab4:	3c 20                	cmp    $0x20,%al
  106ab6:	74 f3                	je     106aab <strtol+0x16>
  106ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  106abb:	0f b6 00             	movzbl (%eax),%eax
  106abe:	3c 09                	cmp    $0x9,%al
  106ac0:	74 e9                	je     106aab <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  106ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  106ac5:	0f b6 00             	movzbl (%eax),%eax
  106ac8:	3c 2b                	cmp    $0x2b,%al
  106aca:	75 05                	jne    106ad1 <strtol+0x3c>
        s ++;
  106acc:	ff 45 08             	incl   0x8(%ebp)
  106acf:	eb 14                	jmp    106ae5 <strtol+0x50>
    }
    else if (*s == '-') {
  106ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  106ad4:	0f b6 00             	movzbl (%eax),%eax
  106ad7:	3c 2d                	cmp    $0x2d,%al
  106ad9:	75 0a                	jne    106ae5 <strtol+0x50>
        s ++, neg = 1;
  106adb:	ff 45 08             	incl   0x8(%ebp)
  106ade:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  106ae5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106ae9:	74 06                	je     106af1 <strtol+0x5c>
  106aeb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  106aef:	75 22                	jne    106b13 <strtol+0x7e>
  106af1:	8b 45 08             	mov    0x8(%ebp),%eax
  106af4:	0f b6 00             	movzbl (%eax),%eax
  106af7:	3c 30                	cmp    $0x30,%al
  106af9:	75 18                	jne    106b13 <strtol+0x7e>
  106afb:	8b 45 08             	mov    0x8(%ebp),%eax
  106afe:	40                   	inc    %eax
  106aff:	0f b6 00             	movzbl (%eax),%eax
  106b02:	3c 78                	cmp    $0x78,%al
  106b04:	75 0d                	jne    106b13 <strtol+0x7e>
        s += 2, base = 16;
  106b06:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  106b0a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  106b11:	eb 29                	jmp    106b3c <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  106b13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106b17:	75 16                	jne    106b2f <strtol+0x9a>
  106b19:	8b 45 08             	mov    0x8(%ebp),%eax
  106b1c:	0f b6 00             	movzbl (%eax),%eax
  106b1f:	3c 30                	cmp    $0x30,%al
  106b21:	75 0c                	jne    106b2f <strtol+0x9a>
        s ++, base = 8;
  106b23:	ff 45 08             	incl   0x8(%ebp)
  106b26:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  106b2d:	eb 0d                	jmp    106b3c <strtol+0xa7>
    }
    else if (base == 0) {
  106b2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106b33:	75 07                	jne    106b3c <strtol+0xa7>
        base = 10;
  106b35:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  106b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  106b3f:	0f b6 00             	movzbl (%eax),%eax
  106b42:	3c 2f                	cmp    $0x2f,%al
  106b44:	7e 1b                	jle    106b61 <strtol+0xcc>
  106b46:	8b 45 08             	mov    0x8(%ebp),%eax
  106b49:	0f b6 00             	movzbl (%eax),%eax
  106b4c:	3c 39                	cmp    $0x39,%al
  106b4e:	7f 11                	jg     106b61 <strtol+0xcc>
            dig = *s - '0';
  106b50:	8b 45 08             	mov    0x8(%ebp),%eax
  106b53:	0f b6 00             	movzbl (%eax),%eax
  106b56:	0f be c0             	movsbl %al,%eax
  106b59:	83 e8 30             	sub    $0x30,%eax
  106b5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106b5f:	eb 48                	jmp    106ba9 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  106b61:	8b 45 08             	mov    0x8(%ebp),%eax
  106b64:	0f b6 00             	movzbl (%eax),%eax
  106b67:	3c 60                	cmp    $0x60,%al
  106b69:	7e 1b                	jle    106b86 <strtol+0xf1>
  106b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  106b6e:	0f b6 00             	movzbl (%eax),%eax
  106b71:	3c 7a                	cmp    $0x7a,%al
  106b73:	7f 11                	jg     106b86 <strtol+0xf1>
            dig = *s - 'a' + 10;
  106b75:	8b 45 08             	mov    0x8(%ebp),%eax
  106b78:	0f b6 00             	movzbl (%eax),%eax
  106b7b:	0f be c0             	movsbl %al,%eax
  106b7e:	83 e8 57             	sub    $0x57,%eax
  106b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106b84:	eb 23                	jmp    106ba9 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  106b86:	8b 45 08             	mov    0x8(%ebp),%eax
  106b89:	0f b6 00             	movzbl (%eax),%eax
  106b8c:	3c 40                	cmp    $0x40,%al
  106b8e:	7e 3b                	jle    106bcb <strtol+0x136>
  106b90:	8b 45 08             	mov    0x8(%ebp),%eax
  106b93:	0f b6 00             	movzbl (%eax),%eax
  106b96:	3c 5a                	cmp    $0x5a,%al
  106b98:	7f 31                	jg     106bcb <strtol+0x136>
            dig = *s - 'A' + 10;
  106b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  106b9d:	0f b6 00             	movzbl (%eax),%eax
  106ba0:	0f be c0             	movsbl %al,%eax
  106ba3:	83 e8 37             	sub    $0x37,%eax
  106ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  106ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106bac:	3b 45 10             	cmp    0x10(%ebp),%eax
  106baf:	7d 19                	jge    106bca <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  106bb1:	ff 45 08             	incl   0x8(%ebp)
  106bb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106bb7:	0f af 45 10          	imul   0x10(%ebp),%eax
  106bbb:	89 c2                	mov    %eax,%edx
  106bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106bc0:	01 d0                	add    %edx,%eax
  106bc2:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  106bc5:	e9 72 ff ff ff       	jmp    106b3c <strtol+0xa7>
            break;
  106bca:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  106bcb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106bcf:	74 08                	je     106bd9 <strtol+0x144>
        *endptr = (char *) s;
  106bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  106bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  106bd7:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  106bd9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  106bdd:	74 07                	je     106be6 <strtol+0x151>
  106bdf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106be2:	f7 d8                	neg    %eax
  106be4:	eb 03                	jmp    106be9 <strtol+0x154>
  106be6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  106be9:	89 ec                	mov    %ebp,%esp
  106beb:	5d                   	pop    %ebp
  106bec:	c3                   	ret    

00106bed <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  106bed:	55                   	push   %ebp
  106bee:	89 e5                	mov    %esp,%ebp
  106bf0:	83 ec 28             	sub    $0x28,%esp
  106bf3:	89 7d fc             	mov    %edi,-0x4(%ebp)
  106bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  106bf9:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  106bfc:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  106c00:	8b 45 08             	mov    0x8(%ebp),%eax
  106c03:	89 45 f8             	mov    %eax,-0x8(%ebp)
  106c06:	88 55 f7             	mov    %dl,-0x9(%ebp)
  106c09:	8b 45 10             	mov    0x10(%ebp),%eax
  106c0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  106c0f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  106c12:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  106c16:	8b 55 f8             	mov    -0x8(%ebp),%edx
  106c19:	89 d7                	mov    %edx,%edi
  106c1b:	f3 aa                	rep stos %al,%es:(%edi)
  106c1d:	89 fa                	mov    %edi,%edx
  106c1f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  106c22:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  106c25:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  106c28:	8b 7d fc             	mov    -0x4(%ebp),%edi
  106c2b:	89 ec                	mov    %ebp,%esp
  106c2d:	5d                   	pop    %ebp
  106c2e:	c3                   	ret    

00106c2f <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  106c2f:	55                   	push   %ebp
  106c30:	89 e5                	mov    %esp,%ebp
  106c32:	57                   	push   %edi
  106c33:	56                   	push   %esi
  106c34:	53                   	push   %ebx
  106c35:	83 ec 30             	sub    $0x30,%esp
  106c38:	8b 45 08             	mov    0x8(%ebp),%eax
  106c3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  106c41:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106c44:	8b 45 10             	mov    0x10(%ebp),%eax
  106c47:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  106c4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106c4d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  106c50:	73 42                	jae    106c94 <memmove+0x65>
  106c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106c55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106c5b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106c5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106c61:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  106c64:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106c67:	c1 e8 02             	shr    $0x2,%eax
  106c6a:	89 c1                	mov    %eax,%ecx
    asm volatile (
  106c6c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106c6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106c72:	89 d7                	mov    %edx,%edi
  106c74:	89 c6                	mov    %eax,%esi
  106c76:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106c78:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  106c7b:	83 e1 03             	and    $0x3,%ecx
  106c7e:	74 02                	je     106c82 <memmove+0x53>
  106c80:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106c82:	89 f0                	mov    %esi,%eax
  106c84:	89 fa                	mov    %edi,%edx
  106c86:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  106c89:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  106c8c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  106c8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  106c92:	eb 36                	jmp    106cca <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  106c94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106c97:	8d 50 ff             	lea    -0x1(%eax),%edx
  106c9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106c9d:	01 c2                	add    %eax,%edx
  106c9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106ca2:	8d 48 ff             	lea    -0x1(%eax),%ecx
  106ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106ca8:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  106cab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106cae:	89 c1                	mov    %eax,%ecx
  106cb0:	89 d8                	mov    %ebx,%eax
  106cb2:	89 d6                	mov    %edx,%esi
  106cb4:	89 c7                	mov    %eax,%edi
  106cb6:	fd                   	std    
  106cb7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106cb9:	fc                   	cld    
  106cba:	89 f8                	mov    %edi,%eax
  106cbc:	89 f2                	mov    %esi,%edx
  106cbe:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  106cc1:	89 55 c8             	mov    %edx,-0x38(%ebp)
  106cc4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  106cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  106cca:	83 c4 30             	add    $0x30,%esp
  106ccd:	5b                   	pop    %ebx
  106cce:	5e                   	pop    %esi
  106ccf:	5f                   	pop    %edi
  106cd0:	5d                   	pop    %ebp
  106cd1:	c3                   	ret    

00106cd2 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  106cd2:	55                   	push   %ebp
  106cd3:	89 e5                	mov    %esp,%ebp
  106cd5:	57                   	push   %edi
  106cd6:	56                   	push   %esi
  106cd7:	83 ec 20             	sub    $0x20,%esp
  106cda:	8b 45 08             	mov    0x8(%ebp),%eax
  106cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  106ce3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106ce6:	8b 45 10             	mov    0x10(%ebp),%eax
  106ce9:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  106cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106cef:	c1 e8 02             	shr    $0x2,%eax
  106cf2:	89 c1                	mov    %eax,%ecx
    asm volatile (
  106cf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106cfa:	89 d7                	mov    %edx,%edi
  106cfc:	89 c6                	mov    %eax,%esi
  106cfe:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106d00:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  106d03:	83 e1 03             	and    $0x3,%ecx
  106d06:	74 02                	je     106d0a <memcpy+0x38>
  106d08:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106d0a:	89 f0                	mov    %esi,%eax
  106d0c:	89 fa                	mov    %edi,%edx
  106d0e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  106d11:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  106d14:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  106d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  106d1a:	83 c4 20             	add    $0x20,%esp
  106d1d:	5e                   	pop    %esi
  106d1e:	5f                   	pop    %edi
  106d1f:	5d                   	pop    %ebp
  106d20:	c3                   	ret    

00106d21 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  106d21:	55                   	push   %ebp
  106d22:	89 e5                	mov    %esp,%ebp
  106d24:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  106d27:	8b 45 08             	mov    0x8(%ebp),%eax
  106d2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  106d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  106d30:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  106d33:	eb 2e                	jmp    106d63 <memcmp+0x42>
        if (*s1 != *s2) {
  106d35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106d38:	0f b6 10             	movzbl (%eax),%edx
  106d3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106d3e:	0f b6 00             	movzbl (%eax),%eax
  106d41:	38 c2                	cmp    %al,%dl
  106d43:	74 18                	je     106d5d <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  106d45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106d48:	0f b6 00             	movzbl (%eax),%eax
  106d4b:	0f b6 d0             	movzbl %al,%edx
  106d4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106d51:	0f b6 00             	movzbl (%eax),%eax
  106d54:	0f b6 c8             	movzbl %al,%ecx
  106d57:	89 d0                	mov    %edx,%eax
  106d59:	29 c8                	sub    %ecx,%eax
  106d5b:	eb 18                	jmp    106d75 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  106d5d:	ff 45 fc             	incl   -0x4(%ebp)
  106d60:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  106d63:	8b 45 10             	mov    0x10(%ebp),%eax
  106d66:	8d 50 ff             	lea    -0x1(%eax),%edx
  106d69:	89 55 10             	mov    %edx,0x10(%ebp)
  106d6c:	85 c0                	test   %eax,%eax
  106d6e:	75 c5                	jne    106d35 <memcmp+0x14>
    }
    return 0;
  106d70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106d75:	89 ec                	mov    %ebp,%esp
  106d77:	5d                   	pop    %ebp
  106d78:	c3                   	ret    
