
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
  100027:	e8 27 2f 00 00       	call   102f53 <memset>

    cons_init();                // init the console
  10002c:	e8 1d 16 00 00       	call   10164e <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 80 37 10 00 	movl   $0x103780,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 9c 37 10 00 	movl   $0x10379c,(%esp)
  100046:	e8 49 02 00 00       	call   100294 <cprintf>

    print_kerninfo();
  10004b:	e8 07 09 00 00       	call   100957 <print_kerninfo>

    grade_backtrace();
  100050:	e8 9a 00 00 00       	call   1000ef <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 a8 2b 00 00       	call   102c02 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 44 17 00 00       	call   1017a3 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 e9 18 00 00       	call   10194d <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 6a 0d 00 00       	call   100dd3 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 81 18 00 00       	call   1018ef <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 87 01 00 00       	call   1001fa <lab1_switch_test>

    /* do nothing */
    while (1);
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100075:	f3 0f 1e fb          	endbr32 
  100079:	55                   	push   %ebp
  10007a:	89 e5                	mov    %esp,%ebp
  10007c:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100086:	00 
  100087:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008e:	00 
  10008f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100096:	e8 22 0d 00 00       	call   100dbd <mon_backtrace>
}
  10009b:	90                   	nop
  10009c:	c9                   	leave  
  10009d:	c3                   	ret    

0010009e <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  10009e:	f3 0f 1e fb          	endbr32 
  1000a2:	55                   	push   %ebp
  1000a3:	89 e5                	mov    %esp,%ebp
  1000a5:	53                   	push   %ebx
  1000a6:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a9:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000af:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1000b5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000bd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000c1:	89 04 24             	mov    %eax,(%esp)
  1000c4:	e8 ac ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c9:	90                   	nop
  1000ca:	83 c4 14             	add    $0x14,%esp
  1000cd:	5b                   	pop    %ebx
  1000ce:	5d                   	pop    %ebp
  1000cf:	c3                   	ret    

001000d0 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000d0:	f3 0f 1e fb          	endbr32 
  1000d4:	55                   	push   %ebp
  1000d5:	89 e5                	mov    %esp,%ebp
  1000d7:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000da:	8b 45 10             	mov    0x10(%ebp),%eax
  1000dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1000e4:	89 04 24             	mov    %eax,(%esp)
  1000e7:	e8 b2 ff ff ff       	call   10009e <grade_backtrace1>
}
  1000ec:	90                   	nop
  1000ed:	c9                   	leave  
  1000ee:	c3                   	ret    

001000ef <grade_backtrace>:

void
grade_backtrace(void) {
  1000ef:	f3 0f 1e fb          	endbr32 
  1000f3:	55                   	push   %ebp
  1000f4:	89 e5                	mov    %esp,%ebp
  1000f6:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000f9:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000fe:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100105:	ff 
  100106:	89 44 24 04          	mov    %eax,0x4(%esp)
  10010a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100111:	e8 ba ff ff ff       	call   1000d0 <grade_backtrace0>
}
  100116:	90                   	nop
  100117:	c9                   	leave  
  100118:	c3                   	ret    

00100119 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100119:	f3 0f 1e fb          	endbr32 
  10011d:	55                   	push   %ebp
  10011e:	89 e5                	mov    %esp,%ebp
  100120:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100123:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100126:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100129:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10012c:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10012f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100133:	83 e0 03             	and    $0x3,%eax
  100136:	89 c2                	mov    %eax,%edx
  100138:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10013d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100141:	89 44 24 04          	mov    %eax,0x4(%esp)
  100145:	c7 04 24 a1 37 10 00 	movl   $0x1037a1,(%esp)
  10014c:	e8 43 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100155:	89 c2                	mov    %eax,%edx
  100157:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10015c:	89 54 24 08          	mov    %edx,0x8(%esp)
  100160:	89 44 24 04          	mov    %eax,0x4(%esp)
  100164:	c7 04 24 af 37 10 00 	movl   $0x1037af,(%esp)
  10016b:	e8 24 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100170:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100174:	89 c2                	mov    %eax,%edx
  100176:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10017b:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100183:	c7 04 24 bd 37 10 00 	movl   $0x1037bd,(%esp)
  10018a:	e8 05 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10018f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100193:	89 c2                	mov    %eax,%edx
  100195:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10019a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10019e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a2:	c7 04 24 cb 37 10 00 	movl   $0x1037cb,(%esp)
  1001a9:	e8 e6 00 00 00       	call   100294 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001ae:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001b2:	89 c2                	mov    %eax,%edx
  1001b4:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c1:	c7 04 24 d9 37 10 00 	movl   $0x1037d9,(%esp)
  1001c8:	e8 c7 00 00 00       	call   100294 <cprintf>
    round ++;
  1001cd:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001d2:	40                   	inc    %eax
  1001d3:	a3 20 0a 11 00       	mov    %eax,0x110a20
}
  1001d8:	90                   	nop
  1001d9:	c9                   	leave  
  1001da:	c3                   	ret    

001001db <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001db:	f3 0f 1e fb          	endbr32 
  1001df:	55                   	push   %ebp
  1001e0:	89 e5                	mov    %esp,%ebp
    //执行“int n”时, CPU从中断向量表中, 找到第n号表项, 修改CS和IP
    //1. 取中断类型码n ;
    //2. 标志寄存器入栈(pushf) , IF=0, TF=0(重置中断标志位)  ;
    //3. CS、IP入栈 ;
    //4. 查中断向量表,  (IP)=(n*4), (CS)=(n*4+2)。
    asm volatile (
  1001e2:	83 ec 08             	sub    $0x8,%esp
  1001e5:	cd 78                	int    $0x78
  1001e7:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001e9:	90                   	nop
  1001ea:	5d                   	pop    %ebp
  1001eb:	c3                   	ret    

001001ec <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001ec:	f3 0f 1e fb          	endbr32 
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
  1001f3:	cd 79                	int    $0x79
  1001f5:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001f7:	90                   	nop
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	f3 0f 1e fb          	endbr32 
  1001fe:	55                   	push   %ebp
  1001ff:	89 e5                	mov    %esp,%ebp
  100201:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100204:	e8 10 ff ff ff       	call   100119 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100209:	c7 04 24 e8 37 10 00 	movl   $0x1037e8,(%esp)
  100210:	e8 7f 00 00 00       	call   100294 <cprintf>
    lab1_switch_to_user();
  100215:	e8 c1 ff ff ff       	call   1001db <lab1_switch_to_user>
    lab1_print_cur_status();
  10021a:	e8 fa fe ff ff       	call   100119 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021f:	c7 04 24 08 38 10 00 	movl   $0x103808,(%esp)
  100226:	e8 69 00 00 00       	call   100294 <cprintf>
    lab1_switch_to_kernel();
  10022b:	e8 bc ff ff ff       	call   1001ec <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100230:	e8 e4 fe ff ff       	call   100119 <lab1_print_cur_status>
}
  100235:	90                   	nop
  100236:	c9                   	leave  
  100237:	c3                   	ret    

00100238 <cputch>:
 *  do
 *      writes a single character @c to stdout
 *      increaces the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100238:	f3 0f 1e fb          	endbr32 
  10023c:	55                   	push   %ebp
  10023d:	89 e5                	mov    %esp,%ebp
  10023f:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100242:	8b 45 08             	mov    0x8(%ebp),%eax
  100245:	89 04 24             	mov    %eax,(%esp)
  100248:	e8 32 14 00 00       	call   10167f <cons_putc>
    (*cnt) ++;
  10024d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100250:	8b 00                	mov    (%eax),%eax
  100252:	8d 50 01             	lea    0x1(%eax),%edx
  100255:	8b 45 0c             	mov    0xc(%ebp),%eax
  100258:	89 10                	mov    %edx,(%eax)
}
  10025a:	90                   	nop
  10025b:	c9                   	leave  
  10025c:	c3                   	ret    

0010025d <vcprintf>:
 *      the number of characters which would be written to stdout
 *  call it when
 *      you are already dealing with a va_list. Or you probably want cprintf() instead.
 */
int
vcprintf(const char *fmt, va_list ap) {
  10025d:	f3 0f 1e fb          	endbr32 
  100261:	55                   	push   %ebp
  100262:	89 e5                	mov    %esp,%ebp
  100264:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100267:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10026e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100271:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100275:	8b 45 08             	mov    0x8(%ebp),%eax
  100278:	89 44 24 08          	mov    %eax,0x8(%esp)
  10027c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10027f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100283:	c7 04 24 38 02 10 00 	movl   $0x100238,(%esp)
  10028a:	e8 30 30 00 00       	call   1032bf <vprintfmt>
    return cnt;
  10028f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100292:	c9                   	leave  
  100293:	c3                   	ret    

00100294 <cprintf>:
 *      format a string and writes it to stdout
 *  return
 *      the number of characters which would be written to stdout
 */
int
cprintf(const char *fmt, ...) {
  100294:	f3 0f 1e fb          	endbr32 
  100298:	55                   	push   %ebp
  100299:	89 e5                	mov    %esp,%ebp
  10029b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10029e:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ae:	89 04 24             	mov    %eax,(%esp)
  1002b1:	e8 a7 ff ff ff       	call   10025d <vcprintf>
  1002b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002bc:	c9                   	leave  
  1002bd:	c3                   	ret    

001002be <cputchar>:
/*  cputchar
 *  do
 *      writes a single character to stdout
 */
void
cputchar(int c) {
  1002be:	f3 0f 1e fb          	endbr32 
  1002c2:	55                   	push   %ebp
  1002c3:	89 e5                	mov    %esp,%ebp
  1002c5:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002cb:	89 04 24             	mov    %eax,(%esp)
  1002ce:	e8 ac 13 00 00       	call   10167f <cons_putc>
}
  1002d3:	90                   	nop
  1002d4:	c9                   	leave  
  1002d5:	c3                   	ret    

001002d6 <cputs>:
 *      writes the string pointed by @str to stdout and appends a newline character.
 *  return
 *      the number of characters which would be written to stdout
 */
int
cputs(const char *str) {
  1002d6:	f3 0f 1e fb          	endbr32 
  1002da:	55                   	push   %ebp
  1002db:	89 e5                	mov    %esp,%ebp
  1002dd:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002e7:	eb 13                	jmp    1002fc <cputs+0x26>
        cputch(c, &cnt);
  1002e9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002ed:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002f4:	89 04 24             	mov    %eax,(%esp)
  1002f7:	e8 3c ff ff ff       	call   100238 <cputch>
    while ((c = *str ++) != '\0') {
  1002fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	89 55 08             	mov    %edx,0x8(%ebp)
  100305:	0f b6 00             	movzbl (%eax),%eax
  100308:	88 45 f7             	mov    %al,-0x9(%ebp)
  10030b:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  10030f:	75 d8                	jne    1002e9 <cputs+0x13>
    }
    cputch('\n', &cnt);
  100311:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100314:	89 44 24 04          	mov    %eax,0x4(%esp)
  100318:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10031f:	e8 14 ff ff ff       	call   100238 <cputch>
    return cnt;
  100324:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100327:	c9                   	leave  
  100328:	c3                   	ret    

00100329 <getchar>:
 *      reads a single non-zero character from stdin 
 *  return
 *      this non-zero charater
 */
int
getchar(void) {
  100329:	f3 0f 1e fb          	endbr32 
  10032d:	55                   	push   %ebp
  10032e:	89 e5                	mov    %esp,%ebp
  100330:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100333:	90                   	nop
  100334:	e8 74 13 00 00       	call   1016ad <cons_getc>
  100339:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10033c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100340:	74 f2                	je     100334 <getchar+0xb>
        /* do nothing */;
    return c;
  100342:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100345:	c9                   	leave  
  100346:	c3                   	ret    

00100347 <readline>:
 *      the text of the line read.
 *      If some errors are happened, NULL is returned.
 *      The return value is a , thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100347:	f3 0f 1e fb          	endbr32 
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100351:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100355:	74 13                	je     10036a <readline+0x23>
        cprintf("%s", prompt);
  100357:	8b 45 08             	mov    0x8(%ebp),%eax
  10035a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10035e:	c7 04 24 27 38 10 00 	movl   $0x103827,(%esp)
  100365:	e8 2a ff ff ff       	call   100294 <cprintf>
    }
    int i = 0, c;
  10036a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100371:	e8 b3 ff ff ff       	call   100329 <getchar>
  100376:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100379:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10037d:	79 07                	jns    100386 <readline+0x3f>
            return NULL;
  10037f:	b8 00 00 00 00       	mov    $0x0,%eax
  100384:	eb 78                	jmp    1003fe <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100386:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10038a:	7e 28                	jle    1003b4 <readline+0x6d>
  10038c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100393:	7f 1f                	jg     1003b4 <readline+0x6d>
            cputchar(c);
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100398:	89 04 24             	mov    %eax,(%esp)
  10039b:	e8 1e ff ff ff       	call   1002be <cputchar>
            buf[i ++] = c;
  1003a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003a3:	8d 50 01             	lea    0x1(%eax),%edx
  1003a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003ac:	88 90 40 0a 11 00    	mov    %dl,0x110a40(%eax)
  1003b2:	eb 45                	jmp    1003f9 <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003b4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003b8:	75 16                	jne    1003d0 <readline+0x89>
  1003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003be:	7e 10                	jle    1003d0 <readline+0x89>
            cputchar(c);
  1003c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003c3:	89 04 24             	mov    %eax,(%esp)
  1003c6:	e8 f3 fe ff ff       	call   1002be <cputchar>
            i --;
  1003cb:	ff 4d f4             	decl   -0xc(%ebp)
  1003ce:	eb 29                	jmp    1003f9 <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  1003d0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003d4:	74 06                	je     1003dc <readline+0x95>
  1003d6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003da:	75 95                	jne    100371 <readline+0x2a>
            cputchar(c);
  1003dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003df:	89 04 24             	mov    %eax,(%esp)
  1003e2:	e8 d7 fe ff ff       	call   1002be <cputchar>
            buf[i] = '\0';
  1003e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003ea:	05 40 0a 11 00       	add    $0x110a40,%eax
  1003ef:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003f2:	b8 40 0a 11 00       	mov    $0x110a40,%eax
  1003f7:	eb 05                	jmp    1003fe <readline+0xb7>
        c = getchar();
  1003f9:	e9 73 ff ff ff       	jmp    100371 <readline+0x2a>
        }
    }
}
  1003fe:	c9                   	leave  
  1003ff:	c3                   	ret    

00100400 <__panic>:
 *  do 
 *      1.  prints "panic: 'message'"
 *      2.  enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100400:	f3 0f 1e fb          	endbr32 
  100404:	55                   	push   %ebp
  100405:	89 e5                	mov    %esp,%ebp
  100407:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  10040a:	a1 40 0e 11 00       	mov    0x110e40,%eax
  10040f:	85 c0                	test   %eax,%eax
  100411:	75 5b                	jne    10046e <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100413:	c7 05 40 0e 11 00 01 	movl   $0x1,0x110e40
  10041a:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  10041d:	8d 45 14             	lea    0x14(%ebp),%eax
  100420:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100423:	8b 45 0c             	mov    0xc(%ebp),%eax
  100426:	89 44 24 08          	mov    %eax,0x8(%esp)
  10042a:	8b 45 08             	mov    0x8(%ebp),%eax
  10042d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100431:	c7 04 24 2a 38 10 00 	movl   $0x10382a,(%esp)
  100438:	e8 57 fe ff ff       	call   100294 <cprintf>
    vcprintf(fmt, ap);
  10043d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100440:	89 44 24 04          	mov    %eax,0x4(%esp)
  100444:	8b 45 10             	mov    0x10(%ebp),%eax
  100447:	89 04 24             	mov    %eax,(%esp)
  10044a:	e8 0e fe ff ff       	call   10025d <vcprintf>
    cprintf("\n");
  10044f:	c7 04 24 46 38 10 00 	movl   $0x103846,(%esp)
  100456:	e8 39 fe ff ff       	call   100294 <cprintf>
    
    cprintf("stack trackback:\n");
  10045b:	c7 04 24 48 38 10 00 	movl   $0x103848,(%esp)
  100462:	e8 2d fe ff ff       	call   100294 <cprintf>
    print_stackframe();
  100467:	e8 3d 06 00 00       	call   100aa9 <print_stackframe>
  10046c:	eb 01                	jmp    10046f <__panic+0x6f>
        goto panic_dead;
  10046e:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10046f:	e8 87 14 00 00       	call   1018fb <intr_disable>
    while (1) {
        kmonitor(NULL);
  100474:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10047b:	e8 64 08 00 00       	call   100ce4 <kmonitor>
  100480:	eb f2                	jmp    100474 <__panic+0x74>

00100482 <__warn>:
/*  __warn
 *  do 
 *      prints "panic: 'message'"
 */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100482:	f3 0f 1e fb          	endbr32 
  100486:	55                   	push   %ebp
  100487:	89 e5                	mov    %esp,%ebp
  100489:	83 ec 28             	sub    $0x28,%esp
    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  10048c:	8d 45 14             	lea    0x14(%ebp),%eax
  10048f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100492:	8b 45 0c             	mov    0xc(%ebp),%eax
  100495:	89 44 24 08          	mov    %eax,0x8(%esp)
  100499:	8b 45 08             	mov    0x8(%ebp),%eax
  10049c:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004a0:	c7 04 24 5a 38 10 00 	movl   $0x10385a,(%esp)
  1004a7:	e8 e8 fd ff ff       	call   100294 <cprintf>
    vcprintf(fmt, ap);
  1004ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004b3:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b6:	89 04 24             	mov    %eax,(%esp)
  1004b9:	e8 9f fd ff ff       	call   10025d <vcprintf>
    cprintf("\n");
  1004be:	c7 04 24 46 38 10 00 	movl   $0x103846,(%esp)
  1004c5:	e8 ca fd ff ff       	call   100294 <cprintf>
    va_end(ap);
}
  1004ca:	90                   	nop
  1004cb:	c9                   	leave  
  1004cc:	c3                   	ret    

001004cd <is_kernel_panic>:
/*  is_kernel_panic
 *  do
 *      judge whether panic
 */
bool
is_kernel_panic(void) {
  1004cd:	f3 0f 1e fb          	endbr32 
  1004d1:	55                   	push   %ebp
  1004d2:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004d4:	a1 40 0e 11 00       	mov    0x110e40,%eax
}
  1004d9:	5d                   	pop    %ebp
  1004da:	c3                   	ret    

001004db <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004db:	f3 0f 1e fb          	endbr32 
  1004df:	55                   	push   %ebp
  1004e0:	89 e5                	mov    %esp,%ebp
  1004e2:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e8:	8b 00                	mov    (%eax),%eax
  1004ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004ed:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f0:	8b 00                	mov    (%eax),%eax
  1004f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004fc:	e9 ca 00 00 00       	jmp    1005cb <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
  100501:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100504:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100507:	01 d0                	add    %edx,%eax
  100509:	89 c2                	mov    %eax,%edx
  10050b:	c1 ea 1f             	shr    $0x1f,%edx
  10050e:	01 d0                	add    %edx,%eax
  100510:	d1 f8                	sar    %eax
  100512:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100518:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10051b:	eb 03                	jmp    100520 <stab_binsearch+0x45>
            m --;
  10051d:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100520:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100523:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100526:	7c 1f                	jl     100547 <stab_binsearch+0x6c>
  100528:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10052b:	89 d0                	mov    %edx,%eax
  10052d:	01 c0                	add    %eax,%eax
  10052f:	01 d0                	add    %edx,%eax
  100531:	c1 e0 02             	shl    $0x2,%eax
  100534:	89 c2                	mov    %eax,%edx
  100536:	8b 45 08             	mov    0x8(%ebp),%eax
  100539:	01 d0                	add    %edx,%eax
  10053b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10053f:	0f b6 c0             	movzbl %al,%eax
  100542:	39 45 14             	cmp    %eax,0x14(%ebp)
  100545:	75 d6                	jne    10051d <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  100547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10054d:	7d 09                	jge    100558 <stab_binsearch+0x7d>
            l = true_m + 1;
  10054f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100552:	40                   	inc    %eax
  100553:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100556:	eb 73                	jmp    1005cb <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
  100558:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10055f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100562:	89 d0                	mov    %edx,%eax
  100564:	01 c0                	add    %eax,%eax
  100566:	01 d0                	add    %edx,%eax
  100568:	c1 e0 02             	shl    $0x2,%eax
  10056b:	89 c2                	mov    %eax,%edx
  10056d:	8b 45 08             	mov    0x8(%ebp),%eax
  100570:	01 d0                	add    %edx,%eax
  100572:	8b 40 08             	mov    0x8(%eax),%eax
  100575:	39 45 18             	cmp    %eax,0x18(%ebp)
  100578:	76 11                	jbe    10058b <stab_binsearch+0xb0>
            *region_left = m;
  10057a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10057d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100580:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100582:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100585:	40                   	inc    %eax
  100586:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100589:	eb 40                	jmp    1005cb <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	89 d0                	mov    %edx,%eax
  100590:	01 c0                	add    %eax,%eax
  100592:	01 d0                	add    %edx,%eax
  100594:	c1 e0 02             	shl    $0x2,%eax
  100597:	89 c2                	mov    %eax,%edx
  100599:	8b 45 08             	mov    0x8(%ebp),%eax
  10059c:	01 d0                	add    %edx,%eax
  10059e:	8b 40 08             	mov    0x8(%eax),%eax
  1005a1:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005a4:	73 14                	jae    1005ba <stab_binsearch+0xdf>
            *region_right = m - 1;
  1005a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005ac:	8b 45 10             	mov    0x10(%ebp),%eax
  1005af:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005b4:	48                   	dec    %eax
  1005b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005b8:	eb 11                	jmp    1005cb <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005c0:	89 10                	mov    %edx,(%eax)
            l = m;
  1005c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005c8:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005d1:	0f 8e 2a ff ff ff    	jle    100501 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  1005d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005db:	75 0f                	jne    1005ec <stab_binsearch+0x111>
        *region_right = *region_left - 1;
  1005dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e0:	8b 00                	mov    (%eax),%eax
  1005e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005e5:	8b 45 10             	mov    0x10(%ebp),%eax
  1005e8:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005ea:	eb 3e                	jmp    10062a <stab_binsearch+0x14f>
        l = *region_right;
  1005ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1005ef:	8b 00                	mov    (%eax),%eax
  1005f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005f4:	eb 03                	jmp    1005f9 <stab_binsearch+0x11e>
  1005f6:	ff 4d fc             	decl   -0x4(%ebp)
  1005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fc:	8b 00                	mov    (%eax),%eax
  1005fe:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100601:	7e 1f                	jle    100622 <stab_binsearch+0x147>
  100603:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100606:	89 d0                	mov    %edx,%eax
  100608:	01 c0                	add    %eax,%eax
  10060a:	01 d0                	add    %edx,%eax
  10060c:	c1 e0 02             	shl    $0x2,%eax
  10060f:	89 c2                	mov    %eax,%edx
  100611:	8b 45 08             	mov    0x8(%ebp),%eax
  100614:	01 d0                	add    %edx,%eax
  100616:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10061a:	0f b6 c0             	movzbl %al,%eax
  10061d:	39 45 14             	cmp    %eax,0x14(%ebp)
  100620:	75 d4                	jne    1005f6 <stab_binsearch+0x11b>
        *region_left = l;
  100622:	8b 45 0c             	mov    0xc(%ebp),%eax
  100625:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100628:	89 10                	mov    %edx,(%eax)
}
  10062a:	90                   	nop
  10062b:	c9                   	leave  
  10062c:	c3                   	ret    

