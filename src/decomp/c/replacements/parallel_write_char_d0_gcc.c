#include "esq_types.h"

/*
 * Target 055 GCC trial function.
 * Writes one character via low-level parallel routine.
 */
void PARALLEL_WriteCharHw(s32 ch);
void PARALLEL_WriteCharD0(s32 ch) __attribute__((noinline, used));

void PARALLEL_WriteCharD0(s32 ch)
{
    PARALLEL_WriteCharHw(ch);
}
