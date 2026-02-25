#include "esq_types.h"

/*
 * Target 039 GCC trial function.
 * Remove MsgPort if linked, free signal, then free MsgPort memory.
 */
void IOSTDREQ_CleanupSignalAndMsgport(void *msgport_ptr) __attribute__((noinline, used));

void IOSTDREQ_CleanupSignalAndMsgport(void *msgport_ptr)
{
    u8 *p = (u8 *)msgport_ptr;

    if (*(u32 *)(p + 10) != 0) {
        register void *a1_in __asm__("a1") = p;
        __asm__ volatile(
            "movea.l 4.w,%%a6\n\t"
            "jsr _LVORemPort(%%a6)\n\t"
            : "+r"(a1_in)
            :
            : "a6", "cc", "memory");
    }

    p[8] = 0xff;
    *(u32 *)(p + 20) = 0xffffffffu;

    {
        register u32 d0_in __asm__("d0") = p[15];
        __asm__ volatile(
            "movea.l 4.w,%%a6\n\t"
            "jsr _LVOFreeSignal(%%a6)\n\t"
            : "+r"(d0_in)
            :
            : "a6", "cc", "memory");
    }

    {
        register void *a1_in __asm__("a1") = p;
        register u32 d0_in __asm__("d0") = 34;
        __asm__ volatile(
            "movea.l 4.w,%%a6\n\t"
            "jsr _LVOFreeMem(%%a6)\n\t"
            : "+r"(d0_in), "+r"(a1_in)
            :
            : "a6", "cc", "memory");
    }
}
