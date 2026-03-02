#include "esq_types.h"

/*
 * Target 628 GCC trial function.
 * Wrapper that calls TLIBA2_ResolveEntryWindowAndSlotCount with default range args.
 */
s32 TLIBA2_ResolveEntryWindowAndSlotCount(void *entry, void *out_pair, s32 mode, s32 arg4, s32 arg5) __attribute__((noinline));

s32 TLIBA2_ResolveEntryWindowWithDefaultRange(void *entry, void *out_pair, s32 mode) __attribute__((noinline, used));

s32 TLIBA2_ResolveEntryWindowWithDefaultRange(void *entry, void *out_pair, s32 mode)
{
    return TLIBA2_ResolveEntryWindowAndSlotCount(entry, out_pair, mode, 0, 0);
}
