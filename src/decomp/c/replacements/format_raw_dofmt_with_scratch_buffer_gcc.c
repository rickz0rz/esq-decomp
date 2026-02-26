#include "esq_types.h"

/*
 * Target 077 GCC trial function.
 * Format into FORMAT_ScratchBuffer, then emit via PARALLEL_RawDoFmtStackArgs.
 */
extern u8 FORMAT_ScratchBuffer[];
extern void FORMAT_FormatToBuffer2(u8 *dst, const char *fmt, void *args);
extern void PARALLEL_RawDoFmtStackArgs(u8 *buffer);

void FORMAT_RawDoFmtWithScratchBuffer(const char *fmt, ...) __attribute__((noinline, used));

void FORMAT_RawDoFmtWithScratchBuffer(const char *fmt, ...)
{
    void *arg_list = (void *)(&fmt + 1);

    FORMAT_FormatToBuffer2(FORMAT_ScratchBuffer, fmt, arg_list);
    PARALLEL_RawDoFmtStackArgs(FORMAT_ScratchBuffer);
}
