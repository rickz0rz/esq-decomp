#include "esq_types.h"

/*
 * Target 611 GCC trial function.
 * Wrapper that calls DST_BuildBannerTimeEntry and returns the output word.
 */
void DST_BuildBannerTimeEntry(s32 arg0, s32 arg1, s16 *out_word, u32 arg3) __attribute__((noinline));

s32 DST_BuildBannerTimeWord(s16 arg_1, s32 arg_2, u8 arg_3) __attribute__((noinline, used));

s32 DST_BuildBannerTimeWord(s16 arg_1, s32 arg_2, u8 arg_3)
{
    s16 out_word = 0;
    DST_BuildBannerTimeEntry((s32)arg_1, (s32)arg_3, &out_word, 0);
    (void)arg_2;
    return (s32)out_word;
}
