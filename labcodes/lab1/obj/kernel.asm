
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	b8 08 fd 10 00       	mov    $0x10fd08,%eax
  10000b:	2d 16 ea 10 00       	sub    $0x10ea16,%eax
  100010:	89 44 24 08          	mov    %eax,0x8(%esp)
  100014:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001b:	00 
  10001c:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100023:	e8 e3 30 00 00       	call   10310b <memset>

    cons_init();                // init the console
  100028:	e8 f0 14 00 00       	call   10151d <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002d:	c7 45 f4 a0 32 10 00 	movl   $0x1032a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100037:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003b:	c7 04 24 bc 32 10 00 	movl   $0x1032bc,(%esp)
  100042:	e8 d9 02 00 00       	call   100320 <cprintf>

    print_kerninfo();
  100047:	e8 f7 07 00 00       	call   100843 <print_kerninfo>

    grade_backtrace();
  10004c:	e8 90 00 00 00       	call   1000e1 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100051:	e8 0c 27 00 00       	call   102762 <pmm_init>

    pic_init();                 // init interrupt controller
  100056:	e8 1d 16 00 00       	call   101678 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005b:	e8 81 17 00 00       	call   1017e1 <idt_init>

    clock_init();               // init clock interrupt
  100060:	e8 59 0c 00 00       	call   100cbe <clock_init>
    intr_enable();              // enable irq interrupt
  100065:	e8 6c 15 00 00       	call   1015d6 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006a:	eb fe                	jmp    10006a <kern_init+0x6a>

0010006c <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10006c:	55                   	push   %ebp
  10006d:	89 e5                	mov    %esp,%ebp
  10006f:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100072:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100079:	00 
  10007a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100081:	00 
  100082:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100089:	e8 4b 0b 00 00       	call   100bd9 <mon_backtrace>
}
  10008e:	90                   	nop
  10008f:	89 ec                	mov    %ebp,%esp
  100091:	5d                   	pop    %ebp
  100092:	c3                   	ret    

00100093 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100093:	55                   	push   %ebp
  100094:	89 e5                	mov    %esp,%ebp
  100096:	83 ec 18             	sub    $0x18,%esp
  100099:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009c:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  10009f:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000a2:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000ac:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000b4:	89 04 24             	mov    %eax,(%esp)
  1000b7:	e8 b0 ff ff ff       	call   10006c <grade_backtrace2>
}
  1000bc:	90                   	nop
  1000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000c0:	89 ec                	mov    %ebp,%esp
  1000c2:	5d                   	pop    %ebp
  1000c3:	c3                   	ret    

001000c4 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c4:	55                   	push   %ebp
  1000c5:	89 e5                	mov    %esp,%ebp
  1000c7:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000ca:	8b 45 10             	mov    0x10(%ebp),%eax
  1000cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d4:	89 04 24             	mov    %eax,(%esp)
  1000d7:	e8 b7 ff ff ff       	call   100093 <grade_backtrace1>
}
  1000dc:	90                   	nop
  1000dd:	89 ec                	mov    %ebp,%esp
  1000df:	5d                   	pop    %ebp
  1000e0:	c3                   	ret    

001000e1 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e1:	55                   	push   %ebp
  1000e2:	89 e5                	mov    %esp,%ebp
  1000e4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e7:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000ec:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f3:	ff 
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000ff:	e8 c0 ff ff ff       	call   1000c4 <grade_backtrace0>
}
  100104:	90                   	nop
  100105:	89 ec                	mov    %ebp,%esp
  100107:	5d                   	pop    %ebp
  100108:	c3                   	ret    

00100109 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100109:	55                   	push   %ebp
  10010a:	89 e5                	mov    %esp,%ebp
  10010c:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10010f:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100112:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100115:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100118:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10011b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011f:	83 e0 03             	and    $0x3,%eax
  100122:	89 c2                	mov    %eax,%edx
  100124:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100129:	89 54 24 08          	mov    %edx,0x8(%esp)
  10012d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100131:	c7 04 24 c1 32 10 00 	movl   $0x1032c1,(%esp)
  100138:	e8 e3 01 00 00       	call   100320 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100141:	89 c2                	mov    %eax,%edx
  100143:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100148:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100150:	c7 04 24 cf 32 10 00 	movl   $0x1032cf,(%esp)
  100157:	e8 c4 01 00 00       	call   100320 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100160:	89 c2                	mov    %eax,%edx
  100162:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100167:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016f:	c7 04 24 dd 32 10 00 	movl   $0x1032dd,(%esp)
  100176:	e8 a5 01 00 00       	call   100320 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017f:	89 c2                	mov    %eax,%edx
  100181:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100186:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018e:	c7 04 24 eb 32 10 00 	movl   $0x1032eb,(%esp)
  100195:	e8 86 01 00 00       	call   100320 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019a:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019e:	89 c2                	mov    %eax,%edx
  1001a0:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a5:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ad:	c7 04 24 f9 32 10 00 	movl   $0x1032f9,(%esp)
  1001b4:	e8 67 01 00 00       	call   100320 <cprintf>
    round ++;
  1001b9:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001be:	40                   	inc    %eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	90                   	nop
  1001c5:	89 ec                	mov    %ebp,%esp
  1001c7:	5d                   	pop    %ebp
  1001c8:	c3                   	ret    

001001c9 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c9:	55                   	push   %ebp
  1001ca:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001cc:	90                   	nop
  1001cd:	5d                   	pop    %ebp
  1001ce:	c3                   	ret    

001001cf <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cf:	55                   	push   %ebp
  1001d0:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001d2:	90                   	nop
  1001d3:	5d                   	pop    %ebp
  1001d4:	c3                   	ret    

001001d5 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d5:	55                   	push   %ebp
  1001d6:	89 e5                	mov    %esp,%ebp
  1001d8:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001db:	e8 29 ff ff ff       	call   100109 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001e0:	c7 04 24 08 33 10 00 	movl   $0x103308,(%esp)
  1001e7:	e8 34 01 00 00       	call   100320 <cprintf>
    lab1_switch_to_user();
  1001ec:	e8 d8 ff ff ff       	call   1001c9 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001f1:	e8 13 ff ff ff       	call   100109 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f6:	c7 04 24 28 33 10 00 	movl   $0x103328,(%esp)
  1001fd:	e8 1e 01 00 00       	call   100320 <cprintf>
    lab1_switch_to_kernel();
  100202:	e8 c8 ff ff ff       	call   1001cf <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100207:	e8 fd fe ff ff       	call   100109 <lab1_print_cur_status>
}
  10020c:	90                   	nop
  10020d:	89 ec                	mov    %ebp,%esp
  10020f:	5d                   	pop    %ebp
  100210:	c3                   	ret    

00100211 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100211:	55                   	push   %ebp
  100212:	89 e5                	mov    %esp,%ebp
  100214:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100217:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10021b:	74 13                	je     100230 <readline+0x1f>
        cprintf("%s", prompt);
  10021d:	8b 45 08             	mov    0x8(%ebp),%eax
  100220:	89 44 24 04          	mov    %eax,0x4(%esp)
  100224:	c7 04 24 47 33 10 00 	movl   $0x103347,(%esp)
  10022b:	e8 f0 00 00 00       	call   100320 <cprintf>
    }
    int i = 0, c;
  100230:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100237:	e8 73 01 00 00       	call   1003af <getchar>
  10023c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10023f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100243:	79 07                	jns    10024c <readline+0x3b>
            return NULL;
  100245:	b8 00 00 00 00       	mov    $0x0,%eax
  10024a:	eb 78                	jmp    1002c4 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10024c:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100250:	7e 28                	jle    10027a <readline+0x69>
  100252:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100259:	7f 1f                	jg     10027a <readline+0x69>
            cputchar(c);
  10025b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10025e:	89 04 24             	mov    %eax,(%esp)
  100261:	e8 e2 00 00 00       	call   100348 <cputchar>
            buf[i ++] = c;
  100266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100269:	8d 50 01             	lea    0x1(%eax),%edx
  10026c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10026f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100272:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100278:	eb 45                	jmp    1002bf <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  10027a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10027e:	75 16                	jne    100296 <readline+0x85>
  100280:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100284:	7e 10                	jle    100296 <readline+0x85>
            cputchar(c);
  100286:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100289:	89 04 24             	mov    %eax,(%esp)
  10028c:	e8 b7 00 00 00       	call   100348 <cputchar>
            i --;
  100291:	ff 4d f4             	decl   -0xc(%ebp)
  100294:	eb 29                	jmp    1002bf <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  100296:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  10029a:	74 06                	je     1002a2 <readline+0x91>
  10029c:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002a0:	75 95                	jne    100237 <readline+0x26>
            cputchar(c);
  1002a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a5:	89 04 24             	mov    %eax,(%esp)
  1002a8:	e8 9b 00 00 00       	call   100348 <cputchar>
            buf[i] = '\0';
  1002ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002b0:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002b5:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b8:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002bd:	eb 05                	jmp    1002c4 <readline+0xb3>
        c = getchar();
  1002bf:	e9 73 ff ff ff       	jmp    100237 <readline+0x26>
        }
    }
}
  1002c4:	89 ec                	mov    %ebp,%esp
  1002c6:	5d                   	pop    %ebp
  1002c7:	c3                   	ret    

001002c8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002c8:	55                   	push   %ebp
  1002c9:	89 e5                	mov    %esp,%ebp
  1002cb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d1:	89 04 24             	mov    %eax,(%esp)
  1002d4:	e8 73 12 00 00       	call   10154c <cons_putc>
    (*cnt) ++;
  1002d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002dc:	8b 00                	mov    (%eax),%eax
  1002de:	8d 50 01             	lea    0x1(%eax),%edx
  1002e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002e4:	89 10                	mov    %edx,(%eax)
}
  1002e6:	90                   	nop
  1002e7:	89 ec                	mov    %ebp,%esp
  1002e9:	5d                   	pop    %ebp
  1002ea:	c3                   	ret    

001002eb <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002eb:	55                   	push   %ebp
  1002ec:	89 e5                	mov    %esp,%ebp
  1002ee:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002ff:	8b 45 08             	mov    0x8(%ebp),%eax
  100302:	89 44 24 08          	mov    %eax,0x8(%esp)
  100306:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100309:	89 44 24 04          	mov    %eax,0x4(%esp)
  10030d:	c7 04 24 c8 02 10 00 	movl   $0x1002c8,(%esp)
  100314:	e8 1d 26 00 00       	call   102936 <vprintfmt>
    return cnt;
  100319:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10031c:	89 ec                	mov    %ebp,%esp
  10031e:	5d                   	pop    %ebp
  10031f:	c3                   	ret    

00100320 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100320:	55                   	push   %ebp
  100321:	89 e5                	mov    %esp,%ebp
  100323:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100326:	8d 45 0c             	lea    0xc(%ebp),%eax
  100329:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10032c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10032f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100333:	8b 45 08             	mov    0x8(%ebp),%eax
  100336:	89 04 24             	mov    %eax,(%esp)
  100339:	e8 ad ff ff ff       	call   1002eb <vcprintf>
  10033e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100341:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100344:	89 ec                	mov    %ebp,%esp
  100346:	5d                   	pop    %ebp
  100347:	c3                   	ret    

00100348 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100348:	55                   	push   %ebp
  100349:	89 e5                	mov    %esp,%ebp
  10034b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10034e:	8b 45 08             	mov    0x8(%ebp),%eax
  100351:	89 04 24             	mov    %eax,(%esp)
  100354:	e8 f3 11 00 00       	call   10154c <cons_putc>
}
  100359:	90                   	nop
  10035a:	89 ec                	mov    %ebp,%esp
  10035c:	5d                   	pop    %ebp
  10035d:	c3                   	ret    

0010035e <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10035e:	55                   	push   %ebp
  10035f:	89 e5                	mov    %esp,%ebp
  100361:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100364:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10036b:	eb 13                	jmp    100380 <cputs+0x22>
        cputch(c, &cnt);
  10036d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100371:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100374:	89 54 24 04          	mov    %edx,0x4(%esp)
  100378:	89 04 24             	mov    %eax,(%esp)
  10037b:	e8 48 ff ff ff       	call   1002c8 <cputch>
    while ((c = *str ++) != '\0') {
  100380:	8b 45 08             	mov    0x8(%ebp),%eax
  100383:	8d 50 01             	lea    0x1(%eax),%edx
  100386:	89 55 08             	mov    %edx,0x8(%ebp)
  100389:	0f b6 00             	movzbl (%eax),%eax
  10038c:	88 45 f7             	mov    %al,-0x9(%ebp)
  10038f:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100393:	75 d8                	jne    10036d <cputs+0xf>
    }
    cputch('\n', &cnt);
  100395:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100398:	89 44 24 04          	mov    %eax,0x4(%esp)
  10039c:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003a3:	e8 20 ff ff ff       	call   1002c8 <cputch>
    return cnt;
  1003a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003ab:	89 ec                	mov    %ebp,%esp
  1003ad:	5d                   	pop    %ebp
  1003ae:	c3                   	ret    

001003af <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003af:	55                   	push   %ebp
  1003b0:	89 e5                	mov    %esp,%ebp
  1003b2:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003b5:	90                   	nop
  1003b6:	e8 bd 11 00 00       	call   101578 <cons_getc>
  1003bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003c2:	74 f2                	je     1003b6 <getchar+0x7>
        /* do nothing */;
    return c;
  1003c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003c7:	89 ec                	mov    %ebp,%esp
  1003c9:	5d                   	pop    %ebp
  1003ca:	c3                   	ret    

001003cb <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003cb:	55                   	push   %ebp
  1003cc:	89 e5                	mov    %esp,%ebp
  1003ce:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003d4:	8b 00                	mov    (%eax),%eax
  1003d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003d9:	8b 45 10             	mov    0x10(%ebp),%eax
  1003dc:	8b 00                	mov    (%eax),%eax
  1003de:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003e8:	e9 ca 00 00 00       	jmp    1004b7 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1003ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003f3:	01 d0                	add    %edx,%eax
  1003f5:	89 c2                	mov    %eax,%edx
  1003f7:	c1 ea 1f             	shr    $0x1f,%edx
  1003fa:	01 d0                	add    %edx,%eax
  1003fc:	d1 f8                	sar    %eax
  1003fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100401:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100404:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100407:	eb 03                	jmp    10040c <stab_binsearch+0x41>
            m --;
  100409:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  10040c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10040f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100412:	7c 1f                	jl     100433 <stab_binsearch+0x68>
  100414:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100417:	89 d0                	mov    %edx,%eax
  100419:	01 c0                	add    %eax,%eax
  10041b:	01 d0                	add    %edx,%eax
  10041d:	c1 e0 02             	shl    $0x2,%eax
  100420:	89 c2                	mov    %eax,%edx
  100422:	8b 45 08             	mov    0x8(%ebp),%eax
  100425:	01 d0                	add    %edx,%eax
  100427:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10042b:	0f b6 c0             	movzbl %al,%eax
  10042e:	39 45 14             	cmp    %eax,0x14(%ebp)
  100431:	75 d6                	jne    100409 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100436:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100439:	7d 09                	jge    100444 <stab_binsearch+0x79>
            l = true_m + 1;
  10043b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10043e:	40                   	inc    %eax
  10043f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100442:	eb 73                	jmp    1004b7 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  100444:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10044b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10044e:	89 d0                	mov    %edx,%eax
  100450:	01 c0                	add    %eax,%eax
  100452:	01 d0                	add    %edx,%eax
  100454:	c1 e0 02             	shl    $0x2,%eax
  100457:	89 c2                	mov    %eax,%edx
  100459:	8b 45 08             	mov    0x8(%ebp),%eax
  10045c:	01 d0                	add    %edx,%eax
  10045e:	8b 40 08             	mov    0x8(%eax),%eax
  100461:	39 45 18             	cmp    %eax,0x18(%ebp)
  100464:	76 11                	jbe    100477 <stab_binsearch+0xac>
            *region_left = m;
  100466:	8b 45 0c             	mov    0xc(%ebp),%eax
  100469:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10046c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10046e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100471:	40                   	inc    %eax
  100472:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100475:	eb 40                	jmp    1004b7 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  100477:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10047a:	89 d0                	mov    %edx,%eax
  10047c:	01 c0                	add    %eax,%eax
  10047e:	01 d0                	add    %edx,%eax
  100480:	c1 e0 02             	shl    $0x2,%eax
  100483:	89 c2                	mov    %eax,%edx
  100485:	8b 45 08             	mov    0x8(%ebp),%eax
  100488:	01 d0                	add    %edx,%eax
  10048a:	8b 40 08             	mov    0x8(%eax),%eax
  10048d:	39 45 18             	cmp    %eax,0x18(%ebp)
  100490:	73 14                	jae    1004a6 <stab_binsearch+0xdb>
            *region_right = m - 1;
  100492:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100495:	8d 50 ff             	lea    -0x1(%eax),%edx
  100498:	8b 45 10             	mov    0x10(%ebp),%eax
  10049b:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a0:	48                   	dec    %eax
  1004a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a4:	eb 11                	jmp    1004b7 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004ac:	89 10                	mov    %edx,(%eax)
            l = m;
  1004ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004b4:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1004b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004bd:	0f 8e 2a ff ff ff    	jle    1003ed <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1004c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004c7:	75 0f                	jne    1004d8 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  1004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004cc:	8b 00                	mov    (%eax),%eax
  1004ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d4:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1004d6:	eb 3e                	jmp    100516 <stab_binsearch+0x14b>
        l = *region_right;
  1004d8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004db:	8b 00                	mov    (%eax),%eax
  1004dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004e0:	eb 03                	jmp    1004e5 <stab_binsearch+0x11a>
  1004e2:	ff 4d fc             	decl   -0x4(%ebp)
  1004e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e8:	8b 00                	mov    (%eax),%eax
  1004ea:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1004ed:	7e 1f                	jle    10050e <stab_binsearch+0x143>
  1004ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004f2:	89 d0                	mov    %edx,%eax
  1004f4:	01 c0                	add    %eax,%eax
  1004f6:	01 d0                	add    %edx,%eax
  1004f8:	c1 e0 02             	shl    $0x2,%eax
  1004fb:	89 c2                	mov    %eax,%edx
  1004fd:	8b 45 08             	mov    0x8(%ebp),%eax
  100500:	01 d0                	add    %edx,%eax
  100502:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100506:	0f b6 c0             	movzbl %al,%eax
  100509:	39 45 14             	cmp    %eax,0x14(%ebp)
  10050c:	75 d4                	jne    1004e2 <stab_binsearch+0x117>
        *region_left = l;
  10050e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100511:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100514:	89 10                	mov    %edx,(%eax)
}
  100516:	90                   	nop
  100517:	89 ec                	mov    %ebp,%esp
  100519:	5d                   	pop    %ebp
  10051a:	c3                   	ret    

0010051b <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10051b:	55                   	push   %ebp
  10051c:	89 e5                	mov    %esp,%ebp
  10051e:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100521:	8b 45 0c             	mov    0xc(%ebp),%eax
  100524:	c7 00 4c 33 10 00    	movl   $0x10334c,(%eax)
    info->eip_line = 0;
  10052a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100534:	8b 45 0c             	mov    0xc(%ebp),%eax
  100537:	c7 40 08 4c 33 10 00 	movl   $0x10334c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10053e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100541:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100548:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054b:	8b 55 08             	mov    0x8(%ebp),%edx
  10054e:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100551:	8b 45 0c             	mov    0xc(%ebp),%eax
  100554:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10055b:	c7 45 f4 8c 3b 10 00 	movl   $0x103b8c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100562:	c7 45 f0 14 b6 10 00 	movl   $0x10b614,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100569:	c7 45 ec 15 b6 10 00 	movl   $0x10b615,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100570:	c7 45 e8 59 df 10 00 	movl   $0x10df59,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100577:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10057a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10057d:	76 0b                	jbe    10058a <debuginfo_eip+0x6f>
  10057f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100582:	48                   	dec    %eax
  100583:	0f b6 00             	movzbl (%eax),%eax
  100586:	84 c0                	test   %al,%al
  100588:	74 0a                	je     100594 <debuginfo_eip+0x79>
        return -1;
  10058a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10058f:	e9 ab 02 00 00       	jmp    10083f <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100594:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10059b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10059e:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1005a1:	c1 f8 02             	sar    $0x2,%eax
  1005a4:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005aa:	48                   	dec    %eax
  1005ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1005b1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005b5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005bc:	00 
  1005bd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005c4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ce:	89 04 24             	mov    %eax,(%esp)
  1005d1:	e8 f5 fd ff ff       	call   1003cb <stab_binsearch>
    if (lfile == 0)
  1005d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005d9:	85 c0                	test   %eax,%eax
  1005db:	75 0a                	jne    1005e7 <debuginfo_eip+0xcc>
        return -1;
  1005dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005e2:	e9 58 02 00 00       	jmp    10083f <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1005f6:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005fa:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100601:	00 
  100602:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100605:	89 44 24 08          	mov    %eax,0x8(%esp)
  100609:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10060c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100613:	89 04 24             	mov    %eax,(%esp)
  100616:	e8 b0 fd ff ff       	call   1003cb <stab_binsearch>

    if (lfun <= rfun) {
  10061b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10061e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100621:	39 c2                	cmp    %eax,%edx
  100623:	7f 78                	jg     10069d <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100625:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100628:	89 c2                	mov    %eax,%edx
  10062a:	89 d0                	mov    %edx,%eax
  10062c:	01 c0                	add    %eax,%eax
  10062e:	01 d0                	add    %edx,%eax
  100630:	c1 e0 02             	shl    $0x2,%eax
  100633:	89 c2                	mov    %eax,%edx
  100635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100638:	01 d0                	add    %edx,%eax
  10063a:	8b 10                	mov    (%eax),%edx
  10063c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10063f:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100642:	39 c2                	cmp    %eax,%edx
  100644:	73 22                	jae    100668 <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100646:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100649:	89 c2                	mov    %eax,%edx
  10064b:	89 d0                	mov    %edx,%eax
  10064d:	01 c0                	add    %eax,%eax
  10064f:	01 d0                	add    %edx,%eax
  100651:	c1 e0 02             	shl    $0x2,%eax
  100654:	89 c2                	mov    %eax,%edx
  100656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100659:	01 d0                	add    %edx,%eax
  10065b:	8b 10                	mov    (%eax),%edx
  10065d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100660:	01 c2                	add    %eax,%edx
  100662:	8b 45 0c             	mov    0xc(%ebp),%eax
  100665:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100668:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066b:	89 c2                	mov    %eax,%edx
  10066d:	89 d0                	mov    %edx,%eax
  10066f:	01 c0                	add    %eax,%eax
  100671:	01 d0                	add    %edx,%eax
  100673:	c1 e0 02             	shl    $0x2,%eax
  100676:	89 c2                	mov    %eax,%edx
  100678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067b:	01 d0                	add    %edx,%eax
  10067d:	8b 50 08             	mov    0x8(%eax),%edx
  100680:	8b 45 0c             	mov    0xc(%ebp),%eax
  100683:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	8b 40 10             	mov    0x10(%eax),%eax
  10068c:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10068f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100692:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100695:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100698:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10069b:	eb 15                	jmp    1006b2 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10069d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a0:	8b 55 08             	mov    0x8(%ebp),%edx
  1006a3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006af:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b5:	8b 40 08             	mov    0x8(%eax),%eax
  1006b8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006bf:	00 
  1006c0:	89 04 24             	mov    %eax,(%esp)
  1006c3:	e8 bb 28 00 00       	call   102f83 <strfind>
  1006c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1006cb:	8b 4a 08             	mov    0x8(%edx),%ecx
  1006ce:	29 c8                	sub    %ecx,%eax
  1006d0:	89 c2                	mov    %eax,%edx
  1006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d5:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1006db:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006df:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e6:	00 
  1006e7:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006ee:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f8:	89 04 24             	mov    %eax,(%esp)
  1006fb:	e8 cb fc ff ff       	call   1003cb <stab_binsearch>
    if (lline <= rline) {
  100700:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100703:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100706:	39 c2                	cmp    %eax,%edx
  100708:	7f 23                	jg     10072d <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
  10070a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10070d:	89 c2                	mov    %eax,%edx
  10070f:	89 d0                	mov    %edx,%eax
  100711:	01 c0                	add    %eax,%eax
  100713:	01 d0                	add    %edx,%eax
  100715:	c1 e0 02             	shl    $0x2,%eax
  100718:	89 c2                	mov    %eax,%edx
  10071a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071d:	01 d0                	add    %edx,%eax
  10071f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100723:	89 c2                	mov    %eax,%edx
  100725:	8b 45 0c             	mov    0xc(%ebp),%eax
  100728:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10072b:	eb 11                	jmp    10073e <debuginfo_eip+0x223>
        return -1;
  10072d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100732:	e9 08 01 00 00       	jmp    10083f <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100737:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10073a:	48                   	dec    %eax
  10073b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10073e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100741:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100744:	39 c2                	cmp    %eax,%edx
  100746:	7c 56                	jl     10079e <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
  100748:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10074b:	89 c2                	mov    %eax,%edx
  10074d:	89 d0                	mov    %edx,%eax
  10074f:	01 c0                	add    %eax,%eax
  100751:	01 d0                	add    %edx,%eax
  100753:	c1 e0 02             	shl    $0x2,%eax
  100756:	89 c2                	mov    %eax,%edx
  100758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075b:	01 d0                	add    %edx,%eax
  10075d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100761:	3c 84                	cmp    $0x84,%al
  100763:	74 39                	je     10079e <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100765:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100768:	89 c2                	mov    %eax,%edx
  10076a:	89 d0                	mov    %edx,%eax
  10076c:	01 c0                	add    %eax,%eax
  10076e:	01 d0                	add    %edx,%eax
  100770:	c1 e0 02             	shl    $0x2,%eax
  100773:	89 c2                	mov    %eax,%edx
  100775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077e:	3c 64                	cmp    $0x64,%al
  100780:	75 b5                	jne    100737 <debuginfo_eip+0x21c>
  100782:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100785:	89 c2                	mov    %eax,%edx
  100787:	89 d0                	mov    %edx,%eax
  100789:	01 c0                	add    %eax,%eax
  10078b:	01 d0                	add    %edx,%eax
  10078d:	c1 e0 02             	shl    $0x2,%eax
  100790:	89 c2                	mov    %eax,%edx
  100792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	8b 40 08             	mov    0x8(%eax),%eax
  10079a:	85 c0                	test   %eax,%eax
  10079c:	74 99                	je     100737 <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10079e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a4:	39 c2                	cmp    %eax,%edx
  1007a6:	7c 42                	jl     1007ea <debuginfo_eip+0x2cf>
  1007a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ab:	89 c2                	mov    %eax,%edx
  1007ad:	89 d0                	mov    %edx,%eax
  1007af:	01 c0                	add    %eax,%eax
  1007b1:	01 d0                	add    %edx,%eax
  1007b3:	c1 e0 02             	shl    $0x2,%eax
  1007b6:	89 c2                	mov    %eax,%edx
  1007b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bb:	01 d0                	add    %edx,%eax
  1007bd:	8b 10                	mov    (%eax),%edx
  1007bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1007c2:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1007c5:	39 c2                	cmp    %eax,%edx
  1007c7:	73 21                	jae    1007ea <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007cc:	89 c2                	mov    %eax,%edx
  1007ce:	89 d0                	mov    %edx,%eax
  1007d0:	01 c0                	add    %eax,%eax
  1007d2:	01 d0                	add    %edx,%eax
  1007d4:	c1 e0 02             	shl    $0x2,%eax
  1007d7:	89 c2                	mov    %eax,%edx
  1007d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dc:	01 d0                	add    %edx,%eax
  1007de:	8b 10                	mov    (%eax),%edx
  1007e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e3:	01 c2                	add    %eax,%edx
  1007e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e8:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	7d 46                	jge    10083a <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  1007f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007f7:	40                   	inc    %eax
  1007f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007fb:	eb 16                	jmp    100813 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1007fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100800:	8b 40 14             	mov    0x14(%eax),%eax
  100803:	8d 50 01             	lea    0x1(%eax),%edx
  100806:	8b 45 0c             	mov    0xc(%ebp),%eax
  100809:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  10080c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10080f:	40                   	inc    %eax
  100810:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100813:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100816:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100819:	39 c2                	cmp    %eax,%edx
  10081b:	7d 1d                	jge    10083a <debuginfo_eip+0x31f>
  10081d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100820:	89 c2                	mov    %eax,%edx
  100822:	89 d0                	mov    %edx,%eax
  100824:	01 c0                	add    %eax,%eax
  100826:	01 d0                	add    %edx,%eax
  100828:	c1 e0 02             	shl    $0x2,%eax
  10082b:	89 c2                	mov    %eax,%edx
  10082d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100830:	01 d0                	add    %edx,%eax
  100832:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100836:	3c a0                	cmp    $0xa0,%al
  100838:	74 c3                	je     1007fd <debuginfo_eip+0x2e2>
        }
    }
    return 0;
  10083a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10083f:	89 ec                	mov    %ebp,%esp
  100841:	5d                   	pop    %ebp
  100842:	c3                   	ret    