0010062d <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10062d:	f3 0f 1e fb          	endbr32 
  100631:	55                   	push   %ebp
  100632:	89 e5                	mov    %esp,%ebp
  100634:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100637:	8b 45 0c             	mov    0xc(%ebp),%eax
  10063a:	c7 00 78 38 10 00    	movl   $0x103878,(%eax)
    info->eip_line = 0;
  100640:	8b 45 0c             	mov    0xc(%ebp),%eax
  100643:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10064a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10064d:	c7 40 08 78 38 10 00 	movl   $0x103878,0x8(%eax)
    info->eip_fn_namelen = 9;
  100654:	8b 45 0c             	mov    0xc(%ebp),%eax
  100657:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10065e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100661:	8b 55 08             	mov    0x8(%ebp),%edx
  100664:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100667:	8b 45 0c             	mov    0xc(%ebp),%eax
  10066a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100671:	c7 45 f4 ac 40 10 00 	movl   $0x1040ac,-0xc(%ebp)
    stab_end = __STAB_END__;
  100678:	c7 45 f0 2c cf 10 00 	movl   $0x10cf2c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10067f:	c7 45 ec 2d cf 10 00 	movl   $0x10cf2d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100686:	c7 45 e8 1f f0 10 00 	movl   $0x10f01f,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10068d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100690:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100693:	76 0b                	jbe    1006a0 <debuginfo_eip+0x73>
  100695:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100698:	48                   	dec    %eax
  100699:	0f b6 00             	movzbl (%eax),%eax
  10069c:	84 c0                	test   %al,%al
  10069e:	74 0a                	je     1006aa <debuginfo_eip+0x7d>
        return -1;
  1006a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006a5:	e9 ab 02 00 00       	jmp    100955 <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1006aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006b4:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006b7:	c1 f8 02             	sar    $0x2,%eax
  1006ba:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006c0:	48                   	dec    %eax
  1006c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1006c7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006cb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006d2:	00 
  1006d3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006da:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 ef fd ff ff       	call   1004db <stab_binsearch>
    if (lfile == 0)
  1006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ef:	85 c0                	test   %eax,%eax
  1006f1:	75 0a                	jne    1006fd <debuginfo_eip+0xd0>
        return -1;
  1006f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006f8:	e9 58 02 00 00       	jmp    100955 <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100700:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100703:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100706:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100709:	8b 45 08             	mov    0x8(%ebp),%eax
  10070c:	89 44 24 10          	mov    %eax,0x10(%esp)
  100710:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100717:	00 
  100718:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10071b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10071f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100722:	89 44 24 04          	mov    %eax,0x4(%esp)
  100726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100729:	89 04 24             	mov    %eax,(%esp)
  10072c:	e8 aa fd ff ff       	call   1004db <stab_binsearch>

    if (lfun <= rfun) {
  100731:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100734:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100737:	39 c2                	cmp    %eax,%edx
  100739:	7f 78                	jg     1007b3 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10073b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10073e:	89 c2                	mov    %eax,%edx
  100740:	89 d0                	mov    %edx,%eax
  100742:	01 c0                	add    %eax,%eax
  100744:	01 d0                	add    %edx,%eax
  100746:	c1 e0 02             	shl    $0x2,%eax
  100749:	89 c2                	mov    %eax,%edx
  10074b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	8b 10                	mov    (%eax),%edx
  100752:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100755:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100758:	39 c2                	cmp    %eax,%edx
  10075a:	73 22                	jae    10077e <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10075c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10075f:	89 c2                	mov    %eax,%edx
  100761:	89 d0                	mov    %edx,%eax
  100763:	01 c0                	add    %eax,%eax
  100765:	01 d0                	add    %edx,%eax
  100767:	c1 e0 02             	shl    $0x2,%eax
  10076a:	89 c2                	mov    %eax,%edx
  10076c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10076f:	01 d0                	add    %edx,%eax
  100771:	8b 10                	mov    (%eax),%edx
  100773:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100776:	01 c2                	add    %eax,%edx
  100778:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077b:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10077e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100781:	89 c2                	mov    %eax,%edx
  100783:	89 d0                	mov    %edx,%eax
  100785:	01 c0                	add    %eax,%eax
  100787:	01 d0                	add    %edx,%eax
  100789:	c1 e0 02             	shl    $0x2,%eax
  10078c:	89 c2                	mov    %eax,%edx
  10078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100791:	01 d0                	add    %edx,%eax
  100793:	8b 50 08             	mov    0x8(%eax),%edx
  100796:	8b 45 0c             	mov    0xc(%ebp),%eax
  100799:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10079c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10079f:	8b 40 10             	mov    0x10(%eax),%eax
  1007a2:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1007a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1007ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007b1:	eb 15                	jmp    1007c8 <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b6:	8b 55 08             	mov    0x8(%ebp),%edx
  1007b9:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007c5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007cb:	8b 40 08             	mov    0x8(%eax),%eax
  1007ce:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007d5:	00 
  1007d6:	89 04 24             	mov    %eax,(%esp)
  1007d9:	e8 e9 25 00 00       	call   102dc7 <strfind>
  1007de:	8b 55 0c             	mov    0xc(%ebp),%edx
  1007e1:	8b 52 08             	mov    0x8(%edx),%edx
  1007e4:	29 d0                	sub    %edx,%eax
  1007e6:	89 c2                	mov    %eax,%edx
  1007e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007eb:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1007f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007f5:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007fc:	00 
  1007fd:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100800:	89 44 24 08          	mov    %eax,0x8(%esp)
  100804:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100807:	89 44 24 04          	mov    %eax,0x4(%esp)
  10080b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10080e:	89 04 24             	mov    %eax,(%esp)
  100811:	e8 c5 fc ff ff       	call   1004db <stab_binsearch>
    if (lline <= rline) {
  100816:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100819:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10081c:	39 c2                	cmp    %eax,%edx
  10081e:	7f 23                	jg     100843 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
  100820:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100823:	89 c2                	mov    %eax,%edx
  100825:	89 d0                	mov    %edx,%eax
  100827:	01 c0                	add    %eax,%eax
  100829:	01 d0                	add    %edx,%eax
  10082b:	c1 e0 02             	shl    $0x2,%eax
  10082e:	89 c2                	mov    %eax,%edx
  100830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100833:	01 d0                	add    %edx,%eax
  100835:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100839:	89 c2                	mov    %eax,%edx
  10083b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10083e:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100841:	eb 11                	jmp    100854 <debuginfo_eip+0x227>
        return -1;
  100843:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100848:	e9 08 01 00 00       	jmp    100955 <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10084d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100850:	48                   	dec    %eax
  100851:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100854:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100857:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10085a:	39 c2                	cmp    %eax,%edx
  10085c:	7c 56                	jl     1008b4 <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
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
  100877:	3c 84                	cmp    $0x84,%al
  100879:	74 39                	je     1008b4 <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10087b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10087e:	89 c2                	mov    %eax,%edx
  100880:	89 d0                	mov    %edx,%eax
  100882:	01 c0                	add    %eax,%eax
  100884:	01 d0                	add    %edx,%eax
  100886:	c1 e0 02             	shl    $0x2,%eax
  100889:	89 c2                	mov    %eax,%edx
  10088b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10088e:	01 d0                	add    %edx,%eax
  100890:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100894:	3c 64                	cmp    $0x64,%al
  100896:	75 b5                	jne    10084d <debuginfo_eip+0x220>
  100898:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10089b:	89 c2                	mov    %eax,%edx
  10089d:	89 d0                	mov    %edx,%eax
  10089f:	01 c0                	add    %eax,%eax
  1008a1:	01 d0                	add    %edx,%eax
  1008a3:	c1 e0 02             	shl    $0x2,%eax
  1008a6:	89 c2                	mov    %eax,%edx
  1008a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ab:	01 d0                	add    %edx,%eax
  1008ad:	8b 40 08             	mov    0x8(%eax),%eax
  1008b0:	85 c0                	test   %eax,%eax
  1008b2:	74 99                	je     10084d <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008ba:	39 c2                	cmp    %eax,%edx
  1008bc:	7c 42                	jl     100900 <debuginfo_eip+0x2d3>
  1008be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008c1:	89 c2                	mov    %eax,%edx
  1008c3:	89 d0                	mov    %edx,%eax
  1008c5:	01 c0                	add    %eax,%eax
  1008c7:	01 d0                	add    %edx,%eax
  1008c9:	c1 e0 02             	shl    $0x2,%eax
  1008cc:	89 c2                	mov    %eax,%edx
  1008ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008d1:	01 d0                	add    %edx,%eax
  1008d3:	8b 10                	mov    (%eax),%edx
  1008d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1008d8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1008db:	39 c2                	cmp    %eax,%edx
  1008dd:	73 21                	jae    100900 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e2:	89 c2                	mov    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	01 c0                	add    %eax,%eax
  1008e8:	01 d0                	add    %edx,%eax
  1008ea:	c1 e0 02             	shl    $0x2,%eax
  1008ed:	89 c2                	mov    %eax,%edx
  1008ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008f2:	01 d0                	add    %edx,%eax
  1008f4:	8b 10                	mov    (%eax),%edx
  1008f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008f9:	01 c2                	add    %eax,%edx
  1008fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008fe:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100900:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100903:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100906:	39 c2                	cmp    %eax,%edx
  100908:	7d 46                	jge    100950 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
  10090a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10090d:	40                   	inc    %eax
  10090e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100911:	eb 16                	jmp    100929 <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100913:	8b 45 0c             	mov    0xc(%ebp),%eax
  100916:	8b 40 14             	mov    0x14(%eax),%eax
  100919:	8d 50 01             	lea    0x1(%eax),%edx
  10091c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10091f:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100922:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100925:	40                   	inc    %eax
  100926:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100929:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10092c:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  10092f:	39 c2                	cmp    %eax,%edx
  100931:	7d 1d                	jge    100950 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100933:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100936:	89 c2                	mov    %eax,%edx
  100938:	89 d0                	mov    %edx,%eax
  10093a:	01 c0                	add    %eax,%eax
  10093c:	01 d0                	add    %edx,%eax
  10093e:	c1 e0 02             	shl    $0x2,%eax
  100941:	89 c2                	mov    %eax,%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10094c:	3c a0                	cmp    $0xa0,%al
  10094e:	74 c3                	je     100913 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
  100950:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100955:	c9                   	leave  
  100956:	c3                   	ret    

00100957 <print_kerninfo>:
 *  * the start address of text segements
 *  * the start address of free memory
 *  * how many memory that kernel has used.
*/
void
print_kerninfo(void) {
  100957:	f3 0f 1e fb          	endbr32 
  10095b:	55                   	push   %ebp
  10095c:	89 e5                	mov    %esp,%ebp
  10095e:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100961:	c7 04 24 82 38 10 00 	movl   $0x103882,(%esp)
  100968:	e8 27 f9 ff ff       	call   100294 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10096d:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  100974:	00 
  100975:	c7 04 24 9b 38 10 00 	movl   $0x10389b,(%esp)
  10097c:	e8 13 f9 ff ff       	call   100294 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100981:	c7 44 24 04 77 37 10 	movl   $0x103777,0x4(%esp)
  100988:	00 
  100989:	c7 04 24 b3 38 10 00 	movl   $0x1038b3,(%esp)
  100990:	e8 ff f8 ff ff       	call   100294 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100995:	c7 44 24 04 16 0a 11 	movl   $0x110a16,0x4(%esp)
  10099c:	00 
  10099d:	c7 04 24 cb 38 10 00 	movl   $0x1038cb,(%esp)
  1009a4:	e8 eb f8 ff ff       	call   100294 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009a9:	c7 44 24 04 20 1d 11 	movl   $0x111d20,0x4(%esp)
  1009b0:	00 
  1009b1:	c7 04 24 e3 38 10 00 	movl   $0x1038e3,(%esp)
  1009b8:	e8 d7 f8 ff ff       	call   100294 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009bd:	b8 20 1d 11 00       	mov    $0x111d20,%eax
  1009c2:	2d 00 00 10 00       	sub    $0x100000,%eax
  1009c7:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009cc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009d2:	85 c0                	test   %eax,%eax
  1009d4:	0f 48 c2             	cmovs  %edx,%eax
  1009d7:	c1 f8 0a             	sar    $0xa,%eax
  1009da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009de:	c7 04 24 fc 38 10 00 	movl   $0x1038fc,(%esp)
  1009e5:	e8 aa f8 ff ff       	call   100294 <cprintf>
}
  1009ea:	90                   	nop
  1009eb:	c9                   	leave  
  1009ec:	c3                   	ret    

001009ed <print_debuginfo>:
 * read and print the stat info for the address @eip,
 * 
 * 'info.eip_fn_addr' should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009ed:	f3 0f 1e fb          	endbr32 
  1009f1:	55                   	push   %ebp
  1009f2:	89 e5                	mov    %esp,%ebp
  1009f4:	81 ec 48 01 00 00    	sub    $0x148,%esp
    //当前所在函数进一步调用其他函数的语句在源代码文件中的行号
    //一类数值表示从该函数汇编代码的入口处到进一步调用其他函数的call指令的最后一个字节的偏移量，以字节为单位
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009fa:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a01:	8b 45 08             	mov    0x8(%ebp),%eax
  100a04:	89 04 24             	mov    %eax,(%esp)
  100a07:	e8 21 fc ff ff       	call   10062d <debuginfo_eip>
  100a0c:	85 c0                	test   %eax,%eax
  100a0e:	74 15                	je     100a25 <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a10:	8b 45 08             	mov    0x8(%ebp),%eax
  100a13:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a17:	c7 04 24 26 39 10 00 	movl   $0x103926,(%esp)
  100a1e:	e8 71 f8 ff ff       	call   100294 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a23:	eb 6c                	jmp    100a91 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a2c:	eb 1b                	jmp    100a49 <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
  100a2e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a34:	01 d0                	add    %edx,%eax
  100a36:	0f b6 10             	movzbl (%eax),%edx
  100a39:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a42:	01 c8                	add    %ecx,%eax
  100a44:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a46:	ff 45 f4             	incl   -0xc(%ebp)
  100a49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a4c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a4f:	7c dd                	jl     100a2e <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a51:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5a:	01 d0                	add    %edx,%eax
  100a5c:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a62:	8b 55 08             	mov    0x8(%ebp),%edx
  100a65:	89 d1                	mov    %edx,%ecx
  100a67:	29 c1                	sub    %eax,%ecx
  100a69:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a6f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a73:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a79:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a7d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a81:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a85:	c7 04 24 42 39 10 00 	movl   $0x103942,(%esp)
  100a8c:	e8 03 f8 ff ff       	call   100294 <cprintf>
}
  100a91:	90                   	nop
  100a92:	c9                   	leave  
  100a93:	c3                   	ret    

00100a94 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a94:	f3 0f 1e fb          	endbr32 
  100a98:	55                   	push   %ebp
  100a99:	89 e5                	mov    %esp,%ebp
  100a9b:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a9e:	8b 45 04             	mov    0x4(%ebp),%eax
  100aa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100aa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100aa7:	c9                   	leave  
  100aa8:	c3                   	ret    

00100aa9 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100aa9:	f3 0f 1e fb          	endbr32 
  100aad:	55                   	push   %ebp
  100aae:	89 e5                	mov    %esp,%ebp
  100ab0:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100ab3:	89 e8                	mov    %ebp,%eax
  100ab5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100ab8:	8b 45 e0             	mov    -0x20(%ebp),%eax
    //ebp是第一个被调用函数的栈帧的base pointer，
    //eip是在该栈帧对应函数中调用下一个栈帧对应函数的指令的下一条指令的地址（return address）
    //args是传递给这第一个被调用的函数的参数

    // get ebp and eip
    uint32_t ebp = read_ebp(), eip = read_eip();
  100abb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100abe:	e8 d1 ff ff ff       	call   100a94 <read_eip>
  100ac3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // traverse all
    for(int i=0,j=0; ebp!=0 && i<STACKFRAME_DEPTH;i++){
  100ac6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100acd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100ad4:	e9 84 00 00 00       	jmp    100b5d <print_stackframe+0xb4>
        //print ebp & eip
        cprintf("ebp:0x%08x eip:0x%08x args:",ebp,eip);
  100ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100adc:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ae7:	c7 04 24 54 39 10 00 	movl   $0x103954,(%esp)
  100aee:	e8 a1 f7 ff ff       	call   100294 <cprintf>
        //print args
        // +1 -> 返回地址
        // +2 -> 参数
        uint32_t *args =(uint32_t*)ebp+2;
  100af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100af6:	83 c0 08             	add    $0x8,%eax
  100af9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for(j=0;j<4;j++){
  100afc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100b03:	eb 24                	jmp    100b29 <print_stackframe+0x80>
            cprintf("0x%08x ",args[j]);
  100b05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100b12:	01 d0                	add    %edx,%eax
  100b14:	8b 00                	mov    (%eax),%eax
  100b16:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b1a:	c7 04 24 70 39 10 00 	movl   $0x103970,(%esp)
  100b21:	e8 6e f7 ff ff       	call   100294 <cprintf>
        for(j=0;j<4;j++){
  100b26:	ff 45 e8             	incl   -0x18(%ebp)
  100b29:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100b2d:	7e d6                	jle    100b05 <print_stackframe+0x5c>
        }
        cprintf("\n");
  100b2f:	c7 04 24 78 39 10 00 	movl   $0x103978,(%esp)
  100b36:	e8 59 f7 ff ff       	call   100294 <cprintf>
        // print the C calling function name and line number, etc
        print_debuginfo(eip - 1);
  100b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b3e:	48                   	dec    %eax
  100b3f:	89 04 24             	mov    %eax,(%esp)
  100b42:	e8 a6 fe ff ff       	call   1009ed <print_debuginfo>
        // get next func call
        // popup a calling stackframe
        // the calling funciton's return addr eip  = ss:[ebp+4]
        // the calling funciton's ebp = ss:[ebp]
        eip = ((uint32_t *)ebp)[1];
  100b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b4a:	83 c0 04             	add    $0x4,%eax
  100b4d:	8b 00                	mov    (%eax),%eax
  100b4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b55:	8b 00                	mov    (%eax),%eax
  100b57:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(int i=0,j=0; ebp!=0 && i<STACKFRAME_DEPTH;i++){
  100b5a:	ff 45 ec             	incl   -0x14(%ebp)
  100b5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b61:	74 0a                	je     100b6d <print_stackframe+0xc4>
  100b63:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b67:	0f 8e 6c ff ff ff    	jle    100ad9 <print_stackframe+0x30>
    }
}
  100b6d:	90                   	nop
  100b6e:	c9                   	leave  
  100b6f:	c3                   	ret    

00100b70 <parse>:
/*  parse
 *  do
 *      parse the command buffer into whitespace-separated arguments
 */
static int
parse(char *buf, char **argv) {
  100b70:	f3 0f 1e fb          	endbr32 
  100b74:	55                   	push   %ebp
  100b75:	89 e5                	mov    %esp,%ebp
  100b77:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b81:	eb 0c                	jmp    100b8f <parse+0x1f>
            *buf ++ = '\0';
  100b83:	8b 45 08             	mov    0x8(%ebp),%eax
  100b86:	8d 50 01             	lea    0x1(%eax),%edx
  100b89:	89 55 08             	mov    %edx,0x8(%ebp)
  100b8c:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b92:	0f b6 00             	movzbl (%eax),%eax
  100b95:	84 c0                	test   %al,%al
  100b97:	74 1d                	je     100bb6 <parse+0x46>
  100b99:	8b 45 08             	mov    0x8(%ebp),%eax
  100b9c:	0f b6 00             	movzbl (%eax),%eax
  100b9f:	0f be c0             	movsbl %al,%eax
  100ba2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ba6:	c7 04 24 fc 39 10 00 	movl   $0x1039fc,(%esp)
  100bad:	e8 df 21 00 00       	call   102d91 <strchr>
  100bb2:	85 c0                	test   %eax,%eax
  100bb4:	75 cd                	jne    100b83 <parse+0x13>
        }
        if (*buf == '\0') {
  100bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb9:	0f b6 00             	movzbl (%eax),%eax
  100bbc:	84 c0                	test   %al,%al
  100bbe:	74 65                	je     100c25 <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100bc0:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100bc4:	75 14                	jne    100bda <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100bc6:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100bcd:	00 
  100bce:	c7 04 24 01 3a 10 00 	movl   $0x103a01,(%esp)
  100bd5:	e8 ba f6 ff ff       	call   100294 <cprintf>
        }
        argv[argc ++] = buf;
  100bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bdd:	8d 50 01             	lea    0x1(%eax),%edx
  100be0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100be3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100bea:	8b 45 0c             	mov    0xc(%ebp),%eax
  100bed:	01 c2                	add    %eax,%edx
  100bef:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf2:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bf4:	eb 03                	jmp    100bf9 <parse+0x89>
            buf ++;
  100bf6:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  100bfc:	0f b6 00             	movzbl (%eax),%eax
  100bff:	84 c0                	test   %al,%al
  100c01:	74 8c                	je     100b8f <parse+0x1f>
  100c03:	8b 45 08             	mov    0x8(%ebp),%eax
  100c06:	0f b6 00             	movzbl (%eax),%eax
  100c09:	0f be c0             	movsbl %al,%eax
  100c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c10:	c7 04 24 fc 39 10 00 	movl   $0x1039fc,(%esp)
  100c17:	e8 75 21 00 00       	call   102d91 <strchr>
  100c1c:	85 c0                	test   %eax,%eax
  100c1e:	74 d6                	je     100bf6 <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c20:	e9 6a ff ff ff       	jmp    100b8f <parse+0x1f>
            break;
  100c25:	90                   	nop
        }
    }
    return argc;
  100c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c29:	c9                   	leave  
  100c2a:	c3                   	ret    

00100c2b <runcmd>:
 *  do
 *      1.  parse the input string and split it into separated arguments
 *      2.  lookup and invoke some related commands
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c2b:	f3 0f 1e fb          	endbr32 
  100c2f:	55                   	push   %ebp
  100c30:	89 e5                	mov    %esp,%ebp
  100c32:	53                   	push   %ebx
  100c33:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c36:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c39:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  100c40:	89 04 24             	mov    %eax,(%esp)
  100c43:	e8 28 ff ff ff       	call   100b70 <parse>
  100c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c4f:	75 0a                	jne    100c5b <runcmd+0x30>
        return 0;
  100c51:	b8 00 00 00 00       	mov    $0x0,%eax
  100c56:	e9 83 00 00 00       	jmp    100cde <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c62:	eb 5a                	jmp    100cbe <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c64:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c6a:	89 d0                	mov    %edx,%eax
  100c6c:	01 c0                	add    %eax,%eax
  100c6e:	01 d0                	add    %edx,%eax
  100c70:	c1 e0 02             	shl    $0x2,%eax
  100c73:	05 00 00 11 00       	add    $0x110000,%eax
  100c78:	8b 00                	mov    (%eax),%eax
  100c7a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c7e:	89 04 24             	mov    %eax,(%esp)
  100c81:	e8 67 20 00 00       	call   102ced <strcmp>
  100c86:	85 c0                	test   %eax,%eax
  100c88:	75 31                	jne    100cbb <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c8d:	89 d0                	mov    %edx,%eax
  100c8f:	01 c0                	add    %eax,%eax
  100c91:	01 d0                	add    %edx,%eax
  100c93:	c1 e0 02             	shl    $0x2,%eax
  100c96:	05 08 00 11 00       	add    $0x110008,%eax
  100c9b:	8b 10                	mov    (%eax),%edx
  100c9d:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100ca0:	83 c0 04             	add    $0x4,%eax
  100ca3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100ca6:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100ca9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100cac:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100cb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cb4:	89 1c 24             	mov    %ebx,(%esp)
  100cb7:	ff d2                	call   *%edx
  100cb9:	eb 23                	jmp    100cde <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100cbb:	ff 45 f4             	incl   -0xc(%ebp)
  100cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cc1:	83 f8 02             	cmp    $0x2,%eax
  100cc4:	76 9e                	jbe    100c64 <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100cc6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100cc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ccd:	c7 04 24 1f 3a 10 00 	movl   $0x103a1f,(%esp)
  100cd4:	e8 bb f5 ff ff       	call   100294 <cprintf>
    return 0;
  100cd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cde:	83 c4 64             	add    $0x64,%esp
  100ce1:	5b                   	pop    %ebx
  100ce2:	5d                   	pop    %ebp
  100ce3:	c3                   	ret    

00100ce4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/
void
kmonitor(struct trapframe *tf) {
  100ce4:	f3 0f 1e fb          	endbr32 
  100ce8:	55                   	push   %ebp
  100ce9:	89 e5                	mov    %esp,%ebp
  100ceb:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100cee:	c7 04 24 38 3a 10 00 	movl   $0x103a38,(%esp)
  100cf5:	e8 9a f5 ff ff       	call   100294 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100cfa:	c7 04 24 60 3a 10 00 	movl   $0x103a60,(%esp)
  100d01:	e8 8e f5 ff ff       	call   100294 <cprintf>

    if (tf != NULL) {
  100d06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d0a:	74 0b                	je     100d17 <kmonitor+0x33>
        print_trapframe(tf);
  100d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  100d0f:	89 04 24             	mov    %eax,(%esp)
  100d12:	e8 7c 0e 00 00       	call   101b93 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d17:	c7 04 24 85 3a 10 00 	movl   $0x103a85,(%esp)
  100d1e:	e8 24 f6 ff ff       	call   100347 <readline>
  100d23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d2a:	74 eb                	je     100d17 <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  100d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d36:	89 04 24             	mov    %eax,(%esp)
  100d39:	e8 ed fe ff ff       	call   100c2b <runcmd>
  100d3e:	85 c0                	test   %eax,%eax
  100d40:	78 02                	js     100d44 <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100d42:	eb d3                	jmp    100d17 <kmonitor+0x33>
                break;
  100d44:	90                   	nop
            }
        }
    }
}
  100d45:	90                   	nop
  100d46:	c9                   	leave  
  100d47:	c3                   	ret    

00100d48 <mon_help>:
 *  mon_help
 *  do
 *      print the information about mon_* functions
 * */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d48:	f3 0f 1e fb          	endbr32 
  100d4c:	55                   	push   %ebp
  100d4d:	89 e5                	mov    %esp,%ebp
  100d4f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d59:	eb 3d                	jmp    100d98 <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d5e:	89 d0                	mov    %edx,%eax
  100d60:	01 c0                	add    %eax,%eax
  100d62:	01 d0                	add    %edx,%eax
  100d64:	c1 e0 02             	shl    $0x2,%eax
  100d67:	05 04 00 11 00       	add    $0x110004,%eax
  100d6c:	8b 08                	mov    (%eax),%ecx
  100d6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d71:	89 d0                	mov    %edx,%eax
  100d73:	01 c0                	add    %eax,%eax
  100d75:	01 d0                	add    %edx,%eax
  100d77:	c1 e0 02             	shl    $0x2,%eax
  100d7a:	05 00 00 11 00       	add    $0x110000,%eax
  100d7f:	8b 00                	mov    (%eax),%eax
  100d81:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d85:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d89:	c7 04 24 89 3a 10 00 	movl   $0x103a89,(%esp)
  100d90:	e8 ff f4 ff ff       	call   100294 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d95:	ff 45 f4             	incl   -0xc(%ebp)
  100d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d9b:	83 f8 02             	cmp    $0x2,%eax
  100d9e:	76 bb                	jbe    100d5b <mon_help+0x13>
    }
    return 0;
  100da0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100da5:	c9                   	leave  
  100da6:	c3                   	ret    

00100da7 <mon_kerninfo>:
 *  do
 *      print the memory occupancy in kernel 
 *      by calling print_kerninfo(kern/debug/kdebug.c)
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100da7:	f3 0f 1e fb          	endbr32 
  100dab:	55                   	push   %ebp
  100dac:	89 e5                	mov    %esp,%ebp
  100dae:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100db1:	e8 a1 fb ff ff       	call   100957 <print_kerninfo>
    return 0;
  100db6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dbb:	c9                   	leave  
  100dbc:	c3                   	ret    

00100dbd <mon_backtrace>:
 *  do
 *      to print a backtrace of the stack
 *      by calling print_stackframe(kern/debug/kdebug.c)
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100dbd:	f3 0f 1e fb          	endbr32 
  100dc1:	55                   	push   %ebp
  100dc2:	89 e5                	mov    %esp,%ebp
  100dc4:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100dc7:	e8 dd fc ff ff       	call   100aa9 <print_stackframe>
    return 0;
  100dcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dd1:	c9                   	leave  
  100dd2:	c3                   	ret    

