#include "esq_types.h"

u8 *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(u8 *new_value, u8 *old_value) __attribute__((noinline));

void SCRIPT_ResetCtrlContext(u8 *ctx) __attribute__((noinline, used));

void SCRIPT_ResetCtrlContext(u8 *ctx)
{
    s32 i;

    *(u8 *)(ctx + 436) = 0;
    *(u8 *)(ctx + 437) = 120;
    *(u8 *)(ctx + 438) = 0;
    *(u8 *)(ctx + 439) = 0;
    *(u8 **)(ctx + 440) = ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(0, *(u8 **)(ctx + 440));

    *(u8 *)(ctx + 226) = 0;
    *(u8 *)(ctx + 26) = 0;
    *(s16 *)(ctx + 6) = 0;
    *(s16 *)(ctx + 4) = 0;
    *(s16 *)(ctx + 10) = 0;
    *(s16 *)(ctx + 12) = 0;
    *(s16 *)(ctx + 14) = 0;
    *(s32 *)(ctx + 16) = 0;
    *(s32 *)(ctx + 20) = 0;
    *(s16 *)(ctx + 24) = 0;
    *(s16 *)(ctx + 426) = 1;

    for (i = 0; i < 4; i++) {
        *(u8 *)(ctx + 428 + i) = 0;
        *(u8 *)(ctx + 0x1b0 + i) = 0;
    }
}
