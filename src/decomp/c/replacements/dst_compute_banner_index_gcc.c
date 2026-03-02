#include "esq_types.h"

/*
 * Target 612 GCC trial function.
 * Compute banner index bucket from date fields and mode flags.
 */
void DST_BuildBannerTimeEntry(s32 arg0, s32 arg1, s16 *out_word, void *ctx) __attribute__((noinline));

static s32 DST_ModByDivS32Helper(s32 dividend, s32 divisor) __attribute__((noinline));
static s16 DST_RemS16Div48(s16 value) __attribute__((noinline));

static s32 DST_ModByDivS32Helper(s32 dividend, s32 divisor)
{
    register s32 d0_inout __asm__("d0") = dividend;
    register s32 d1_inout __asm__("d1") = divisor;

    __asm__ volatile(
        "jsr GROUP_AG_JMPTBL_MATH_DivS32\n\t"
        : "+d"(d0_inout), "+d"(d1_inout)
        :
        : "cc", "memory");

    return d1_inout;
}

static s16 DST_RemS16Div48(s16 value)
{
    register s32 d0_inout __asm__("d0") = (s32)value;

    __asm__ volatile(
        "divs #0x30,%0\n\t"
        "swap %0\n\t"
        : "+d"(d0_inout)
        :
        : "cc");

    return (s16)d0_inout;
}

s32 DST_ComputeBannerIndex(void *ctx, s16 arg_2, u8 arg_3) __attribute__((noinline, used));

s32 DST_ComputeBannerIndex(void *ctx, s16 arg_2, u8 arg_3)
{
    u8 *p = (u8 *)ctx;
    s16 out_word = 0;
    s32 rem;
    s32 idx;
    s32 nonzero;
    s16 folded;

    DST_BuildBannerTimeEntry((s32)arg_2, (s32)arg_3, &out_word, ctx);

    rem = DST_ModByDivS32Helper((s32)(s16)(*(s16 *)(p + 8)), 12);
    if (*(s16 *)(p + 18) != 0) {
        rem += 12;
    }

    idx = rem + rem;
    if ((s16)(*(s16 *)(p + 10)) > 0x1d) {
        idx += 1;
    }

    nonzero = (idx != 0) ? 1 : 0;
    folded = DST_RemS16Div48((s16)(nonzero + 0x26));

    return (s32)(s16)(folded + 1);
}
