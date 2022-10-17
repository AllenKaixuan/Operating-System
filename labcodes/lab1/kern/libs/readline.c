#include <stdio.h>

#define BUFSIZE    1024
static char buf[BUFSIZE];

/*  readline
 *  do
 *      1.  write the input string @prompt (whether it is null or empty) to stdout first as info
 *      2.  reading characters from stdin and saving them to buffer 'buf'(global variable) 
 *          until '\n' or '\r' is encountered. if the length of string that will be read 
 *          is longer than buffer size, the end of string will be discarded.
 *  param
 *      @prompt     the string to be written to stdout
 *  return
 *      the text of the line read.
 *      If some errors are happened, NULL is returned.
 *      The return value is a , thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
    if (prompt != NULL) {
        cprintf("%s", prompt);
    }
    int i = 0, c;
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
            cputchar(c);
            buf[i] = '\0';
            return buf;
        }
    }
}

