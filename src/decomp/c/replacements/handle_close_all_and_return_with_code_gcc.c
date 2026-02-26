#include "esq_types.h"

/*
 * Target 075 GCC trial function.
 * Close eligible handles, then return via ESQ return-code jump-table stub.
 */
extern u32 Global_HandleTableCount;
extern u8 Global_HandleTableBase[];

s32 DOS_CloseWithSignalCheck(s32 handle) __attribute__((noinline));
s32 UNKNOWN32_JMPTBL_ESQ_ReturnWithStackCode(s32 code) __attribute__((noinline));

s32 HANDLE_CloseAllAndReturnWithCode(s32 code) __attribute__((noinline, used));

s32 HANDLE_CloseAllAndReturnWithCode(s32 code)
{
    s16 i = (s16)(Global_HandleTableCount - 1u);

    while (i >= 0) {
        u8 *entry = Global_HandleTableBase + (((u32)(u16)i) << 3);
        u32 flags = *(u32 *)(entry + 0);

        if ((u8)flags != 0u && (flags & (1u << 4)) == 0u) {
            s32 handle = *(s32 *)(entry + 4);
            DOS_CloseWithSignalCheck(handle);
        }

        --i;
    }

    return UNKNOWN32_JMPTBL_ESQ_ReturnWithStackCode(code);
}