00100843 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100843:	55                   	push   %ebp
  100844:	89 e5                	mov    %esp,%ebp
  100846:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100849:	c7 04 24 56 33 10 00 	movl   $0x103356,(%esp)
  100850:	e8 cb fa ff ff       	call   100320 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100855:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085c:	00 
  10085d:	c7 04 24 6f 33 10 00 	movl   $0x10336f,(%esp)
  100864:	e8 b7 fa ff ff       	call   100320 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100869:	c7 44 24 04 97 32 10 	movl   $0x103297,0x4(%esp)
  100870:	00 
  100871:	c7 04 24 87 33 10 00 	movl   $0x103387,(%esp)
  100878:	e8 a3 fa ff ff       	call   100320 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10087d:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100884:	00 
  100885:	c7 04 24 9f 33 10 00 	movl   $0x10339f,(%esp)
  10088c:	e8 8f fa ff ff       	call   100320 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100891:	c7 44 24 04 08 fd 10 	movl   $0x10fd08,0x4(%esp)
  100898:	00 
  100899:	c7 04 24 b7 33 10 00 	movl   $0x1033b7,(%esp)
  1008a0:	e8 7b fa ff ff       	call   100320 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008a5:	b8 08 fd 10 00       	mov    $0x10fd08,%eax
  1008aa:	2d 00 00 10 00       	sub    $0x100000,%eax
  1008af:	05 ff 03 00 00       	add    $0x3ff,%eax
  1008b4:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ba:	85 c0                	test   %eax,%eax
  1008bc:	0f 48 c2             	cmovs  %edx,%eax
  1008bf:	c1 f8 0a             	sar    $0xa,%eax
  1008c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008c6:	c7 04 24 d0 33 10 00 	movl   $0x1033d0,(%esp)
  1008cd:	e8 4e fa ff ff       	call   100320 <cprintf>
}
  1008d2:	90                   	nop
  1008d3:	89 ec                	mov    %ebp,%esp
  1008d5:	5d                   	pop    %ebp
  1008d6:	c3                   	ret    

001008d7 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008d7:	55                   	push   %ebp
  1008d8:	89 e5                	mov    %esp,%ebp
  1008da:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008e0:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ea:	89 04 24             	mov    %eax,(%esp)
  1008ed:	e8 29 fc ff ff       	call   10051b <debuginfo_eip>
  1008f2:	85 c0                	test   %eax,%eax
  1008f4:	74 15                	je     10090b <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1008f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008fd:	c7 04 24 fa 33 10 00 	movl   $0x1033fa,(%esp)
  100904:	e8 17 fa ff ff       	call   100320 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100909:	eb 6c                	jmp    100977 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10090b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100912:	eb 1b                	jmp    10092f <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  100914:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10091a:	01 d0                	add    %edx,%eax
  10091c:	0f b6 10             	movzbl (%eax),%edx
  10091f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100928:	01 c8                	add    %ecx,%eax
  10092a:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10092c:	ff 45 f4             	incl   -0xc(%ebp)
  10092f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100932:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100935:	7c dd                	jl     100914 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100937:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10093d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100940:	01 d0                	add    %edx,%eax
  100942:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100945:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100948:	8b 45 08             	mov    0x8(%ebp),%eax
  10094b:	29 d0                	sub    %edx,%eax
  10094d:	89 c1                	mov    %eax,%ecx
  10094f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100952:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100955:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100959:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10095f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100963:	89 54 24 08          	mov    %edx,0x8(%esp)
  100967:	89 44 24 04          	mov    %eax,0x4(%esp)
  10096b:	c7 04 24 16 34 10 00 	movl   $0x103416,(%esp)
  100972:	e8 a9 f9 ff ff       	call   100320 <cprintf>
}
  100977:	90                   	nop
  100978:	89 ec                	mov    %ebp,%esp
  10097a:	5d                   	pop    %ebp
  10097b:	c3                   	ret    

0010097c <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10097c:	55                   	push   %ebp
  10097d:	89 e5                	mov    %esp,%ebp
  10097f:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100982:	8b 45 04             	mov    0x4(%ebp),%eax
  100985:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100988:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10098b:	89 ec                	mov    %ebp,%esp
  10098d:	5d                   	pop    %ebp
  10098e:	c3                   	ret    

0010098f <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  10098f:	55                   	push   %ebp
  100990:	89 e5                	mov    %esp,%ebp
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
  100992:	90                   	nop
  100993:	5d                   	pop    %ebp
  100994:	c3                   	ret    

00100995 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100995:	55                   	push   %ebp
  100996:	89 e5                	mov    %esp,%ebp
  100998:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  10099b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  1009a2:	eb 0c                	jmp    1009b0 <parse+0x1b>
            *buf ++ = '\0';
  1009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1009a7:	8d 50 01             	lea    0x1(%eax),%edx
  1009aa:	89 55 08             	mov    %edx,0x8(%ebp)
  1009ad:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  1009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1009b3:	0f b6 00             	movzbl (%eax),%eax
  1009b6:	84 c0                	test   %al,%al
  1009b8:	74 1d                	je     1009d7 <parse+0x42>
  1009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1009bd:	0f b6 00             	movzbl (%eax),%eax
  1009c0:	0f be c0             	movsbl %al,%eax
  1009c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009c7:	c7 04 24 a8 34 10 00 	movl   $0x1034a8,(%esp)
  1009ce:	e8 7c 25 00 00       	call   102f4f <strchr>
  1009d3:	85 c0                	test   %eax,%eax
  1009d5:	75 cd                	jne    1009a4 <parse+0xf>
        }
        if (*buf == '\0') {
  1009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1009da:	0f b6 00             	movzbl (%eax),%eax
  1009dd:	84 c0                	test   %al,%al
  1009df:	74 65                	je     100a46 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  1009e1:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  1009e5:	75 14                	jne    1009fb <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  1009e7:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  1009ee:	00 
  1009ef:	c7 04 24 ad 34 10 00 	movl   $0x1034ad,(%esp)
  1009f6:	e8 25 f9 ff ff       	call   100320 <cprintf>
        }
        argv[argc ++] = buf;
  1009fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fe:	8d 50 01             	lea    0x1(%eax),%edx
  100a01:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100a04:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a0e:	01 c2                	add    %eax,%edx
  100a10:	8b 45 08             	mov    0x8(%ebp),%eax
  100a13:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a15:	eb 03                	jmp    100a1a <parse+0x85>
            buf ++;
  100a17:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  100a1d:	0f b6 00             	movzbl (%eax),%eax
  100a20:	84 c0                	test   %al,%al
  100a22:	74 8c                	je     1009b0 <parse+0x1b>
  100a24:	8b 45 08             	mov    0x8(%ebp),%eax
  100a27:	0f b6 00             	movzbl (%eax),%eax
  100a2a:	0f be c0             	movsbl %al,%eax
  100a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a31:	c7 04 24 a8 34 10 00 	movl   $0x1034a8,(%esp)
  100a38:	e8 12 25 00 00       	call   102f4f <strchr>
  100a3d:	85 c0                	test   %eax,%eax
  100a3f:	74 d6                	je     100a17 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a41:	e9 6a ff ff ff       	jmp    1009b0 <parse+0x1b>
            break;
  100a46:	90                   	nop
        }
    }
    return argc;
  100a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100a4a:	89 ec                	mov    %ebp,%esp
  100a4c:	5d                   	pop    %ebp
  100a4d:	c3                   	ret    

00100a4e <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100a4e:	55                   	push   %ebp
  100a4f:	89 e5                	mov    %esp,%ebp
  100a51:	83 ec 68             	sub    $0x68,%esp
  100a54:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100a57:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100a5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  100a61:	89 04 24             	mov    %eax,(%esp)
  100a64:	e8 2c ff ff ff       	call   100995 <parse>
  100a69:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100a6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100a70:	75 0a                	jne    100a7c <runcmd+0x2e>
        return 0;
  100a72:	b8 00 00 00 00       	mov    $0x0,%eax
  100a77:	e9 83 00 00 00       	jmp    100aff <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100a7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a83:	eb 5a                	jmp    100adf <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100a85:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100a88:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100a8b:	89 c8                	mov    %ecx,%eax
  100a8d:	01 c0                	add    %eax,%eax
  100a8f:	01 c8                	add    %ecx,%eax
  100a91:	c1 e0 02             	shl    $0x2,%eax
  100a94:	05 00 e0 10 00       	add    $0x10e000,%eax
  100a99:	8b 00                	mov    (%eax),%eax
  100a9b:	89 54 24 04          	mov    %edx,0x4(%esp)
  100a9f:	89 04 24             	mov    %eax,(%esp)
  100aa2:	e8 0c 24 00 00       	call   102eb3 <strcmp>
  100aa7:	85 c0                	test   %eax,%eax
  100aa9:	75 31                	jne    100adc <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
  100aab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100aae:	89 d0                	mov    %edx,%eax
  100ab0:	01 c0                	add    %eax,%eax
  100ab2:	01 d0                	add    %edx,%eax
  100ab4:	c1 e0 02             	shl    $0x2,%eax
  100ab7:	05 08 e0 10 00       	add    $0x10e008,%eax
  100abc:	8b 10                	mov    (%eax),%edx
  100abe:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100ac1:	83 c0 04             	add    $0x4,%eax
  100ac4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100ac7:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100aca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100acd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100ad1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ad5:	89 1c 24             	mov    %ebx,(%esp)
  100ad8:	ff d2                	call   *%edx
  100ada:	eb 23                	jmp    100aff <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
  100adc:	ff 45 f4             	incl   -0xc(%ebp)
  100adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae2:	83 f8 02             	cmp    $0x2,%eax
  100ae5:	76 9e                	jbe    100a85 <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100ae7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100aea:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aee:	c7 04 24 cb 34 10 00 	movl   $0x1034cb,(%esp)
  100af5:	e8 26 f8 ff ff       	call   100320 <cprintf>
    return 0;
  100afa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100aff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100b02:	89 ec                	mov    %ebp,%esp
  100b04:	5d                   	pop    %ebp
  100b05:	c3                   	ret    

00100b06 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100b06:	55                   	push   %ebp
  100b07:	89 e5                	mov    %esp,%ebp
  100b09:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100b0c:	c7 04 24 e4 34 10 00 	movl   $0x1034e4,(%esp)
  100b13:	e8 08 f8 ff ff       	call   100320 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100b18:	c7 04 24 0c 35 10 00 	movl   $0x10350c,(%esp)
  100b1f:	e8 fc f7 ff ff       	call   100320 <cprintf>

    if (tf != NULL) {
  100b24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100b28:	74 0b                	je     100b35 <kmonitor+0x2f>
        print_trapframe(tf);
  100b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b2d:	89 04 24             	mov    %eax,(%esp)
  100b30:	e8 f8 0c 00 00       	call   10182d <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100b35:	c7 04 24 31 35 10 00 	movl   $0x103531,(%esp)
  100b3c:	e8 d0 f6 ff ff       	call   100211 <readline>
  100b41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100b44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b48:	74 eb                	je     100b35 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b54:	89 04 24             	mov    %eax,(%esp)
  100b57:	e8 f2 fe ff ff       	call   100a4e <runcmd>
  100b5c:	85 c0                	test   %eax,%eax
  100b5e:	78 02                	js     100b62 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100b60:	eb d3                	jmp    100b35 <kmonitor+0x2f>
                break;
  100b62:	90                   	nop
            }
        }
    }
}
  100b63:	90                   	nop
  100b64:	89 ec                	mov    %ebp,%esp
  100b66:	5d                   	pop    %ebp
  100b67:	c3                   	ret    

00100b68 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100b68:	55                   	push   %ebp
  100b69:	89 e5                	mov    %esp,%ebp
  100b6b:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b75:	eb 3d                	jmp    100bb4 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100b77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b7a:	89 d0                	mov    %edx,%eax
  100b7c:	01 c0                	add    %eax,%eax
  100b7e:	01 d0                	add    %edx,%eax
  100b80:	c1 e0 02             	shl    $0x2,%eax
  100b83:	05 04 e0 10 00       	add    $0x10e004,%eax
  100b88:	8b 10                	mov    (%eax),%edx
  100b8a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100b8d:	89 c8                	mov    %ecx,%eax
  100b8f:	01 c0                	add    %eax,%eax
  100b91:	01 c8                	add    %ecx,%eax
  100b93:	c1 e0 02             	shl    $0x2,%eax
  100b96:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b9b:	8b 00                	mov    (%eax),%eax
  100b9d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ba5:	c7 04 24 35 35 10 00 	movl   $0x103535,(%esp)
  100bac:	e8 6f f7 ff ff       	call   100320 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100bb1:	ff 45 f4             	incl   -0xc(%ebp)
  100bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bb7:	83 f8 02             	cmp    $0x2,%eax
  100bba:	76 bb                	jbe    100b77 <mon_help+0xf>
    }
    return 0;
  100bbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bc1:	89 ec                	mov    %ebp,%esp
  100bc3:	5d                   	pop    %ebp
  100bc4:	c3                   	ret    

00100bc5 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100bc5:	55                   	push   %ebp
  100bc6:	89 e5                	mov    %esp,%ebp
  100bc8:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100bcb:	e8 73 fc ff ff       	call   100843 <print_kerninfo>
    return 0;
  100bd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bd5:	89 ec                	mov    %ebp,%esp
  100bd7:	5d                   	pop    %ebp
  100bd8:	c3                   	ret    

00100bd9 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100bd9:	55                   	push   %ebp
  100bda:	89 e5                	mov    %esp,%ebp
  100bdc:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100bdf:	e8 ab fd ff ff       	call   10098f <print_stackframe>
    return 0;
  100be4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100be9:	89 ec                	mov    %ebp,%esp
  100beb:	5d                   	pop    %ebp
  100bec:	c3                   	ret    

00100bed <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100bed:	55                   	push   %ebp
  100bee:	89 e5                	mov    %esp,%ebp
  100bf0:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100bf3:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100bf8:	85 c0                	test   %eax,%eax
  100bfa:	75 5b                	jne    100c57 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100bfc:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100c03:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100c06:	8d 45 14             	lea    0x14(%ebp),%eax
  100c09:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c0f:	89 44 24 08          	mov    %eax,0x8(%esp)
  100c13:	8b 45 08             	mov    0x8(%ebp),%eax
  100c16:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c1a:	c7 04 24 3e 35 10 00 	movl   $0x10353e,(%esp)
  100c21:	e8 fa f6 ff ff       	call   100320 <cprintf>
    vcprintf(fmt, ap);
  100c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c29:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c2d:	8b 45 10             	mov    0x10(%ebp),%eax
  100c30:	89 04 24             	mov    %eax,(%esp)
  100c33:	e8 b3 f6 ff ff       	call   1002eb <vcprintf>
    cprintf("\n");
  100c38:	c7 04 24 5a 35 10 00 	movl   $0x10355a,(%esp)
  100c3f:	e8 dc f6 ff ff       	call   100320 <cprintf>
    
    cprintf("stack trackback:\n");
  100c44:	c7 04 24 5c 35 10 00 	movl   $0x10355c,(%esp)
  100c4b:	e8 d0 f6 ff ff       	call   100320 <cprintf>
    print_stackframe();
  100c50:	e8 3a fd ff ff       	call   10098f <print_stackframe>
  100c55:	eb 01                	jmp    100c58 <__panic+0x6b>
        goto panic_dead;
  100c57:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100c58:	e8 81 09 00 00       	call   1015de <intr_disable>
    while (1) {
        kmonitor(NULL);
  100c5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100c64:	e8 9d fe ff ff       	call   100b06 <kmonitor>
  100c69:	eb f2                	jmp    100c5d <__panic+0x70>

00100c6b <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100c6b:	55                   	push   %ebp
  100c6c:	89 e5                	mov    %esp,%ebp
  100c6e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100c71:	8d 45 14             	lea    0x14(%ebp),%eax
  100c74:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c7a:	89 44 24 08          	mov    %eax,0x8(%esp)
  100c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c81:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c85:	c7 04 24 6e 35 10 00 	movl   $0x10356e,(%esp)
  100c8c:	e8 8f f6 ff ff       	call   100320 <cprintf>
    vcprintf(fmt, ap);
  100c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c94:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c98:	8b 45 10             	mov    0x10(%ebp),%eax
  100c9b:	89 04 24             	mov    %eax,(%esp)
  100c9e:	e8 48 f6 ff ff       	call   1002eb <vcprintf>
    cprintf("\n");
  100ca3:	c7 04 24 5a 35 10 00 	movl   $0x10355a,(%esp)
  100caa:	e8 71 f6 ff ff       	call   100320 <cprintf>
    va_end(ap);
}
  100caf:	90                   	nop
  100cb0:	89 ec                	mov    %ebp,%esp
  100cb2:	5d                   	pop    %ebp
  100cb3:	c3                   	ret    

00100cb4 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100cb4:	55                   	push   %ebp
  100cb5:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100cb7:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100cbc:	5d                   	pop    %ebp
  100cbd:	c3                   	ret    

00100cbe <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100cbe:	55                   	push   %ebp
  100cbf:	89 e5                	mov    %esp,%ebp
  100cc1:	83 ec 28             	sub    $0x28,%esp
  100cc4:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100cca:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100cce:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100cd2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100cd6:	ee                   	out    %al,(%dx)
}
  100cd7:	90                   	nop
  100cd8:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100cde:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ce2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ce6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100cea:	ee                   	out    %al,(%dx)
}
  100ceb:	90                   	nop
  100cec:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100cf2:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100cf6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100cfa:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100cfe:	ee                   	out    %al,(%dx)
}
  100cff:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d00:	c7 05 44 ee 10 00 00 	movl   $0x0,0x10ee44
  100d07:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d0a:	c7 04 24 8c 35 10 00 	movl   $0x10358c,(%esp)
  100d11:	e8 0a f6 ff ff       	call   100320 <cprintf>
    pic_enable(IRQ_TIMER);
  100d16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d1d:	e8 21 09 00 00       	call   101643 <pic_enable>
}
  100d22:	90                   	nop
  100d23:	89 ec                	mov    %ebp,%esp
  100d25:	5d                   	pop    %ebp
  100d26:	c3                   	ret    

00100d27 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100d27:	55                   	push   %ebp
  100d28:	89 e5                	mov    %esp,%ebp
  100d2a:	83 ec 10             	sub    $0x10,%esp
  100d2d:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100d33:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100d37:	89 c2                	mov    %eax,%edx
  100d39:	ec                   	in     (%dx),%al
  100d3a:	88 45 f1             	mov    %al,-0xf(%ebp)
  100d3d:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100d43:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100d47:	89 c2                	mov    %eax,%edx
  100d49:	ec                   	in     (%dx),%al
  100d4a:	88 45 f5             	mov    %al,-0xb(%ebp)
  100d4d:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100d53:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100d57:	89 c2                	mov    %eax,%edx
  100d59:	ec                   	in     (%dx),%al
  100d5a:	88 45 f9             	mov    %al,-0x7(%ebp)
  100d5d:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100d63:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100d67:	89 c2                	mov    %eax,%edx
  100d69:	ec                   	in     (%dx),%al
  100d6a:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100d6d:	90                   	nop
  100d6e:	89 ec                	mov    %ebp,%esp
  100d70:	5d                   	pop    %ebp
  100d71:	c3                   	ret    

00100d72 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100d72:	55                   	push   %ebp
  100d73:	89 e5                	mov    %esp,%ebp
  100d75:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100d78:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100d7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d82:	0f b7 00             	movzwl (%eax),%eax
  100d85:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100d89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d8c:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100d91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d94:	0f b7 00             	movzwl (%eax),%eax
  100d97:	0f b7 c0             	movzwl %ax,%eax
  100d9a:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100d9f:	74 12                	je     100db3 <cga_init+0x41>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100da1:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100da8:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100daf:	b4 03 
  100db1:	eb 13                	jmp    100dc6 <cga_init+0x54>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100db3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100db6:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100dba:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100dbd:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100dc4:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100dc6:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100dcd:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100dd1:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dd5:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100dd9:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ddd:	ee                   	out    %al,(%dx)
}
  100dde:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100ddf:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100de6:	40                   	inc    %eax
  100de7:	0f b7 c0             	movzwl %ax,%eax
  100dea:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dee:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100df2:	89 c2                	mov    %eax,%edx
  100df4:	ec                   	in     (%dx),%al
  100df5:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100df8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100dfc:	0f b6 c0             	movzbl %al,%eax
  100dff:	c1 e0 08             	shl    $0x8,%eax
  100e02:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e05:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e0c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100e10:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e14:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e18:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e1c:	ee                   	out    %al,(%dx)
}
  100e1d:	90                   	nop
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100e1e:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e25:	40                   	inc    %eax
  100e26:	0f b7 c0             	movzwl %ax,%eax
  100e29:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e2d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e31:	89 c2                	mov    %eax,%edx
  100e33:	ec                   	in     (%dx),%al
  100e34:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100e37:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e3b:	0f b6 c0             	movzbl %al,%eax
  100e3e:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100e41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e44:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100e4c:	0f b7 c0             	movzwl %ax,%eax
  100e4f:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100e55:	90                   	nop
  100e56:	89 ec                	mov    %ebp,%esp
  100e58:	5d                   	pop    %ebp
  100e59:	c3                   	ret    

00100e5a <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100e5a:	55                   	push   %ebp
  100e5b:	89 e5                	mov    %esp,%ebp
  100e5d:	83 ec 48             	sub    $0x48,%esp
  100e60:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100e66:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e6a:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100e6e:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100e72:	ee                   	out    %al,(%dx)
}
  100e73:	90                   	nop
  100e74:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100e7a:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e7e:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100e82:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100e86:	ee                   	out    %al,(%dx)
}
  100e87:	90                   	nop
  100e88:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100e8e:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e92:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100e96:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100e9a:	ee                   	out    %al,(%dx)
}
  100e9b:	90                   	nop
  100e9c:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100ea2:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ea6:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100eaa:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100eae:	ee                   	out    %al,(%dx)
}
  100eaf:	90                   	nop
  100eb0:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100eb6:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eba:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100ebe:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100ec2:	ee                   	out    %al,(%dx)
}
  100ec3:	90                   	nop
  100ec4:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100eca:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ece:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ed2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ed6:	ee                   	out    %al,(%dx)
}
  100ed7:	90                   	nop
  100ed8:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100ede:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ee2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ee6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100eea:	ee                   	out    %al,(%dx)
}
  100eeb:	90                   	nop
  100eec:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ef2:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ef6:	89 c2                	mov    %eax,%edx
  100ef8:	ec                   	in     (%dx),%al
  100ef9:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100efc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f00:	3c ff                	cmp    $0xff,%al
  100f02:	0f 95 c0             	setne  %al
  100f05:	0f b6 c0             	movzbl %al,%eax
  100f08:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f0d:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f13:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f17:	89 c2                	mov    %eax,%edx
  100f19:	ec                   	in     (%dx),%al
  100f1a:	88 45 f1             	mov    %al,-0xf(%ebp)
  100f1d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100f23:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100f27:	89 c2                	mov    %eax,%edx
  100f29:	ec                   	in     (%dx),%al
  100f2a:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100f2d:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100f32:	85 c0                	test   %eax,%eax
  100f34:	74 0c                	je     100f42 <serial_init+0xe8>
        pic_enable(IRQ_COM1);
  100f36:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100f3d:	e8 01 07 00 00       	call   101643 <pic_enable>
    }
}
  100f42:	90                   	nop
  100f43:	89 ec                	mov    %ebp,%esp
  100f45:	5d                   	pop    %ebp
  100f46:	c3                   	ret    

