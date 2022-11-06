
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	f3 0f 1e fb          	endbr32 
  100004:	55                   	push   %ebp
  100005:	89 e5                	mov    %esp,%ebp
  100007:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10000a:	b8 20 1d 11 00       	mov    $0x111d20,%eax
  10000f:	2d 16 0a 11 00       	sub    $0x110a16,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 0a 11 00 	movl   $0x110a16,(%esp)
  100027:	e8 22 2f 00 00       	call   102f4e <memset>

    cons_init();                // init the console
  10002c:	e8 18 16 00 00       	call   101649 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 80 37 10 00 	movl   $0x103780,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 9c 37 10 00 	movl   $0x10379c,(%esp)
  100046:	e8 44 02 00 00       	call   10028f <cprintf>

    print_kerninfo();
  10004b:	e8 02 09 00 00       	call   100952 <print_kerninfo>

    grade_backtrace();
  100050:	e8 95 00 00 00       	call   1000ea <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 a3 2b 00 00       	call   102bfd <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 3f 17 00 00       	call   10179e <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 e4 18 00 00       	call   101948 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 65 0d 00 00       	call   100dce <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 7c 18 00 00       	call   1018ea <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	f3 0f 1e fb          	endbr32 
  100074:	55                   	push   %ebp
  100075:	89 e5                	mov    %esp,%ebp
  100077:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100081:	00 
  100082:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100089:	00 
  10008a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100091:	e8 22 0d 00 00       	call   100db8 <mon_backtrace>
}
  100096:	90                   	nop
  100097:	c9                   	leave  
  100098:	c3                   	ret    

00100099 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100099:	f3 0f 1e fb          	endbr32 
  10009d:	55                   	push   %ebp
  10009e:	89 e5                	mov    %esp,%ebp
  1000a0:	53                   	push   %ebx
  1000a1:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a4:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000aa:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1000b0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000b4:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000b8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000bc:	89 04 24             	mov    %eax,(%esp)
  1000bf:	e8 ac ff ff ff       	call   100070 <grade_backtrace2>
}
  1000c4:	90                   	nop
  1000c5:	83 c4 14             	add    $0x14,%esp
  1000c8:	5b                   	pop    %ebx
  1000c9:	5d                   	pop    %ebp
  1000ca:	c3                   	ret    

001000cb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000cb:	f3 0f 1e fb          	endbr32 
  1000cf:	55                   	push   %ebp
  1000d0:	89 e5                	mov    %esp,%ebp
  1000d2:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000d5:	8b 45 10             	mov    0x10(%ebp),%eax
  1000d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1000df:	89 04 24             	mov    %eax,(%esp)
  1000e2:	e8 b2 ff ff ff       	call   100099 <grade_backtrace1>
}
  1000e7:	90                   	nop
  1000e8:	c9                   	leave  
  1000e9:	c3                   	ret    

001000ea <grade_backtrace>:

void
grade_backtrace(void) {
  1000ea:	f3 0f 1e fb          	endbr32 
  1000ee:	55                   	push   %ebp
  1000ef:	89 e5                	mov    %esp,%ebp
  1000f1:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000f4:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000f9:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100100:	ff 
  100101:	89 44 24 04          	mov    %eax,0x4(%esp)
  100105:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10010c:	e8 ba ff ff ff       	call   1000cb <grade_backtrace0>
}
  100111:	90                   	nop
  100112:	c9                   	leave  
  100113:	c3                   	ret    

00100114 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100114:	f3 0f 1e fb          	endbr32 
  100118:	55                   	push   %ebp
  100119:	89 e5                	mov    %esp,%ebp
  10011b:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10011e:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100121:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100124:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100127:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10012a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10012e:	83 e0 03             	and    $0x3,%eax
  100131:	89 c2                	mov    %eax,%edx
  100133:	a1 20 0a 11 00       	mov    0x110a20,%eax
  100138:	89 54 24 08          	mov    %edx,0x8(%esp)
  10013c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100140:	c7 04 24 a1 37 10 00 	movl   $0x1037a1,(%esp)
  100147:	e8 43 01 00 00       	call   10028f <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10014c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100150:	89 c2                	mov    %eax,%edx
  100152:	a1 20 0a 11 00       	mov    0x110a20,%eax
  100157:	89 54 24 08          	mov    %edx,0x8(%esp)
  10015b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10015f:	c7 04 24 af 37 10 00 	movl   $0x1037af,(%esp)
  100166:	e8 24 01 00 00       	call   10028f <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10016b:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10016f:	89 c2                	mov    %eax,%edx
  100171:	a1 20 0a 11 00       	mov    0x110a20,%eax
  100176:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10017e:	c7 04 24 bd 37 10 00 	movl   $0x1037bd,(%esp)
  100185:	e8 05 01 00 00       	call   10028f <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10018a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10018e:	89 c2                	mov    %eax,%edx
  100190:	a1 20 0a 11 00       	mov    0x110a20,%eax
  100195:	89 54 24 08          	mov    %edx,0x8(%esp)
  100199:	89 44 24 04          	mov    %eax,0x4(%esp)
  10019d:	c7 04 24 cb 37 10 00 	movl   $0x1037cb,(%esp)
  1001a4:	e8 e6 00 00 00       	call   10028f <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001a9:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001ad:	89 c2                	mov    %eax,%edx
  1001af:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001b4:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001bc:	c7 04 24 d9 37 10 00 	movl   $0x1037d9,(%esp)
  1001c3:	e8 c7 00 00 00       	call   10028f <cprintf>
    round ++;
  1001c8:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001cd:	40                   	inc    %eax
  1001ce:	a3 20 0a 11 00       	mov    %eax,0x110a20
}
  1001d3:	90                   	nop
  1001d4:	c9                   	leave  
  1001d5:	c3                   	ret    

001001d6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001d6:	f3 0f 1e fb          	endbr32 
  1001da:	55                   	push   %ebp
  1001db:	89 e5                	mov    %esp,%ebp
    //执行“int n”时, CPU从中断向量表中, 找到第n号表项, 修改CS和IP
    //1. 取中断类型码n ;
    //2. 标志寄存器入栈(pushf) , IF=0, TF=0(重置中断标志位)  ;
    //3. CS、IP入栈 ;
    //4. 查中断向量表,  (IP)=(n*4), (CS)=(n*4+2)。
    asm volatile (
  1001dd:	83 ec 08             	sub    $0x8,%esp
  1001e0:	cd 78                	int    $0x78
  1001e2:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001e4:	90                   	nop
  1001e5:	5d                   	pop    %ebp
  1001e6:	c3                   	ret    

001001e7 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001e7:	f3 0f 1e fb          	endbr32 
  1001eb:	55                   	push   %ebp
  1001ec:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
  1001ee:	cd 79                	int    $0x79
  1001f0:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001f2:	90                   	nop
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001f5:	f3 0f 1e fb          	endbr32 
  1001f9:	55                   	push   %ebp
  1001fa:	89 e5                	mov    %esp,%ebp
  1001fc:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001ff:	e8 10 ff ff ff       	call   100114 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100204:	c7 04 24 e8 37 10 00 	movl   $0x1037e8,(%esp)
  10020b:	e8 7f 00 00 00       	call   10028f <cprintf>
    lab1_switch_to_user();
  100210:	e8 c1 ff ff ff       	call   1001d6 <lab1_switch_to_user>
    lab1_print_cur_status();
  100215:	e8 fa fe ff ff       	call   100114 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021a:	c7 04 24 08 38 10 00 	movl   $0x103808,(%esp)
  100221:	e8 69 00 00 00       	call   10028f <cprintf>
    lab1_switch_to_kernel();
  100226:	e8 bc ff ff ff       	call   1001e7 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022b:	e8 e4 fe ff ff       	call   100114 <lab1_print_cur_status>
}
  100230:	90                   	nop
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <cputch>:
 *  do
 *      writes a single character @c to stdout
 *      increaces the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100233:	f3 0f 1e fb          	endbr32 
  100237:	55                   	push   %ebp
  100238:	89 e5                	mov    %esp,%ebp
  10023a:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10023d:	8b 45 08             	mov    0x8(%ebp),%eax
  100240:	89 04 24             	mov    %eax,(%esp)
  100243:	e8 32 14 00 00       	call   10167a <cons_putc>
    (*cnt) ++;
  100248:	8b 45 0c             	mov    0xc(%ebp),%eax
  10024b:	8b 00                	mov    (%eax),%eax
  10024d:	8d 50 01             	lea    0x1(%eax),%edx
  100250:	8b 45 0c             	mov    0xc(%ebp),%eax
  100253:	89 10                	mov    %edx,(%eax)
}
  100255:	90                   	nop
  100256:	c9                   	leave  
  100257:	c3                   	ret    

00100258 <vcprintf>:
 *      the number of characters which would be written to stdout
 *  call it when
 *      you are already dealing with a va_list. Or you probably want cprintf() instead.
 */
int
vcprintf(const char *fmt, va_list ap) {
  100258:	f3 0f 1e fb          	endbr32 
  10025c:	55                   	push   %ebp
  10025d:	89 e5                	mov    %esp,%ebp
  10025f:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100262:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100269:	8b 45 0c             	mov    0xc(%ebp),%eax
  10026c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100270:	8b 45 08             	mov    0x8(%ebp),%eax
  100273:	89 44 24 08          	mov    %eax,0x8(%esp)
  100277:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10027a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10027e:	c7 04 24 33 02 10 00 	movl   $0x100233,(%esp)
  100285:	e8 30 30 00 00       	call   1032ba <vprintfmt>
    return cnt;
  10028a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10028d:	c9                   	leave  
  10028e:	c3                   	ret    

0010028f <cprintf>:
 *      format a string and writes it to stdout
 *  return
 *      the number of characters which would be written to stdout
 */
int
cprintf(const char *fmt, ...) {
  10028f:	f3 0f 1e fb          	endbr32 
  100293:	55                   	push   %ebp
  100294:	89 e5                	mov    %esp,%ebp
  100296:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100299:	8d 45 0c             	lea    0xc(%ebp),%eax
  10029c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10029f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1002a9:	89 04 24             	mov    %eax,(%esp)
  1002ac:	e8 a7 ff ff ff       	call   100258 <vcprintf>
  1002b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002b7:	c9                   	leave  
  1002b8:	c3                   	ret    

001002b9 <cputchar>:
/*  cputchar
 *  do
 *      writes a single character to stdout
 */
void
cputchar(int c) {
  1002b9:	f3 0f 1e fb          	endbr32 
  1002bd:	55                   	push   %ebp
  1002be:	89 e5                	mov    %esp,%ebp
  1002c0:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c6:	89 04 24             	mov    %eax,(%esp)
  1002c9:	e8 ac 13 00 00       	call   10167a <cons_putc>
}
  1002ce:	90                   	nop
  1002cf:	c9                   	leave  
  1002d0:	c3                   	ret    

001002d1 <cputs>:
 *      writes the string pointed by @str to stdout and appends a newline character.
 *  return
 *      the number of characters which would be written to stdout
 */
int
cputs(const char *str) {
  1002d1:	f3 0f 1e fb          	endbr32 
  1002d5:	55                   	push   %ebp
  1002d6:	89 e5                	mov    %esp,%ebp
  1002d8:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002e2:	eb 13                	jmp    1002f7 <cputs+0x26>
        cputch(c, &cnt);
  1002e4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002e8:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002eb:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002ef:	89 04 24             	mov    %eax,(%esp)
  1002f2:	e8 3c ff ff ff       	call   100233 <cputch>
    while ((c = *str ++) != '\0') {
  1002f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fa:	8d 50 01             	lea    0x1(%eax),%edx
  1002fd:	89 55 08             	mov    %edx,0x8(%ebp)
  100300:	0f b6 00             	movzbl (%eax),%eax
  100303:	88 45 f7             	mov    %al,-0x9(%ebp)
  100306:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  10030a:	75 d8                	jne    1002e4 <cputs+0x13>
    }
    cputch('\n', &cnt);
  10030c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10030f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100313:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10031a:	e8 14 ff ff ff       	call   100233 <cputch>
    return cnt;
  10031f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100322:	c9                   	leave  
  100323:	c3                   	ret    

00100324 <getchar>:
 *      reads a single non-zero character from stdin 
 *  return
 *      this non-zero charater
 */
int
getchar(void) {
  100324:	f3 0f 1e fb          	endbr32 
  100328:	55                   	push   %ebp
  100329:	89 e5                	mov    %esp,%ebp
  10032b:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  10032e:	90                   	nop
  10032f:	e8 74 13 00 00       	call   1016a8 <cons_getc>
  100334:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100337:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10033b:	74 f2                	je     10032f <getchar+0xb>
        /* do nothing */;
    return c;
  10033d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100340:	c9                   	leave  
  100341:	c3                   	ret    

00100342 <readline>:
 *      the text of the line read.
 *      If some errors are happened, NULL is returned.
 *      The return value is a , thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100342:	f3 0f 1e fb          	endbr32 
  100346:	55                   	push   %ebp
  100347:	89 e5                	mov    %esp,%ebp
  100349:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10034c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100350:	74 13                	je     100365 <readline+0x23>
        cprintf("%s", prompt);
  100352:	8b 45 08             	mov    0x8(%ebp),%eax
  100355:	89 44 24 04          	mov    %eax,0x4(%esp)
  100359:	c7 04 24 27 38 10 00 	movl   $0x103827,(%esp)
  100360:	e8 2a ff ff ff       	call   10028f <cprintf>
    }
    int i = 0, c;
  100365:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10036c:	e8 b3 ff ff ff       	call   100324 <getchar>
  100371:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100374:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100378:	79 07                	jns    100381 <readline+0x3f>
            return NULL;
  10037a:	b8 00 00 00 00       	mov    $0x0,%eax
  10037f:	eb 78                	jmp    1003f9 <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100381:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100385:	7e 28                	jle    1003af <readline+0x6d>
  100387:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10038e:	7f 1f                	jg     1003af <readline+0x6d>
            cputchar(c);
  100390:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100393:	89 04 24             	mov    %eax,(%esp)
  100396:	e8 1e ff ff ff       	call   1002b9 <cputchar>
            buf[i ++] = c;
  10039b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10039e:	8d 50 01             	lea    0x1(%eax),%edx
  1003a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003a7:	88 90 40 0a 11 00    	mov    %dl,0x110a40(%eax)
  1003ad:	eb 45                	jmp    1003f4 <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003af:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003b3:	75 16                	jne    1003cb <readline+0x89>
  1003b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003b9:	7e 10                	jle    1003cb <readline+0x89>
            cputchar(c);
  1003bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003be:	89 04 24             	mov    %eax,(%esp)
  1003c1:	e8 f3 fe ff ff       	call   1002b9 <cputchar>
            i --;
  1003c6:	ff 4d f4             	decl   -0xc(%ebp)
  1003c9:	eb 29                	jmp    1003f4 <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  1003cb:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003cf:	74 06                	je     1003d7 <readline+0x95>
  1003d1:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003d5:	75 95                	jne    10036c <readline+0x2a>
            cputchar(c);
  1003d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003da:	89 04 24             	mov    %eax,(%esp)
  1003dd:	e8 d7 fe ff ff       	call   1002b9 <cputchar>
            buf[i] = '\0';
  1003e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003e5:	05 40 0a 11 00       	add    $0x110a40,%eax
  1003ea:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003ed:	b8 40 0a 11 00       	mov    $0x110a40,%eax
  1003f2:	eb 05                	jmp    1003f9 <readline+0xb7>
        c = getchar();
  1003f4:	e9 73 ff ff ff       	jmp    10036c <readline+0x2a>
        }
    }
}
  1003f9:	c9                   	leave  
  1003fa:	c3                   	ret    

001003fb <__panic>:
 *  do 
 *      1.  prints "panic: 'message'"
 *      2.  enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003fb:	f3 0f 1e fb          	endbr32 
  1003ff:	55                   	push   %ebp
  100400:	89 e5                	mov    %esp,%ebp
  100402:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100405:	a1 40 0e 11 00       	mov    0x110e40,%eax
  10040a:	85 c0                	test   %eax,%eax
  10040c:	75 5b                	jne    100469 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  10040e:	c7 05 40 0e 11 00 01 	movl   $0x1,0x110e40
  100415:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100418:	8d 45 14             	lea    0x14(%ebp),%eax
  10041b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  10041e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100421:	89 44 24 08          	mov    %eax,0x8(%esp)
  100425:	8b 45 08             	mov    0x8(%ebp),%eax
  100428:	89 44 24 04          	mov    %eax,0x4(%esp)
  10042c:	c7 04 24 2a 38 10 00 	movl   $0x10382a,(%esp)
  100433:	e8 57 fe ff ff       	call   10028f <cprintf>
    vcprintf(fmt, ap);
  100438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10043b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10043f:	8b 45 10             	mov    0x10(%ebp),%eax
  100442:	89 04 24             	mov    %eax,(%esp)
  100445:	e8 0e fe ff ff       	call   100258 <vcprintf>
    cprintf("\n");
  10044a:	c7 04 24 46 38 10 00 	movl   $0x103846,(%esp)
  100451:	e8 39 fe ff ff       	call   10028f <cprintf>
    
    cprintf("stack trackback:\n");
  100456:	c7 04 24 48 38 10 00 	movl   $0x103848,(%esp)
  10045d:	e8 2d fe ff ff       	call   10028f <cprintf>
    print_stackframe();
  100462:	e8 3d 06 00 00       	call   100aa4 <print_stackframe>
  100467:	eb 01                	jmp    10046a <__panic+0x6f>
        goto panic_dead;
  100469:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10046a:	e8 87 14 00 00       	call   1018f6 <intr_disable>
    while (1) {
        kmonitor(NULL);
  10046f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100476:	e8 64 08 00 00       	call   100cdf <kmonitor>
  10047b:	eb f2                	jmp    10046f <__panic+0x74>

0010047d <__warn>:
/*  __warn
 *  do 
 *      prints "panic: 'message'"
 */
void
__warn(const char *file, int line, const char *fmt, ...) {
  10047d:	f3 0f 1e fb          	endbr32 
  100481:	55                   	push   %ebp
  100482:	89 e5                	mov    %esp,%ebp
  100484:	83 ec 28             	sub    $0x28,%esp
    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100487:	8d 45 14             	lea    0x14(%ebp),%eax
  10048a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10048d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100490:	89 44 24 08          	mov    %eax,0x8(%esp)
  100494:	8b 45 08             	mov    0x8(%ebp),%eax
  100497:	89 44 24 04          	mov    %eax,0x4(%esp)
  10049b:	c7 04 24 5a 38 10 00 	movl   $0x10385a,(%esp)
  1004a2:	e8 e8 fd ff ff       	call   10028f <cprintf>
    vcprintf(fmt, ap);
  1004a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004ae:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b1:	89 04 24             	mov    %eax,(%esp)
  1004b4:	e8 9f fd ff ff       	call   100258 <vcprintf>
    cprintf("\n");
  1004b9:	c7 04 24 46 38 10 00 	movl   $0x103846,(%esp)
  1004c0:	e8 ca fd ff ff       	call   10028f <cprintf>
    va_end(ap);
}
  1004c5:	90                   	nop
  1004c6:	c9                   	leave  
  1004c7:	c3                   	ret    

001004c8 <is_kernel_panic>:
/*  is_kernel_panic
 *  do
 *      judge whether panic
 */
bool
is_kernel_panic(void) {
  1004c8:	f3 0f 1e fb          	endbr32 
  1004cc:	55                   	push   %ebp
  1004cd:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004cf:	a1 40 0e 11 00       	mov    0x110e40,%eax
}
  1004d4:	5d                   	pop    %ebp
  1004d5:	c3                   	ret    

001004d6 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004d6:	f3 0f 1e fb          	endbr32 
  1004da:	55                   	push   %ebp
  1004db:	89 e5                	mov    %esp,%ebp
  1004dd:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e3:	8b 00                	mov    (%eax),%eax
  1004e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004e8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004eb:	8b 00                	mov    (%eax),%eax
  1004ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004f7:	e9 ca 00 00 00       	jmp    1005c6 <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
  1004fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100502:	01 d0                	add    %edx,%eax
  100504:	89 c2                	mov    %eax,%edx
  100506:	c1 ea 1f             	shr    $0x1f,%edx
  100509:	01 d0                	add    %edx,%eax
  10050b:	d1 f8                	sar    %eax
  10050d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100510:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100513:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100516:	eb 03                	jmp    10051b <stab_binsearch+0x45>
            m --;
  100518:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  10051b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10051e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100521:	7c 1f                	jl     100542 <stab_binsearch+0x6c>
  100523:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100526:	89 d0                	mov    %edx,%eax
  100528:	01 c0                	add    %eax,%eax
  10052a:	01 d0                	add    %edx,%eax
  10052c:	c1 e0 02             	shl    $0x2,%eax
  10052f:	89 c2                	mov    %eax,%edx
  100531:	8b 45 08             	mov    0x8(%ebp),%eax
  100534:	01 d0                	add    %edx,%eax
  100536:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10053a:	0f b6 c0             	movzbl %al,%eax
  10053d:	39 45 14             	cmp    %eax,0x14(%ebp)
  100540:	75 d6                	jne    100518 <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  100542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100545:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100548:	7d 09                	jge    100553 <stab_binsearch+0x7d>
            l = true_m + 1;
  10054a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10054d:	40                   	inc    %eax
  10054e:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100551:	eb 73                	jmp    1005c6 <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
  100553:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10055a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10055d:	89 d0                	mov    %edx,%eax
  10055f:	01 c0                	add    %eax,%eax
  100561:	01 d0                	add    %edx,%eax
  100563:	c1 e0 02             	shl    $0x2,%eax
  100566:	89 c2                	mov    %eax,%edx
  100568:	8b 45 08             	mov    0x8(%ebp),%eax
  10056b:	01 d0                	add    %edx,%eax
  10056d:	8b 40 08             	mov    0x8(%eax),%eax
  100570:	39 45 18             	cmp    %eax,0x18(%ebp)
  100573:	76 11                	jbe    100586 <stab_binsearch+0xb0>
            *region_left = m;
  100575:	8b 45 0c             	mov    0xc(%ebp),%eax
  100578:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10057b:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10057d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100580:	40                   	inc    %eax
  100581:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100584:	eb 40                	jmp    1005c6 <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
  100586:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100589:	89 d0                	mov    %edx,%eax
  10058b:	01 c0                	add    %eax,%eax
  10058d:	01 d0                	add    %edx,%eax
  10058f:	c1 e0 02             	shl    $0x2,%eax
  100592:	89 c2                	mov    %eax,%edx
  100594:	8b 45 08             	mov    0x8(%ebp),%eax
  100597:	01 d0                	add    %edx,%eax
  100599:	8b 40 08             	mov    0x8(%eax),%eax
  10059c:	39 45 18             	cmp    %eax,0x18(%ebp)
  10059f:	73 14                	jae    1005b5 <stab_binsearch+0xdf>
            *region_right = m - 1;
  1005a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005a7:	8b 45 10             	mov    0x10(%ebp),%eax
  1005aa:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005af:	48                   	dec    %eax
  1005b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005b3:	eb 11                	jmp    1005c6 <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005bb:	89 10                	mov    %edx,(%eax)
            l = m;
  1005bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005c3:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005c9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005cc:	0f 8e 2a ff ff ff    	jle    1004fc <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  1005d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005d6:	75 0f                	jne    1005e7 <stab_binsearch+0x111>
        *region_right = *region_left - 1;
  1005d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005db:	8b 00                	mov    (%eax),%eax
  1005dd:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005e0:	8b 45 10             	mov    0x10(%ebp),%eax
  1005e3:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005e5:	eb 3e                	jmp    100625 <stab_binsearch+0x14f>
        l = *region_right;
  1005e7:	8b 45 10             	mov    0x10(%ebp),%eax
  1005ea:	8b 00                	mov    (%eax),%eax
  1005ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005ef:	eb 03                	jmp    1005f4 <stab_binsearch+0x11e>
  1005f1:	ff 4d fc             	decl   -0x4(%ebp)
  1005f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f7:	8b 00                	mov    (%eax),%eax
  1005f9:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005fc:	7e 1f                	jle    10061d <stab_binsearch+0x147>
  1005fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100601:	89 d0                	mov    %edx,%eax
  100603:	01 c0                	add    %eax,%eax
  100605:	01 d0                	add    %edx,%eax
  100607:	c1 e0 02             	shl    $0x2,%eax
  10060a:	89 c2                	mov    %eax,%edx
  10060c:	8b 45 08             	mov    0x8(%ebp),%eax
  10060f:	01 d0                	add    %edx,%eax
  100611:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100615:	0f b6 c0             	movzbl %al,%eax
  100618:	39 45 14             	cmp    %eax,0x14(%ebp)
  10061b:	75 d4                	jne    1005f1 <stab_binsearch+0x11b>
        *region_left = l;
  10061d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100620:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100623:	89 10                	mov    %edx,(%eax)
}
  100625:	90                   	nop
  100626:	c9                   	leave  
  100627:	c3                   	ret    

