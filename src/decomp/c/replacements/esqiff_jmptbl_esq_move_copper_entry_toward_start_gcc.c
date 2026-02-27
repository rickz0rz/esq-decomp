#include "esq_types.h"

/*
 * Target 126 GCC trial function.
 * Jump-table stub forwarding to ESQ_MoveCopperEntryTowardStart.
 */
void ESQ_MoveCopperEntryTowardStart(s32 dst_index, s32 src_index) __attribute__((noinline));

void ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(s32 dst_index, s32 src_index) __attribute__((noinline, used));

void ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(s32 dst_index, s32 src_index)
{
    ESQ_MoveCopperEntryTowardStart(dst_index, src_index);
}
