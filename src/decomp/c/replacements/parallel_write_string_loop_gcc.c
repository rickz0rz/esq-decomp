#include "esq_types.h"

/*
 * Target 059 GCC trial function.
 * Emit a NUL-terminated string via PARALLEL_WriteCharD0.
 */
void PARALLEL_WriteCharD0(s32 ch);
void PARALLEL_WriteStringLoop(const u8 *s) __attribute__((noinline, used));

void PARALLEL_WriteStringLoop(const u8 *s)
{
    u8 ch;

    while ((ch = *s++) != 0) {
        PARALLEL_WriteCharD0((s32)ch);
    }
}