00100628 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100628:	f3 0f 1e fb          	endbr32 
  10062c:	55                   	push   %ebp
  10062d:	89 e5                	mov    %esp,%ebp
  10062f:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100632:	8b 45 0c             	mov    0xc(%ebp),%eax
  100635:	c7 00 78 38 10 00    	movl   $0x103878,(%eax)
    info->eip_line = 0;
  10063b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10063e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100645:	8b 45 0c             	mov    0xc(%ebp),%eax
  100648:	c7 40 08 78 38 10 00 	movl   $0x103878,0x8(%eax)
    info->eip_fn_namelen = 9;
  10064f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100652:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100659:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065c:	8b 55 08             	mov    0x8(%ebp),%edx
  10065f:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100662:	8b 45 0c             	mov    0xc(%ebp),%eax
  100665:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10066c:	c7 45 f4 ac 40 10 00 	movl   $0x1040ac,-0xc(%ebp)
    stab_end = __STAB_END__;
  100673:	c7 45 f0 20 cf 10 00 	movl   $0x10cf20,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10067a:	c7 45 ec 21 cf 10 00 	movl   $0x10cf21,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100681:	c7 45 e8 13 f0 10 00 	movl   $0x10f013,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100688:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10068b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10068e:	76 0b                	jbe    10069b <debuginfo_eip+0x73>
  100690:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100693:	48                   	dec    %eax
  100694:	0f b6 00             	movzbl (%eax),%eax
  100697:	84 c0                	test   %al,%al
  100699:	74 0a                	je     1006a5 <debuginfo_eip+0x7d>
        return -1;
  10069b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006a0:	e9 ab 02 00 00       	jmp    100950 <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1006a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006af:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006b2:	c1 f8 02             	sar    $0x2,%eax
  1006b5:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006bb:	48                   	dec    %eax
  1006bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1006c2:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006c6:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006cd:	00 
  1006ce:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006d5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006df:	89 04 24             	mov    %eax,(%esp)
  1006e2:	e8 ef fd ff ff       	call   1004d6 <stab_binsearch>
    if (lfile == 0)
  1006e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ea:	85 c0                	test   %eax,%eax
  1006ec:	75 0a                	jne    1006f8 <debuginfo_eip+0xd0>
        return -1;
  1006ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006f3:	e9 58 02 00 00       	jmp    100950 <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100701:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100704:	8b 45 08             	mov    0x8(%ebp),%eax
  100707:	89 44 24 10          	mov    %eax,0x10(%esp)
  10070b:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100712:	00 
  100713:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100716:	89 44 24 08          	mov    %eax,0x8(%esp)
  10071a:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10071d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100724:	89 04 24             	mov    %eax,(%esp)
  100727:	e8 aa fd ff ff       	call   1004d6 <stab_binsearch>

    if (lfun <= rfun) {
  10072c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10072f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100732:	39 c2                	cmp    %eax,%edx
  100734:	7f 78                	jg     1007ae <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100736:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100739:	89 c2                	mov    %eax,%edx
  10073b:	89 d0                	mov    %edx,%eax
  10073d:	01 c0                	add    %eax,%eax
  10073f:	01 d0                	add    %edx,%eax
  100741:	c1 e0 02             	shl    $0x2,%eax
  100744:	89 c2                	mov    %eax,%edx
  100746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100749:	01 d0                	add    %edx,%eax
  10074b:	8b 10                	mov    (%eax),%edx
  10074d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100750:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100753:	39 c2                	cmp    %eax,%edx
  100755:	73 22                	jae    100779 <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100757:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10075a:	89 c2                	mov    %eax,%edx
  10075c:	89 d0                	mov    %edx,%eax
  10075e:	01 c0                	add    %eax,%eax
  100760:	01 d0                	add    %edx,%eax
  100762:	c1 e0 02             	shl    $0x2,%eax
  100765:	89 c2                	mov    %eax,%edx
  100767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10076a:	01 d0                	add    %edx,%eax
  10076c:	8b 10                	mov    (%eax),%edx
  10076e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100771:	01 c2                	add    %eax,%edx
  100773:	8b 45 0c             	mov    0xc(%ebp),%eax
  100776:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100779:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10077c:	89 c2                	mov    %eax,%edx
  10077e:	89 d0                	mov    %edx,%eax
  100780:	01 c0                	add    %eax,%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	c1 e0 02             	shl    $0x2,%eax
  100787:	89 c2                	mov    %eax,%edx
  100789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10078c:	01 d0                	add    %edx,%eax
  10078e:	8b 50 08             	mov    0x8(%eax),%edx
  100791:	8b 45 0c             	mov    0xc(%ebp),%eax
  100794:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100797:	8b 45 0c             	mov    0xc(%ebp),%eax
  10079a:	8b 40 10             	mov    0x10(%eax),%eax
  10079d:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1007a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1007a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007ac:	eb 15                	jmp    1007c3 <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b1:	8b 55 08             	mov    0x8(%ebp),%edx
  1007b4:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007c6:	8b 40 08             	mov    0x8(%eax),%eax
  1007c9:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007d0:	00 
  1007d1:	89 04 24             	mov    %eax,(%esp)
  1007d4:	e8 e9 25 00 00       	call   102dc2 <strfind>
  1007d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1007dc:	8b 52 08             	mov    0x8(%edx),%edx
  1007df:	29 d0                	sub    %edx,%eax
  1007e1:	89 c2                	mov    %eax,%edx
  1007e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e6:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1007ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007f0:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007f7:	00 
  1007f8:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007ff:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100802:	89 44 24 04          	mov    %eax,0x4(%esp)
  100806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100809:	89 04 24             	mov    %eax,(%esp)
  10080c:	e8 c5 fc ff ff       	call   1004d6 <stab_binsearch>
    if (lline <= rline) {
  100811:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100814:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100817:	39 c2                	cmp    %eax,%edx
  100819:	7f 23                	jg     10083e <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
  10081b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10081e:	89 c2                	mov    %eax,%edx
  100820:	89 d0                	mov    %edx,%eax
  100822:	01 c0                	add    %eax,%eax
  100824:	01 d0                	add    %edx,%eax
  100826:	c1 e0 02             	shl    $0x2,%eax
  100829:	89 c2                	mov    %eax,%edx
  10082b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10082e:	01 d0                	add    %edx,%eax
  100830:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100834:	89 c2                	mov    %eax,%edx
  100836:	8b 45 0c             	mov    0xc(%ebp),%eax
  100839:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10083c:	eb 11                	jmp    10084f <debuginfo_eip+0x227>
        return -1;
  10083e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100843:	e9 08 01 00 00       	jmp    100950 <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100848:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084b:	48                   	dec    %eax
  10084c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10084f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100852:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100855:	39 c2                	cmp    %eax,%edx
  100857:	7c 56                	jl     1008af <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
  100859:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085c:	89 c2                	mov    %eax,%edx
  10085e:	89 d0                	mov    %edx,%eax
  100860:	01 c0                	add    %eax,%eax
  100862:	01 d0                	add    %edx,%eax
  100864:	c1 e0 02             	shl    $0x2,%eax
  100867:	89 c2                	mov    %eax,%edx
  100869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086c:	01 d0                	add    %edx,%eax
  10086e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100872:	3c 84                	cmp    $0x84,%al
  100874:	74 39                	je     1008af <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100876:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100879:	89 c2                	mov    %eax,%edx
  10087b:	89 d0                	mov    %edx,%eax
  10087d:	01 c0                	add    %eax,%eax
  10087f:	01 d0                	add    %edx,%eax
  100881:	c1 e0 02             	shl    $0x2,%eax
  100884:	89 c2                	mov    %eax,%edx
  100886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100889:	01 d0                	add    %edx,%eax
  10088b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10088f:	3c 64                	cmp    $0x64,%al
  100891:	75 b5                	jne    100848 <debuginfo_eip+0x220>
  100893:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100896:	89 c2                	mov    %eax,%edx
  100898:	89 d0                	mov    %edx,%eax
  10089a:	01 c0                	add    %eax,%eax
  10089c:	01 d0                	add    %edx,%eax
  10089e:	c1 e0 02             	shl    $0x2,%eax
  1008a1:	89 c2                	mov    %eax,%edx
  1008a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008a6:	01 d0                	add    %edx,%eax
  1008a8:	8b 40 08             	mov    0x8(%eax),%eax
  1008ab:	85 c0                	test   %eax,%eax
  1008ad:	74 99                	je     100848 <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008af:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008b5:	39 c2                	cmp    %eax,%edx
  1008b7:	7c 42                	jl     1008fb <debuginfo_eip+0x2d3>
  1008b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008bc:	89 c2                	mov    %eax,%edx
  1008be:	89 d0                	mov    %edx,%eax
  1008c0:	01 c0                	add    %eax,%eax
  1008c2:	01 d0                	add    %edx,%eax
  1008c4:	c1 e0 02             	shl    $0x2,%eax
  1008c7:	89 c2                	mov    %eax,%edx
  1008c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008cc:	01 d0                	add    %edx,%eax
  1008ce:	8b 10                	mov    (%eax),%edx
  1008d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1008d3:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1008d6:	39 c2                	cmp    %eax,%edx
  1008d8:	73 21                	jae    1008fb <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008dd:	89 c2                	mov    %eax,%edx
  1008df:	89 d0                	mov    %edx,%eax
  1008e1:	01 c0                	add    %eax,%eax
  1008e3:	01 d0                	add    %edx,%eax
  1008e5:	c1 e0 02             	shl    $0x2,%eax
  1008e8:	89 c2                	mov    %eax,%edx
  1008ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ed:	01 d0                	add    %edx,%eax
  1008ef:	8b 10                	mov    (%eax),%edx
  1008f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008f4:	01 c2                	add    %eax,%edx
  1008f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008f9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100901:	39 c2                	cmp    %eax,%edx
  100903:	7d 46                	jge    10094b <debuginfo_eip+0x323>
        for (lline = lfun + 1;
  100905:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100908:	40                   	inc    %eax
  100909:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10090c:	eb 16                	jmp    100924 <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10090e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100911:	8b 40 14             	mov    0x14(%eax),%eax
  100914:	8d 50 01             	lea    0x1(%eax),%edx
  100917:	8b 45 0c             	mov    0xc(%ebp),%eax
  10091a:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  10091d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100920:	40                   	inc    %eax
  100921:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100924:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100927:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  10092a:	39 c2                	cmp    %eax,%edx
  10092c:	7d 1d                	jge    10094b <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10092e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100931:	89 c2                	mov    %eax,%edx
  100933:	89 d0                	mov    %edx,%eax
  100935:	01 c0                	add    %eax,%eax
  100937:	01 d0                	add    %edx,%eax
  100939:	c1 e0 02             	shl    $0x2,%eax
  10093c:	89 c2                	mov    %eax,%edx
  10093e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100941:	01 d0                	add    %edx,%eax
  100943:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100947:	3c a0                	cmp    $0xa0,%al
  100949:	74 c3                	je     10090e <debuginfo_eip+0x2e6>
        }
    }
    return 0;
  10094b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100950:	c9                   	leave  
  100951:	c3                   	ret    

00100952 <print_kerninfo>:
 *  * the start address of text segements
 *  * the start address of free memory
 *  * how many memory that kernel has used.
*/
void
print_kerninfo(void) {
  100952:	f3 0f 1e fb          	endbr32 
  100956:	55                   	push   %ebp
  100957:	89 e5                	mov    %esp,%ebp
  100959:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10095c:	c7 04 24 82 38 10 00 	movl   $0x103882,(%esp)
  100963:	e8 27 f9 ff ff       	call   10028f <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100968:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10096f:	00 
  100970:	c7 04 24 9b 38 10 00 	movl   $0x10389b,(%esp)
  100977:	e8 13 f9 ff ff       	call   10028f <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10097c:	c7 44 24 04 72 37 10 	movl   $0x103772,0x4(%esp)
  100983:	00 
  100984:	c7 04 24 b3 38 10 00 	movl   $0x1038b3,(%esp)
  10098b:	e8 ff f8 ff ff       	call   10028f <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100990:	c7 44 24 04 16 0a 11 	movl   $0x110a16,0x4(%esp)
  100997:	00 
  100998:	c7 04 24 cb 38 10 00 	movl   $0x1038cb,(%esp)
  10099f:	e8 eb f8 ff ff       	call   10028f <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009a4:	c7 44 24 04 20 1d 11 	movl   $0x111d20,0x4(%esp)
  1009ab:	00 
  1009ac:	c7 04 24 e3 38 10 00 	movl   $0x1038e3,(%esp)
  1009b3:	e8 d7 f8 ff ff       	call   10028f <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009b8:	b8 20 1d 11 00       	mov    $0x111d20,%eax
  1009bd:	2d 00 00 10 00       	sub    $0x100000,%eax
  1009c2:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009c7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009cd:	85 c0                	test   %eax,%eax
  1009cf:	0f 48 c2             	cmovs  %edx,%eax
  1009d2:	c1 f8 0a             	sar    $0xa,%eax
  1009d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d9:	c7 04 24 fc 38 10 00 	movl   $0x1038fc,(%esp)
  1009e0:	e8 aa f8 ff ff       	call   10028f <cprintf>
}
  1009e5:	90                   	nop
  1009e6:	c9                   	leave  
  1009e7:	c3                   	ret    

001009e8 <print_debuginfo>:
 * read and print the stat info for the address @eip,
 * 
 * 'info.eip_fn_addr' should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009e8:	f3 0f 1e fb          	endbr32 
  1009ec:	55                   	push   %ebp
  1009ed:	89 e5                	mov    %esp,%ebp
  1009ef:	81 ec 48 01 00 00    	sub    $0x148,%esp
    //当前所在函数进一步调用其他函数的语句在源代码文件中的行号
    //一类数值表示从该函数汇编代码的入口处到进一步调用其他函数的call指令的最后一个字节的偏移量，以字节为单位
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009f5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1009ff:	89 04 24             	mov    %eax,(%esp)
  100a02:	e8 21 fc ff ff       	call   100628 <debuginfo_eip>
  100a07:	85 c0                	test   %eax,%eax
  100a09:	74 15                	je     100a20 <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a12:	c7 04 24 26 39 10 00 	movl   $0x103926,(%esp)
  100a19:	e8 71 f8 ff ff       	call   10028f <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a1e:	eb 6c                	jmp    100a8c <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a27:	eb 1b                	jmp    100a44 <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
  100a29:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a2f:	01 d0                	add    %edx,%eax
  100a31:	0f b6 10             	movzbl (%eax),%edx
  100a34:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a3d:	01 c8                	add    %ecx,%eax
  100a3f:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a41:	ff 45 f4             	incl   -0xc(%ebp)
  100a44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a47:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a4a:	7c dd                	jl     100a29 <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a4c:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a55:	01 d0                	add    %edx,%eax
  100a57:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a5d:	8b 55 08             	mov    0x8(%ebp),%edx
  100a60:	89 d1                	mov    %edx,%ecx
  100a62:	29 c1                	sub    %eax,%ecx
  100a64:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a67:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a6a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a6e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a74:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a78:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a80:	c7 04 24 42 39 10 00 	movl   $0x103942,(%esp)
  100a87:	e8 03 f8 ff ff       	call   10028f <cprintf>
}
  100a8c:	90                   	nop
  100a8d:	c9                   	leave  
  100a8e:	c3                   	ret    

00100a8f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a8f:	f3 0f 1e fb          	endbr32 
  100a93:	55                   	push   %ebp
  100a94:	89 e5                	mov    %esp,%ebp
  100a96:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a99:	8b 45 04             	mov    0x4(%ebp),%eax
  100a9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100aa2:	c9                   	leave  
  100aa3:	c3                   	ret    

00100aa4 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100aa4:	f3 0f 1e fb          	endbr32 
  100aa8:	55                   	push   %ebp
  100aa9:	89 e5                	mov    %esp,%ebp
  100aab:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100aae:	89 e8                	mov    %ebp,%eax
  100ab0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100ab3:	8b 45 e0             	mov    -0x20(%ebp),%eax
    //ebp是第一个被调用函数的栈帧的base pointer，
    //eip是在该栈帧对应函数中调用下一个栈帧对应函数的指令的下一条指令的地址（return address）
    //args是传递给这第一个被调用的函数的参数

    // get ebp and eip
    uint32_t ebp = read_ebp(), eip = read_eip();
  100ab6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100ab9:	e8 d1 ff ff ff       	call   100a8f <read_eip>
  100abe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // traverse all
    for(int i=0,j=0; ebp!=0 && i<STACKFRAME_DEPTH;i++){
  100ac1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100ac8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100acf:	e9 84 00 00 00       	jmp    100b58 <print_stackframe+0xb4>
        //print ebp & eip
        cprintf("ebp:0x%08x eip:0x%08x args:",ebp,eip);
  100ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ad7:	89 44 24 08          	mov    %eax,0x8(%esp)
  100adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ade:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ae2:	c7 04 24 54 39 10 00 	movl   $0x103954,(%esp)
  100ae9:	e8 a1 f7 ff ff       	call   10028f <cprintf>
        //print args
        // +1 -> 返回地址
        // +2 -> 参数
        uint32_t *args =(uint32_t*)ebp+2;
  100aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100af1:	83 c0 08             	add    $0x8,%eax
  100af4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for(j=0;j<4;j++){
  100af7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100afe:	eb 24                	jmp    100b24 <print_stackframe+0x80>
            cprintf("0x%08x ",args[j]);
  100b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b03:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100b0d:	01 d0                	add    %edx,%eax
  100b0f:	8b 00                	mov    (%eax),%eax
  100b11:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b15:	c7 04 24 70 39 10 00 	movl   $0x103970,(%esp)
  100b1c:	e8 6e f7 ff ff       	call   10028f <cprintf>
        for(j=0;j<4;j++){
  100b21:	ff 45 e8             	incl   -0x18(%ebp)
  100b24:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100b28:	7e d6                	jle    100b00 <print_stackframe+0x5c>
        }
        cprintf("\n");
  100b2a:	c7 04 24 78 39 10 00 	movl   $0x103978,(%esp)
  100b31:	e8 59 f7 ff ff       	call   10028f <cprintf>
        // print the C calling function name and line number, etc
        print_debuginfo(eip - 1);
  100b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b39:	48                   	dec    %eax
  100b3a:	89 04 24             	mov    %eax,(%esp)
  100b3d:	e8 a6 fe ff ff       	call   1009e8 <print_debuginfo>
        // get next func call
        // popup a calling stackframe
        // the calling funciton's return addr eip  = ss:[ebp+4]
        // the calling funciton's ebp = ss:[ebp]
        eip = ((uint32_t *)ebp)[1];
  100b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b45:	83 c0 04             	add    $0x4,%eax
  100b48:	8b 00                	mov    (%eax),%eax
  100b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b50:	8b 00                	mov    (%eax),%eax
  100b52:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(int i=0,j=0; ebp!=0 && i<STACKFRAME_DEPTH;i++){
  100b55:	ff 45 ec             	incl   -0x14(%ebp)
  100b58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b5c:	74 0a                	je     100b68 <print_stackframe+0xc4>
  100b5e:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b62:	0f 8e 6c ff ff ff    	jle    100ad4 <print_stackframe+0x30>
    }
}
  100b68:	90                   	nop
  100b69:	c9                   	leave  
  100b6a:	c3                   	ret    

00100b6b <parse>:
/*  parse
 *  do
 *      parse the command buffer into whitespace-separated arguments
 */
static int
parse(char *buf, char **argv) {
  100b6b:	f3 0f 1e fb          	endbr32 
  100b6f:	55                   	push   %ebp
  100b70:	89 e5                	mov    %esp,%ebp
  100b72:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b7c:	eb 0c                	jmp    100b8a <parse+0x1f>
            *buf ++ = '\0';
  100b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b81:	8d 50 01             	lea    0x1(%eax),%edx
  100b84:	89 55 08             	mov    %edx,0x8(%ebp)
  100b87:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b8d:	0f b6 00             	movzbl (%eax),%eax
  100b90:	84 c0                	test   %al,%al
  100b92:	74 1d                	je     100bb1 <parse+0x46>
  100b94:	8b 45 08             	mov    0x8(%ebp),%eax
  100b97:	0f b6 00             	movzbl (%eax),%eax
  100b9a:	0f be c0             	movsbl %al,%eax
  100b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ba1:	c7 04 24 fc 39 10 00 	movl   $0x1039fc,(%esp)
  100ba8:	e8 df 21 00 00       	call   102d8c <strchr>
  100bad:	85 c0                	test   %eax,%eax
  100baf:	75 cd                	jne    100b7e <parse+0x13>
        }
        if (*buf == '\0') {
  100bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb4:	0f b6 00             	movzbl (%eax),%eax
  100bb7:	84 c0                	test   %al,%al
  100bb9:	74 65                	je     100c20 <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100bbb:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100bbf:	75 14                	jne    100bd5 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100bc1:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100bc8:	00 
  100bc9:	c7 04 24 01 3a 10 00 	movl   $0x103a01,(%esp)
  100bd0:	e8 ba f6 ff ff       	call   10028f <cprintf>
        }
        argv[argc ++] = buf;
  100bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bd8:	8d 50 01             	lea    0x1(%eax),%edx
  100bdb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100bde:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100be5:	8b 45 0c             	mov    0xc(%ebp),%eax
  100be8:	01 c2                	add    %eax,%edx
  100bea:	8b 45 08             	mov    0x8(%ebp),%eax
  100bed:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bef:	eb 03                	jmp    100bf4 <parse+0x89>
            buf ++;
  100bf1:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf7:	0f b6 00             	movzbl (%eax),%eax
  100bfa:	84 c0                	test   %al,%al
  100bfc:	74 8c                	je     100b8a <parse+0x1f>
  100bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  100c01:	0f b6 00             	movzbl (%eax),%eax
  100c04:	0f be c0             	movsbl %al,%eax
  100c07:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c0b:	c7 04 24 fc 39 10 00 	movl   $0x1039fc,(%esp)
  100c12:	e8 75 21 00 00       	call   102d8c <strchr>
  100c17:	85 c0                	test   %eax,%eax
  100c19:	74 d6                	je     100bf1 <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c1b:	e9 6a ff ff ff       	jmp    100b8a <parse+0x1f>
            break;
  100c20:	90                   	nop
        }
    }
    return argc;
  100c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c24:	c9                   	leave  
  100c25:	c3                   	ret    

00100c26 <runcmd>:
 *  do
 *      1.  parse the input string and split it into separated arguments
 *      2.  lookup and invoke some related commands
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c26:	f3 0f 1e fb          	endbr32 
  100c2a:	55                   	push   %ebp
  100c2b:	89 e5                	mov    %esp,%ebp
  100c2d:	53                   	push   %ebx
  100c2e:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c31:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c34:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c38:	8b 45 08             	mov    0x8(%ebp),%eax
  100c3b:	89 04 24             	mov    %eax,(%esp)
  100c3e:	e8 28 ff ff ff       	call   100b6b <parse>
  100c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c4a:	75 0a                	jne    100c56 <runcmd+0x30>
        return 0;
  100c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  100c51:	e9 83 00 00 00       	jmp    100cd9 <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c5d:	eb 5a                	jmp    100cb9 <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c5f:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c65:	89 d0                	mov    %edx,%eax
  100c67:	01 c0                	add    %eax,%eax
  100c69:	01 d0                	add    %edx,%eax
  100c6b:	c1 e0 02             	shl    $0x2,%eax
  100c6e:	05 00 00 11 00       	add    $0x110000,%eax
  100c73:	8b 00                	mov    (%eax),%eax
  100c75:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c79:	89 04 24             	mov    %eax,(%esp)
  100c7c:	e8 67 20 00 00       	call   102ce8 <strcmp>
  100c81:	85 c0                	test   %eax,%eax
  100c83:	75 31                	jne    100cb6 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c88:	89 d0                	mov    %edx,%eax
  100c8a:	01 c0                	add    %eax,%eax
  100c8c:	01 d0                	add    %edx,%eax
  100c8e:	c1 e0 02             	shl    $0x2,%eax
  100c91:	05 08 00 11 00       	add    $0x110008,%eax
  100c96:	8b 10                	mov    (%eax),%edx
  100c98:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c9b:	83 c0 04             	add    $0x4,%eax
  100c9e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100ca1:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100ca4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100ca7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100cab:	89 44 24 04          	mov    %eax,0x4(%esp)
  100caf:	89 1c 24             	mov    %ebx,(%esp)
  100cb2:	ff d2                	call   *%edx
  100cb4:	eb 23                	jmp    100cd9 <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100cb6:	ff 45 f4             	incl   -0xc(%ebp)
  100cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cbc:	83 f8 02             	cmp    $0x2,%eax
  100cbf:	76 9e                	jbe    100c5f <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100cc1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100cc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cc8:	c7 04 24 1f 3a 10 00 	movl   $0x103a1f,(%esp)
  100ccf:	e8 bb f5 ff ff       	call   10028f <cprintf>
    return 0;
  100cd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cd9:	83 c4 64             	add    $0x64,%esp
  100cdc:	5b                   	pop    %ebx
  100cdd:	5d                   	pop    %ebp
  100cde:	c3                   	ret    

00100cdf <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/
void
kmonitor(struct trapframe *tf) {
  100cdf:	f3 0f 1e fb          	endbr32 
  100ce3:	55                   	push   %ebp
  100ce4:	89 e5                	mov    %esp,%ebp
  100ce6:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100ce9:	c7 04 24 38 3a 10 00 	movl   $0x103a38,(%esp)
  100cf0:	e8 9a f5 ff ff       	call   10028f <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100cf5:	c7 04 24 60 3a 10 00 	movl   $0x103a60,(%esp)
  100cfc:	e8 8e f5 ff ff       	call   10028f <cprintf>

    if (tf != NULL) {
  100d01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d05:	74 0b                	je     100d12 <kmonitor+0x33>
        print_trapframe(tf);
  100d07:	8b 45 08             	mov    0x8(%ebp),%eax
  100d0a:	89 04 24             	mov    %eax,(%esp)
  100d0d:	e8 7c 0e 00 00       	call   101b8e <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d12:	c7 04 24 85 3a 10 00 	movl   $0x103a85,(%esp)
  100d19:	e8 24 f6 ff ff       	call   100342 <readline>
  100d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d25:	74 eb                	je     100d12 <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100d27:	8b 45 08             	mov    0x8(%ebp),%eax
  100d2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d31:	89 04 24             	mov    %eax,(%esp)
  100d34:	e8 ed fe ff ff       	call   100c26 <runcmd>
  100d39:	85 c0                	test   %eax,%eax
  100d3b:	78 02                	js     100d3f <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100d3d:	eb d3                	jmp    100d12 <kmonitor+0x33>
                break;
  100d3f:	90                   	nop
            }
        }
    }
}
  100d40:	90                   	nop
  100d41:	c9                   	leave  
  100d42:	c3                   	ret    

00100d43 <mon_help>:
 *  mon_help
 *  do
 *      print the information about mon_* functions
 * */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d43:	f3 0f 1e fb          	endbr32 
  100d47:	55                   	push   %ebp
  100d48:	89 e5                	mov    %esp,%ebp
  100d4a:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d54:	eb 3d                	jmp    100d93 <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d59:	89 d0                	mov    %edx,%eax
  100d5b:	01 c0                	add    %eax,%eax
  100d5d:	01 d0                	add    %edx,%eax
  100d5f:	c1 e0 02             	shl    $0x2,%eax
  100d62:	05 04 00 11 00       	add    $0x110004,%eax
  100d67:	8b 08                	mov    (%eax),%ecx
  100d69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d6c:	89 d0                	mov    %edx,%eax
  100d6e:	01 c0                	add    %eax,%eax
  100d70:	01 d0                	add    %edx,%eax
  100d72:	c1 e0 02             	shl    $0x2,%eax
  100d75:	05 00 00 11 00       	add    $0x110000,%eax
  100d7a:	8b 00                	mov    (%eax),%eax
  100d7c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d80:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d84:	c7 04 24 89 3a 10 00 	movl   $0x103a89,(%esp)
  100d8b:	e8 ff f4 ff ff       	call   10028f <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d90:	ff 45 f4             	incl   -0xc(%ebp)
  100d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d96:	83 f8 02             	cmp    $0x2,%eax
  100d99:	76 bb                	jbe    100d56 <mon_help+0x13>
    }
    return 0;
  100d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100da0:	c9                   	leave  
  100da1:	c3                   	ret    

00100da2 <mon_kerninfo>:
 *  do
 *      print the memory occupancy in kernel 
 *      by calling print_kerninfo(kern/debug/kdebug.c)
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100da2:	f3 0f 1e fb          	endbr32 
  100da6:	55                   	push   %ebp
  100da7:	89 e5                	mov    %esp,%ebp
  100da9:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100dac:	e8 a1 fb ff ff       	call   100952 <print_kerninfo>
    return 0;
  100db1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100db6:	c9                   	leave  
  100db7:	c3                   	ret    

00100db8 <mon_backtrace>:
 *  do
 *      to print a backtrace of the stack
 *      by calling print_stackframe(kern/debug/kdebug.c)
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100db8:	f3 0f 1e fb          	endbr32 
  100dbc:	55                   	push   %ebp
  100dbd:	89 e5                	mov    %esp,%ebp
  100dbf:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100dc2:	e8 dd fc ff ff       	call   100aa4 <print_stackframe>
    return 0;
  100dc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dcc:	c9                   	leave  
  100dcd:	c3                   	ret    

