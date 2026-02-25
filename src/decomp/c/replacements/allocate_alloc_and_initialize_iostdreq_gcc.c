#include "esq_types.h"

/*
 * Target 042 GCC trial function.
 * Allocate 48-byte IOStdReq-like block and initialize message header fields.
 */
void *ALLOCATE_AllocAndInitializeIOStdReq(void *reply_port) __attribute__((noinline, used));

void *ALLOCATE_AllocAndInitializeIOStdReq(void *reply_port)
{
    u8 *req;

    if (reply_port == (void *)0) {
        return (void *)0;
    }

    {
        register u32 d0_in __asm__("d0") = 48;
        register u32 d1_in __asm__("d1") = 0x00010001u;
        __asm__ volatile(
            "movea.l 4.w,%%a6\n\t"
            "jsr _LVOAllocMem(%%a6)\n\t"
            : "+r"(d0_in)
            : "r"(d1_in)
            : "a6", "cc", "memory");
        req = (u8 *)d0_in;
    }

    if (req == (u8 *)0) {
        return (void *)0;
    }

    req[8] = 5; /* NT_MESSAGE */
    req[9] = 0; /* ln_Pri */
    *(void **)(req + 14) = reply_port; /* mn_ReplyPort */

    return (void *)req;
}
