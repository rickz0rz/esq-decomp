#include "esq_types.h"

/*
 * Target 062 GCC trial function.
 * Stack-args wrapper for PARALLEL_RawDoFmtCommon.
 */
void PARALLEL_RawDoFmtCommon(const u8 *fmt, const void *arg_stream);
void PARALLEL_RawDoFmtStackArgs(const u8 *fmt, u32 first_arg_word) __attribute__((noinline, used));

void PARALLEL_RawDoFmtStackArgs(const u8 *fmt, u32 first_arg_word)
{
    (void)first_arg_word;
    PARALLEL_RawDoFmtCommon(fmt, &first_arg_word);
}