00100dce <clock_init>:
/* *
 * clock_init
 * initialize 8253 clock to interrupt 100 times per second, and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100dce:	f3 0f 1e fb          	endbr32 
  100dd2:	55                   	push   %ebp
  100dd3:	89 e5                	mov    %esp,%ebp
  100dd5:	83 ec 28             	sub    $0x28,%esp
  100dd8:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100dde:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100de2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100de6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dea:	ee                   	out    %al,(%dx)
}
  100deb:	90                   	nop
  100dec:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100df2:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100df6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dfa:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dfe:	ee                   	out    %al,(%dx)
}
  100dff:	90                   	nop
  100e00:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100e06:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e0a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e0e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e12:	ee                   	out    %al,(%dx)
}
  100e13:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e14:	c7 05 08 19 11 00 00 	movl   $0x0,0x111908
  100e1b:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e1e:	c7 04 24 92 3a 10 00 	movl   $0x103a92,(%esp)
  100e25:	e8 65 f4 ff ff       	call   10028f <cprintf>
    pic_enable(IRQ_TIMER);
  100e2a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e31:	e8 31 09 00 00       	call   101767 <pic_enable>
}
  100e36:	90                   	nop
  100e37:	c9                   	leave  
  100e38:	c3                   	ret    

00100e39 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e39:	f3 0f 1e fb          	endbr32 
  100e3d:	55                   	push   %ebp
  100e3e:	89 e5                	mov    %esp,%ebp
  100e40:	83 ec 10             	sub    $0x10,%esp
  100e43:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e49:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e4d:	89 c2                	mov    %eax,%edx
  100e4f:	ec                   	in     (%dx),%al
  100e50:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e53:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e59:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e5d:	89 c2                	mov    %eax,%edx
  100e5f:	ec                   	in     (%dx),%al
  100e60:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e63:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e69:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e6d:	89 c2                	mov    %eax,%edx
  100e6f:	ec                   	in     (%dx),%al
  100e70:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e73:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e79:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e7d:	89 c2                	mov    %eax,%edx
  100e7f:	ec                   	in     (%dx),%al
  100e80:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e83:	90                   	nop
  100e84:	c9                   	leave  
  100e85:	c3                   	ret    

00100e86 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e86:	f3 0f 1e fb          	endbr32 
  100e8a:	55                   	push   %ebp
  100e8b:	89 e5                	mov    %esp,%ebp
  100e8d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e90:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e9a:	0f b7 00             	movzwl (%eax),%eax
  100e9d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100ea1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea4:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100ea9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eac:	0f b7 00             	movzwl (%eax),%eax
  100eaf:	0f b7 c0             	movzwl %ax,%eax
  100eb2:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100eb7:	74 12                	je     100ecb <cga_init+0x45>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100eb9:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100ec0:	66 c7 05 66 0e 11 00 	movw   $0x3b4,0x110e66
  100ec7:	b4 03 
  100ec9:	eb 13                	jmp    100ede <cga_init+0x58>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100ecb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ece:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ed2:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100ed5:	66 c7 05 66 0e 11 00 	movw   $0x3d4,0x110e66
  100edc:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100ede:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100ee5:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100ee9:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eed:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ef1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ef5:	ee                   	out    %al,(%dx)
}
  100ef6:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100ef7:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100efe:	40                   	inc    %eax
  100eff:	0f b7 c0             	movzwl %ax,%eax
  100f02:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f06:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f0a:	89 c2                	mov    %eax,%edx
  100f0c:	ec                   	in     (%dx),%al
  100f0d:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f10:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f14:	0f b6 c0             	movzbl %al,%eax
  100f17:	c1 e0 08             	shl    $0x8,%eax
  100f1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f1d:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f24:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f28:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f2c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f30:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f34:	ee                   	out    %al,(%dx)
}
  100f35:	90                   	nop
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100f36:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f3d:	40                   	inc    %eax
  100f3e:	0f b7 c0             	movzwl %ax,%eax
  100f41:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f45:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f49:	89 c2                	mov    %eax,%edx
  100f4b:	ec                   	in     (%dx),%al
  100f4c:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f4f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f53:	0f b6 c0             	movzbl %al,%eax
  100f56:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f5c:	a3 60 0e 11 00       	mov    %eax,0x110e60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f64:	0f b7 c0             	movzwl %ax,%eax
  100f67:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
}
  100f6d:	90                   	nop
  100f6e:	c9                   	leave  
  100f6f:	c3                   	ret    

00100f70 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f70:	f3 0f 1e fb          	endbr32 
  100f74:	55                   	push   %ebp
  100f75:	89 e5                	mov    %esp,%ebp
  100f77:	83 ec 48             	sub    $0x48,%esp
  100f7a:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f80:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f84:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f88:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f8c:	ee                   	out    %al,(%dx)
}
  100f8d:	90                   	nop
  100f8e:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f94:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f98:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f9c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100fa0:	ee                   	out    %al,(%dx)
}
  100fa1:	90                   	nop
  100fa2:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100fa8:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fac:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100fb0:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fb4:	ee                   	out    %al,(%dx)
}
  100fb5:	90                   	nop
  100fb6:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fbc:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fc0:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fc4:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fc8:	ee                   	out    %al,(%dx)
}
  100fc9:	90                   	nop
  100fca:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100fd0:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fd4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fd8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fdc:	ee                   	out    %al,(%dx)
}
  100fdd:	90                   	nop
  100fde:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100fe4:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fe8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fec:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ff0:	ee                   	out    %al,(%dx)
}
  100ff1:	90                   	nop
  100ff2:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100ff8:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ffc:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101000:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101004:	ee                   	out    %al,(%dx)
}
  101005:	90                   	nop
  101006:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10100c:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  101010:	89 c2                	mov    %eax,%edx
  101012:	ec                   	in     (%dx),%al
  101013:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101016:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10101a:	3c ff                	cmp    $0xff,%al
  10101c:	0f 95 c0             	setne  %al
  10101f:	0f b6 c0             	movzbl %al,%eax
  101022:	a3 68 0e 11 00       	mov    %eax,0x110e68
  101027:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10102d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101031:	89 c2                	mov    %eax,%edx
  101033:	ec                   	in     (%dx),%al
  101034:	88 45 f1             	mov    %al,-0xf(%ebp)
  101037:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10103d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101041:	89 c2                	mov    %eax,%edx
  101043:	ec                   	in     (%dx),%al
  101044:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101047:	a1 68 0e 11 00       	mov    0x110e68,%eax
  10104c:	85 c0                	test   %eax,%eax
  10104e:	74 0c                	je     10105c <serial_init+0xec>
        pic_enable(IRQ_COM1);
  101050:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101057:	e8 0b 07 00 00       	call   101767 <pic_enable>
    }
}
  10105c:	90                   	nop
  10105d:	c9                   	leave  
  10105e:	c3                   	ret    

0010105f <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10105f:	f3 0f 1e fb          	endbr32 
  101063:	55                   	push   %ebp
  101064:	89 e5                	mov    %esp,%ebp
  101066:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101069:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101070:	eb 08                	jmp    10107a <lpt_putc_sub+0x1b>
        delay();
  101072:	e8 c2 fd ff ff       	call   100e39 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101077:	ff 45 fc             	incl   -0x4(%ebp)
  10107a:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101080:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101084:	89 c2                	mov    %eax,%edx
  101086:	ec                   	in     (%dx),%al
  101087:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10108a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10108e:	84 c0                	test   %al,%al
  101090:	78 09                	js     10109b <lpt_putc_sub+0x3c>
  101092:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101099:	7e d7                	jle    101072 <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  10109b:	8b 45 08             	mov    0x8(%ebp),%eax
  10109e:	0f b6 c0             	movzbl %al,%eax
  1010a1:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  1010a7:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010aa:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010ae:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010b2:	ee                   	out    %al,(%dx)
}
  1010b3:	90                   	nop
  1010b4:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010ba:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010be:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010c2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010c6:	ee                   	out    %al,(%dx)
}
  1010c7:	90                   	nop
  1010c8:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010ce:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010d2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010d6:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010da:	ee                   	out    %al,(%dx)
}
  1010db:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010dc:	90                   	nop
  1010dd:	c9                   	leave  
  1010de:	c3                   	ret    

001010df <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010df:	f3 0f 1e fb          	endbr32 
  1010e3:	55                   	push   %ebp
  1010e4:	89 e5                	mov    %esp,%ebp
  1010e6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010e9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010ed:	74 0d                	je     1010fc <lpt_putc+0x1d>
        lpt_putc_sub(c);
  1010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f2:	89 04 24             	mov    %eax,(%esp)
  1010f5:	e8 65 ff ff ff       	call   10105f <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010fa:	eb 24                	jmp    101120 <lpt_putc+0x41>
        lpt_putc_sub('\b');
  1010fc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101103:	e8 57 ff ff ff       	call   10105f <lpt_putc_sub>
        lpt_putc_sub(' ');
  101108:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10110f:	e8 4b ff ff ff       	call   10105f <lpt_putc_sub>
        lpt_putc_sub('\b');
  101114:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10111b:	e8 3f ff ff ff       	call   10105f <lpt_putc_sub>
}
  101120:	90                   	nop
  101121:	c9                   	leave  
  101122:	c3                   	ret    

00101123 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101123:	f3 0f 1e fb          	endbr32 
  101127:	55                   	push   %ebp
  101128:	89 e5                	mov    %esp,%ebp
  10112a:	53                   	push   %ebx
  10112b:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10112e:	8b 45 08             	mov    0x8(%ebp),%eax
  101131:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101136:	85 c0                	test   %eax,%eax
  101138:	75 07                	jne    101141 <cga_putc+0x1e>
        c |= 0x0700;
  10113a:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101141:	8b 45 08             	mov    0x8(%ebp),%eax
  101144:	0f b6 c0             	movzbl %al,%eax
  101147:	83 f8 0d             	cmp    $0xd,%eax
  10114a:	74 72                	je     1011be <cga_putc+0x9b>
  10114c:	83 f8 0d             	cmp    $0xd,%eax
  10114f:	0f 8f a3 00 00 00    	jg     1011f8 <cga_putc+0xd5>
  101155:	83 f8 08             	cmp    $0x8,%eax
  101158:	74 0a                	je     101164 <cga_putc+0x41>
  10115a:	83 f8 0a             	cmp    $0xa,%eax
  10115d:	74 4c                	je     1011ab <cga_putc+0x88>
  10115f:	e9 94 00 00 00       	jmp    1011f8 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  101164:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  10116b:	85 c0                	test   %eax,%eax
  10116d:	0f 84 af 00 00 00    	je     101222 <cga_putc+0xff>
            crt_pos --;
  101173:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  10117a:	48                   	dec    %eax
  10117b:	0f b7 c0             	movzwl %ax,%eax
  10117e:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101184:	8b 45 08             	mov    0x8(%ebp),%eax
  101187:	98                   	cwtl   
  101188:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10118d:	98                   	cwtl   
  10118e:	83 c8 20             	or     $0x20,%eax
  101191:	98                   	cwtl   
  101192:	8b 15 60 0e 11 00    	mov    0x110e60,%edx
  101198:	0f b7 0d 64 0e 11 00 	movzwl 0x110e64,%ecx
  10119f:	01 c9                	add    %ecx,%ecx
  1011a1:	01 ca                	add    %ecx,%edx
  1011a3:	0f b7 c0             	movzwl %ax,%eax
  1011a6:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011a9:	eb 77                	jmp    101222 <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  1011ab:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1011b2:	83 c0 50             	add    $0x50,%eax
  1011b5:	0f b7 c0             	movzwl %ax,%eax
  1011b8:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011be:	0f b7 1d 64 0e 11 00 	movzwl 0x110e64,%ebx
  1011c5:	0f b7 0d 64 0e 11 00 	movzwl 0x110e64,%ecx
  1011cc:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1011d1:	89 c8                	mov    %ecx,%eax
  1011d3:	f7 e2                	mul    %edx
  1011d5:	c1 ea 06             	shr    $0x6,%edx
  1011d8:	89 d0                	mov    %edx,%eax
  1011da:	c1 e0 02             	shl    $0x2,%eax
  1011dd:	01 d0                	add    %edx,%eax
  1011df:	c1 e0 04             	shl    $0x4,%eax
  1011e2:	29 c1                	sub    %eax,%ecx
  1011e4:	89 c8                	mov    %ecx,%eax
  1011e6:	0f b7 c0             	movzwl %ax,%eax
  1011e9:	29 c3                	sub    %eax,%ebx
  1011eb:	89 d8                	mov    %ebx,%eax
  1011ed:	0f b7 c0             	movzwl %ax,%eax
  1011f0:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
        break;
  1011f6:	eb 2b                	jmp    101223 <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011f8:	8b 0d 60 0e 11 00    	mov    0x110e60,%ecx
  1011fe:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101205:	8d 50 01             	lea    0x1(%eax),%edx
  101208:	0f b7 d2             	movzwl %dx,%edx
  10120b:	66 89 15 64 0e 11 00 	mov    %dx,0x110e64
  101212:	01 c0                	add    %eax,%eax
  101214:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101217:	8b 45 08             	mov    0x8(%ebp),%eax
  10121a:	0f b7 c0             	movzwl %ax,%eax
  10121d:	66 89 02             	mov    %ax,(%edx)
        break;
  101220:	eb 01                	jmp    101223 <cga_putc+0x100>
        break;
  101222:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101223:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  10122a:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  10122f:	76 5d                	jbe    10128e <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101231:	a1 60 0e 11 00       	mov    0x110e60,%eax
  101236:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10123c:	a1 60 0e 11 00       	mov    0x110e60,%eax
  101241:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101248:	00 
  101249:	89 54 24 04          	mov    %edx,0x4(%esp)
  10124d:	89 04 24             	mov    %eax,(%esp)
  101250:	e8 3c 1d 00 00       	call   102f91 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101255:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10125c:	eb 14                	jmp    101272 <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  10125e:	a1 60 0e 11 00       	mov    0x110e60,%eax
  101263:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101266:	01 d2                	add    %edx,%edx
  101268:	01 d0                	add    %edx,%eax
  10126a:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10126f:	ff 45 f4             	incl   -0xc(%ebp)
  101272:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101279:	7e e3                	jle    10125e <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  10127b:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101282:	83 e8 50             	sub    $0x50,%eax
  101285:	0f b7 c0             	movzwl %ax,%eax
  101288:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10128e:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  101295:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101299:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10129d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012a1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012a5:	ee                   	out    %al,(%dx)
}
  1012a6:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  1012a7:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1012ae:	c1 e8 08             	shr    $0x8,%eax
  1012b1:	0f b7 c0             	movzwl %ax,%eax
  1012b4:	0f b6 c0             	movzbl %al,%eax
  1012b7:	0f b7 15 66 0e 11 00 	movzwl 0x110e66,%edx
  1012be:	42                   	inc    %edx
  1012bf:	0f b7 d2             	movzwl %dx,%edx
  1012c2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012c6:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012c9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012cd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012d1:	ee                   	out    %al,(%dx)
}
  1012d2:	90                   	nop
    outb(addr_6845, 15);
  1012d3:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  1012da:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012de:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012e2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012e6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012ea:	ee                   	out    %al,(%dx)
}
  1012eb:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  1012ec:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1012f3:	0f b6 c0             	movzbl %al,%eax
  1012f6:	0f b7 15 66 0e 11 00 	movzwl 0x110e66,%edx
  1012fd:	42                   	inc    %edx
  1012fe:	0f b7 d2             	movzwl %dx,%edx
  101301:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101305:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101308:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10130c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101310:	ee                   	out    %al,(%dx)
}
  101311:	90                   	nop
}
  101312:	90                   	nop
  101313:	83 c4 34             	add    $0x34,%esp
  101316:	5b                   	pop    %ebx
  101317:	5d                   	pop    %ebp
  101318:	c3                   	ret    

00101319 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101319:	f3 0f 1e fb          	endbr32 
  10131d:	55                   	push   %ebp
  10131e:	89 e5                	mov    %esp,%ebp
  101320:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101323:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10132a:	eb 08                	jmp    101334 <serial_putc_sub+0x1b>
        delay();
  10132c:	e8 08 fb ff ff       	call   100e39 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101331:	ff 45 fc             	incl   -0x4(%ebp)
  101334:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10133a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10133e:	89 c2                	mov    %eax,%edx
  101340:	ec                   	in     (%dx),%al
  101341:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101344:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101348:	0f b6 c0             	movzbl %al,%eax
  10134b:	83 e0 20             	and    $0x20,%eax
  10134e:	85 c0                	test   %eax,%eax
  101350:	75 09                	jne    10135b <serial_putc_sub+0x42>
  101352:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101359:	7e d1                	jle    10132c <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  10135b:	8b 45 08             	mov    0x8(%ebp),%eax
  10135e:	0f b6 c0             	movzbl %al,%eax
  101361:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101367:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10136a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10136e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101372:	ee                   	out    %al,(%dx)
}
  101373:	90                   	nop
}
  101374:	90                   	nop
  101375:	c9                   	leave  
  101376:	c3                   	ret    

00101377 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101377:	f3 0f 1e fb          	endbr32 
  10137b:	55                   	push   %ebp
  10137c:	89 e5                	mov    %esp,%ebp
  10137e:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101381:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101385:	74 0d                	je     101394 <serial_putc+0x1d>
        serial_putc_sub(c);
  101387:	8b 45 08             	mov    0x8(%ebp),%eax
  10138a:	89 04 24             	mov    %eax,(%esp)
  10138d:	e8 87 ff ff ff       	call   101319 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101392:	eb 24                	jmp    1013b8 <serial_putc+0x41>
        serial_putc_sub('\b');
  101394:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10139b:	e8 79 ff ff ff       	call   101319 <serial_putc_sub>
        serial_putc_sub(' ');
  1013a0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1013a7:	e8 6d ff ff ff       	call   101319 <serial_putc_sub>
        serial_putc_sub('\b');
  1013ac:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013b3:	e8 61 ff ff ff       	call   101319 <serial_putc_sub>
}
  1013b8:	90                   	nop
  1013b9:	c9                   	leave  
  1013ba:	c3                   	ret    

001013bb <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013bb:	f3 0f 1e fb          	endbr32 
  1013bf:	55                   	push   %ebp
  1013c0:	89 e5                	mov    %esp,%ebp
  1013c2:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013c5:	eb 33                	jmp    1013fa <cons_intr+0x3f>
        if (c != 0) {
  1013c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013cb:	74 2d                	je     1013fa <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  1013cd:	a1 84 10 11 00       	mov    0x111084,%eax
  1013d2:	8d 50 01             	lea    0x1(%eax),%edx
  1013d5:	89 15 84 10 11 00    	mov    %edx,0x111084
  1013db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013de:	88 90 80 0e 11 00    	mov    %dl,0x110e80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013e4:	a1 84 10 11 00       	mov    0x111084,%eax
  1013e9:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013ee:	75 0a                	jne    1013fa <cons_intr+0x3f>
                cons.wpos = 0;
  1013f0:	c7 05 84 10 11 00 00 	movl   $0x0,0x111084
  1013f7:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1013fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1013fd:	ff d0                	call   *%eax
  1013ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101402:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101406:	75 bf                	jne    1013c7 <cons_intr+0xc>
            }
        }
    }
}
  101408:	90                   	nop
  101409:	90                   	nop
  10140a:	c9                   	leave  
  10140b:	c3                   	ret    

0010140c <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10140c:	f3 0f 1e fb          	endbr32 
  101410:	55                   	push   %ebp
  101411:	89 e5                	mov    %esp,%ebp
  101413:	83 ec 10             	sub    $0x10,%esp
  101416:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10141c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101420:	89 c2                	mov    %eax,%edx
  101422:	ec                   	in     (%dx),%al
  101423:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101426:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10142a:	0f b6 c0             	movzbl %al,%eax
  10142d:	83 e0 01             	and    $0x1,%eax
  101430:	85 c0                	test   %eax,%eax
  101432:	75 07                	jne    10143b <serial_proc_data+0x2f>
        return -1;
  101434:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101439:	eb 2a                	jmp    101465 <serial_proc_data+0x59>
  10143b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101441:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101445:	89 c2                	mov    %eax,%edx
  101447:	ec                   	in     (%dx),%al
  101448:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10144b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10144f:	0f b6 c0             	movzbl %al,%eax
  101452:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101455:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101459:	75 07                	jne    101462 <serial_proc_data+0x56>
        c = '\b';
  10145b:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101462:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101465:	c9                   	leave  
  101466:	c3                   	ret    

00101467 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101467:	f3 0f 1e fb          	endbr32 
  10146b:	55                   	push   %ebp
  10146c:	89 e5                	mov    %esp,%ebp
  10146e:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101471:	a1 68 0e 11 00       	mov    0x110e68,%eax
  101476:	85 c0                	test   %eax,%eax
  101478:	74 0c                	je     101486 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  10147a:	c7 04 24 0c 14 10 00 	movl   $0x10140c,(%esp)
  101481:	e8 35 ff ff ff       	call   1013bb <cons_intr>
    }
}
  101486:	90                   	nop
  101487:	c9                   	leave  
  101488:	c3                   	ret    

00101489 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101489:	f3 0f 1e fb          	endbr32 
  10148d:	55                   	push   %ebp
  10148e:	89 e5                	mov    %esp,%ebp
  101490:	83 ec 38             	sub    $0x38,%esp
  101493:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101499:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10149c:	89 c2                	mov    %eax,%edx
  10149e:	ec                   	in     (%dx),%al
  10149f:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1014a2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014a6:	0f b6 c0             	movzbl %al,%eax
  1014a9:	83 e0 01             	and    $0x1,%eax
  1014ac:	85 c0                	test   %eax,%eax
  1014ae:	75 0a                	jne    1014ba <kbd_proc_data+0x31>
        return -1;
  1014b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014b5:	e9 56 01 00 00       	jmp    101610 <kbd_proc_data+0x187>
  1014ba:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1014c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1014c3:	89 c2                	mov    %eax,%edx
  1014c5:	ec                   	in     (%dx),%al
  1014c6:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014c9:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014cd:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014d0:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014d4:	75 17                	jne    1014ed <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  1014d6:	a1 88 10 11 00       	mov    0x111088,%eax
  1014db:	83 c8 40             	or     $0x40,%eax
  1014de:	a3 88 10 11 00       	mov    %eax,0x111088
        return 0;
  1014e3:	b8 00 00 00 00       	mov    $0x0,%eax
  1014e8:	e9 23 01 00 00       	jmp    101610 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  1014ed:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f1:	84 c0                	test   %al,%al
  1014f3:	79 45                	jns    10153a <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014f5:	a1 88 10 11 00       	mov    0x111088,%eax
  1014fa:	83 e0 40             	and    $0x40,%eax
  1014fd:	85 c0                	test   %eax,%eax
  1014ff:	75 08                	jne    101509 <kbd_proc_data+0x80>
  101501:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101505:	24 7f                	and    $0x7f,%al
  101507:	eb 04                	jmp    10150d <kbd_proc_data+0x84>
  101509:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10150d:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101510:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101514:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  10151b:	0c 40                	or     $0x40,%al
  10151d:	0f b6 c0             	movzbl %al,%eax
  101520:	f7 d0                	not    %eax
  101522:	89 c2                	mov    %eax,%edx
  101524:	a1 88 10 11 00       	mov    0x111088,%eax
  101529:	21 d0                	and    %edx,%eax
  10152b:	a3 88 10 11 00       	mov    %eax,0x111088
        return 0;
  101530:	b8 00 00 00 00       	mov    $0x0,%eax
  101535:	e9 d6 00 00 00       	jmp    101610 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  10153a:	a1 88 10 11 00       	mov    0x111088,%eax
  10153f:	83 e0 40             	and    $0x40,%eax
  101542:	85 c0                	test   %eax,%eax
  101544:	74 11                	je     101557 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101546:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10154a:	a1 88 10 11 00       	mov    0x111088,%eax
  10154f:	83 e0 bf             	and    $0xffffffbf,%eax
  101552:	a3 88 10 11 00       	mov    %eax,0x111088
    }

    shift |= shiftcode[data];
  101557:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10155b:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  101562:	0f b6 d0             	movzbl %al,%edx
  101565:	a1 88 10 11 00       	mov    0x111088,%eax
  10156a:	09 d0                	or     %edx,%eax
  10156c:	a3 88 10 11 00       	mov    %eax,0x111088
    shift ^= togglecode[data];
  101571:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101575:	0f b6 80 40 01 11 00 	movzbl 0x110140(%eax),%eax
  10157c:	0f b6 d0             	movzbl %al,%edx
  10157f:	a1 88 10 11 00       	mov    0x111088,%eax
  101584:	31 d0                	xor    %edx,%eax
  101586:	a3 88 10 11 00       	mov    %eax,0x111088

    c = charcode[shift & (CTL | SHIFT)][data];
  10158b:	a1 88 10 11 00       	mov    0x111088,%eax
  101590:	83 e0 03             	and    $0x3,%eax
  101593:	8b 14 85 40 05 11 00 	mov    0x110540(,%eax,4),%edx
  10159a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10159e:	01 d0                	add    %edx,%eax
  1015a0:	0f b6 00             	movzbl (%eax),%eax
  1015a3:	0f b6 c0             	movzbl %al,%eax
  1015a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015a9:	a1 88 10 11 00       	mov    0x111088,%eax
  1015ae:	83 e0 08             	and    $0x8,%eax
  1015b1:	85 c0                	test   %eax,%eax
  1015b3:	74 22                	je     1015d7 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1015b5:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015b9:	7e 0c                	jle    1015c7 <kbd_proc_data+0x13e>
  1015bb:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015bf:	7f 06                	jg     1015c7 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1015c1:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015c5:	eb 10                	jmp    1015d7 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1015c7:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015cb:	7e 0a                	jle    1015d7 <kbd_proc_data+0x14e>
  1015cd:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015d1:	7f 04                	jg     1015d7 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1015d3:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015d7:	a1 88 10 11 00       	mov    0x111088,%eax
  1015dc:	f7 d0                	not    %eax
  1015de:	83 e0 06             	and    $0x6,%eax
  1015e1:	85 c0                	test   %eax,%eax
  1015e3:	75 28                	jne    10160d <kbd_proc_data+0x184>
  1015e5:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015ec:	75 1f                	jne    10160d <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  1015ee:	c7 04 24 ad 3a 10 00 	movl   $0x103aad,(%esp)
  1015f5:	e8 95 ec ff ff       	call   10028f <cprintf>
  1015fa:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101600:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101604:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101608:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10160b:	ee                   	out    %al,(%dx)
}
  10160c:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10160d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101610:	c9                   	leave  
  101611:	c3                   	ret    

00101612 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101612:	f3 0f 1e fb          	endbr32 
  101616:	55                   	push   %ebp
  101617:	89 e5                	mov    %esp,%ebp
  101619:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10161c:	c7 04 24 89 14 10 00 	movl   $0x101489,(%esp)
  101623:	e8 93 fd ff ff       	call   1013bb <cons_intr>
}
  101628:	90                   	nop
  101629:	c9                   	leave  
  10162a:	c3                   	ret    

0010162b <kbd_init>:

static void
kbd_init(void) {
  10162b:	f3 0f 1e fb          	endbr32 
  10162f:	55                   	push   %ebp
  101630:	89 e5                	mov    %esp,%ebp
  101632:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101635:	e8 d8 ff ff ff       	call   101612 <kbd_intr>
    pic_enable(IRQ_KBD);
  10163a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101641:	e8 21 01 00 00       	call   101767 <pic_enable>
}
  101646:	90                   	nop
  101647:	c9                   	leave  
  101648:	c3                   	ret    

00101649 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101649:	f3 0f 1e fb          	endbr32 
  10164d:	55                   	push   %ebp
  10164e:	89 e5                	mov    %esp,%ebp
  101650:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101653:	e8 2e f8 ff ff       	call   100e86 <cga_init>
    serial_init();
  101658:	e8 13 f9 ff ff       	call   100f70 <serial_init>
    kbd_init();
  10165d:	e8 c9 ff ff ff       	call   10162b <kbd_init>
    if (!serial_exists) {
  101662:	a1 68 0e 11 00       	mov    0x110e68,%eax
  101667:	85 c0                	test   %eax,%eax
  101669:	75 0c                	jne    101677 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  10166b:	c7 04 24 b9 3a 10 00 	movl   $0x103ab9,(%esp)
  101672:	e8 18 ec ff ff       	call   10028f <cprintf>
    }
}
  101677:	90                   	nop
  101678:	c9                   	leave  
  101679:	c3                   	ret    

0010167a <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10167a:	f3 0f 1e fb          	endbr32 
  10167e:	55                   	push   %ebp
  10167f:	89 e5                	mov    %esp,%ebp
  101681:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101684:	8b 45 08             	mov    0x8(%ebp),%eax
  101687:	89 04 24             	mov    %eax,(%esp)
  10168a:	e8 50 fa ff ff       	call   1010df <lpt_putc>
    cga_putc(c);
  10168f:	8b 45 08             	mov    0x8(%ebp),%eax
  101692:	89 04 24             	mov    %eax,(%esp)
  101695:	e8 89 fa ff ff       	call   101123 <cga_putc>
    serial_putc(c);
  10169a:	8b 45 08             	mov    0x8(%ebp),%eax
  10169d:	89 04 24             	mov    %eax,(%esp)
  1016a0:	e8 d2 fc ff ff       	call   101377 <serial_putc>
}
  1016a5:	90                   	nop
  1016a6:	c9                   	leave  
  1016a7:	c3                   	ret    

001016a8 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1016a8:	f3 0f 1e fb          	endbr32 
  1016ac:	55                   	push   %ebp
  1016ad:	89 e5                	mov    %esp,%ebp
  1016af:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1016b2:	e8 b0 fd ff ff       	call   101467 <serial_intr>
    kbd_intr();
  1016b7:	e8 56 ff ff ff       	call   101612 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1016bc:	8b 15 80 10 11 00    	mov    0x111080,%edx
  1016c2:	a1 84 10 11 00       	mov    0x111084,%eax
  1016c7:	39 c2                	cmp    %eax,%edx
  1016c9:	74 36                	je     101701 <cons_getc+0x59>
        c = cons.buf[cons.rpos ++];
  1016cb:	a1 80 10 11 00       	mov    0x111080,%eax
  1016d0:	8d 50 01             	lea    0x1(%eax),%edx
  1016d3:	89 15 80 10 11 00    	mov    %edx,0x111080
  1016d9:	0f b6 80 80 0e 11 00 	movzbl 0x110e80(%eax),%eax
  1016e0:	0f b6 c0             	movzbl %al,%eax
  1016e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1016e6:	a1 80 10 11 00       	mov    0x111080,%eax
  1016eb:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016f0:	75 0a                	jne    1016fc <cons_getc+0x54>
            cons.rpos = 0;
  1016f2:	c7 05 80 10 11 00 00 	movl   $0x0,0x111080
  1016f9:	00 00 00 
        }
        return c;
  1016fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016ff:	eb 05                	jmp    101706 <cons_getc+0x5e>
    }
    return 0;
  101701:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101706:	c9                   	leave  
  101707:	c3                   	ret    

00101708 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101708:	f3 0f 1e fb          	endbr32 
  10170c:	55                   	push   %ebp
  10170d:	89 e5                	mov    %esp,%ebp
  10170f:	83 ec 14             	sub    $0x14,%esp
  101712:	8b 45 08             	mov    0x8(%ebp),%eax
  101715:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101719:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10171c:	66 a3 50 05 11 00    	mov    %ax,0x110550
    if (did_init) {
  101722:	a1 8c 10 11 00       	mov    0x11108c,%eax
  101727:	85 c0                	test   %eax,%eax
  101729:	74 39                	je     101764 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  10172b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10172e:	0f b6 c0             	movzbl %al,%eax
  101731:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101737:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10173a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10173e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101742:	ee                   	out    %al,(%dx)
}
  101743:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101744:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101748:	c1 e8 08             	shr    $0x8,%eax
  10174b:	0f b7 c0             	movzwl %ax,%eax
  10174e:	0f b6 c0             	movzbl %al,%eax
  101751:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101757:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10175a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10175e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101762:	ee                   	out    %al,(%dx)
}
  101763:	90                   	nop
    }
}
  101764:	90                   	nop
  101765:	c9                   	leave  
  101766:	c3                   	ret    

00101767 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101767:	f3 0f 1e fb          	endbr32 
  10176b:	55                   	push   %ebp
  10176c:	89 e5                	mov    %esp,%ebp
  10176e:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101771:	8b 45 08             	mov    0x8(%ebp),%eax
  101774:	ba 01 00 00 00       	mov    $0x1,%edx
  101779:	88 c1                	mov    %al,%cl
  10177b:	d3 e2                	shl    %cl,%edx
  10177d:	89 d0                	mov    %edx,%eax
  10177f:	98                   	cwtl   
  101780:	f7 d0                	not    %eax
  101782:	0f bf d0             	movswl %ax,%edx
  101785:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  10178c:	98                   	cwtl   
  10178d:	21 d0                	and    %edx,%eax
  10178f:	98                   	cwtl   
  101790:	0f b7 c0             	movzwl %ax,%eax
  101793:	89 04 24             	mov    %eax,(%esp)
  101796:	e8 6d ff ff ff       	call   101708 <pic_setmask>
}
  10179b:	90                   	nop
  10179c:	c9                   	leave  
  10179d:	c3                   	ret    

0010179e <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10179e:	f3 0f 1e fb          	endbr32 
  1017a2:	55                   	push   %ebp
  1017a3:	89 e5                	mov    %esp,%ebp
  1017a5:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017a8:	c7 05 8c 10 11 00 01 	movl   $0x1,0x11108c
  1017af:	00 00 00 
  1017b2:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1017b8:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017bc:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017c0:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017c4:	ee                   	out    %al,(%dx)
}
  1017c5:	90                   	nop
  1017c6:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1017cc:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017d0:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017d4:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017d8:	ee                   	out    %al,(%dx)
}
  1017d9:	90                   	nop
  1017da:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017e0:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017e4:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017e8:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017ec:	ee                   	out    %al,(%dx)
}
  1017ed:	90                   	nop
  1017ee:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1017f4:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017f8:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017fc:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101800:	ee                   	out    %al,(%dx)
}
  101801:	90                   	nop
  101802:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101808:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10180c:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101810:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101814:	ee                   	out    %al,(%dx)
}
  101815:	90                   	nop
  101816:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  10181c:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101820:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101824:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101828:	ee                   	out    %al,(%dx)
}
  101829:	90                   	nop
  10182a:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101830:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101834:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101838:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10183c:	ee                   	out    %al,(%dx)
}
  10183d:	90                   	nop
  10183e:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101844:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101848:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10184c:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101850:	ee                   	out    %al,(%dx)
}
  101851:	90                   	nop
  101852:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101858:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10185c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101860:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101864:	ee                   	out    %al,(%dx)
}
  101865:	90                   	nop
  101866:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10186c:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101870:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101874:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101878:	ee                   	out    %al,(%dx)
}
  101879:	90                   	nop
  10187a:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101880:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101884:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101888:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10188c:	ee                   	out    %al,(%dx)
}
  10188d:	90                   	nop
  10188e:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101894:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101898:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10189c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1018a0:	ee                   	out    %al,(%dx)
}
  1018a1:	90                   	nop
  1018a2:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1018a8:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018ac:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1018b0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1018b4:	ee                   	out    %al,(%dx)
}
  1018b5:	90                   	nop
  1018b6:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1018bc:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018c0:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1018c4:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1018c8:	ee                   	out    %al,(%dx)
}
  1018c9:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1018ca:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1018d1:	3d ff ff 00 00       	cmp    $0xffff,%eax
  1018d6:	74 0f                	je     1018e7 <pic_init+0x149>
        pic_setmask(irq_mask);
  1018d8:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1018df:	89 04 24             	mov    %eax,(%esp)
  1018e2:	e8 21 fe ff ff       	call   101708 <pic_setmask>
    }
}
  1018e7:	90                   	nop
  1018e8:	c9                   	leave  
  1018e9:	c3                   	ret    

001018ea <intr_enable>:
/*  intr_enable
 *  do
 *      enable irq interrupt
 */