00100f47 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100f47:	55                   	push   %ebp
  100f48:	89 e5                	mov    %esp,%ebp
  100f4a:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100f4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100f54:	eb 08                	jmp    100f5e <lpt_putc_sub+0x17>
        delay();
  100f56:	e8 cc fd ff ff       	call   100d27 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100f5b:	ff 45 fc             	incl   -0x4(%ebp)
  100f5e:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100f64:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100f68:	89 c2                	mov    %eax,%edx
  100f6a:	ec                   	in     (%dx),%al
  100f6b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100f6e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100f72:	84 c0                	test   %al,%al
  100f74:	78 09                	js     100f7f <lpt_putc_sub+0x38>
  100f76:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100f7d:	7e d7                	jle    100f56 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  100f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  100f82:	0f b6 c0             	movzbl %al,%eax
  100f85:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  100f8b:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f8e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f92:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f96:	ee                   	out    %al,(%dx)
}
  100f97:	90                   	nop
  100f98:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  100f9e:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fa2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fa6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100faa:	ee                   	out    %al,(%dx)
}
  100fab:	90                   	nop
  100fac:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  100fb2:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fb6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100fba:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100fbe:	ee                   	out    %al,(%dx)
}
  100fbf:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  100fc0:	90                   	nop
  100fc1:	89 ec                	mov    %ebp,%esp
  100fc3:	5d                   	pop    %ebp
  100fc4:	c3                   	ret    

00100fc5 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  100fc5:	55                   	push   %ebp
  100fc6:	89 e5                	mov    %esp,%ebp
  100fc8:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  100fcb:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  100fcf:	74 0d                	je     100fde <lpt_putc+0x19>
        lpt_putc_sub(c);
  100fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  100fd4:	89 04 24             	mov    %eax,(%esp)
  100fd7:	e8 6b ff ff ff       	call   100f47 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  100fdc:	eb 24                	jmp    101002 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  100fde:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  100fe5:	e8 5d ff ff ff       	call   100f47 <lpt_putc_sub>
        lpt_putc_sub(' ');
  100fea:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  100ff1:	e8 51 ff ff ff       	call   100f47 <lpt_putc_sub>
        lpt_putc_sub('\b');
  100ff6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  100ffd:	e8 45 ff ff ff       	call   100f47 <lpt_putc_sub>
}
  101002:	90                   	nop
  101003:	89 ec                	mov    %ebp,%esp
  101005:	5d                   	pop    %ebp
  101006:	c3                   	ret    

00101007 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101007:	55                   	push   %ebp
  101008:	89 e5                	mov    %esp,%ebp
  10100a:	83 ec 38             	sub    $0x38,%esp
  10100d:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
  101010:	8b 45 08             	mov    0x8(%ebp),%eax
  101013:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101018:	85 c0                	test   %eax,%eax
  10101a:	75 07                	jne    101023 <cga_putc+0x1c>
        c |= 0x0700;
  10101c:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101023:	8b 45 08             	mov    0x8(%ebp),%eax
  101026:	0f b6 c0             	movzbl %al,%eax
  101029:	83 f8 0d             	cmp    $0xd,%eax
  10102c:	74 72                	je     1010a0 <cga_putc+0x99>
  10102e:	83 f8 0d             	cmp    $0xd,%eax
  101031:	0f 8f a3 00 00 00    	jg     1010da <cga_putc+0xd3>
  101037:	83 f8 08             	cmp    $0x8,%eax
  10103a:	74 0a                	je     101046 <cga_putc+0x3f>
  10103c:	83 f8 0a             	cmp    $0xa,%eax
  10103f:	74 4c                	je     10108d <cga_putc+0x86>
  101041:	e9 94 00 00 00       	jmp    1010da <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
  101046:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10104d:	85 c0                	test   %eax,%eax
  10104f:	0f 84 af 00 00 00    	je     101104 <cga_putc+0xfd>
            crt_pos --;
  101055:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10105c:	48                   	dec    %eax
  10105d:	0f b7 c0             	movzwl %ax,%eax
  101060:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101066:	8b 45 08             	mov    0x8(%ebp),%eax
  101069:	98                   	cwtl   
  10106a:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10106f:	98                   	cwtl   
  101070:	83 c8 20             	or     $0x20,%eax
  101073:	98                   	cwtl   
  101074:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  10107a:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  101081:	01 d2                	add    %edx,%edx
  101083:	01 ca                	add    %ecx,%edx
  101085:	0f b7 c0             	movzwl %ax,%eax
  101088:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10108b:	eb 77                	jmp    101104 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
  10108d:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101094:	83 c0 50             	add    $0x50,%eax
  101097:	0f b7 c0             	movzwl %ax,%eax
  10109a:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010a0:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  1010a7:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  1010ae:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1010b3:	89 c8                	mov    %ecx,%eax
  1010b5:	f7 e2                	mul    %edx
  1010b7:	c1 ea 06             	shr    $0x6,%edx
  1010ba:	89 d0                	mov    %edx,%eax
  1010bc:	c1 e0 02             	shl    $0x2,%eax
  1010bf:	01 d0                	add    %edx,%eax
  1010c1:	c1 e0 04             	shl    $0x4,%eax
  1010c4:	29 c1                	sub    %eax,%ecx
  1010c6:	89 ca                	mov    %ecx,%edx
  1010c8:	0f b7 d2             	movzwl %dx,%edx
  1010cb:	89 d8                	mov    %ebx,%eax
  1010cd:	29 d0                	sub    %edx,%eax
  1010cf:	0f b7 c0             	movzwl %ax,%eax
  1010d2:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  1010d8:	eb 2b                	jmp    101105 <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1010da:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  1010e0:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010e7:	8d 50 01             	lea    0x1(%eax),%edx
  1010ea:	0f b7 d2             	movzwl %dx,%edx
  1010ed:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  1010f4:	01 c0                	add    %eax,%eax
  1010f6:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1010fc:	0f b7 c0             	movzwl %ax,%eax
  1010ff:	66 89 02             	mov    %ax,(%edx)
        break;
  101102:	eb 01                	jmp    101105 <cga_putc+0xfe>
        break;
  101104:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101105:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10110c:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101111:	76 5e                	jbe    101171 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101113:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101118:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10111e:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101123:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10112a:	00 
  10112b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10112f:	89 04 24             	mov    %eax,(%esp)
  101132:	e8 16 20 00 00       	call   10314d <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101137:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10113e:	eb 15                	jmp    101155 <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
  101140:	8b 15 60 ee 10 00    	mov    0x10ee60,%edx
  101146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101149:	01 c0                	add    %eax,%eax
  10114b:	01 d0                	add    %edx,%eax
  10114d:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101152:	ff 45 f4             	incl   -0xc(%ebp)
  101155:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10115c:	7e e2                	jle    101140 <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
  10115e:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101165:	83 e8 50             	sub    $0x50,%eax
  101168:	0f b7 c0             	movzwl %ax,%eax
  10116b:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101171:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101178:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  10117c:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101180:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101184:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101188:	ee                   	out    %al,(%dx)
}
  101189:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  10118a:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101191:	c1 e8 08             	shr    $0x8,%eax
  101194:	0f b7 c0             	movzwl %ax,%eax
  101197:	0f b6 c0             	movzbl %al,%eax
  10119a:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011a1:	42                   	inc    %edx
  1011a2:	0f b7 d2             	movzwl %dx,%edx
  1011a5:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1011a9:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1011ac:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1011b0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1011b4:	ee                   	out    %al,(%dx)
}
  1011b5:	90                   	nop
    outb(addr_6845, 15);
  1011b6:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011bd:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1011c1:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1011c5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1011c9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1011cd:	ee                   	out    %al,(%dx)
}
  1011ce:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  1011cf:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011d6:	0f b6 c0             	movzbl %al,%eax
  1011d9:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011e0:	42                   	inc    %edx
  1011e1:	0f b7 d2             	movzwl %dx,%edx
  1011e4:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1011e8:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1011eb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011ef:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011f3:	ee                   	out    %al,(%dx)
}
  1011f4:	90                   	nop
}
  1011f5:	90                   	nop
  1011f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1011f9:	89 ec                	mov    %ebp,%esp
  1011fb:	5d                   	pop    %ebp
  1011fc:	c3                   	ret    

001011fd <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1011fd:	55                   	push   %ebp
  1011fe:	89 e5                	mov    %esp,%ebp
  101200:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101203:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10120a:	eb 08                	jmp    101214 <serial_putc_sub+0x17>
        delay();
  10120c:	e8 16 fb ff ff       	call   100d27 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101211:	ff 45 fc             	incl   -0x4(%ebp)
  101214:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10121a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10121e:	89 c2                	mov    %eax,%edx
  101220:	ec                   	in     (%dx),%al
  101221:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101224:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101228:	0f b6 c0             	movzbl %al,%eax
  10122b:	83 e0 20             	and    $0x20,%eax
  10122e:	85 c0                	test   %eax,%eax
  101230:	75 09                	jne    10123b <serial_putc_sub+0x3e>
  101232:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101239:	7e d1                	jle    10120c <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  10123b:	8b 45 08             	mov    0x8(%ebp),%eax
  10123e:	0f b6 c0             	movzbl %al,%eax
  101241:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101247:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10124a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10124e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101252:	ee                   	out    %al,(%dx)
}
  101253:	90                   	nop
}
  101254:	90                   	nop
  101255:	89 ec                	mov    %ebp,%esp
  101257:	5d                   	pop    %ebp
  101258:	c3                   	ret    

00101259 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101259:	55                   	push   %ebp
  10125a:	89 e5                	mov    %esp,%ebp
  10125c:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10125f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101263:	74 0d                	je     101272 <serial_putc+0x19>
        serial_putc_sub(c);
  101265:	8b 45 08             	mov    0x8(%ebp),%eax
  101268:	89 04 24             	mov    %eax,(%esp)
  10126b:	e8 8d ff ff ff       	call   1011fd <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101270:	eb 24                	jmp    101296 <serial_putc+0x3d>
        serial_putc_sub('\b');
  101272:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101279:	e8 7f ff ff ff       	call   1011fd <serial_putc_sub>
        serial_putc_sub(' ');
  10127e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101285:	e8 73 ff ff ff       	call   1011fd <serial_putc_sub>
        serial_putc_sub('\b');
  10128a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101291:	e8 67 ff ff ff       	call   1011fd <serial_putc_sub>
}
  101296:	90                   	nop
  101297:	89 ec                	mov    %ebp,%esp
  101299:	5d                   	pop    %ebp
  10129a:	c3                   	ret    

0010129b <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10129b:	55                   	push   %ebp
  10129c:	89 e5                	mov    %esp,%ebp
  10129e:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012a1:	eb 33                	jmp    1012d6 <cons_intr+0x3b>
        if (c != 0) {
  1012a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012a7:	74 2d                	je     1012d6 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012a9:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012ae:	8d 50 01             	lea    0x1(%eax),%edx
  1012b1:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  1012b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012ba:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012c0:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012c5:	3d 00 02 00 00       	cmp    $0x200,%eax
  1012ca:	75 0a                	jne    1012d6 <cons_intr+0x3b>
                cons.wpos = 0;
  1012cc:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  1012d3:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1012d9:	ff d0                	call   *%eax
  1012db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1012de:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1012e2:	75 bf                	jne    1012a3 <cons_intr+0x8>
            }
        }
    }
}
  1012e4:	90                   	nop
  1012e5:	90                   	nop
  1012e6:	89 ec                	mov    %ebp,%esp
  1012e8:	5d                   	pop    %ebp
  1012e9:	c3                   	ret    

001012ea <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1012ea:	55                   	push   %ebp
  1012eb:	89 e5                	mov    %esp,%ebp
  1012ed:	83 ec 10             	sub    $0x10,%esp
  1012f0:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012f6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012fa:	89 c2                	mov    %eax,%edx
  1012fc:	ec                   	in     (%dx),%al
  1012fd:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101300:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101304:	0f b6 c0             	movzbl %al,%eax
  101307:	83 e0 01             	and    $0x1,%eax
  10130a:	85 c0                	test   %eax,%eax
  10130c:	75 07                	jne    101315 <serial_proc_data+0x2b>
        return -1;
  10130e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101313:	eb 2a                	jmp    10133f <serial_proc_data+0x55>
  101315:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10131b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10131f:	89 c2                	mov    %eax,%edx
  101321:	ec                   	in     (%dx),%al
  101322:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101325:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101329:	0f b6 c0             	movzbl %al,%eax
  10132c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10132f:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101333:	75 07                	jne    10133c <serial_proc_data+0x52>
        c = '\b';
  101335:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10133c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10133f:	89 ec                	mov    %ebp,%esp
  101341:	5d                   	pop    %ebp
  101342:	c3                   	ret    

00101343 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101343:	55                   	push   %ebp
  101344:	89 e5                	mov    %esp,%ebp
  101346:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101349:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10134e:	85 c0                	test   %eax,%eax
  101350:	74 0c                	je     10135e <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101352:	c7 04 24 ea 12 10 00 	movl   $0x1012ea,(%esp)
  101359:	e8 3d ff ff ff       	call   10129b <cons_intr>
    }
}
  10135e:	90                   	nop
  10135f:	89 ec                	mov    %ebp,%esp
  101361:	5d                   	pop    %ebp
  101362:	c3                   	ret    

00101363 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101363:	55                   	push   %ebp
  101364:	89 e5                	mov    %esp,%ebp
  101366:	83 ec 38             	sub    $0x38,%esp
  101369:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10136f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101372:	89 c2                	mov    %eax,%edx
  101374:	ec                   	in     (%dx),%al
  101375:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101378:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10137c:	0f b6 c0             	movzbl %al,%eax
  10137f:	83 e0 01             	and    $0x1,%eax
  101382:	85 c0                	test   %eax,%eax
  101384:	75 0a                	jne    101390 <kbd_proc_data+0x2d>
        return -1;
  101386:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10138b:	e9 56 01 00 00       	jmp    1014e6 <kbd_proc_data+0x183>
  101390:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101396:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101399:	89 c2                	mov    %eax,%edx
  10139b:	ec                   	in     (%dx),%al
  10139c:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10139f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013a3:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013a6:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013aa:	75 17                	jne    1013c3 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  1013ac:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013b1:	83 c8 40             	or     $0x40,%eax
  1013b4:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1013b9:	b8 00 00 00 00       	mov    $0x0,%eax
  1013be:	e9 23 01 00 00       	jmp    1014e6 <kbd_proc_data+0x183>
    } else if (data & 0x80) {
  1013c3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013c7:	84 c0                	test   %al,%al
  1013c9:	79 45                	jns    101410 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1013cb:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013d0:	83 e0 40             	and    $0x40,%eax
  1013d3:	85 c0                	test   %eax,%eax
  1013d5:	75 08                	jne    1013df <kbd_proc_data+0x7c>
  1013d7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013db:	24 7f                	and    $0x7f,%al
  1013dd:	eb 04                	jmp    1013e3 <kbd_proc_data+0x80>
  1013df:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013e3:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1013e6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013ea:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  1013f1:	0c 40                	or     $0x40,%al
  1013f3:	0f b6 c0             	movzbl %al,%eax
  1013f6:	f7 d0                	not    %eax
  1013f8:	89 c2                	mov    %eax,%edx
  1013fa:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013ff:	21 d0                	and    %edx,%eax
  101401:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101406:	b8 00 00 00 00       	mov    $0x0,%eax
  10140b:	e9 d6 00 00 00       	jmp    1014e6 <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
  101410:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101415:	83 e0 40             	and    $0x40,%eax
  101418:	85 c0                	test   %eax,%eax
  10141a:	74 11                	je     10142d <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10141c:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101420:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101425:	83 e0 bf             	and    $0xffffffbf,%eax
  101428:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10142d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101431:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101438:	0f b6 d0             	movzbl %al,%edx
  10143b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101440:	09 d0                	or     %edx,%eax
  101442:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101447:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10144b:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  101452:	0f b6 d0             	movzbl %al,%edx
  101455:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10145a:	31 d0                	xor    %edx,%eax
  10145c:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  101461:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101466:	83 e0 03             	and    $0x3,%eax
  101469:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  101470:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101474:	01 d0                	add    %edx,%eax
  101476:	0f b6 00             	movzbl (%eax),%eax
  101479:	0f b6 c0             	movzbl %al,%eax
  10147c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10147f:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101484:	83 e0 08             	and    $0x8,%eax
  101487:	85 c0                	test   %eax,%eax
  101489:	74 22                	je     1014ad <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  10148b:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10148f:	7e 0c                	jle    10149d <kbd_proc_data+0x13a>
  101491:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101495:	7f 06                	jg     10149d <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  101497:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10149b:	eb 10                	jmp    1014ad <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  10149d:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014a1:	7e 0a                	jle    1014ad <kbd_proc_data+0x14a>
  1014a3:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014a7:	7f 04                	jg     1014ad <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  1014a9:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014ad:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b2:	f7 d0                	not    %eax
  1014b4:	83 e0 06             	and    $0x6,%eax
  1014b7:	85 c0                	test   %eax,%eax
  1014b9:	75 28                	jne    1014e3 <kbd_proc_data+0x180>
  1014bb:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1014c2:	75 1f                	jne    1014e3 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
  1014c4:	c7 04 24 a7 35 10 00 	movl   $0x1035a7,(%esp)
  1014cb:	e8 50 ee ff ff       	call   100320 <cprintf>
  1014d0:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1014d6:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1014da:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1014de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1014e1:	ee                   	out    %al,(%dx)
}
  1014e2:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1014e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1014e6:	89 ec                	mov    %ebp,%esp
  1014e8:	5d                   	pop    %ebp
  1014e9:	c3                   	ret    

001014ea <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1014ea:	55                   	push   %ebp
  1014eb:	89 e5                	mov    %esp,%ebp
  1014ed:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1014f0:	c7 04 24 63 13 10 00 	movl   $0x101363,(%esp)
  1014f7:	e8 9f fd ff ff       	call   10129b <cons_intr>
}
  1014fc:	90                   	nop
  1014fd:	89 ec                	mov    %ebp,%esp
  1014ff:	5d                   	pop    %ebp
  101500:	c3                   	ret    

00101501 <kbd_init>:

static void
kbd_init(void) {
  101501:	55                   	push   %ebp
  101502:	89 e5                	mov    %esp,%ebp
  101504:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101507:	e8 de ff ff ff       	call   1014ea <kbd_intr>
    pic_enable(IRQ_KBD);
  10150c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101513:	e8 2b 01 00 00       	call   101643 <pic_enable>
}
  101518:	90                   	nop
  101519:	89 ec                	mov    %ebp,%esp
  10151b:	5d                   	pop    %ebp
  10151c:	c3                   	ret    

0010151d <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10151d:	55                   	push   %ebp
  10151e:	89 e5                	mov    %esp,%ebp
  101520:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101523:	e8 4a f8 ff ff       	call   100d72 <cga_init>
    serial_init();
  101528:	e8 2d f9 ff ff       	call   100e5a <serial_init>
    kbd_init();
  10152d:	e8 cf ff ff ff       	call   101501 <kbd_init>
    if (!serial_exists) {
  101532:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101537:	85 c0                	test   %eax,%eax
  101539:	75 0c                	jne    101547 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10153b:	c7 04 24 b3 35 10 00 	movl   $0x1035b3,(%esp)
  101542:	e8 d9 ed ff ff       	call   100320 <cprintf>
    }
}
  101547:	90                   	nop
  101548:	89 ec                	mov    %ebp,%esp
  10154a:	5d                   	pop    %ebp
  10154b:	c3                   	ret    

0010154c <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10154c:	55                   	push   %ebp
  10154d:	89 e5                	mov    %esp,%ebp
  10154f:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101552:	8b 45 08             	mov    0x8(%ebp),%eax
  101555:	89 04 24             	mov    %eax,(%esp)
  101558:	e8 68 fa ff ff       	call   100fc5 <lpt_putc>
    cga_putc(c);
  10155d:	8b 45 08             	mov    0x8(%ebp),%eax
  101560:	89 04 24             	mov    %eax,(%esp)
  101563:	e8 9f fa ff ff       	call   101007 <cga_putc>
    serial_putc(c);
  101568:	8b 45 08             	mov    0x8(%ebp),%eax
  10156b:	89 04 24             	mov    %eax,(%esp)
  10156e:	e8 e6 fc ff ff       	call   101259 <serial_putc>
}
  101573:	90                   	nop
  101574:	89 ec                	mov    %ebp,%esp
  101576:	5d                   	pop    %ebp
  101577:	c3                   	ret    

00101578 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101578:	55                   	push   %ebp
  101579:	89 e5                	mov    %esp,%ebp
  10157b:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  10157e:	e8 c0 fd ff ff       	call   101343 <serial_intr>
    kbd_intr();
  101583:	e8 62 ff ff ff       	call   1014ea <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  101588:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  10158e:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101593:	39 c2                	cmp    %eax,%edx
  101595:	74 36                	je     1015cd <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  101597:	a1 80 f0 10 00       	mov    0x10f080,%eax
  10159c:	8d 50 01             	lea    0x1(%eax),%edx
  10159f:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015a5:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015ac:	0f b6 c0             	movzbl %al,%eax
  1015af:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015b2:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015b7:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015bc:	75 0a                	jne    1015c8 <cons_getc+0x50>
            cons.rpos = 0;
  1015be:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  1015c5:	00 00 00 
        }
        return c;
  1015c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1015cb:	eb 05                	jmp    1015d2 <cons_getc+0x5a>
    }
    return 0;
  1015cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1015d2:	89 ec                	mov    %ebp,%esp
  1015d4:	5d                   	pop    %ebp
  1015d5:	c3                   	ret    

001015d6 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1015d6:	55                   	push   %ebp
  1015d7:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1015d9:	fb                   	sti    
}
  1015da:	90                   	nop
    sti();
}
  1015db:	90                   	nop
  1015dc:	5d                   	pop    %ebp
  1015dd:	c3                   	ret    

001015de <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1015de:	55                   	push   %ebp
  1015df:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  1015e1:	fa                   	cli    
}
  1015e2:	90                   	nop
    cli();
}
  1015e3:	90                   	nop
  1015e4:	5d                   	pop    %ebp
  1015e5:	c3                   	ret    

001015e6 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1015e6:	55                   	push   %ebp
  1015e7:	89 e5                	mov    %esp,%ebp
  1015e9:	83 ec 14             	sub    $0x14,%esp
  1015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1015ef:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1015f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1015f6:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  1015fc:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101601:	85 c0                	test   %eax,%eax
  101603:	74 39                	je     10163e <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
  101605:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101608:	0f b6 c0             	movzbl %al,%eax
  10160b:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101611:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101614:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101618:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10161c:	ee                   	out    %al,(%dx)
}
  10161d:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  10161e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101622:	c1 e8 08             	shr    $0x8,%eax
  101625:	0f b7 c0             	movzwl %ax,%eax
  101628:	0f b6 c0             	movzbl %al,%eax
  10162b:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101631:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101634:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101638:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10163c:	ee                   	out    %al,(%dx)
}
  10163d:	90                   	nop
    }
}
  10163e:	90                   	nop
  10163f:	89 ec                	mov    %ebp,%esp
  101641:	5d                   	pop    %ebp
  101642:	c3                   	ret    

00101643 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101643:	55                   	push   %ebp
  101644:	89 e5                	mov    %esp,%ebp
  101646:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101649:	8b 45 08             	mov    0x8(%ebp),%eax
  10164c:	ba 01 00 00 00       	mov    $0x1,%edx
  101651:	88 c1                	mov    %al,%cl
  101653:	d3 e2                	shl    %cl,%edx
  101655:	89 d0                	mov    %edx,%eax
  101657:	98                   	cwtl   
  101658:	f7 d0                	not    %eax
  10165a:	0f bf d0             	movswl %ax,%edx
  10165d:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101664:	98                   	cwtl   
  101665:	21 d0                	and    %edx,%eax
  101667:	98                   	cwtl   
  101668:	0f b7 c0             	movzwl %ax,%eax
  10166b:	89 04 24             	mov    %eax,(%esp)
  10166e:	e8 73 ff ff ff       	call   1015e6 <pic_setmask>
}
  101673:	90                   	nop
  101674:	89 ec                	mov    %ebp,%esp
  101676:	5d                   	pop    %ebp
  101677:	c3                   	ret    