00100dd3 <clock_init>:
/* *
 * clock_init
 * initialize 8253 clock to interrupt 100 times per second, and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100dd3:	f3 0f 1e fb          	endbr32 
  100dd7:	55                   	push   %ebp
  100dd8:	89 e5                	mov    %esp,%ebp
  100dda:	83 ec 28             	sub    $0x28,%esp
  100ddd:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100de3:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100de7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100deb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100def:	ee                   	out    %al,(%dx)
}
  100df0:	90                   	nop
  100df1:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100df7:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dfb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dff:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e03:	ee                   	out    %al,(%dx)
}
  100e04:	90                   	nop
  100e05:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100e0b:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e0f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e13:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e17:	ee                   	out    %al,(%dx)
}
  100e18:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e19:	c7 05 08 19 11 00 00 	movl   $0x0,0x111908
  100e20:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e23:	c7 04 24 92 3a 10 00 	movl   $0x103a92,(%esp)
  100e2a:	e8 65 f4 ff ff       	call   100294 <cprintf>
    pic_enable(IRQ_TIMER);
  100e2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e36:	e8 31 09 00 00       	call   10176c <pic_enable>
}
  100e3b:	90                   	nop
  100e3c:	c9                   	leave  
  100e3d:	c3                   	ret    

00100e3e <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e3e:	f3 0f 1e fb          	endbr32 
  100e42:	55                   	push   %ebp
  100e43:	89 e5                	mov    %esp,%ebp
  100e45:	83 ec 10             	sub    $0x10,%esp
  100e48:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e4e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e52:	89 c2                	mov    %eax,%edx
  100e54:	ec                   	in     (%dx),%al
  100e55:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e58:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e5e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e62:	89 c2                	mov    %eax,%edx
  100e64:	ec                   	in     (%dx),%al
  100e65:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e68:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e6e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e72:	89 c2                	mov    %eax,%edx
  100e74:	ec                   	in     (%dx),%al
  100e75:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e78:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e7e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e82:	89 c2                	mov    %eax,%edx
  100e84:	ec                   	in     (%dx),%al
  100e85:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e88:	90                   	nop
  100e89:	c9                   	leave  
  100e8a:	c3                   	ret    

00100e8b <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e8b:	f3 0f 1e fb          	endbr32 
  100e8f:	55                   	push   %ebp
  100e90:	89 e5                	mov    %esp,%ebp
  100e92:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e95:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e9f:	0f b7 00             	movzwl (%eax),%eax
  100ea2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea9:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100eae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb1:	0f b7 00             	movzwl (%eax),%eax
  100eb4:	0f b7 c0             	movzwl %ax,%eax
  100eb7:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100ebc:	74 12                	je     100ed0 <cga_init+0x45>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100ebe:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100ec5:	66 c7 05 66 0e 11 00 	movw   $0x3b4,0x110e66
  100ecc:	b4 03 
  100ece:	eb 13                	jmp    100ee3 <cga_init+0x58>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ed7:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100eda:	66 c7 05 66 0e 11 00 	movw   $0x3d4,0x110e66
  100ee1:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100ee3:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100eea:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100eee:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ef2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ef6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100efa:	ee                   	out    %al,(%dx)
}
  100efb:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100efc:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f03:	40                   	inc    %eax
  100f04:	0f b7 c0             	movzwl %ax,%eax
  100f07:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f0b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f0f:	89 c2                	mov    %eax,%edx
  100f11:	ec                   	in     (%dx),%al
  100f12:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f15:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f19:	0f b6 c0             	movzbl %al,%eax
  100f1c:	c1 e0 08             	shl    $0x8,%eax
  100f1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f22:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f29:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f2d:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f31:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f35:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f39:	ee                   	out    %al,(%dx)
}
  100f3a:	90                   	nop
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100f3b:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f42:	40                   	inc    %eax
  100f43:	0f b7 c0             	movzwl %ax,%eax
  100f46:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f4a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f4e:	89 c2                	mov    %eax,%edx
  100f50:	ec                   	in     (%dx),%al
  100f51:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f54:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f58:	0f b6 c0             	movzbl %al,%eax
  100f5b:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f61:	a3 60 0e 11 00       	mov    %eax,0x110e60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f69:	0f b7 c0             	movzwl %ax,%eax
  100f6c:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
}
  100f72:	90                   	nop
  100f73:	c9                   	leave  
  100f74:	c3                   	ret    

00100f75 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f75:	f3 0f 1e fb          	endbr32 
  100f79:	55                   	push   %ebp
  100f7a:	89 e5                	mov    %esp,%ebp
  100f7c:	83 ec 48             	sub    $0x48,%esp
  100f7f:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f85:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f89:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f8d:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f91:	ee                   	out    %al,(%dx)
}
  100f92:	90                   	nop
  100f93:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f99:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f9d:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100fa1:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100fa5:	ee                   	out    %al,(%dx)
}
  100fa6:	90                   	nop
  100fa7:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100fad:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fb1:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100fb5:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fb9:	ee                   	out    %al,(%dx)
}
  100fba:	90                   	nop
  100fbb:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fc1:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fc5:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fc9:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fcd:	ee                   	out    %al,(%dx)
}
  100fce:	90                   	nop
  100fcf:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100fd5:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fd9:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fdd:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fe1:	ee                   	out    %al,(%dx)
}
  100fe2:	90                   	nop
  100fe3:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100fe9:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fed:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ff1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ff5:	ee                   	out    %al,(%dx)
}
  100ff6:	90                   	nop
  100ff7:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100ffd:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101001:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101005:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101009:	ee                   	out    %al,(%dx)
}
  10100a:	90                   	nop
  10100b:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101011:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  101015:	89 c2                	mov    %eax,%edx
  101017:	ec                   	in     (%dx),%al
  101018:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  10101b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10101f:	3c ff                	cmp    $0xff,%al
  101021:	0f 95 c0             	setne  %al
  101024:	0f b6 c0             	movzbl %al,%eax
  101027:	a3 68 0e 11 00       	mov    %eax,0x110e68
  10102c:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101032:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101036:	89 c2                	mov    %eax,%edx
  101038:	ec                   	in     (%dx),%al
  101039:	88 45 f1             	mov    %al,-0xf(%ebp)
  10103c:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101042:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101046:	89 c2                	mov    %eax,%edx
  101048:	ec                   	in     (%dx),%al
  101049:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10104c:	a1 68 0e 11 00       	mov    0x110e68,%eax
  101051:	85 c0                	test   %eax,%eax
  101053:	74 0c                	je     101061 <serial_init+0xec>
        pic_enable(IRQ_COM1);
  101055:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10105c:	e8 0b 07 00 00       	call   10176c <pic_enable>
    }
}
  101061:	90                   	nop
  101062:	c9                   	leave  
  101063:	c3                   	ret    

00101064 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101064:	f3 0f 1e fb          	endbr32 
  101068:	55                   	push   %ebp
  101069:	89 e5                	mov    %esp,%ebp
  10106b:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10106e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101075:	eb 08                	jmp    10107f <lpt_putc_sub+0x1b>
        delay();
  101077:	e8 c2 fd ff ff       	call   100e3e <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10107c:	ff 45 fc             	incl   -0x4(%ebp)
  10107f:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101085:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101089:	89 c2                	mov    %eax,%edx
  10108b:	ec                   	in     (%dx),%al
  10108c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10108f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101093:	84 c0                	test   %al,%al
  101095:	78 09                	js     1010a0 <lpt_putc_sub+0x3c>
  101097:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10109e:	7e d7                	jle    101077 <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  1010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1010a3:	0f b6 c0             	movzbl %al,%eax
  1010a6:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  1010ac:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010af:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010b3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010b7:	ee                   	out    %al,(%dx)
}
  1010b8:	90                   	nop
  1010b9:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010bf:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010c3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010c7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010cb:	ee                   	out    %al,(%dx)
}
  1010cc:	90                   	nop
  1010cd:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010d3:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010d7:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010db:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010df:	ee                   	out    %al,(%dx)
}
  1010e0:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010e1:	90                   	nop
  1010e2:	c9                   	leave  
  1010e3:	c3                   	ret    

001010e4 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010e4:	f3 0f 1e fb          	endbr32 
  1010e8:	55                   	push   %ebp
  1010e9:	89 e5                	mov    %esp,%ebp
  1010eb:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010ee:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010f2:	74 0d                	je     101101 <lpt_putc+0x1d>
        lpt_putc_sub(c);
  1010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f7:	89 04 24             	mov    %eax,(%esp)
  1010fa:	e8 65 ff ff ff       	call   101064 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010ff:	eb 24                	jmp    101125 <lpt_putc+0x41>
        lpt_putc_sub('\b');
  101101:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101108:	e8 57 ff ff ff       	call   101064 <lpt_putc_sub>
        lpt_putc_sub(' ');
  10110d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101114:	e8 4b ff ff ff       	call   101064 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101119:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101120:	e8 3f ff ff ff       	call   101064 <lpt_putc_sub>
}
  101125:	90                   	nop
  101126:	c9                   	leave  
  101127:	c3                   	ret    

00101128 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101128:	f3 0f 1e fb          	endbr32 
  10112c:	55                   	push   %ebp
  10112d:	89 e5                	mov    %esp,%ebp
  10112f:	53                   	push   %ebx
  101130:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101133:	8b 45 08             	mov    0x8(%ebp),%eax
  101136:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10113b:	85 c0                	test   %eax,%eax
  10113d:	75 07                	jne    101146 <cga_putc+0x1e>
        c |= 0x0700;
  10113f:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101146:	8b 45 08             	mov    0x8(%ebp),%eax
  101149:	0f b6 c0             	movzbl %al,%eax
  10114c:	83 f8 0d             	cmp    $0xd,%eax
  10114f:	74 72                	je     1011c3 <cga_putc+0x9b>
  101151:	83 f8 0d             	cmp    $0xd,%eax
  101154:	0f 8f a3 00 00 00    	jg     1011fd <cga_putc+0xd5>
  10115a:	83 f8 08             	cmp    $0x8,%eax
  10115d:	74 0a                	je     101169 <cga_putc+0x41>
  10115f:	83 f8 0a             	cmp    $0xa,%eax
  101162:	74 4c                	je     1011b0 <cga_putc+0x88>
  101164:	e9 94 00 00 00       	jmp    1011fd <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  101169:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101170:	85 c0                	test   %eax,%eax
  101172:	0f 84 af 00 00 00    	je     101227 <cga_putc+0xff>
            crt_pos --;
  101178:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  10117f:	48                   	dec    %eax
  101180:	0f b7 c0             	movzwl %ax,%eax
  101183:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101189:	8b 45 08             	mov    0x8(%ebp),%eax
  10118c:	98                   	cwtl   
  10118d:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101192:	98                   	cwtl   
  101193:	83 c8 20             	or     $0x20,%eax
  101196:	98                   	cwtl   
  101197:	8b 15 60 0e 11 00    	mov    0x110e60,%edx
  10119d:	0f b7 0d 64 0e 11 00 	movzwl 0x110e64,%ecx
  1011a4:	01 c9                	add    %ecx,%ecx
  1011a6:	01 ca                	add    %ecx,%edx
  1011a8:	0f b7 c0             	movzwl %ax,%eax
  1011ab:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011ae:	eb 77                	jmp    101227 <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  1011b0:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1011b7:	83 c0 50             	add    $0x50,%eax
  1011ba:	0f b7 c0             	movzwl %ax,%eax
  1011bd:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011c3:	0f b7 1d 64 0e 11 00 	movzwl 0x110e64,%ebx
  1011ca:	0f b7 0d 64 0e 11 00 	movzwl 0x110e64,%ecx
  1011d1:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1011d6:	89 c8                	mov    %ecx,%eax
  1011d8:	f7 e2                	mul    %edx
  1011da:	c1 ea 06             	shr    $0x6,%edx
  1011dd:	89 d0                	mov    %edx,%eax
  1011df:	c1 e0 02             	shl    $0x2,%eax
  1011e2:	01 d0                	add    %edx,%eax
  1011e4:	c1 e0 04             	shl    $0x4,%eax
  1011e7:	29 c1                	sub    %eax,%ecx
  1011e9:	89 c8                	mov    %ecx,%eax
  1011eb:	0f b7 c0             	movzwl %ax,%eax
  1011ee:	29 c3                	sub    %eax,%ebx
  1011f0:	89 d8                	mov    %ebx,%eax
  1011f2:	0f b7 c0             	movzwl %ax,%eax
  1011f5:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
        break;
  1011fb:	eb 2b                	jmp    101228 <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011fd:	8b 0d 60 0e 11 00    	mov    0x110e60,%ecx
  101203:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  10120a:	8d 50 01             	lea    0x1(%eax),%edx
  10120d:	0f b7 d2             	movzwl %dx,%edx
  101210:	66 89 15 64 0e 11 00 	mov    %dx,0x110e64
  101217:	01 c0                	add    %eax,%eax
  101219:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10121c:	8b 45 08             	mov    0x8(%ebp),%eax
  10121f:	0f b7 c0             	movzwl %ax,%eax
  101222:	66 89 02             	mov    %ax,(%edx)
        break;
  101225:	eb 01                	jmp    101228 <cga_putc+0x100>
        break;
  101227:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101228:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  10122f:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101234:	76 5d                	jbe    101293 <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101236:	a1 60 0e 11 00       	mov    0x110e60,%eax
  10123b:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101241:	a1 60 0e 11 00       	mov    0x110e60,%eax
  101246:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10124d:	00 
  10124e:	89 54 24 04          	mov    %edx,0x4(%esp)
  101252:	89 04 24             	mov    %eax,(%esp)
  101255:	e8 3c 1d 00 00       	call   102f96 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10125a:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101261:	eb 14                	jmp    101277 <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  101263:	a1 60 0e 11 00       	mov    0x110e60,%eax
  101268:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10126b:	01 d2                	add    %edx,%edx
  10126d:	01 d0                	add    %edx,%eax
  10126f:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101274:	ff 45 f4             	incl   -0xc(%ebp)
  101277:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10127e:	7e e3                	jle    101263 <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  101280:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101287:	83 e8 50             	sub    $0x50,%eax
  10128a:	0f b7 c0             	movzwl %ax,%eax
  10128d:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101293:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  10129a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  10129e:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012a2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012a6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012aa:	ee                   	out    %al,(%dx)
}
  1012ab:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  1012ac:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1012b3:	c1 e8 08             	shr    $0x8,%eax
  1012b6:	0f b7 c0             	movzwl %ax,%eax
  1012b9:	0f b6 c0             	movzbl %al,%eax
  1012bc:	0f b7 15 66 0e 11 00 	movzwl 0x110e66,%edx
  1012c3:	42                   	inc    %edx
  1012c4:	0f b7 d2             	movzwl %dx,%edx
  1012c7:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012cb:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012ce:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012d2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012d6:	ee                   	out    %al,(%dx)
}
  1012d7:	90                   	nop
    outb(addr_6845, 15);
  1012d8:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  1012df:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012e3:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012e7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012eb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012ef:	ee                   	out    %al,(%dx)
}
  1012f0:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  1012f1:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1012f8:	0f b6 c0             	movzbl %al,%eax
  1012fb:	0f b7 15 66 0e 11 00 	movzwl 0x110e66,%edx
  101302:	42                   	inc    %edx
  101303:	0f b7 d2             	movzwl %dx,%edx
  101306:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  10130a:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10130d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101311:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101315:	ee                   	out    %al,(%dx)
}
  101316:	90                   	nop
}
  101317:	90                   	nop
  101318:	83 c4 34             	add    $0x34,%esp
  10131b:	5b                   	pop    %ebx
  10131c:	5d                   	pop    %ebp
  10131d:	c3                   	ret    

0010131e <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10131e:	f3 0f 1e fb          	endbr32 
  101322:	55                   	push   %ebp
  101323:	89 e5                	mov    %esp,%ebp
  101325:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101328:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10132f:	eb 08                	jmp    101339 <serial_putc_sub+0x1b>
        delay();
  101331:	e8 08 fb ff ff       	call   100e3e <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101336:	ff 45 fc             	incl   -0x4(%ebp)
  101339:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10133f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101343:	89 c2                	mov    %eax,%edx
  101345:	ec                   	in     (%dx),%al
  101346:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101349:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10134d:	0f b6 c0             	movzbl %al,%eax
  101350:	83 e0 20             	and    $0x20,%eax
  101353:	85 c0                	test   %eax,%eax
  101355:	75 09                	jne    101360 <serial_putc_sub+0x42>
  101357:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10135e:	7e d1                	jle    101331 <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  101360:	8b 45 08             	mov    0x8(%ebp),%eax
  101363:	0f b6 c0             	movzbl %al,%eax
  101366:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10136c:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10136f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101373:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101377:	ee                   	out    %al,(%dx)
}
  101378:	90                   	nop
}
  101379:	90                   	nop
  10137a:	c9                   	leave  
  10137b:	c3                   	ret    

0010137c <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10137c:	f3 0f 1e fb          	endbr32 
  101380:	55                   	push   %ebp
  101381:	89 e5                	mov    %esp,%ebp
  101383:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101386:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10138a:	74 0d                	je     101399 <serial_putc+0x1d>
        serial_putc_sub(c);
  10138c:	8b 45 08             	mov    0x8(%ebp),%eax
  10138f:	89 04 24             	mov    %eax,(%esp)
  101392:	e8 87 ff ff ff       	call   10131e <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101397:	eb 24                	jmp    1013bd <serial_putc+0x41>
        serial_putc_sub('\b');
  101399:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013a0:	e8 79 ff ff ff       	call   10131e <serial_putc_sub>
        serial_putc_sub(' ');
  1013a5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1013ac:	e8 6d ff ff ff       	call   10131e <serial_putc_sub>
        serial_putc_sub('\b');
  1013b1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013b8:	e8 61 ff ff ff       	call   10131e <serial_putc_sub>
}
  1013bd:	90                   	nop
  1013be:	c9                   	leave  
  1013bf:	c3                   	ret    

001013c0 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013c0:	f3 0f 1e fb          	endbr32 
  1013c4:	55                   	push   %ebp
  1013c5:	89 e5                	mov    %esp,%ebp
  1013c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013ca:	eb 33                	jmp    1013ff <cons_intr+0x3f>
        if (c != 0) {
  1013cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013d0:	74 2d                	je     1013ff <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  1013d2:	a1 84 10 11 00       	mov    0x111084,%eax
  1013d7:	8d 50 01             	lea    0x1(%eax),%edx
  1013da:	89 15 84 10 11 00    	mov    %edx,0x111084
  1013e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013e3:	88 90 80 0e 11 00    	mov    %dl,0x110e80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013e9:	a1 84 10 11 00       	mov    0x111084,%eax
  1013ee:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013f3:	75 0a                	jne    1013ff <cons_intr+0x3f>
                cons.wpos = 0;
  1013f5:	c7 05 84 10 11 00 00 	movl   $0x0,0x111084
  1013fc:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  101402:	ff d0                	call   *%eax
  101404:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101407:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10140b:	75 bf                	jne    1013cc <cons_intr+0xc>
            }
        }
    }
}
  10140d:	90                   	nop
  10140e:	90                   	nop
  10140f:	c9                   	leave  
  101410:	c3                   	ret    

00101411 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101411:	f3 0f 1e fb          	endbr32 
  101415:	55                   	push   %ebp
  101416:	89 e5                	mov    %esp,%ebp
  101418:	83 ec 10             	sub    $0x10,%esp
  10141b:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101421:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101425:	89 c2                	mov    %eax,%edx
  101427:	ec                   	in     (%dx),%al
  101428:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10142b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10142f:	0f b6 c0             	movzbl %al,%eax
  101432:	83 e0 01             	and    $0x1,%eax
  101435:	85 c0                	test   %eax,%eax
  101437:	75 07                	jne    101440 <serial_proc_data+0x2f>
        return -1;
  101439:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10143e:	eb 2a                	jmp    10146a <serial_proc_data+0x59>
  101440:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101446:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10144a:	89 c2                	mov    %eax,%edx
  10144c:	ec                   	in     (%dx),%al
  10144d:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101450:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101454:	0f b6 c0             	movzbl %al,%eax
  101457:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10145a:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10145e:	75 07                	jne    101467 <serial_proc_data+0x56>
        c = '\b';
  101460:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101467:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10146a:	c9                   	leave  
  10146b:	c3                   	ret    

0010146c <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10146c:	f3 0f 1e fb          	endbr32 
  101470:	55                   	push   %ebp
  101471:	89 e5                	mov    %esp,%ebp
  101473:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101476:	a1 68 0e 11 00       	mov    0x110e68,%eax
  10147b:	85 c0                	test   %eax,%eax
  10147d:	74 0c                	je     10148b <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  10147f:	c7 04 24 11 14 10 00 	movl   $0x101411,(%esp)
  101486:	e8 35 ff ff ff       	call   1013c0 <cons_intr>
    }
}
  10148b:	90                   	nop
  10148c:	c9                   	leave  
  10148d:	c3                   	ret    

0010148e <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10148e:	f3 0f 1e fb          	endbr32 
  101492:	55                   	push   %ebp
  101493:	89 e5                	mov    %esp,%ebp
  101495:	83 ec 38             	sub    $0x38,%esp
  101498:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10149e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1014a1:	89 c2                	mov    %eax,%edx
  1014a3:	ec                   	in     (%dx),%al
  1014a4:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1014a7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014ab:	0f b6 c0             	movzbl %al,%eax
  1014ae:	83 e0 01             	and    $0x1,%eax
  1014b1:	85 c0                	test   %eax,%eax
  1014b3:	75 0a                	jne    1014bf <kbd_proc_data+0x31>
        return -1;
  1014b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014ba:	e9 56 01 00 00       	jmp    101615 <kbd_proc_data+0x187>
  1014bf:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1014c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1014c8:	89 c2                	mov    %eax,%edx
  1014ca:	ec                   	in     (%dx),%al
  1014cb:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014ce:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014d2:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014d5:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014d9:	75 17                	jne    1014f2 <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  1014db:	a1 88 10 11 00       	mov    0x111088,%eax
  1014e0:	83 c8 40             	or     $0x40,%eax
  1014e3:	a3 88 10 11 00       	mov    %eax,0x111088
        return 0;
  1014e8:	b8 00 00 00 00       	mov    $0x0,%eax
  1014ed:	e9 23 01 00 00       	jmp    101615 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  1014f2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f6:	84 c0                	test   %al,%al
  1014f8:	79 45                	jns    10153f <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014fa:	a1 88 10 11 00       	mov    0x111088,%eax
  1014ff:	83 e0 40             	and    $0x40,%eax
  101502:	85 c0                	test   %eax,%eax
  101504:	75 08                	jne    10150e <kbd_proc_data+0x80>
  101506:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10150a:	24 7f                	and    $0x7f,%al
  10150c:	eb 04                	jmp    101512 <kbd_proc_data+0x84>
  10150e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101512:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101515:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101519:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  101520:	0c 40                	or     $0x40,%al
  101522:	0f b6 c0             	movzbl %al,%eax
  101525:	f7 d0                	not    %eax
  101527:	89 c2                	mov    %eax,%edx
  101529:	a1 88 10 11 00       	mov    0x111088,%eax
  10152e:	21 d0                	and    %edx,%eax
  101530:	a3 88 10 11 00       	mov    %eax,0x111088
        return 0;
  101535:	b8 00 00 00 00       	mov    $0x0,%eax
  10153a:	e9 d6 00 00 00       	jmp    101615 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  10153f:	a1 88 10 11 00       	mov    0x111088,%eax
  101544:	83 e0 40             	and    $0x40,%eax
  101547:	85 c0                	test   %eax,%eax
  101549:	74 11                	je     10155c <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10154b:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10154f:	a1 88 10 11 00       	mov    0x111088,%eax
  101554:	83 e0 bf             	and    $0xffffffbf,%eax
  101557:	a3 88 10 11 00       	mov    %eax,0x111088
    }

    shift |= shiftcode[data];
  10155c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101560:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  101567:	0f b6 d0             	movzbl %al,%edx
  10156a:	a1 88 10 11 00       	mov    0x111088,%eax
  10156f:	09 d0                	or     %edx,%eax
  101571:	a3 88 10 11 00       	mov    %eax,0x111088
    shift ^= togglecode[data];
  101576:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10157a:	0f b6 80 40 01 11 00 	movzbl 0x110140(%eax),%eax
  101581:	0f b6 d0             	movzbl %al,%edx
  101584:	a1 88 10 11 00       	mov    0x111088,%eax
  101589:	31 d0                	xor    %edx,%eax
  10158b:	a3 88 10 11 00       	mov    %eax,0x111088

    c = charcode[shift & (CTL | SHIFT)][data];
  101590:	a1 88 10 11 00       	mov    0x111088,%eax
  101595:	83 e0 03             	and    $0x3,%eax
  101598:	8b 14 85 40 05 11 00 	mov    0x110540(,%eax,4),%edx
  10159f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015a3:	01 d0                	add    %edx,%eax
  1015a5:	0f b6 00             	movzbl (%eax),%eax
  1015a8:	0f b6 c0             	movzbl %al,%eax
  1015ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015ae:	a1 88 10 11 00       	mov    0x111088,%eax
  1015b3:	83 e0 08             	and    $0x8,%eax
  1015b6:	85 c0                	test   %eax,%eax
  1015b8:	74 22                	je     1015dc <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1015ba:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015be:	7e 0c                	jle    1015cc <kbd_proc_data+0x13e>
  1015c0:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015c4:	7f 06                	jg     1015cc <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1015c6:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015ca:	eb 10                	jmp    1015dc <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1015cc:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015d0:	7e 0a                	jle    1015dc <kbd_proc_data+0x14e>
  1015d2:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015d6:	7f 04                	jg     1015dc <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1015d8:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015dc:	a1 88 10 11 00       	mov    0x111088,%eax
  1015e1:	f7 d0                	not    %eax
  1015e3:	83 e0 06             	and    $0x6,%eax
  1015e6:	85 c0                	test   %eax,%eax
  1015e8:	75 28                	jne    101612 <kbd_proc_data+0x184>
  1015ea:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015f1:	75 1f                	jne    101612 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  1015f3:	c7 04 24 ad 3a 10 00 	movl   $0x103aad,(%esp)
  1015fa:	e8 95 ec ff ff       	call   100294 <cprintf>
  1015ff:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101605:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101609:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10160d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101610:	ee                   	out    %al,(%dx)
}
  101611:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101612:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101615:	c9                   	leave  
  101616:	c3                   	ret    

00101617 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101617:	f3 0f 1e fb          	endbr32 
  10161b:	55                   	push   %ebp
  10161c:	89 e5                	mov    %esp,%ebp
  10161e:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101621:	c7 04 24 8e 14 10 00 	movl   $0x10148e,(%esp)
  101628:	e8 93 fd ff ff       	call   1013c0 <cons_intr>
}
  10162d:	90                   	nop
  10162e:	c9                   	leave  
  10162f:	c3                   	ret    

00101630 <kbd_init>:

static void
kbd_init(void) {
  101630:	f3 0f 1e fb          	endbr32 
  101634:	55                   	push   %ebp
  101635:	89 e5                	mov    %esp,%ebp
  101637:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10163a:	e8 d8 ff ff ff       	call   101617 <kbd_intr>
    pic_enable(IRQ_KBD);
  10163f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101646:	e8 21 01 00 00       	call   10176c <pic_enable>
}
  10164b:	90                   	nop
  10164c:	c9                   	leave  
  10164d:	c3                   	ret    

0010164e <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10164e:	f3 0f 1e fb          	endbr32 
  101652:	55                   	push   %ebp
  101653:	89 e5                	mov    %esp,%ebp
  101655:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101658:	e8 2e f8 ff ff       	call   100e8b <cga_init>
    serial_init();
  10165d:	e8 13 f9 ff ff       	call   100f75 <serial_init>
    kbd_init();
  101662:	e8 c9 ff ff ff       	call   101630 <kbd_init>
    if (!serial_exists) {
  101667:	a1 68 0e 11 00       	mov    0x110e68,%eax
  10166c:	85 c0                	test   %eax,%eax
  10166e:	75 0c                	jne    10167c <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  101670:	c7 04 24 b9 3a 10 00 	movl   $0x103ab9,(%esp)
  101677:	e8 18 ec ff ff       	call   100294 <cprintf>
    }
}
  10167c:	90                   	nop
  10167d:	c9                   	leave  
  10167e:	c3                   	ret    

0010167f <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10167f:	f3 0f 1e fb          	endbr32 
  101683:	55                   	push   %ebp
  101684:	89 e5                	mov    %esp,%ebp
  101686:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101689:	8b 45 08             	mov    0x8(%ebp),%eax
  10168c:	89 04 24             	mov    %eax,(%esp)
  10168f:	e8 50 fa ff ff       	call   1010e4 <lpt_putc>
    cga_putc(c);
  101694:	8b 45 08             	mov    0x8(%ebp),%eax
  101697:	89 04 24             	mov    %eax,(%esp)
  10169a:	e8 89 fa ff ff       	call   101128 <cga_putc>
    serial_putc(c);
  10169f:	8b 45 08             	mov    0x8(%ebp),%eax
  1016a2:	89 04 24             	mov    %eax,(%esp)
  1016a5:	e8 d2 fc ff ff       	call   10137c <serial_putc>
}
  1016aa:	90                   	nop
  1016ab:	c9                   	leave  
  1016ac:	c3                   	ret    

001016ad <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1016ad:	f3 0f 1e fb          	endbr32 
  1016b1:	55                   	push   %ebp
  1016b2:	89 e5                	mov    %esp,%ebp
  1016b4:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1016b7:	e8 b0 fd ff ff       	call   10146c <serial_intr>
    kbd_intr();
  1016bc:	e8 56 ff ff ff       	call   101617 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1016c1:	8b 15 80 10 11 00    	mov    0x111080,%edx
  1016c7:	a1 84 10 11 00       	mov    0x111084,%eax
  1016cc:	39 c2                	cmp    %eax,%edx
  1016ce:	74 36                	je     101706 <cons_getc+0x59>
        c = cons.buf[cons.rpos ++];
  1016d0:	a1 80 10 11 00       	mov    0x111080,%eax
  1016d5:	8d 50 01             	lea    0x1(%eax),%edx
  1016d8:	89 15 80 10 11 00    	mov    %edx,0x111080
  1016de:	0f b6 80 80 0e 11 00 	movzbl 0x110e80(%eax),%eax
  1016e5:	0f b6 c0             	movzbl %al,%eax
  1016e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1016eb:	a1 80 10 11 00       	mov    0x111080,%eax
  1016f0:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016f5:	75 0a                	jne    101701 <cons_getc+0x54>
            cons.rpos = 0;
  1016f7:	c7 05 80 10 11 00 00 	movl   $0x0,0x111080
  1016fe:	00 00 00 
        }
        return c;
  101701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101704:	eb 05                	jmp    10170b <cons_getc+0x5e>
    }
    return 0;
  101706:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10170b:	c9                   	leave  
  10170c:	c3                   	ret    

0010170d <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10170d:	f3 0f 1e fb          	endbr32 
  101711:	55                   	push   %ebp
  101712:	89 e5                	mov    %esp,%ebp
  101714:	83 ec 14             	sub    $0x14,%esp
  101717:	8b 45 08             	mov    0x8(%ebp),%eax
  10171a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  10171e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101721:	66 a3 50 05 11 00    	mov    %ax,0x110550
    if (did_init) {
  101727:	a1 8c 10 11 00       	mov    0x11108c,%eax
  10172c:	85 c0                	test   %eax,%eax
  10172e:	74 39                	je     101769 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  101730:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101733:	0f b6 c0             	movzbl %al,%eax
  101736:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  10173c:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10173f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101743:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101747:	ee                   	out    %al,(%dx)
}
  101748:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101749:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10174d:	c1 e8 08             	shr    $0x8,%eax
  101750:	0f b7 c0             	movzwl %ax,%eax
  101753:	0f b6 c0             	movzbl %al,%eax
  101756:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  10175c:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10175f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101763:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101767:	ee                   	out    %al,(%dx)
}
  101768:	90                   	nop
    }
}
  101769:	90                   	nop
  10176a:	c9                   	leave  
  10176b:	c3                   	ret    

0010176c <pic_enable>:

void
pic_enable(unsigned int irq) {
  10176c:	f3 0f 1e fb          	endbr32 
  101770:	55                   	push   %ebp
  101771:	89 e5                	mov    %esp,%ebp
  101773:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101776:	8b 45 08             	mov    0x8(%ebp),%eax
  101779:	ba 01 00 00 00       	mov    $0x1,%edx
  10177e:	88 c1                	mov    %al,%cl
  101780:	d3 e2                	shl    %cl,%edx
  101782:	89 d0                	mov    %edx,%eax
  101784:	98                   	cwtl   
  101785:	f7 d0                	not    %eax
  101787:	0f bf d0             	movswl %ax,%edx
  10178a:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  101791:	98                   	cwtl   
  101792:	21 d0                	and    %edx,%eax
  101794:	98                   	cwtl   
  101795:	0f b7 c0             	movzwl %ax,%eax
  101798:	89 04 24             	mov    %eax,(%esp)
  10179b:	e8 6d ff ff ff       	call   10170d <pic_setmask>
}
  1017a0:	90                   	nop
  1017a1:	c9                   	leave  
  1017a2:	c3                   	ret    

001017a3 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1017a3:	f3 0f 1e fb          	endbr32 
  1017a7:	55                   	push   %ebp
  1017a8:	89 e5                	mov    %esp,%ebp
  1017aa:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017ad:	c7 05 8c 10 11 00 01 	movl   $0x1,0x11108c
  1017b4:	00 00 00 
  1017b7:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1017bd:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017c1:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017c5:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017c9:	ee                   	out    %al,(%dx)
}
  1017ca:	90                   	nop
  1017cb:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1017d1:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017d5:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017d9:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017dd:	ee                   	out    %al,(%dx)
}
  1017de:	90                   	nop
  1017df:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017e5:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017e9:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017ed:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017f1:	ee                   	out    %al,(%dx)
}
  1017f2:	90                   	nop
  1017f3:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1017f9:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017fd:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101801:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101805:	ee                   	out    %al,(%dx)
}
  101806:	90                   	nop
  101807:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  10180d:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101811:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101815:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101819:	ee                   	out    %al,(%dx)
}
  10181a:	90                   	nop
  10181b:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101821:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101825:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101829:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10182d:	ee                   	out    %al,(%dx)
}
  10182e:	90                   	nop
  10182f:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101835:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101839:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10183d:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101841:	ee                   	out    %al,(%dx)
}
  101842:	90                   	nop
  101843:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101849:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10184d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101851:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101855:	ee                   	out    %al,(%dx)
}
  101856:	90                   	nop
  101857:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  10185d:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101861:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101865:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101869:	ee                   	out    %al,(%dx)
}
  10186a:	90                   	nop
  10186b:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101871:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101875:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101879:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10187d:	ee                   	out    %al,(%dx)
}
  10187e:	90                   	nop
  10187f:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101885:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101889:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10188d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101891:	ee                   	out    %al,(%dx)
}
  101892:	90                   	nop
  101893:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101899:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10189d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1018a1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1018a5:	ee                   	out    %al,(%dx)
}
  1018a6:	90                   	nop
  1018a7:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1018ad:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018b1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1018b5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1018b9:	ee                   	out    %al,(%dx)
}
  1018ba:	90                   	nop
  1018bb:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1018c1:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018c5:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1018c9:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1018cd:	ee                   	out    %al,(%dx)
}
  1018ce:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1018cf:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1018d6:	3d ff ff 00 00       	cmp    $0xffff,%eax
  1018db:	74 0f                	je     1018ec <pic_init+0x149>
        pic_setmask(irq_mask);
  1018dd:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1018e4:	89 04 24             	mov    %eax,(%esp)
  1018e7:	e8 21 fe ff ff       	call   10170d <pic_setmask>
    }
}
  1018ec:	90                   	nop
  1018ed:	c9                   	leave  
  1018ee:	c3                   	ret    

001018ef <intr_enable>:
/*  intr_enable
 *  do
 *      enable irq interrupt
 */
