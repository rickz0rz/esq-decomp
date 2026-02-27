#include "esq_types.h"

/*
 * Target 127 GCC trial function.
 * Jump-table stub forwarding to ESQ_MoveCopperEntryTowardEnd.
 */
void ESQ_MoveCopperEntryTowardEnd(s32 src_index, s32 dst_index) __attribute__((noinline));

void ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(s32 src_index, s32 dst_index) __attribute__((noinline, used));

void ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(s32 src_index, s32 dst_index)
{
    ESQ_MoveCopperEntryTowardEnd(src_index, dst_index);
}