00101678 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101678:	55                   	push   %ebp
  101679:	89 e5                	mov    %esp,%ebp
  10167b:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10167e:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  101685:	00 00 00 
  101688:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  10168e:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101692:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101696:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10169a:	ee                   	out    %al,(%dx)
}
  10169b:	90                   	nop
  10169c:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1016a2:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1016a6:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1016aa:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1016ae:	ee                   	out    %al,(%dx)
}
  1016af:	90                   	nop
  1016b0:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1016b6:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1016ba:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1016be:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1016c2:	ee                   	out    %al,(%dx)
}
  1016c3:	90                   	nop
  1016c4:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1016ca:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1016ce:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1016d2:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1016d6:	ee                   	out    %al,(%dx)
}
  1016d7:	90                   	nop
  1016d8:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  1016de:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1016e2:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1016e6:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1016ea:	ee                   	out    %al,(%dx)
}
  1016eb:	90                   	nop
  1016ec:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1016f2:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1016f6:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1016fa:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1016fe:	ee                   	out    %al,(%dx)
}
  1016ff:	90                   	nop
  101700:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101706:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10170a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10170e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101712:	ee                   	out    %al,(%dx)
}
  101713:	90                   	nop
  101714:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  10171a:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10171e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101722:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101726:	ee                   	out    %al,(%dx)
}
  101727:	90                   	nop
  101728:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  10172e:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101732:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101736:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10173a:	ee                   	out    %al,(%dx)
}
  10173b:	90                   	nop
  10173c:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101742:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101746:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10174a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10174e:	ee                   	out    %al,(%dx)
}
  10174f:	90                   	nop
  101750:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101756:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10175a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10175e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101762:	ee                   	out    %al,(%dx)
}
  101763:	90                   	nop
  101764:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10176a:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10176e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101772:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101776:	ee                   	out    %al,(%dx)
}
  101777:	90                   	nop
  101778:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  10177e:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101782:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101786:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10178a:	ee                   	out    %al,(%dx)
}
  10178b:	90                   	nop
  10178c:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101792:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101796:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10179a:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10179e:	ee                   	out    %al,(%dx)
}
  10179f:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017a0:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017a7:	3d ff ff 00 00       	cmp    $0xffff,%eax
  1017ac:	74 0f                	je     1017bd <pic_init+0x145>
        pic_setmask(irq_mask);
  1017ae:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017b5:	89 04 24             	mov    %eax,(%esp)
  1017b8:	e8 29 fe ff ff       	call   1015e6 <pic_setmask>
    }
}
  1017bd:	90                   	nop
  1017be:	89 ec                	mov    %ebp,%esp
  1017c0:	5d                   	pop    %ebp
  1017c1:	c3                   	ret    

001017c2 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017c2:	55                   	push   %ebp
  1017c3:	89 e5                	mov    %esp,%ebp
  1017c5:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017c8:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1017cf:	00 
  1017d0:	c7 04 24 e0 35 10 00 	movl   $0x1035e0,(%esp)
  1017d7:	e8 44 eb ff ff       	call   100320 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1017dc:	90                   	nop
  1017dd:	89 ec                	mov    %ebp,%esp
  1017df:	5d                   	pop    %ebp
  1017e0:	c3                   	ret    

001017e1 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1017e1:	55                   	push   %ebp
  1017e2:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  1017e4:	90                   	nop
  1017e5:	5d                   	pop    %ebp
  1017e6:	c3                   	ret    

001017e7 <trapname>:

static const char *
trapname(int trapno) {
  1017e7:	55                   	push   %ebp
  1017e8:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1017ed:	83 f8 13             	cmp    $0x13,%eax
  1017f0:	77 0c                	ja     1017fe <trapname+0x17>
        return excnames[trapno];
  1017f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1017f5:	8b 04 85 40 39 10 00 	mov    0x103940(,%eax,4),%eax
  1017fc:	eb 18                	jmp    101816 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1017fe:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101802:	7e 0d                	jle    101811 <trapname+0x2a>
  101804:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101808:	7f 07                	jg     101811 <trapname+0x2a>
        return "Hardware Interrupt";
  10180a:	b8 ea 35 10 00       	mov    $0x1035ea,%eax
  10180f:	eb 05                	jmp    101816 <trapname+0x2f>
    }
    return "(unknown trap)";
  101811:	b8 fd 35 10 00       	mov    $0x1035fd,%eax
}
  101816:	5d                   	pop    %ebp
  101817:	c3                   	ret    

00101818 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101818:	55                   	push   %ebp
  101819:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  10181b:	8b 45 08             	mov    0x8(%ebp),%eax
  10181e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101822:	83 f8 08             	cmp    $0x8,%eax
  101825:	0f 94 c0             	sete   %al
  101828:	0f b6 c0             	movzbl %al,%eax
}
  10182b:	5d                   	pop    %ebp
  10182c:	c3                   	ret    

0010182d <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  10182d:	55                   	push   %ebp
  10182e:	89 e5                	mov    %esp,%ebp
  101830:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101833:	8b 45 08             	mov    0x8(%ebp),%eax
  101836:	89 44 24 04          	mov    %eax,0x4(%esp)
  10183a:	c7 04 24 3e 36 10 00 	movl   $0x10363e,(%esp)
  101841:	e8 da ea ff ff       	call   100320 <cprintf>
    print_regs(&tf->tf_regs);
  101846:	8b 45 08             	mov    0x8(%ebp),%eax
  101849:	89 04 24             	mov    %eax,(%esp)
  10184c:	e8 8f 01 00 00       	call   1019e0 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101851:	8b 45 08             	mov    0x8(%ebp),%eax
  101854:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101858:	89 44 24 04          	mov    %eax,0x4(%esp)
  10185c:	c7 04 24 4f 36 10 00 	movl   $0x10364f,(%esp)
  101863:	e8 b8 ea ff ff       	call   100320 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101868:	8b 45 08             	mov    0x8(%ebp),%eax
  10186b:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  10186f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101873:	c7 04 24 62 36 10 00 	movl   $0x103662,(%esp)
  10187a:	e8 a1 ea ff ff       	call   100320 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  10187f:	8b 45 08             	mov    0x8(%ebp),%eax
  101882:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101886:	89 44 24 04          	mov    %eax,0x4(%esp)
  10188a:	c7 04 24 75 36 10 00 	movl   $0x103675,(%esp)
  101891:	e8 8a ea ff ff       	call   100320 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101896:	8b 45 08             	mov    0x8(%ebp),%eax
  101899:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  10189d:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018a1:	c7 04 24 88 36 10 00 	movl   $0x103688,(%esp)
  1018a8:	e8 73 ea ff ff       	call   100320 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  1018ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1018b0:	8b 40 30             	mov    0x30(%eax),%eax
  1018b3:	89 04 24             	mov    %eax,(%esp)
  1018b6:	e8 2c ff ff ff       	call   1017e7 <trapname>
  1018bb:	8b 55 08             	mov    0x8(%ebp),%edx
  1018be:	8b 52 30             	mov    0x30(%edx),%edx
  1018c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1018c5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1018c9:	c7 04 24 9b 36 10 00 	movl   $0x10369b,(%esp)
  1018d0:	e8 4b ea ff ff       	call   100320 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  1018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1018d8:	8b 40 34             	mov    0x34(%eax),%eax
  1018db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018df:	c7 04 24 ad 36 10 00 	movl   $0x1036ad,(%esp)
  1018e6:	e8 35 ea ff ff       	call   100320 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  1018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1018ee:	8b 40 38             	mov    0x38(%eax),%eax
  1018f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018f5:	c7 04 24 bc 36 10 00 	movl   $0x1036bc,(%esp)
  1018fc:	e8 1f ea ff ff       	call   100320 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101901:	8b 45 08             	mov    0x8(%ebp),%eax
  101904:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101908:	89 44 24 04          	mov    %eax,0x4(%esp)
  10190c:	c7 04 24 cb 36 10 00 	movl   $0x1036cb,(%esp)
  101913:	e8 08 ea ff ff       	call   100320 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101918:	8b 45 08             	mov    0x8(%ebp),%eax
  10191b:	8b 40 40             	mov    0x40(%eax),%eax
  10191e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101922:	c7 04 24 de 36 10 00 	movl   $0x1036de,(%esp)
  101929:	e8 f2 e9 ff ff       	call   100320 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  10192e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101935:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  10193c:	eb 3d                	jmp    10197b <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  10193e:	8b 45 08             	mov    0x8(%ebp),%eax
  101941:	8b 50 40             	mov    0x40(%eax),%edx
  101944:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101947:	21 d0                	and    %edx,%eax
  101949:	85 c0                	test   %eax,%eax
  10194b:	74 28                	je     101975 <print_trapframe+0x148>
  10194d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101950:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101957:	85 c0                	test   %eax,%eax
  101959:	74 1a                	je     101975 <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
  10195b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10195e:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101965:	89 44 24 04          	mov    %eax,0x4(%esp)
  101969:	c7 04 24 ed 36 10 00 	movl   $0x1036ed,(%esp)
  101970:	e8 ab e9 ff ff       	call   100320 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101975:	ff 45 f4             	incl   -0xc(%ebp)
  101978:	d1 65 f0             	shll   -0x10(%ebp)
  10197b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10197e:	83 f8 17             	cmp    $0x17,%eax
  101981:	76 bb                	jbe    10193e <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101983:	8b 45 08             	mov    0x8(%ebp),%eax
  101986:	8b 40 40             	mov    0x40(%eax),%eax
  101989:	c1 e8 0c             	shr    $0xc,%eax
  10198c:	83 e0 03             	and    $0x3,%eax
  10198f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101993:	c7 04 24 f1 36 10 00 	movl   $0x1036f1,(%esp)
  10199a:	e8 81 e9 ff ff       	call   100320 <cprintf>

    if (!trap_in_kernel(tf)) {
  10199f:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a2:	89 04 24             	mov    %eax,(%esp)
  1019a5:	e8 6e fe ff ff       	call   101818 <trap_in_kernel>
  1019aa:	85 c0                	test   %eax,%eax
  1019ac:	75 2d                	jne    1019db <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  1019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b1:	8b 40 44             	mov    0x44(%eax),%eax
  1019b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019b8:	c7 04 24 fa 36 10 00 	movl   $0x1036fa,(%esp)
  1019bf:	e8 5c e9 ff ff       	call   100320 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  1019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c7:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  1019cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019cf:	c7 04 24 09 37 10 00 	movl   $0x103709,(%esp)
  1019d6:	e8 45 e9 ff ff       	call   100320 <cprintf>
    }
}
  1019db:	90                   	nop
  1019dc:	89 ec                	mov    %ebp,%esp
  1019de:	5d                   	pop    %ebp
  1019df:	c3                   	ret    

001019e0 <print_regs>:

void
print_regs(struct pushregs *regs) {
  1019e0:	55                   	push   %ebp
  1019e1:	89 e5                	mov    %esp,%ebp
  1019e3:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  1019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e9:	8b 00                	mov    (%eax),%eax
  1019eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019ef:	c7 04 24 1c 37 10 00 	movl   $0x10371c,(%esp)
  1019f6:	e8 25 e9 ff ff       	call   100320 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  1019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1019fe:	8b 40 04             	mov    0x4(%eax),%eax
  101a01:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a05:	c7 04 24 2b 37 10 00 	movl   $0x10372b,(%esp)
  101a0c:	e8 0f e9 ff ff       	call   100320 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101a11:	8b 45 08             	mov    0x8(%ebp),%eax
  101a14:	8b 40 08             	mov    0x8(%eax),%eax
  101a17:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a1b:	c7 04 24 3a 37 10 00 	movl   $0x10373a,(%esp)
  101a22:	e8 f9 e8 ff ff       	call   100320 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101a27:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2a:	8b 40 0c             	mov    0xc(%eax),%eax
  101a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a31:	c7 04 24 49 37 10 00 	movl   $0x103749,(%esp)
  101a38:	e8 e3 e8 ff ff       	call   100320 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a40:	8b 40 10             	mov    0x10(%eax),%eax
  101a43:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a47:	c7 04 24 58 37 10 00 	movl   $0x103758,(%esp)
  101a4e:	e8 cd e8 ff ff       	call   100320 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101a53:	8b 45 08             	mov    0x8(%ebp),%eax
  101a56:	8b 40 14             	mov    0x14(%eax),%eax
  101a59:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a5d:	c7 04 24 67 37 10 00 	movl   $0x103767,(%esp)
  101a64:	e8 b7 e8 ff ff       	call   100320 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101a69:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6c:	8b 40 18             	mov    0x18(%eax),%eax
  101a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a73:	c7 04 24 76 37 10 00 	movl   $0x103776,(%esp)
  101a7a:	e8 a1 e8 ff ff       	call   100320 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a82:	8b 40 1c             	mov    0x1c(%eax),%eax
  101a85:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a89:	c7 04 24 85 37 10 00 	movl   $0x103785,(%esp)
  101a90:	e8 8b e8 ff ff       	call   100320 <cprintf>
}
  101a95:	90                   	nop
  101a96:	89 ec                	mov    %ebp,%esp
  101a98:	5d                   	pop    %ebp
  101a99:	c3                   	ret    

00101a9a <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101a9a:	55                   	push   %ebp
  101a9b:	89 e5                	mov    %esp,%ebp
  101a9d:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa3:	8b 40 30             	mov    0x30(%eax),%eax
  101aa6:	83 f8 79             	cmp    $0x79,%eax
  101aa9:	0f 87 99 00 00 00    	ja     101b48 <trap_dispatch+0xae>
  101aaf:	83 f8 78             	cmp    $0x78,%eax
  101ab2:	73 78                	jae    101b2c <trap_dispatch+0x92>
  101ab4:	83 f8 2f             	cmp    $0x2f,%eax
  101ab7:	0f 87 8b 00 00 00    	ja     101b48 <trap_dispatch+0xae>
  101abd:	83 f8 2e             	cmp    $0x2e,%eax
  101ac0:	0f 83 b7 00 00 00    	jae    101b7d <trap_dispatch+0xe3>
  101ac6:	83 f8 24             	cmp    $0x24,%eax
  101ac9:	74 15                	je     101ae0 <trap_dispatch+0x46>
  101acb:	83 f8 24             	cmp    $0x24,%eax
  101ace:	77 78                	ja     101b48 <trap_dispatch+0xae>
  101ad0:	83 f8 20             	cmp    $0x20,%eax
  101ad3:	0f 84 a7 00 00 00    	je     101b80 <trap_dispatch+0xe6>
  101ad9:	83 f8 21             	cmp    $0x21,%eax
  101adc:	74 28                	je     101b06 <trap_dispatch+0x6c>
  101ade:	eb 68                	jmp    101b48 <trap_dispatch+0xae>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ae0:	e8 93 fa ff ff       	call   101578 <cons_getc>
  101ae5:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ae8:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101aec:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101af0:	89 54 24 08          	mov    %edx,0x8(%esp)
  101af4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af8:	c7 04 24 94 37 10 00 	movl   $0x103794,(%esp)
  101aff:	e8 1c e8 ff ff       	call   100320 <cprintf>
        break;
  101b04:	eb 7b                	jmp    101b81 <trap_dispatch+0xe7>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101b06:	e8 6d fa ff ff       	call   101578 <cons_getc>
  101b0b:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101b0e:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101b12:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101b16:	89 54 24 08          	mov    %edx,0x8(%esp)
  101b1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b1e:	c7 04 24 a6 37 10 00 	movl   $0x1037a6,(%esp)
  101b25:	e8 f6 e7 ff ff       	call   100320 <cprintf>
        break;
  101b2a:	eb 55                	jmp    101b81 <trap_dispatch+0xe7>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101b2c:	c7 44 24 08 b5 37 10 	movl   $0x1037b5,0x8(%esp)
  101b33:	00 
  101b34:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  101b3b:	00 
  101b3c:	c7 04 24 c5 37 10 00 	movl   $0x1037c5,(%esp)
  101b43:	e8 a5 f0 ff ff       	call   100bed <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101b48:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b4f:	83 e0 03             	and    $0x3,%eax
  101b52:	85 c0                	test   %eax,%eax
  101b54:	75 2b                	jne    101b81 <trap_dispatch+0xe7>
            print_trapframe(tf);
  101b56:	8b 45 08             	mov    0x8(%ebp),%eax
  101b59:	89 04 24             	mov    %eax,(%esp)
  101b5c:	e8 cc fc ff ff       	call   10182d <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101b61:	c7 44 24 08 d6 37 10 	movl   $0x1037d6,0x8(%esp)
  101b68:	00 
  101b69:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  101b70:	00 
  101b71:	c7 04 24 c5 37 10 00 	movl   $0x1037c5,(%esp)
  101b78:	e8 70 f0 ff ff       	call   100bed <__panic>
        break;
  101b7d:	90                   	nop
  101b7e:	eb 01                	jmp    101b81 <trap_dispatch+0xe7>
        break;
  101b80:	90                   	nop
        }
    }
}
  101b81:	90                   	nop
  101b82:	89 ec                	mov    %ebp,%esp
  101b84:	5d                   	pop    %ebp
  101b85:	c3                   	ret    

00101b86 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101b86:	55                   	push   %ebp
  101b87:	89 e5                	mov    %esp,%ebp
  101b89:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8f:	89 04 24             	mov    %eax,(%esp)
  101b92:	e8 03 ff ff ff       	call   101a9a <trap_dispatch>
}
  101b97:	90                   	nop
  101b98:	89 ec                	mov    %ebp,%esp
  101b9a:	5d                   	pop    %ebp
  101b9b:	c3                   	ret    

00101b9c <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101b9c:	1e                   	push   %ds
    pushl %es
  101b9d:	06                   	push   %es
    pushl %fs
  101b9e:	0f a0                	push   %fs
    pushl %gs
  101ba0:	0f a8                	push   %gs
    pushal
  101ba2:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101ba3:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101ba8:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101baa:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101bac:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101bad:	e8 d4 ff ff ff       	call   101b86 <trap>

    # pop the pushed stack pointer
    popl %esp
  101bb2:	5c                   	pop    %esp

00101bb3 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101bb3:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101bb4:	0f a9                	pop    %gs
    popl %fs
  101bb6:	0f a1                	pop    %fs
    popl %es
  101bb8:	07                   	pop    %es
    popl %ds
  101bb9:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101bba:	83 c4 08             	add    $0x8,%esp
    iret
  101bbd:	cf                   	iret   

00101bbe <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101bbe:	6a 00                	push   $0x0
  pushl $0
  101bc0:	6a 00                	push   $0x0
  jmp __alltraps
  101bc2:	e9 d5 ff ff ff       	jmp    101b9c <__alltraps>

00101bc7 <vector1>:
.globl vector1
vector1:
  pushl $0
  101bc7:	6a 00                	push   $0x0
  pushl $1
  101bc9:	6a 01                	push   $0x1
  jmp __alltraps
  101bcb:	e9 cc ff ff ff       	jmp    101b9c <__alltraps>

00101bd0 <vector2>:
.globl vector2
vector2:
  pushl $0
  101bd0:	6a 00                	push   $0x0
  pushl $2
  101bd2:	6a 02                	push   $0x2
  jmp __alltraps
  101bd4:	e9 c3 ff ff ff       	jmp    101b9c <__alltraps>

00101bd9 <vector3>:
.globl vector3
vector3:
  pushl $0
  101bd9:	6a 00                	push   $0x0
  pushl $3
  101bdb:	6a 03                	push   $0x3
  jmp __alltraps
  101bdd:	e9 ba ff ff ff       	jmp    101b9c <__alltraps>

00101be2 <vector4>:
.globl vector4
vector4:
  pushl $0
  101be2:	6a 00                	push   $0x0
  pushl $4
  101be4:	6a 04                	push   $0x4
  jmp __alltraps
  101be6:	e9 b1 ff ff ff       	jmp    101b9c <__alltraps>

00101beb <vector5>:
.globl vector5
vector5:
  pushl $0
  101beb:	6a 00                	push   $0x0
  pushl $5
  101bed:	6a 05                	push   $0x5
  jmp __alltraps
  101bef:	e9 a8 ff ff ff       	jmp    101b9c <__alltraps>

00101bf4 <vector6>:
.globl vector6
vector6:
  pushl $0
  101bf4:	6a 00                	push   $0x0
  pushl $6
  101bf6:	6a 06                	push   $0x6
  jmp __alltraps
  101bf8:	e9 9f ff ff ff       	jmp    101b9c <__alltraps>

00101bfd <vector7>:
.globl vector7
vector7:
  pushl $0
  101bfd:	6a 00                	push   $0x0
  pushl $7
  101bff:	6a 07                	push   $0x7
  jmp __alltraps
  101c01:	e9 96 ff ff ff       	jmp    101b9c <__alltraps>

00101c06 <vector8>:
.globl vector8
vector8:
  pushl $8
  101c06:	6a 08                	push   $0x8
  jmp __alltraps
  101c08:	e9 8f ff ff ff       	jmp    101b9c <__alltraps>

00101c0d <vector9>:
.globl vector9
vector9:
  pushl $0
  101c0d:	6a 00                	push   $0x0
  pushl $9
  101c0f:	6a 09                	push   $0x9
  jmp __alltraps
  101c11:	e9 86 ff ff ff       	jmp    101b9c <__alltraps>

00101c16 <vector10>:
.globl vector10
vector10:
  pushl $10
  101c16:	6a 0a                	push   $0xa
  jmp __alltraps
  101c18:	e9 7f ff ff ff       	jmp    101b9c <__alltraps>

00101c1d <vector11>:
.globl vector11
vector11:
  pushl $11
  101c1d:	6a 0b                	push   $0xb
  jmp __alltraps
  101c1f:	e9 78 ff ff ff       	jmp    101b9c <__alltraps>

00101c24 <vector12>:
.globl vector12
vector12:
  pushl $12
  101c24:	6a 0c                	push   $0xc
  jmp __alltraps
  101c26:	e9 71 ff ff ff       	jmp    101b9c <__alltraps>

00101c2b <vector13>:
.globl vector13
vector13:
  pushl $13
  101c2b:	6a 0d                	push   $0xd
  jmp __alltraps
  101c2d:	e9 6a ff ff ff       	jmp    101b9c <__alltraps>

00101c32 <vector14>:
.globl vector14
vector14:
  pushl $14
  101c32:	6a 0e                	push   $0xe
  jmp __alltraps
  101c34:	e9 63 ff ff ff       	jmp    101b9c <__alltraps>

00101c39 <vector15>:
.globl vector15
vector15:
  pushl $0
  101c39:	6a 00                	push   $0x0
  pushl $15
  101c3b:	6a 0f                	push   $0xf
  jmp __alltraps
  101c3d:	e9 5a ff ff ff       	jmp    101b9c <__alltraps>

00101c42 <vector16>:
.globl vector16
vector16:
  pushl $0
  101c42:	6a 00                	push   $0x0
  pushl $16
  101c44:	6a 10                	push   $0x10
  jmp __alltraps
  101c46:	e9 51 ff ff ff       	jmp    101b9c <__alltraps>

00101c4b <vector17>:
.globl vector17
vector17:
  pushl $17
  101c4b:	6a 11                	push   $0x11
  jmp __alltraps
  101c4d:	e9 4a ff ff ff       	jmp    101b9c <__alltraps>

00101c52 <vector18>:
.globl vector18
vector18:
  pushl $0
  101c52:	6a 00                	push   $0x0
  pushl $18
  101c54:	6a 12                	push   $0x12
  jmp __alltraps
  101c56:	e9 41 ff ff ff       	jmp    101b9c <__alltraps>

00101c5b <vector19>:
.globl vector19
vector19:
  pushl $0
  101c5b:	6a 00                	push   $0x0
  pushl $19
  101c5d:	6a 13                	push   $0x13
  jmp __alltraps
  101c5f:	e9 38 ff ff ff       	jmp    101b9c <__alltraps>

00101c64 <vector20>:
.globl vector20
vector20:
  pushl $0
  101c64:	6a 00                	push   $0x0
  pushl $20
  101c66:	6a 14                	push   $0x14
  jmp __alltraps
  101c68:	e9 2f ff ff ff       	jmp    101b9c <__alltraps>

00101c6d <vector21>:
.globl vector21
vector21:
  pushl $0
  101c6d:	6a 00                	push   $0x0
  pushl $21
  101c6f:	6a 15                	push   $0x15
  jmp __alltraps
  101c71:	e9 26 ff ff ff       	jmp    101b9c <__alltraps>

00101c76 <vector22>:
.globl vector22
vector22:
  pushl $0
  101c76:	6a 00                	push   $0x0
  pushl $22
  101c78:	6a 16                	push   $0x16
  jmp __alltraps
  101c7a:	e9 1d ff ff ff       	jmp    101b9c <__alltraps>

00101c7f <vector23>:
.globl vector23
vector23:
  pushl $0
  101c7f:	6a 00                	push   $0x0
  pushl $23
  101c81:	6a 17                	push   $0x17
  jmp __alltraps
  101c83:	e9 14 ff ff ff       	jmp    101b9c <__alltraps>

00101c88 <vector24>:
.globl vector24
vector24:
  pushl $0
  101c88:	6a 00                	push   $0x0
  pushl $24
  101c8a:	6a 18                	push   $0x18
  jmp __alltraps
  101c8c:	e9 0b ff ff ff       	jmp    101b9c <__alltraps>

00101c91 <vector25>:
.globl vector25
vector25:
  pushl $0
  101c91:	6a 00                	push   $0x0
  pushl $25
  101c93:	6a 19                	push   $0x19
  jmp __alltraps
  101c95:	e9 02 ff ff ff       	jmp    101b9c <__alltraps>

00101c9a <vector26>:
.globl vector26
vector26:
  pushl $0
  101c9a:	6a 00                	push   $0x0
  pushl $26
  101c9c:	6a 1a                	push   $0x1a
  jmp __alltraps
  101c9e:	e9 f9 fe ff ff       	jmp    101b9c <__alltraps>

00101ca3 <vector27>:
.globl vector27
vector27:
  pushl $0
  101ca3:	6a 00                	push   $0x0
  pushl $27
  101ca5:	6a 1b                	push   $0x1b
  jmp __alltraps
  101ca7:	e9 f0 fe ff ff       	jmp    101b9c <__alltraps>

00101cac <vector28>:
.globl vector28
vector28:
  pushl $0
  101cac:	6a 00                	push   $0x0
  pushl $28
  101cae:	6a 1c                	push   $0x1c
  jmp __alltraps
  101cb0:	e9 e7 fe ff ff       	jmp    101b9c <__alltraps>

