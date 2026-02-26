#include "esq_types.h"

/*
 * Target 061 GCC trial function.
 * Low-level parallel output with LF -> CR/LF translation.
 */
extern volatile u8 CIAB_PRA;
extern volatile u8 CIAA_DDRB;
extern volatile u8 CIAA_PRB;

void PARALLEL_WriteCharHw(s32 ch) __attribute__((noinline, used));

void PARALLEL_WriteCharHw(s32 ch)
{
    u8 out = (u8)ch;

    if (out == 10) {
        while ((CIAB_PRA & 1u) != 0u) {
        }
        CIAA_DDRB = 0xff;
        CIAA_PRB = 13;
    }

    while ((CIAB_PRA & 1u) != 0u) {
    }
    CIAA_DDRB = 0xff;
    CIAA_PRB = out;
}