void
intr_enable(void) {
  1018ea:	f3 0f 1e fb          	endbr32 
  1018ee:	55                   	push   %ebp
  1018ef:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1018f1:	fb                   	sti    
}
  1018f2:	90                   	nop
    sti();
}
  1018f3:	90                   	nop
  1018f4:	5d                   	pop    %ebp
  1018f5:	c3                   	ret    

001018f6 <intr_disable>:
/*  intr_disable
 *  do
 *      disable irq interrupt
 */
void
intr_disable(void) {
  1018f6:	f3 0f 1e fb          	endbr32 
  1018fa:	55                   	push   %ebp
  1018fb:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  1018fd:	fa                   	cli    
}
  1018fe:	90                   	nop
    cli();
}
  1018ff:	90                   	nop
  101900:	5d                   	pop    %ebp
  101901:	c3                   	ret    

00101902 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101902:	f3 0f 1e fb          	endbr32 
  101906:	55                   	push   %ebp
  101907:	89 e5                	mov    %esp,%ebp
  101909:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10190c:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101913:	00 
  101914:	c7 04 24 e0 3a 10 00 	movl   $0x103ae0,(%esp)
  10191b:	e8 6f e9 ff ff       	call   10028f <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101920:	c7 04 24 ea 3a 10 00 	movl   $0x103aea,(%esp)
  101927:	e8 63 e9 ff ff       	call   10028f <cprintf>
    panic("EOT: kernel seems ok.");
  10192c:	c7 44 24 08 f8 3a 10 	movl   $0x103af8,0x8(%esp)
  101933:	00 
  101934:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  10193b:	00 
  10193c:	c7 04 24 0e 3b 10 00 	movl   $0x103b0e,(%esp)
  101943:	e8 b3 ea ff ff       	call   1003fb <__panic>

00101948 <idt_init>:
/*  idt_init
 *  do
 *      initialize IDT to each of the entry points in kern/trap/vectors.S 
 * */
void
idt_init(void) {
  101948:	f3 0f 1e fb          	endbr32 
  10194c:	55                   	push   %ebp
  10194d:	89 e5                	mov    %esp,%ebp
  10194f:	83 ec 10             	sub    $0x10,%esp
    //然后使用lidt加载IDT即可，指令格式与LGDT类似；至此完成了中断描述符表的初始化过程；

    // entry adders of ISR(Interrupt Service Routine)
    extern uintptr_t __vectors[];
    // setup the entries of ISR in IDT(Interrupt Description Table)
    int n=sizeof(idt)/sizeof(struct gatedesc);
  101952:	c7 45 f8 00 01 00 00 	movl   $0x100,-0x8(%ebp)
    for(int i=0;i<n;i++){
  101959:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101960:	e9 c4 00 00 00       	jmp    101a29 <idt_init+0xe1>
        trap: 1 for a trap (= exception) gate, 0 for an interrupt gate
        sel: 段选择器
        off: 偏移
        dpl: 特权级
        * */
        SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
  101965:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101968:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  10196f:	0f b7 d0             	movzwl %ax,%edx
  101972:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101975:	66 89 14 c5 a0 10 11 	mov    %dx,0x1110a0(,%eax,8)
  10197c:	00 
  10197d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101980:	66 c7 04 c5 a2 10 11 	movw   $0x8,0x1110a2(,%eax,8)
  101987:	00 08 00 
  10198a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198d:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  101994:	00 
  101995:	80 e2 e0             	and    $0xe0,%dl
  101998:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  10199f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a2:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  1019a9:	00 
  1019aa:	80 e2 1f             	and    $0x1f,%dl
  1019ad:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  1019b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b7:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019be:	00 
  1019bf:	80 e2 f0             	and    $0xf0,%dl
  1019c2:	80 ca 0e             	or     $0xe,%dl
  1019c5:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019cf:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019d6:	00 
  1019d7:	80 e2 ef             	and    $0xef,%dl
  1019da:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e4:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019eb:	00 
  1019ec:	80 e2 9f             	and    $0x9f,%dl
  1019ef:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f9:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  101a00:	00 
  101a01:	80 ca 80             	or     $0x80,%dl
  101a04:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  101a0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a0e:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  101a15:	c1 e8 10             	shr    $0x10,%eax
  101a18:	0f b7 d0             	movzwl %ax,%edx
  101a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a1e:	66 89 14 c5 a6 10 11 	mov    %dx,0x1110a6(,%eax,8)
  101a25:	00 
    for(int i=0;i<n;i++){
  101a26:	ff 45 fc             	incl   -0x4(%ebp)
  101a29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a2c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  101a2f:	0f 8c 30 ff ff ff    	jl     101965 <idt_init+0x1d>
    }
    //系统调用中断
    //而ucore的应用程序处于特权级３，需要采用｀int 0x80`指令操作（软中断）来发出系统调用请求，并要能实现从特权级３到特权级０的转换
    //所以系统调用中断(T_SYSCALL)所对应的中断门描述符中的特权级（DPL）需要设置为３。
    SETGATE(idt[T_SYSCALL],1,GD_KTEXT,__vectors[T_SYSCALL],DPL_USER);
  101a35:	a1 e0 07 11 00       	mov    0x1107e0,%eax
  101a3a:	0f b7 c0             	movzwl %ax,%eax
  101a3d:	66 a3 a0 14 11 00    	mov    %ax,0x1114a0
  101a43:	66 c7 05 a2 14 11 00 	movw   $0x8,0x1114a2
  101a4a:	08 00 
  101a4c:	0f b6 05 a4 14 11 00 	movzbl 0x1114a4,%eax
  101a53:	24 e0                	and    $0xe0,%al
  101a55:	a2 a4 14 11 00       	mov    %al,0x1114a4
  101a5a:	0f b6 05 a4 14 11 00 	movzbl 0x1114a4,%eax
  101a61:	24 1f                	and    $0x1f,%al
  101a63:	a2 a4 14 11 00       	mov    %al,0x1114a4
  101a68:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101a6f:	0c 0f                	or     $0xf,%al
  101a71:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101a76:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101a7d:	24 ef                	and    $0xef,%al
  101a7f:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101a84:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101a8b:	0c 60                	or     $0x60,%al
  101a8d:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101a92:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101a99:	0c 80                	or     $0x80,%al
  101a9b:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101aa0:	a1 e0 07 11 00       	mov    0x1107e0,%eax
  101aa5:	c1 e8 10             	shr    $0x10,%eax
  101aa8:	0f b7 c0             	movzwl %ax,%eax
  101aab:	66 a3 a6 14 11 00    	mov    %ax,0x1114a6
    SETGATE(idt[T_SWITCH_TOK],0,GD_KTEXT,__vectors[T_SWITCH_TOK],DPL_USER);
  101ab1:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101ab6:	0f b7 c0             	movzwl %ax,%eax
  101ab9:	66 a3 68 14 11 00    	mov    %ax,0x111468
  101abf:	66 c7 05 6a 14 11 00 	movw   $0x8,0x11146a
  101ac6:	08 00 
  101ac8:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101acf:	24 e0                	and    $0xe0,%al
  101ad1:	a2 6c 14 11 00       	mov    %al,0x11146c
  101ad6:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101add:	24 1f                	and    $0x1f,%al
  101adf:	a2 6c 14 11 00       	mov    %al,0x11146c
  101ae4:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101aeb:	24 f0                	and    $0xf0,%al
  101aed:	0c 0e                	or     $0xe,%al
  101aef:	a2 6d 14 11 00       	mov    %al,0x11146d
  101af4:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101afb:	24 ef                	and    $0xef,%al
  101afd:	a2 6d 14 11 00       	mov    %al,0x11146d
  101b02:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101b09:	0c 60                	or     $0x60,%al
  101b0b:	a2 6d 14 11 00       	mov    %al,0x11146d
  101b10:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101b17:	0c 80                	or     $0x80,%al
  101b19:	a2 6d 14 11 00       	mov    %al,0x11146d
  101b1e:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101b23:	c1 e8 10             	shr    $0x10,%eax
  101b26:	0f b7 c0             	movzwl %ax,%eax
  101b29:	66 a3 6e 14 11 00    	mov    %ax,0x11146e
  101b2f:	c7 45 f4 60 05 11 00 	movl   $0x110560,-0xc(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b39:	0f 01 18             	lidtl  (%eax)
}
  101b3c:	90                   	nop
    // load the IDT
    lidt(&idt_pd);
}
  101b3d:	90                   	nop
  101b3e:	c9                   	leave  
  101b3f:	c3                   	ret    

00101b40 <trapname>:

static const char *
trapname(int trapno) {
  101b40:	f3 0f 1e fb          	endbr32 
  101b44:	55                   	push   %ebp
  101b45:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101b47:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4a:	83 f8 13             	cmp    $0x13,%eax
  101b4d:	77 0c                	ja     101b5b <trapname+0x1b>
        return excnames[trapno];
  101b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b52:	8b 04 85 60 3e 10 00 	mov    0x103e60(,%eax,4),%eax
  101b59:	eb 18                	jmp    101b73 <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101b5b:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b5f:	7e 0d                	jle    101b6e <trapname+0x2e>
  101b61:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b65:	7f 07                	jg     101b6e <trapname+0x2e>
        return "Hardware Interrupt";
  101b67:	b8 1f 3b 10 00       	mov    $0x103b1f,%eax
  101b6c:	eb 05                	jmp    101b73 <trapname+0x33>
    }
    return "(unknown trap)";
  101b6e:	b8 32 3b 10 00       	mov    $0x103b32,%eax
}
  101b73:	5d                   	pop    %ebp
  101b74:	c3                   	ret    

00101b75 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101b75:	f3 0f 1e fb          	endbr32 
  101b79:	55                   	push   %ebp
  101b7a:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b83:	83 f8 08             	cmp    $0x8,%eax
  101b86:	0f 94 c0             	sete   %al
  101b89:	0f b6 c0             	movzbl %al,%eax
}
  101b8c:	5d                   	pop    %ebp
  101b8d:	c3                   	ret    

00101b8e <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b8e:	f3 0f 1e fb          	endbr32 
  101b92:	55                   	push   %ebp
  101b93:	89 e5                	mov    %esp,%ebp
  101b95:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b98:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b9f:	c7 04 24 73 3b 10 00 	movl   $0x103b73,(%esp)
  101ba6:	e8 e4 e6 ff ff       	call   10028f <cprintf>
    print_regs(&tf->tf_regs);
  101bab:	8b 45 08             	mov    0x8(%ebp),%eax
  101bae:	89 04 24             	mov    %eax,(%esp)
  101bb1:	e8 8d 01 00 00       	call   101d43 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb9:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101bbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc1:	c7 04 24 84 3b 10 00 	movl   $0x103b84,(%esp)
  101bc8:	e8 c2 e6 ff ff       	call   10028f <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd0:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd8:	c7 04 24 97 3b 10 00 	movl   $0x103b97,(%esp)
  101bdf:	e8 ab e6 ff ff       	call   10028f <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101be4:	8b 45 08             	mov    0x8(%ebp),%eax
  101be7:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101beb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bef:	c7 04 24 aa 3b 10 00 	movl   $0x103baa,(%esp)
  101bf6:	e8 94 e6 ff ff       	call   10028f <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfe:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101c02:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c06:	c7 04 24 bd 3b 10 00 	movl   $0x103bbd,(%esp)
  101c0d:	e8 7d e6 ff ff       	call   10028f <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101c12:	8b 45 08             	mov    0x8(%ebp),%eax
  101c15:	8b 40 30             	mov    0x30(%eax),%eax
  101c18:	89 04 24             	mov    %eax,(%esp)
  101c1b:	e8 20 ff ff ff       	call   101b40 <trapname>
  101c20:	8b 55 08             	mov    0x8(%ebp),%edx
  101c23:	8b 52 30             	mov    0x30(%edx),%edx
  101c26:	89 44 24 08          	mov    %eax,0x8(%esp)
  101c2a:	89 54 24 04          	mov    %edx,0x4(%esp)
  101c2e:	c7 04 24 d0 3b 10 00 	movl   $0x103bd0,(%esp)
  101c35:	e8 55 e6 ff ff       	call   10028f <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3d:	8b 40 34             	mov    0x34(%eax),%eax
  101c40:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c44:	c7 04 24 e2 3b 10 00 	movl   $0x103be2,(%esp)
  101c4b:	e8 3f e6 ff ff       	call   10028f <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101c50:	8b 45 08             	mov    0x8(%ebp),%eax
  101c53:	8b 40 38             	mov    0x38(%eax),%eax
  101c56:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5a:	c7 04 24 f1 3b 10 00 	movl   $0x103bf1,(%esp)
  101c61:	e8 29 e6 ff ff       	call   10028f <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c66:	8b 45 08             	mov    0x8(%ebp),%eax
  101c69:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c71:	c7 04 24 00 3c 10 00 	movl   $0x103c00,(%esp)
  101c78:	e8 12 e6 ff ff       	call   10028f <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c80:	8b 40 40             	mov    0x40(%eax),%eax
  101c83:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c87:	c7 04 24 13 3c 10 00 	movl   $0x103c13,(%esp)
  101c8e:	e8 fc e5 ff ff       	call   10028f <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c9a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ca1:	eb 3d                	jmp    101ce0 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca6:	8b 50 40             	mov    0x40(%eax),%edx
  101ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101cac:	21 d0                	and    %edx,%eax
  101cae:	85 c0                	test   %eax,%eax
  101cb0:	74 28                	je     101cda <print_trapframe+0x14c>
  101cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cb5:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101cbc:	85 c0                	test   %eax,%eax
  101cbe:	74 1a                	je     101cda <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cc3:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101cca:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cce:	c7 04 24 22 3c 10 00 	movl   $0x103c22,(%esp)
  101cd5:	e8 b5 e5 ff ff       	call   10028f <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101cda:	ff 45 f4             	incl   -0xc(%ebp)
  101cdd:	d1 65 f0             	shll   -0x10(%ebp)
  101ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ce3:	83 f8 17             	cmp    $0x17,%eax
  101ce6:	76 bb                	jbe    101ca3 <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  101ceb:	8b 40 40             	mov    0x40(%eax),%eax
  101cee:	c1 e8 0c             	shr    $0xc,%eax
  101cf1:	83 e0 03             	and    $0x3,%eax
  101cf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf8:	c7 04 24 26 3c 10 00 	movl   $0x103c26,(%esp)
  101cff:	e8 8b e5 ff ff       	call   10028f <cprintf>

    if (!trap_in_kernel(tf)) {
  101d04:	8b 45 08             	mov    0x8(%ebp),%eax
  101d07:	89 04 24             	mov    %eax,(%esp)
  101d0a:	e8 66 fe ff ff       	call   101b75 <trap_in_kernel>
  101d0f:	85 c0                	test   %eax,%eax
  101d11:	75 2d                	jne    101d40 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101d13:	8b 45 08             	mov    0x8(%ebp),%eax
  101d16:	8b 40 44             	mov    0x44(%eax),%eax
  101d19:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d1d:	c7 04 24 2f 3c 10 00 	movl   $0x103c2f,(%esp)
  101d24:	e8 66 e5 ff ff       	call   10028f <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101d29:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2c:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101d30:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d34:	c7 04 24 3e 3c 10 00 	movl   $0x103c3e,(%esp)
  101d3b:	e8 4f e5 ff ff       	call   10028f <cprintf>
    }
}
  101d40:	90                   	nop
  101d41:	c9                   	leave  
  101d42:	c3                   	ret    

00101d43 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101d43:	f3 0f 1e fb          	endbr32 
  101d47:	55                   	push   %ebp
  101d48:	89 e5                	mov    %esp,%ebp
  101d4a:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d50:	8b 00                	mov    (%eax),%eax
  101d52:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d56:	c7 04 24 51 3c 10 00 	movl   $0x103c51,(%esp)
  101d5d:	e8 2d e5 ff ff       	call   10028f <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101d62:	8b 45 08             	mov    0x8(%ebp),%eax
  101d65:	8b 40 04             	mov    0x4(%eax),%eax
  101d68:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d6c:	c7 04 24 60 3c 10 00 	movl   $0x103c60,(%esp)
  101d73:	e8 17 e5 ff ff       	call   10028f <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d78:	8b 45 08             	mov    0x8(%ebp),%eax
  101d7b:	8b 40 08             	mov    0x8(%eax),%eax
  101d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d82:	c7 04 24 6f 3c 10 00 	movl   $0x103c6f,(%esp)
  101d89:	e8 01 e5 ff ff       	call   10028f <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d91:	8b 40 0c             	mov    0xc(%eax),%eax
  101d94:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d98:	c7 04 24 7e 3c 10 00 	movl   $0x103c7e,(%esp)
  101d9f:	e8 eb e4 ff ff       	call   10028f <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101da4:	8b 45 08             	mov    0x8(%ebp),%eax
  101da7:	8b 40 10             	mov    0x10(%eax),%eax
  101daa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dae:	c7 04 24 8d 3c 10 00 	movl   $0x103c8d,(%esp)
  101db5:	e8 d5 e4 ff ff       	call   10028f <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101dba:	8b 45 08             	mov    0x8(%ebp),%eax
  101dbd:	8b 40 14             	mov    0x14(%eax),%eax
  101dc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dc4:	c7 04 24 9c 3c 10 00 	movl   $0x103c9c,(%esp)
  101dcb:	e8 bf e4 ff ff       	call   10028f <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd3:	8b 40 18             	mov    0x18(%eax),%eax
  101dd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dda:	c7 04 24 ab 3c 10 00 	movl   $0x103cab,(%esp)
  101de1:	e8 a9 e4 ff ff       	call   10028f <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101de6:	8b 45 08             	mov    0x8(%ebp),%eax
  101de9:	8b 40 1c             	mov    0x1c(%eax),%eax
  101dec:	89 44 24 04          	mov    %eax,0x4(%esp)
  101df0:	c7 04 24 ba 3c 10 00 	movl   $0x103cba,(%esp)
  101df7:	e8 93 e4 ff ff       	call   10028f <cprintf>
}
  101dfc:	90                   	nop
  101dfd:	c9                   	leave  
  101dfe:	c3                   	ret    

00101dff <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101dff:	f3 0f 1e fb          	endbr32 
  101e03:	55                   	push   %ebp
  101e04:	89 e5                	mov    %esp,%ebp
  101e06:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101e09:	8b 45 08             	mov    0x8(%ebp),%eax
  101e0c:	8b 40 30             	mov    0x30(%eax),%eax
  101e0f:	83 f8 79             	cmp    $0x79,%eax
  101e12:	0f 84 54 01 00 00    	je     101f6c <trap_dispatch+0x16d>
  101e18:	83 f8 79             	cmp    $0x79,%eax
  101e1b:	0f 87 ba 01 00 00    	ja     101fdb <trap_dispatch+0x1dc>
  101e21:	83 f8 78             	cmp    $0x78,%eax
  101e24:	0f 84 d0 00 00 00    	je     101efa <trap_dispatch+0xfb>
  101e2a:	83 f8 78             	cmp    $0x78,%eax
  101e2d:	0f 87 a8 01 00 00    	ja     101fdb <trap_dispatch+0x1dc>
  101e33:	83 f8 2f             	cmp    $0x2f,%eax
  101e36:	0f 87 9f 01 00 00    	ja     101fdb <trap_dispatch+0x1dc>
  101e3c:	83 f8 2e             	cmp    $0x2e,%eax
  101e3f:	0f 83 cb 01 00 00    	jae    102010 <trap_dispatch+0x211>
  101e45:	83 f8 24             	cmp    $0x24,%eax
  101e48:	74 5e                	je     101ea8 <trap_dispatch+0xa9>
  101e4a:	83 f8 24             	cmp    $0x24,%eax
  101e4d:	0f 87 88 01 00 00    	ja     101fdb <trap_dispatch+0x1dc>
  101e53:	83 f8 20             	cmp    $0x20,%eax
  101e56:	74 0a                	je     101e62 <trap_dispatch+0x63>
  101e58:	83 f8 21             	cmp    $0x21,%eax
  101e5b:	74 74                	je     101ed1 <trap_dispatch+0xd2>
  101e5d:	e9 79 01 00 00       	jmp    101fdb <trap_dispatch+0x1dc>
    case IRQ_OFFSET + IRQ_TIMER:
        /* LAB1 YOUR CODE : STEP 3 */
        //record it
        ticks++;
  101e62:	a1 08 19 11 00       	mov    0x111908,%eax
  101e67:	40                   	inc    %eax
  101e68:	a3 08 19 11 00       	mov    %eax,0x111908
        if(ticks%TICK_NUM==0){
  101e6d:	8b 0d 08 19 11 00    	mov    0x111908,%ecx
  101e73:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101e78:	89 c8                	mov    %ecx,%eax
  101e7a:	f7 e2                	mul    %edx
  101e7c:	c1 ea 05             	shr    $0x5,%edx
  101e7f:	89 d0                	mov    %edx,%eax
  101e81:	c1 e0 02             	shl    $0x2,%eax
  101e84:	01 d0                	add    %edx,%eax
  101e86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101e8d:	01 d0                	add    %edx,%eax
  101e8f:	c1 e0 02             	shl    $0x2,%eax
  101e92:	29 c1                	sub    %eax,%ecx
  101e94:	89 ca                	mov    %ecx,%edx
  101e96:	85 d2                	test   %edx,%edx
  101e98:	0f 85 75 01 00 00    	jne    102013 <trap_dispatch+0x214>
            //print ticks info
            print_ticks();
  101e9e:	e8 5f fa ff ff       	call   101902 <print_ticks>
        }
        break;
  101ea3:	e9 6b 01 00 00       	jmp    102013 <trap_dispatch+0x214>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ea8:	e8 fb f7 ff ff       	call   1016a8 <cons_getc>
  101ead:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101eb0:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101eb4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101eb8:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ebc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ec0:	c7 04 24 c9 3c 10 00 	movl   $0x103cc9,(%esp)
  101ec7:	e8 c3 e3 ff ff       	call   10028f <cprintf>
        break;
  101ecc:	e9 49 01 00 00       	jmp    10201a <trap_dispatch+0x21b>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101ed1:	e8 d2 f7 ff ff       	call   1016a8 <cons_getc>
  101ed6:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101ed9:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101edd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ee1:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ee5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ee9:	c7 04 24 db 3c 10 00 	movl   $0x103cdb,(%esp)
  101ef0:	e8 9a e3 ff ff       	call   10028f <cprintf>
        break;
  101ef5:	e9 20 01 00 00       	jmp    10201a <trap_dispatch+0x21b>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101efa:	8b 45 08             	mov    0x8(%ebp),%eax
  101efd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f01:	83 f8 1b             	cmp    $0x1b,%eax
  101f04:	0f 84 0c 01 00 00    	je     102016 <trap_dispatch+0x217>
            //为了使得程序在低CPL的情况下仍然能够使用IO，需要将eflags中对应的IOPL位置成表示用户态的
            //if CPL > IOPL, then cpu will generate a general protection.
            tf->tf_eflags |= FL_IOPL_MASK;
  101f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f0d:	8b 40 40             	mov    0x40(%eax),%eax
  101f10:	0d 00 30 00 00       	or     $0x3000,%eax
  101f15:	89 c2                	mov    %eax,%edx
  101f17:	8b 45 08             	mov    0x8(%ebp),%eax
  101f1a:	89 50 40             	mov    %edx,0x40(%eax)
            //iret认定在发生中断的时候是否发生了PL的切换，是取决于CPL和最终跳转回的地址的cs选择子对应的段描述符处的CPL（也就是发生中断前的CPL）是否相等来决定的
            //因此将保存在trapframe中的原先的cs修改成指向用户态描述子的USER_CS
            tf->tf_cs = USER_CS;
  101f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101f20:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            //为了使得中断返回之后能够正常访问数据，将其他的段选择子都修改为USER_DS
            tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = USER_DS;
  101f26:	8b 45 08             	mov    0x8(%ebp),%eax
  101f29:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  101f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f32:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101f36:	8b 45 08             	mov    0x8(%ebp),%eax
  101f39:	66 89 50 48          	mov    %dx,0x48(%eax)
  101f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101f40:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101f44:	8b 45 08             	mov    0x8(%ebp),%eax
  101f47:	66 89 50 20          	mov    %dx,0x20(%eax)
  101f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101f4e:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101f52:	8b 45 08             	mov    0x8(%ebp),%eax
  101f55:	66 89 50 28          	mov    %dx,0x28(%eax)
  101f59:	8b 45 08             	mov    0x8(%ebp),%eax
  101f5c:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f60:	8b 45 08             	mov    0x8(%ebp),%eax
  101f63:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        }
        break;
  101f67:	e9 aa 00 00 00       	jmp    102016 <trap_dispatch+0x217>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f6f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f73:	83 f8 08             	cmp    $0x8,%eax
  101f76:	0f 84 9d 00 00 00    	je     102019 <trap_dispatch+0x21a>
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f7f:	8b 40 40             	mov    0x40(%eax),%eax
  101f82:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101f87:	89 c2                	mov    %eax,%edx
  101f89:	8b 45 08             	mov    0x8(%ebp),%eax
  101f8c:	89 50 40             	mov    %edx,0x40(%eax)
            tf->tf_cs = KERNEL_CS;
  101f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f92:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = KERNEL_DS;
  101f98:	8b 45 08             	mov    0x8(%ebp),%eax
  101f9b:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
  101fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  101fa4:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  101fab:	66 89 50 48          	mov    %dx,0x48(%eax)
  101faf:	8b 45 08             	mov    0x8(%ebp),%eax
  101fb2:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  101fb9:	66 89 50 20          	mov    %dx,0x20(%eax)
  101fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  101fc0:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  101fc7:	66 89 50 28          	mov    %dx,0x28(%eax)
  101fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  101fce:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  101fd5:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        }
        //panic("T_SWITCH_** ??\n");
        break;
  101fd9:	eb 3e                	jmp    102019 <trap_dispatch+0x21a>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  101fde:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101fe2:	83 e0 03             	and    $0x3,%eax
  101fe5:	85 c0                	test   %eax,%eax
  101fe7:	75 31                	jne    10201a <trap_dispatch+0x21b>
            print_trapframe(tf);
  101fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  101fec:	89 04 24             	mov    %eax,(%esp)
  101fef:	e8 9a fb ff ff       	call   101b8e <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101ff4:	c7 44 24 08 ea 3c 10 	movl   $0x103cea,0x8(%esp)
  101ffb:	00 
  101ffc:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
  102003:	00 
  102004:	c7 04 24 0e 3b 10 00 	movl   $0x103b0e,(%esp)
  10200b:	e8 eb e3 ff ff       	call   1003fb <__panic>
        break;
  102010:	90                   	nop
  102011:	eb 07                	jmp    10201a <trap_dispatch+0x21b>
        break;
  102013:	90                   	nop
  102014:	eb 04                	jmp    10201a <trap_dispatch+0x21b>
        break;
  102016:	90                   	nop
  102017:	eb 01                	jmp    10201a <trap_dispatch+0x21b>
        break;
  102019:	90                   	nop
        }
    }
}
  10201a:	90                   	nop
  10201b:	c9                   	leave  
  10201c:	c3                   	ret    

