#include "esq_types.h"

/*
 * Target 063 GCC trial function.
 * Common wrapper that forwards format + arg stream to PARALLEL_RawDoFmt.
 */
void PARALLEL_RawDoFmt(const u8 *fmt, const void *arg_stream);
void PARALLEL_RawDoFmtCommon(const u8 *fmt, const void *arg_stream) __attribute__((noinline, used));

void PARALLEL_RawDoFmtCommon(const u8 *fmt, const void *arg_stream)
{
    PARALLEL_RawDoFmt(fmt, arg_stream);
}