00101cb5 <vector29>:
.globl vector29
vector29:
  pushl $0
  101cb5:	6a 00                	push   $0x0
  pushl $29
  101cb7:	6a 1d                	push   $0x1d
  jmp __alltraps
  101cb9:	e9 de fe ff ff       	jmp    101b9c <__alltraps>

00101cbe <vector30>:
.globl vector30
vector30:
  pushl $0
  101cbe:	6a 00                	push   $0x0
  pushl $30
  101cc0:	6a 1e                	push   $0x1e
  jmp __alltraps
  101cc2:	e9 d5 fe ff ff       	jmp    101b9c <__alltraps>

00101cc7 <vector31>:
.globl vector31
vector31:
  pushl $0
  101cc7:	6a 00                	push   $0x0
  pushl $31
  101cc9:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ccb:	e9 cc fe ff ff       	jmp    101b9c <__alltraps>

00101cd0 <vector32>:
.globl vector32
vector32:
  pushl $0
  101cd0:	6a 00                	push   $0x0
  pushl $32
  101cd2:	6a 20                	push   $0x20
  jmp __alltraps
  101cd4:	e9 c3 fe ff ff       	jmp    101b9c <__alltraps>

00101cd9 <vector33>:
.globl vector33
vector33:
  pushl $0
  101cd9:	6a 00                	push   $0x0
  pushl $33
  101cdb:	6a 21                	push   $0x21
  jmp __alltraps
  101cdd:	e9 ba fe ff ff       	jmp    101b9c <__alltraps>

00101ce2 <vector34>:
.globl vector34
vector34:
  pushl $0
  101ce2:	6a 00                	push   $0x0
  pushl $34
  101ce4:	6a 22                	push   $0x22
  jmp __alltraps
  101ce6:	e9 b1 fe ff ff       	jmp    101b9c <__alltraps>

00101ceb <vector35>:
.globl vector35
vector35:
  pushl $0
  101ceb:	6a 00                	push   $0x0
  pushl $35
  101ced:	6a 23                	push   $0x23
  jmp __alltraps
  101cef:	e9 a8 fe ff ff       	jmp    101b9c <__alltraps>

00101cf4 <vector36>:
.globl vector36
vector36:
  pushl $0
  101cf4:	6a 00                	push   $0x0
  pushl $36
  101cf6:	6a 24                	push   $0x24
  jmp __alltraps
  101cf8:	e9 9f fe ff ff       	jmp    101b9c <__alltraps>

00101cfd <vector37>:
.globl vector37
vector37:
  pushl $0
  101cfd:	6a 00                	push   $0x0
  pushl $37
  101cff:	6a 25                	push   $0x25
  jmp __alltraps
  101d01:	e9 96 fe ff ff       	jmp    101b9c <__alltraps>

00101d06 <vector38>:
.globl vector38
vector38:
  pushl $0
  101d06:	6a 00                	push   $0x0
  pushl $38
  101d08:	6a 26                	push   $0x26
  jmp __alltraps
  101d0a:	e9 8d fe ff ff       	jmp    101b9c <__alltraps>

00101d0f <vector39>:
.globl vector39
vector39:
  pushl $0
  101d0f:	6a 00                	push   $0x0
  pushl $39
  101d11:	6a 27                	push   $0x27
  jmp __alltraps
  101d13:	e9 84 fe ff ff       	jmp    101b9c <__alltraps>

00101d18 <vector40>:
.globl vector40
vector40:
  pushl $0
  101d18:	6a 00                	push   $0x0
  pushl $40
  101d1a:	6a 28                	push   $0x28
  jmp __alltraps
  101d1c:	e9 7b fe ff ff       	jmp    101b9c <__alltraps>

00101d21 <vector41>:
.globl vector41
vector41:
  pushl $0
  101d21:	6a 00                	push   $0x0
  pushl $41
  101d23:	6a 29                	push   $0x29
  jmp __alltraps
  101d25:	e9 72 fe ff ff       	jmp    101b9c <__alltraps>

00101d2a <vector42>:
.globl vector42
vector42:
  pushl $0
  101d2a:	6a 00                	push   $0x0
  pushl $42
  101d2c:	6a 2a                	push   $0x2a
  jmp __alltraps
  101d2e:	e9 69 fe ff ff       	jmp    101b9c <__alltraps>

00101d33 <vector43>:
.globl vector43
vector43:
  pushl $0
  101d33:	6a 00                	push   $0x0
  pushl $43
  101d35:	6a 2b                	push   $0x2b
  jmp __alltraps
  101d37:	e9 60 fe ff ff       	jmp    101b9c <__alltraps>

00101d3c <vector44>:
.globl vector44
vector44:
  pushl $0
  101d3c:	6a 00                	push   $0x0
  pushl $44
  101d3e:	6a 2c                	push   $0x2c
  jmp __alltraps
  101d40:	e9 57 fe ff ff       	jmp    101b9c <__alltraps>

00101d45 <vector45>:
.globl vector45
vector45:
  pushl $0
  101d45:	6a 00                	push   $0x0
  pushl $45
  101d47:	6a 2d                	push   $0x2d
  jmp __alltraps
  101d49:	e9 4e fe ff ff       	jmp    101b9c <__alltraps>

00101d4e <vector46>:
.globl vector46
vector46:
  pushl $0
  101d4e:	6a 00                	push   $0x0
  pushl $46
  101d50:	6a 2e                	push   $0x2e
  jmp __alltraps
  101d52:	e9 45 fe ff ff       	jmp    101b9c <__alltraps>

00101d57 <vector47>:
.globl vector47
vector47:
  pushl $0
  101d57:	6a 00                	push   $0x0
  pushl $47
  101d59:	6a 2f                	push   $0x2f
  jmp __alltraps
  101d5b:	e9 3c fe ff ff       	jmp    101b9c <__alltraps>

00101d60 <vector48>:
.globl vector48
vector48:
  pushl $0
  101d60:	6a 00                	push   $0x0
  pushl $48
  101d62:	6a 30                	push   $0x30
  jmp __alltraps
  101d64:	e9 33 fe ff ff       	jmp    101b9c <__alltraps>

00101d69 <vector49>:
.globl vector49
vector49:
  pushl $0
  101d69:	6a 00                	push   $0x0
  pushl $49
  101d6b:	6a 31                	push   $0x31
  jmp __alltraps
  101d6d:	e9 2a fe ff ff       	jmp    101b9c <__alltraps>

00101d72 <vector50>:
.globl vector50
vector50:
  pushl $0
  101d72:	6a 00                	push   $0x0
  pushl $50
  101d74:	6a 32                	push   $0x32
  jmp __alltraps
  101d76:	e9 21 fe ff ff       	jmp    101b9c <__alltraps>

00101d7b <vector51>:
.globl vector51
vector51:
  pushl $0
  101d7b:	6a 00                	push   $0x0
  pushl $51
  101d7d:	6a 33                	push   $0x33
  jmp __alltraps
  101d7f:	e9 18 fe ff ff       	jmp    101b9c <__alltraps>

00101d84 <vector52>:
.globl vector52
vector52:
  pushl $0
  101d84:	6a 00                	push   $0x0
  pushl $52
  101d86:	6a 34                	push   $0x34
  jmp __alltraps
  101d88:	e9 0f fe ff ff       	jmp    101b9c <__alltraps>

00101d8d <vector53>:
.globl vector53
vector53:
  pushl $0
  101d8d:	6a 00                	push   $0x0
  pushl $53
  101d8f:	6a 35                	push   $0x35
  jmp __alltraps
  101d91:	e9 06 fe ff ff       	jmp    101b9c <__alltraps>

00101d96 <vector54>:
.globl vector54
vector54:
  pushl $0
  101d96:	6a 00                	push   $0x0
  pushl $54
  101d98:	6a 36                	push   $0x36
  jmp __alltraps
  101d9a:	e9 fd fd ff ff       	jmp    101b9c <__alltraps>

00101d9f <vector55>:
.globl vector55
vector55:
  pushl $0
  101d9f:	6a 00                	push   $0x0
  pushl $55
  101da1:	6a 37                	push   $0x37
  jmp __alltraps
  101da3:	e9 f4 fd ff ff       	jmp    101b9c <__alltraps>

00101da8 <vector56>:
.globl vector56
vector56:
  pushl $0
  101da8:	6a 00                	push   $0x0
  pushl $56
  101daa:	6a 38                	push   $0x38
  jmp __alltraps
  101dac:	e9 eb fd ff ff       	jmp    101b9c <__alltraps>

00101db1 <vector57>:
.globl vector57
vector57:
  pushl $0
  101db1:	6a 00                	push   $0x0
  pushl $57
  101db3:	6a 39                	push   $0x39
  jmp __alltraps
  101db5:	e9 e2 fd ff ff       	jmp    101b9c <__alltraps>

00101dba <vector58>:
.globl vector58
vector58:
  pushl $0
  101dba:	6a 00                	push   $0x0
  pushl $58
  101dbc:	6a 3a                	push   $0x3a
  jmp __alltraps
  101dbe:	e9 d9 fd ff ff       	jmp    101b9c <__alltraps>

00101dc3 <vector59>:
.globl vector59
vector59:
  pushl $0
  101dc3:	6a 00                	push   $0x0
  pushl $59
  101dc5:	6a 3b                	push   $0x3b
  jmp __alltraps
  101dc7:	e9 d0 fd ff ff       	jmp    101b9c <__alltraps>

00101dcc <vector60>:
.globl vector60
vector60:
  pushl $0
  101dcc:	6a 00                	push   $0x0
  pushl $60
  101dce:	6a 3c                	push   $0x3c
  jmp __alltraps
  101dd0:	e9 c7 fd ff ff       	jmp    101b9c <__alltraps>

00101dd5 <vector61>:
.globl vector61
vector61:
  pushl $0
  101dd5:	6a 00                	push   $0x0
  pushl $61
  101dd7:	6a 3d                	push   $0x3d
  jmp __alltraps
  101dd9:	e9 be fd ff ff       	jmp    101b9c <__alltraps>

00101dde <vector62>:
.globl vector62
vector62:
  pushl $0
  101dde:	6a 00                	push   $0x0
  pushl $62
  101de0:	6a 3e                	push   $0x3e
  jmp __alltraps
  101de2:	e9 b5 fd ff ff       	jmp    101b9c <__alltraps>

00101de7 <vector63>:
.globl vector63
vector63:
  pushl $0
  101de7:	6a 00                	push   $0x0
  pushl $63
  101de9:	6a 3f                	push   $0x3f
  jmp __alltraps
  101deb:	e9 ac fd ff ff       	jmp    101b9c <__alltraps>

00101df0 <vector64>:
.globl vector64
vector64:
  pushl $0
  101df0:	6a 00                	push   $0x0
  pushl $64
  101df2:	6a 40                	push   $0x40
  jmp __alltraps
  101df4:	e9 a3 fd ff ff       	jmp    101b9c <__alltraps>

00101df9 <vector65>:
.globl vector65
vector65:
  pushl $0
  101df9:	6a 00                	push   $0x0
  pushl $65
  101dfb:	6a 41                	push   $0x41
  jmp __alltraps
  101dfd:	e9 9a fd ff ff       	jmp    101b9c <__alltraps>

00101e02 <vector66>:
.globl vector66
vector66:
  pushl $0
  101e02:	6a 00                	push   $0x0
  pushl $66
  101e04:	6a 42                	push   $0x42
  jmp __alltraps
  101e06:	e9 91 fd ff ff       	jmp    101b9c <__alltraps>

00101e0b <vector67>:
.globl vector67
vector67:
  pushl $0
  101e0b:	6a 00                	push   $0x0
  pushl $67
  101e0d:	6a 43                	push   $0x43
  jmp __alltraps
  101e0f:	e9 88 fd ff ff       	jmp    101b9c <__alltraps>

00101e14 <vector68>:
.globl vector68
vector68:
  pushl $0
  101e14:	6a 00                	push   $0x0
  pushl $68
  101e16:	6a 44                	push   $0x44
  jmp __alltraps
  101e18:	e9 7f fd ff ff       	jmp    101b9c <__alltraps>

00101e1d <vector69>:
.globl vector69
vector69:
  pushl $0
  101e1d:	6a 00                	push   $0x0
  pushl $69
  101e1f:	6a 45                	push   $0x45
  jmp __alltraps
  101e21:	e9 76 fd ff ff       	jmp    101b9c <__alltraps>

00101e26 <vector70>:
.globl vector70
vector70:
  pushl $0
  101e26:	6a 00                	push   $0x0
  pushl $70
  101e28:	6a 46                	push   $0x46
  jmp __alltraps
  101e2a:	e9 6d fd ff ff       	jmp    101b9c <__alltraps>

00101e2f <vector71>:
.globl vector71
vector71:
  pushl $0
  101e2f:	6a 00                	push   $0x0
  pushl $71
  101e31:	6a 47                	push   $0x47
  jmp __alltraps
  101e33:	e9 64 fd ff ff       	jmp    101b9c <__alltraps>

00101e38 <vector72>:
.globl vector72
vector72:
  pushl $0
  101e38:	6a 00                	push   $0x0
  pushl $72
  101e3a:	6a 48                	push   $0x48
  jmp __alltraps
  101e3c:	e9 5b fd ff ff       	jmp    101b9c <__alltraps>

00101e41 <vector73>:
.globl vector73
vector73:
  pushl $0
  101e41:	6a 00                	push   $0x0
  pushl $73
  101e43:	6a 49                	push   $0x49
  jmp __alltraps
  101e45:	e9 52 fd ff ff       	jmp    101b9c <__alltraps>

00101e4a <vector74>:
.globl vector74
vector74:
  pushl $0
  101e4a:	6a 00                	push   $0x0
  pushl $74
  101e4c:	6a 4a                	push   $0x4a
  jmp __alltraps
  101e4e:	e9 49 fd ff ff       	jmp    101b9c <__alltraps>

00101e53 <vector75>:
.globl vector75
vector75:
  pushl $0
  101e53:	6a 00                	push   $0x0
  pushl $75
  101e55:	6a 4b                	push   $0x4b
  jmp __alltraps
  101e57:	e9 40 fd ff ff       	jmp    101b9c <__alltraps>

00101e5c <vector76>:
.globl vector76
vector76:
  pushl $0
  101e5c:	6a 00                	push   $0x0
  pushl $76
  101e5e:	6a 4c                	push   $0x4c
  jmp __alltraps
  101e60:	e9 37 fd ff ff       	jmp    101b9c <__alltraps>

00101e65 <vector77>:
.globl vector77
vector77:
  pushl $0
  101e65:	6a 00                	push   $0x0
  pushl $77
  101e67:	6a 4d                	push   $0x4d
  jmp __alltraps
  101e69:	e9 2e fd ff ff       	jmp    101b9c <__alltraps>

00101e6e <vector78>:
.globl vector78
vector78:
  pushl $0
  101e6e:	6a 00                	push   $0x0
  pushl $78
  101e70:	6a 4e                	push   $0x4e
  jmp __alltraps
  101e72:	e9 25 fd ff ff       	jmp    101b9c <__alltraps>

00101e77 <vector79>:
.globl vector79
vector79:
  pushl $0
  101e77:	6a 00                	push   $0x0
  pushl $79
  101e79:	6a 4f                	push   $0x4f
  jmp __alltraps
  101e7b:	e9 1c fd ff ff       	jmp    101b9c <__alltraps>

00101e80 <vector80>:
.globl vector80
vector80:
  pushl $0
  101e80:	6a 00                	push   $0x0
  pushl $80
  101e82:	6a 50                	push   $0x50
  jmp __alltraps
  101e84:	e9 13 fd ff ff       	jmp    101b9c <__alltraps>

00101e89 <vector81>:
.globl vector81
vector81:
  pushl $0
  101e89:	6a 00                	push   $0x0
  pushl $81
  101e8b:	6a 51                	push   $0x51
  jmp __alltraps
  101e8d:	e9 0a fd ff ff       	jmp    101b9c <__alltraps>

00101e92 <vector82>:
.globl vector82
vector82:
  pushl $0
  101e92:	6a 00                	push   $0x0
  pushl $82
  101e94:	6a 52                	push   $0x52
  jmp __alltraps
  101e96:	e9 01 fd ff ff       	jmp    101b9c <__alltraps>

00101e9b <vector83>:
.globl vector83
vector83:
  pushl $0
  101e9b:	6a 00                	push   $0x0
  pushl $83
  101e9d:	6a 53                	push   $0x53
  jmp __alltraps
  101e9f:	e9 f8 fc ff ff       	jmp    101b9c <__alltraps>

00101ea4 <vector84>:
.globl vector84
vector84:
  pushl $0
  101ea4:	6a 00                	push   $0x0
  pushl $84
  101ea6:	6a 54                	push   $0x54
  jmp __alltraps
  101ea8:	e9 ef fc ff ff       	jmp    101b9c <__alltraps>

00101ead <vector85>:
.globl vector85
vector85:
  pushl $0
  101ead:	6a 00                	push   $0x0
  pushl $85
  101eaf:	6a 55                	push   $0x55
  jmp __alltraps
  101eb1:	e9 e6 fc ff ff       	jmp    101b9c <__alltraps>

00101eb6 <vector86>:
.globl vector86
vector86:
  pushl $0
  101eb6:	6a 00                	push   $0x0
  pushl $86
  101eb8:	6a 56                	push   $0x56
  jmp __alltraps
  101eba:	e9 dd fc ff ff       	jmp    101b9c <__alltraps>

00101ebf <vector87>:
.globl vector87
vector87:
  pushl $0
  101ebf:	6a 00                	push   $0x0
  pushl $87
  101ec1:	6a 57                	push   $0x57
  jmp __alltraps
  101ec3:	e9 d4 fc ff ff       	jmp    101b9c <__alltraps>

00101ec8 <vector88>:
.globl vector88
vector88:
  pushl $0
  101ec8:	6a 00                	push   $0x0
  pushl $88
  101eca:	6a 58                	push   $0x58
  jmp __alltraps
  101ecc:	e9 cb fc ff ff       	jmp    101b9c <__alltraps>

00101ed1 <vector89>:
.globl vector89
vector89:
  pushl $0
  101ed1:	6a 00                	push   $0x0
  pushl $89
  101ed3:	6a 59                	push   $0x59
  jmp __alltraps
  101ed5:	e9 c2 fc ff ff       	jmp    101b9c <__alltraps>

00101eda <vector90>:
.globl vector90
vector90:
  pushl $0
  101eda:	6a 00                	push   $0x0
  pushl $90
  101edc:	6a 5a                	push   $0x5a
  jmp __alltraps
  101ede:	e9 b9 fc ff ff       	jmp    101b9c <__alltraps>

00101ee3 <vector91>:
.globl vector91
vector91:
  pushl $0
  101ee3:	6a 00                	push   $0x0
  pushl $91
  101ee5:	6a 5b                	push   $0x5b
  jmp __alltraps
  101ee7:	e9 b0 fc ff ff       	jmp    101b9c <__alltraps>

00101eec <vector92>:
.globl vector92
vector92:
  pushl $0
  101eec:	6a 00                	push   $0x0
  pushl $92
  101eee:	6a 5c                	push   $0x5c
  jmp __alltraps
  101ef0:	e9 a7 fc ff ff       	jmp    101b9c <__alltraps>

00101ef5 <vector93>:
.globl vector93
vector93:
  pushl $0
  101ef5:	6a 00                	push   $0x0
  pushl $93
  101ef7:	6a 5d                	push   $0x5d
  jmp __alltraps
  101ef9:	e9 9e fc ff ff       	jmp    101b9c <__alltraps>

00101efe <vector94>:
.globl vector94
vector94:
  pushl $0
  101efe:	6a 00                	push   $0x0
  pushl $94
  101f00:	6a 5e                	push   $0x5e
  jmp __alltraps
  101f02:	e9 95 fc ff ff       	jmp    101b9c <__alltraps>

00101f07 <vector95>:
.globl vector95
vector95:
  pushl $0
  101f07:	6a 00                	push   $0x0
  pushl $95
  101f09:	6a 5f                	push   $0x5f
  jmp __alltraps
  101f0b:	e9 8c fc ff ff       	jmp    101b9c <__alltraps>

00101f10 <vector96>:
.globl vector96
vector96:
  pushl $0
  101f10:	6a 00                	push   $0x0
  pushl $96
  101f12:	6a 60                	push   $0x60
  jmp __alltraps
  101f14:	e9 83 fc ff ff       	jmp    101b9c <__alltraps>

00101f19 <vector97>:
.globl vector97
vector97:
  pushl $0
  101f19:	6a 00                	push   $0x0
  pushl $97
  101f1b:	6a 61                	push   $0x61
  jmp __alltraps
  101f1d:	e9 7a fc ff ff       	jmp    101b9c <__alltraps>

00101f22 <vector98>:
.globl vector98
vector98:
  pushl $0
  101f22:	6a 00                	push   $0x0
  pushl $98
  101f24:	6a 62                	push   $0x62
  jmp __alltraps
  101f26:	e9 71 fc ff ff       	jmp    101b9c <__alltraps>

00101f2b <vector99>:
.globl vector99
vector99:
  pushl $0
  101f2b:	6a 00                	push   $0x0
  pushl $99
  101f2d:	6a 63                	push   $0x63
  jmp __alltraps
  101f2f:	e9 68 fc ff ff       	jmp    101b9c <__alltraps>

00101f34 <vector100>:
.globl vector100
vector100:
  pushl $0
  101f34:	6a 00                	push   $0x0
  pushl $100
  101f36:	6a 64                	push   $0x64
  jmp __alltraps
  101f38:	e9 5f fc ff ff       	jmp    101b9c <__alltraps>

00101f3d <vector101>:
.globl vector101
vector101:
  pushl $0
  101f3d:	6a 00                	push   $0x0
  pushl $101
  101f3f:	6a 65                	push   $0x65
  jmp __alltraps
  101f41:	e9 56 fc ff ff       	jmp    101b9c <__alltraps>

00101f46 <vector102>:
.globl vector102
vector102:
  pushl $0
  101f46:	6a 00                	push   $0x0
  pushl $102
  101f48:	6a 66                	push   $0x66
  jmp __alltraps
  101f4a:	e9 4d fc ff ff       	jmp    101b9c <__alltraps>

00101f4f <vector103>:
.globl vector103
vector103:
  pushl $0
  101f4f:	6a 00                	push   $0x0
  pushl $103
  101f51:	6a 67                	push   $0x67
  jmp __alltraps
  101f53:	e9 44 fc ff ff       	jmp    101b9c <__alltraps>

00101f58 <vector104>:
.globl vector104
vector104:
  pushl $0
  101f58:	6a 00                	push   $0x0
  pushl $104
  101f5a:	6a 68                	push   $0x68
  jmp __alltraps
  101f5c:	e9 3b fc ff ff       	jmp    101b9c <__alltraps>

00101f61 <vector105>:
.globl vector105
vector105:
  pushl $0
  101f61:	6a 00                	push   $0x0
  pushl $105
  101f63:	6a 69                	push   $0x69
  jmp __alltraps
  101f65:	e9 32 fc ff ff       	jmp    101b9c <__alltraps>

00101f6a <vector106>:
.globl vector106
vector106:
  pushl $0
  101f6a:	6a 00                	push   $0x0
  pushl $106
  101f6c:	6a 6a                	push   $0x6a
  jmp __alltraps
  101f6e:	e9 29 fc ff ff       	jmp    101b9c <__alltraps>

00101f73 <vector107>:
.globl vector107
vector107:
  pushl $0
  101f73:	6a 00                	push   $0x0
  pushl $107
  101f75:	6a 6b                	push   $0x6b
  jmp __alltraps
  101f77:	e9 20 fc ff ff       	jmp    101b9c <__alltraps>

00101f7c <vector108>:
.globl vector108
vector108:
  pushl $0
  101f7c:	6a 00                	push   $0x0
  pushl $108
  101f7e:	6a 6c                	push   $0x6c
  jmp __alltraps
  101f80:	e9 17 fc ff ff       	jmp    101b9c <__alltraps>

00101f85 <vector109>:
.globl vector109
vector109:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $109
  101f87:	6a 6d                	push   $0x6d
  jmp __alltraps
  101f89:	e9 0e fc ff ff       	jmp    101b9c <__alltraps>

00101f8e <vector110>:
.globl vector110
vector110:
  pushl $0
  101f8e:	6a 00                	push   $0x0
  pushl $110
  101f90:	6a 6e                	push   $0x6e
  jmp __alltraps
  101f92:	e9 05 fc ff ff       	jmp    101b9c <__alltraps>

00101f97 <vector111>:
.globl vector111
vector111:
  pushl $0
  101f97:	6a 00                	push   $0x0
  pushl $111
  101f99:	6a 6f                	push   $0x6f
  jmp __alltraps
  101f9b:	e9 fc fb ff ff       	jmp    101b9c <__alltraps>

00101fa0 <vector112>:
.globl vector112
vector112:
  pushl $0
  101fa0:	6a 00                	push   $0x0
  pushl $112
  101fa2:	6a 70                	push   $0x70
  jmp __alltraps
  101fa4:	e9 f3 fb ff ff       	jmp    101b9c <__alltraps>

00101fa9 <vector113>:
.globl vector113
vector113:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $113
  101fab:	6a 71                	push   $0x71
  jmp __alltraps
  101fad:	e9 ea fb ff ff       	jmp    101b9c <__alltraps>

00101fb2 <vector114>:
.globl vector114
vector114:
  pushl $0
  101fb2:	6a 00                	push   $0x0
  pushl $114
  101fb4:	6a 72                	push   $0x72
  jmp __alltraps
  101fb6:	e9 e1 fb ff ff       	jmp    101b9c <__alltraps>

00101fbb <vector115>:
.globl vector115
vector115:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $115
  101fbd:	6a 73                	push   $0x73
  jmp __alltraps
  101fbf:	e9 d8 fb ff ff       	jmp    101b9c <__alltraps>

00101fc4 <vector116>:
.globl vector116
vector116:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $116
  101fc6:	6a 74                	push   $0x74
  jmp __alltraps
  101fc8:	e9 cf fb ff ff       	jmp    101b9c <__alltraps>

