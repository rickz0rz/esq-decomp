#include <stdint.h>

/*
 * Target 751 GCC trial function pair.
 * Keep the cold-reboot path in inline assembly to preserve control flow shape.
 */
void ESQ_ColdReboot(void) __attribute__((noinline, used));
void ESQ_ColdRebootViaSupervisor(void) __attribute__((noinline, used));

void ESQ_ColdReboot(void)
{
    __asm__ volatile(
        "movea.l AbsExecBase,%a6\n\t"
        "cmpi.w #0x24,20(%a6)\n\t"
        "blt.s ESQ_ColdRebootViaSupervisor\n\t"
        "jmp _LVOColdReboot(%a6)\n\t");
}

void ESQ_ColdRebootViaSupervisor(void)
{
    __asm__ volatile(
        "lea ESQ_SupervisorColdReboot(%pc),%a5\n\t"
        "jsr _LVOSupervisor(%a6)\n\t");
}