0010201d <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  10201d:	f3 0f 1e fb          	endbr32 
  102021:	55                   	push   %ebp
  102022:	89 e5                	mov    %esp,%ebp
  102024:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  102027:	8b 45 08             	mov    0x8(%ebp),%eax
  10202a:	89 04 24             	mov    %eax,(%esp)
  10202d:	e8 cd fd ff ff       	call   101dff <trap_dispatch>
}
  102032:	90                   	nop
  102033:	c9                   	leave  
  102034:	c3                   	ret    

00102035 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  102035:	6a 00                	push   $0x0
  pushl $0
  102037:	6a 00                	push   $0x0
  jmp __alltraps
  102039:	e9 69 0a 00 00       	jmp    102aa7 <__alltraps>

0010203e <vector1>:
.globl vector1
vector1:
  pushl $0
  10203e:	6a 00                	push   $0x0
  pushl $1
  102040:	6a 01                	push   $0x1
  jmp __alltraps
  102042:	e9 60 0a 00 00       	jmp    102aa7 <__alltraps>

00102047 <vector2>:
.globl vector2
vector2:
  pushl $0
  102047:	6a 00                	push   $0x0
  pushl $2
  102049:	6a 02                	push   $0x2
  jmp __alltraps
  10204b:	e9 57 0a 00 00       	jmp    102aa7 <__alltraps>

00102050 <vector3>:
.globl vector3
vector3:
  pushl $0
  102050:	6a 00                	push   $0x0
  pushl $3
  102052:	6a 03                	push   $0x3
  jmp __alltraps
  102054:	e9 4e 0a 00 00       	jmp    102aa7 <__alltraps>

00102059 <vector4>:
.globl vector4
vector4:
  pushl $0
  102059:	6a 00                	push   $0x0
  pushl $4
  10205b:	6a 04                	push   $0x4
  jmp __alltraps
  10205d:	e9 45 0a 00 00       	jmp    102aa7 <__alltraps>

00102062 <vector5>:
.globl vector5
vector5:
  pushl $0
  102062:	6a 00                	push   $0x0
  pushl $5
  102064:	6a 05                	push   $0x5
  jmp __alltraps
  102066:	e9 3c 0a 00 00       	jmp    102aa7 <__alltraps>

0010206b <vector6>:
.globl vector6
vector6:
  pushl $0
  10206b:	6a 00                	push   $0x0
  pushl $6
  10206d:	6a 06                	push   $0x6
  jmp __alltraps
  10206f:	e9 33 0a 00 00       	jmp    102aa7 <__alltraps>

00102074 <vector7>:
.globl vector7
vector7:
  pushl $0
  102074:	6a 00                	push   $0x0
  pushl $7
  102076:	6a 07                	push   $0x7
  jmp __alltraps
  102078:	e9 2a 0a 00 00       	jmp    102aa7 <__alltraps>

0010207d <vector8>:
.globl vector8
vector8:
  pushl $8
  10207d:	6a 08                	push   $0x8
  jmp __alltraps
  10207f:	e9 23 0a 00 00       	jmp    102aa7 <__alltraps>

00102084 <vector9>:
.globl vector9
vector9:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $9
  102086:	6a 09                	push   $0x9
  jmp __alltraps
  102088:	e9 1a 0a 00 00       	jmp    102aa7 <__alltraps>

0010208d <vector10>:
.globl vector10
vector10:
  pushl $10
  10208d:	6a 0a                	push   $0xa
  jmp __alltraps
  10208f:	e9 13 0a 00 00       	jmp    102aa7 <__alltraps>

00102094 <vector11>:
.globl vector11
vector11:
  pushl $11
  102094:	6a 0b                	push   $0xb
  jmp __alltraps
  102096:	e9 0c 0a 00 00       	jmp    102aa7 <__alltraps>

0010209b <vector12>:
.globl vector12
vector12:
  pushl $12
  10209b:	6a 0c                	push   $0xc
  jmp __alltraps
  10209d:	e9 05 0a 00 00       	jmp    102aa7 <__alltraps>

001020a2 <vector13>:
.globl vector13
vector13:
  pushl $13
  1020a2:	6a 0d                	push   $0xd
  jmp __alltraps
  1020a4:	e9 fe 09 00 00       	jmp    102aa7 <__alltraps>

001020a9 <vector14>:
.globl vector14
vector14:
  pushl $14
  1020a9:	6a 0e                	push   $0xe
  jmp __alltraps
  1020ab:	e9 f7 09 00 00       	jmp    102aa7 <__alltraps>

001020b0 <vector15>:
.globl vector15
vector15:
  pushl $0
  1020b0:	6a 00                	push   $0x0
  pushl $15
  1020b2:	6a 0f                	push   $0xf
  jmp __alltraps
  1020b4:	e9 ee 09 00 00       	jmp    102aa7 <__alltraps>

001020b9 <vector16>:
.globl vector16
vector16:
  pushl $0
  1020b9:	6a 00                	push   $0x0
  pushl $16
  1020bb:	6a 10                	push   $0x10
  jmp __alltraps
  1020bd:	e9 e5 09 00 00       	jmp    102aa7 <__alltraps>

001020c2 <vector17>:
.globl vector17
vector17:
  pushl $17
  1020c2:	6a 11                	push   $0x11
  jmp __alltraps
  1020c4:	e9 de 09 00 00       	jmp    102aa7 <__alltraps>

001020c9 <vector18>:
.globl vector18
vector18:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $18
  1020cb:	6a 12                	push   $0x12
  jmp __alltraps
  1020cd:	e9 d5 09 00 00       	jmp    102aa7 <__alltraps>

001020d2 <vector19>:
.globl vector19
vector19:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $19
  1020d4:	6a 13                	push   $0x13
  jmp __alltraps
  1020d6:	e9 cc 09 00 00       	jmp    102aa7 <__alltraps>

001020db <vector20>:
.globl vector20
vector20:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $20
  1020dd:	6a 14                	push   $0x14
  jmp __alltraps
  1020df:	e9 c3 09 00 00       	jmp    102aa7 <__alltraps>

001020e4 <vector21>:
.globl vector21
vector21:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $21
  1020e6:	6a 15                	push   $0x15
  jmp __alltraps
  1020e8:	e9 ba 09 00 00       	jmp    102aa7 <__alltraps>

001020ed <vector22>:
.globl vector22
vector22:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $22
  1020ef:	6a 16                	push   $0x16
  jmp __alltraps
  1020f1:	e9 b1 09 00 00       	jmp    102aa7 <__alltraps>

001020f6 <vector23>:
.globl vector23
vector23:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $23
  1020f8:	6a 17                	push   $0x17
  jmp __alltraps
  1020fa:	e9 a8 09 00 00       	jmp    102aa7 <__alltraps>

001020ff <vector24>:
.globl vector24
vector24:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $24
  102101:	6a 18                	push   $0x18
  jmp __alltraps
  102103:	e9 9f 09 00 00       	jmp    102aa7 <__alltraps>

00102108 <vector25>:
.globl vector25
vector25:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $25
  10210a:	6a 19                	push   $0x19
  jmp __alltraps
  10210c:	e9 96 09 00 00       	jmp    102aa7 <__alltraps>

00102111 <vector26>:
.globl vector26
vector26:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $26
  102113:	6a 1a                	push   $0x1a
  jmp __alltraps
  102115:	e9 8d 09 00 00       	jmp    102aa7 <__alltraps>

0010211a <vector27>:
.globl vector27
vector27:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $27
  10211c:	6a 1b                	push   $0x1b
  jmp __alltraps
  10211e:	e9 84 09 00 00       	jmp    102aa7 <__alltraps>

00102123 <vector28>:
.globl vector28
vector28:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $28
  102125:	6a 1c                	push   $0x1c
  jmp __alltraps
  102127:	e9 7b 09 00 00       	jmp    102aa7 <__alltraps>

0010212c <vector29>:
.globl vector29
vector29:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $29
  10212e:	6a 1d                	push   $0x1d
  jmp __alltraps
  102130:	e9 72 09 00 00       	jmp    102aa7 <__alltraps>

00102135 <vector30>:
.globl vector30
vector30:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $30
  102137:	6a 1e                	push   $0x1e
  jmp __alltraps
  102139:	e9 69 09 00 00       	jmp    102aa7 <__alltraps>

0010213e <vector31>:
.globl vector31
vector31:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $31
  102140:	6a 1f                	push   $0x1f
  jmp __alltraps
  102142:	e9 60 09 00 00       	jmp    102aa7 <__alltraps>

00102147 <vector32>:
.globl vector32
vector32:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $32
  102149:	6a 20                	push   $0x20
  jmp __alltraps
  10214b:	e9 57 09 00 00       	jmp    102aa7 <__alltraps>

00102150 <vector33>:
.globl vector33
vector33:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $33
  102152:	6a 21                	push   $0x21
  jmp __alltraps
  102154:	e9 4e 09 00 00       	jmp    102aa7 <__alltraps>

00102159 <vector34>:
.globl vector34
vector34:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $34
  10215b:	6a 22                	push   $0x22
  jmp __alltraps
  10215d:	e9 45 09 00 00       	jmp    102aa7 <__alltraps>

00102162 <vector35>:
.globl vector35
vector35:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $35
  102164:	6a 23                	push   $0x23
  jmp __alltraps
  102166:	e9 3c 09 00 00       	jmp    102aa7 <__alltraps>

0010216b <vector36>:
.globl vector36
vector36:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $36
  10216d:	6a 24                	push   $0x24
  jmp __alltraps
  10216f:	e9 33 09 00 00       	jmp    102aa7 <__alltraps>

00102174 <vector37>:
.globl vector37
vector37:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $37
  102176:	6a 25                	push   $0x25
  jmp __alltraps
  102178:	e9 2a 09 00 00       	jmp    102aa7 <__alltraps>

0010217d <vector38>:
.globl vector38
vector38:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $38
  10217f:	6a 26                	push   $0x26
  jmp __alltraps
  102181:	e9 21 09 00 00       	jmp    102aa7 <__alltraps>

00102186 <vector39>:
.globl vector39
vector39:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $39
  102188:	6a 27                	push   $0x27
  jmp __alltraps
  10218a:	e9 18 09 00 00       	jmp    102aa7 <__alltraps>

0010218f <vector40>:
.globl vector40
vector40:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $40
  102191:	6a 28                	push   $0x28
  jmp __alltraps
  102193:	e9 0f 09 00 00       	jmp    102aa7 <__alltraps>

00102198 <vector41>:
.globl vector41
vector41:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $41
  10219a:	6a 29                	push   $0x29
  jmp __alltraps
  10219c:	e9 06 09 00 00       	jmp    102aa7 <__alltraps>

001021a1 <vector42>:
.globl vector42
vector42:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $42
  1021a3:	6a 2a                	push   $0x2a
  jmp __alltraps
  1021a5:	e9 fd 08 00 00       	jmp    102aa7 <__alltraps>

001021aa <vector43>:
.globl vector43
vector43:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $43
  1021ac:	6a 2b                	push   $0x2b
  jmp __alltraps
  1021ae:	e9 f4 08 00 00       	jmp    102aa7 <__alltraps>

001021b3 <vector44>:
.globl vector44
vector44:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $44
  1021b5:	6a 2c                	push   $0x2c
  jmp __alltraps
  1021b7:	e9 eb 08 00 00       	jmp    102aa7 <__alltraps>

001021bc <vector45>:
.globl vector45
vector45:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $45
  1021be:	6a 2d                	push   $0x2d
  jmp __alltraps
  1021c0:	e9 e2 08 00 00       	jmp    102aa7 <__alltraps>

001021c5 <vector46>:
.globl vector46
vector46:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $46
  1021c7:	6a 2e                	push   $0x2e
  jmp __alltraps
  1021c9:	e9 d9 08 00 00       	jmp    102aa7 <__alltraps>

001021ce <vector47>:
.globl vector47
vector47:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $47
  1021d0:	6a 2f                	push   $0x2f
  jmp __alltraps
  1021d2:	e9 d0 08 00 00       	jmp    102aa7 <__alltraps>

001021d7 <vector48>:
.globl vector48
vector48:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $48
  1021d9:	6a 30                	push   $0x30
  jmp __alltraps
  1021db:	e9 c7 08 00 00       	jmp    102aa7 <__alltraps>

001021e0 <vector49>:
.globl vector49
vector49:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $49
  1021e2:	6a 31                	push   $0x31
  jmp __alltraps
  1021e4:	e9 be 08 00 00       	jmp    102aa7 <__alltraps>

001021e9 <vector50>:
.globl vector50
vector50:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $50
  1021eb:	6a 32                	push   $0x32
  jmp __alltraps
  1021ed:	e9 b5 08 00 00       	jmp    102aa7 <__alltraps>

001021f2 <vector51>:
.globl vector51
vector51:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $51
  1021f4:	6a 33                	push   $0x33
  jmp __alltraps
  1021f6:	e9 ac 08 00 00       	jmp    102aa7 <__alltraps>

001021fb <vector52>:
.globl vector52
vector52:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $52
  1021fd:	6a 34                	push   $0x34
  jmp __alltraps
  1021ff:	e9 a3 08 00 00       	jmp    102aa7 <__alltraps>

00102204 <vector53>:
.globl vector53
vector53:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $53
  102206:	6a 35                	push   $0x35
  jmp __alltraps
  102208:	e9 9a 08 00 00       	jmp    102aa7 <__alltraps>

0010220d <vector54>:
.globl vector54
vector54:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $54
  10220f:	6a 36                	push   $0x36
  jmp __alltraps
  102211:	e9 91 08 00 00       	jmp    102aa7 <__alltraps>

00102216 <vector55>:
.globl vector55
vector55:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $55
  102218:	6a 37                	push   $0x37
  jmp __alltraps
  10221a:	e9 88 08 00 00       	jmp    102aa7 <__alltraps>

0010221f <vector56>:
.globl vector56
vector56:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $56
  102221:	6a 38                	push   $0x38
  jmp __alltraps
  102223:	e9 7f 08 00 00       	jmp    102aa7 <__alltraps>

00102228 <vector57>:
.globl vector57
vector57:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $57
  10222a:	6a 39                	push   $0x39
  jmp __alltraps
  10222c:	e9 76 08 00 00       	jmp    102aa7 <__alltraps>

00102231 <vector58>:
.globl vector58
vector58:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $58
  102233:	6a 3a                	push   $0x3a
  jmp __alltraps
  102235:	e9 6d 08 00 00       	jmp    102aa7 <__alltraps>

0010223a <vector59>:
.globl vector59
vector59:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $59
  10223c:	6a 3b                	push   $0x3b
  jmp __alltraps
  10223e:	e9 64 08 00 00       	jmp    102aa7 <__alltraps>

00102243 <vector60>:
.globl vector60
vector60:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $60
  102245:	6a 3c                	push   $0x3c
  jmp __alltraps
  102247:	e9 5b 08 00 00       	jmp    102aa7 <__alltraps>

0010224c <vector61>:
.globl vector61
vector61:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $61
  10224e:	6a 3d                	push   $0x3d
  jmp __alltraps
  102250:	e9 52 08 00 00       	jmp    102aa7 <__alltraps>

00102255 <vector62>:
.globl vector62
vector62:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $62
  102257:	6a 3e                	push   $0x3e
  jmp __alltraps
  102259:	e9 49 08 00 00       	jmp    102aa7 <__alltraps>

0010225e <vector63>:
.globl vector63
vector63:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $63
  102260:	6a 3f                	push   $0x3f
  jmp __alltraps
  102262:	e9 40 08 00 00       	jmp    102aa7 <__alltraps>

00102267 <vector64>:
.globl vector64
vector64:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $64
  102269:	6a 40                	push   $0x40
  jmp __alltraps
  10226b:	e9 37 08 00 00       	jmp    102aa7 <__alltraps>

00102270 <vector65>:
.globl vector65
vector65:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $65
  102272:	6a 41                	push   $0x41
  jmp __alltraps
  102274:	e9 2e 08 00 00       	jmp    102aa7 <__alltraps>

00102279 <vector66>:
.globl vector66
vector66:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $66
  10227b:	6a 42                	push   $0x42
  jmp __alltraps
  10227d:	e9 25 08 00 00       	jmp    102aa7 <__alltraps>

00102282 <vector67>:
.globl vector67
vector67:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $67
  102284:	6a 43                	push   $0x43
  jmp __alltraps
  102286:	e9 1c 08 00 00       	jmp    102aa7 <__alltraps>

0010228b <vector68>:
.globl vector68
vector68:
  pushl $0
  10228b:	6a 00                	push   $0x0
  pushl $68
  10228d:	6a 44                	push   $0x44
  jmp __alltraps
  10228f:	e9 13 08 00 00       	jmp    102aa7 <__alltraps>

00102294 <vector69>:
.globl vector69
vector69:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $69
  102296:	6a 45                	push   $0x45
  jmp __alltraps
  102298:	e9 0a 08 00 00       	jmp    102aa7 <__alltraps>

0010229d <vector70>:
.globl vector70
vector70:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $70
  10229f:	6a 46                	push   $0x46
  jmp __alltraps
  1022a1:	e9 01 08 00 00       	jmp    102aa7 <__alltraps>

001022a6 <vector71>:
.globl vector71
vector71:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $71
  1022a8:	6a 47                	push   $0x47
  jmp __alltraps
  1022aa:	e9 f8 07 00 00       	jmp    102aa7 <__alltraps>

001022af <vector72>:
.globl vector72
vector72:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $72
  1022b1:	6a 48                	push   $0x48
  jmp __alltraps
  1022b3:	e9 ef 07 00 00       	jmp    102aa7 <__alltraps>

001022b8 <vector73>:
.globl vector73
vector73:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $73
  1022ba:	6a 49                	push   $0x49
  jmp __alltraps
  1022bc:	e9 e6 07 00 00       	jmp    102aa7 <__alltraps>

001022c1 <vector74>:
.globl vector74
vector74:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $74
  1022c3:	6a 4a                	push   $0x4a
  jmp __alltraps
  1022c5:	e9 dd 07 00 00       	jmp    102aa7 <__alltraps>

001022ca <vector75>:
.globl vector75
vector75:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $75
  1022cc:	6a 4b                	push   $0x4b
  jmp __alltraps
  1022ce:	e9 d4 07 00 00       	jmp    102aa7 <__alltraps>

001022d3 <vector76>:
.globl vector76
vector76:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $76
  1022d5:	6a 4c                	push   $0x4c
  jmp __alltraps
  1022d7:	e9 cb 07 00 00       	jmp    102aa7 <__alltraps>

001022dc <vector77>:
.globl vector77
vector77:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $77
  1022de:	6a 4d                	push   $0x4d
  jmp __alltraps
  1022e0:	e9 c2 07 00 00       	jmp    102aa7 <__alltraps>

001022e5 <vector78>:
.globl vector78
vector78:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $78
  1022e7:	6a 4e                	push   $0x4e
  jmp __alltraps
  1022e9:	e9 b9 07 00 00       	jmp    102aa7 <__alltraps>

001022ee <vector79>:
.globl vector79
vector79:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $79
  1022f0:	6a 4f                	push   $0x4f
  jmp __alltraps
  1022f2:	e9 b0 07 00 00       	jmp    102aa7 <__alltraps>

001022f7 <vector80>:
.globl vector80
vector80:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $80
  1022f9:	6a 50                	push   $0x50
  jmp __alltraps
  1022fb:	e9 a7 07 00 00       	jmp    102aa7 <__alltraps>

00102300 <vector81>:
.globl vector81
vector81:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $81
  102302:	6a 51                	push   $0x51
  jmp __alltraps
  102304:	e9 9e 07 00 00       	jmp    102aa7 <__alltraps>

00102309 <vector82>:
.globl vector82
vector82:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $82
  10230b:	6a 52                	push   $0x52
  jmp __alltraps
  10230d:	e9 95 07 00 00       	jmp    102aa7 <__alltraps>

00102312 <vector83>:
.globl vector83
vector83:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $83
  102314:	6a 53                	push   $0x53
  jmp __alltraps
  102316:	e9 8c 07 00 00       	jmp    102aa7 <__alltraps>

0010231b <vector84>:
.globl vector84
vector84:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $84
  10231d:	6a 54                	push   $0x54
  jmp __alltraps
  10231f:	e9 83 07 00 00       	jmp    102aa7 <__alltraps>

00102324 <vector85>:
.globl vector85
vector85:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $85
  102326:	6a 55                	push   $0x55
  jmp __alltraps
  102328:	e9 7a 07 00 00       	jmp    102aa7 <__alltraps>

0010232d <vector86>:
.globl vector86
vector86:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $86
  10232f:	6a 56                	push   $0x56
  jmp __alltraps
  102331:	e9 71 07 00 00       	jmp    102aa7 <__alltraps>

00102336 <vector87>:
.globl vector87
vector87:
  pushl $0
  102336:	6a 00                	push   $0x0
  pushl $87
  102338:	6a 57                	push   $0x57
  jmp __alltraps
  10233a:	e9 68 07 00 00       	jmp    102aa7 <__alltraps>

0010233f <vector88>:
.globl vector88
vector88:
  pushl $0
  10233f:	6a 00                	push   $0x0
  pushl $88
  102341:	6a 58                	push   $0x58
  jmp __alltraps
  102343:	e9 5f 07 00 00       	jmp    102aa7 <__alltraps>

00102348 <vector89>:
.globl vector89
vector89:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $89
  10234a:	6a 59                	push   $0x59
  jmp __alltraps
  10234c:	e9 56 07 00 00       	jmp    102aa7 <__alltraps>

00102351 <vector90>:
.globl vector90
vector90:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $90
  102353:	6a 5a                	push   $0x5a
  jmp __alltraps
  102355:	e9 4d 07 00 00       	jmp    102aa7 <__alltraps>

0010235a <vector91>:
.globl vector91
vector91:
  pushl $0
  10235a:	6a 00                	push   $0x0
  pushl $91
  10235c:	6a 5b                	push   $0x5b
  jmp __alltraps
  10235e:	e9 44 07 00 00       	jmp    102aa7 <__alltraps>

00102363 <vector92>:
.globl vector92
vector92:
  pushl $0
  102363:	6a 00                	push   $0x0
  pushl $92
  102365:	6a 5c                	push   $0x5c
  jmp __alltraps
  102367:	e9 3b 07 00 00       	jmp    102aa7 <__alltraps>

0010236c <vector93>:
.globl vector93
vector93:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $93
  10236e:	6a 5d                	push   $0x5d
  jmp __alltraps
  102370:	e9 32 07 00 00       	jmp    102aa7 <__alltraps>

00102375 <vector94>:
.globl vector94
vector94:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $94
  102377:	6a 5e                	push   $0x5e
  jmp __alltraps
  102379:	e9 29 07 00 00       	jmp    102aa7 <__alltraps>

0010237e <vector95>:
.globl vector95
vector95:
  pushl $0
  10237e:	6a 00                	push   $0x0
  pushl $95
  102380:	6a 5f                	push   $0x5f
  jmp __alltraps
  102382:	e9 20 07 00 00       	jmp    102aa7 <__alltraps>

00102387 <vector96>:
.globl vector96
vector96:
  pushl $0
  102387:	6a 00                	push   $0x0
  pushl $96
  102389:	6a 60                	push   $0x60
  jmp __alltraps
  10238b:	e9 17 07 00 00       	jmp    102aa7 <__alltraps>

00102390 <vector97>:
.globl vector97
vector97:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $97
  102392:	6a 61                	push   $0x61
  jmp __alltraps
  102394:	e9 0e 07 00 00       	jmp    102aa7 <__alltraps>

00102399 <vector98>:
.globl vector98
vector98:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $98
  10239b:	6a 62                	push   $0x62
  jmp __alltraps
  10239d:	e9 05 07 00 00       	jmp    102aa7 <__alltraps>

001023a2 <vector99>:
.globl vector99
vector99:
  pushl $0
  1023a2:	6a 00                	push   $0x0
  pushl $99
  1023a4:	6a 63                	push   $0x63
  jmp __alltraps
  1023a6:	e9 fc 06 00 00       	jmp    102aa7 <__alltraps>

001023ab <vector100>:
.globl vector100
vector100:
  pushl $0
  1023ab:	6a 00                	push   $0x0
  pushl $100
  1023ad:	6a 64                	push   $0x64
  jmp __alltraps
  1023af:	e9 f3 06 00 00       	jmp    102aa7 <__alltraps>

001023b4 <vector101>:
.globl vector101
vector101:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $101
  1023b6:	6a 65                	push   $0x65
  jmp __alltraps
  1023b8:	e9 ea 06 00 00       	jmp    102aa7 <__alltraps>

001023bd <vector102>:
.globl vector102
vector102:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $102
  1023bf:	6a 66                	push   $0x66
  jmp __alltraps
  1023c1:	e9 e1 06 00 00       	jmp    102aa7 <__alltraps>

001023c6 <vector103>:
.globl vector103
vector103:
  pushl $0
  1023c6:	6a 00                	push   $0x0
  pushl $103
  1023c8:	6a 67                	push   $0x67
  jmp __alltraps
  1023ca:	e9 d8 06 00 00       	jmp    102aa7 <__alltraps>

001023cf <vector104>:
.globl vector104
vector104:
  pushl $0
  1023cf:	6a 00                	push   $0x0
  pushl $104
  1023d1:	6a 68                	push   $0x68
  jmp __alltraps
  1023d3:	e9 cf 06 00 00       	jmp    102aa7 <__alltraps>

001023d8 <vector105>:
.globl vector105
vector105:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $105
  1023da:	6a 69                	push   $0x69
  jmp __alltraps
  1023dc:	e9 c6 06 00 00       	jmp    102aa7 <__alltraps>

001023e1 <vector106>:
.globl vector106
vector106:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $106
  1023e3:	6a 6a                	push   $0x6a
  jmp __alltraps
  1023e5:	e9 bd 06 00 00       	jmp    102aa7 <__alltraps>

001023ea <vector107>:
.globl vector107
vector107:
  pushl $0
  1023ea:	6a 00                	push   $0x0
  pushl $107
  1023ec:	6a 6b                	push   $0x6b
  jmp __alltraps
  1023ee:	e9 b4 06 00 00       	jmp    102aa7 <__alltraps>

001023f3 <vector108>:
.globl vector108
vector108:
  pushl $0
  1023f3:	6a 00                	push   $0x0
  pushl $108
  1023f5:	6a 6c                	push   $0x6c
  jmp __alltraps
  1023f7:	e9 ab 06 00 00       	jmp    102aa7 <__alltraps>