void
intr_enable(void) {
  1018ef:	f3 0f 1e fb          	endbr32 
  1018f3:	55                   	push   %ebp
  1018f4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1018f6:	fb                   	sti    
}
  1018f7:	90                   	nop
    sti();
}
  1018f8:	90                   	nop
  1018f9:	5d                   	pop    %ebp
  1018fa:	c3                   	ret    

001018fb <intr_disable>:
/*  intr_disable
 *  do
 *      disable irq interrupt
 */
void
intr_disable(void) {
  1018fb:	f3 0f 1e fb          	endbr32 
  1018ff:	55                   	push   %ebp
  101900:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  101902:	fa                   	cli    
}
  101903:	90                   	nop
    cli();
}
  101904:	90                   	nop
  101905:	5d                   	pop    %ebp
  101906:	c3                   	ret    

00101907 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101907:	f3 0f 1e fb          	endbr32 
  10190b:	55                   	push   %ebp
  10190c:	89 e5                	mov    %esp,%ebp
  10190e:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101911:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101918:	00 
  101919:	c7 04 24 e0 3a 10 00 	movl   $0x103ae0,(%esp)
  101920:	e8 6f e9 ff ff       	call   100294 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101925:	c7 04 24 ea 3a 10 00 	movl   $0x103aea,(%esp)
  10192c:	e8 63 e9 ff ff       	call   100294 <cprintf>
    panic("EOT: kernel seems ok.");
  101931:	c7 44 24 08 f8 3a 10 	movl   $0x103af8,0x8(%esp)
  101938:	00 
  101939:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  101940:	00 
  101941:	c7 04 24 0e 3b 10 00 	movl   $0x103b0e,(%esp)
  101948:	e8 b3 ea ff ff       	call   100400 <__panic>

0010194d <idt_init>:
/*  idt_init
 *  do
 *      initialize IDT to each of the entry points in kern/trap/vectors.S 
 * */
void
idt_init(void) {
  10194d:	f3 0f 1e fb          	endbr32 
  101951:	55                   	push   %ebp
  101952:	89 e5                	mov    %esp,%ebp
  101954:	83 ec 10             	sub    $0x10,%esp
    //然后使用lidt加载IDT即可，指令格式与LGDT类似；至此完成了中断描述符表的初始化过程；

    // entry adders of ISR(Interrupt Service Routine)
    extern uintptr_t __vectors[];
    // setup the entries of ISR in IDT(Interrupt Description Table)
    int n=sizeof(idt)/sizeof(struct gatedesc);
  101957:	c7 45 f8 00 01 00 00 	movl   $0x100,-0x8(%ebp)
    for(int i=0;i<n;i++){
  10195e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101965:	e9 c4 00 00 00       	jmp    101a2e <idt_init+0xe1>
        trap: 1 for a trap (= exception) gate, 0 for an interrupt gate
        sel: 段选择器
        off: 偏移
        dpl: 特权级
        * */
        SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
  10196a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196d:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  101974:	0f b7 d0             	movzwl %ax,%edx
  101977:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197a:	66 89 14 c5 a0 10 11 	mov    %dx,0x1110a0(,%eax,8)
  101981:	00 
  101982:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101985:	66 c7 04 c5 a2 10 11 	movw   $0x8,0x1110a2(,%eax,8)
  10198c:	00 08 00 
  10198f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101992:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  101999:	00 
  10199a:	80 e2 e0             	and    $0xe0,%dl
  10199d:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  1019a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a7:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  1019ae:	00 
  1019af:	80 e2 1f             	and    $0x1f,%dl
  1019b2:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  1019b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019bc:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019c3:	00 
  1019c4:	80 e2 f0             	and    $0xf0,%dl
  1019c7:	80 ca 0e             	or     $0xe,%dl
  1019ca:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d4:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019db:	00 
  1019dc:	80 e2 ef             	and    $0xef,%dl
  1019df:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e9:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019f0:	00 
  1019f1:	80 e2 9f             	and    $0x9f,%dl
  1019f4:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019fe:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  101a05:	00 
  101a06:	80 ca 80             	or     $0x80,%dl
  101a09:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  101a10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a13:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  101a1a:	c1 e8 10             	shr    $0x10,%eax
  101a1d:	0f b7 d0             	movzwl %ax,%edx
  101a20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a23:	66 89 14 c5 a6 10 11 	mov    %dx,0x1110a6(,%eax,8)
  101a2a:	00 
    for(int i=0;i<n;i++){
  101a2b:	ff 45 fc             	incl   -0x4(%ebp)
  101a2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a31:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  101a34:	0f 8c 30 ff ff ff    	jl     10196a <idt_init+0x1d>
    }
    //系统调用中断
    //而ucore的应用程序处于特权级３，需要采用｀int 0x80`指令操作（软中断）来发出系统调用请求，并要能实现从特权级３到特权级０的转换
    //所以系统调用中断(T_SYSCALL)所对应的中断门描述符中的特权级（DPL）需要设置为３。
    SETGATE(idt[T_SYSCALL],1,GD_KTEXT,__vectors[T_SYSCALL],DPL_USER);
  101a3a:	a1 e0 07 11 00       	mov    0x1107e0,%eax
  101a3f:	0f b7 c0             	movzwl %ax,%eax
  101a42:	66 a3 a0 14 11 00    	mov    %ax,0x1114a0
  101a48:	66 c7 05 a2 14 11 00 	movw   $0x8,0x1114a2
  101a4f:	08 00 
  101a51:	0f b6 05 a4 14 11 00 	movzbl 0x1114a4,%eax
  101a58:	24 e0                	and    $0xe0,%al
  101a5a:	a2 a4 14 11 00       	mov    %al,0x1114a4
  101a5f:	0f b6 05 a4 14 11 00 	movzbl 0x1114a4,%eax
  101a66:	24 1f                	and    $0x1f,%al
  101a68:	a2 a4 14 11 00       	mov    %al,0x1114a4
  101a6d:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101a74:	0c 0f                	or     $0xf,%al
  101a76:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101a7b:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101a82:	24 ef                	and    $0xef,%al
  101a84:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101a89:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101a90:	0c 60                	or     $0x60,%al
  101a92:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101a97:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101a9e:	0c 80                	or     $0x80,%al
  101aa0:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101aa5:	a1 e0 07 11 00       	mov    0x1107e0,%eax
  101aaa:	c1 e8 10             	shr    $0x10,%eax
  101aad:	0f b7 c0             	movzwl %ax,%eax
  101ab0:	66 a3 a6 14 11 00    	mov    %ax,0x1114a6
    SETGATE(idt[T_SWITCH_TOK],0,GD_KTEXT,__vectors[T_SWITCH_TOK],DPL_USER);
  101ab6:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101abb:	0f b7 c0             	movzwl %ax,%eax
  101abe:	66 a3 68 14 11 00    	mov    %ax,0x111468
  101ac4:	66 c7 05 6a 14 11 00 	movw   $0x8,0x11146a
  101acb:	08 00 
  101acd:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101ad4:	24 e0                	and    $0xe0,%al
  101ad6:	a2 6c 14 11 00       	mov    %al,0x11146c
  101adb:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101ae2:	24 1f                	and    $0x1f,%al
  101ae4:	a2 6c 14 11 00       	mov    %al,0x11146c
  101ae9:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101af0:	24 f0                	and    $0xf0,%al
  101af2:	0c 0e                	or     $0xe,%al
  101af4:	a2 6d 14 11 00       	mov    %al,0x11146d
  101af9:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101b00:	24 ef                	and    $0xef,%al
  101b02:	a2 6d 14 11 00       	mov    %al,0x11146d
  101b07:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101b0e:	0c 60                	or     $0x60,%al
  101b10:	a2 6d 14 11 00       	mov    %al,0x11146d
  101b15:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101b1c:	0c 80                	or     $0x80,%al
  101b1e:	a2 6d 14 11 00       	mov    %al,0x11146d
  101b23:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101b28:	c1 e8 10             	shr    $0x10,%eax
  101b2b:	0f b7 c0             	movzwl %ax,%eax
  101b2e:	66 a3 6e 14 11 00    	mov    %ax,0x11146e
  101b34:	c7 45 f4 60 05 11 00 	movl   $0x110560,-0xc(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b3e:	0f 01 18             	lidtl  (%eax)
}
  101b41:	90                   	nop
    // load the IDT
    lidt(&idt_pd);
}
  101b42:	90                   	nop
  101b43:	c9                   	leave  
  101b44:	c3                   	ret    

00101b45 <trapname>:

static const char *
trapname(int trapno) {
  101b45:	f3 0f 1e fb          	endbr32 
  101b49:	55                   	push   %ebp
  101b4a:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4f:	83 f8 13             	cmp    $0x13,%eax
  101b52:	77 0c                	ja     101b60 <trapname+0x1b>
        return excnames[trapno];
  101b54:	8b 45 08             	mov    0x8(%ebp),%eax
  101b57:	8b 04 85 60 3e 10 00 	mov    0x103e60(,%eax,4),%eax
  101b5e:	eb 18                	jmp    101b78 <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101b60:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b64:	7e 0d                	jle    101b73 <trapname+0x2e>
  101b66:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b6a:	7f 07                	jg     101b73 <trapname+0x2e>
        return "Hardware Interrupt";
  101b6c:	b8 1f 3b 10 00       	mov    $0x103b1f,%eax
  101b71:	eb 05                	jmp    101b78 <trapname+0x33>
    }
    return "(unknown trap)";
  101b73:	b8 32 3b 10 00       	mov    $0x103b32,%eax
}
  101b78:	5d                   	pop    %ebp
  101b79:	c3                   	ret    

00101b7a <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101b7a:	f3 0f 1e fb          	endbr32 
  101b7e:	55                   	push   %ebp
  101b7f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b81:	8b 45 08             	mov    0x8(%ebp),%eax
  101b84:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b88:	83 f8 08             	cmp    $0x8,%eax
  101b8b:	0f 94 c0             	sete   %al
  101b8e:	0f b6 c0             	movzbl %al,%eax
}
  101b91:	5d                   	pop    %ebp
  101b92:	c3                   	ret    

00101b93 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b93:	f3 0f 1e fb          	endbr32 
  101b97:	55                   	push   %ebp
  101b98:	89 e5                	mov    %esp,%ebp
  101b9a:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba4:	c7 04 24 73 3b 10 00 	movl   $0x103b73,(%esp)
  101bab:	e8 e4 e6 ff ff       	call   100294 <cprintf>
    print_regs(&tf->tf_regs);
  101bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb3:	89 04 24             	mov    %eax,(%esp)
  101bb6:	e8 8d 01 00 00       	call   101d48 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbe:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc6:	c7 04 24 84 3b 10 00 	movl   $0x103b84,(%esp)
  101bcd:	e8 c2 e6 ff ff       	call   100294 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd5:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdd:	c7 04 24 97 3b 10 00 	movl   $0x103b97,(%esp)
  101be4:	e8 ab e6 ff ff       	call   100294 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101be9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bec:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf4:	c7 04 24 aa 3b 10 00 	movl   $0x103baa,(%esp)
  101bfb:	e8 94 e6 ff ff       	call   100294 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101c00:	8b 45 08             	mov    0x8(%ebp),%eax
  101c03:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101c07:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0b:	c7 04 24 bd 3b 10 00 	movl   $0x103bbd,(%esp)
  101c12:	e8 7d e6 ff ff       	call   100294 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101c17:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1a:	8b 40 30             	mov    0x30(%eax),%eax
  101c1d:	89 04 24             	mov    %eax,(%esp)
  101c20:	e8 20 ff ff ff       	call   101b45 <trapname>
  101c25:	8b 55 08             	mov    0x8(%ebp),%edx
  101c28:	8b 52 30             	mov    0x30(%edx),%edx
  101c2b:	89 44 24 08          	mov    %eax,0x8(%esp)
  101c2f:	89 54 24 04          	mov    %edx,0x4(%esp)
  101c33:	c7 04 24 d0 3b 10 00 	movl   $0x103bd0,(%esp)
  101c3a:	e8 55 e6 ff ff       	call   100294 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c42:	8b 40 34             	mov    0x34(%eax),%eax
  101c45:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c49:	c7 04 24 e2 3b 10 00 	movl   $0x103be2,(%esp)
  101c50:	e8 3f e6 ff ff       	call   100294 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101c55:	8b 45 08             	mov    0x8(%ebp),%eax
  101c58:	8b 40 38             	mov    0x38(%eax),%eax
  101c5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5f:	c7 04 24 f1 3b 10 00 	movl   $0x103bf1,(%esp)
  101c66:	e8 29 e6 ff ff       	call   100294 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c72:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c76:	c7 04 24 00 3c 10 00 	movl   $0x103c00,(%esp)
  101c7d:	e8 12 e6 ff ff       	call   100294 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c82:	8b 45 08             	mov    0x8(%ebp),%eax
  101c85:	8b 40 40             	mov    0x40(%eax),%eax
  101c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c8c:	c7 04 24 13 3c 10 00 	movl   $0x103c13,(%esp)
  101c93:	e8 fc e5 ff ff       	call   100294 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c9f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ca6:	eb 3d                	jmp    101ce5 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  101cab:	8b 50 40             	mov    0x40(%eax),%edx
  101cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101cb1:	21 d0                	and    %edx,%eax
  101cb3:	85 c0                	test   %eax,%eax
  101cb5:	74 28                	je     101cdf <print_trapframe+0x14c>
  101cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cba:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101cc1:	85 c0                	test   %eax,%eax
  101cc3:	74 1a                	je     101cdf <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cc8:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd3:	c7 04 24 22 3c 10 00 	movl   $0x103c22,(%esp)
  101cda:	e8 b5 e5 ff ff       	call   100294 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101cdf:	ff 45 f4             	incl   -0xc(%ebp)
  101ce2:	d1 65 f0             	shll   -0x10(%ebp)
  101ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ce8:	83 f8 17             	cmp    $0x17,%eax
  101ceb:	76 bb                	jbe    101ca8 <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101ced:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf0:	8b 40 40             	mov    0x40(%eax),%eax
  101cf3:	c1 e8 0c             	shr    $0xc,%eax
  101cf6:	83 e0 03             	and    $0x3,%eax
  101cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfd:	c7 04 24 26 3c 10 00 	movl   $0x103c26,(%esp)
  101d04:	e8 8b e5 ff ff       	call   100294 <cprintf>

    if (!trap_in_kernel(tf)) {
  101d09:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0c:	89 04 24             	mov    %eax,(%esp)
  101d0f:	e8 66 fe ff ff       	call   101b7a <trap_in_kernel>
  101d14:	85 c0                	test   %eax,%eax
  101d16:	75 2d                	jne    101d45 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101d18:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1b:	8b 40 44             	mov    0x44(%eax),%eax
  101d1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d22:	c7 04 24 2f 3c 10 00 	movl   $0x103c2f,(%esp)
  101d29:	e8 66 e5 ff ff       	call   100294 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d31:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101d35:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d39:	c7 04 24 3e 3c 10 00 	movl   $0x103c3e,(%esp)
  101d40:	e8 4f e5 ff ff       	call   100294 <cprintf>
    }
}
  101d45:	90                   	nop
  101d46:	c9                   	leave  
  101d47:	c3                   	ret    

00101d48 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101d48:	f3 0f 1e fb          	endbr32 
  101d4c:	55                   	push   %ebp
  101d4d:	89 e5                	mov    %esp,%ebp
  101d4f:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101d52:	8b 45 08             	mov    0x8(%ebp),%eax
  101d55:	8b 00                	mov    (%eax),%eax
  101d57:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d5b:	c7 04 24 51 3c 10 00 	movl   $0x103c51,(%esp)
  101d62:	e8 2d e5 ff ff       	call   100294 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101d67:	8b 45 08             	mov    0x8(%ebp),%eax
  101d6a:	8b 40 04             	mov    0x4(%eax),%eax
  101d6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d71:	c7 04 24 60 3c 10 00 	movl   $0x103c60,(%esp)
  101d78:	e8 17 e5 ff ff       	call   100294 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d80:	8b 40 08             	mov    0x8(%eax),%eax
  101d83:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d87:	c7 04 24 6f 3c 10 00 	movl   $0x103c6f,(%esp)
  101d8e:	e8 01 e5 ff ff       	call   100294 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d93:	8b 45 08             	mov    0x8(%ebp),%eax
  101d96:	8b 40 0c             	mov    0xc(%eax),%eax
  101d99:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d9d:	c7 04 24 7e 3c 10 00 	movl   $0x103c7e,(%esp)
  101da4:	e8 eb e4 ff ff       	call   100294 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101da9:	8b 45 08             	mov    0x8(%ebp),%eax
  101dac:	8b 40 10             	mov    0x10(%eax),%eax
  101daf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101db3:	c7 04 24 8d 3c 10 00 	movl   $0x103c8d,(%esp)
  101dba:	e8 d5 e4 ff ff       	call   100294 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc2:	8b 40 14             	mov    0x14(%eax),%eax
  101dc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dc9:	c7 04 24 9c 3c 10 00 	movl   $0x103c9c,(%esp)
  101dd0:	e8 bf e4 ff ff       	call   100294 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd8:	8b 40 18             	mov    0x18(%eax),%eax
  101ddb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ddf:	c7 04 24 ab 3c 10 00 	movl   $0x103cab,(%esp)
  101de6:	e8 a9 e4 ff ff       	call   100294 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101deb:	8b 45 08             	mov    0x8(%ebp),%eax
  101dee:	8b 40 1c             	mov    0x1c(%eax),%eax
  101df1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101df5:	c7 04 24 ba 3c 10 00 	movl   $0x103cba,(%esp)
  101dfc:	e8 93 e4 ff ff       	call   100294 <cprintf>
}
  101e01:	90                   	nop
  101e02:	c9                   	leave  
  101e03:	c3                   	ret    

00101e04 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101e04:	f3 0f 1e fb          	endbr32 
  101e08:	55                   	push   %ebp
  101e09:	89 e5                	mov    %esp,%ebp
  101e0b:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e11:	8b 40 30             	mov    0x30(%eax),%eax
  101e14:	83 f8 79             	cmp    $0x79,%eax
  101e17:	0f 84 54 01 00 00    	je     101f71 <trap_dispatch+0x16d>
  101e1d:	83 f8 79             	cmp    $0x79,%eax
  101e20:	0f 87 ba 01 00 00    	ja     101fe0 <trap_dispatch+0x1dc>
  101e26:	83 f8 78             	cmp    $0x78,%eax
  101e29:	0f 84 d0 00 00 00    	je     101eff <trap_dispatch+0xfb>
  101e2f:	83 f8 78             	cmp    $0x78,%eax
  101e32:	0f 87 a8 01 00 00    	ja     101fe0 <trap_dispatch+0x1dc>
  101e38:	83 f8 2f             	cmp    $0x2f,%eax
  101e3b:	0f 87 9f 01 00 00    	ja     101fe0 <trap_dispatch+0x1dc>
  101e41:	83 f8 2e             	cmp    $0x2e,%eax
  101e44:	0f 83 cb 01 00 00    	jae    102015 <trap_dispatch+0x211>
  101e4a:	83 f8 24             	cmp    $0x24,%eax
  101e4d:	74 5e                	je     101ead <trap_dispatch+0xa9>
  101e4f:	83 f8 24             	cmp    $0x24,%eax
  101e52:	0f 87 88 01 00 00    	ja     101fe0 <trap_dispatch+0x1dc>
  101e58:	83 f8 20             	cmp    $0x20,%eax
  101e5b:	74 0a                	je     101e67 <trap_dispatch+0x63>
  101e5d:	83 f8 21             	cmp    $0x21,%eax
  101e60:	74 74                	je     101ed6 <trap_dispatch+0xd2>
  101e62:	e9 79 01 00 00       	jmp    101fe0 <trap_dispatch+0x1dc>
    case IRQ_OFFSET + IRQ_TIMER:
        /* LAB1 YOUR CODE : STEP 3 */
        //record it
        ticks++;
  101e67:	a1 08 19 11 00       	mov    0x111908,%eax
  101e6c:	40                   	inc    %eax
  101e6d:	a3 08 19 11 00       	mov    %eax,0x111908
        if(ticks%TICK_NUM==0){
  101e72:	8b 0d 08 19 11 00    	mov    0x111908,%ecx
  101e78:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101e7d:	89 c8                	mov    %ecx,%eax
  101e7f:	f7 e2                	mul    %edx
  101e81:	c1 ea 05             	shr    $0x5,%edx
  101e84:	89 d0                	mov    %edx,%eax
  101e86:	c1 e0 02             	shl    $0x2,%eax
  101e89:	01 d0                	add    %edx,%eax
  101e8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101e92:	01 d0                	add    %edx,%eax
  101e94:	c1 e0 02             	shl    $0x2,%eax
  101e97:	29 c1                	sub    %eax,%ecx
  101e99:	89 ca                	mov    %ecx,%edx
  101e9b:	85 d2                	test   %edx,%edx
  101e9d:	0f 85 75 01 00 00    	jne    102018 <trap_dispatch+0x214>
            //print ticks info
            print_ticks();
  101ea3:	e8 5f fa ff ff       	call   101907 <print_ticks>
        }
        break;
  101ea8:	e9 6b 01 00 00       	jmp    102018 <trap_dispatch+0x214>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ead:	e8 fb f7 ff ff       	call   1016ad <cons_getc>
  101eb2:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101eb5:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101eb9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ebd:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ec1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ec5:	c7 04 24 c9 3c 10 00 	movl   $0x103cc9,(%esp)
  101ecc:	e8 c3 e3 ff ff       	call   100294 <cprintf>
        break;
  101ed1:	e9 49 01 00 00       	jmp    10201f <trap_dispatch+0x21b>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101ed6:	e8 d2 f7 ff ff       	call   1016ad <cons_getc>
  101edb:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101ede:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101ee2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ee6:	89 54 24 08          	mov    %edx,0x8(%esp)
  101eea:	89 44 24 04          	mov    %eax,0x4(%esp)
  101eee:	c7 04 24 db 3c 10 00 	movl   $0x103cdb,(%esp)
  101ef5:	e8 9a e3 ff ff       	call   100294 <cprintf>
        break;
  101efa:	e9 20 01 00 00       	jmp    10201f <trap_dispatch+0x21b>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101eff:	8b 45 08             	mov    0x8(%ebp),%eax
  101f02:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f06:	83 f8 1b             	cmp    $0x1b,%eax
  101f09:	0f 84 0c 01 00 00    	je     10201b <trap_dispatch+0x217>
            //为了使得程序在低CPL的情况下仍然能够使用IO，需要将eflags中对应的IOPL位置成表示用户态的
            //if CPL > IOPL, then cpu will generate a general protection.
            tf->tf_eflags |= FL_IOPL_MASK;
  101f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f12:	8b 40 40             	mov    0x40(%eax),%eax
  101f15:	0d 00 30 00 00       	or     $0x3000,%eax
  101f1a:	89 c2                	mov    %eax,%edx
  101f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f1f:	89 50 40             	mov    %edx,0x40(%eax)
            //iret认定在发生中断的时候是否发生了PL的切换，是取决于CPL和最终跳转回的地址的cs选择子对应的段描述符处的CPL（也就是发生中断前的CPL）是否相等来决定的
            //因此将保存在trapframe中的原先的cs修改成指向用户态描述子的USER_CS
            tf->tf_cs = USER_CS;
  101f22:	8b 45 08             	mov    0x8(%ebp),%eax
  101f25:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            //为了使得中断返回之后能够正常访问数据，将其他的段选择子都修改为USER_DS
            tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = USER_DS;
  101f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101f2e:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  101f34:	8b 45 08             	mov    0x8(%ebp),%eax
  101f37:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101f3e:	66 89 50 48          	mov    %dx,0x48(%eax)
  101f42:	8b 45 08             	mov    0x8(%ebp),%eax
  101f45:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101f49:	8b 45 08             	mov    0x8(%ebp),%eax
  101f4c:	66 89 50 20          	mov    %dx,0x20(%eax)
  101f50:	8b 45 08             	mov    0x8(%ebp),%eax
  101f53:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101f57:	8b 45 08             	mov    0x8(%ebp),%eax
  101f5a:	66 89 50 28          	mov    %dx,0x28(%eax)
  101f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f61:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f65:	8b 45 08             	mov    0x8(%ebp),%eax
  101f68:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            //switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
            // set temporary stack
            // then iret will jump to the right stack
            //*((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
        }
        break;
  101f6c:	e9 aa 00 00 00       	jmp    10201b <trap_dispatch+0x217>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101f71:	8b 45 08             	mov    0x8(%ebp),%eax
  101f74:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f78:	83 f8 08             	cmp    $0x8,%eax
  101f7b:	0f 84 9d 00 00 00    	je     10201e <trap_dispatch+0x21a>
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101f81:	8b 45 08             	mov    0x8(%ebp),%eax
  101f84:	8b 40 40             	mov    0x40(%eax),%eax
  101f87:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101f8c:	89 c2                	mov    %eax,%edx
  101f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f91:	89 50 40             	mov    %edx,0x40(%eax)
            tf->tf_cs = KERNEL_CS;
  101f94:	8b 45 08             	mov    0x8(%ebp),%eax
  101f97:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = KERNEL_DS;
  101f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101fa0:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
  101fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  101fa9:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101fad:	8b 45 08             	mov    0x8(%ebp),%eax
  101fb0:	66 89 50 48          	mov    %dx,0x48(%eax)
  101fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  101fb7:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  101fbe:	66 89 50 20          	mov    %dx,0x20(%eax)
  101fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  101fc5:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  101fcc:	66 89 50 28          	mov    %dx,0x28(%eax)
  101fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  101fd3:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101fda:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        }
        //panic("T_SWITCH_** ??\n");
        break;
  101fde:	eb 3e                	jmp    10201e <trap_dispatch+0x21a>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  101fe3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101fe7:	83 e0 03             	and    $0x3,%eax
  101fea:	85 c0                	test   %eax,%eax
  101fec:	75 31                	jne    10201f <trap_dispatch+0x21b>
            print_trapframe(tf);
  101fee:	8b 45 08             	mov    0x8(%ebp),%eax
  101ff1:	89 04 24             	mov    %eax,(%esp)
  101ff4:	e8 9a fb ff ff       	call   101b93 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101ff9:	c7 44 24 08 ea 3c 10 	movl   $0x103cea,0x8(%esp)
  102000:	00 
  102001:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
  102008:	00 
  102009:	c7 04 24 0e 3b 10 00 	movl   $0x103b0e,(%esp)
  102010:	e8 eb e3 ff ff       	call   100400 <__panic>
        break;
  102015:	90                   	nop
  102016:	eb 07                	jmp    10201f <trap_dispatch+0x21b>
        break;
  102018:	90                   	nop
  102019:	eb 04                	jmp    10201f <trap_dispatch+0x21b>
        break;
  10201b:	90                   	nop
  10201c:	eb 01                	jmp    10201f <trap_dispatch+0x21b>
        break;
  10201e:	90                   	nop
        }
    }
}
  10201f:	90                   	nop
  102020:	c9                   	leave  
  102021:	c3                   	ret    

00102022 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  102022:	f3 0f 1e fb          	endbr32 
  102026:	55                   	push   %ebp
  102027:	89 e5                	mov    %esp,%ebp
  102029:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  10202c:	8b 45 08             	mov    0x8(%ebp),%eax
  10202f:	89 04 24             	mov    %eax,(%esp)
  102032:	e8 cd fd ff ff       	call   101e04 <trap_dispatch>
}
  102037:	90                   	nop
  102038:	c9                   	leave  
  102039:	c3                   	ret    

0010203a <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $0
  10203c:	6a 00                	push   $0x0
  jmp __alltraps
  10203e:	e9 69 0a 00 00       	jmp    102aac <__alltraps>

00102043 <vector1>:
.globl vector1
vector1:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $1
  102045:	6a 01                	push   $0x1
  jmp __alltraps
  102047:	e9 60 0a 00 00       	jmp    102aac <__alltraps>

0010204c <vector2>:
.globl vector2
vector2:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $2
  10204e:	6a 02                	push   $0x2
  jmp __alltraps
  102050:	e9 57 0a 00 00       	jmp    102aac <__alltraps>

