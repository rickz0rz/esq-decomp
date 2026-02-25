#include "esq_types.h"

/*
 * Target 026 GCC trial function.
 * Append one byte to printf output buffer.
 */
extern u8 *Global_PrintfBufferPtr;
extern u32 Global_PrintfByteCount;

u32 UNKNOWN10_PrintfPutcToBuffer(u32 ch) __attribute__((noinline, used));

u32 UNKNOWN10_PrintfPutcToBuffer(u32 ch)
{
    Global_PrintfByteCount += 1;

    u8 *p = Global_PrintfBufferPtr;
    *p++ = (u8)ch;
    Global_PrintfBufferPtr = p;

    return ch;
}
