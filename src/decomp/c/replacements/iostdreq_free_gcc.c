#include "esq_types.h"

/*
 * Target 038 GCC trial function.
 * Mark IOStdReq-like fields invalid and free 48-byte block.
 */
void IOSTDREQ_Free(void *io_req_ptr) __attribute__((noinline, used));

void IOSTDREQ_Free(void *io_req_ptr)
{
    u8 *p = (u8 *)io_req_ptr;

    p[8] = 0xff;
    *(u32 *)(p + 20) = 0xffffffffu;
    *(u32 *)(p + 24) = 0xffffffffu;

    {
        register void *a1_in __asm__("a1") = p;
        register u32 d0_in __asm__("d0") = 48;
        __asm__ volatile(
            "movea.l 4.w,%%a6\n\t"
            "jsr _LVOFreeMem(%%a6)\n\t"
            : "+r"(d0_in), "+r"(a1_in)
            :
            : "a6", "cc", "memory");
    }
}