00102055 <vector3>:
.globl vector3
vector3:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $3
  102057:	6a 03                	push   $0x3
  jmp __alltraps
  102059:	e9 4e 0a 00 00       	jmp    102aac <__alltraps>

0010205e <vector4>:
.globl vector4
vector4:
  pushl $0
  10205e:	6a 00                	push   $0x0
  pushl $4
  102060:	6a 04                	push   $0x4
  jmp __alltraps
  102062:	e9 45 0a 00 00       	jmp    102aac <__alltraps>

00102067 <vector5>:
.globl vector5
vector5:
  pushl $0
  102067:	6a 00                	push   $0x0
  pushl $5
  102069:	6a 05                	push   $0x5
  jmp __alltraps
  10206b:	e9 3c 0a 00 00       	jmp    102aac <__alltraps>

00102070 <vector6>:
.globl vector6
vector6:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $6
  102072:	6a 06                	push   $0x6
  jmp __alltraps
  102074:	e9 33 0a 00 00       	jmp    102aac <__alltraps>

00102079 <vector7>:
.globl vector7
vector7:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $7
  10207b:	6a 07                	push   $0x7
  jmp __alltraps
  10207d:	e9 2a 0a 00 00       	jmp    102aac <__alltraps>

00102082 <vector8>:
.globl vector8
vector8:
  pushl $8
  102082:	6a 08                	push   $0x8
  jmp __alltraps
  102084:	e9 23 0a 00 00       	jmp    102aac <__alltraps>

00102089 <vector9>:
.globl vector9
vector9:
  pushl $0
  102089:	6a 00                	push   $0x0
  pushl $9
  10208b:	6a 09                	push   $0x9
  jmp __alltraps
  10208d:	e9 1a 0a 00 00       	jmp    102aac <__alltraps>

00102092 <vector10>:
.globl vector10
vector10:
  pushl $10
  102092:	6a 0a                	push   $0xa
  jmp __alltraps
  102094:	e9 13 0a 00 00       	jmp    102aac <__alltraps>

00102099 <vector11>:
.globl vector11
vector11:
  pushl $11
  102099:	6a 0b                	push   $0xb
  jmp __alltraps
  10209b:	e9 0c 0a 00 00       	jmp    102aac <__alltraps>

001020a0 <vector12>:
.globl vector12
vector12:
  pushl $12
  1020a0:	6a 0c                	push   $0xc
  jmp __alltraps
  1020a2:	e9 05 0a 00 00       	jmp    102aac <__alltraps>

001020a7 <vector13>:
.globl vector13
vector13:
  pushl $13
  1020a7:	6a 0d                	push   $0xd
  jmp __alltraps
  1020a9:	e9 fe 09 00 00       	jmp    102aac <__alltraps>

001020ae <vector14>:
.globl vector14
vector14:
  pushl $14
  1020ae:	6a 0e                	push   $0xe
  jmp __alltraps
  1020b0:	e9 f7 09 00 00       	jmp    102aac <__alltraps>

001020b5 <vector15>:
.globl vector15
vector15:
  pushl $0
  1020b5:	6a 00                	push   $0x0
  pushl $15
  1020b7:	6a 0f                	push   $0xf
  jmp __alltraps
  1020b9:	e9 ee 09 00 00       	jmp    102aac <__alltraps>

001020be <vector16>:
.globl vector16
vector16:
  pushl $0
  1020be:	6a 00                	push   $0x0
  pushl $16
  1020c0:	6a 10                	push   $0x10
  jmp __alltraps
  1020c2:	e9 e5 09 00 00       	jmp    102aac <__alltraps>

001020c7 <vector17>:
.globl vector17
vector17:
  pushl $17
  1020c7:	6a 11                	push   $0x11
  jmp __alltraps
  1020c9:	e9 de 09 00 00       	jmp    102aac <__alltraps>

001020ce <vector18>:
.globl vector18
vector18:
  pushl $0
  1020ce:	6a 00                	push   $0x0
  pushl $18
  1020d0:	6a 12                	push   $0x12
  jmp __alltraps
  1020d2:	e9 d5 09 00 00       	jmp    102aac <__alltraps>

001020d7 <vector19>:
.globl vector19
vector19:
  pushl $0
  1020d7:	6a 00                	push   $0x0
  pushl $19
  1020d9:	6a 13                	push   $0x13
  jmp __alltraps
  1020db:	e9 cc 09 00 00       	jmp    102aac <__alltraps>

001020e0 <vector20>:
.globl vector20
vector20:
  pushl $0
  1020e0:	6a 00                	push   $0x0
  pushl $20
  1020e2:	6a 14                	push   $0x14
  jmp __alltraps
  1020e4:	e9 c3 09 00 00       	jmp    102aac <__alltraps>

001020e9 <vector21>:
.globl vector21
vector21:
  pushl $0
  1020e9:	6a 00                	push   $0x0
  pushl $21
  1020eb:	6a 15                	push   $0x15
  jmp __alltraps
  1020ed:	e9 ba 09 00 00       	jmp    102aac <__alltraps>

001020f2 <vector22>:
.globl vector22
vector22:
  pushl $0
  1020f2:	6a 00                	push   $0x0
  pushl $22
  1020f4:	6a 16                	push   $0x16
  jmp __alltraps
  1020f6:	e9 b1 09 00 00       	jmp    102aac <__alltraps>

001020fb <vector23>:
.globl vector23
vector23:
  pushl $0
  1020fb:	6a 00                	push   $0x0
  pushl $23
  1020fd:	6a 17                	push   $0x17
  jmp __alltraps
  1020ff:	e9 a8 09 00 00       	jmp    102aac <__alltraps>

00102104 <vector24>:
.globl vector24
vector24:
  pushl $0
  102104:	6a 00                	push   $0x0
  pushl $24
  102106:	6a 18                	push   $0x18
  jmp __alltraps
  102108:	e9 9f 09 00 00       	jmp    102aac <__alltraps>

0010210d <vector25>:
.globl vector25
vector25:
  pushl $0
  10210d:	6a 00                	push   $0x0
  pushl $25
  10210f:	6a 19                	push   $0x19
  jmp __alltraps
  102111:	e9 96 09 00 00       	jmp    102aac <__alltraps>

00102116 <vector26>:
.globl vector26
vector26:
  pushl $0
  102116:	6a 00                	push   $0x0
  pushl $26
  102118:	6a 1a                	push   $0x1a
  jmp __alltraps
  10211a:	e9 8d 09 00 00       	jmp    102aac <__alltraps>

0010211f <vector27>:
.globl vector27
vector27:
  pushl $0
  10211f:	6a 00                	push   $0x0
  pushl $27
  102121:	6a 1b                	push   $0x1b
  jmp __alltraps
  102123:	e9 84 09 00 00       	jmp    102aac <__alltraps>

00102128 <vector28>:
.globl vector28
vector28:
  pushl $0
  102128:	6a 00                	push   $0x0
  pushl $28
  10212a:	6a 1c                	push   $0x1c
  jmp __alltraps
  10212c:	e9 7b 09 00 00       	jmp    102aac <__alltraps>

00102131 <vector29>:
.globl vector29
vector29:
  pushl $0
  102131:	6a 00                	push   $0x0
  pushl $29
  102133:	6a 1d                	push   $0x1d
  jmp __alltraps
  102135:	e9 72 09 00 00       	jmp    102aac <__alltraps>

0010213a <vector30>:
.globl vector30
vector30:
  pushl $0
  10213a:	6a 00                	push   $0x0
  pushl $30
  10213c:	6a 1e                	push   $0x1e
  jmp __alltraps
  10213e:	e9 69 09 00 00       	jmp    102aac <__alltraps>

00102143 <vector31>:
.globl vector31
vector31:
  pushl $0
  102143:	6a 00                	push   $0x0
  pushl $31
  102145:	6a 1f                	push   $0x1f
  jmp __alltraps
  102147:	e9 60 09 00 00       	jmp    102aac <__alltraps>

0010214c <vector32>:
.globl vector32
vector32:
  pushl $0
  10214c:	6a 00                	push   $0x0
  pushl $32
  10214e:	6a 20                	push   $0x20
  jmp __alltraps
  102150:	e9 57 09 00 00       	jmp    102aac <__alltraps>

00102155 <vector33>:
.globl vector33
vector33:
  pushl $0
  102155:	6a 00                	push   $0x0
  pushl $33
  102157:	6a 21                	push   $0x21
  jmp __alltraps
  102159:	e9 4e 09 00 00       	jmp    102aac <__alltraps>

0010215e <vector34>:
.globl vector34
vector34:
  pushl $0
  10215e:	6a 00                	push   $0x0
  pushl $34
  102160:	6a 22                	push   $0x22
  jmp __alltraps
  102162:	e9 45 09 00 00       	jmp    102aac <__alltraps>

00102167 <vector35>:
.globl vector35
vector35:
  pushl $0
  102167:	6a 00                	push   $0x0
  pushl $35
  102169:	6a 23                	push   $0x23
  jmp __alltraps
  10216b:	e9 3c 09 00 00       	jmp    102aac <__alltraps>

00102170 <vector36>:
.globl vector36
vector36:
  pushl $0
  102170:	6a 00                	push   $0x0
  pushl $36
  102172:	6a 24                	push   $0x24
  jmp __alltraps
  102174:	e9 33 09 00 00       	jmp    102aac <__alltraps>

00102179 <vector37>:
.globl vector37
vector37:
  pushl $0
  102179:	6a 00                	push   $0x0
  pushl $37
  10217b:	6a 25                	push   $0x25
  jmp __alltraps
  10217d:	e9 2a 09 00 00       	jmp    102aac <__alltraps>

00102182 <vector38>:
.globl vector38
vector38:
  pushl $0
  102182:	6a 00                	push   $0x0
  pushl $38
  102184:	6a 26                	push   $0x26
  jmp __alltraps
  102186:	e9 21 09 00 00       	jmp    102aac <__alltraps>

0010218b <vector39>:
.globl vector39
vector39:
  pushl $0
  10218b:	6a 00                	push   $0x0
  pushl $39
  10218d:	6a 27                	push   $0x27
  jmp __alltraps
  10218f:	e9 18 09 00 00       	jmp    102aac <__alltraps>

00102194 <vector40>:
.globl vector40
vector40:
  pushl $0
  102194:	6a 00                	push   $0x0
  pushl $40
  102196:	6a 28                	push   $0x28
  jmp __alltraps
  102198:	e9 0f 09 00 00       	jmp    102aac <__alltraps>

0010219d <vector41>:
.globl vector41
vector41:
  pushl $0
  10219d:	6a 00                	push   $0x0
  pushl $41
  10219f:	6a 29                	push   $0x29
  jmp __alltraps
  1021a1:	e9 06 09 00 00       	jmp    102aac <__alltraps>

001021a6 <vector42>:
.globl vector42
vector42:
  pushl $0
  1021a6:	6a 00                	push   $0x0
  pushl $42
  1021a8:	6a 2a                	push   $0x2a
  jmp __alltraps
  1021aa:	e9 fd 08 00 00       	jmp    102aac <__alltraps>

001021af <vector43>:
.globl vector43
vector43:
  pushl $0
  1021af:	6a 00                	push   $0x0
  pushl $43
  1021b1:	6a 2b                	push   $0x2b
  jmp __alltraps
  1021b3:	e9 f4 08 00 00       	jmp    102aac <__alltraps>

001021b8 <vector44>:
.globl vector44
vector44:
  pushl $0
  1021b8:	6a 00                	push   $0x0
  pushl $44
  1021ba:	6a 2c                	push   $0x2c
  jmp __alltraps
  1021bc:	e9 eb 08 00 00       	jmp    102aac <__alltraps>

001021c1 <vector45>:
.globl vector45
vector45:
  pushl $0
  1021c1:	6a 00                	push   $0x0
  pushl $45
  1021c3:	6a 2d                	push   $0x2d
  jmp __alltraps
  1021c5:	e9 e2 08 00 00       	jmp    102aac <__alltraps>

001021ca <vector46>:
.globl vector46
vector46:
  pushl $0
  1021ca:	6a 00                	push   $0x0
  pushl $46
  1021cc:	6a 2e                	push   $0x2e
  jmp __alltraps
  1021ce:	e9 d9 08 00 00       	jmp    102aac <__alltraps>

001021d3 <vector47>:
.globl vector47
vector47:
  pushl $0
  1021d3:	6a 00                	push   $0x0
  pushl $47
  1021d5:	6a 2f                	push   $0x2f
  jmp __alltraps
  1021d7:	e9 d0 08 00 00       	jmp    102aac <__alltraps>

001021dc <vector48>:
.globl vector48
vector48:
  pushl $0
  1021dc:	6a 00                	push   $0x0
  pushl $48
  1021de:	6a 30                	push   $0x30
  jmp __alltraps
  1021e0:	e9 c7 08 00 00       	jmp    102aac <__alltraps>

001021e5 <vector49>:
.globl vector49
vector49:
  pushl $0
  1021e5:	6a 00                	push   $0x0
  pushl $49
  1021e7:	6a 31                	push   $0x31
  jmp __alltraps
  1021e9:	e9 be 08 00 00       	jmp    102aac <__alltraps>

001021ee <vector50>:
.globl vector50
vector50:
  pushl $0
  1021ee:	6a 00                	push   $0x0
  pushl $50
  1021f0:	6a 32                	push   $0x32
  jmp __alltraps
  1021f2:	e9 b5 08 00 00       	jmp    102aac <__alltraps>

001021f7 <vector51>:
.globl vector51
vector51:
  pushl $0
  1021f7:	6a 00                	push   $0x0
  pushl $51
  1021f9:	6a 33                	push   $0x33
  jmp __alltraps
  1021fb:	e9 ac 08 00 00       	jmp    102aac <__alltraps>

00102200 <vector52>:
.globl vector52
vector52:
  pushl $0
  102200:	6a 00                	push   $0x0
  pushl $52
  102202:	6a 34                	push   $0x34
  jmp __alltraps
  102204:	e9 a3 08 00 00       	jmp    102aac <__alltraps>

00102209 <vector53>:
.globl vector53
vector53:
  pushl $0
  102209:	6a 00                	push   $0x0
  pushl $53
  10220b:	6a 35                	push   $0x35
  jmp __alltraps
  10220d:	e9 9a 08 00 00       	jmp    102aac <__alltraps>

00102212 <vector54>:
.globl vector54
vector54:
  pushl $0
  102212:	6a 00                	push   $0x0
  pushl $54
  102214:	6a 36                	push   $0x36
  jmp __alltraps
  102216:	e9 91 08 00 00       	jmp    102aac <__alltraps>

0010221b <vector55>:
.globl vector55
vector55:
  pushl $0
  10221b:	6a 00                	push   $0x0
  pushl $55
  10221d:	6a 37                	push   $0x37
  jmp __alltraps
  10221f:	e9 88 08 00 00       	jmp    102aac <__alltraps>

00102224 <vector56>:
.globl vector56
vector56:
  pushl $0
  102224:	6a 00                	push   $0x0
  pushl $56
  102226:	6a 38                	push   $0x38
  jmp __alltraps
  102228:	e9 7f 08 00 00       	jmp    102aac <__alltraps>

0010222d <vector57>:
.globl vector57
vector57:
  pushl $0
  10222d:	6a 00                	push   $0x0
  pushl $57
  10222f:	6a 39                	push   $0x39
  jmp __alltraps
  102231:	e9 76 08 00 00       	jmp    102aac <__alltraps>

00102236 <vector58>:
.globl vector58
vector58:
  pushl $0
  102236:	6a 00                	push   $0x0
  pushl $58
  102238:	6a 3a                	push   $0x3a
  jmp __alltraps
  10223a:	e9 6d 08 00 00       	jmp    102aac <__alltraps>

0010223f <vector59>:
.globl vector59
vector59:
  pushl $0
  10223f:	6a 00                	push   $0x0
  pushl $59
  102241:	6a 3b                	push   $0x3b
  jmp __alltraps
  102243:	e9 64 08 00 00       	jmp    102aac <__alltraps>

00102248 <vector60>:
.globl vector60
vector60:
  pushl $0
  102248:	6a 00                	push   $0x0
  pushl $60
  10224a:	6a 3c                	push   $0x3c
  jmp __alltraps
  10224c:	e9 5b 08 00 00       	jmp    102aac <__alltraps>

00102251 <vector61>:
.globl vector61
vector61:
  pushl $0
  102251:	6a 00                	push   $0x0
  pushl $61
  102253:	6a 3d                	push   $0x3d
  jmp __alltraps
  102255:	e9 52 08 00 00       	jmp    102aac <__alltraps>

0010225a <vector62>:
.globl vector62
vector62:
  pushl $0
  10225a:	6a 00                	push   $0x0
  pushl $62
  10225c:	6a 3e                	push   $0x3e
  jmp __alltraps
  10225e:	e9 49 08 00 00       	jmp    102aac <__alltraps>

00102263 <vector63>:
.globl vector63
vector63:
  pushl $0
  102263:	6a 00                	push   $0x0
  pushl $63
  102265:	6a 3f                	push   $0x3f
  jmp __alltraps
  102267:	e9 40 08 00 00       	jmp    102aac <__alltraps>

0010226c <vector64>:
.globl vector64
vector64:
  pushl $0
  10226c:	6a 00                	push   $0x0
  pushl $64
  10226e:	6a 40                	push   $0x40
  jmp __alltraps
  102270:	e9 37 08 00 00       	jmp    102aac <__alltraps>

00102275 <vector65>:
.globl vector65
vector65:
  pushl $0
  102275:	6a 00                	push   $0x0
  pushl $65
  102277:	6a 41                	push   $0x41
  jmp __alltraps
  102279:	e9 2e 08 00 00       	jmp    102aac <__alltraps>

0010227e <vector66>:
.globl vector66
vector66:
  pushl $0
  10227e:	6a 00                	push   $0x0
  pushl $66
  102280:	6a 42                	push   $0x42
  jmp __alltraps
  102282:	e9 25 08 00 00       	jmp    102aac <__alltraps>

00102287 <vector67>:
.globl vector67
vector67:
  pushl $0
  102287:	6a 00                	push   $0x0
  pushl $67
  102289:	6a 43                	push   $0x43
  jmp __alltraps
  10228b:	e9 1c 08 00 00       	jmp    102aac <__alltraps>

00102290 <vector68>:
.globl vector68
vector68:
  pushl $0
  102290:	6a 00                	push   $0x0
  pushl $68
  102292:	6a 44                	push   $0x44
  jmp __alltraps
  102294:	e9 13 08 00 00       	jmp    102aac <__alltraps>

00102299 <vector69>:
.globl vector69
vector69:
  pushl $0
  102299:	6a 00                	push   $0x0
  pushl $69
  10229b:	6a 45                	push   $0x45
  jmp __alltraps
  10229d:	e9 0a 08 00 00       	jmp    102aac <__alltraps>

001022a2 <vector70>:
.globl vector70
vector70:
  pushl $0
  1022a2:	6a 00                	push   $0x0
  pushl $70
  1022a4:	6a 46                	push   $0x46
  jmp __alltraps
  1022a6:	e9 01 08 00 00       	jmp    102aac <__alltraps>

001022ab <vector71>:
.globl vector71
vector71:
  pushl $0
  1022ab:	6a 00                	push   $0x0
  pushl $71
  1022ad:	6a 47                	push   $0x47
  jmp __alltraps
  1022af:	e9 f8 07 00 00       	jmp    102aac <__alltraps>

001022b4 <vector72>:
.globl vector72
vector72:
  pushl $0
  1022b4:	6a 00                	push   $0x0
  pushl $72
  1022b6:	6a 48                	push   $0x48
  jmp __alltraps
  1022b8:	e9 ef 07 00 00       	jmp    102aac <__alltraps>

001022bd <vector73>:
.globl vector73
vector73:
  pushl $0
  1022bd:	6a 00                	push   $0x0
  pushl $73
  1022bf:	6a 49                	push   $0x49
  jmp __alltraps
  1022c1:	e9 e6 07 00 00       	jmp    102aac <__alltraps>

001022c6 <vector74>:
.globl vector74
vector74:
  pushl $0
  1022c6:	6a 00                	push   $0x0
  pushl $74
  1022c8:	6a 4a                	push   $0x4a
  jmp __alltraps
  1022ca:	e9 dd 07 00 00       	jmp    102aac <__alltraps>

001022cf <vector75>:
.globl vector75
vector75:
  pushl $0
  1022cf:	6a 00                	push   $0x0
  pushl $75
  1022d1:	6a 4b                	push   $0x4b
  jmp __alltraps
  1022d3:	e9 d4 07 00 00       	jmp    102aac <__alltraps>

001022d8 <vector76>:
.globl vector76
vector76:
  pushl $0
  1022d8:	6a 00                	push   $0x0
  pushl $76
  1022da:	6a 4c                	push   $0x4c
  jmp __alltraps
  1022dc:	e9 cb 07 00 00       	jmp    102aac <__alltraps>

001022e1 <vector77>:
.globl vector77
vector77:
  pushl $0
  1022e1:	6a 00                	push   $0x0
  pushl $77
  1022e3:	6a 4d                	push   $0x4d
  jmp __alltraps
  1022e5:	e9 c2 07 00 00       	jmp    102aac <__alltraps>

001022ea <vector78>:
.globl vector78
vector78:
  pushl $0
  1022ea:	6a 00                	push   $0x0
  pushl $78
  1022ec:	6a 4e                	push   $0x4e
  jmp __alltraps
  1022ee:	e9 b9 07 00 00       	jmp    102aac <__alltraps>

001022f3 <vector79>:
.globl vector79
vector79:
  pushl $0
  1022f3:	6a 00                	push   $0x0
  pushl $79
  1022f5:	6a 4f                	push   $0x4f
  jmp __alltraps
  1022f7:	e9 b0 07 00 00       	jmp    102aac <__alltraps>

001022fc <vector80>:
.globl vector80
vector80:
  pushl $0
  1022fc:	6a 00                	push   $0x0
  pushl $80
  1022fe:	6a 50                	push   $0x50
  jmp __alltraps
  102300:	e9 a7 07 00 00       	jmp    102aac <__alltraps>

00102305 <vector81>:
.globl vector81
vector81:
  pushl $0
  102305:	6a 00                	push   $0x0
  pushl $81
  102307:	6a 51                	push   $0x51
  jmp __alltraps
  102309:	e9 9e 07 00 00       	jmp    102aac <__alltraps>

0010230e <vector82>:
.globl vector82
vector82:
  pushl $0
  10230e:	6a 00                	push   $0x0
  pushl $82
  102310:	6a 52                	push   $0x52
  jmp __alltraps
  102312:	e9 95 07 00 00       	jmp    102aac <__alltraps>

00102317 <vector83>:
.globl vector83
vector83:
  pushl $0
  102317:	6a 00                	push   $0x0
  pushl $83
  102319:	6a 53                	push   $0x53
  jmp __alltraps
  10231b:	e9 8c 07 00 00       	jmp    102aac <__alltraps>

00102320 <vector84>:
.globl vector84
vector84:
  pushl $0
  102320:	6a 00                	push   $0x0
  pushl $84
  102322:	6a 54                	push   $0x54
  jmp __alltraps
  102324:	e9 83 07 00 00       	jmp    102aac <__alltraps>

00102329 <vector85>:
.globl vector85
vector85:
  pushl $0
  102329:	6a 00                	push   $0x0
  pushl $85
  10232b:	6a 55                	push   $0x55
  jmp __alltraps
  10232d:	e9 7a 07 00 00       	jmp    102aac <__alltraps>

00102332 <vector86>:
.globl vector86
vector86:
  pushl $0
  102332:	6a 00                	push   $0x0
  pushl $86
  102334:	6a 56                	push   $0x56
  jmp __alltraps
  102336:	e9 71 07 00 00       	jmp    102aac <__alltraps>

0010233b <vector87>:
.globl vector87
vector87:
  pushl $0
  10233b:	6a 00                	push   $0x0
  pushl $87
  10233d:	6a 57                	push   $0x57
  jmp __alltraps
  10233f:	e9 68 07 00 00       	jmp    102aac <__alltraps>

00102344 <vector88>:
.globl vector88
vector88:
  pushl $0
  102344:	6a 00                	push   $0x0
  pushl $88
  102346:	6a 58                	push   $0x58
  jmp __alltraps
  102348:	e9 5f 07 00 00       	jmp    102aac <__alltraps>

0010234d <vector89>:
.globl vector89
vector89:
  pushl $0
  10234d:	6a 00                	push   $0x0
  pushl $89
  10234f:	6a 59                	push   $0x59
  jmp __alltraps
  102351:	e9 56 07 00 00       	jmp    102aac <__alltraps>

00102356 <vector90>:
.globl vector90
vector90:
  pushl $0
  102356:	6a 00                	push   $0x0
  pushl $90
  102358:	6a 5a                	push   $0x5a
  jmp __alltraps
  10235a:	e9 4d 07 00 00       	jmp    102aac <__alltraps>

0010235f <vector91>:
.globl vector91
vector91:
  pushl $0
  10235f:	6a 00                	push   $0x0
  pushl $91
  102361:	6a 5b                	push   $0x5b
  jmp __alltraps
  102363:	e9 44 07 00 00       	jmp    102aac <__alltraps>

00102368 <vector92>:
.globl vector92
vector92:
  pushl $0
  102368:	6a 00                	push   $0x0
  pushl $92
  10236a:	6a 5c                	push   $0x5c
  jmp __alltraps
  10236c:	e9 3b 07 00 00       	jmp    102aac <__alltraps>

00102371 <vector93>:
.globl vector93
vector93:
  pushl $0
  102371:	6a 00                	push   $0x0
  pushl $93
  102373:	6a 5d                	push   $0x5d
  jmp __alltraps
  102375:	e9 32 07 00 00       	jmp    102aac <__alltraps>

0010237a <vector94>:
.globl vector94
vector94:
  pushl $0
  10237a:	6a 00                	push   $0x0
  pushl $94
  10237c:	6a 5e                	push   $0x5e
  jmp __alltraps
  10237e:	e9 29 07 00 00       	jmp    102aac <__alltraps>

00102383 <vector95>:
.globl vector95
vector95:
  pushl $0
  102383:	6a 00                	push   $0x0
  pushl $95
  102385:	6a 5f                	push   $0x5f
  jmp __alltraps
  102387:	e9 20 07 00 00       	jmp    102aac <__alltraps>

0010238c <vector96>:
.globl vector96
vector96:
  pushl $0
  10238c:	6a 00                	push   $0x0
  pushl $96
  10238e:	6a 60                	push   $0x60
  jmp __alltraps
  102390:	e9 17 07 00 00       	jmp    102aac <__alltraps>

00102395 <vector97>:
.globl vector97
vector97:
  pushl $0
  102395:	6a 00                	push   $0x0
  pushl $97
  102397:	6a 61                	push   $0x61
  jmp __alltraps
  102399:	e9 0e 07 00 00       	jmp    102aac <__alltraps>

0010239e <vector98>:
.globl vector98
vector98:
  pushl $0
  10239e:	6a 00                	push   $0x0
  pushl $98
  1023a0:	6a 62                	push   $0x62
  jmp __alltraps
  1023a2:	e9 05 07 00 00       	jmp    102aac <__alltraps>

001023a7 <vector99>:
.globl vector99
vector99:
  pushl $0
  1023a7:	6a 00                	push   $0x0
  pushl $99
  1023a9:	6a 63                	push   $0x63
  jmp __alltraps
  1023ab:	e9 fc 06 00 00       	jmp    102aac <__alltraps>

001023b0 <vector100>:
.globl vector100
vector100:
  pushl $0
  1023b0:	6a 00                	push   $0x0
  pushl $100
  1023b2:	6a 64                	push   $0x64
  jmp __alltraps
  1023b4:	e9 f3 06 00 00       	jmp    102aac <__alltraps>

001023b9 <vector101>:
.globl vector101
vector101:
  pushl $0
  1023b9:	6a 00                	push   $0x0
  pushl $101
  1023bb:	6a 65                	push   $0x65
  jmp __alltraps
  1023bd:	e9 ea 06 00 00       	jmp    102aac <__alltraps>

001023c2 <vector102>:
.globl vector102
vector102:
  pushl $0
  1023c2:	6a 00                	push   $0x0
  pushl $102
  1023c4:	6a 66                	push   $0x66
  jmp __alltraps
  1023c6:	e9 e1 06 00 00       	jmp    102aac <__alltraps>

001023cb <vector103>:
.globl vector103
vector103:
  pushl $0
  1023cb:	6a 00                	push   $0x0
  pushl $103
  1023cd:	6a 67                	push   $0x67
  jmp __alltraps
  1023cf:	e9 d8 06 00 00       	jmp    102aac <__alltraps>

001023d4 <vector104>:
.globl vector104
vector104:
  pushl $0
  1023d4:	6a 00                	push   $0x0
  pushl $104
  1023d6:	6a 68                	push   $0x68
  jmp __alltraps
  1023d8:	e9 cf 06 00 00       	jmp    102aac <__alltraps>

001023dd <vector105>:
.globl vector105
vector105:
  pushl $0
  1023dd:	6a 00                	push   $0x0
  pushl $105
  1023df:	6a 69                	push   $0x69
  jmp __alltraps
  1023e1:	e9 c6 06 00 00       	jmp    102aac <__alltraps>