001023fc <vector109>:
.globl vector109
vector109:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $109
  1023fe:	6a 6d                	push   $0x6d
  jmp __alltraps
  102400:	e9 a2 06 00 00       	jmp    102aa7 <__alltraps>

00102405 <vector110>:
.globl vector110
vector110:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $110
  102407:	6a 6e                	push   $0x6e
  jmp __alltraps
  102409:	e9 99 06 00 00       	jmp    102aa7 <__alltraps>

0010240e <vector111>:
.globl vector111
vector111:
  pushl $0
  10240e:	6a 00                	push   $0x0
  pushl $111
  102410:	6a 6f                	push   $0x6f
  jmp __alltraps
  102412:	e9 90 06 00 00       	jmp    102aa7 <__alltraps>

00102417 <vector112>:
.globl vector112
vector112:
  pushl $0
  102417:	6a 00                	push   $0x0
  pushl $112
  102419:	6a 70                	push   $0x70
  jmp __alltraps
  10241b:	e9 87 06 00 00       	jmp    102aa7 <__alltraps>

00102420 <vector113>:
.globl vector113
vector113:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $113
  102422:	6a 71                	push   $0x71
  jmp __alltraps
  102424:	e9 7e 06 00 00       	jmp    102aa7 <__alltraps>

00102429 <vector114>:
.globl vector114
vector114:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $114
  10242b:	6a 72                	push   $0x72
  jmp __alltraps
  10242d:	e9 75 06 00 00       	jmp    102aa7 <__alltraps>

00102432 <vector115>:
.globl vector115
vector115:
  pushl $0
  102432:	6a 00                	push   $0x0
  pushl $115
  102434:	6a 73                	push   $0x73
  jmp __alltraps
  102436:	e9 6c 06 00 00       	jmp    102aa7 <__alltraps>

0010243b <vector116>:
.globl vector116
vector116:
  pushl $0
  10243b:	6a 00                	push   $0x0
  pushl $116
  10243d:	6a 74                	push   $0x74
  jmp __alltraps
  10243f:	e9 63 06 00 00       	jmp    102aa7 <__alltraps>

00102444 <vector117>:
.globl vector117
vector117:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $117
  102446:	6a 75                	push   $0x75
  jmp __alltraps
  102448:	e9 5a 06 00 00       	jmp    102aa7 <__alltraps>

0010244d <vector118>:
.globl vector118
vector118:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $118
  10244f:	6a 76                	push   $0x76
  jmp __alltraps
  102451:	e9 51 06 00 00       	jmp    102aa7 <__alltraps>

00102456 <vector119>:
.globl vector119
vector119:
  pushl $0
  102456:	6a 00                	push   $0x0
  pushl $119
  102458:	6a 77                	push   $0x77
  jmp __alltraps
  10245a:	e9 48 06 00 00       	jmp    102aa7 <__alltraps>

0010245f <vector120>:
.globl vector120
vector120:
  pushl $0
  10245f:	6a 00                	push   $0x0
  pushl $120
  102461:	6a 78                	push   $0x78
  jmp __alltraps
  102463:	e9 3f 06 00 00       	jmp    102aa7 <__alltraps>

00102468 <vector121>:
.globl vector121
vector121:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $121
  10246a:	6a 79                	push   $0x79
  jmp __alltraps
  10246c:	e9 36 06 00 00       	jmp    102aa7 <__alltraps>

00102471 <vector122>:
.globl vector122
vector122:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $122
  102473:	6a 7a                	push   $0x7a
  jmp __alltraps
  102475:	e9 2d 06 00 00       	jmp    102aa7 <__alltraps>

0010247a <vector123>:
.globl vector123
vector123:
  pushl $0
  10247a:	6a 00                	push   $0x0
  pushl $123
  10247c:	6a 7b                	push   $0x7b
  jmp __alltraps
  10247e:	e9 24 06 00 00       	jmp    102aa7 <__alltraps>

00102483 <vector124>:
.globl vector124
vector124:
  pushl $0
  102483:	6a 00                	push   $0x0
  pushl $124
  102485:	6a 7c                	push   $0x7c
  jmp __alltraps
  102487:	e9 1b 06 00 00       	jmp    102aa7 <__alltraps>

0010248c <vector125>:
.globl vector125
vector125:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $125
  10248e:	6a 7d                	push   $0x7d
  jmp __alltraps
  102490:	e9 12 06 00 00       	jmp    102aa7 <__alltraps>

00102495 <vector126>:
.globl vector126
vector126:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $126
  102497:	6a 7e                	push   $0x7e
  jmp __alltraps
  102499:	e9 09 06 00 00       	jmp    102aa7 <__alltraps>

0010249e <vector127>:
.globl vector127
vector127:
  pushl $0
  10249e:	6a 00                	push   $0x0
  pushl $127
  1024a0:	6a 7f                	push   $0x7f
  jmp __alltraps
  1024a2:	e9 00 06 00 00       	jmp    102aa7 <__alltraps>

001024a7 <vector128>:
.globl vector128
vector128:
  pushl $0
  1024a7:	6a 00                	push   $0x0
  pushl $128
  1024a9:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1024ae:	e9 f4 05 00 00       	jmp    102aa7 <__alltraps>

001024b3 <vector129>:
.globl vector129
vector129:
  pushl $0
  1024b3:	6a 00                	push   $0x0
  pushl $129
  1024b5:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1024ba:	e9 e8 05 00 00       	jmp    102aa7 <__alltraps>

001024bf <vector130>:
.globl vector130
vector130:
  pushl $0
  1024bf:	6a 00                	push   $0x0
  pushl $130
  1024c1:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1024c6:	e9 dc 05 00 00       	jmp    102aa7 <__alltraps>

001024cb <vector131>:
.globl vector131
vector131:
  pushl $0
  1024cb:	6a 00                	push   $0x0
  pushl $131
  1024cd:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1024d2:	e9 d0 05 00 00       	jmp    102aa7 <__alltraps>

001024d7 <vector132>:
.globl vector132
vector132:
  pushl $0
  1024d7:	6a 00                	push   $0x0
  pushl $132
  1024d9:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1024de:	e9 c4 05 00 00       	jmp    102aa7 <__alltraps>

001024e3 <vector133>:
.globl vector133
vector133:
  pushl $0
  1024e3:	6a 00                	push   $0x0
  pushl $133
  1024e5:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1024ea:	e9 b8 05 00 00       	jmp    102aa7 <__alltraps>

001024ef <vector134>:
.globl vector134
vector134:
  pushl $0
  1024ef:	6a 00                	push   $0x0
  pushl $134
  1024f1:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1024f6:	e9 ac 05 00 00       	jmp    102aa7 <__alltraps>

001024fb <vector135>:
.globl vector135
vector135:
  pushl $0
  1024fb:	6a 00                	push   $0x0
  pushl $135
  1024fd:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102502:	e9 a0 05 00 00       	jmp    102aa7 <__alltraps>

00102507 <vector136>:
.globl vector136
vector136:
  pushl $0
  102507:	6a 00                	push   $0x0
  pushl $136
  102509:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10250e:	e9 94 05 00 00       	jmp    102aa7 <__alltraps>

00102513 <vector137>:
.globl vector137
vector137:
  pushl $0
  102513:	6a 00                	push   $0x0
  pushl $137
  102515:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10251a:	e9 88 05 00 00       	jmp    102aa7 <__alltraps>

0010251f <vector138>:
.globl vector138
vector138:
  pushl $0
  10251f:	6a 00                	push   $0x0
  pushl $138
  102521:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102526:	e9 7c 05 00 00       	jmp    102aa7 <__alltraps>

0010252b <vector139>:
.globl vector139
vector139:
  pushl $0
  10252b:	6a 00                	push   $0x0
  pushl $139
  10252d:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102532:	e9 70 05 00 00       	jmp    102aa7 <__alltraps>

00102537 <vector140>:
.globl vector140
vector140:
  pushl $0
  102537:	6a 00                	push   $0x0
  pushl $140
  102539:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10253e:	e9 64 05 00 00       	jmp    102aa7 <__alltraps>

00102543 <vector141>:
.globl vector141
vector141:
  pushl $0
  102543:	6a 00                	push   $0x0
  pushl $141
  102545:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10254a:	e9 58 05 00 00       	jmp    102aa7 <__alltraps>

0010254f <vector142>:
.globl vector142
vector142:
  pushl $0
  10254f:	6a 00                	push   $0x0
  pushl $142
  102551:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102556:	e9 4c 05 00 00       	jmp    102aa7 <__alltraps>

0010255b <vector143>:
.globl vector143
vector143:
  pushl $0
  10255b:	6a 00                	push   $0x0
  pushl $143
  10255d:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102562:	e9 40 05 00 00       	jmp    102aa7 <__alltraps>

00102567 <vector144>:
.globl vector144
vector144:
  pushl $0
  102567:	6a 00                	push   $0x0
  pushl $144
  102569:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10256e:	e9 34 05 00 00       	jmp    102aa7 <__alltraps>

00102573 <vector145>:
.globl vector145
vector145:
  pushl $0
  102573:	6a 00                	push   $0x0
  pushl $145
  102575:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10257a:	e9 28 05 00 00       	jmp    102aa7 <__alltraps>

0010257f <vector146>:
.globl vector146
vector146:
  pushl $0
  10257f:	6a 00                	push   $0x0
  pushl $146
  102581:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102586:	e9 1c 05 00 00       	jmp    102aa7 <__alltraps>

0010258b <vector147>:
.globl vector147
vector147:
  pushl $0
  10258b:	6a 00                	push   $0x0
  pushl $147
  10258d:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102592:	e9 10 05 00 00       	jmp    102aa7 <__alltraps>

00102597 <vector148>:
.globl vector148
vector148:
  pushl $0
  102597:	6a 00                	push   $0x0
  pushl $148
  102599:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10259e:	e9 04 05 00 00       	jmp    102aa7 <__alltraps>

001025a3 <vector149>:
.globl vector149
vector149:
  pushl $0
  1025a3:	6a 00                	push   $0x0
  pushl $149
  1025a5:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1025aa:	e9 f8 04 00 00       	jmp    102aa7 <__alltraps>

001025af <vector150>:
.globl vector150
vector150:
  pushl $0
  1025af:	6a 00                	push   $0x0
  pushl $150
  1025b1:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1025b6:	e9 ec 04 00 00       	jmp    102aa7 <__alltraps>

001025bb <vector151>:
.globl vector151
vector151:
  pushl $0
  1025bb:	6a 00                	push   $0x0
  pushl $151
  1025bd:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1025c2:	e9 e0 04 00 00       	jmp    102aa7 <__alltraps>

001025c7 <vector152>:
.globl vector152
vector152:
  pushl $0
  1025c7:	6a 00                	push   $0x0
  pushl $152
  1025c9:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1025ce:	e9 d4 04 00 00       	jmp    102aa7 <__alltraps>

001025d3 <vector153>:
.globl vector153
vector153:
  pushl $0
  1025d3:	6a 00                	push   $0x0
  pushl $153
  1025d5:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1025da:	e9 c8 04 00 00       	jmp    102aa7 <__alltraps>

001025df <vector154>:
.globl vector154
vector154:
  pushl $0
  1025df:	6a 00                	push   $0x0
  pushl $154
  1025e1:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1025e6:	e9 bc 04 00 00       	jmp    102aa7 <__alltraps>

001025eb <vector155>:
.globl vector155
vector155:
  pushl $0
  1025eb:	6a 00                	push   $0x0
  pushl $155
  1025ed:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1025f2:	e9 b0 04 00 00       	jmp    102aa7 <__alltraps>

001025f7 <vector156>:
.globl vector156
vector156:
  pushl $0
  1025f7:	6a 00                	push   $0x0
  pushl $156
  1025f9:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1025fe:	e9 a4 04 00 00       	jmp    102aa7 <__alltraps>

00102603 <vector157>:
.globl vector157
vector157:
  pushl $0
  102603:	6a 00                	push   $0x0
  pushl $157
  102605:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10260a:	e9 98 04 00 00       	jmp    102aa7 <__alltraps>

0010260f <vector158>:
.globl vector158
vector158:
  pushl $0
  10260f:	6a 00                	push   $0x0
  pushl $158
  102611:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102616:	e9 8c 04 00 00       	jmp    102aa7 <__alltraps>

0010261b <vector159>:
.globl vector159
vector159:
  pushl $0
  10261b:	6a 00                	push   $0x0
  pushl $159
  10261d:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102622:	e9 80 04 00 00       	jmp    102aa7 <__alltraps>

00102627 <vector160>:
.globl vector160
vector160:
  pushl $0
  102627:	6a 00                	push   $0x0
  pushl $160
  102629:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10262e:	e9 74 04 00 00       	jmp    102aa7 <__alltraps>

00102633 <vector161>:
.globl vector161
vector161:
  pushl $0
  102633:	6a 00                	push   $0x0
  pushl $161
  102635:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10263a:	e9 68 04 00 00       	jmp    102aa7 <__alltraps>

0010263f <vector162>:
.globl vector162
vector162:
  pushl $0
  10263f:	6a 00                	push   $0x0
  pushl $162
  102641:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102646:	e9 5c 04 00 00       	jmp    102aa7 <__alltraps>

0010264b <vector163>:
.globl vector163
vector163:
  pushl $0
  10264b:	6a 00                	push   $0x0
  pushl $163
  10264d:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102652:	e9 50 04 00 00       	jmp    102aa7 <__alltraps>

00102657 <vector164>:
.globl vector164
vector164:
  pushl $0
  102657:	6a 00                	push   $0x0
  pushl $164
  102659:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10265e:	e9 44 04 00 00       	jmp    102aa7 <__alltraps>

00102663 <vector165>:
.globl vector165
vector165:
  pushl $0
  102663:	6a 00                	push   $0x0
  pushl $165
  102665:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10266a:	e9 38 04 00 00       	jmp    102aa7 <__alltraps>

0010266f <vector166>:
.globl vector166
vector166:
  pushl $0
  10266f:	6a 00                	push   $0x0
  pushl $166
  102671:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102676:	e9 2c 04 00 00       	jmp    102aa7 <__alltraps>

0010267b <vector167>:
.globl vector167
vector167:
  pushl $0
  10267b:	6a 00                	push   $0x0
  pushl $167
  10267d:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102682:	e9 20 04 00 00       	jmp    102aa7 <__alltraps>

00102687 <vector168>:
.globl vector168
vector168:
  pushl $0
  102687:	6a 00                	push   $0x0
  pushl $168
  102689:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10268e:	e9 14 04 00 00       	jmp    102aa7 <__alltraps>

00102693 <vector169>:
.globl vector169
vector169:
  pushl $0
  102693:	6a 00                	push   $0x0
  pushl $169
  102695:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10269a:	e9 08 04 00 00       	jmp    102aa7 <__alltraps>

0010269f <vector170>:
.globl vector170
vector170:
  pushl $0
  10269f:	6a 00                	push   $0x0
  pushl $170
  1026a1:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1026a6:	e9 fc 03 00 00       	jmp    102aa7 <__alltraps>

001026ab <vector171>:
.globl vector171
vector171:
  pushl $0
  1026ab:	6a 00                	push   $0x0
  pushl $171
  1026ad:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1026b2:	e9 f0 03 00 00       	jmp    102aa7 <__alltraps>

001026b7 <vector172>:
.globl vector172
vector172:
  pushl $0
  1026b7:	6a 00                	push   $0x0
  pushl $172
  1026b9:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1026be:	e9 e4 03 00 00       	jmp    102aa7 <__alltraps>

001026c3 <vector173>:
.globl vector173
vector173:
  pushl $0
  1026c3:	6a 00                	push   $0x0
  pushl $173
  1026c5:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1026ca:	e9 d8 03 00 00       	jmp    102aa7 <__alltraps>

001026cf <vector174>:
.globl vector174
vector174:
  pushl $0
  1026cf:	6a 00                	push   $0x0
  pushl $174
  1026d1:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1026d6:	e9 cc 03 00 00       	jmp    102aa7 <__alltraps>

001026db <vector175>:
.globl vector175
vector175:
  pushl $0
  1026db:	6a 00                	push   $0x0
  pushl $175
  1026dd:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1026e2:	e9 c0 03 00 00       	jmp    102aa7 <__alltraps>

001026e7 <vector176>:
.globl vector176
vector176:
  pushl $0
  1026e7:	6a 00                	push   $0x0
  pushl $176
  1026e9:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1026ee:	e9 b4 03 00 00       	jmp    102aa7 <__alltraps>

001026f3 <vector177>:
.globl vector177
vector177:
  pushl $0
  1026f3:	6a 00                	push   $0x0
  pushl $177
  1026f5:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1026fa:	e9 a8 03 00 00       	jmp    102aa7 <__alltraps>

001026ff <vector178>:
.globl vector178
vector178:
  pushl $0
  1026ff:	6a 00                	push   $0x0
  pushl $178
  102701:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102706:	e9 9c 03 00 00       	jmp    102aa7 <__alltraps>

0010270b <vector179>:
.globl vector179
vector179:
  pushl $0
  10270b:	6a 00                	push   $0x0
  pushl $179
  10270d:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102712:	e9 90 03 00 00       	jmp    102aa7 <__alltraps>

00102717 <vector180>:
.globl vector180
vector180:
  pushl $0
  102717:	6a 00                	push   $0x0
  pushl $180
  102719:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10271e:	e9 84 03 00 00       	jmp    102aa7 <__alltraps>

00102723 <vector181>:
.globl vector181
vector181:
  pushl $0
  102723:	6a 00                	push   $0x0
  pushl $181
  102725:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10272a:	e9 78 03 00 00       	jmp    102aa7 <__alltraps>

0010272f <vector182>:
.globl vector182
vector182:
  pushl $0
  10272f:	6a 00                	push   $0x0
  pushl $182
  102731:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102736:	e9 6c 03 00 00       	jmp    102aa7 <__alltraps>

0010273b <vector183>:
.globl vector183
vector183:
  pushl $0
  10273b:	6a 00                	push   $0x0
  pushl $183
  10273d:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102742:	e9 60 03 00 00       	jmp    102aa7 <__alltraps>

00102747 <vector184>:
.globl vector184
vector184:
  pushl $0
  102747:	6a 00                	push   $0x0
  pushl $184
  102749:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10274e:	e9 54 03 00 00       	jmp    102aa7 <__alltraps>

00102753 <vector185>:
.globl vector185
vector185:
  pushl $0
  102753:	6a 00                	push   $0x0
  pushl $185
  102755:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10275a:	e9 48 03 00 00       	jmp    102aa7 <__alltraps>

0010275f <vector186>:
.globl vector186
vector186:
  pushl $0
  10275f:	6a 00                	push   $0x0
  pushl $186
  102761:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102766:	e9 3c 03 00 00       	jmp    102aa7 <__alltraps>

0010276b <vector187>:
.globl vector187
vector187:
  pushl $0
  10276b:	6a 00                	push   $0x0
  pushl $187
  10276d:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102772:	e9 30 03 00 00       	jmp    102aa7 <__alltraps>

00102777 <vector188>:
.globl vector188
vector188:
  pushl $0
  102777:	6a 00                	push   $0x0
  pushl $188
  102779:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10277e:	e9 24 03 00 00       	jmp    102aa7 <__alltraps>

00102783 <vector189>:
.globl vector189
vector189:
  pushl $0
  102783:	6a 00                	push   $0x0
  pushl $189
  102785:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10278a:	e9 18 03 00 00       	jmp    102aa7 <__alltraps>

0010278f <vector190>:
.globl vector190
vector190:
  pushl $0
  10278f:	6a 00                	push   $0x0
  pushl $190
  102791:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102796:	e9 0c 03 00 00       	jmp    102aa7 <__alltraps>

0010279b <vector191>:
.globl vector191
vector191:
  pushl $0
  10279b:	6a 00                	push   $0x0
  pushl $191
  10279d:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1027a2:	e9 00 03 00 00       	jmp    102aa7 <__alltraps>

001027a7 <vector192>:
.globl vector192
vector192:
  pushl $0
  1027a7:	6a 00                	push   $0x0
  pushl $192
  1027a9:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1027ae:	e9 f4 02 00 00       	jmp    102aa7 <__alltraps>

001027b3 <vector193>:
.globl vector193
vector193:
  pushl $0
  1027b3:	6a 00                	push   $0x0
  pushl $193
  1027b5:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1027ba:	e9 e8 02 00 00       	jmp    102aa7 <__alltraps>

001027bf <vector194>:
.globl vector194
vector194:
  pushl $0
  1027bf:	6a 00                	push   $0x0
  pushl $194
  1027c1:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1027c6:	e9 dc 02 00 00       	jmp    102aa7 <__alltraps>

001027cb <vector195>:
.globl vector195
vector195:
  pushl $0
  1027cb:	6a 00                	push   $0x0
  pushl $195
  1027cd:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1027d2:	e9 d0 02 00 00       	jmp    102aa7 <__alltraps>

001027d7 <vector196>:
.globl vector196
vector196:
  pushl $0
  1027d7:	6a 00                	push   $0x0
  pushl $196
  1027d9:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1027de:	e9 c4 02 00 00       	jmp    102aa7 <__alltraps>

001027e3 <vector197>:
.globl vector197
vector197:
  pushl $0
  1027e3:	6a 00                	push   $0x0
  pushl $197
  1027e5:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1027ea:	e9 b8 02 00 00       	jmp    102aa7 <__alltraps>

001027ef <vector198>:
.globl vector198
vector198:
  pushl $0
  1027ef:	6a 00                	push   $0x0
  pushl $198
  1027f1:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1027f6:	e9 ac 02 00 00       	jmp    102aa7 <__alltraps>

001027fb <vector199>:
.globl vector199
vector199:
  pushl $0
  1027fb:	6a 00                	push   $0x0
  pushl $199
  1027fd:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102802:	e9 a0 02 00 00       	jmp    102aa7 <__alltraps>

00102807 <vector200>:
.globl vector200
vector200:
  pushl $0
  102807:	6a 00                	push   $0x0
  pushl $200
  102809:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10280e:	e9 94 02 00 00       	jmp    102aa7 <__alltraps>

00102813 <vector201>:
.globl vector201
vector201:
  pushl $0
  102813:	6a 00                	push   $0x0
  pushl $201
  102815:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10281a:	e9 88 02 00 00       	jmp    102aa7 <__alltraps>

0010281f <vector202>:
.globl vector202
vector202:
  pushl $0
  10281f:	6a 00                	push   $0x0
  pushl $202
  102821:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102826:	e9 7c 02 00 00       	jmp    102aa7 <__alltraps>

0010282b <vector203>:
.globl vector203
vector203:
  pushl $0
  10282b:	6a 00                	push   $0x0
  pushl $203
  10282d:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102832:	e9 70 02 00 00       	jmp    102aa7 <__alltraps>

00102837 <vector204>:
.globl vector204
vector204:
  pushl $0
  102837:	6a 00                	push   $0x0
  pushl $204
  102839:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10283e:	e9 64 02 00 00       	jmp    102aa7 <__alltraps>

00102843 <vector205>:
.globl vector205
vector205:
  pushl $0
  102843:	6a 00                	push   $0x0
  pushl $205
  102845:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10284a:	e9 58 02 00 00       	jmp    102aa7 <__alltraps>

0010284f <vector206>:
.globl vector206
vector206:
  pushl $0
  10284f:	6a 00                	push   $0x0
  pushl $206
  102851:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102856:	e9 4c 02 00 00       	jmp    102aa7 <__alltraps>

0010285b <vector207>:
.globl vector207
vector207:
  pushl $0
  10285b:	6a 00                	push   $0x0
  pushl $207
  10285d:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102862:	e9 40 02 00 00       	jmp    102aa7 <__alltraps>

00102867 <vector208>:
.globl vector208
vector208:
  pushl $0
  102867:	6a 00                	push   $0x0
  pushl $208
  102869:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10286e:	e9 34 02 00 00       	jmp    102aa7 <__alltraps>

00102873 <vector209>:
.globl vector209
vector209:
  pushl $0
  102873:	6a 00                	push   $0x0
  pushl $209
  102875:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10287a:	e9 28 02 00 00       	jmp    102aa7 <__alltraps>

0010287f <vector210>:
.globl vector210
vector210:
  pushl $0
  10287f:	6a 00                	push   $0x0
  pushl $210
  102881:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102886:	e9 1c 02 00 00       	jmp    102aa7 <__alltraps>

0010288b <vector211>:
.globl vector211
vector211:
  pushl $0
  10288b:	6a 00                	push   $0x0
  pushl $211
  10288d:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102892:	e9 10 02 00 00       	jmp    102aa7 <__alltraps>

00102897 <vector212>:
.globl vector212
vector212:
  pushl $0
  102897:	6a 00                	push   $0x0
  pushl $212
  102899:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10289e:	e9 04 02 00 00       	jmp    102aa7 <__alltraps>

001028a3 <vector213>:
.globl vector213
vector213:
  pushl $0
  1028a3:	6a 00                	push   $0x0
  pushl $213
  1028a5:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1028aa:	e9 f8 01 00 00       	jmp    102aa7 <__alltraps>

001028af <vector214>:
.globl vector214
vector214:
  pushl $0
  1028af:	6a 00                	push   $0x0
  pushl $214
  1028b1:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1028b6:	e9 ec 01 00 00       	jmp    102aa7 <__alltraps>

001028bb <vector215>:
.globl vector215
vector215:
  pushl $0
  1028bb:	6a 00                	push   $0x0
  pushl $215
  1028bd:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1028c2:	e9 e0 01 00 00       	jmp    102aa7 <__alltraps>

001028c7 <vector216>:
.globl vector216
vector216:
  pushl $0
  1028c7:	6a 00                	push   $0x0
  pushl $216
  1028c9:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1028ce:	e9 d4 01 00 00       	jmp    102aa7 <__alltraps>

001028d3 <vector217>:
.globl vector217
vector217:
  pushl $0
  1028d3:	6a 00                	push   $0x0
  pushl $217
  1028d5:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1028da:	e9 c8 01 00 00       	jmp    102aa7 <__alltraps>

001028df <vector218>:
.globl vector218
vector218:
  pushl $0
  1028df:	6a 00                	push   $0x0
  pushl $218
  1028e1:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1028e6:	e9 bc 01 00 00       	jmp    102aa7 <__alltraps>

001028eb <vector219>:
.globl vector219
vector219:
  pushl $0
  1028eb:	6a 00                	push   $0x0
  pushl $219
  1028ed:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1028f2:	e9 b0 01 00 00       	jmp    102aa7 <__alltraps>

001028f7 <vector220>:
.globl vector220
vector220:
  pushl $0
  1028f7:	6a 00                	push   $0x0
  pushl $220
  1028f9:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1028fe:	e9 a4 01 00 00       	jmp    102aa7 <__alltraps>

00102903 <vector221>:
.globl vector221
vector221:
  pushl $0
  102903:	6a 00                	push   $0x0
  pushl $221
  102905:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10290a:	e9 98 01 00 00       	jmp    102aa7 <__alltraps>

0010290f <vector222>:
.globl vector222
vector222:
  pushl $0
  10290f:	6a 00                	push   $0x0
  pushl $222
  102911:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102916:	e9 8c 01 00 00       	jmp    102aa7 <__alltraps>

0010291b <vector223>:
.globl vector223
vector223:
  pushl $0
  10291b:	6a 00                	push   $0x0
  pushl $223
  10291d:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102922:	e9 80 01 00 00       	jmp    102aa7 <__alltraps>

00102927 <vector224>:
.globl vector224
vector224:
  pushl $0
  102927:	6a 00                	push   $0x0
  pushl $224
  102929:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10292e:	e9 74 01 00 00       	jmp    102aa7 <__alltraps>

00102933 <vector225>:
.globl vector225
vector225:
  pushl $0
  102933:	6a 00                	push   $0x0
  pushl $225
  102935:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10293a:	e9 68 01 00 00       	jmp    102aa7 <__alltraps>

0010293f <vector226>:
.globl vector226
vector226:
  pushl $0
  10293f:	6a 00                	push   $0x0
  pushl $226
  102941:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102946:	e9 5c 01 00 00       	jmp    102aa7 <__alltraps>

0010294b <vector227>:
.globl vector227
vector227:
  pushl $0
  10294b:	6a 00                	push   $0x0
  pushl $227
  10294d:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102952:	e9 50 01 00 00       	jmp    102aa7 <__alltraps>

00102957 <vector228>:
.globl vector228
vector228:
  pushl $0
  102957:	6a 00                	push   $0x0
  pushl $228
  102959:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10295e:	e9 44 01 00 00       	jmp    102aa7 <__alltraps>

00102963 <vector229>:
.globl vector229
vector229:
  pushl $0
  102963:	6a 00                	push   $0x0
  pushl $229
  102965:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10296a:	e9 38 01 00 00       	jmp    102aa7 <__alltraps>