00101fcd <vector117>:
.globl vector117
vector117:
  pushl $0
  101fcd:	6a 00                	push   $0x0
  pushl $117
  101fcf:	6a 75                	push   $0x75
  jmp __alltraps
  101fd1:	e9 c6 fb ff ff       	jmp    101b9c <__alltraps>

00101fd6 <vector118>:
.globl vector118
vector118:
  pushl $0
  101fd6:	6a 00                	push   $0x0
  pushl $118
  101fd8:	6a 76                	push   $0x76
  jmp __alltraps
  101fda:	e9 bd fb ff ff       	jmp    101b9c <__alltraps>

00101fdf <vector119>:
.globl vector119
vector119:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $119
  101fe1:	6a 77                	push   $0x77
  jmp __alltraps
  101fe3:	e9 b4 fb ff ff       	jmp    101b9c <__alltraps>

00101fe8 <vector120>:
.globl vector120
vector120:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $120
  101fea:	6a 78                	push   $0x78
  jmp __alltraps
  101fec:	e9 ab fb ff ff       	jmp    101b9c <__alltraps>

00101ff1 <vector121>:
.globl vector121
vector121:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $121
  101ff3:	6a 79                	push   $0x79
  jmp __alltraps
  101ff5:	e9 a2 fb ff ff       	jmp    101b9c <__alltraps>

00101ffa <vector122>:
.globl vector122
vector122:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $122
  101ffc:	6a 7a                	push   $0x7a
  jmp __alltraps
  101ffe:	e9 99 fb ff ff       	jmp    101b9c <__alltraps>

00102003 <vector123>:
.globl vector123
vector123:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $123
  102005:	6a 7b                	push   $0x7b
  jmp __alltraps
  102007:	e9 90 fb ff ff       	jmp    101b9c <__alltraps>

0010200c <vector124>:
.globl vector124
vector124:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $124
  10200e:	6a 7c                	push   $0x7c
  jmp __alltraps
  102010:	e9 87 fb ff ff       	jmp    101b9c <__alltraps>

00102015 <vector125>:
.globl vector125
vector125:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $125
  102017:	6a 7d                	push   $0x7d
  jmp __alltraps
  102019:	e9 7e fb ff ff       	jmp    101b9c <__alltraps>

0010201e <vector126>:
.globl vector126
vector126:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $126
  102020:	6a 7e                	push   $0x7e
  jmp __alltraps
  102022:	e9 75 fb ff ff       	jmp    101b9c <__alltraps>

00102027 <vector127>:
.globl vector127
vector127:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $127
  102029:	6a 7f                	push   $0x7f
  jmp __alltraps
  10202b:	e9 6c fb ff ff       	jmp    101b9c <__alltraps>

00102030 <vector128>:
.globl vector128
vector128:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $128
  102032:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102037:	e9 60 fb ff ff       	jmp    101b9c <__alltraps>

0010203c <vector129>:
.globl vector129
vector129:
  pushl $0
  10203c:	6a 00                	push   $0x0
  pushl $129
  10203e:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102043:	e9 54 fb ff ff       	jmp    101b9c <__alltraps>

00102048 <vector130>:
.globl vector130
vector130:
  pushl $0
  102048:	6a 00                	push   $0x0
  pushl $130
  10204a:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10204f:	e9 48 fb ff ff       	jmp    101b9c <__alltraps>

00102054 <vector131>:
.globl vector131
vector131:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $131
  102056:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10205b:	e9 3c fb ff ff       	jmp    101b9c <__alltraps>

00102060 <vector132>:
.globl vector132
vector132:
  pushl $0
  102060:	6a 00                	push   $0x0
  pushl $132
  102062:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102067:	e9 30 fb ff ff       	jmp    101b9c <__alltraps>

0010206c <vector133>:
.globl vector133
vector133:
  pushl $0
  10206c:	6a 00                	push   $0x0
  pushl $133
  10206e:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102073:	e9 24 fb ff ff       	jmp    101b9c <__alltraps>

00102078 <vector134>:
.globl vector134
vector134:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $134
  10207a:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10207f:	e9 18 fb ff ff       	jmp    101b9c <__alltraps>

00102084 <vector135>:
.globl vector135
vector135:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $135
  102086:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10208b:	e9 0c fb ff ff       	jmp    101b9c <__alltraps>

00102090 <vector136>:
.globl vector136
vector136:
  pushl $0
  102090:	6a 00                	push   $0x0
  pushl $136
  102092:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102097:	e9 00 fb ff ff       	jmp    101b9c <__alltraps>

0010209c <vector137>:
.globl vector137
vector137:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $137
  10209e:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1020a3:	e9 f4 fa ff ff       	jmp    101b9c <__alltraps>

001020a8 <vector138>:
.globl vector138
vector138:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $138
  1020aa:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1020af:	e9 e8 fa ff ff       	jmp    101b9c <__alltraps>

001020b4 <vector139>:
.globl vector139
vector139:
  pushl $0
  1020b4:	6a 00                	push   $0x0
  pushl $139
  1020b6:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1020bb:	e9 dc fa ff ff       	jmp    101b9c <__alltraps>

001020c0 <vector140>:
.globl vector140
vector140:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $140
  1020c2:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1020c7:	e9 d0 fa ff ff       	jmp    101b9c <__alltraps>

001020cc <vector141>:
.globl vector141
vector141:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $141
  1020ce:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1020d3:	e9 c4 fa ff ff       	jmp    101b9c <__alltraps>

001020d8 <vector142>:
.globl vector142
vector142:
  pushl $0
  1020d8:	6a 00                	push   $0x0
  pushl $142
  1020da:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1020df:	e9 b8 fa ff ff       	jmp    101b9c <__alltraps>

001020e4 <vector143>:
.globl vector143
vector143:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $143
  1020e6:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1020eb:	e9 ac fa ff ff       	jmp    101b9c <__alltraps>

001020f0 <vector144>:
.globl vector144
vector144:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $144
  1020f2:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1020f7:	e9 a0 fa ff ff       	jmp    101b9c <__alltraps>

001020fc <vector145>:
.globl vector145
vector145:
  pushl $0
  1020fc:	6a 00                	push   $0x0
  pushl $145
  1020fe:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102103:	e9 94 fa ff ff       	jmp    101b9c <__alltraps>

00102108 <vector146>:
.globl vector146
vector146:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $146
  10210a:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10210f:	e9 88 fa ff ff       	jmp    101b9c <__alltraps>

00102114 <vector147>:
.globl vector147
vector147:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $147
  102116:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10211b:	e9 7c fa ff ff       	jmp    101b9c <__alltraps>

00102120 <vector148>:
.globl vector148
vector148:
  pushl $0
  102120:	6a 00                	push   $0x0
  pushl $148
  102122:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102127:	e9 70 fa ff ff       	jmp    101b9c <__alltraps>

0010212c <vector149>:
.globl vector149
vector149:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $149
  10212e:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102133:	e9 64 fa ff ff       	jmp    101b9c <__alltraps>

00102138 <vector150>:
.globl vector150
vector150:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $150
  10213a:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10213f:	e9 58 fa ff ff       	jmp    101b9c <__alltraps>

00102144 <vector151>:
.globl vector151
vector151:
  pushl $0
  102144:	6a 00                	push   $0x0
  pushl $151
  102146:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10214b:	e9 4c fa ff ff       	jmp    101b9c <__alltraps>

00102150 <vector152>:
.globl vector152
vector152:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $152
  102152:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102157:	e9 40 fa ff ff       	jmp    101b9c <__alltraps>

0010215c <vector153>:
.globl vector153
vector153:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $153
  10215e:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102163:	e9 34 fa ff ff       	jmp    101b9c <__alltraps>

00102168 <vector154>:
.globl vector154
vector154:
  pushl $0
  102168:	6a 00                	push   $0x0
  pushl $154
  10216a:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10216f:	e9 28 fa ff ff       	jmp    101b9c <__alltraps>

00102174 <vector155>:
.globl vector155
vector155:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $155
  102176:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10217b:	e9 1c fa ff ff       	jmp    101b9c <__alltraps>

00102180 <vector156>:
.globl vector156
vector156:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $156
  102182:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102187:	e9 10 fa ff ff       	jmp    101b9c <__alltraps>

0010218c <vector157>:
.globl vector157
vector157:
  pushl $0
  10218c:	6a 00                	push   $0x0
  pushl $157
  10218e:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102193:	e9 04 fa ff ff       	jmp    101b9c <__alltraps>

00102198 <vector158>:
.globl vector158
vector158:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $158
  10219a:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10219f:	e9 f8 f9 ff ff       	jmp    101b9c <__alltraps>

001021a4 <vector159>:
.globl vector159
vector159:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $159
  1021a6:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1021ab:	e9 ec f9 ff ff       	jmp    101b9c <__alltraps>

001021b0 <vector160>:
.globl vector160
vector160:
  pushl $0
  1021b0:	6a 00                	push   $0x0
  pushl $160
  1021b2:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1021b7:	e9 e0 f9 ff ff       	jmp    101b9c <__alltraps>

001021bc <vector161>:
.globl vector161
vector161:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $161
  1021be:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1021c3:	e9 d4 f9 ff ff       	jmp    101b9c <__alltraps>

001021c8 <vector162>:
.globl vector162
vector162:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $162
  1021ca:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1021cf:	e9 c8 f9 ff ff       	jmp    101b9c <__alltraps>

001021d4 <vector163>:
.globl vector163
vector163:
  pushl $0
  1021d4:	6a 00                	push   $0x0
  pushl $163
  1021d6:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1021db:	e9 bc f9 ff ff       	jmp    101b9c <__alltraps>

001021e0 <vector164>:
.globl vector164
vector164:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $164
  1021e2:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1021e7:	e9 b0 f9 ff ff       	jmp    101b9c <__alltraps>

001021ec <vector165>:
.globl vector165
vector165:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $165
  1021ee:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1021f3:	e9 a4 f9 ff ff       	jmp    101b9c <__alltraps>

001021f8 <vector166>:
.globl vector166
vector166:
  pushl $0
  1021f8:	6a 00                	push   $0x0
  pushl $166
  1021fa:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1021ff:	e9 98 f9 ff ff       	jmp    101b9c <__alltraps>

00102204 <vector167>:
.globl vector167
vector167:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $167
  102206:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10220b:	e9 8c f9 ff ff       	jmp    101b9c <__alltraps>

00102210 <vector168>:
.globl vector168
vector168:
  pushl $0
  102210:	6a 00                	push   $0x0
  pushl $168
  102212:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102217:	e9 80 f9 ff ff       	jmp    101b9c <__alltraps>

0010221c <vector169>:
.globl vector169
vector169:
  pushl $0
  10221c:	6a 00                	push   $0x0
  pushl $169
  10221e:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102223:	e9 74 f9 ff ff       	jmp    101b9c <__alltraps>

00102228 <vector170>:
.globl vector170
vector170:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $170
  10222a:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10222f:	e9 68 f9 ff ff       	jmp    101b9c <__alltraps>

00102234 <vector171>:
.globl vector171
vector171:
  pushl $0
  102234:	6a 00                	push   $0x0
  pushl $171
  102236:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10223b:	e9 5c f9 ff ff       	jmp    101b9c <__alltraps>

00102240 <vector172>:
.globl vector172
vector172:
  pushl $0
  102240:	6a 00                	push   $0x0
  pushl $172
  102242:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102247:	e9 50 f9 ff ff       	jmp    101b9c <__alltraps>

0010224c <vector173>:
.globl vector173
vector173:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $173
  10224e:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102253:	e9 44 f9 ff ff       	jmp    101b9c <__alltraps>

00102258 <vector174>:
.globl vector174
vector174:
  pushl $0
  102258:	6a 00                	push   $0x0
  pushl $174
  10225a:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10225f:	e9 38 f9 ff ff       	jmp    101b9c <__alltraps>

00102264 <vector175>:
.globl vector175
vector175:
  pushl $0
  102264:	6a 00                	push   $0x0
  pushl $175
  102266:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10226b:	e9 2c f9 ff ff       	jmp    101b9c <__alltraps>

00102270 <vector176>:
.globl vector176
vector176:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $176
  102272:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102277:	e9 20 f9 ff ff       	jmp    101b9c <__alltraps>

0010227c <vector177>:
.globl vector177
vector177:
  pushl $0
  10227c:	6a 00                	push   $0x0
  pushl $177
  10227e:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102283:	e9 14 f9 ff ff       	jmp    101b9c <__alltraps>

00102288 <vector178>:
.globl vector178
vector178:
  pushl $0
  102288:	6a 00                	push   $0x0
  pushl $178
  10228a:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10228f:	e9 08 f9 ff ff       	jmp    101b9c <__alltraps>

00102294 <vector179>:
.globl vector179
vector179:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $179
  102296:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10229b:	e9 fc f8 ff ff       	jmp    101b9c <__alltraps>

001022a0 <vector180>:
.globl vector180
vector180:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $180
  1022a2:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1022a7:	e9 f0 f8 ff ff       	jmp    101b9c <__alltraps>

001022ac <vector181>:
.globl vector181
vector181:
  pushl $0
  1022ac:	6a 00                	push   $0x0
  pushl $181
  1022ae:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1022b3:	e9 e4 f8 ff ff       	jmp    101b9c <__alltraps>

001022b8 <vector182>:
.globl vector182
vector182:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $182
  1022ba:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1022bf:	e9 d8 f8 ff ff       	jmp    101b9c <__alltraps>

001022c4 <vector183>:
.globl vector183
vector183:
  pushl $0
  1022c4:	6a 00                	push   $0x0
  pushl $183
  1022c6:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1022cb:	e9 cc f8 ff ff       	jmp    101b9c <__alltraps>

001022d0 <vector184>:
.globl vector184
vector184:
  pushl $0
  1022d0:	6a 00                	push   $0x0
  pushl $184
  1022d2:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1022d7:	e9 c0 f8 ff ff       	jmp    101b9c <__alltraps>

001022dc <vector185>:
.globl vector185
vector185:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $185
  1022de:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1022e3:	e9 b4 f8 ff ff       	jmp    101b9c <__alltraps>

001022e8 <vector186>:
.globl vector186
vector186:
  pushl $0
  1022e8:	6a 00                	push   $0x0
  pushl $186
  1022ea:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1022ef:	e9 a8 f8 ff ff       	jmp    101b9c <__alltraps>

001022f4 <vector187>:
.globl vector187
vector187:
  pushl $0
  1022f4:	6a 00                	push   $0x0
  pushl $187
  1022f6:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1022fb:	e9 9c f8 ff ff       	jmp    101b9c <__alltraps>

00102300 <vector188>:
.globl vector188
vector188:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $188
  102302:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102307:	e9 90 f8 ff ff       	jmp    101b9c <__alltraps>

0010230c <vector189>:
.globl vector189
vector189:
  pushl $0
  10230c:	6a 00                	push   $0x0
  pushl $189
  10230e:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102313:	e9 84 f8 ff ff       	jmp    101b9c <__alltraps>

00102318 <vector190>:
.globl vector190
vector190:
  pushl $0
  102318:	6a 00                	push   $0x0
  pushl $190
  10231a:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10231f:	e9 78 f8 ff ff       	jmp    101b9c <__alltraps>

00102324 <vector191>:
.globl vector191
vector191:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $191
  102326:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10232b:	e9 6c f8 ff ff       	jmp    101b9c <__alltraps>

00102330 <vector192>:
.globl vector192
vector192:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $192
  102332:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102337:	e9 60 f8 ff ff       	jmp    101b9c <__alltraps>

0010233c <vector193>:
.globl vector193
vector193:
  pushl $0
  10233c:	6a 00                	push   $0x0
  pushl $193
  10233e:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102343:	e9 54 f8 ff ff       	jmp    101b9c <__alltraps>

00102348 <vector194>:
.globl vector194
vector194:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $194
  10234a:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10234f:	e9 48 f8 ff ff       	jmp    101b9c <__alltraps>

00102354 <vector195>:
.globl vector195
vector195:
  pushl $0
  102354:	6a 00                	push   $0x0
  pushl $195
  102356:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10235b:	e9 3c f8 ff ff       	jmp    101b9c <__alltraps>

00102360 <vector196>:
.globl vector196
vector196:
  pushl $0
  102360:	6a 00                	push   $0x0
  pushl $196
  102362:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102367:	e9 30 f8 ff ff       	jmp    101b9c <__alltraps>

0010236c <vector197>:
.globl vector197
vector197:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $197
  10236e:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102373:	e9 24 f8 ff ff       	jmp    101b9c <__alltraps>

00102378 <vector198>:
.globl vector198
vector198:
  pushl $0
  102378:	6a 00                	push   $0x0
  pushl $198
  10237a:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10237f:	e9 18 f8 ff ff       	jmp    101b9c <__alltraps>

00102384 <vector199>:
.globl vector199
vector199:
  pushl $0
  102384:	6a 00                	push   $0x0
  pushl $199
  102386:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10238b:	e9 0c f8 ff ff       	jmp    101b9c <__alltraps>

00102390 <vector200>:
.globl vector200
vector200:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $200
  102392:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102397:	e9 00 f8 ff ff       	jmp    101b9c <__alltraps>

0010239c <vector201>:
.globl vector201
vector201:
  pushl $0
  10239c:	6a 00                	push   $0x0
  pushl $201
  10239e:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1023a3:	e9 f4 f7 ff ff       	jmp    101b9c <__alltraps>

001023a8 <vector202>:
.globl vector202
vector202:
  pushl $0
  1023a8:	6a 00                	push   $0x0
  pushl $202
  1023aa:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1023af:	e9 e8 f7 ff ff       	jmp    101b9c <__alltraps>

001023b4 <vector203>:
.globl vector203
vector203:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $203
  1023b6:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1023bb:	e9 dc f7 ff ff       	jmp    101b9c <__alltraps>

001023c0 <vector204>:
.globl vector204
vector204:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $204
  1023c2:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1023c7:	e9 d0 f7 ff ff       	jmp    101b9c <__alltraps>

001023cc <vector205>:
.globl vector205
vector205:
  pushl $0
  1023cc:	6a 00                	push   $0x0
  pushl $205
  1023ce:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1023d3:	e9 c4 f7 ff ff       	jmp    101b9c <__alltraps>

001023d8 <vector206>:
.globl vector206
vector206:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $206
  1023da:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1023df:	e9 b8 f7 ff ff       	jmp    101b9c <__alltraps>

001023e4 <vector207>:
.globl vector207
vector207:
  pushl $0
  1023e4:	6a 00                	push   $0x0
  pushl $207
  1023e6:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1023eb:	e9 ac f7 ff ff       	jmp    101b9c <__alltraps>

001023f0 <vector208>:
.globl vector208
vector208:
  pushl $0
  1023f0:	6a 00                	push   $0x0
  pushl $208
  1023f2:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1023f7:	e9 a0 f7 ff ff       	jmp    101b9c <__alltraps>

001023fc <vector209>:
.globl vector209
vector209:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $209
  1023fe:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102403:	e9 94 f7 ff ff       	jmp    101b9c <__alltraps>

00102408 <vector210>:
.globl vector210
vector210:
  pushl $0
  102408:	6a 00                	push   $0x0
  pushl $210
  10240a:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10240f:	e9 88 f7 ff ff       	jmp    101b9c <__alltraps>

00102414 <vector211>:
.globl vector211
vector211:
  pushl $0
  102414:	6a 00                	push   $0x0
  pushl $211
  102416:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10241b:	e9 7c f7 ff ff       	jmp    101b9c <__alltraps>

00102420 <vector212>:
.globl vector212
vector212:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $212
  102422:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102427:	e9 70 f7 ff ff       	jmp    101b9c <__alltraps>

0010242c <vector213>:
.globl vector213
vector213:
  pushl $0
  10242c:	6a 00                	push   $0x0
  pushl $213
  10242e:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102433:	e9 64 f7 ff ff       	jmp    101b9c <__alltraps>

00102438 <vector214>:
.globl vector214
vector214:
  pushl $0
  102438:	6a 00                	push   $0x0
  pushl $214
  10243a:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10243f:	e9 58 f7 ff ff       	jmp    101b9c <__alltraps>

00102444 <vector215>:
.globl vector215
vector215:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $215
  102446:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10244b:	e9 4c f7 ff ff       	jmp    101b9c <__alltraps>

00102450 <vector216>:
.globl vector216
vector216:
  pushl $0
  102450:	6a 00                	push   $0x0
  pushl $216
  102452:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102457:	e9 40 f7 ff ff       	jmp    101b9c <__alltraps>

0010245c <vector217>:
.globl vector217
vector217:
  pushl $0
  10245c:	6a 00                	push   $0x0
  pushl $217
  10245e:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102463:	e9 34 f7 ff ff       	jmp    101b9c <__alltraps>

00102468 <vector218>:
.globl vector218
vector218:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $218
  10246a:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10246f:	e9 28 f7 ff ff       	jmp    101b9c <__alltraps>

00102474 <vector219>:
.globl vector219
vector219:
  pushl $0
  102474:	6a 00                	push   $0x0
  pushl $219
  102476:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10247b:	e9 1c f7 ff ff       	jmp    101b9c <__alltraps>

00102480 <vector220>:
.globl vector220
vector220:
  pushl $0
  102480:	6a 00                	push   $0x0
  pushl $220
  102482:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102487:	e9 10 f7 ff ff       	jmp    101b9c <__alltraps>

0010248c <vector221>:
.globl vector221
vector221:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $221
  10248e:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102493:	e9 04 f7 ff ff       	jmp    101b9c <__alltraps>

00102498 <vector222>:
.globl vector222
vector222:
  pushl $0
  102498:	6a 00                	push   $0x0
  pushl $222
  10249a:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10249f:	e9 f8 f6 ff ff       	jmp    101b9c <__alltraps>

001024a4 <vector223>:
.globl vector223
vector223:
  pushl $0
  1024a4:	6a 00                	push   $0x0
  pushl $223
  1024a6:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1024ab:	e9 ec f6 ff ff       	jmp    101b9c <__alltraps>

001024b0 <vector224>:
.globl vector224
vector224:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $224
  1024b2:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1024b7:	e9 e0 f6 ff ff       	jmp    101b9c <__alltraps>

001024bc <vector225>:
.globl vector225
vector225:
  pushl $0
  1024bc:	6a 00                	push   $0x0
  pushl $225
  1024be:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1024c3:	e9 d4 f6 ff ff       	jmp    101b9c <__alltraps>

001024c8 <vector226>:
.globl vector226
vector226:
  pushl $0
  1024c8:	6a 00                	push   $0x0
  pushl $226
  1024ca:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1024cf:	e9 c8 f6 ff ff       	jmp    101b9c <__alltraps>

001024d4 <vector227>:
.globl vector227
vector227:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $227
  1024d6:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1024db:	e9 bc f6 ff ff       	jmp    101b9c <__alltraps>

001024e0 <vector228>:
.globl vector228
vector228:
  pushl $0
  1024e0:	6a 00                	push   $0x0
  pushl $228
  1024e2:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1024e7:	e9 b0 f6 ff ff       	jmp    101b9c <__alltraps>

001024ec <vector229>:
.globl vector229
vector229:
  pushl $0
  1024ec:	6a 00                	push   $0x0
  pushl $229
  1024ee:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1024f3:	e9 a4 f6 ff ff       	jmp    101b9c <__alltraps>

001024f8 <vector230>:
.globl vector230
vector230:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $230
  1024fa:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1024ff:	e9 98 f6 ff ff       	jmp    101b9c <__alltraps>

00102504 <vector231>:
.globl vector231
vector231:
  pushl $0
  102504:	6a 00                	push   $0x0
  pushl $231
  102506:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10250b:	e9 8c f6 ff ff       	jmp    101b9c <__alltraps>

00102510 <vector232>:
.globl vector232
vector232:
  pushl $0
  102510:	6a 00                	push   $0x0
  pushl $232
  102512:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102517:	e9 80 f6 ff ff       	jmp    101b9c <__alltraps>

0010251c <vector233>:
.globl vector233
vector233:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $233
  10251e:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102523:	e9 74 f6 ff ff       	jmp    101b9c <__alltraps>

00102528 <vector234>:
.globl vector234
vector234:
  pushl $0
  102528:	6a 00                	push   $0x0
  pushl $234
  10252a:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10252f:	e9 68 f6 ff ff       	jmp    101b9c <__alltraps>

00102534 <vector235>:
.globl vector235
vector235:
  pushl $0
  102534:	6a 00                	push   $0x0
  pushl $235
  102536:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10253b:	e9 5c f6 ff ff       	jmp    101b9c <__alltraps>

00102540 <vector236>:
.globl vector236
vector236:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $236
  102542:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102547:	e9 50 f6 ff ff       	jmp    101b9c <__alltraps>

0010254c <vector237>:
.globl vector237
vector237:
  pushl $0
  10254c:	6a 00                	push   $0x0
  pushl $237
  10254e:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102553:	e9 44 f6 ff ff       	jmp    101b9c <__alltraps>

00102558 <vector238>:
.globl vector238
vector238:
  pushl $0
  102558:	6a 00                	push   $0x0
  pushl $238
  10255a:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10255f:	e9 38 f6 ff ff       	jmp    101b9c <__alltraps>

00102564 <vector239>:
.globl vector239
vector239:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $239
  102566:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10256b:	e9 2c f6 ff ff       	jmp    101b9c <__alltraps>

00102570 <vector240>:
.globl vector240
vector240:
  pushl $0
  102570:	6a 00                	push   $0x0
  pushl $240
  102572:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102577:	e9 20 f6 ff ff       	jmp    101b9c <__alltraps>

0010257c <vector241>:
.globl vector241
vector241:
  pushl $0
  10257c:	6a 00                	push   $0x0
  pushl $241
  10257e:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102583:	e9 14 f6 ff ff       	jmp    101b9c <__alltraps>