001023e6 <vector106>:
.globl vector106
vector106:
  pushl $0
  1023e6:	6a 00                	push   $0x0
  pushl $106
  1023e8:	6a 6a                	push   $0x6a
  jmp __alltraps
  1023ea:	e9 bd 06 00 00       	jmp    102aac <__alltraps>

001023ef <vector107>:
.globl vector107
vector107:
  pushl $0
  1023ef:	6a 00                	push   $0x0
  pushl $107
  1023f1:	6a 6b                	push   $0x6b
  jmp __alltraps
  1023f3:	e9 b4 06 00 00       	jmp    102aac <__alltraps>

001023f8 <vector108>:
.globl vector108
vector108:
  pushl $0
  1023f8:	6a 00                	push   $0x0
  pushl $108
  1023fa:	6a 6c                	push   $0x6c
  jmp __alltraps
  1023fc:	e9 ab 06 00 00       	jmp    102aac <__alltraps>

00102401 <vector109>:
.globl vector109
vector109:
  pushl $0
  102401:	6a 00                	push   $0x0
  pushl $109
  102403:	6a 6d                	push   $0x6d
  jmp __alltraps
  102405:	e9 a2 06 00 00       	jmp    102aac <__alltraps>

0010240a <vector110>:
.globl vector110
vector110:
  pushl $0
  10240a:	6a 00                	push   $0x0
  pushl $110
  10240c:	6a 6e                	push   $0x6e
  jmp __alltraps
  10240e:	e9 99 06 00 00       	jmp    102aac <__alltraps>

00102413 <vector111>:
.globl vector111
vector111:
  pushl $0
  102413:	6a 00                	push   $0x0
  pushl $111
  102415:	6a 6f                	push   $0x6f
  jmp __alltraps
  102417:	e9 90 06 00 00       	jmp    102aac <__alltraps>

0010241c <vector112>:
.globl vector112
vector112:
  pushl $0
  10241c:	6a 00                	push   $0x0
  pushl $112
  10241e:	6a 70                	push   $0x70
  jmp __alltraps
  102420:	e9 87 06 00 00       	jmp    102aac <__alltraps>

00102425 <vector113>:
.globl vector113
vector113:
  pushl $0
  102425:	6a 00                	push   $0x0
  pushl $113
  102427:	6a 71                	push   $0x71
  jmp __alltraps
  102429:	e9 7e 06 00 00       	jmp    102aac <__alltraps>

0010242e <vector114>:
.globl vector114
vector114:
  pushl $0
  10242e:	6a 00                	push   $0x0
  pushl $114
  102430:	6a 72                	push   $0x72
  jmp __alltraps
  102432:	e9 75 06 00 00       	jmp    102aac <__alltraps>

00102437 <vector115>:
.globl vector115
vector115:
  pushl $0
  102437:	6a 00                	push   $0x0
  pushl $115
  102439:	6a 73                	push   $0x73
  jmp __alltraps
  10243b:	e9 6c 06 00 00       	jmp    102aac <__alltraps>

00102440 <vector116>:
.globl vector116
vector116:
  pushl $0
  102440:	6a 00                	push   $0x0
  pushl $116
  102442:	6a 74                	push   $0x74
  jmp __alltraps
  102444:	e9 63 06 00 00       	jmp    102aac <__alltraps>

00102449 <vector117>:
.globl vector117
vector117:
  pushl $0
  102449:	6a 00                	push   $0x0
  pushl $117
  10244b:	6a 75                	push   $0x75
  jmp __alltraps
  10244d:	e9 5a 06 00 00       	jmp    102aac <__alltraps>

00102452 <vector118>:
.globl vector118
vector118:
  pushl $0
  102452:	6a 00                	push   $0x0
  pushl $118
  102454:	6a 76                	push   $0x76
  jmp __alltraps
  102456:	e9 51 06 00 00       	jmp    102aac <__alltraps>

0010245b <vector119>:
.globl vector119
vector119:
  pushl $0
  10245b:	6a 00                	push   $0x0
  pushl $119
  10245d:	6a 77                	push   $0x77
  jmp __alltraps
  10245f:	e9 48 06 00 00       	jmp    102aac <__alltraps>

00102464 <vector120>:
.globl vector120
vector120:
  pushl $0
  102464:	6a 00                	push   $0x0
  pushl $120
  102466:	6a 78                	push   $0x78
  jmp __alltraps
  102468:	e9 3f 06 00 00       	jmp    102aac <__alltraps>

0010246d <vector121>:
.globl vector121
vector121:
  pushl $0
  10246d:	6a 00                	push   $0x0
  pushl $121
  10246f:	6a 79                	push   $0x79
  jmp __alltraps
  102471:	e9 36 06 00 00       	jmp    102aac <__alltraps>

00102476 <vector122>:
.globl vector122
vector122:
  pushl $0
  102476:	6a 00                	push   $0x0
  pushl $122
  102478:	6a 7a                	push   $0x7a
  jmp __alltraps
  10247a:	e9 2d 06 00 00       	jmp    102aac <__alltraps>

0010247f <vector123>:
.globl vector123
vector123:
  pushl $0
  10247f:	6a 00                	push   $0x0
  pushl $123
  102481:	6a 7b                	push   $0x7b
  jmp __alltraps
  102483:	e9 24 06 00 00       	jmp    102aac <__alltraps>

00102488 <vector124>:
.globl vector124
vector124:
  pushl $0
  102488:	6a 00                	push   $0x0
  pushl $124
  10248a:	6a 7c                	push   $0x7c
  jmp __alltraps
  10248c:	e9 1b 06 00 00       	jmp    102aac <__alltraps>

00102491 <vector125>:
.globl vector125
vector125:
  pushl $0
  102491:	6a 00                	push   $0x0
  pushl $125
  102493:	6a 7d                	push   $0x7d
  jmp __alltraps
  102495:	e9 12 06 00 00       	jmp    102aac <__alltraps>

0010249a <vector126>:
.globl vector126
vector126:
  pushl $0
  10249a:	6a 00                	push   $0x0
  pushl $126
  10249c:	6a 7e                	push   $0x7e
  jmp __alltraps
  10249e:	e9 09 06 00 00       	jmp    102aac <__alltraps>

001024a3 <vector127>:
.globl vector127
vector127:
  pushl $0
  1024a3:	6a 00                	push   $0x0
  pushl $127
  1024a5:	6a 7f                	push   $0x7f
  jmp __alltraps
  1024a7:	e9 00 06 00 00       	jmp    102aac <__alltraps>

001024ac <vector128>:
.globl vector128
vector128:
  pushl $0
  1024ac:	6a 00                	push   $0x0
  pushl $128
  1024ae:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1024b3:	e9 f4 05 00 00       	jmp    102aac <__alltraps>

001024b8 <vector129>:
.globl vector129
vector129:
  pushl $0
  1024b8:	6a 00                	push   $0x0
  pushl $129
  1024ba:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1024bf:	e9 e8 05 00 00       	jmp    102aac <__alltraps>

001024c4 <vector130>:
.globl vector130
vector130:
  pushl $0
  1024c4:	6a 00                	push   $0x0
  pushl $130
  1024c6:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1024cb:	e9 dc 05 00 00       	jmp    102aac <__alltraps>

001024d0 <vector131>:
.globl vector131
vector131:
  pushl $0
  1024d0:	6a 00                	push   $0x0
  pushl $131
  1024d2:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1024d7:	e9 d0 05 00 00       	jmp    102aac <__alltraps>

001024dc <vector132>:
.globl vector132
vector132:
  pushl $0
  1024dc:	6a 00                	push   $0x0
  pushl $132
  1024de:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1024e3:	e9 c4 05 00 00       	jmp    102aac <__alltraps>

001024e8 <vector133>:
.globl vector133
vector133:
  pushl $0
  1024e8:	6a 00                	push   $0x0
  pushl $133
  1024ea:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1024ef:	e9 b8 05 00 00       	jmp    102aac <__alltraps>

001024f4 <vector134>:
.globl vector134
vector134:
  pushl $0
  1024f4:	6a 00                	push   $0x0
  pushl $134
  1024f6:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1024fb:	e9 ac 05 00 00       	jmp    102aac <__alltraps>

00102500 <vector135>:
.globl vector135
vector135:
  pushl $0
  102500:	6a 00                	push   $0x0
  pushl $135
  102502:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102507:	e9 a0 05 00 00       	jmp    102aac <__alltraps>

0010250c <vector136>:
.globl vector136
vector136:
  pushl $0
  10250c:	6a 00                	push   $0x0
  pushl $136
  10250e:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102513:	e9 94 05 00 00       	jmp    102aac <__alltraps>

00102518 <vector137>:
.globl vector137
vector137:
  pushl $0
  102518:	6a 00                	push   $0x0
  pushl $137
  10251a:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10251f:	e9 88 05 00 00       	jmp    102aac <__alltraps>

00102524 <vector138>:
.globl vector138
vector138:
  pushl $0
  102524:	6a 00                	push   $0x0
  pushl $138
  102526:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10252b:	e9 7c 05 00 00       	jmp    102aac <__alltraps>

00102530 <vector139>:
.globl vector139
vector139:
  pushl $0
  102530:	6a 00                	push   $0x0
  pushl $139
  102532:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102537:	e9 70 05 00 00       	jmp    102aac <__alltraps>

0010253c <vector140>:
.globl vector140
vector140:
  pushl $0
  10253c:	6a 00                	push   $0x0
  pushl $140
  10253e:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102543:	e9 64 05 00 00       	jmp    102aac <__alltraps>

00102548 <vector141>:
.globl vector141
vector141:
  pushl $0
  102548:	6a 00                	push   $0x0
  pushl $141
  10254a:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10254f:	e9 58 05 00 00       	jmp    102aac <__alltraps>

00102554 <vector142>:
.globl vector142
vector142:
  pushl $0
  102554:	6a 00                	push   $0x0
  pushl $142
  102556:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10255b:	e9 4c 05 00 00       	jmp    102aac <__alltraps>

00102560 <vector143>:
.globl vector143
vector143:
  pushl $0
  102560:	6a 00                	push   $0x0
  pushl $143
  102562:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102567:	e9 40 05 00 00       	jmp    102aac <__alltraps>

0010256c <vector144>:
.globl vector144
vector144:
  pushl $0
  10256c:	6a 00                	push   $0x0
  pushl $144
  10256e:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102573:	e9 34 05 00 00       	jmp    102aac <__alltraps>

00102578 <vector145>:
.globl vector145
vector145:
  pushl $0
  102578:	6a 00                	push   $0x0
  pushl $145
  10257a:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10257f:	e9 28 05 00 00       	jmp    102aac <__alltraps>

00102584 <vector146>:
.globl vector146
vector146:
  pushl $0
  102584:	6a 00                	push   $0x0
  pushl $146
  102586:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10258b:	e9 1c 05 00 00       	jmp    102aac <__alltraps>

00102590 <vector147>:
.globl vector147
vector147:
  pushl $0
  102590:	6a 00                	push   $0x0
  pushl $147
  102592:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102597:	e9 10 05 00 00       	jmp    102aac <__alltraps>

0010259c <vector148>:
.globl vector148
vector148:
  pushl $0
  10259c:	6a 00                	push   $0x0
  pushl $148
  10259e:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1025a3:	e9 04 05 00 00       	jmp    102aac <__alltraps>

001025a8 <vector149>:
.globl vector149
vector149:
  pushl $0
  1025a8:	6a 00                	push   $0x0
  pushl $149
  1025aa:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1025af:	e9 f8 04 00 00       	jmp    102aac <__alltraps>

001025b4 <vector150>:
.globl vector150
vector150:
  pushl $0
  1025b4:	6a 00                	push   $0x0
  pushl $150
  1025b6:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1025bb:	e9 ec 04 00 00       	jmp    102aac <__alltraps>

001025c0 <vector151>:
.globl vector151
vector151:
  pushl $0
  1025c0:	6a 00                	push   $0x0
  pushl $151
  1025c2:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1025c7:	e9 e0 04 00 00       	jmp    102aac <__alltraps>

001025cc <vector152>:
.globl vector152
vector152:
  pushl $0
  1025cc:	6a 00                	push   $0x0
  pushl $152
  1025ce:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1025d3:	e9 d4 04 00 00       	jmp    102aac <__alltraps>

001025d8 <vector153>:
.globl vector153
vector153:
  pushl $0
  1025d8:	6a 00                	push   $0x0
  pushl $153
  1025da:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1025df:	e9 c8 04 00 00       	jmp    102aac <__alltraps>

001025e4 <vector154>:
.globl vector154
vector154:
  pushl $0
  1025e4:	6a 00                	push   $0x0
  pushl $154
  1025e6:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1025eb:	e9 bc 04 00 00       	jmp    102aac <__alltraps>

001025f0 <vector155>:
.globl vector155
vector155:
  pushl $0
  1025f0:	6a 00                	push   $0x0
  pushl $155
  1025f2:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1025f7:	e9 b0 04 00 00       	jmp    102aac <__alltraps>

001025fc <vector156>:
.globl vector156
vector156:
  pushl $0
  1025fc:	6a 00                	push   $0x0
  pushl $156
  1025fe:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102603:	e9 a4 04 00 00       	jmp    102aac <__alltraps>

00102608 <vector157>:
.globl vector157
vector157:
  pushl $0
  102608:	6a 00                	push   $0x0
  pushl $157
  10260a:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10260f:	e9 98 04 00 00       	jmp    102aac <__alltraps>

00102614 <vector158>:
.globl vector158
vector158:
  pushl $0
  102614:	6a 00                	push   $0x0
  pushl $158
  102616:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10261b:	e9 8c 04 00 00       	jmp    102aac <__alltraps>

00102620 <vector159>:
.globl vector159
vector159:
  pushl $0
  102620:	6a 00                	push   $0x0
  pushl $159
  102622:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102627:	e9 80 04 00 00       	jmp    102aac <__alltraps>

0010262c <vector160>:
.globl vector160
vector160:
  pushl $0
  10262c:	6a 00                	push   $0x0
  pushl $160
  10262e:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102633:	e9 74 04 00 00       	jmp    102aac <__alltraps>

00102638 <vector161>:
.globl vector161
vector161:
  pushl $0
  102638:	6a 00                	push   $0x0
  pushl $161
  10263a:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10263f:	e9 68 04 00 00       	jmp    102aac <__alltraps>

00102644 <vector162>:
.globl vector162
vector162:
  pushl $0
  102644:	6a 00                	push   $0x0
  pushl $162
  102646:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10264b:	e9 5c 04 00 00       	jmp    102aac <__alltraps>

00102650 <vector163>:
.globl vector163
vector163:
  pushl $0
  102650:	6a 00                	push   $0x0
  pushl $163
  102652:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102657:	e9 50 04 00 00       	jmp    102aac <__alltraps>

0010265c <vector164>:
.globl vector164
vector164:
  pushl $0
  10265c:	6a 00                	push   $0x0
  pushl $164
  10265e:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102663:	e9 44 04 00 00       	jmp    102aac <__alltraps>

00102668 <vector165>:
.globl vector165
vector165:
  pushl $0
  102668:	6a 00                	push   $0x0
  pushl $165
  10266a:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10266f:	e9 38 04 00 00       	jmp    102aac <__alltraps>

00102674 <vector166>:
.globl vector166
vector166:
  pushl $0
  102674:	6a 00                	push   $0x0
  pushl $166
  102676:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10267b:	e9 2c 04 00 00       	jmp    102aac <__alltraps>

00102680 <vector167>:
.globl vector167
vector167:
  pushl $0
  102680:	6a 00                	push   $0x0
  pushl $167
  102682:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102687:	e9 20 04 00 00       	jmp    102aac <__alltraps>

0010268c <vector168>:
.globl vector168
vector168:
  pushl $0
  10268c:	6a 00                	push   $0x0
  pushl $168
  10268e:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102693:	e9 14 04 00 00       	jmp    102aac <__alltraps>

00102698 <vector169>:
.globl vector169
vector169:
  pushl $0
  102698:	6a 00                	push   $0x0
  pushl $169
  10269a:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10269f:	e9 08 04 00 00       	jmp    102aac <__alltraps>

001026a4 <vector170>:
.globl vector170
vector170:
  pushl $0
  1026a4:	6a 00                	push   $0x0
  pushl $170
  1026a6:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1026ab:	e9 fc 03 00 00       	jmp    102aac <__alltraps>

001026b0 <vector171>:
.globl vector171
vector171:
  pushl $0
  1026b0:	6a 00                	push   $0x0
  pushl $171
  1026b2:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1026b7:	e9 f0 03 00 00       	jmp    102aac <__alltraps>

001026bc <vector172>:
.globl vector172
vector172:
  pushl $0
  1026bc:	6a 00                	push   $0x0
  pushl $172
  1026be:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1026c3:	e9 e4 03 00 00       	jmp    102aac <__alltraps>

001026c8 <vector173>:
.globl vector173
vector173:
  pushl $0
  1026c8:	6a 00                	push   $0x0
  pushl $173
  1026ca:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1026cf:	e9 d8 03 00 00       	jmp    102aac <__alltraps>

001026d4 <vector174>:
.globl vector174
vector174:
  pushl $0
  1026d4:	6a 00                	push   $0x0
  pushl $174
  1026d6:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1026db:	e9 cc 03 00 00       	jmp    102aac <__alltraps>

001026e0 <vector175>:
.globl vector175
vector175:
  pushl $0
  1026e0:	6a 00                	push   $0x0
  pushl $175
  1026e2:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1026e7:	e9 c0 03 00 00       	jmp    102aac <__alltraps>

001026ec <vector176>:
.globl vector176
vector176:
  pushl $0
  1026ec:	6a 00                	push   $0x0
  pushl $176
  1026ee:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1026f3:	e9 b4 03 00 00       	jmp    102aac <__alltraps>

001026f8 <vector177>:
.globl vector177
vector177:
  pushl $0
  1026f8:	6a 00                	push   $0x0
  pushl $177
  1026fa:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1026ff:	e9 a8 03 00 00       	jmp    102aac <__alltraps>

00102704 <vector178>:
.globl vector178
vector178:
  pushl $0
  102704:	6a 00                	push   $0x0
  pushl $178
  102706:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10270b:	e9 9c 03 00 00       	jmp    102aac <__alltraps>

00102710 <vector179>:
.globl vector179
vector179:
  pushl $0
  102710:	6a 00                	push   $0x0
  pushl $179
  102712:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102717:	e9 90 03 00 00       	jmp    102aac <__alltraps>

0010271c <vector180>:
.globl vector180
vector180:
  pushl $0
  10271c:	6a 00                	push   $0x0
  pushl $180
  10271e:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102723:	e9 84 03 00 00       	jmp    102aac <__alltraps>

00102728 <vector181>:
.globl vector181
vector181:
  pushl $0
  102728:	6a 00                	push   $0x0
  pushl $181
  10272a:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10272f:	e9 78 03 00 00       	jmp    102aac <__alltraps>

00102734 <vector182>:
.globl vector182
vector182:
  pushl $0
  102734:	6a 00                	push   $0x0
  pushl $182
  102736:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10273b:	e9 6c 03 00 00       	jmp    102aac <__alltraps>

00102740 <vector183>:
.globl vector183
vector183:
  pushl $0
  102740:	6a 00                	push   $0x0
  pushl $183
  102742:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102747:	e9 60 03 00 00       	jmp    102aac <__alltraps>

0010274c <vector184>:
.globl vector184
vector184:
  pushl $0
  10274c:	6a 00                	push   $0x0
  pushl $184
  10274e:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102753:	e9 54 03 00 00       	jmp    102aac <__alltraps>

00102758 <vector185>:
.globl vector185
vector185:
  pushl $0
  102758:	6a 00                	push   $0x0
  pushl $185
  10275a:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10275f:	e9 48 03 00 00       	jmp    102aac <__alltraps>

00102764 <vector186>:
.globl vector186
vector186:
  pushl $0
  102764:	6a 00                	push   $0x0
  pushl $186
  102766:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10276b:	e9 3c 03 00 00       	jmp    102aac <__alltraps>

00102770 <vector187>:
.globl vector187
vector187:
  pushl $0
  102770:	6a 00                	push   $0x0
  pushl $187
  102772:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102777:	e9 30 03 00 00       	jmp    102aac <__alltraps>

0010277c <vector188>:
.globl vector188
vector188:
  pushl $0
  10277c:	6a 00                	push   $0x0
  pushl $188
  10277e:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102783:	e9 24 03 00 00       	jmp    102aac <__alltraps>

00102788 <vector189>:
.globl vector189
vector189:
  pushl $0
  102788:	6a 00                	push   $0x0
  pushl $189
  10278a:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10278f:	e9 18 03 00 00       	jmp    102aac <__alltraps>

00102794 <vector190>:
.globl vector190
vector190:
  pushl $0
  102794:	6a 00                	push   $0x0
  pushl $190
  102796:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10279b:	e9 0c 03 00 00       	jmp    102aac <__alltraps>

001027a0 <vector191>:
.globl vector191
vector191:
  pushl $0
  1027a0:	6a 00                	push   $0x0
  pushl $191
  1027a2:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1027a7:	e9 00 03 00 00       	jmp    102aac <__alltraps>

001027ac <vector192>:
.globl vector192
vector192:
  pushl $0
  1027ac:	6a 00                	push   $0x0
  pushl $192
  1027ae:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1027b3:	e9 f4 02 00 00       	jmp    102aac <__alltraps>

001027b8 <vector193>:
.globl vector193
vector193:
  pushl $0
  1027b8:	6a 00                	push   $0x0
  pushl $193
  1027ba:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1027bf:	e9 e8 02 00 00       	jmp    102aac <__alltraps>

001027c4 <vector194>:
.globl vector194
vector194:
  pushl $0
  1027c4:	6a 00                	push   $0x0
  pushl $194
  1027c6:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1027cb:	e9 dc 02 00 00       	jmp    102aac <__alltraps>

001027d0 <vector195>:
.globl vector195
vector195:
  pushl $0
  1027d0:	6a 00                	push   $0x0
  pushl $195
  1027d2:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1027d7:	e9 d0 02 00 00       	jmp    102aac <__alltraps>

001027dc <vector196>:
.globl vector196
vector196:
  pushl $0
  1027dc:	6a 00                	push   $0x0
  pushl $196
  1027de:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1027e3:	e9 c4 02 00 00       	jmp    102aac <__alltraps>

001027e8 <vector197>:
.globl vector197
vector197:
  pushl $0
  1027e8:	6a 00                	push   $0x0
  pushl $197
  1027ea:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1027ef:	e9 b8 02 00 00       	jmp    102aac <__alltraps>

001027f4 <vector198>:
.globl vector198
vector198:
  pushl $0
  1027f4:	6a 00                	push   $0x0
  pushl $198
  1027f6:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1027fb:	e9 ac 02 00 00       	jmp    102aac <__alltraps>

00102800 <vector199>:
.globl vector199
vector199:
  pushl $0
  102800:	6a 00                	push   $0x0
  pushl $199
  102802:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102807:	e9 a0 02 00 00       	jmp    102aac <__alltraps>

0010280c <vector200>:
.globl vector200
vector200:
  pushl $0
  10280c:	6a 00                	push   $0x0
  pushl $200
  10280e:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102813:	e9 94 02 00 00       	jmp    102aac <__alltraps>

00102818 <vector201>:
.globl vector201
vector201:
  pushl $0
  102818:	6a 00                	push   $0x0
  pushl $201
  10281a:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10281f:	e9 88 02 00 00       	jmp    102aac <__alltraps>

00102824 <vector202>:
.globl vector202
vector202:
  pushl $0
  102824:	6a 00                	push   $0x0
  pushl $202
  102826:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10282b:	e9 7c 02 00 00       	jmp    102aac <__alltraps>

00102830 <vector203>:
.globl vector203
vector203:
  pushl $0
  102830:	6a 00                	push   $0x0
  pushl $203
  102832:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102837:	e9 70 02 00 00       	jmp    102aac <__alltraps>

0010283c <vector204>:
.globl vector204
vector204:
  pushl $0
  10283c:	6a 00                	push   $0x0
  pushl $204
  10283e:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102843:	e9 64 02 00 00       	jmp    102aac <__alltraps>

00102848 <vector205>:
.globl vector205
vector205:
  pushl $0
  102848:	6a 00                	push   $0x0
  pushl $205
  10284a:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10284f:	e9 58 02 00 00       	jmp    102aac <__alltraps>

00102854 <vector206>:
.globl vector206
vector206:
  pushl $0
  102854:	6a 00                	push   $0x0
  pushl $206
  102856:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10285b:	e9 4c 02 00 00       	jmp    102aac <__alltraps>

00102860 <vector207>:
.globl vector207
vector207:
  pushl $0
  102860:	6a 00                	push   $0x0
  pushl $207
  102862:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102867:	e9 40 02 00 00       	jmp    102aac <__alltraps>

0010286c <vector208>:
.globl vector208
vector208:
  pushl $0
  10286c:	6a 00                	push   $0x0
  pushl $208
  10286e:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102873:	e9 34 02 00 00       	jmp    102aac <__alltraps>

00102878 <vector209>:
.globl vector209
vector209:
  pushl $0
  102878:	6a 00                	push   $0x0
  pushl $209
  10287a:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10287f:	e9 28 02 00 00       	jmp    102aac <__alltraps>

00102884 <vector210>:
.globl vector210
vector210:
  pushl $0
  102884:	6a 00                	push   $0x0
  pushl $210
  102886:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10288b:	e9 1c 02 00 00       	jmp    102aac <__alltraps>

00102890 <vector211>:
.globl vector211
vector211:
  pushl $0
  102890:	6a 00                	push   $0x0
  pushl $211
  102892:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102897:	e9 10 02 00 00       	jmp    102aac <__alltraps>

0010289c <vector212>:
.globl vector212
vector212:
  pushl $0
  10289c:	6a 00                	push   $0x0
  pushl $212
  10289e:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1028a3:	e9 04 02 00 00       	jmp    102aac <__alltraps>

001028a8 <vector213>:
.globl vector213
vector213:
  pushl $0
  1028a8:	6a 00                	push   $0x0
  pushl $213
  1028aa:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1028af:	e9 f8 01 00 00       	jmp    102aac <__alltraps>

001028b4 <vector214>:
.globl vector214
vector214:
  pushl $0
  1028b4:	6a 00                	push   $0x0
  pushl $214
  1028b6:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1028bb:	e9 ec 01 00 00       	jmp    102aac <__alltraps>

001028c0 <vector215>:
.globl vector215
vector215:
  pushl $0
  1028c0:	6a 00                	push   $0x0
  pushl $215
  1028c2:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1028c7:	e9 e0 01 00 00       	jmp    102aac <__alltraps>

001028cc <vector216>:
.globl vector216
vector216:
  pushl $0
  1028cc:	6a 00                	push   $0x0
  pushl $216
  1028ce:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1028d3:	e9 d4 01 00 00       	jmp    102aac <__alltraps>

001028d8 <vector217>:
.globl vector217
vector217:
  pushl $0
  1028d8:	6a 00                	push   $0x0
  pushl $217
  1028da:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1028df:	e9 c8 01 00 00       	jmp    102aac <__alltraps>

001028e4 <vector218>:
.globl vector218
vector218:
  pushl $0
  1028e4:	6a 00                	push   $0x0
  pushl $218
  1028e6:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1028eb:	e9 bc 01 00 00       	jmp    102aac <__alltraps>

001028f0 <vector219>:
.globl vector219
vector219:
  pushl $0
  1028f0:	6a 00                	push   $0x0
  pushl $219
  1028f2:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1028f7:	e9 b0 01 00 00       	jmp    102aac <__alltraps>

001028fc <vector220>:
.globl vector220
vector220:
  pushl $0
  1028fc:	6a 00                	push   $0x0
  pushl $220
  1028fe:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102903:	e9 a4 01 00 00       	jmp    102aac <__alltraps>

00102908 <vector221>:
.globl vector221
vector221:
  pushl $0
  102908:	6a 00                	push   $0x0
  pushl $221
  10290a:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10290f:	e9 98 01 00 00       	jmp    102aac <__alltraps>

00102914 <vector222>:
.globl vector222
vector222:
  pushl $0
  102914:	6a 00                	push   $0x0
  pushl $222
  102916:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10291b:	e9 8c 01 00 00       	jmp    102aac <__alltraps>

00102920 <vector223>:
.globl vector223
vector223:
  pushl $0
  102920:	6a 00                	push   $0x0
  pushl $223
  102922:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102927:	e9 80 01 00 00       	jmp    102aac <__alltraps>

0010292c <vector224>:
.globl vector224
vector224:
  pushl $0
  10292c:	6a 00                	push   $0x0
  pushl $224
  10292e:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102933:	e9 74 01 00 00       	jmp    102aac <__alltraps>

00102938 <vector225>:
.globl vector225
vector225:
  pushl $0
  102938:	6a 00                	push   $0x0
  pushl $225
  10293a:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10293f:	e9 68 01 00 00       	jmp    102aac <__alltraps>