0010296f <vector230>:
.globl vector230
vector230:
  pushl $0
  10296f:	6a 00                	push   $0x0
  pushl $230
  102971:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102976:	e9 2c 01 00 00       	jmp    102aa7 <__alltraps>

0010297b <vector231>:
.globl vector231
vector231:
  pushl $0
  10297b:	6a 00                	push   $0x0
  pushl $231
  10297d:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102982:	e9 20 01 00 00       	jmp    102aa7 <__alltraps>

00102987 <vector232>:
.globl vector232
vector232:
  pushl $0
  102987:	6a 00                	push   $0x0
  pushl $232
  102989:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10298e:	e9 14 01 00 00       	jmp    102aa7 <__alltraps>

00102993 <vector233>:
.globl vector233
vector233:
  pushl $0
  102993:	6a 00                	push   $0x0
  pushl $233
  102995:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10299a:	e9 08 01 00 00       	jmp    102aa7 <__alltraps>

0010299f <vector234>:
.globl vector234
vector234:
  pushl $0
  10299f:	6a 00                	push   $0x0
  pushl $234
  1029a1:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1029a6:	e9 fc 00 00 00       	jmp    102aa7 <__alltraps>

001029ab <vector235>:
.globl vector235
vector235:
  pushl $0
  1029ab:	6a 00                	push   $0x0
  pushl $235
  1029ad:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1029b2:	e9 f0 00 00 00       	jmp    102aa7 <__alltraps>

001029b7 <vector236>:
.globl vector236
vector236:
  pushl $0
  1029b7:	6a 00                	push   $0x0
  pushl $236
  1029b9:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1029be:	e9 e4 00 00 00       	jmp    102aa7 <__alltraps>

001029c3 <vector237>:
.globl vector237
vector237:
  pushl $0
  1029c3:	6a 00                	push   $0x0
  pushl $237
  1029c5:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1029ca:	e9 d8 00 00 00       	jmp    102aa7 <__alltraps>

001029cf <vector238>:
.globl vector238
vector238:
  pushl $0
  1029cf:	6a 00                	push   $0x0
  pushl $238
  1029d1:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1029d6:	e9 cc 00 00 00       	jmp    102aa7 <__alltraps>

001029db <vector239>:
.globl vector239
vector239:
  pushl $0
  1029db:	6a 00                	push   $0x0
  pushl $239
  1029dd:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1029e2:	e9 c0 00 00 00       	jmp    102aa7 <__alltraps>

001029e7 <vector240>:
.globl vector240
vector240:
  pushl $0
  1029e7:	6a 00                	push   $0x0
  pushl $240
  1029e9:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1029ee:	e9 b4 00 00 00       	jmp    102aa7 <__alltraps>

001029f3 <vector241>:
.globl vector241
vector241:
  pushl $0
  1029f3:	6a 00                	push   $0x0
  pushl $241
  1029f5:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1029fa:	e9 a8 00 00 00       	jmp    102aa7 <__alltraps>

001029ff <vector242>:
.globl vector242
vector242:
  pushl $0
  1029ff:	6a 00                	push   $0x0
  pushl $242
  102a01:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102a06:	e9 9c 00 00 00       	jmp    102aa7 <__alltraps>

00102a0b <vector243>:
.globl vector243
vector243:
  pushl $0
  102a0b:	6a 00                	push   $0x0
  pushl $243
  102a0d:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102a12:	e9 90 00 00 00       	jmp    102aa7 <__alltraps>

00102a17 <vector244>:
.globl vector244
vector244:
  pushl $0
  102a17:	6a 00                	push   $0x0
  pushl $244
  102a19:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102a1e:	e9 84 00 00 00       	jmp    102aa7 <__alltraps>

00102a23 <vector245>:
.globl vector245
vector245:
  pushl $0
  102a23:	6a 00                	push   $0x0
  pushl $245
  102a25:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102a2a:	e9 78 00 00 00       	jmp    102aa7 <__alltraps>

00102a2f <vector246>:
.globl vector246
vector246:
  pushl $0
  102a2f:	6a 00                	push   $0x0
  pushl $246
  102a31:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102a36:	e9 6c 00 00 00       	jmp    102aa7 <__alltraps>

00102a3b <vector247>:
.globl vector247
vector247:
  pushl $0
  102a3b:	6a 00                	push   $0x0
  pushl $247
  102a3d:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102a42:	e9 60 00 00 00       	jmp    102aa7 <__alltraps>

00102a47 <vector248>:
.globl vector248
vector248:
  pushl $0
  102a47:	6a 00                	push   $0x0
  pushl $248
  102a49:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102a4e:	e9 54 00 00 00       	jmp    102aa7 <__alltraps>

00102a53 <vector249>:
.globl vector249
vector249:
  pushl $0
  102a53:	6a 00                	push   $0x0
  pushl $249
  102a55:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102a5a:	e9 48 00 00 00       	jmp    102aa7 <__alltraps>

00102a5f <vector250>:
.globl vector250
vector250:
  pushl $0
  102a5f:	6a 00                	push   $0x0
  pushl $250
  102a61:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102a66:	e9 3c 00 00 00       	jmp    102aa7 <__alltraps>

00102a6b <vector251>:
.globl vector251
vector251:
  pushl $0
  102a6b:	6a 00                	push   $0x0
  pushl $251
  102a6d:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102a72:	e9 30 00 00 00       	jmp    102aa7 <__alltraps>

00102a77 <vector252>:
.globl vector252
vector252:
  pushl $0
  102a77:	6a 00                	push   $0x0
  pushl $252
  102a79:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102a7e:	e9 24 00 00 00       	jmp    102aa7 <__alltraps>

00102a83 <vector253>:
.globl vector253
vector253:
  pushl $0
  102a83:	6a 00                	push   $0x0
  pushl $253
  102a85:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102a8a:	e9 18 00 00 00       	jmp    102aa7 <__alltraps>

00102a8f <vector254>:
.globl vector254
vector254:
  pushl $0
  102a8f:	6a 00                	push   $0x0
  pushl $254
  102a91:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102a96:	e9 0c 00 00 00       	jmp    102aa7 <__alltraps>

00102a9b <vector255>:
.globl vector255
vector255:
  pushl $0
  102a9b:	6a 00                	push   $0x0
  pushl $255
  102a9d:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102aa2:	e9 00 00 00 00       	jmp    102aa7 <__alltraps>

00102aa7 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102aa7:	1e                   	push   %ds
    pushl %es
  102aa8:	06                   	push   %es
    pushl %fs
  102aa9:	0f a0                	push   %fs
    pushl %gs
  102aab:	0f a8                	push   %gs
    pushal
  102aad:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102aae:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102ab3:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102ab5:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102ab7:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102ab8:	e8 60 f5 ff ff       	call   10201d <trap>

    # pop the pushed stack pointer
    popl %esp
  102abd:	5c                   	pop    %esp

00102abe <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102abe:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102abf:	0f a9                	pop    %gs
    popl %fs
  102ac1:	0f a1                	pop    %fs
    popl %es
  102ac3:	07                   	pop    %es
    popl %ds
  102ac4:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102ac5:	83 c4 08             	add    $0x8,%esp
    iret
  102ac8:	cf                   	iret   

00102ac9 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102ac9:	55                   	push   %ebp
  102aca:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102acc:	8b 45 08             	mov    0x8(%ebp),%eax
  102acf:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102ad2:	b8 23 00 00 00       	mov    $0x23,%eax
  102ad7:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102ad9:	b8 23 00 00 00       	mov    $0x23,%eax
  102ade:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102ae0:	b8 10 00 00 00       	mov    $0x10,%eax
  102ae5:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102ae7:	b8 10 00 00 00       	mov    $0x10,%eax
  102aec:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102aee:	b8 10 00 00 00       	mov    $0x10,%eax
  102af3:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102af5:	ea fc 2a 10 00 08 00 	ljmp   $0x8,$0x102afc
}
  102afc:	90                   	nop
  102afd:	5d                   	pop    %ebp
  102afe:	c3                   	ret    

00102aff <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102aff:	f3 0f 1e fb          	endbr32 
  102b03:	55                   	push   %ebp
  102b04:	89 e5                	mov    %esp,%ebp
  102b06:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102b09:	b8 20 19 11 00       	mov    $0x111920,%eax
  102b0e:	05 00 04 00 00       	add    $0x400,%eax
  102b13:	a3 a4 18 11 00       	mov    %eax,0x1118a4
    ts.ts_ss0 = KERNEL_DS;
  102b18:	66 c7 05 a8 18 11 00 	movw   $0x10,0x1118a8
  102b1f:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102b21:	66 c7 05 08 0a 11 00 	movw   $0x68,0x110a08
  102b28:	68 00 
  102b2a:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102b2f:	0f b7 c0             	movzwl %ax,%eax
  102b32:	66 a3 0a 0a 11 00    	mov    %ax,0x110a0a
  102b38:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102b3d:	c1 e8 10             	shr    $0x10,%eax
  102b40:	a2 0c 0a 11 00       	mov    %al,0x110a0c
  102b45:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b4c:	24 f0                	and    $0xf0,%al
  102b4e:	0c 09                	or     $0x9,%al
  102b50:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102b55:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b5c:	0c 10                	or     $0x10,%al
  102b5e:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102b63:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b6a:	24 9f                	and    $0x9f,%al
  102b6c:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102b71:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b78:	0c 80                	or     $0x80,%al
  102b7a:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102b7f:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102b86:	24 f0                	and    $0xf0,%al
  102b88:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102b8d:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102b94:	24 ef                	and    $0xef,%al
  102b96:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102b9b:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102ba2:	24 df                	and    $0xdf,%al
  102ba4:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102ba9:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102bb0:	0c 40                	or     $0x40,%al
  102bb2:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102bb7:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102bbe:	24 7f                	and    $0x7f,%al
  102bc0:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102bc5:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102bca:	c1 e8 18             	shr    $0x18,%eax
  102bcd:	a2 0f 0a 11 00       	mov    %al,0x110a0f
    gdt[SEG_TSS].sd_s = 0;
  102bd2:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102bd9:	24 ef                	and    $0xef,%al
  102bdb:	a2 0d 0a 11 00       	mov    %al,0x110a0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102be0:	c7 04 24 10 0a 11 00 	movl   $0x110a10,(%esp)
  102be7:	e8 dd fe ff ff       	call   102ac9 <lgdt>
  102bec:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102bf2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102bf6:	0f 00 d8             	ltr    %ax
}
  102bf9:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102bfa:	90                   	nop
  102bfb:	c9                   	leave  
  102bfc:	c3                   	ret    

00102bfd <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102bfd:	f3 0f 1e fb          	endbr32 
  102c01:	55                   	push   %ebp
  102c02:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102c04:	e8 f6 fe ff ff       	call   102aff <gdt_init>
}
  102c09:	90                   	nop
  102c0a:	5d                   	pop    %ebp
  102c0b:	c3                   	ret    

00102c0c <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102c0c:	f3 0f 1e fb          	endbr32 
  102c10:	55                   	push   %ebp
  102c11:	89 e5                	mov    %esp,%ebp
  102c13:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102c16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102c1d:	eb 03                	jmp    102c22 <strlen+0x16>
        cnt ++;
  102c1f:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102c22:	8b 45 08             	mov    0x8(%ebp),%eax
  102c25:	8d 50 01             	lea    0x1(%eax),%edx
  102c28:	89 55 08             	mov    %edx,0x8(%ebp)
  102c2b:	0f b6 00             	movzbl (%eax),%eax
  102c2e:	84 c0                	test   %al,%al
  102c30:	75 ed                	jne    102c1f <strlen+0x13>
    }
    return cnt;
  102c32:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102c35:	c9                   	leave  
  102c36:	c3                   	ret    

00102c37 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102c37:	f3 0f 1e fb          	endbr32 
  102c3b:	55                   	push   %ebp
  102c3c:	89 e5                	mov    %esp,%ebp
  102c3e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102c41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c48:	eb 03                	jmp    102c4d <strnlen+0x16>
        cnt ++;
  102c4a:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c50:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102c53:	73 10                	jae    102c65 <strnlen+0x2e>
  102c55:	8b 45 08             	mov    0x8(%ebp),%eax
  102c58:	8d 50 01             	lea    0x1(%eax),%edx
  102c5b:	89 55 08             	mov    %edx,0x8(%ebp)
  102c5e:	0f b6 00             	movzbl (%eax),%eax
  102c61:	84 c0                	test   %al,%al
  102c63:	75 e5                	jne    102c4a <strnlen+0x13>
    }
    return cnt;
  102c65:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102c68:	c9                   	leave  
  102c69:	c3                   	ret    

00102c6a <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102c6a:	f3 0f 1e fb          	endbr32 
  102c6e:	55                   	push   %ebp
  102c6f:	89 e5                	mov    %esp,%ebp
  102c71:	57                   	push   %edi
  102c72:	56                   	push   %esi
  102c73:	83 ec 20             	sub    $0x20,%esp
  102c76:	8b 45 08             	mov    0x8(%ebp),%eax
  102c79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102c82:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c88:	89 d1                	mov    %edx,%ecx
  102c8a:	89 c2                	mov    %eax,%edx
  102c8c:	89 ce                	mov    %ecx,%esi
  102c8e:	89 d7                	mov    %edx,%edi
  102c90:	ac                   	lods   %ds:(%esi),%al
  102c91:	aa                   	stos   %al,%es:(%edi)
  102c92:	84 c0                	test   %al,%al
  102c94:	75 fa                	jne    102c90 <strcpy+0x26>
  102c96:	89 fa                	mov    %edi,%edx
  102c98:	89 f1                	mov    %esi,%ecx
  102c9a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102c9d:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102ca0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102ca6:	83 c4 20             	add    $0x20,%esp
  102ca9:	5e                   	pop    %esi
  102caa:	5f                   	pop    %edi
  102cab:	5d                   	pop    %ebp
  102cac:	c3                   	ret    

00102cad <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102cad:	f3 0f 1e fb          	endbr32 
  102cb1:	55                   	push   %ebp
  102cb2:	89 e5                	mov    %esp,%ebp
  102cb4:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  102cba:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102cbd:	eb 1e                	jmp    102cdd <strncpy+0x30>
        if ((*p = *src) != '\0') {
  102cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cc2:	0f b6 10             	movzbl (%eax),%edx
  102cc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102cc8:	88 10                	mov    %dl,(%eax)
  102cca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ccd:	0f b6 00             	movzbl (%eax),%eax
  102cd0:	84 c0                	test   %al,%al
  102cd2:	74 03                	je     102cd7 <strncpy+0x2a>
            src ++;
  102cd4:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102cd7:	ff 45 fc             	incl   -0x4(%ebp)
  102cda:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  102cdd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ce1:	75 dc                	jne    102cbf <strncpy+0x12>
    }
    return dst;
  102ce3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102ce6:	c9                   	leave  
  102ce7:	c3                   	ret    

00102ce8 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102ce8:	f3 0f 1e fb          	endbr32 
  102cec:	55                   	push   %ebp
  102ced:	89 e5                	mov    %esp,%ebp
  102cef:	57                   	push   %edi
  102cf0:	56                   	push   %esi
  102cf1:	83 ec 20             	sub    $0x20,%esp
  102cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102d00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d06:	89 d1                	mov    %edx,%ecx
  102d08:	89 c2                	mov    %eax,%edx
  102d0a:	89 ce                	mov    %ecx,%esi
  102d0c:	89 d7                	mov    %edx,%edi
  102d0e:	ac                   	lods   %ds:(%esi),%al
  102d0f:	ae                   	scas   %es:(%edi),%al
  102d10:	75 08                	jne    102d1a <strcmp+0x32>
  102d12:	84 c0                	test   %al,%al
  102d14:	75 f8                	jne    102d0e <strcmp+0x26>
  102d16:	31 c0                	xor    %eax,%eax
  102d18:	eb 04                	jmp    102d1e <strcmp+0x36>
  102d1a:	19 c0                	sbb    %eax,%eax
  102d1c:	0c 01                	or     $0x1,%al
  102d1e:	89 fa                	mov    %edi,%edx
  102d20:	89 f1                	mov    %esi,%ecx
  102d22:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102d25:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102d28:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102d2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102d2e:	83 c4 20             	add    $0x20,%esp
  102d31:	5e                   	pop    %esi
  102d32:	5f                   	pop    %edi
  102d33:	5d                   	pop    %ebp
  102d34:	c3                   	ret    

00102d35 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102d35:	f3 0f 1e fb          	endbr32 
  102d39:	55                   	push   %ebp
  102d3a:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d3c:	eb 09                	jmp    102d47 <strncmp+0x12>
        n --, s1 ++, s2 ++;
  102d3e:	ff 4d 10             	decl   0x10(%ebp)
  102d41:	ff 45 08             	incl   0x8(%ebp)
  102d44:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d4b:	74 1a                	je     102d67 <strncmp+0x32>
  102d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d50:	0f b6 00             	movzbl (%eax),%eax
  102d53:	84 c0                	test   %al,%al
  102d55:	74 10                	je     102d67 <strncmp+0x32>
  102d57:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5a:	0f b6 10             	movzbl (%eax),%edx
  102d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d60:	0f b6 00             	movzbl (%eax),%eax
  102d63:	38 c2                	cmp    %al,%dl
  102d65:	74 d7                	je     102d3e <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102d67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d6b:	74 18                	je     102d85 <strncmp+0x50>
  102d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d70:	0f b6 00             	movzbl (%eax),%eax
  102d73:	0f b6 d0             	movzbl %al,%edx
  102d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d79:	0f b6 00             	movzbl (%eax),%eax
  102d7c:	0f b6 c0             	movzbl %al,%eax
  102d7f:	29 c2                	sub    %eax,%edx
  102d81:	89 d0                	mov    %edx,%eax
  102d83:	eb 05                	jmp    102d8a <strncmp+0x55>
  102d85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102d8a:	5d                   	pop    %ebp
  102d8b:	c3                   	ret    

00102d8c <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102d8c:	f3 0f 1e fb          	endbr32 
  102d90:	55                   	push   %ebp
  102d91:	89 e5                	mov    %esp,%ebp
  102d93:	83 ec 04             	sub    $0x4,%esp
  102d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d99:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102d9c:	eb 13                	jmp    102db1 <strchr+0x25>
        if (*s == c) {
  102d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  102da1:	0f b6 00             	movzbl (%eax),%eax
  102da4:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102da7:	75 05                	jne    102dae <strchr+0x22>
            return (char *)s;
  102da9:	8b 45 08             	mov    0x8(%ebp),%eax
  102dac:	eb 12                	jmp    102dc0 <strchr+0x34>
        }
        s ++;
  102dae:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102db1:	8b 45 08             	mov    0x8(%ebp),%eax
  102db4:	0f b6 00             	movzbl (%eax),%eax
  102db7:	84 c0                	test   %al,%al
  102db9:	75 e3                	jne    102d9e <strchr+0x12>
    }
    return NULL;
  102dbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102dc0:	c9                   	leave  
  102dc1:	c3                   	ret    

00102dc2 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102dc2:	f3 0f 1e fb          	endbr32 
  102dc6:	55                   	push   %ebp
  102dc7:	89 e5                	mov    %esp,%ebp
  102dc9:	83 ec 04             	sub    $0x4,%esp
  102dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dcf:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102dd2:	eb 0e                	jmp    102de2 <strfind+0x20>
        if (*s == c) {
  102dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  102dd7:	0f b6 00             	movzbl (%eax),%eax
  102dda:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102ddd:	74 0f                	je     102dee <strfind+0x2c>
            break;
        }
        s ++;
  102ddf:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102de2:	8b 45 08             	mov    0x8(%ebp),%eax
  102de5:	0f b6 00             	movzbl (%eax),%eax
  102de8:	84 c0                	test   %al,%al
  102dea:	75 e8                	jne    102dd4 <strfind+0x12>
  102dec:	eb 01                	jmp    102def <strfind+0x2d>
            break;
  102dee:	90                   	nop
    }
    return (char *)s;
  102def:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102df2:	c9                   	leave  
  102df3:	c3                   	ret    

00102df4 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102df4:	f3 0f 1e fb          	endbr32 
  102df8:	55                   	push   %ebp
  102df9:	89 e5                	mov    %esp,%ebp
  102dfb:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102dfe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102e05:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102e0c:	eb 03                	jmp    102e11 <strtol+0x1d>
        s ++;
  102e0e:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102e11:	8b 45 08             	mov    0x8(%ebp),%eax
  102e14:	0f b6 00             	movzbl (%eax),%eax
  102e17:	3c 20                	cmp    $0x20,%al
  102e19:	74 f3                	je     102e0e <strtol+0x1a>
  102e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e1e:	0f b6 00             	movzbl (%eax),%eax
  102e21:	3c 09                	cmp    $0x9,%al
  102e23:	74 e9                	je     102e0e <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  102e25:	8b 45 08             	mov    0x8(%ebp),%eax
  102e28:	0f b6 00             	movzbl (%eax),%eax
  102e2b:	3c 2b                	cmp    $0x2b,%al
  102e2d:	75 05                	jne    102e34 <strtol+0x40>
        s ++;
  102e2f:	ff 45 08             	incl   0x8(%ebp)
  102e32:	eb 14                	jmp    102e48 <strtol+0x54>
    }
    else if (*s == '-') {
  102e34:	8b 45 08             	mov    0x8(%ebp),%eax
  102e37:	0f b6 00             	movzbl (%eax),%eax
  102e3a:	3c 2d                	cmp    $0x2d,%al
  102e3c:	75 0a                	jne    102e48 <strtol+0x54>
        s ++, neg = 1;
  102e3e:	ff 45 08             	incl   0x8(%ebp)
  102e41:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102e48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e4c:	74 06                	je     102e54 <strtol+0x60>
  102e4e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102e52:	75 22                	jne    102e76 <strtol+0x82>
  102e54:	8b 45 08             	mov    0x8(%ebp),%eax
  102e57:	0f b6 00             	movzbl (%eax),%eax
  102e5a:	3c 30                	cmp    $0x30,%al
  102e5c:	75 18                	jne    102e76 <strtol+0x82>
  102e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e61:	40                   	inc    %eax
  102e62:	0f b6 00             	movzbl (%eax),%eax
  102e65:	3c 78                	cmp    $0x78,%al
  102e67:	75 0d                	jne    102e76 <strtol+0x82>
        s += 2, base = 16;
  102e69:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102e6d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102e74:	eb 29                	jmp    102e9f <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  102e76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e7a:	75 16                	jne    102e92 <strtol+0x9e>
  102e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e7f:	0f b6 00             	movzbl (%eax),%eax
  102e82:	3c 30                	cmp    $0x30,%al
  102e84:	75 0c                	jne    102e92 <strtol+0x9e>
        s ++, base = 8;
  102e86:	ff 45 08             	incl   0x8(%ebp)
  102e89:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102e90:	eb 0d                	jmp    102e9f <strtol+0xab>
    }
    else if (base == 0) {
  102e92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e96:	75 07                	jne    102e9f <strtol+0xab>
        base = 10;
  102e98:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea2:	0f b6 00             	movzbl (%eax),%eax
  102ea5:	3c 2f                	cmp    $0x2f,%al
  102ea7:	7e 1b                	jle    102ec4 <strtol+0xd0>
  102ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  102eac:	0f b6 00             	movzbl (%eax),%eax
  102eaf:	3c 39                	cmp    $0x39,%al
  102eb1:	7f 11                	jg     102ec4 <strtol+0xd0>
            dig = *s - '0';
  102eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb6:	0f b6 00             	movzbl (%eax),%eax
  102eb9:	0f be c0             	movsbl %al,%eax
  102ebc:	83 e8 30             	sub    $0x30,%eax
  102ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ec2:	eb 48                	jmp    102f0c <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec7:	0f b6 00             	movzbl (%eax),%eax
  102eca:	3c 60                	cmp    $0x60,%al
  102ecc:	7e 1b                	jle    102ee9 <strtol+0xf5>
  102ece:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed1:	0f b6 00             	movzbl (%eax),%eax
  102ed4:	3c 7a                	cmp    $0x7a,%al
  102ed6:	7f 11                	jg     102ee9 <strtol+0xf5>
            dig = *s - 'a' + 10;
  102ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  102edb:	0f b6 00             	movzbl (%eax),%eax
  102ede:	0f be c0             	movsbl %al,%eax
  102ee1:	83 e8 57             	sub    $0x57,%eax
  102ee4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ee7:	eb 23                	jmp    102f0c <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  102eec:	0f b6 00             	movzbl (%eax),%eax
  102eef:	3c 40                	cmp    $0x40,%al
  102ef1:	7e 3b                	jle    102f2e <strtol+0x13a>
  102ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef6:	0f b6 00             	movzbl (%eax),%eax
  102ef9:	3c 5a                	cmp    $0x5a,%al
  102efb:	7f 31                	jg     102f2e <strtol+0x13a>
            dig = *s - 'A' + 10;
  102efd:	8b 45 08             	mov    0x8(%ebp),%eax
  102f00:	0f b6 00             	movzbl (%eax),%eax
  102f03:	0f be c0             	movsbl %al,%eax
  102f06:	83 e8 37             	sub    $0x37,%eax
  102f09:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f0f:	3b 45 10             	cmp    0x10(%ebp),%eax
  102f12:	7d 19                	jge    102f2d <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  102f14:	ff 45 08             	incl   0x8(%ebp)
  102f17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f1a:	0f af 45 10          	imul   0x10(%ebp),%eax
  102f1e:	89 c2                	mov    %eax,%edx
  102f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f23:	01 d0                	add    %edx,%eax
  102f25:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102f28:	e9 72 ff ff ff       	jmp    102e9f <strtol+0xab>
            break;
  102f2d:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102f2e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f32:	74 08                	je     102f3c <strtol+0x148>
        *endptr = (char *) s;
  102f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f37:	8b 55 08             	mov    0x8(%ebp),%edx
  102f3a:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102f3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102f40:	74 07                	je     102f49 <strtol+0x155>
  102f42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f45:	f7 d8                	neg    %eax
  102f47:	eb 03                	jmp    102f4c <strtol+0x158>
  102f49:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102f4c:	c9                   	leave  
  102f4d:	c3                   	ret    

00102f4e <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102f4e:	f3 0f 1e fb          	endbr32 
  102f52:	55                   	push   %ebp
  102f53:	89 e5                	mov    %esp,%ebp
  102f55:	57                   	push   %edi
  102f56:	83 ec 24             	sub    $0x24,%esp
  102f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f5c:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102f5f:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  102f63:	8b 45 08             	mov    0x8(%ebp),%eax
  102f66:	89 45 f8             	mov    %eax,-0x8(%ebp)
  102f69:	88 55 f7             	mov    %dl,-0x9(%ebp)
  102f6c:	8b 45 10             	mov    0x10(%ebp),%eax
  102f6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102f72:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102f75:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102f79:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102f7c:	89 d7                	mov    %edx,%edi
  102f7e:	f3 aa                	rep stos %al,%es:(%edi)
  102f80:	89 fa                	mov    %edi,%edx
  102f82:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102f85:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102f88:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102f8b:	83 c4 24             	add    $0x24,%esp
  102f8e:	5f                   	pop    %edi
  102f8f:	5d                   	pop    %ebp
  102f90:	c3                   	ret    

00102f91 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102f91:	f3 0f 1e fb          	endbr32 
  102f95:	55                   	push   %ebp
  102f96:	89 e5                	mov    %esp,%ebp
  102f98:	57                   	push   %edi
  102f99:	56                   	push   %esi
  102f9a:	53                   	push   %ebx
  102f9b:	83 ec 30             	sub    $0x30,%esp
  102f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  102fa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fa7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102faa:	8b 45 10             	mov    0x10(%ebp),%eax
  102fad:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102fb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fb3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102fb6:	73 42                	jae    102ffa <memmove+0x69>
  102fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fbb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102fbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fc1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102fc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fc7:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102fca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102fcd:	c1 e8 02             	shr    $0x2,%eax
  102fd0:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102fd2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102fd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fd8:	89 d7                	mov    %edx,%edi
  102fda:	89 c6                	mov    %eax,%esi
  102fdc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102fde:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102fe1:	83 e1 03             	and    $0x3,%ecx
  102fe4:	74 02                	je     102fe8 <memmove+0x57>
  102fe6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102fe8:	89 f0                	mov    %esi,%eax
  102fea:	89 fa                	mov    %edi,%edx
  102fec:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102fef:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102ff2:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102ff5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  102ff8:	eb 36                	jmp    103030 <memmove+0x9f>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102ffa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ffd:	8d 50 ff             	lea    -0x1(%eax),%edx
  103000:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103003:	01 c2                	add    %eax,%edx
  103005:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103008:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10300b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10300e:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  103011:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103014:	89 c1                	mov    %eax,%ecx
  103016:	89 d8                	mov    %ebx,%eax
  103018:	89 d6                	mov    %edx,%esi
  10301a:	89 c7                	mov    %eax,%edi
  10301c:	fd                   	std    
  10301d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10301f:	fc                   	cld    
  103020:	89 f8                	mov    %edi,%eax
  103022:	89 f2                	mov    %esi,%edx
  103024:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103027:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10302a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  10302d:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  103030:	83 c4 30             	add    $0x30,%esp
  103033:	5b                   	pop    %ebx
  103034:	5e                   	pop    %esi
  103035:	5f                   	pop    %edi
  103036:	5d                   	pop    %ebp
  103037:	c3                   	ret    

00103038 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  103038:	f3 0f 1e fb          	endbr32 
  10303c:	55                   	push   %ebp
  10303d:	89 e5                	mov    %esp,%ebp
  10303f:	57                   	push   %edi
  103040:	56                   	push   %esi
  103041:	83 ec 20             	sub    $0x20,%esp
  103044:	8b 45 08             	mov    0x8(%ebp),%eax
  103047:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10304a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10304d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103050:	8b 45 10             	mov    0x10(%ebp),%eax
  103053:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103056:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103059:	c1 e8 02             	shr    $0x2,%eax
  10305c:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10305e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103061:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103064:	89 d7                	mov    %edx,%edi
  103066:	89 c6                	mov    %eax,%esi
  103068:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10306a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10306d:	83 e1 03             	and    $0x3,%ecx
  103070:	74 02                	je     103074 <memcpy+0x3c>
  103072:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103074:	89 f0                	mov    %esi,%eax
  103076:	89 fa                	mov    %edi,%edx
  103078:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10307b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10307e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  103081:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103084:	83 c4 20             	add    $0x20,%esp
  103087:	5e                   	pop    %esi
  103088:	5f                   	pop    %edi
  103089:	5d                   	pop    %ebp
  10308a:	c3                   	ret    

0010308b <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10308b:	f3 0f 1e fb          	endbr32 
  10308f:	55                   	push   %ebp
  103090:	89 e5                	mov    %esp,%ebp
  103092:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103095:	8b 45 08             	mov    0x8(%ebp),%eax
  103098:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10309b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10309e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1030a1:	eb 2e                	jmp    1030d1 <memcmp+0x46>
        if (*s1 != *s2) {
  1030a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030a6:	0f b6 10             	movzbl (%eax),%edx
  1030a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1030ac:	0f b6 00             	movzbl (%eax),%eax
  1030af:	38 c2                	cmp    %al,%dl
  1030b1:	74 18                	je     1030cb <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1030b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030b6:	0f b6 00             	movzbl (%eax),%eax
  1030b9:	0f b6 d0             	movzbl %al,%edx
  1030bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1030bf:	0f b6 00             	movzbl (%eax),%eax
  1030c2:	0f b6 c0             	movzbl %al,%eax
  1030c5:	29 c2                	sub    %eax,%edx
  1030c7:	89 d0                	mov    %edx,%eax
  1030c9:	eb 18                	jmp    1030e3 <memcmp+0x58>
        }
        s1 ++, s2 ++;
  1030cb:	ff 45 fc             	incl   -0x4(%ebp)
  1030ce:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  1030d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1030d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  1030d7:	89 55 10             	mov    %edx,0x10(%ebp)
  1030da:	85 c0                	test   %eax,%eax
  1030dc:	75 c5                	jne    1030a3 <memcmp+0x18>
    }
    return 0;
  1030de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1030e3:	c9                   	leave  
  1030e4:	c3                   	ret    

