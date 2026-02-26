#include "esq_types.h"

/*
 * Target 046 GCC trial function.
 * Allocate a signal and MsgPort, populate fields, and optionally register it.
 */
void *SIGNAL_CreateMsgPortWithSignal(void *port_name, s32 port_pri) __attribute__((noinline, used));

void *SIGNAL_CreateMsgPortWithSignal(void *port_name, s32 port_pri)
{
    u8 *msgport;
    s32 signal_num;

    {
        register s32 d0_in __asm__("d0") = -1;
        __asm__ volatile(
            "movea.l 4.w,%%a6\n\t"
            "jsr _LVOAllocSignal(%%a6)\n\t"
            : "+r"(d0_in)
            :
            : "a6", "cc", "memory");
        signal_num = d0_in;
    }

    if ((s8)signal_num == (s8)-1) {
        return (void *)0;
    }

    {
        register u32 d0_in __asm__("d0") = 34;
        register u32 d1_in __asm__("d1") = 0x00010001u;
        __asm__ volatile(
            "movea.l 4.w,%%a6\n\t"
            "jsr _LVOAllocMem(%%a6)\n\t"
            : "+r"(d0_in)
            : "r"(d1_in)
            : "a6", "cc", "memory");
        msgport = (u8 *)d0_in;
    }

    if (msgport == (u8 *)0) {
        register u32 d0_in __asm__("d0") = (u8)signal_num;
        __asm__ volatile(
            "movea.l 4.w,%%a6\n\t"
            "jsr _LVOFreeSignal(%%a6)\n\t"
            : "+r"(d0_in)
            :
            : "a6", "cc", "memory");
        return (void *)0;
    }

    *(void **)(msgport + 10) = port_name; /* ln_Name */
    msgport[9] = (u8)port_pri;            /* ln_Pri */
    msgport[8] = 4;                       /* NT_MSGPORT */
    msgport[14] = 0;                      /* mp_Flags */
    msgport[15] = (u8)signal_num;         /* mp_SigBit */

    {
        register void *a1_in __asm__("a1") = (void *)0;
        register u32 d0_out __asm__("d0");
        __asm__ volatile(
            "movea.l 4.w,%%a6\n\t"
            "jsr _LVOFindTask(%%a6)\n\t"
            : "=r"(d0_out), "+r"(a1_in)
            :
            : "a6", "cc", "memory");
        *(u32 *)(msgport + 16) = d0_out; /* mp_SigTask */
    }

    if (port_name != (void *)0) {
        register void *a1_in __asm__("a1") = msgport;
        __asm__ volatile(
            "movea.l 4.w,%%a6\n\t"
            "jsr _LVOAddPort(%%a6)\n\t"
            : "+r"(a1_in)
            :
            : "a6", "cc", "memory");
    } else {
        *(u32 *)(msgport + 20) = (u32)(msgport + 24);
        *(u32 *)(msgport + 28) = (u32)(msgport + 20);
        *(u32 *)(msgport + 24) = 0;
        msgport[32] = 2;
    }

    return (void *)msgport;
}