00102944 <vector226>:
.globl vector226
vector226:
  pushl $0
  102944:	6a 00                	push   $0x0
  pushl $226
  102946:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10294b:	e9 5c 01 00 00       	jmp    102aac <__alltraps>

00102950 <vector227>:
.globl vector227
vector227:
  pushl $0
  102950:	6a 00                	push   $0x0
  pushl $227
  102952:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102957:	e9 50 01 00 00       	jmp    102aac <__alltraps>

0010295c <vector228>:
.globl vector228
vector228:
  pushl $0
  10295c:	6a 00                	push   $0x0
  pushl $228
  10295e:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102963:	e9 44 01 00 00       	jmp    102aac <__alltraps>

00102968 <vector229>:
.globl vector229
vector229:
  pushl $0
  102968:	6a 00                	push   $0x0
  pushl $229
  10296a:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10296f:	e9 38 01 00 00       	jmp    102aac <__alltraps>

00102974 <vector230>:
.globl vector230
vector230:
  pushl $0
  102974:	6a 00                	push   $0x0
  pushl $230
  102976:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10297b:	e9 2c 01 00 00       	jmp    102aac <__alltraps>

00102980 <vector231>:
.globl vector231
vector231:
  pushl $0
  102980:	6a 00                	push   $0x0
  pushl $231
  102982:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102987:	e9 20 01 00 00       	jmp    102aac <__alltraps>

0010298c <vector232>:
.globl vector232
vector232:
  pushl $0
  10298c:	6a 00                	push   $0x0
  pushl $232
  10298e:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102993:	e9 14 01 00 00       	jmp    102aac <__alltraps>

00102998 <vector233>:
.globl vector233
vector233:
  pushl $0
  102998:	6a 00                	push   $0x0
  pushl $233
  10299a:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10299f:	e9 08 01 00 00       	jmp    102aac <__alltraps>

001029a4 <vector234>:
.globl vector234
vector234:
  pushl $0
  1029a4:	6a 00                	push   $0x0
  pushl $234
  1029a6:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1029ab:	e9 fc 00 00 00       	jmp    102aac <__alltraps>

001029b0 <vector235>:
.globl vector235
vector235:
  pushl $0
  1029b0:	6a 00                	push   $0x0
  pushl $235
  1029b2:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1029b7:	e9 f0 00 00 00       	jmp    102aac <__alltraps>

001029bc <vector236>:
.globl vector236
vector236:
  pushl $0
  1029bc:	6a 00                	push   $0x0
  pushl $236
  1029be:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1029c3:	e9 e4 00 00 00       	jmp    102aac <__alltraps>

001029c8 <vector237>:
.globl vector237
vector237:
  pushl $0
  1029c8:	6a 00                	push   $0x0
  pushl $237
  1029ca:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1029cf:	e9 d8 00 00 00       	jmp    102aac <__alltraps>

001029d4 <vector238>:
.globl vector238
vector238:
  pushl $0
  1029d4:	6a 00                	push   $0x0
  pushl $238
  1029d6:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1029db:	e9 cc 00 00 00       	jmp    102aac <__alltraps>

001029e0 <vector239>:
.globl vector239
vector239:
  pushl $0
  1029e0:	6a 00                	push   $0x0
  pushl $239
  1029e2:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1029e7:	e9 c0 00 00 00       	jmp    102aac <__alltraps>

001029ec <vector240>:
.globl vector240
vector240:
  pushl $0
  1029ec:	6a 00                	push   $0x0
  pushl $240
  1029ee:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1029f3:	e9 b4 00 00 00       	jmp    102aac <__alltraps>

001029f8 <vector241>:
.globl vector241
vector241:
  pushl $0
  1029f8:	6a 00                	push   $0x0
  pushl $241
  1029fa:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1029ff:	e9 a8 00 00 00       	jmp    102aac <__alltraps>

00102a04 <vector242>:
.globl vector242
vector242:
  pushl $0
  102a04:	6a 00                	push   $0x0
  pushl $242
  102a06:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102a0b:	e9 9c 00 00 00       	jmp    102aac <__alltraps>

00102a10 <vector243>:
.globl vector243
vector243:
  pushl $0
  102a10:	6a 00                	push   $0x0
  pushl $243
  102a12:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102a17:	e9 90 00 00 00       	jmp    102aac <__alltraps>

00102a1c <vector244>:
.globl vector244
vector244:
  pushl $0
  102a1c:	6a 00                	push   $0x0
  pushl $244
  102a1e:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102a23:	e9 84 00 00 00       	jmp    102aac <__alltraps>

00102a28 <vector245>:
.globl vector245
vector245:
  pushl $0
  102a28:	6a 00                	push   $0x0
  pushl $245
  102a2a:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102a2f:	e9 78 00 00 00       	jmp    102aac <__alltraps>

00102a34 <vector246>:
.globl vector246
vector246:
  pushl $0
  102a34:	6a 00                	push   $0x0
  pushl $246
  102a36:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102a3b:	e9 6c 00 00 00       	jmp    102aac <__alltraps>

00102a40 <vector247>:
.globl vector247
vector247:
  pushl $0
  102a40:	6a 00                	push   $0x0
  pushl $247
  102a42:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102a47:	e9 60 00 00 00       	jmp    102aac <__alltraps>

00102a4c <vector248>:
.globl vector248
vector248:
  pushl $0
  102a4c:	6a 00                	push   $0x0
  pushl $248
  102a4e:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102a53:	e9 54 00 00 00       	jmp    102aac <__alltraps>

00102a58 <vector249>:
.globl vector249
vector249:
  pushl $0
  102a58:	6a 00                	push   $0x0
  pushl $249
  102a5a:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102a5f:	e9 48 00 00 00       	jmp    102aac <__alltraps>

00102a64 <vector250>:
.globl vector250
vector250:
  pushl $0
  102a64:	6a 00                	push   $0x0
  pushl $250
  102a66:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102a6b:	e9 3c 00 00 00       	jmp    102aac <__alltraps>

00102a70 <vector251>:
.globl vector251
vector251:
  pushl $0
  102a70:	6a 00                	push   $0x0
  pushl $251
  102a72:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102a77:	e9 30 00 00 00       	jmp    102aac <__alltraps>

00102a7c <vector252>:
.globl vector252
vector252:
  pushl $0
  102a7c:	6a 00                	push   $0x0
  pushl $252
  102a7e:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102a83:	e9 24 00 00 00       	jmp    102aac <__alltraps>

00102a88 <vector253>:
.globl vector253
vector253:
  pushl $0
  102a88:	6a 00                	push   $0x0
  pushl $253
  102a8a:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102a8f:	e9 18 00 00 00       	jmp    102aac <__alltraps>

00102a94 <vector254>:
.globl vector254
vector254:
  pushl $0
  102a94:	6a 00                	push   $0x0
  pushl $254
  102a96:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102a9b:	e9 0c 00 00 00       	jmp    102aac <__alltraps>

00102aa0 <vector255>:
.globl vector255
vector255:
  pushl $0
  102aa0:	6a 00                	push   $0x0
  pushl $255
  102aa2:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102aa7:	e9 00 00 00 00       	jmp    102aac <__alltraps>

00102aac <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102aac:	1e                   	push   %ds
    pushl %es
  102aad:	06                   	push   %es
    pushl %fs
  102aae:	0f a0                	push   %fs
    pushl %gs
  102ab0:	0f a8                	push   %gs
    pushal
  102ab2:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102ab3:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102ab8:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102aba:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102abc:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102abd:	e8 60 f5 ff ff       	call   102022 <trap>

    # pop the pushed stack pointer
    popl %esp
  102ac2:	5c                   	pop    %esp

00102ac3 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102ac3:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102ac4:	0f a9                	pop    %gs
    popl %fs
  102ac6:	0f a1                	pop    %fs
    popl %es
  102ac8:	07                   	pop    %es
    popl %ds
  102ac9:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102aca:	83 c4 08             	add    $0x8,%esp
    iret
  102acd:	cf                   	iret   

00102ace <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102ace:	55                   	push   %ebp
  102acf:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad4:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102ad7:	b8 23 00 00 00       	mov    $0x23,%eax
  102adc:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102ade:	b8 23 00 00 00       	mov    $0x23,%eax
  102ae3:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102ae5:	b8 10 00 00 00       	mov    $0x10,%eax
  102aea:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102aec:	b8 10 00 00 00       	mov    $0x10,%eax
  102af1:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102af3:	b8 10 00 00 00       	mov    $0x10,%eax
  102af8:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102afa:	ea 01 2b 10 00 08 00 	ljmp   $0x8,$0x102b01
}
  102b01:	90                   	nop
  102b02:	5d                   	pop    %ebp
  102b03:	c3                   	ret    

00102b04 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102b04:	f3 0f 1e fb          	endbr32 
  102b08:	55                   	push   %ebp
  102b09:	89 e5                	mov    %esp,%ebp
  102b0b:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102b0e:	b8 20 19 11 00       	mov    $0x111920,%eax
  102b13:	05 00 04 00 00       	add    $0x400,%eax
  102b18:	a3 a4 18 11 00       	mov    %eax,0x1118a4
    ts.ts_ss0 = KERNEL_DS;
  102b1d:	66 c7 05 a8 18 11 00 	movw   $0x10,0x1118a8
  102b24:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102b26:	66 c7 05 08 0a 11 00 	movw   $0x68,0x110a08
  102b2d:	68 00 
  102b2f:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102b34:	0f b7 c0             	movzwl %ax,%eax
  102b37:	66 a3 0a 0a 11 00    	mov    %ax,0x110a0a
  102b3d:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102b42:	c1 e8 10             	shr    $0x10,%eax
  102b45:	a2 0c 0a 11 00       	mov    %al,0x110a0c
  102b4a:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b51:	24 f0                	and    $0xf0,%al
  102b53:	0c 09                	or     $0x9,%al
  102b55:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102b5a:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b61:	0c 10                	or     $0x10,%al
  102b63:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102b68:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b6f:	24 9f                	and    $0x9f,%al
  102b71:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102b76:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b7d:	0c 80                	or     $0x80,%al
  102b7f:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102b84:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102b8b:	24 f0                	and    $0xf0,%al
  102b8d:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102b92:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102b99:	24 ef                	and    $0xef,%al
  102b9b:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102ba0:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102ba7:	24 df                	and    $0xdf,%al
  102ba9:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102bae:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102bb5:	0c 40                	or     $0x40,%al
  102bb7:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102bbc:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102bc3:	24 7f                	and    $0x7f,%al
  102bc5:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102bca:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102bcf:	c1 e8 18             	shr    $0x18,%eax
  102bd2:	a2 0f 0a 11 00       	mov    %al,0x110a0f
    gdt[SEG_TSS].sd_s = 0;
  102bd7:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102bde:	24 ef                	and    $0xef,%al
  102be0:	a2 0d 0a 11 00       	mov    %al,0x110a0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102be5:	c7 04 24 10 0a 11 00 	movl   $0x110a10,(%esp)
  102bec:	e8 dd fe ff ff       	call   102ace <lgdt>
  102bf1:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102bf7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102bfb:	0f 00 d8             	ltr    %ax
}
  102bfe:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102bff:	90                   	nop
  102c00:	c9                   	leave  
  102c01:	c3                   	ret    

00102c02 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102c02:	f3 0f 1e fb          	endbr32 
  102c06:	55                   	push   %ebp
  102c07:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102c09:	e8 f6 fe ff ff       	call   102b04 <gdt_init>
}
  102c0e:	90                   	nop
  102c0f:	5d                   	pop    %ebp
  102c10:	c3                   	ret    

00102c11 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102c11:	f3 0f 1e fb          	endbr32 
  102c15:	55                   	push   %ebp
  102c16:	89 e5                	mov    %esp,%ebp
  102c18:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102c1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102c22:	eb 03                	jmp    102c27 <strlen+0x16>
        cnt ++;
  102c24:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102c27:	8b 45 08             	mov    0x8(%ebp),%eax
  102c2a:	8d 50 01             	lea    0x1(%eax),%edx
  102c2d:	89 55 08             	mov    %edx,0x8(%ebp)
  102c30:	0f b6 00             	movzbl (%eax),%eax
  102c33:	84 c0                	test   %al,%al
  102c35:	75 ed                	jne    102c24 <strlen+0x13>
    }
    return cnt;
  102c37:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102c3a:	c9                   	leave  
  102c3b:	c3                   	ret    

00102c3c <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102c3c:	f3 0f 1e fb          	endbr32 
  102c40:	55                   	push   %ebp
  102c41:	89 e5                	mov    %esp,%ebp
  102c43:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102c46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c4d:	eb 03                	jmp    102c52 <strnlen+0x16>
        cnt ++;
  102c4f:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c55:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102c58:	73 10                	jae    102c6a <strnlen+0x2e>
  102c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  102c5d:	8d 50 01             	lea    0x1(%eax),%edx
  102c60:	89 55 08             	mov    %edx,0x8(%ebp)
  102c63:	0f b6 00             	movzbl (%eax),%eax
  102c66:	84 c0                	test   %al,%al
  102c68:	75 e5                	jne    102c4f <strnlen+0x13>
    }
    return cnt;
  102c6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102c6d:	c9                   	leave  
  102c6e:	c3                   	ret    

00102c6f <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102c6f:	f3 0f 1e fb          	endbr32 
  102c73:	55                   	push   %ebp
  102c74:	89 e5                	mov    %esp,%ebp
  102c76:	57                   	push   %edi
  102c77:	56                   	push   %esi
  102c78:	83 ec 20             	sub    $0x20,%esp
  102c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c81:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c84:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102c87:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c8d:	89 d1                	mov    %edx,%ecx
  102c8f:	89 c2                	mov    %eax,%edx
  102c91:	89 ce                	mov    %ecx,%esi
  102c93:	89 d7                	mov    %edx,%edi
  102c95:	ac                   	lods   %ds:(%esi),%al
  102c96:	aa                   	stos   %al,%es:(%edi)
  102c97:	84 c0                	test   %al,%al
  102c99:	75 fa                	jne    102c95 <strcpy+0x26>
  102c9b:	89 fa                	mov    %edi,%edx
  102c9d:	89 f1                	mov    %esi,%ecx
  102c9f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102ca2:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102ca5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102cab:	83 c4 20             	add    $0x20,%esp
  102cae:	5e                   	pop    %esi
  102caf:	5f                   	pop    %edi
  102cb0:	5d                   	pop    %ebp
  102cb1:	c3                   	ret    

00102cb2 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102cb2:	f3 0f 1e fb          	endbr32 
  102cb6:	55                   	push   %ebp
  102cb7:	89 e5                	mov    %esp,%ebp
  102cb9:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  102cbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102cc2:	eb 1e                	jmp    102ce2 <strncpy+0x30>
        if ((*p = *src) != '\0') {
  102cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cc7:	0f b6 10             	movzbl (%eax),%edx
  102cca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ccd:	88 10                	mov    %dl,(%eax)
  102ccf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102cd2:	0f b6 00             	movzbl (%eax),%eax
  102cd5:	84 c0                	test   %al,%al
  102cd7:	74 03                	je     102cdc <strncpy+0x2a>
            src ++;
  102cd9:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102cdc:	ff 45 fc             	incl   -0x4(%ebp)
  102cdf:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  102ce2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ce6:	75 dc                	jne    102cc4 <strncpy+0x12>
    }
    return dst;
  102ce8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102ceb:	c9                   	leave  
  102cec:	c3                   	ret    

00102ced <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102ced:	f3 0f 1e fb          	endbr32 
  102cf1:	55                   	push   %ebp
  102cf2:	89 e5                	mov    %esp,%ebp
  102cf4:	57                   	push   %edi
  102cf5:	56                   	push   %esi
  102cf6:	83 ec 20             	sub    $0x20,%esp
  102cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  102cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102cff:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d02:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102d05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d0b:	89 d1                	mov    %edx,%ecx
  102d0d:	89 c2                	mov    %eax,%edx
  102d0f:	89 ce                	mov    %ecx,%esi
  102d11:	89 d7                	mov    %edx,%edi
  102d13:	ac                   	lods   %ds:(%esi),%al
  102d14:	ae                   	scas   %es:(%edi),%al
  102d15:	75 08                	jne    102d1f <strcmp+0x32>
  102d17:	84 c0                	test   %al,%al
  102d19:	75 f8                	jne    102d13 <strcmp+0x26>
  102d1b:	31 c0                	xor    %eax,%eax
  102d1d:	eb 04                	jmp    102d23 <strcmp+0x36>
  102d1f:	19 c0                	sbb    %eax,%eax
  102d21:	0c 01                	or     $0x1,%al
  102d23:	89 fa                	mov    %edi,%edx
  102d25:	89 f1                	mov    %esi,%ecx
  102d27:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102d2a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102d2d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102d33:	83 c4 20             	add    $0x20,%esp
  102d36:	5e                   	pop    %esi
  102d37:	5f                   	pop    %edi
  102d38:	5d                   	pop    %ebp
  102d39:	c3                   	ret    

00102d3a <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102d3a:	f3 0f 1e fb          	endbr32 
  102d3e:	55                   	push   %ebp
  102d3f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d41:	eb 09                	jmp    102d4c <strncmp+0x12>
        n --, s1 ++, s2 ++;
  102d43:	ff 4d 10             	decl   0x10(%ebp)
  102d46:	ff 45 08             	incl   0x8(%ebp)
  102d49:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d50:	74 1a                	je     102d6c <strncmp+0x32>
  102d52:	8b 45 08             	mov    0x8(%ebp),%eax
  102d55:	0f b6 00             	movzbl (%eax),%eax
  102d58:	84 c0                	test   %al,%al
  102d5a:	74 10                	je     102d6c <strncmp+0x32>
  102d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5f:	0f b6 10             	movzbl (%eax),%edx
  102d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d65:	0f b6 00             	movzbl (%eax),%eax
  102d68:	38 c2                	cmp    %al,%dl
  102d6a:	74 d7                	je     102d43 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102d6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d70:	74 18                	je     102d8a <strncmp+0x50>
  102d72:	8b 45 08             	mov    0x8(%ebp),%eax
  102d75:	0f b6 00             	movzbl (%eax),%eax
  102d78:	0f b6 d0             	movzbl %al,%edx
  102d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d7e:	0f b6 00             	movzbl (%eax),%eax
  102d81:	0f b6 c0             	movzbl %al,%eax
  102d84:	29 c2                	sub    %eax,%edx
  102d86:	89 d0                	mov    %edx,%eax
  102d88:	eb 05                	jmp    102d8f <strncmp+0x55>
  102d8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102d8f:	5d                   	pop    %ebp
  102d90:	c3                   	ret    

00102d91 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102d91:	f3 0f 1e fb          	endbr32 
  102d95:	55                   	push   %ebp
  102d96:	89 e5                	mov    %esp,%ebp
  102d98:	83 ec 04             	sub    $0x4,%esp
  102d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d9e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102da1:	eb 13                	jmp    102db6 <strchr+0x25>
        if (*s == c) {
  102da3:	8b 45 08             	mov    0x8(%ebp),%eax
  102da6:	0f b6 00             	movzbl (%eax),%eax
  102da9:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102dac:	75 05                	jne    102db3 <strchr+0x22>
            return (char *)s;
  102dae:	8b 45 08             	mov    0x8(%ebp),%eax
  102db1:	eb 12                	jmp    102dc5 <strchr+0x34>
        }
        s ++;
  102db3:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102db6:	8b 45 08             	mov    0x8(%ebp),%eax
  102db9:	0f b6 00             	movzbl (%eax),%eax
  102dbc:	84 c0                	test   %al,%al
  102dbe:	75 e3                	jne    102da3 <strchr+0x12>
    }
    return NULL;
  102dc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102dc5:	c9                   	leave  
  102dc6:	c3                   	ret    

00102dc7 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102dc7:	f3 0f 1e fb          	endbr32 
  102dcb:	55                   	push   %ebp
  102dcc:	89 e5                	mov    %esp,%ebp
  102dce:	83 ec 04             	sub    $0x4,%esp
  102dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dd4:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102dd7:	eb 0e                	jmp    102de7 <strfind+0x20>
        if (*s == c) {
  102dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  102ddc:	0f b6 00             	movzbl (%eax),%eax
  102ddf:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102de2:	74 0f                	je     102df3 <strfind+0x2c>
            break;
        }
        s ++;
  102de4:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102de7:	8b 45 08             	mov    0x8(%ebp),%eax
  102dea:	0f b6 00             	movzbl (%eax),%eax
  102ded:	84 c0                	test   %al,%al
  102def:	75 e8                	jne    102dd9 <strfind+0x12>
  102df1:	eb 01                	jmp    102df4 <strfind+0x2d>
            break;
  102df3:	90                   	nop
    }
    return (char *)s;
  102df4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102df7:	c9                   	leave  
  102df8:	c3                   	ret    

00102df9 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102df9:	f3 0f 1e fb          	endbr32 
  102dfd:	55                   	push   %ebp
  102dfe:	89 e5                	mov    %esp,%ebp
  102e00:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102e03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102e0a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102e11:	eb 03                	jmp    102e16 <strtol+0x1d>
        s ++;
  102e13:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102e16:	8b 45 08             	mov    0x8(%ebp),%eax
  102e19:	0f b6 00             	movzbl (%eax),%eax
  102e1c:	3c 20                	cmp    $0x20,%al
  102e1e:	74 f3                	je     102e13 <strtol+0x1a>
  102e20:	8b 45 08             	mov    0x8(%ebp),%eax
  102e23:	0f b6 00             	movzbl (%eax),%eax
  102e26:	3c 09                	cmp    $0x9,%al
  102e28:	74 e9                	je     102e13 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  102e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e2d:	0f b6 00             	movzbl (%eax),%eax
  102e30:	3c 2b                	cmp    $0x2b,%al
  102e32:	75 05                	jne    102e39 <strtol+0x40>
        s ++;
  102e34:	ff 45 08             	incl   0x8(%ebp)
  102e37:	eb 14                	jmp    102e4d <strtol+0x54>
    }
    else if (*s == '-') {
  102e39:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3c:	0f b6 00             	movzbl (%eax),%eax
  102e3f:	3c 2d                	cmp    $0x2d,%al
  102e41:	75 0a                	jne    102e4d <strtol+0x54>
        s ++, neg = 1;
  102e43:	ff 45 08             	incl   0x8(%ebp)
  102e46:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102e4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e51:	74 06                	je     102e59 <strtol+0x60>
  102e53:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102e57:	75 22                	jne    102e7b <strtol+0x82>
  102e59:	8b 45 08             	mov    0x8(%ebp),%eax
  102e5c:	0f b6 00             	movzbl (%eax),%eax
  102e5f:	3c 30                	cmp    $0x30,%al
  102e61:	75 18                	jne    102e7b <strtol+0x82>
  102e63:	8b 45 08             	mov    0x8(%ebp),%eax
  102e66:	40                   	inc    %eax
  102e67:	0f b6 00             	movzbl (%eax),%eax
  102e6a:	3c 78                	cmp    $0x78,%al
  102e6c:	75 0d                	jne    102e7b <strtol+0x82>
        s += 2, base = 16;
  102e6e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102e72:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102e79:	eb 29                	jmp    102ea4 <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  102e7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e7f:	75 16                	jne    102e97 <strtol+0x9e>
  102e81:	8b 45 08             	mov    0x8(%ebp),%eax
  102e84:	0f b6 00             	movzbl (%eax),%eax
  102e87:	3c 30                	cmp    $0x30,%al
  102e89:	75 0c                	jne    102e97 <strtol+0x9e>
        s ++, base = 8;
  102e8b:	ff 45 08             	incl   0x8(%ebp)
  102e8e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102e95:	eb 0d                	jmp    102ea4 <strtol+0xab>
    }
    else if (base == 0) {
  102e97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e9b:	75 07                	jne    102ea4 <strtol+0xab>
        base = 10;
  102e9d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea7:	0f b6 00             	movzbl (%eax),%eax
  102eaa:	3c 2f                	cmp    $0x2f,%al
  102eac:	7e 1b                	jle    102ec9 <strtol+0xd0>
  102eae:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb1:	0f b6 00             	movzbl (%eax),%eax
  102eb4:	3c 39                	cmp    $0x39,%al
  102eb6:	7f 11                	jg     102ec9 <strtol+0xd0>
            dig = *s - '0';
  102eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  102ebb:	0f b6 00             	movzbl (%eax),%eax
  102ebe:	0f be c0             	movsbl %al,%eax
  102ec1:	83 e8 30             	sub    $0x30,%eax
  102ec4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ec7:	eb 48                	jmp    102f11 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  102ecc:	0f b6 00             	movzbl (%eax),%eax
  102ecf:	3c 60                	cmp    $0x60,%al
  102ed1:	7e 1b                	jle    102eee <strtol+0xf5>
  102ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed6:	0f b6 00             	movzbl (%eax),%eax
  102ed9:	3c 7a                	cmp    $0x7a,%al
  102edb:	7f 11                	jg     102eee <strtol+0xf5>
            dig = *s - 'a' + 10;
  102edd:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee0:	0f b6 00             	movzbl (%eax),%eax
  102ee3:	0f be c0             	movsbl %al,%eax
  102ee6:	83 e8 57             	sub    $0x57,%eax
  102ee9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102eec:	eb 23                	jmp    102f11 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102eee:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef1:	0f b6 00             	movzbl (%eax),%eax
  102ef4:	3c 40                	cmp    $0x40,%al
  102ef6:	7e 3b                	jle    102f33 <strtol+0x13a>
  102ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  102efb:	0f b6 00             	movzbl (%eax),%eax
  102efe:	3c 5a                	cmp    $0x5a,%al
  102f00:	7f 31                	jg     102f33 <strtol+0x13a>
            dig = *s - 'A' + 10;
  102f02:	8b 45 08             	mov    0x8(%ebp),%eax
  102f05:	0f b6 00             	movzbl (%eax),%eax
  102f08:	0f be c0             	movsbl %al,%eax
  102f0b:	83 e8 37             	sub    $0x37,%eax
  102f0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f14:	3b 45 10             	cmp    0x10(%ebp),%eax
  102f17:	7d 19                	jge    102f32 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  102f19:	ff 45 08             	incl   0x8(%ebp)
  102f1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f1f:	0f af 45 10          	imul   0x10(%ebp),%eax
  102f23:	89 c2                	mov    %eax,%edx
  102f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f28:	01 d0                	add    %edx,%eax
  102f2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102f2d:	e9 72 ff ff ff       	jmp    102ea4 <strtol+0xab>
            break;
  102f32:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102f33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f37:	74 08                	je     102f41 <strtol+0x148>
        *endptr = (char *) s;
  102f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f3c:	8b 55 08             	mov    0x8(%ebp),%edx
  102f3f:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102f41:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102f45:	74 07                	je     102f4e <strtol+0x155>
  102f47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f4a:	f7 d8                	neg    %eax
  102f4c:	eb 03                	jmp    102f51 <strtol+0x158>
  102f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102f51:	c9                   	leave  
  102f52:	c3                   	ret    

00102f53 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102f53:	f3 0f 1e fb          	endbr32 
  102f57:	55                   	push   %ebp
  102f58:	89 e5                	mov    %esp,%ebp
  102f5a:	57                   	push   %edi
  102f5b:	83 ec 24             	sub    $0x24,%esp
  102f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f61:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102f64:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  102f68:	8b 45 08             	mov    0x8(%ebp),%eax
  102f6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  102f6e:	88 55 f7             	mov    %dl,-0x9(%ebp)
  102f71:	8b 45 10             	mov    0x10(%ebp),%eax
  102f74:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102f77:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102f7a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102f7e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102f81:	89 d7                	mov    %edx,%edi
  102f83:	f3 aa                	rep stos %al,%es:(%edi)
  102f85:	89 fa                	mov    %edi,%edx
  102f87:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102f8a:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102f8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102f90:	83 c4 24             	add    $0x24,%esp
  102f93:	5f                   	pop    %edi
  102f94:	5d                   	pop    %ebp
  102f95:	c3                   	ret    

00102f96 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102f96:	f3 0f 1e fb          	endbr32 
  102f9a:	55                   	push   %ebp
  102f9b:	89 e5                	mov    %esp,%ebp
  102f9d:	57                   	push   %edi
  102f9e:	56                   	push   %esi
  102f9f:	53                   	push   %ebx
  102fa0:	83 ec 30             	sub    $0x30,%esp
  102fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  102fa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102faf:	8b 45 10             	mov    0x10(%ebp),%eax
  102fb2:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fb8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102fbb:	73 42                	jae    102fff <memmove+0x69>
  102fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102fc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102fc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fcc:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102fcf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102fd2:	c1 e8 02             	shr    $0x2,%eax
  102fd5:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102fd7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102fda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fdd:	89 d7                	mov    %edx,%edi
  102fdf:	89 c6                	mov    %eax,%esi
  102fe1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102fe3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102fe6:	83 e1 03             	and    $0x3,%ecx
  102fe9:	74 02                	je     102fed <memmove+0x57>
  102feb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102fed:	89 f0                	mov    %esi,%eax
  102fef:	89 fa                	mov    %edi,%edx
  102ff1:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102ff4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102ff7:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102ffa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  102ffd:	eb 36                	jmp    103035 <memmove+0x9f>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102fff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103002:	8d 50 ff             	lea    -0x1(%eax),%edx
  103005:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103008:	01 c2                	add    %eax,%edx
  10300a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10300d:	8d 48 ff             	lea    -0x1(%eax),%ecx
  103010:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103013:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  103016:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103019:	89 c1                	mov    %eax,%ecx
  10301b:	89 d8                	mov    %ebx,%eax
  10301d:	89 d6                	mov    %edx,%esi
  10301f:	89 c7                	mov    %eax,%edi
  103021:	fd                   	std    
  103022:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103024:	fc                   	cld    
  103025:	89 f8                	mov    %edi,%eax
  103027:	89 f2                	mov    %esi,%edx
  103029:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  10302c:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10302f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  103032:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  103035:	83 c4 30             	add    $0x30,%esp
  103038:	5b                   	pop    %ebx
  103039:	5e                   	pop    %esi
  10303a:	5f                   	pop    %edi
  10303b:	5d                   	pop    %ebp
  10303c:	c3                   	ret    

0010303d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10303d:	f3 0f 1e fb          	endbr32 
  103041:	55                   	push   %ebp
  103042:	89 e5                	mov    %esp,%ebp
  103044:	57                   	push   %edi
  103045:	56                   	push   %esi
  103046:	83 ec 20             	sub    $0x20,%esp
  103049:	8b 45 08             	mov    0x8(%ebp),%eax
  10304c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10304f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103052:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103055:	8b 45 10             	mov    0x10(%ebp),%eax
  103058:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10305b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10305e:	c1 e8 02             	shr    $0x2,%eax
  103061:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103063:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103066:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103069:	89 d7                	mov    %edx,%edi
  10306b:	89 c6                	mov    %eax,%esi
  10306d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10306f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103072:	83 e1 03             	and    $0x3,%ecx
  103075:	74 02                	je     103079 <memcpy+0x3c>
  103077:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103079:	89 f0                	mov    %esi,%eax
  10307b:	89 fa                	mov    %edi,%edx
  10307d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103080:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103083:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  103086:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103089:	83 c4 20             	add    $0x20,%esp
  10308c:	5e                   	pop    %esi
  10308d:	5f                   	pop    %edi
  10308e:	5d                   	pop    %ebp
  10308f:	c3                   	ret    

00103090 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103090:	f3 0f 1e fb          	endbr32 
  103094:	55                   	push   %ebp
  103095:	89 e5                	mov    %esp,%ebp
  103097:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10309a:	8b 45 08             	mov    0x8(%ebp),%eax
  10309d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1030a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1030a6:	eb 2e                	jmp    1030d6 <memcmp+0x46>
        if (*s1 != *s2) {
  1030a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030ab:	0f b6 10             	movzbl (%eax),%edx
  1030ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1030b1:	0f b6 00             	movzbl (%eax),%eax
  1030b4:	38 c2                	cmp    %al,%dl
  1030b6:	74 18                	je     1030d0 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1030b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030bb:	0f b6 00             	movzbl (%eax),%eax
  1030be:	0f b6 d0             	movzbl %al,%edx
  1030c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1030c4:	0f b6 00             	movzbl (%eax),%eax
  1030c7:	0f b6 c0             	movzbl %al,%eax
  1030ca:	29 c2                	sub    %eax,%edx
  1030cc:	89 d0                	mov    %edx,%eax
  1030ce:	eb 18                	jmp    1030e8 <memcmp+0x58>
        }
        s1 ++, s2 ++;
  1030d0:	ff 45 fc             	incl   -0x4(%ebp)
  1030d3:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  1030d6:	8b 45 10             	mov    0x10(%ebp),%eax
  1030d9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1030dc:	89 55 10             	mov    %edx,0x10(%ebp)
  1030df:	85 c0                	test   %eax,%eax
  1030e1:	75 c5                	jne    1030a8 <memcmp+0x18>
    }
    return 0;
  1030e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1030e8:	c9                   	leave  
  1030e9:	c3                   	ret    

