#include <x86.h>
#include <intr.h>

/*  intr_enable
 *  do
 *      enable irq interrupt
 */
void
intr_enable(void) {
    sti();
}

/*  intr_disable
 *  do
 *      disable irq interrupt
 */
void
intr_disable(void) {
    cli();
}