00102588 <vector242>:
.globl vector242
vector242:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $242
  10258a:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10258f:	e9 08 f6 ff ff       	jmp    101b9c <__alltraps>

00102594 <vector243>:
.globl vector243
vector243:
  pushl $0
  102594:	6a 00                	push   $0x0
  pushl $243
  102596:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10259b:	e9 fc f5 ff ff       	jmp    101b9c <__alltraps>

001025a0 <vector244>:
.globl vector244
vector244:
  pushl $0
  1025a0:	6a 00                	push   $0x0
  pushl $244
  1025a2:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1025a7:	e9 f0 f5 ff ff       	jmp    101b9c <__alltraps>

001025ac <vector245>:
.globl vector245
vector245:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $245
  1025ae:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1025b3:	e9 e4 f5 ff ff       	jmp    101b9c <__alltraps>

001025b8 <vector246>:
.globl vector246
vector246:
  pushl $0
  1025b8:	6a 00                	push   $0x0
  pushl $246
  1025ba:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1025bf:	e9 d8 f5 ff ff       	jmp    101b9c <__alltraps>

001025c4 <vector247>:
.globl vector247
vector247:
  pushl $0
  1025c4:	6a 00                	push   $0x0
  pushl $247
  1025c6:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1025cb:	e9 cc f5 ff ff       	jmp    101b9c <__alltraps>

001025d0 <vector248>:
.globl vector248
vector248:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $248
  1025d2:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1025d7:	e9 c0 f5 ff ff       	jmp    101b9c <__alltraps>

001025dc <vector249>:
.globl vector249
vector249:
  pushl $0
  1025dc:	6a 00                	push   $0x0
  pushl $249
  1025de:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1025e3:	e9 b4 f5 ff ff       	jmp    101b9c <__alltraps>

001025e8 <vector250>:
.globl vector250
vector250:
  pushl $0
  1025e8:	6a 00                	push   $0x0
  pushl $250
  1025ea:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1025ef:	e9 a8 f5 ff ff       	jmp    101b9c <__alltraps>

001025f4 <vector251>:
.globl vector251
vector251:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $251
  1025f6:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1025fb:	e9 9c f5 ff ff       	jmp    101b9c <__alltraps>

00102600 <vector252>:
.globl vector252
vector252:
  pushl $0
  102600:	6a 00                	push   $0x0
  pushl $252
  102602:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102607:	e9 90 f5 ff ff       	jmp    101b9c <__alltraps>

0010260c <vector253>:
.globl vector253
vector253:
  pushl $0
  10260c:	6a 00                	push   $0x0
  pushl $253
  10260e:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102613:	e9 84 f5 ff ff       	jmp    101b9c <__alltraps>

00102618 <vector254>:
.globl vector254
vector254:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $254
  10261a:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10261f:	e9 78 f5 ff ff       	jmp    101b9c <__alltraps>

00102624 <vector255>:
.globl vector255
vector255:
  pushl $0
  102624:	6a 00                	push   $0x0
  pushl $255
  102626:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10262b:	e9 6c f5 ff ff       	jmp    101b9c <__alltraps>

00102630 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102630:	55                   	push   %ebp
  102631:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102633:	8b 45 08             	mov    0x8(%ebp),%eax
  102636:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102639:	b8 23 00 00 00       	mov    $0x23,%eax
  10263e:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102640:	b8 23 00 00 00       	mov    $0x23,%eax
  102645:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102647:	b8 10 00 00 00       	mov    $0x10,%eax
  10264c:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10264e:	b8 10 00 00 00       	mov    $0x10,%eax
  102653:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102655:	b8 10 00 00 00       	mov    $0x10,%eax
  10265a:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  10265c:	ea 63 26 10 00 08 00 	ljmp   $0x8,$0x102663
}
  102663:	90                   	nop
  102664:	5d                   	pop    %ebp
  102665:	c3                   	ret    

00102666 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102666:	55                   	push   %ebp
  102667:	89 e5                	mov    %esp,%ebp
  102669:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  10266c:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102671:	05 00 04 00 00       	add    $0x400,%eax
  102676:	a3 a4 fc 10 00       	mov    %eax,0x10fca4
    ts.ts_ss0 = KERNEL_DS;
  10267b:	66 c7 05 a8 fc 10 00 	movw   $0x10,0x10fca8
  102682:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102684:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  10268b:	68 00 
  10268d:	b8 a0 fc 10 00       	mov    $0x10fca0,%eax
  102692:	0f b7 c0             	movzwl %ax,%eax
  102695:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  10269b:	b8 a0 fc 10 00       	mov    $0x10fca0,%eax
  1026a0:	c1 e8 10             	shr    $0x10,%eax
  1026a3:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1026a8:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1026af:	24 f0                	and    $0xf0,%al
  1026b1:	0c 09                	or     $0x9,%al
  1026b3:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1026b8:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1026bf:	0c 10                	or     $0x10,%al
  1026c1:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1026c6:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1026cd:	24 9f                	and    $0x9f,%al
  1026cf:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1026d4:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1026db:	0c 80                	or     $0x80,%al
  1026dd:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1026e2:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1026e9:	24 f0                	and    $0xf0,%al
  1026eb:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1026f0:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1026f7:	24 ef                	and    $0xef,%al
  1026f9:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1026fe:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102705:	24 df                	and    $0xdf,%al
  102707:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10270c:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102713:	0c 40                	or     $0x40,%al
  102715:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10271a:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102721:	24 7f                	and    $0x7f,%al
  102723:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102728:	b8 a0 fc 10 00       	mov    $0x10fca0,%eax
  10272d:	c1 e8 18             	shr    $0x18,%eax
  102730:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102735:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10273c:	24 ef                	and    $0xef,%al
  10273e:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102743:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  10274a:	e8 e1 fe ff ff       	call   102630 <lgdt>
  10274f:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102755:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102759:	0f 00 d8             	ltr    %ax
}
  10275c:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  10275d:	90                   	nop
  10275e:	89 ec                	mov    %ebp,%esp
  102760:	5d                   	pop    %ebp
  102761:	c3                   	ret    

00102762 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102762:	55                   	push   %ebp
  102763:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102765:	e8 fc fe ff ff       	call   102666 <gdt_init>
}
  10276a:	90                   	nop
  10276b:	5d                   	pop    %ebp
  10276c:	c3                   	ret    

0010276d <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10276d:	55                   	push   %ebp
  10276e:	89 e5                	mov    %esp,%ebp
  102770:	83 ec 58             	sub    $0x58,%esp
  102773:	8b 45 10             	mov    0x10(%ebp),%eax
  102776:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102779:	8b 45 14             	mov    0x14(%ebp),%eax
  10277c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10277f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102782:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102785:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102788:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10278b:	8b 45 18             	mov    0x18(%ebp),%eax
  10278e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102791:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102794:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102797:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10279a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10279d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1027a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1027a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1027a7:	74 1c                	je     1027c5 <printnum+0x58>
  1027a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1027ac:	ba 00 00 00 00       	mov    $0x0,%edx
  1027b1:	f7 75 e4             	divl   -0x1c(%ebp)
  1027b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1027b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1027ba:	ba 00 00 00 00       	mov    $0x0,%edx
  1027bf:	f7 75 e4             	divl   -0x1c(%ebp)
  1027c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1027c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1027c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1027cb:	f7 75 e4             	divl   -0x1c(%ebp)
  1027ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1027d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1027d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1027d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1027da:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1027dd:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1027e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1027e3:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1027e6:	8b 45 18             	mov    0x18(%ebp),%eax
  1027e9:	ba 00 00 00 00       	mov    $0x0,%edx
  1027ee:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1027f1:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1027f4:	19 d1                	sbb    %edx,%ecx
  1027f6:	72 4c                	jb     102844 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
  1027f8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1027fb:	8d 50 ff             	lea    -0x1(%eax),%edx
  1027fe:	8b 45 20             	mov    0x20(%ebp),%eax
  102801:	89 44 24 18          	mov    %eax,0x18(%esp)
  102805:	89 54 24 14          	mov    %edx,0x14(%esp)
  102809:	8b 45 18             	mov    0x18(%ebp),%eax
  10280c:	89 44 24 10          	mov    %eax,0x10(%esp)
  102810:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102813:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102816:	89 44 24 08          	mov    %eax,0x8(%esp)
  10281a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10281e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102821:	89 44 24 04          	mov    %eax,0x4(%esp)
  102825:	8b 45 08             	mov    0x8(%ebp),%eax
  102828:	89 04 24             	mov    %eax,(%esp)
  10282b:	e8 3d ff ff ff       	call   10276d <printnum>
  102830:	eb 1b                	jmp    10284d <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102832:	8b 45 0c             	mov    0xc(%ebp),%eax
  102835:	89 44 24 04          	mov    %eax,0x4(%esp)
  102839:	8b 45 20             	mov    0x20(%ebp),%eax
  10283c:	89 04 24             	mov    %eax,(%esp)
  10283f:	8b 45 08             	mov    0x8(%ebp),%eax
  102842:	ff d0                	call   *%eax
        while (-- width > 0)
  102844:	ff 4d 1c             	decl   0x1c(%ebp)
  102847:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10284b:	7f e5                	jg     102832 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10284d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102850:	05 10 3a 10 00       	add    $0x103a10,%eax
  102855:	0f b6 00             	movzbl (%eax),%eax
  102858:	0f be c0             	movsbl %al,%eax
  10285b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10285e:	89 54 24 04          	mov    %edx,0x4(%esp)
  102862:	89 04 24             	mov    %eax,(%esp)
  102865:	8b 45 08             	mov    0x8(%ebp),%eax
  102868:	ff d0                	call   *%eax
}
  10286a:	90                   	nop
  10286b:	89 ec                	mov    %ebp,%esp
  10286d:	5d                   	pop    %ebp
  10286e:	c3                   	ret    

0010286f <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10286f:	55                   	push   %ebp
  102870:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102872:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102876:	7e 14                	jle    10288c <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102878:	8b 45 08             	mov    0x8(%ebp),%eax
  10287b:	8b 00                	mov    (%eax),%eax
  10287d:	8d 48 08             	lea    0x8(%eax),%ecx
  102880:	8b 55 08             	mov    0x8(%ebp),%edx
  102883:	89 0a                	mov    %ecx,(%edx)
  102885:	8b 50 04             	mov    0x4(%eax),%edx
  102888:	8b 00                	mov    (%eax),%eax
  10288a:	eb 30                	jmp    1028bc <getuint+0x4d>
    }
    else if (lflag) {
  10288c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102890:	74 16                	je     1028a8 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102892:	8b 45 08             	mov    0x8(%ebp),%eax
  102895:	8b 00                	mov    (%eax),%eax
  102897:	8d 48 04             	lea    0x4(%eax),%ecx
  10289a:	8b 55 08             	mov    0x8(%ebp),%edx
  10289d:	89 0a                	mov    %ecx,(%edx)
  10289f:	8b 00                	mov    (%eax),%eax
  1028a1:	ba 00 00 00 00       	mov    $0x0,%edx
  1028a6:	eb 14                	jmp    1028bc <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1028a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1028ab:	8b 00                	mov    (%eax),%eax
  1028ad:	8d 48 04             	lea    0x4(%eax),%ecx
  1028b0:	8b 55 08             	mov    0x8(%ebp),%edx
  1028b3:	89 0a                	mov    %ecx,(%edx)
  1028b5:	8b 00                	mov    (%eax),%eax
  1028b7:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1028bc:	5d                   	pop    %ebp
  1028bd:	c3                   	ret    

001028be <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1028be:	55                   	push   %ebp
  1028bf:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1028c1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1028c5:	7e 14                	jle    1028db <getint+0x1d>
        return va_arg(*ap, long long);
  1028c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1028ca:	8b 00                	mov    (%eax),%eax
  1028cc:	8d 48 08             	lea    0x8(%eax),%ecx
  1028cf:	8b 55 08             	mov    0x8(%ebp),%edx
  1028d2:	89 0a                	mov    %ecx,(%edx)
  1028d4:	8b 50 04             	mov    0x4(%eax),%edx
  1028d7:	8b 00                	mov    (%eax),%eax
  1028d9:	eb 28                	jmp    102903 <getint+0x45>
    }
    else if (lflag) {
  1028db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1028df:	74 12                	je     1028f3 <getint+0x35>
        return va_arg(*ap, long);
  1028e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1028e4:	8b 00                	mov    (%eax),%eax
  1028e6:	8d 48 04             	lea    0x4(%eax),%ecx
  1028e9:	8b 55 08             	mov    0x8(%ebp),%edx
  1028ec:	89 0a                	mov    %ecx,(%edx)
  1028ee:	8b 00                	mov    (%eax),%eax
  1028f0:	99                   	cltd   
  1028f1:	eb 10                	jmp    102903 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1028f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1028f6:	8b 00                	mov    (%eax),%eax
  1028f8:	8d 48 04             	lea    0x4(%eax),%ecx
  1028fb:	8b 55 08             	mov    0x8(%ebp),%edx
  1028fe:	89 0a                	mov    %ecx,(%edx)
  102900:	8b 00                	mov    (%eax),%eax
  102902:	99                   	cltd   
    }
}
  102903:	5d                   	pop    %ebp
  102904:	c3                   	ret    

00102905 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102905:	55                   	push   %ebp
  102906:	89 e5                	mov    %esp,%ebp
  102908:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10290b:	8d 45 14             	lea    0x14(%ebp),%eax
  10290e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102914:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102918:	8b 45 10             	mov    0x10(%ebp),%eax
  10291b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10291f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102922:	89 44 24 04          	mov    %eax,0x4(%esp)
  102926:	8b 45 08             	mov    0x8(%ebp),%eax
  102929:	89 04 24             	mov    %eax,(%esp)
  10292c:	e8 05 00 00 00       	call   102936 <vprintfmt>
    va_end(ap);
}
  102931:	90                   	nop
  102932:	89 ec                	mov    %ebp,%esp
  102934:	5d                   	pop    %ebp
  102935:	c3                   	ret    

00102936 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102936:	55                   	push   %ebp
  102937:	89 e5                	mov    %esp,%ebp
  102939:	56                   	push   %esi
  10293a:	53                   	push   %ebx
  10293b:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10293e:	eb 17                	jmp    102957 <vprintfmt+0x21>
            if (ch == '\0') {
  102940:	85 db                	test   %ebx,%ebx
  102942:	0f 84 bf 03 00 00    	je     102d07 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  102948:	8b 45 0c             	mov    0xc(%ebp),%eax
  10294b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10294f:	89 1c 24             	mov    %ebx,(%esp)
  102952:	8b 45 08             	mov    0x8(%ebp),%eax
  102955:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102957:	8b 45 10             	mov    0x10(%ebp),%eax
  10295a:	8d 50 01             	lea    0x1(%eax),%edx
  10295d:	89 55 10             	mov    %edx,0x10(%ebp)
  102960:	0f b6 00             	movzbl (%eax),%eax
  102963:	0f b6 d8             	movzbl %al,%ebx
  102966:	83 fb 25             	cmp    $0x25,%ebx
  102969:	75 d5                	jne    102940 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  10296b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10296f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102976:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102979:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10297c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102983:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102986:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102989:	8b 45 10             	mov    0x10(%ebp),%eax
  10298c:	8d 50 01             	lea    0x1(%eax),%edx
  10298f:	89 55 10             	mov    %edx,0x10(%ebp)
  102992:	0f b6 00             	movzbl (%eax),%eax
  102995:	0f b6 d8             	movzbl %al,%ebx
  102998:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10299b:	83 f8 55             	cmp    $0x55,%eax
  10299e:	0f 87 37 03 00 00    	ja     102cdb <vprintfmt+0x3a5>
  1029a4:	8b 04 85 34 3a 10 00 	mov    0x103a34(,%eax,4),%eax
  1029ab:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1029ad:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1029b1:	eb d6                	jmp    102989 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1029b3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1029b7:	eb d0                	jmp    102989 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1029b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1029c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1029c3:	89 d0                	mov    %edx,%eax
  1029c5:	c1 e0 02             	shl    $0x2,%eax
  1029c8:	01 d0                	add    %edx,%eax
  1029ca:	01 c0                	add    %eax,%eax
  1029cc:	01 d8                	add    %ebx,%eax
  1029ce:	83 e8 30             	sub    $0x30,%eax
  1029d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1029d4:	8b 45 10             	mov    0x10(%ebp),%eax
  1029d7:	0f b6 00             	movzbl (%eax),%eax
  1029da:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1029dd:	83 fb 2f             	cmp    $0x2f,%ebx
  1029e0:	7e 38                	jle    102a1a <vprintfmt+0xe4>
  1029e2:	83 fb 39             	cmp    $0x39,%ebx
  1029e5:	7f 33                	jg     102a1a <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  1029e7:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1029ea:	eb d4                	jmp    1029c0 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1029ec:	8b 45 14             	mov    0x14(%ebp),%eax
  1029ef:	8d 50 04             	lea    0x4(%eax),%edx
  1029f2:	89 55 14             	mov    %edx,0x14(%ebp)
  1029f5:	8b 00                	mov    (%eax),%eax
  1029f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1029fa:	eb 1f                	jmp    102a1b <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  1029fc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102a00:	79 87                	jns    102989 <vprintfmt+0x53>
                width = 0;
  102a02:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102a09:	e9 7b ff ff ff       	jmp    102989 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  102a0e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102a15:	e9 6f ff ff ff       	jmp    102989 <vprintfmt+0x53>
            goto process_precision;
  102a1a:	90                   	nop

        process_precision:
            if (width < 0)
  102a1b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102a1f:	0f 89 64 ff ff ff    	jns    102989 <vprintfmt+0x53>
                width = precision, precision = -1;
  102a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102a28:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102a2b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102a32:	e9 52 ff ff ff       	jmp    102989 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102a37:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  102a3a:	e9 4a ff ff ff       	jmp    102989 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102a3f:	8b 45 14             	mov    0x14(%ebp),%eax
  102a42:	8d 50 04             	lea    0x4(%eax),%edx
  102a45:	89 55 14             	mov    %edx,0x14(%ebp)
  102a48:	8b 00                	mov    (%eax),%eax
  102a4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a4d:	89 54 24 04          	mov    %edx,0x4(%esp)
  102a51:	89 04 24             	mov    %eax,(%esp)
  102a54:	8b 45 08             	mov    0x8(%ebp),%eax
  102a57:	ff d0                	call   *%eax
            break;
  102a59:	e9 a4 02 00 00       	jmp    102d02 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102a5e:	8b 45 14             	mov    0x14(%ebp),%eax
  102a61:	8d 50 04             	lea    0x4(%eax),%edx
  102a64:	89 55 14             	mov    %edx,0x14(%ebp)
  102a67:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102a69:	85 db                	test   %ebx,%ebx
  102a6b:	79 02                	jns    102a6f <vprintfmt+0x139>
                err = -err;
  102a6d:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102a6f:	83 fb 06             	cmp    $0x6,%ebx
  102a72:	7f 0b                	jg     102a7f <vprintfmt+0x149>
  102a74:	8b 34 9d f4 39 10 00 	mov    0x1039f4(,%ebx,4),%esi
  102a7b:	85 f6                	test   %esi,%esi
  102a7d:	75 23                	jne    102aa2 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  102a7f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102a83:	c7 44 24 08 21 3a 10 	movl   $0x103a21,0x8(%esp)
  102a8a:	00 
  102a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a92:	8b 45 08             	mov    0x8(%ebp),%eax
  102a95:	89 04 24             	mov    %eax,(%esp)
  102a98:	e8 68 fe ff ff       	call   102905 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102a9d:	e9 60 02 00 00       	jmp    102d02 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  102aa2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102aa6:	c7 44 24 08 2a 3a 10 	movl   $0x103a2a,0x8(%esp)
  102aad:	00 
  102aae:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ab1:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab8:	89 04 24             	mov    %eax,(%esp)
  102abb:	e8 45 fe ff ff       	call   102905 <printfmt>
            break;
  102ac0:	e9 3d 02 00 00       	jmp    102d02 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102ac5:	8b 45 14             	mov    0x14(%ebp),%eax
  102ac8:	8d 50 04             	lea    0x4(%eax),%edx
  102acb:	89 55 14             	mov    %edx,0x14(%ebp)
  102ace:	8b 30                	mov    (%eax),%esi
  102ad0:	85 f6                	test   %esi,%esi
  102ad2:	75 05                	jne    102ad9 <vprintfmt+0x1a3>
                p = "(null)";
  102ad4:	be 2d 3a 10 00       	mov    $0x103a2d,%esi
            }
            if (width > 0 && padc != '-') {
  102ad9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102add:	7e 76                	jle    102b55 <vprintfmt+0x21f>
  102adf:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102ae3:	74 70                	je     102b55 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102ae5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ae8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102aec:	89 34 24             	mov    %esi,(%esp)
  102aef:	e8 16 03 00 00       	call   102e0a <strnlen>
  102af4:	89 c2                	mov    %eax,%edx
  102af6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102af9:	29 d0                	sub    %edx,%eax
  102afb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102afe:	eb 16                	jmp    102b16 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  102b00:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102b04:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b07:	89 54 24 04          	mov    %edx,0x4(%esp)
  102b0b:	89 04 24             	mov    %eax,(%esp)
  102b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b11:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  102b13:	ff 4d e8             	decl   -0x18(%ebp)
  102b16:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102b1a:	7f e4                	jg     102b00 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102b1c:	eb 37                	jmp    102b55 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  102b1e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102b22:	74 1f                	je     102b43 <vprintfmt+0x20d>
  102b24:	83 fb 1f             	cmp    $0x1f,%ebx
  102b27:	7e 05                	jle    102b2e <vprintfmt+0x1f8>
  102b29:	83 fb 7e             	cmp    $0x7e,%ebx
  102b2c:	7e 15                	jle    102b43 <vprintfmt+0x20d>
                    putch('?', putdat);
  102b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b31:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b35:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b3f:	ff d0                	call   *%eax
  102b41:	eb 0f                	jmp    102b52 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  102b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b46:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b4a:	89 1c 24             	mov    %ebx,(%esp)
  102b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b50:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102b52:	ff 4d e8             	decl   -0x18(%ebp)
  102b55:	89 f0                	mov    %esi,%eax
  102b57:	8d 70 01             	lea    0x1(%eax),%esi
  102b5a:	0f b6 00             	movzbl (%eax),%eax
  102b5d:	0f be d8             	movsbl %al,%ebx
  102b60:	85 db                	test   %ebx,%ebx
  102b62:	74 27                	je     102b8b <vprintfmt+0x255>
  102b64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102b68:	78 b4                	js     102b1e <vprintfmt+0x1e8>
  102b6a:	ff 4d e4             	decl   -0x1c(%ebp)
  102b6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102b71:	79 ab                	jns    102b1e <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  102b73:	eb 16                	jmp    102b8b <vprintfmt+0x255>
                putch(' ', putdat);
  102b75:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b78:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b7c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102b83:	8b 45 08             	mov    0x8(%ebp),%eax
  102b86:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  102b88:	ff 4d e8             	decl   -0x18(%ebp)
  102b8b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102b8f:	7f e4                	jg     102b75 <vprintfmt+0x23f>
            }
            break;
  102b91:	e9 6c 01 00 00       	jmp    102d02 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102b96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b99:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b9d:	8d 45 14             	lea    0x14(%ebp),%eax
  102ba0:	89 04 24             	mov    %eax,(%esp)
  102ba3:	e8 16 fd ff ff       	call   1028be <getint>
  102ba8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102bab:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102bb4:	85 d2                	test   %edx,%edx
  102bb6:	79 26                	jns    102bde <vprintfmt+0x2a8>
                putch('-', putdat);
  102bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bbf:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc9:	ff d0                	call   *%eax
                num = -(long long)num;
  102bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102bd1:	f7 d8                	neg    %eax
  102bd3:	83 d2 00             	adc    $0x0,%edx
  102bd6:	f7 da                	neg    %edx
  102bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102bdb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102bde:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102be5:	e9 a8 00 00 00       	jmp    102c92 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102bea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102bed:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bf1:	8d 45 14             	lea    0x14(%ebp),%eax
  102bf4:	89 04 24             	mov    %eax,(%esp)
  102bf7:	e8 73 fc ff ff       	call   10286f <getuint>
  102bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102bff:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102c02:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102c09:	e9 84 00 00 00       	jmp    102c92 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102c0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c11:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c15:	8d 45 14             	lea    0x14(%ebp),%eax
  102c18:	89 04 24             	mov    %eax,(%esp)
  102c1b:	e8 4f fc ff ff       	call   10286f <getuint>
  102c20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c23:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102c26:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102c2d:	eb 63                	jmp    102c92 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  102c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c32:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c36:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c40:	ff d0                	call   *%eax
            putch('x', putdat);
  102c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c45:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c49:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102c50:	8b 45 08             	mov    0x8(%ebp),%eax
  102c53:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102c55:	8b 45 14             	mov    0x14(%ebp),%eax
  102c58:	8d 50 04             	lea    0x4(%eax),%edx
  102c5b:	89 55 14             	mov    %edx,0x14(%ebp)
  102c5e:	8b 00                	mov    (%eax),%eax
  102c60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102c6a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102c71:	eb 1f                	jmp    102c92 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102c73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c76:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c7a:	8d 45 14             	lea    0x14(%ebp),%eax
  102c7d:	89 04 24             	mov    %eax,(%esp)
  102c80:	e8 ea fb ff ff       	call   10286f <getuint>
  102c85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c88:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102c8b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102c92:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102c96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c99:	89 54 24 18          	mov    %edx,0x18(%esp)
  102c9d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102ca0:	89 54 24 14          	mov    %edx,0x14(%esp)
  102ca4:	89 44 24 10          	mov    %eax,0x10(%esp)
  102ca8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102cae:	89 44 24 08          	mov    %eax,0x8(%esp)
  102cb2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc0:	89 04 24             	mov    %eax,(%esp)
  102cc3:	e8 a5 fa ff ff       	call   10276d <printnum>
            break;
  102cc8:	eb 38                	jmp    102d02 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ccd:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cd1:	89 1c 24             	mov    %ebx,(%esp)
  102cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd7:	ff d0                	call   *%eax
            break;
  102cd9:	eb 27                	jmp    102d02 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cde:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ce2:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  102cec:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102cee:	ff 4d 10             	decl   0x10(%ebp)
  102cf1:	eb 03                	jmp    102cf6 <vprintfmt+0x3c0>
  102cf3:	ff 4d 10             	decl   0x10(%ebp)
  102cf6:	8b 45 10             	mov    0x10(%ebp),%eax
  102cf9:	48                   	dec    %eax
  102cfa:	0f b6 00             	movzbl (%eax),%eax
  102cfd:	3c 25                	cmp    $0x25,%al
  102cff:	75 f2                	jne    102cf3 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  102d01:	90                   	nop
    while (1) {
  102d02:	e9 37 fc ff ff       	jmp    10293e <vprintfmt+0x8>
                return;
  102d07:	90                   	nop
        }
    }
}
  102d08:	83 c4 40             	add    $0x40,%esp
  102d0b:	5b                   	pop    %ebx
  102d0c:	5e                   	pop    %esi
  102d0d:	5d                   	pop    %ebp
  102d0e:	c3                   	ret    