001030ea <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1030ea:	f3 0f 1e fb          	endbr32 
  1030ee:	55                   	push   %ebp
  1030ef:	89 e5                	mov    %esp,%ebp
  1030f1:	83 ec 58             	sub    $0x58,%esp
  1030f4:	8b 45 10             	mov    0x10(%ebp),%eax
  1030f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1030fa:	8b 45 14             	mov    0x14(%ebp),%eax
  1030fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  103100:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103103:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103106:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103109:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10310c:	8b 45 18             	mov    0x18(%ebp),%eax
  10310f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103112:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103115:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103118:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10311b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10311e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103121:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103124:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103128:	74 1c                	je     103146 <printnum+0x5c>
  10312a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10312d:	ba 00 00 00 00       	mov    $0x0,%edx
  103132:	f7 75 e4             	divl   -0x1c(%ebp)
  103135:	89 55 f4             	mov    %edx,-0xc(%ebp)
  103138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10313b:	ba 00 00 00 00       	mov    $0x0,%edx
  103140:	f7 75 e4             	divl   -0x1c(%ebp)
  103143:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103146:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10314c:	f7 75 e4             	divl   -0x1c(%ebp)
  10314f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103152:	89 55 dc             	mov    %edx,-0x24(%ebp)
  103155:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103158:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10315b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10315e:	89 55 ec             	mov    %edx,-0x14(%ebp)
  103161:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103164:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  103167:	8b 45 18             	mov    0x18(%ebp),%eax
  10316a:	ba 00 00 00 00       	mov    $0x0,%edx
  10316f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  103172:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103175:	19 d1                	sbb    %edx,%ecx
  103177:	72 4c                	jb     1031c5 <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  103179:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10317c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10317f:	8b 45 20             	mov    0x20(%ebp),%eax
  103182:	89 44 24 18          	mov    %eax,0x18(%esp)
  103186:	89 54 24 14          	mov    %edx,0x14(%esp)
  10318a:	8b 45 18             	mov    0x18(%ebp),%eax
  10318d:	89 44 24 10          	mov    %eax,0x10(%esp)
  103191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103194:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103197:	89 44 24 08          	mov    %eax,0x8(%esp)
  10319b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10319f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a9:	89 04 24             	mov    %eax,(%esp)
  1031ac:	e8 39 ff ff ff       	call   1030ea <printnum>
  1031b1:	eb 1b                	jmp    1031ce <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1031b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031ba:	8b 45 20             	mov    0x20(%ebp),%eax
  1031bd:	89 04 24             	mov    %eax,(%esp)
  1031c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1031c3:	ff d0                	call   *%eax
        while (-- width > 0)
  1031c5:	ff 4d 1c             	decl   0x1c(%ebp)
  1031c8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1031cc:	7f e5                	jg     1031b3 <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1031ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1031d1:	05 30 3f 10 00       	add    $0x103f30,%eax
  1031d6:	0f b6 00             	movzbl (%eax),%eax
  1031d9:	0f be c0             	movsbl %al,%eax
  1031dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  1031df:	89 54 24 04          	mov    %edx,0x4(%esp)
  1031e3:	89 04 24             	mov    %eax,(%esp)
  1031e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e9:	ff d0                	call   *%eax
}
  1031eb:	90                   	nop
  1031ec:	c9                   	leave  
  1031ed:	c3                   	ret    

001031ee <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1031ee:	f3 0f 1e fb          	endbr32 
  1031f2:	55                   	push   %ebp
  1031f3:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1031f5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1031f9:	7e 14                	jle    10320f <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  1031fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1031fe:	8b 00                	mov    (%eax),%eax
  103200:	8d 48 08             	lea    0x8(%eax),%ecx
  103203:	8b 55 08             	mov    0x8(%ebp),%edx
  103206:	89 0a                	mov    %ecx,(%edx)
  103208:	8b 50 04             	mov    0x4(%eax),%edx
  10320b:	8b 00                	mov    (%eax),%eax
  10320d:	eb 30                	jmp    10323f <getuint+0x51>
    }
    else if (lflag) {
  10320f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103213:	74 16                	je     10322b <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  103215:	8b 45 08             	mov    0x8(%ebp),%eax
  103218:	8b 00                	mov    (%eax),%eax
  10321a:	8d 48 04             	lea    0x4(%eax),%ecx
  10321d:	8b 55 08             	mov    0x8(%ebp),%edx
  103220:	89 0a                	mov    %ecx,(%edx)
  103222:	8b 00                	mov    (%eax),%eax
  103224:	ba 00 00 00 00       	mov    $0x0,%edx
  103229:	eb 14                	jmp    10323f <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  10322b:	8b 45 08             	mov    0x8(%ebp),%eax
  10322e:	8b 00                	mov    (%eax),%eax
  103230:	8d 48 04             	lea    0x4(%eax),%ecx
  103233:	8b 55 08             	mov    0x8(%ebp),%edx
  103236:	89 0a                	mov    %ecx,(%edx)
  103238:	8b 00                	mov    (%eax),%eax
  10323a:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10323f:	5d                   	pop    %ebp
  103240:	c3                   	ret    

00103241 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  103241:	f3 0f 1e fb          	endbr32 
  103245:	55                   	push   %ebp
  103246:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103248:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10324c:	7e 14                	jle    103262 <getint+0x21>
        return va_arg(*ap, long long);
  10324e:	8b 45 08             	mov    0x8(%ebp),%eax
  103251:	8b 00                	mov    (%eax),%eax
  103253:	8d 48 08             	lea    0x8(%eax),%ecx
  103256:	8b 55 08             	mov    0x8(%ebp),%edx
  103259:	89 0a                	mov    %ecx,(%edx)
  10325b:	8b 50 04             	mov    0x4(%eax),%edx
  10325e:	8b 00                	mov    (%eax),%eax
  103260:	eb 28                	jmp    10328a <getint+0x49>
    }
    else if (lflag) {
  103262:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103266:	74 12                	je     10327a <getint+0x39>
        return va_arg(*ap, long);
  103268:	8b 45 08             	mov    0x8(%ebp),%eax
  10326b:	8b 00                	mov    (%eax),%eax
  10326d:	8d 48 04             	lea    0x4(%eax),%ecx
  103270:	8b 55 08             	mov    0x8(%ebp),%edx
  103273:	89 0a                	mov    %ecx,(%edx)
  103275:	8b 00                	mov    (%eax),%eax
  103277:	99                   	cltd   
  103278:	eb 10                	jmp    10328a <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  10327a:	8b 45 08             	mov    0x8(%ebp),%eax
  10327d:	8b 00                	mov    (%eax),%eax
  10327f:	8d 48 04             	lea    0x4(%eax),%ecx
  103282:	8b 55 08             	mov    0x8(%ebp),%edx
  103285:	89 0a                	mov    %ecx,(%edx)
  103287:	8b 00                	mov    (%eax),%eax
  103289:	99                   	cltd   
    }
}
  10328a:	5d                   	pop    %ebp
  10328b:	c3                   	ret    

0010328c <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10328c:	f3 0f 1e fb          	endbr32 
  103290:	55                   	push   %ebp
  103291:	89 e5                	mov    %esp,%ebp
  103293:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  103296:	8d 45 14             	lea    0x14(%ebp),%eax
  103299:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  10329c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10329f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1032a3:	8b 45 10             	mov    0x10(%ebp),%eax
  1032a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1032aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b4:	89 04 24             	mov    %eax,(%esp)
  1032b7:	e8 03 00 00 00       	call   1032bf <vprintfmt>
    va_end(ap);
}
  1032bc:	90                   	nop
  1032bd:	c9                   	leave  
  1032be:	c3                   	ret    

001032bf <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1032bf:	f3 0f 1e fb          	endbr32 
  1032c3:	55                   	push   %ebp
  1032c4:	89 e5                	mov    %esp,%ebp
  1032c6:	56                   	push   %esi
  1032c7:	53                   	push   %ebx
  1032c8:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1032cb:	eb 17                	jmp    1032e4 <vprintfmt+0x25>
            if (ch == '\0') {
  1032cd:	85 db                	test   %ebx,%ebx
  1032cf:	0f 84 c0 03 00 00    	je     103695 <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  1032d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032dc:	89 1c 24             	mov    %ebx,(%esp)
  1032df:	8b 45 08             	mov    0x8(%ebp),%eax
  1032e2:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1032e4:	8b 45 10             	mov    0x10(%ebp),%eax
  1032e7:	8d 50 01             	lea    0x1(%eax),%edx
  1032ea:	89 55 10             	mov    %edx,0x10(%ebp)
  1032ed:	0f b6 00             	movzbl (%eax),%eax
  1032f0:	0f b6 d8             	movzbl %al,%ebx
  1032f3:	83 fb 25             	cmp    $0x25,%ebx
  1032f6:	75 d5                	jne    1032cd <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  1032f8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1032fc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  103303:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103306:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  103309:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103310:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103313:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  103316:	8b 45 10             	mov    0x10(%ebp),%eax
  103319:	8d 50 01             	lea    0x1(%eax),%edx
  10331c:	89 55 10             	mov    %edx,0x10(%ebp)
  10331f:	0f b6 00             	movzbl (%eax),%eax
  103322:	0f b6 d8             	movzbl %al,%ebx
  103325:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103328:	83 f8 55             	cmp    $0x55,%eax
  10332b:	0f 87 38 03 00 00    	ja     103669 <vprintfmt+0x3aa>
  103331:	8b 04 85 54 3f 10 00 	mov    0x103f54(,%eax,4),%eax
  103338:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10333b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10333f:	eb d5                	jmp    103316 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  103341:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  103345:	eb cf                	jmp    103316 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  103347:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10334e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103351:	89 d0                	mov    %edx,%eax
  103353:	c1 e0 02             	shl    $0x2,%eax
  103356:	01 d0                	add    %edx,%eax
  103358:	01 c0                	add    %eax,%eax
  10335a:	01 d8                	add    %ebx,%eax
  10335c:	83 e8 30             	sub    $0x30,%eax
  10335f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  103362:	8b 45 10             	mov    0x10(%ebp),%eax
  103365:	0f b6 00             	movzbl (%eax),%eax
  103368:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10336b:	83 fb 2f             	cmp    $0x2f,%ebx
  10336e:	7e 38                	jle    1033a8 <vprintfmt+0xe9>
  103370:	83 fb 39             	cmp    $0x39,%ebx
  103373:	7f 33                	jg     1033a8 <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  103375:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  103378:	eb d4                	jmp    10334e <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  10337a:	8b 45 14             	mov    0x14(%ebp),%eax
  10337d:	8d 50 04             	lea    0x4(%eax),%edx
  103380:	89 55 14             	mov    %edx,0x14(%ebp)
  103383:	8b 00                	mov    (%eax),%eax
  103385:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  103388:	eb 1f                	jmp    1033a9 <vprintfmt+0xea>

        case '.':
            if (width < 0)
  10338a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10338e:	79 86                	jns    103316 <vprintfmt+0x57>
                width = 0;
  103390:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  103397:	e9 7a ff ff ff       	jmp    103316 <vprintfmt+0x57>

        case '#':
            altflag = 1;
  10339c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1033a3:	e9 6e ff ff ff       	jmp    103316 <vprintfmt+0x57>
            goto process_precision;
  1033a8:	90                   	nop

        process_precision:
            if (width < 0)
  1033a9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1033ad:	0f 89 63 ff ff ff    	jns    103316 <vprintfmt+0x57>
                width = precision, precision = -1;
  1033b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1033b9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1033c0:	e9 51 ff ff ff       	jmp    103316 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1033c5:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  1033c8:	e9 49 ff ff ff       	jmp    103316 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1033cd:	8b 45 14             	mov    0x14(%ebp),%eax
  1033d0:	8d 50 04             	lea    0x4(%eax),%edx
  1033d3:	89 55 14             	mov    %edx,0x14(%ebp)
  1033d6:	8b 00                	mov    (%eax),%eax
  1033d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1033db:	89 54 24 04          	mov    %edx,0x4(%esp)
  1033df:	89 04 24             	mov    %eax,(%esp)
  1033e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1033e5:	ff d0                	call   *%eax
            break;
  1033e7:	e9 a4 02 00 00       	jmp    103690 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1033ec:	8b 45 14             	mov    0x14(%ebp),%eax
  1033ef:	8d 50 04             	lea    0x4(%eax),%edx
  1033f2:	89 55 14             	mov    %edx,0x14(%ebp)
  1033f5:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1033f7:	85 db                	test   %ebx,%ebx
  1033f9:	79 02                	jns    1033fd <vprintfmt+0x13e>
                err = -err;
  1033fb:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1033fd:	83 fb 06             	cmp    $0x6,%ebx
  103400:	7f 0b                	jg     10340d <vprintfmt+0x14e>
  103402:	8b 34 9d 14 3f 10 00 	mov    0x103f14(,%ebx,4),%esi
  103409:	85 f6                	test   %esi,%esi
  10340b:	75 23                	jne    103430 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  10340d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  103411:	c7 44 24 08 41 3f 10 	movl   $0x103f41,0x8(%esp)
  103418:	00 
  103419:	8b 45 0c             	mov    0xc(%ebp),%eax
  10341c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103420:	8b 45 08             	mov    0x8(%ebp),%eax
  103423:	89 04 24             	mov    %eax,(%esp)
  103426:	e8 61 fe ff ff       	call   10328c <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10342b:	e9 60 02 00 00       	jmp    103690 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  103430:	89 74 24 0c          	mov    %esi,0xc(%esp)
  103434:	c7 44 24 08 4a 3f 10 	movl   $0x103f4a,0x8(%esp)
  10343b:	00 
  10343c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10343f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103443:	8b 45 08             	mov    0x8(%ebp),%eax
  103446:	89 04 24             	mov    %eax,(%esp)
  103449:	e8 3e fe ff ff       	call   10328c <printfmt>
            break;
  10344e:	e9 3d 02 00 00       	jmp    103690 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  103453:	8b 45 14             	mov    0x14(%ebp),%eax
  103456:	8d 50 04             	lea    0x4(%eax),%edx
  103459:	89 55 14             	mov    %edx,0x14(%ebp)
  10345c:	8b 30                	mov    (%eax),%esi
  10345e:	85 f6                	test   %esi,%esi
  103460:	75 05                	jne    103467 <vprintfmt+0x1a8>
                p = "(null)";
  103462:	be 4d 3f 10 00       	mov    $0x103f4d,%esi
            }
            if (width > 0 && padc != '-') {
  103467:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10346b:	7e 76                	jle    1034e3 <vprintfmt+0x224>
  10346d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  103471:	74 70                	je     1034e3 <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  103473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103476:	89 44 24 04          	mov    %eax,0x4(%esp)
  10347a:	89 34 24             	mov    %esi,(%esp)
  10347d:	e8 ba f7 ff ff       	call   102c3c <strnlen>
  103482:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103485:	29 c2                	sub    %eax,%edx
  103487:	89 d0                	mov    %edx,%eax
  103489:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10348c:	eb 16                	jmp    1034a4 <vprintfmt+0x1e5>
                    putch(padc, putdat);
  10348e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  103492:	8b 55 0c             	mov    0xc(%ebp),%edx
  103495:	89 54 24 04          	mov    %edx,0x4(%esp)
  103499:	89 04 24             	mov    %eax,(%esp)
  10349c:	8b 45 08             	mov    0x8(%ebp),%eax
  10349f:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  1034a1:	ff 4d e8             	decl   -0x18(%ebp)
  1034a4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1034a8:	7f e4                	jg     10348e <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1034aa:	eb 37                	jmp    1034e3 <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  1034ac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1034b0:	74 1f                	je     1034d1 <vprintfmt+0x212>
  1034b2:	83 fb 1f             	cmp    $0x1f,%ebx
  1034b5:	7e 05                	jle    1034bc <vprintfmt+0x1fd>
  1034b7:	83 fb 7e             	cmp    $0x7e,%ebx
  1034ba:	7e 15                	jle    1034d1 <vprintfmt+0x212>
                    putch('?', putdat);
  1034bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034c3:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1034ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1034cd:	ff d0                	call   *%eax
  1034cf:	eb 0f                	jmp    1034e0 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  1034d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034d8:	89 1c 24             	mov    %ebx,(%esp)
  1034db:	8b 45 08             	mov    0x8(%ebp),%eax
  1034de:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1034e0:	ff 4d e8             	decl   -0x18(%ebp)
  1034e3:	89 f0                	mov    %esi,%eax
  1034e5:	8d 70 01             	lea    0x1(%eax),%esi
  1034e8:	0f b6 00             	movzbl (%eax),%eax
  1034eb:	0f be d8             	movsbl %al,%ebx
  1034ee:	85 db                	test   %ebx,%ebx
  1034f0:	74 27                	je     103519 <vprintfmt+0x25a>
  1034f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1034f6:	78 b4                	js     1034ac <vprintfmt+0x1ed>
  1034f8:	ff 4d e4             	decl   -0x1c(%ebp)
  1034fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1034ff:	79 ab                	jns    1034ac <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  103501:	eb 16                	jmp    103519 <vprintfmt+0x25a>
                putch(' ', putdat);
  103503:	8b 45 0c             	mov    0xc(%ebp),%eax
  103506:	89 44 24 04          	mov    %eax,0x4(%esp)
  10350a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  103511:	8b 45 08             	mov    0x8(%ebp),%eax
  103514:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  103516:	ff 4d e8             	decl   -0x18(%ebp)
  103519:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10351d:	7f e4                	jg     103503 <vprintfmt+0x244>
            }
            break;
  10351f:	e9 6c 01 00 00       	jmp    103690 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103524:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103527:	89 44 24 04          	mov    %eax,0x4(%esp)
  10352b:	8d 45 14             	lea    0x14(%ebp),%eax
  10352e:	89 04 24             	mov    %eax,(%esp)
  103531:	e8 0b fd ff ff       	call   103241 <getint>
  103536:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103539:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10353c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10353f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103542:	85 d2                	test   %edx,%edx
  103544:	79 26                	jns    10356c <vprintfmt+0x2ad>
                putch('-', putdat);
  103546:	8b 45 0c             	mov    0xc(%ebp),%eax
  103549:	89 44 24 04          	mov    %eax,0x4(%esp)
  10354d:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  103554:	8b 45 08             	mov    0x8(%ebp),%eax
  103557:	ff d0                	call   *%eax
                num = -(long long)num;
  103559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10355c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10355f:	f7 d8                	neg    %eax
  103561:	83 d2 00             	adc    $0x0,%edx
  103564:	f7 da                	neg    %edx
  103566:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103569:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10356c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103573:	e9 a8 00 00 00       	jmp    103620 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  103578:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10357b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10357f:	8d 45 14             	lea    0x14(%ebp),%eax
  103582:	89 04 24             	mov    %eax,(%esp)
  103585:	e8 64 fc ff ff       	call   1031ee <getuint>
  10358a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10358d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  103590:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103597:	e9 84 00 00 00       	jmp    103620 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10359c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10359f:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035a3:	8d 45 14             	lea    0x14(%ebp),%eax
  1035a6:	89 04 24             	mov    %eax,(%esp)
  1035a9:	e8 40 fc ff ff       	call   1031ee <getuint>
  1035ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035b1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1035b4:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1035bb:	eb 63                	jmp    103620 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  1035bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035c4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  1035cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1035ce:	ff d0                	call   *%eax
            putch('x', putdat);
  1035d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035d7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  1035de:	8b 45 08             	mov    0x8(%ebp),%eax
  1035e1:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1035e3:	8b 45 14             	mov    0x14(%ebp),%eax
  1035e6:	8d 50 04             	lea    0x4(%eax),%edx
  1035e9:	89 55 14             	mov    %edx,0x14(%ebp)
  1035ec:	8b 00                	mov    (%eax),%eax
  1035ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1035f8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1035ff:	eb 1f                	jmp    103620 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103601:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103604:	89 44 24 04          	mov    %eax,0x4(%esp)
  103608:	8d 45 14             	lea    0x14(%ebp),%eax
  10360b:	89 04 24             	mov    %eax,(%esp)
  10360e:	e8 db fb ff ff       	call   1031ee <getuint>
  103613:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103616:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103619:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103620:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  103624:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103627:	89 54 24 18          	mov    %edx,0x18(%esp)
  10362b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10362e:	89 54 24 14          	mov    %edx,0x14(%esp)
  103632:	89 44 24 10          	mov    %eax,0x10(%esp)
  103636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103639:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10363c:	89 44 24 08          	mov    %eax,0x8(%esp)
  103640:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103644:	8b 45 0c             	mov    0xc(%ebp),%eax
  103647:	89 44 24 04          	mov    %eax,0x4(%esp)
  10364b:	8b 45 08             	mov    0x8(%ebp),%eax
  10364e:	89 04 24             	mov    %eax,(%esp)
  103651:	e8 94 fa ff ff       	call   1030ea <printnum>
            break;
  103656:	eb 38                	jmp    103690 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103658:	8b 45 0c             	mov    0xc(%ebp),%eax
  10365b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10365f:	89 1c 24             	mov    %ebx,(%esp)
  103662:	8b 45 08             	mov    0x8(%ebp),%eax
  103665:	ff d0                	call   *%eax
            break;
  103667:	eb 27                	jmp    103690 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103669:	8b 45 0c             	mov    0xc(%ebp),%eax
  10366c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103670:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  103677:	8b 45 08             	mov    0x8(%ebp),%eax
  10367a:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  10367c:	ff 4d 10             	decl   0x10(%ebp)
  10367f:	eb 03                	jmp    103684 <vprintfmt+0x3c5>
  103681:	ff 4d 10             	decl   0x10(%ebp)
  103684:	8b 45 10             	mov    0x10(%ebp),%eax
  103687:	48                   	dec    %eax
  103688:	0f b6 00             	movzbl (%eax),%eax
  10368b:	3c 25                	cmp    $0x25,%al
  10368d:	75 f2                	jne    103681 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  10368f:	90                   	nop
    while (1) {
  103690:	e9 36 fc ff ff       	jmp    1032cb <vprintfmt+0xc>
                return;
  103695:	90                   	nop
        }
    }
}
  103696:	83 c4 40             	add    $0x40,%esp
  103699:	5b                   	pop    %ebx
  10369a:	5e                   	pop    %esi
  10369b:	5d                   	pop    %ebp
  10369c:	c3                   	ret    

0010369d <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  10369d:	f3 0f 1e fb          	endbr32 
  1036a1:	55                   	push   %ebp
  1036a2:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1036a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036a7:	8b 40 08             	mov    0x8(%eax),%eax
  1036aa:	8d 50 01             	lea    0x1(%eax),%edx
  1036ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036b0:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1036b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036b6:	8b 10                	mov    (%eax),%edx
  1036b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036bb:	8b 40 04             	mov    0x4(%eax),%eax
  1036be:	39 c2                	cmp    %eax,%edx
  1036c0:	73 12                	jae    1036d4 <sprintputch+0x37>
        *b->buf ++ = ch;
  1036c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036c5:	8b 00                	mov    (%eax),%eax
  1036c7:	8d 48 01             	lea    0x1(%eax),%ecx
  1036ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  1036cd:	89 0a                	mov    %ecx,(%edx)
  1036cf:	8b 55 08             	mov    0x8(%ebp),%edx
  1036d2:	88 10                	mov    %dl,(%eax)
    }
}
  1036d4:	90                   	nop
  1036d5:	5d                   	pop    %ebp
  1036d6:	c3                   	ret    

001036d7 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1036d7:	f3 0f 1e fb          	endbr32 
  1036db:	55                   	push   %ebp
  1036dc:	89 e5                	mov    %esp,%ebp
  1036de:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1036e1:	8d 45 14             	lea    0x14(%ebp),%eax
  1036e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1036e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1036ee:	8b 45 10             	mov    0x10(%ebp),%eax
  1036f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1036f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1036ff:	89 04 24             	mov    %eax,(%esp)
  103702:	e8 08 00 00 00       	call   10370f <vsnprintf>
  103707:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10370a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10370d:	c9                   	leave  
  10370e:	c3                   	ret    

0010370f <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10370f:	f3 0f 1e fb          	endbr32 
  103713:	55                   	push   %ebp
  103714:	89 e5                	mov    %esp,%ebp
  103716:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103719:	8b 45 08             	mov    0x8(%ebp),%eax
  10371c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10371f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103722:	8d 50 ff             	lea    -0x1(%eax),%edx
  103725:	8b 45 08             	mov    0x8(%ebp),%eax
  103728:	01 d0                	add    %edx,%eax
  10372a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10372d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103734:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103738:	74 0a                	je     103744 <vsnprintf+0x35>
  10373a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10373d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103740:	39 c2                	cmp    %eax,%edx
  103742:	76 07                	jbe    10374b <vsnprintf+0x3c>
        return -E_INVAL;
  103744:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103749:	eb 2a                	jmp    103775 <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10374b:	8b 45 14             	mov    0x14(%ebp),%eax
  10374e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103752:	8b 45 10             	mov    0x10(%ebp),%eax
  103755:	89 44 24 08          	mov    %eax,0x8(%esp)
  103759:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10375c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103760:	c7 04 24 9d 36 10 00 	movl   $0x10369d,(%esp)
  103767:	e8 53 fb ff ff       	call   1032bf <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  10376c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10376f:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103772:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103775:	c9                   	leave  
  103776:	c3                   	ret    