001030e5 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1030e5:	f3 0f 1e fb          	endbr32 
  1030e9:	55                   	push   %ebp
  1030ea:	89 e5                	mov    %esp,%ebp
  1030ec:	83 ec 58             	sub    $0x58,%esp
  1030ef:	8b 45 10             	mov    0x10(%ebp),%eax
  1030f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1030f5:	8b 45 14             	mov    0x14(%ebp),%eax
  1030f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1030fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1030fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103101:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103104:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  103107:	8b 45 18             	mov    0x18(%ebp),%eax
  10310a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10310d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103110:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103113:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103116:	89 55 f0             	mov    %edx,-0x10(%ebp)
  103119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10311c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10311f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103123:	74 1c                	je     103141 <printnum+0x5c>
  103125:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103128:	ba 00 00 00 00       	mov    $0x0,%edx
  10312d:	f7 75 e4             	divl   -0x1c(%ebp)
  103130:	89 55 f4             	mov    %edx,-0xc(%ebp)
  103133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103136:	ba 00 00 00 00       	mov    $0x0,%edx
  10313b:	f7 75 e4             	divl   -0x1c(%ebp)
  10313e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103141:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103144:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103147:	f7 75 e4             	divl   -0x1c(%ebp)
  10314a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10314d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  103150:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103153:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103156:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103159:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10315c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10315f:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  103162:	8b 45 18             	mov    0x18(%ebp),%eax
  103165:	ba 00 00 00 00       	mov    $0x0,%edx
  10316a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10316d:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103170:	19 d1                	sbb    %edx,%ecx
  103172:	72 4c                	jb     1031c0 <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  103174:	8b 45 1c             	mov    0x1c(%ebp),%eax
  103177:	8d 50 ff             	lea    -0x1(%eax),%edx
  10317a:	8b 45 20             	mov    0x20(%ebp),%eax
  10317d:	89 44 24 18          	mov    %eax,0x18(%esp)
  103181:	89 54 24 14          	mov    %edx,0x14(%esp)
  103185:	8b 45 18             	mov    0x18(%ebp),%eax
  103188:	89 44 24 10          	mov    %eax,0x10(%esp)
  10318c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10318f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103192:	89 44 24 08          	mov    %eax,0x8(%esp)
  103196:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10319a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10319d:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a4:	89 04 24             	mov    %eax,(%esp)
  1031a7:	e8 39 ff ff ff       	call   1030e5 <printnum>
  1031ac:	eb 1b                	jmp    1031c9 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1031ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031b5:	8b 45 20             	mov    0x20(%ebp),%eax
  1031b8:	89 04 24             	mov    %eax,(%esp)
  1031bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1031be:	ff d0                	call   *%eax
        while (-- width > 0)
  1031c0:	ff 4d 1c             	decl   0x1c(%ebp)
  1031c3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1031c7:	7f e5                	jg     1031ae <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1031c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1031cc:	05 30 3f 10 00       	add    $0x103f30,%eax
  1031d1:	0f b6 00             	movzbl (%eax),%eax
  1031d4:	0f be c0             	movsbl %al,%eax
  1031d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1031da:	89 54 24 04          	mov    %edx,0x4(%esp)
  1031de:	89 04 24             	mov    %eax,(%esp)
  1031e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e4:	ff d0                	call   *%eax
}
  1031e6:	90                   	nop
  1031e7:	c9                   	leave  
  1031e8:	c3                   	ret    

001031e9 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1031e9:	f3 0f 1e fb          	endbr32 
  1031ed:	55                   	push   %ebp
  1031ee:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1031f0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1031f4:	7e 14                	jle    10320a <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  1031f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1031f9:	8b 00                	mov    (%eax),%eax
  1031fb:	8d 48 08             	lea    0x8(%eax),%ecx
  1031fe:	8b 55 08             	mov    0x8(%ebp),%edx
  103201:	89 0a                	mov    %ecx,(%edx)
  103203:	8b 50 04             	mov    0x4(%eax),%edx
  103206:	8b 00                	mov    (%eax),%eax
  103208:	eb 30                	jmp    10323a <getuint+0x51>
    }
    else if (lflag) {
  10320a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10320e:	74 16                	je     103226 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  103210:	8b 45 08             	mov    0x8(%ebp),%eax
  103213:	8b 00                	mov    (%eax),%eax
  103215:	8d 48 04             	lea    0x4(%eax),%ecx
  103218:	8b 55 08             	mov    0x8(%ebp),%edx
  10321b:	89 0a                	mov    %ecx,(%edx)
  10321d:	8b 00                	mov    (%eax),%eax
  10321f:	ba 00 00 00 00       	mov    $0x0,%edx
  103224:	eb 14                	jmp    10323a <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  103226:	8b 45 08             	mov    0x8(%ebp),%eax
  103229:	8b 00                	mov    (%eax),%eax
  10322b:	8d 48 04             	lea    0x4(%eax),%ecx
  10322e:	8b 55 08             	mov    0x8(%ebp),%edx
  103231:	89 0a                	mov    %ecx,(%edx)
  103233:	8b 00                	mov    (%eax),%eax
  103235:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10323a:	5d                   	pop    %ebp
  10323b:	c3                   	ret    

0010323c <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10323c:	f3 0f 1e fb          	endbr32 
  103240:	55                   	push   %ebp
  103241:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103243:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103247:	7e 14                	jle    10325d <getint+0x21>
        return va_arg(*ap, long long);
  103249:	8b 45 08             	mov    0x8(%ebp),%eax
  10324c:	8b 00                	mov    (%eax),%eax
  10324e:	8d 48 08             	lea    0x8(%eax),%ecx
  103251:	8b 55 08             	mov    0x8(%ebp),%edx
  103254:	89 0a                	mov    %ecx,(%edx)
  103256:	8b 50 04             	mov    0x4(%eax),%edx
  103259:	8b 00                	mov    (%eax),%eax
  10325b:	eb 28                	jmp    103285 <getint+0x49>
    }
    else if (lflag) {
  10325d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103261:	74 12                	je     103275 <getint+0x39>
        return va_arg(*ap, long);
  103263:	8b 45 08             	mov    0x8(%ebp),%eax
  103266:	8b 00                	mov    (%eax),%eax
  103268:	8d 48 04             	lea    0x4(%eax),%ecx
  10326b:	8b 55 08             	mov    0x8(%ebp),%edx
  10326e:	89 0a                	mov    %ecx,(%edx)
  103270:	8b 00                	mov    (%eax),%eax
  103272:	99                   	cltd   
  103273:	eb 10                	jmp    103285 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  103275:	8b 45 08             	mov    0x8(%ebp),%eax
  103278:	8b 00                	mov    (%eax),%eax
  10327a:	8d 48 04             	lea    0x4(%eax),%ecx
  10327d:	8b 55 08             	mov    0x8(%ebp),%edx
  103280:	89 0a                	mov    %ecx,(%edx)
  103282:	8b 00                	mov    (%eax),%eax
  103284:	99                   	cltd   
    }
}
  103285:	5d                   	pop    %ebp
  103286:	c3                   	ret    

00103287 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  103287:	f3 0f 1e fb          	endbr32 
  10328b:	55                   	push   %ebp
  10328c:	89 e5                	mov    %esp,%ebp
  10328e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  103291:	8d 45 14             	lea    0x14(%ebp),%eax
  103294:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  103297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10329a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10329e:	8b 45 10             	mov    0x10(%ebp),%eax
  1032a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1032a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1032af:	89 04 24             	mov    %eax,(%esp)
  1032b2:	e8 03 00 00 00       	call   1032ba <vprintfmt>
    va_end(ap);
}
  1032b7:	90                   	nop
  1032b8:	c9                   	leave  
  1032b9:	c3                   	ret    

001032ba <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1032ba:	f3 0f 1e fb          	endbr32 
  1032be:	55                   	push   %ebp
  1032bf:	89 e5                	mov    %esp,%ebp
  1032c1:	56                   	push   %esi
  1032c2:	53                   	push   %ebx
  1032c3:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1032c6:	eb 17                	jmp    1032df <vprintfmt+0x25>
            if (ch == '\0') {
  1032c8:	85 db                	test   %ebx,%ebx
  1032ca:	0f 84 c0 03 00 00    	je     103690 <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  1032d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032d7:	89 1c 24             	mov    %ebx,(%esp)
  1032da:	8b 45 08             	mov    0x8(%ebp),%eax
  1032dd:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1032df:	8b 45 10             	mov    0x10(%ebp),%eax
  1032e2:	8d 50 01             	lea    0x1(%eax),%edx
  1032e5:	89 55 10             	mov    %edx,0x10(%ebp)
  1032e8:	0f b6 00             	movzbl (%eax),%eax
  1032eb:	0f b6 d8             	movzbl %al,%ebx
  1032ee:	83 fb 25             	cmp    $0x25,%ebx
  1032f1:	75 d5                	jne    1032c8 <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  1032f3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1032f7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1032fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103301:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  103304:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10330b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10330e:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  103311:	8b 45 10             	mov    0x10(%ebp),%eax
  103314:	8d 50 01             	lea    0x1(%eax),%edx
  103317:	89 55 10             	mov    %edx,0x10(%ebp)
  10331a:	0f b6 00             	movzbl (%eax),%eax
  10331d:	0f b6 d8             	movzbl %al,%ebx
  103320:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103323:	83 f8 55             	cmp    $0x55,%eax
  103326:	0f 87 38 03 00 00    	ja     103664 <vprintfmt+0x3aa>
  10332c:	8b 04 85 54 3f 10 00 	mov    0x103f54(,%eax,4),%eax
  103333:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  103336:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10333a:	eb d5                	jmp    103311 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10333c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  103340:	eb cf                	jmp    103311 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  103342:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  103349:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10334c:	89 d0                	mov    %edx,%eax
  10334e:	c1 e0 02             	shl    $0x2,%eax
  103351:	01 d0                	add    %edx,%eax
  103353:	01 c0                	add    %eax,%eax
  103355:	01 d8                	add    %ebx,%eax
  103357:	83 e8 30             	sub    $0x30,%eax
  10335a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10335d:	8b 45 10             	mov    0x10(%ebp),%eax
  103360:	0f b6 00             	movzbl (%eax),%eax
  103363:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  103366:	83 fb 2f             	cmp    $0x2f,%ebx
  103369:	7e 38                	jle    1033a3 <vprintfmt+0xe9>
  10336b:	83 fb 39             	cmp    $0x39,%ebx
  10336e:	7f 33                	jg     1033a3 <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  103370:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  103373:	eb d4                	jmp    103349 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  103375:	8b 45 14             	mov    0x14(%ebp),%eax
  103378:	8d 50 04             	lea    0x4(%eax),%edx
  10337b:	89 55 14             	mov    %edx,0x14(%ebp)
  10337e:	8b 00                	mov    (%eax),%eax
  103380:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  103383:	eb 1f                	jmp    1033a4 <vprintfmt+0xea>

        case '.':
            if (width < 0)
  103385:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103389:	79 86                	jns    103311 <vprintfmt+0x57>
                width = 0;
  10338b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  103392:	e9 7a ff ff ff       	jmp    103311 <vprintfmt+0x57>

        case '#':
            altflag = 1;
  103397:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10339e:	e9 6e ff ff ff       	jmp    103311 <vprintfmt+0x57>
            goto process_precision;
  1033a3:	90                   	nop

        process_precision:
            if (width < 0)
  1033a4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1033a8:	0f 89 63 ff ff ff    	jns    103311 <vprintfmt+0x57>
                width = precision, precision = -1;
  1033ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1033b4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1033bb:	e9 51 ff ff ff       	jmp    103311 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1033c0:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  1033c3:	e9 49 ff ff ff       	jmp    103311 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1033c8:	8b 45 14             	mov    0x14(%ebp),%eax
  1033cb:	8d 50 04             	lea    0x4(%eax),%edx
  1033ce:	89 55 14             	mov    %edx,0x14(%ebp)
  1033d1:	8b 00                	mov    (%eax),%eax
  1033d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  1033d6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1033da:	89 04 24             	mov    %eax,(%esp)
  1033dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1033e0:	ff d0                	call   *%eax
            break;
  1033e2:	e9 a4 02 00 00       	jmp    10368b <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1033e7:	8b 45 14             	mov    0x14(%ebp),%eax
  1033ea:	8d 50 04             	lea    0x4(%eax),%edx
  1033ed:	89 55 14             	mov    %edx,0x14(%ebp)
  1033f0:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1033f2:	85 db                	test   %ebx,%ebx
  1033f4:	79 02                	jns    1033f8 <vprintfmt+0x13e>
                err = -err;
  1033f6:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1033f8:	83 fb 06             	cmp    $0x6,%ebx
  1033fb:	7f 0b                	jg     103408 <vprintfmt+0x14e>
  1033fd:	8b 34 9d 14 3f 10 00 	mov    0x103f14(,%ebx,4),%esi
  103404:	85 f6                	test   %esi,%esi
  103406:	75 23                	jne    10342b <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  103408:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10340c:	c7 44 24 08 41 3f 10 	movl   $0x103f41,0x8(%esp)
  103413:	00 
  103414:	8b 45 0c             	mov    0xc(%ebp),%eax
  103417:	89 44 24 04          	mov    %eax,0x4(%esp)
  10341b:	8b 45 08             	mov    0x8(%ebp),%eax
  10341e:	89 04 24             	mov    %eax,(%esp)
  103421:	e8 61 fe ff ff       	call   103287 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  103426:	e9 60 02 00 00       	jmp    10368b <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  10342b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10342f:	c7 44 24 08 4a 3f 10 	movl   $0x103f4a,0x8(%esp)
  103436:	00 
  103437:	8b 45 0c             	mov    0xc(%ebp),%eax
  10343a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10343e:	8b 45 08             	mov    0x8(%ebp),%eax
  103441:	89 04 24             	mov    %eax,(%esp)
  103444:	e8 3e fe ff ff       	call   103287 <printfmt>
            break;
  103449:	e9 3d 02 00 00       	jmp    10368b <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10344e:	8b 45 14             	mov    0x14(%ebp),%eax
  103451:	8d 50 04             	lea    0x4(%eax),%edx
  103454:	89 55 14             	mov    %edx,0x14(%ebp)
  103457:	8b 30                	mov    (%eax),%esi
  103459:	85 f6                	test   %esi,%esi
  10345b:	75 05                	jne    103462 <vprintfmt+0x1a8>
                p = "(null)";
  10345d:	be 4d 3f 10 00       	mov    $0x103f4d,%esi
            }
            if (width > 0 && padc != '-') {
  103462:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103466:	7e 76                	jle    1034de <vprintfmt+0x224>
  103468:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  10346c:	74 70                	je     1034de <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10346e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103471:	89 44 24 04          	mov    %eax,0x4(%esp)
  103475:	89 34 24             	mov    %esi,(%esp)
  103478:	e8 ba f7 ff ff       	call   102c37 <strnlen>
  10347d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103480:	29 c2                	sub    %eax,%edx
  103482:	89 d0                	mov    %edx,%eax
  103484:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103487:	eb 16                	jmp    10349f <vprintfmt+0x1e5>
                    putch(padc, putdat);
  103489:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10348d:	8b 55 0c             	mov    0xc(%ebp),%edx
  103490:	89 54 24 04          	mov    %edx,0x4(%esp)
  103494:	89 04 24             	mov    %eax,(%esp)
  103497:	8b 45 08             	mov    0x8(%ebp),%eax
  10349a:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  10349c:	ff 4d e8             	decl   -0x18(%ebp)
  10349f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1034a3:	7f e4                	jg     103489 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1034a5:	eb 37                	jmp    1034de <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  1034a7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1034ab:	74 1f                	je     1034cc <vprintfmt+0x212>
  1034ad:	83 fb 1f             	cmp    $0x1f,%ebx
  1034b0:	7e 05                	jle    1034b7 <vprintfmt+0x1fd>
  1034b2:	83 fb 7e             	cmp    $0x7e,%ebx
  1034b5:	7e 15                	jle    1034cc <vprintfmt+0x212>
                    putch('?', putdat);
  1034b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034be:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1034c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1034c8:	ff d0                	call   *%eax
  1034ca:	eb 0f                	jmp    1034db <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  1034cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034d3:	89 1c 24             	mov    %ebx,(%esp)
  1034d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1034d9:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1034db:	ff 4d e8             	decl   -0x18(%ebp)
  1034de:	89 f0                	mov    %esi,%eax
  1034e0:	8d 70 01             	lea    0x1(%eax),%esi
  1034e3:	0f b6 00             	movzbl (%eax),%eax
  1034e6:	0f be d8             	movsbl %al,%ebx
  1034e9:	85 db                	test   %ebx,%ebx
  1034eb:	74 27                	je     103514 <vprintfmt+0x25a>
  1034ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1034f1:	78 b4                	js     1034a7 <vprintfmt+0x1ed>
  1034f3:	ff 4d e4             	decl   -0x1c(%ebp)
  1034f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1034fa:	79 ab                	jns    1034a7 <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  1034fc:	eb 16                	jmp    103514 <vprintfmt+0x25a>
                putch(' ', putdat);
  1034fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  103501:	89 44 24 04          	mov    %eax,0x4(%esp)
  103505:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10350c:	8b 45 08             	mov    0x8(%ebp),%eax
  10350f:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  103511:	ff 4d e8             	decl   -0x18(%ebp)
  103514:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103518:	7f e4                	jg     1034fe <vprintfmt+0x244>
            }
            break;
  10351a:	e9 6c 01 00 00       	jmp    10368b <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10351f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103522:	89 44 24 04          	mov    %eax,0x4(%esp)
  103526:	8d 45 14             	lea    0x14(%ebp),%eax
  103529:	89 04 24             	mov    %eax,(%esp)
  10352c:	e8 0b fd ff ff       	call   10323c <getint>
  103531:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103534:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10353a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10353d:	85 d2                	test   %edx,%edx
  10353f:	79 26                	jns    103567 <vprintfmt+0x2ad>
                putch('-', putdat);
  103541:	8b 45 0c             	mov    0xc(%ebp),%eax
  103544:	89 44 24 04          	mov    %eax,0x4(%esp)
  103548:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  10354f:	8b 45 08             	mov    0x8(%ebp),%eax
  103552:	ff d0                	call   *%eax
                num = -(long long)num;
  103554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103557:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10355a:	f7 d8                	neg    %eax
  10355c:	83 d2 00             	adc    $0x0,%edx
  10355f:	f7 da                	neg    %edx
  103561:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103564:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  103567:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10356e:	e9 a8 00 00 00       	jmp    10361b <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  103573:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103576:	89 44 24 04          	mov    %eax,0x4(%esp)
  10357a:	8d 45 14             	lea    0x14(%ebp),%eax
  10357d:	89 04 24             	mov    %eax,(%esp)
  103580:	e8 64 fc ff ff       	call   1031e9 <getuint>
  103585:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103588:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  10358b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103592:	e9 84 00 00 00       	jmp    10361b <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  103597:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10359a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10359e:	8d 45 14             	lea    0x14(%ebp),%eax
  1035a1:	89 04 24             	mov    %eax,(%esp)
  1035a4:	e8 40 fc ff ff       	call   1031e9 <getuint>
  1035a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1035af:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1035b6:	eb 63                	jmp    10361b <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  1035b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035bf:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  1035c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1035c9:	ff d0                	call   *%eax
            putch('x', putdat);
  1035cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035d2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  1035d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1035dc:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1035de:	8b 45 14             	mov    0x14(%ebp),%eax
  1035e1:	8d 50 04             	lea    0x4(%eax),%edx
  1035e4:	89 55 14             	mov    %edx,0x14(%ebp)
  1035e7:	8b 00                	mov    (%eax),%eax
  1035e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1035f3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1035fa:	eb 1f                	jmp    10361b <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1035fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1035ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  103603:	8d 45 14             	lea    0x14(%ebp),%eax
  103606:	89 04 24             	mov    %eax,(%esp)
  103609:	e8 db fb ff ff       	call   1031e9 <getuint>
  10360e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103611:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103614:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10361b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10361f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103622:	89 54 24 18          	mov    %edx,0x18(%esp)
  103626:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103629:	89 54 24 14          	mov    %edx,0x14(%esp)
  10362d:	89 44 24 10          	mov    %eax,0x10(%esp)
  103631:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103634:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103637:	89 44 24 08          	mov    %eax,0x8(%esp)
  10363b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10363f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103642:	89 44 24 04          	mov    %eax,0x4(%esp)
  103646:	8b 45 08             	mov    0x8(%ebp),%eax
  103649:	89 04 24             	mov    %eax,(%esp)
  10364c:	e8 94 fa ff ff       	call   1030e5 <printnum>
            break;
  103651:	eb 38                	jmp    10368b <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103653:	8b 45 0c             	mov    0xc(%ebp),%eax
  103656:	89 44 24 04          	mov    %eax,0x4(%esp)
  10365a:	89 1c 24             	mov    %ebx,(%esp)
  10365d:	8b 45 08             	mov    0x8(%ebp),%eax
  103660:	ff d0                	call   *%eax
            break;
  103662:	eb 27                	jmp    10368b <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103664:	8b 45 0c             	mov    0xc(%ebp),%eax
  103667:	89 44 24 04          	mov    %eax,0x4(%esp)
  10366b:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  103672:	8b 45 08             	mov    0x8(%ebp),%eax
  103675:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  103677:	ff 4d 10             	decl   0x10(%ebp)
  10367a:	eb 03                	jmp    10367f <vprintfmt+0x3c5>
  10367c:	ff 4d 10             	decl   0x10(%ebp)
  10367f:	8b 45 10             	mov    0x10(%ebp),%eax
  103682:	48                   	dec    %eax
  103683:	0f b6 00             	movzbl (%eax),%eax
  103686:	3c 25                	cmp    $0x25,%al
  103688:	75 f2                	jne    10367c <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  10368a:	90                   	nop
    while (1) {
  10368b:	e9 36 fc ff ff       	jmp    1032c6 <vprintfmt+0xc>
                return;
  103690:	90                   	nop
        }
    }
}
  103691:	83 c4 40             	add    $0x40,%esp
  103694:	5b                   	pop    %ebx
  103695:	5e                   	pop    %esi
  103696:	5d                   	pop    %ebp
  103697:	c3                   	ret    

00103698 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103698:	f3 0f 1e fb          	endbr32 
  10369c:	55                   	push   %ebp
  10369d:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  10369f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036a2:	8b 40 08             	mov    0x8(%eax),%eax
  1036a5:	8d 50 01             	lea    0x1(%eax),%edx
  1036a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036ab:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1036ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036b1:	8b 10                	mov    (%eax),%edx
  1036b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036b6:	8b 40 04             	mov    0x4(%eax),%eax
  1036b9:	39 c2                	cmp    %eax,%edx
  1036bb:	73 12                	jae    1036cf <sprintputch+0x37>
        *b->buf ++ = ch;
  1036bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036c0:	8b 00                	mov    (%eax),%eax
  1036c2:	8d 48 01             	lea    0x1(%eax),%ecx
  1036c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1036c8:	89 0a                	mov    %ecx,(%edx)
  1036ca:	8b 55 08             	mov    0x8(%ebp),%edx
  1036cd:	88 10                	mov    %dl,(%eax)
    }
}
  1036cf:	90                   	nop
  1036d0:	5d                   	pop    %ebp
  1036d1:	c3                   	ret    

001036d2 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1036d2:	f3 0f 1e fb          	endbr32 
  1036d6:	55                   	push   %ebp
  1036d7:	89 e5                	mov    %esp,%ebp
  1036d9:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1036dc:	8d 45 14             	lea    0x14(%ebp),%eax
  1036df:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1036e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1036e9:	8b 45 10             	mov    0x10(%ebp),%eax
  1036ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  1036f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1036fa:	89 04 24             	mov    %eax,(%esp)
  1036fd:	e8 08 00 00 00       	call   10370a <vsnprintf>
  103702:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103705:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103708:	c9                   	leave  
  103709:	c3                   	ret    

0010370a <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10370a:	f3 0f 1e fb          	endbr32 
  10370e:	55                   	push   %ebp
  10370f:	89 e5                	mov    %esp,%ebp
  103711:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103714:	8b 45 08             	mov    0x8(%ebp),%eax
  103717:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10371a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10371d:	8d 50 ff             	lea    -0x1(%eax),%edx
  103720:	8b 45 08             	mov    0x8(%ebp),%eax
  103723:	01 d0                	add    %edx,%eax
  103725:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103728:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  10372f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103733:	74 0a                	je     10373f <vsnprintf+0x35>
  103735:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10373b:	39 c2                	cmp    %eax,%edx
  10373d:	76 07                	jbe    103746 <vsnprintf+0x3c>
        return -E_INVAL;
  10373f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103744:	eb 2a                	jmp    103770 <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103746:	8b 45 14             	mov    0x14(%ebp),%eax
  103749:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10374d:	8b 45 10             	mov    0x10(%ebp),%eax
  103750:	89 44 24 08          	mov    %eax,0x8(%esp)
  103754:	8d 45 ec             	lea    -0x14(%ebp),%eax
  103757:	89 44 24 04          	mov    %eax,0x4(%esp)
  10375b:	c7 04 24 98 36 10 00 	movl   $0x103698,(%esp)
  103762:	e8 53 fb ff ff       	call   1032ba <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  103767:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10376a:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10376d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103770:	c9                   	leave  
  103771:	c3                   	ret    