00102d0f <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102d0f:	55                   	push   %ebp
  102d10:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d15:	8b 40 08             	mov    0x8(%eax),%eax
  102d18:	8d 50 01             	lea    0x1(%eax),%edx
  102d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d1e:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d24:	8b 10                	mov    (%eax),%edx
  102d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d29:	8b 40 04             	mov    0x4(%eax),%eax
  102d2c:	39 c2                	cmp    %eax,%edx
  102d2e:	73 12                	jae    102d42 <sprintputch+0x33>
        *b->buf ++ = ch;
  102d30:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d33:	8b 00                	mov    (%eax),%eax
  102d35:	8d 48 01             	lea    0x1(%eax),%ecx
  102d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d3b:	89 0a                	mov    %ecx,(%edx)
  102d3d:	8b 55 08             	mov    0x8(%ebp),%edx
  102d40:	88 10                	mov    %dl,(%eax)
    }
}
  102d42:	90                   	nop
  102d43:	5d                   	pop    %ebp
  102d44:	c3                   	ret    

00102d45 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102d45:	55                   	push   %ebp
  102d46:	89 e5                	mov    %esp,%ebp
  102d48:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102d4b:	8d 45 14             	lea    0x14(%ebp),%eax
  102d4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d54:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102d58:	8b 45 10             	mov    0x10(%ebp),%eax
  102d5b:	89 44 24 08          	mov    %eax,0x8(%esp)
  102d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d62:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d66:	8b 45 08             	mov    0x8(%ebp),%eax
  102d69:	89 04 24             	mov    %eax,(%esp)
  102d6c:	e8 0a 00 00 00       	call   102d7b <vsnprintf>
  102d71:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102d77:	89 ec                	mov    %ebp,%esp
  102d79:	5d                   	pop    %ebp
  102d7a:	c3                   	ret    

00102d7b <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102d7b:	55                   	push   %ebp
  102d7c:	89 e5                	mov    %esp,%ebp
  102d7e:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102d81:	8b 45 08             	mov    0x8(%ebp),%eax
  102d84:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  102d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d90:	01 d0                	add    %edx,%eax
  102d92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102d9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102da0:	74 0a                	je     102dac <vsnprintf+0x31>
  102da2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102da8:	39 c2                	cmp    %eax,%edx
  102daa:	76 07                	jbe    102db3 <vsnprintf+0x38>
        return -E_INVAL;
  102dac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102db1:	eb 2a                	jmp    102ddd <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102db3:	8b 45 14             	mov    0x14(%ebp),%eax
  102db6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102dba:	8b 45 10             	mov    0x10(%ebp),%eax
  102dbd:	89 44 24 08          	mov    %eax,0x8(%esp)
  102dc1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102dc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dc8:	c7 04 24 0f 2d 10 00 	movl   $0x102d0f,(%esp)
  102dcf:	e8 62 fb ff ff       	call   102936 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  102dd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102dd7:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102ddd:	89 ec                	mov    %ebp,%esp
  102ddf:	5d                   	pop    %ebp
  102de0:	c3                   	ret    

00102de1 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102de1:	55                   	push   %ebp
  102de2:	89 e5                	mov    %esp,%ebp
  102de4:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102de7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102dee:	eb 03                	jmp    102df3 <strlen+0x12>
        cnt ++;
  102df0:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102df3:	8b 45 08             	mov    0x8(%ebp),%eax
  102df6:	8d 50 01             	lea    0x1(%eax),%edx
  102df9:	89 55 08             	mov    %edx,0x8(%ebp)
  102dfc:	0f b6 00             	movzbl (%eax),%eax
  102dff:	84 c0                	test   %al,%al
  102e01:	75 ed                	jne    102df0 <strlen+0xf>
    }
    return cnt;
  102e03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102e06:	89 ec                	mov    %ebp,%esp
  102e08:	5d                   	pop    %ebp
  102e09:	c3                   	ret    

00102e0a <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102e0a:	55                   	push   %ebp
  102e0b:	89 e5                	mov    %esp,%ebp
  102e0d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102e10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102e17:	eb 03                	jmp    102e1c <strnlen+0x12>
        cnt ++;
  102e19:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102e1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e1f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102e22:	73 10                	jae    102e34 <strnlen+0x2a>
  102e24:	8b 45 08             	mov    0x8(%ebp),%eax
  102e27:	8d 50 01             	lea    0x1(%eax),%edx
  102e2a:	89 55 08             	mov    %edx,0x8(%ebp)
  102e2d:	0f b6 00             	movzbl (%eax),%eax
  102e30:	84 c0                	test   %al,%al
  102e32:	75 e5                	jne    102e19 <strnlen+0xf>
    }
    return cnt;
  102e34:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102e37:	89 ec                	mov    %ebp,%esp
  102e39:	5d                   	pop    %ebp
  102e3a:	c3                   	ret    

00102e3b <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102e3b:	55                   	push   %ebp
  102e3c:	89 e5                	mov    %esp,%ebp
  102e3e:	57                   	push   %edi
  102e3f:	56                   	push   %esi
  102e40:	83 ec 20             	sub    $0x20,%esp
  102e43:	8b 45 08             	mov    0x8(%ebp),%eax
  102e46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e49:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102e4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e55:	89 d1                	mov    %edx,%ecx
  102e57:	89 c2                	mov    %eax,%edx
  102e59:	89 ce                	mov    %ecx,%esi
  102e5b:	89 d7                	mov    %edx,%edi
  102e5d:	ac                   	lods   %ds:(%esi),%al
  102e5e:	aa                   	stos   %al,%es:(%edi)
  102e5f:	84 c0                	test   %al,%al
  102e61:	75 fa                	jne    102e5d <strcpy+0x22>
  102e63:	89 fa                	mov    %edi,%edx
  102e65:	89 f1                	mov    %esi,%ecx
  102e67:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102e6a:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102e6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102e73:	83 c4 20             	add    $0x20,%esp
  102e76:	5e                   	pop    %esi
  102e77:	5f                   	pop    %edi
  102e78:	5d                   	pop    %ebp
  102e79:	c3                   	ret    

00102e7a <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102e7a:	55                   	push   %ebp
  102e7b:	89 e5                	mov    %esp,%ebp
  102e7d:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102e80:	8b 45 08             	mov    0x8(%ebp),%eax
  102e83:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102e86:	eb 1e                	jmp    102ea6 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  102e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e8b:	0f b6 10             	movzbl (%eax),%edx
  102e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e91:	88 10                	mov    %dl,(%eax)
  102e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e96:	0f b6 00             	movzbl (%eax),%eax
  102e99:	84 c0                	test   %al,%al
  102e9b:	74 03                	je     102ea0 <strncpy+0x26>
            src ++;
  102e9d:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102ea0:	ff 45 fc             	incl   -0x4(%ebp)
  102ea3:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  102ea6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102eaa:	75 dc                	jne    102e88 <strncpy+0xe>
    }
    return dst;
  102eac:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102eaf:	89 ec                	mov    %ebp,%esp
  102eb1:	5d                   	pop    %ebp
  102eb2:	c3                   	ret    

00102eb3 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102eb3:	55                   	push   %ebp
  102eb4:	89 e5                	mov    %esp,%ebp
  102eb6:	57                   	push   %edi
  102eb7:	56                   	push   %esi
  102eb8:	83 ec 20             	sub    $0x20,%esp
  102ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  102ebe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ec4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102ec7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ecd:	89 d1                	mov    %edx,%ecx
  102ecf:	89 c2                	mov    %eax,%edx
  102ed1:	89 ce                	mov    %ecx,%esi
  102ed3:	89 d7                	mov    %edx,%edi
  102ed5:	ac                   	lods   %ds:(%esi),%al
  102ed6:	ae                   	scas   %es:(%edi),%al
  102ed7:	75 08                	jne    102ee1 <strcmp+0x2e>
  102ed9:	84 c0                	test   %al,%al
  102edb:	75 f8                	jne    102ed5 <strcmp+0x22>
  102edd:	31 c0                	xor    %eax,%eax
  102edf:	eb 04                	jmp    102ee5 <strcmp+0x32>
  102ee1:	19 c0                	sbb    %eax,%eax
  102ee3:	0c 01                	or     $0x1,%al
  102ee5:	89 fa                	mov    %edi,%edx
  102ee7:	89 f1                	mov    %esi,%ecx
  102ee9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102eec:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102eef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102ef2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102ef5:	83 c4 20             	add    $0x20,%esp
  102ef8:	5e                   	pop    %esi
  102ef9:	5f                   	pop    %edi
  102efa:	5d                   	pop    %ebp
  102efb:	c3                   	ret    

00102efc <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102efc:	55                   	push   %ebp
  102efd:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102eff:	eb 09                	jmp    102f0a <strncmp+0xe>
        n --, s1 ++, s2 ++;
  102f01:	ff 4d 10             	decl   0x10(%ebp)
  102f04:	ff 45 08             	incl   0x8(%ebp)
  102f07:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102f0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f0e:	74 1a                	je     102f2a <strncmp+0x2e>
  102f10:	8b 45 08             	mov    0x8(%ebp),%eax
  102f13:	0f b6 00             	movzbl (%eax),%eax
  102f16:	84 c0                	test   %al,%al
  102f18:	74 10                	je     102f2a <strncmp+0x2e>
  102f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  102f1d:	0f b6 10             	movzbl (%eax),%edx
  102f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f23:	0f b6 00             	movzbl (%eax),%eax
  102f26:	38 c2                	cmp    %al,%dl
  102f28:	74 d7                	je     102f01 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102f2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f2e:	74 18                	je     102f48 <strncmp+0x4c>
  102f30:	8b 45 08             	mov    0x8(%ebp),%eax
  102f33:	0f b6 00             	movzbl (%eax),%eax
  102f36:	0f b6 d0             	movzbl %al,%edx
  102f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f3c:	0f b6 00             	movzbl (%eax),%eax
  102f3f:	0f b6 c8             	movzbl %al,%ecx
  102f42:	89 d0                	mov    %edx,%eax
  102f44:	29 c8                	sub    %ecx,%eax
  102f46:	eb 05                	jmp    102f4d <strncmp+0x51>
  102f48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102f4d:	5d                   	pop    %ebp
  102f4e:	c3                   	ret    

00102f4f <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102f4f:	55                   	push   %ebp
  102f50:	89 e5                	mov    %esp,%ebp
  102f52:	83 ec 04             	sub    $0x4,%esp
  102f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f58:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102f5b:	eb 13                	jmp    102f70 <strchr+0x21>
        if (*s == c) {
  102f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f60:	0f b6 00             	movzbl (%eax),%eax
  102f63:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102f66:	75 05                	jne    102f6d <strchr+0x1e>
            return (char *)s;
  102f68:	8b 45 08             	mov    0x8(%ebp),%eax
  102f6b:	eb 12                	jmp    102f7f <strchr+0x30>
        }
        s ++;
  102f6d:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102f70:	8b 45 08             	mov    0x8(%ebp),%eax
  102f73:	0f b6 00             	movzbl (%eax),%eax
  102f76:	84 c0                	test   %al,%al
  102f78:	75 e3                	jne    102f5d <strchr+0xe>
    }
    return NULL;
  102f7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102f7f:	89 ec                	mov    %ebp,%esp
  102f81:	5d                   	pop    %ebp
  102f82:	c3                   	ret    

00102f83 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102f83:	55                   	push   %ebp
  102f84:	89 e5                	mov    %esp,%ebp
  102f86:	83 ec 04             	sub    $0x4,%esp
  102f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f8c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102f8f:	eb 0e                	jmp    102f9f <strfind+0x1c>
        if (*s == c) {
  102f91:	8b 45 08             	mov    0x8(%ebp),%eax
  102f94:	0f b6 00             	movzbl (%eax),%eax
  102f97:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102f9a:	74 0f                	je     102fab <strfind+0x28>
            break;
        }
        s ++;
  102f9c:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  102fa2:	0f b6 00             	movzbl (%eax),%eax
  102fa5:	84 c0                	test   %al,%al
  102fa7:	75 e8                	jne    102f91 <strfind+0xe>
  102fa9:	eb 01                	jmp    102fac <strfind+0x29>
            break;
  102fab:	90                   	nop
    }
    return (char *)s;
  102fac:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102faf:	89 ec                	mov    %ebp,%esp
  102fb1:	5d                   	pop    %ebp
  102fb2:	c3                   	ret    

00102fb3 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102fb3:	55                   	push   %ebp
  102fb4:	89 e5                	mov    %esp,%ebp
  102fb6:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102fb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102fc0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102fc7:	eb 03                	jmp    102fcc <strtol+0x19>
        s ++;
  102fc9:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  102fcf:	0f b6 00             	movzbl (%eax),%eax
  102fd2:	3c 20                	cmp    $0x20,%al
  102fd4:	74 f3                	je     102fc9 <strtol+0x16>
  102fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  102fd9:	0f b6 00             	movzbl (%eax),%eax
  102fdc:	3c 09                	cmp    $0x9,%al
  102fde:	74 e9                	je     102fc9 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  102fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe3:	0f b6 00             	movzbl (%eax),%eax
  102fe6:	3c 2b                	cmp    $0x2b,%al
  102fe8:	75 05                	jne    102fef <strtol+0x3c>
        s ++;
  102fea:	ff 45 08             	incl   0x8(%ebp)
  102fed:	eb 14                	jmp    103003 <strtol+0x50>
    }
    else if (*s == '-') {
  102fef:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff2:	0f b6 00             	movzbl (%eax),%eax
  102ff5:	3c 2d                	cmp    $0x2d,%al
  102ff7:	75 0a                	jne    103003 <strtol+0x50>
        s ++, neg = 1;
  102ff9:	ff 45 08             	incl   0x8(%ebp)
  102ffc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  103003:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103007:	74 06                	je     10300f <strtol+0x5c>
  103009:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  10300d:	75 22                	jne    103031 <strtol+0x7e>
  10300f:	8b 45 08             	mov    0x8(%ebp),%eax
  103012:	0f b6 00             	movzbl (%eax),%eax
  103015:	3c 30                	cmp    $0x30,%al
  103017:	75 18                	jne    103031 <strtol+0x7e>
  103019:	8b 45 08             	mov    0x8(%ebp),%eax
  10301c:	40                   	inc    %eax
  10301d:	0f b6 00             	movzbl (%eax),%eax
  103020:	3c 78                	cmp    $0x78,%al
  103022:	75 0d                	jne    103031 <strtol+0x7e>
        s += 2, base = 16;
  103024:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103028:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10302f:	eb 29                	jmp    10305a <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  103031:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103035:	75 16                	jne    10304d <strtol+0x9a>
  103037:	8b 45 08             	mov    0x8(%ebp),%eax
  10303a:	0f b6 00             	movzbl (%eax),%eax
  10303d:	3c 30                	cmp    $0x30,%al
  10303f:	75 0c                	jne    10304d <strtol+0x9a>
        s ++, base = 8;
  103041:	ff 45 08             	incl   0x8(%ebp)
  103044:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  10304b:	eb 0d                	jmp    10305a <strtol+0xa7>
    }
    else if (base == 0) {
  10304d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103051:	75 07                	jne    10305a <strtol+0xa7>
        base = 10;
  103053:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10305a:	8b 45 08             	mov    0x8(%ebp),%eax
  10305d:	0f b6 00             	movzbl (%eax),%eax
  103060:	3c 2f                	cmp    $0x2f,%al
  103062:	7e 1b                	jle    10307f <strtol+0xcc>
  103064:	8b 45 08             	mov    0x8(%ebp),%eax
  103067:	0f b6 00             	movzbl (%eax),%eax
  10306a:	3c 39                	cmp    $0x39,%al
  10306c:	7f 11                	jg     10307f <strtol+0xcc>
            dig = *s - '0';
  10306e:	8b 45 08             	mov    0x8(%ebp),%eax
  103071:	0f b6 00             	movzbl (%eax),%eax
  103074:	0f be c0             	movsbl %al,%eax
  103077:	83 e8 30             	sub    $0x30,%eax
  10307a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10307d:	eb 48                	jmp    1030c7 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10307f:	8b 45 08             	mov    0x8(%ebp),%eax
  103082:	0f b6 00             	movzbl (%eax),%eax
  103085:	3c 60                	cmp    $0x60,%al
  103087:	7e 1b                	jle    1030a4 <strtol+0xf1>
  103089:	8b 45 08             	mov    0x8(%ebp),%eax
  10308c:	0f b6 00             	movzbl (%eax),%eax
  10308f:	3c 7a                	cmp    $0x7a,%al
  103091:	7f 11                	jg     1030a4 <strtol+0xf1>
            dig = *s - 'a' + 10;
  103093:	8b 45 08             	mov    0x8(%ebp),%eax
  103096:	0f b6 00             	movzbl (%eax),%eax
  103099:	0f be c0             	movsbl %al,%eax
  10309c:	83 e8 57             	sub    $0x57,%eax
  10309f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030a2:	eb 23                	jmp    1030c7 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1030a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1030a7:	0f b6 00             	movzbl (%eax),%eax
  1030aa:	3c 40                	cmp    $0x40,%al
  1030ac:	7e 3b                	jle    1030e9 <strtol+0x136>
  1030ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b1:	0f b6 00             	movzbl (%eax),%eax
  1030b4:	3c 5a                	cmp    $0x5a,%al
  1030b6:	7f 31                	jg     1030e9 <strtol+0x136>
            dig = *s - 'A' + 10;
  1030b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1030bb:	0f b6 00             	movzbl (%eax),%eax
  1030be:	0f be c0             	movsbl %al,%eax
  1030c1:	83 e8 37             	sub    $0x37,%eax
  1030c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1030c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030ca:	3b 45 10             	cmp    0x10(%ebp),%eax
  1030cd:	7d 19                	jge    1030e8 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  1030cf:	ff 45 08             	incl   0x8(%ebp)
  1030d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1030d5:	0f af 45 10          	imul   0x10(%ebp),%eax
  1030d9:	89 c2                	mov    %eax,%edx
  1030db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030de:	01 d0                	add    %edx,%eax
  1030e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  1030e3:	e9 72 ff ff ff       	jmp    10305a <strtol+0xa7>
            break;
  1030e8:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  1030e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1030ed:	74 08                	je     1030f7 <strtol+0x144>
        *endptr = (char *) s;
  1030ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030f2:	8b 55 08             	mov    0x8(%ebp),%edx
  1030f5:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1030f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1030fb:	74 07                	je     103104 <strtol+0x151>
  1030fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103100:	f7 d8                	neg    %eax
  103102:	eb 03                	jmp    103107 <strtol+0x154>
  103104:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  103107:	89 ec                	mov    %ebp,%esp
  103109:	5d                   	pop    %ebp
  10310a:	c3                   	ret    

0010310b <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  10310b:	55                   	push   %ebp
  10310c:	89 e5                	mov    %esp,%ebp
  10310e:	83 ec 28             	sub    $0x28,%esp
  103111:	89 7d fc             	mov    %edi,-0x4(%ebp)
  103114:	8b 45 0c             	mov    0xc(%ebp),%eax
  103117:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  10311a:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  10311e:	8b 45 08             	mov    0x8(%ebp),%eax
  103121:	89 45 f8             	mov    %eax,-0x8(%ebp)
  103124:	88 55 f7             	mov    %dl,-0x9(%ebp)
  103127:	8b 45 10             	mov    0x10(%ebp),%eax
  10312a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  10312d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  103130:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103134:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103137:	89 d7                	mov    %edx,%edi
  103139:	f3 aa                	rep stos %al,%es:(%edi)
  10313b:	89 fa                	mov    %edi,%edx
  10313d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103140:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103143:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103146:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103149:	89 ec                	mov    %ebp,%esp
  10314b:	5d                   	pop    %ebp
  10314c:	c3                   	ret    

0010314d <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  10314d:	55                   	push   %ebp
  10314e:	89 e5                	mov    %esp,%ebp
  103150:	57                   	push   %edi
  103151:	56                   	push   %esi
  103152:	53                   	push   %ebx
  103153:	83 ec 30             	sub    $0x30,%esp
  103156:	8b 45 08             	mov    0x8(%ebp),%eax
  103159:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10315c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10315f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103162:	8b 45 10             	mov    0x10(%ebp),%eax
  103165:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103168:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10316b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10316e:	73 42                	jae    1031b2 <memmove+0x65>
  103170:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103176:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103179:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10317c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10317f:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103182:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103185:	c1 e8 02             	shr    $0x2,%eax
  103188:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10318a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10318d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103190:	89 d7                	mov    %edx,%edi
  103192:	89 c6                	mov    %eax,%esi
  103194:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103196:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103199:	83 e1 03             	and    $0x3,%ecx
  10319c:	74 02                	je     1031a0 <memmove+0x53>
  10319e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1031a0:	89 f0                	mov    %esi,%eax
  1031a2:	89 fa                	mov    %edi,%edx
  1031a4:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1031a7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1031aa:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  1031ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  1031b0:	eb 36                	jmp    1031e8 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1031b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031b5:	8d 50 ff             	lea    -0x1(%eax),%edx
  1031b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031bb:	01 c2                	add    %eax,%edx
  1031bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031c0:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1031c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031c6:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  1031c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031cc:	89 c1                	mov    %eax,%ecx
  1031ce:	89 d8                	mov    %ebx,%eax
  1031d0:	89 d6                	mov    %edx,%esi
  1031d2:	89 c7                	mov    %eax,%edi
  1031d4:	fd                   	std    
  1031d5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1031d7:	fc                   	cld    
  1031d8:	89 f8                	mov    %edi,%eax
  1031da:	89 f2                	mov    %esi,%edx
  1031dc:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1031df:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1031e2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1031e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1031e8:	83 c4 30             	add    $0x30,%esp
  1031eb:	5b                   	pop    %ebx
  1031ec:	5e                   	pop    %esi
  1031ed:	5f                   	pop    %edi
  1031ee:	5d                   	pop    %ebp
  1031ef:	c3                   	ret    

001031f0 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1031f0:	55                   	push   %ebp
  1031f1:	89 e5                	mov    %esp,%ebp
  1031f3:	57                   	push   %edi
  1031f4:	56                   	push   %esi
  1031f5:	83 ec 20             	sub    $0x20,%esp
  1031f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1031fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  103201:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103204:	8b 45 10             	mov    0x10(%ebp),%eax
  103207:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10320a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10320d:	c1 e8 02             	shr    $0x2,%eax
  103210:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103212:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103215:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103218:	89 d7                	mov    %edx,%edi
  10321a:	89 c6                	mov    %eax,%esi
  10321c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10321e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103221:	83 e1 03             	and    $0x3,%ecx
  103224:	74 02                	je     103228 <memcpy+0x38>
  103226:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103228:	89 f0                	mov    %esi,%eax
  10322a:	89 fa                	mov    %edi,%edx
  10322c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10322f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103232:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  103235:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103238:	83 c4 20             	add    $0x20,%esp
  10323b:	5e                   	pop    %esi
  10323c:	5f                   	pop    %edi
  10323d:	5d                   	pop    %ebp
  10323e:	c3                   	ret    

0010323f <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10323f:	55                   	push   %ebp
  103240:	89 e5                	mov    %esp,%ebp
  103242:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103245:	8b 45 08             	mov    0x8(%ebp),%eax
  103248:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10324b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10324e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103251:	eb 2e                	jmp    103281 <memcmp+0x42>
        if (*s1 != *s2) {
  103253:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103256:	0f b6 10             	movzbl (%eax),%edx
  103259:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10325c:	0f b6 00             	movzbl (%eax),%eax
  10325f:	38 c2                	cmp    %al,%dl
  103261:	74 18                	je     10327b <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103263:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103266:	0f b6 00             	movzbl (%eax),%eax
  103269:	0f b6 d0             	movzbl %al,%edx
  10326c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10326f:	0f b6 00             	movzbl (%eax),%eax
  103272:	0f b6 c8             	movzbl %al,%ecx
  103275:	89 d0                	mov    %edx,%eax
  103277:	29 c8                	sub    %ecx,%eax
  103279:	eb 18                	jmp    103293 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  10327b:	ff 45 fc             	incl   -0x4(%ebp)
  10327e:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  103281:	8b 45 10             	mov    0x10(%ebp),%eax
  103284:	8d 50 ff             	lea    -0x1(%eax),%edx
  103287:	89 55 10             	mov    %edx,0x10(%ebp)
  10328a:	85 c0                	test   %eax,%eax
  10328c:	75 c5                	jne    103253 <memcmp+0x14>
    }
    return 0;
  10328e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103293:	89 ec                	mov    %ebp,%esp
  103295:	5d                   	pop    %ebp
  103296:	c3                   	ret    
