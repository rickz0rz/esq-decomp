#include "esq_types.h"

/*
 * Target 625 GCC trial function.
 * Probe VPOSR chip id field and set compatibility guard flag for unknown IDs.
 */
extern s16 IS_COMPATIBLE_VIDEO_CHIP;

void ESQ_CheckCompatibleVideoChip(void) __attribute__((noinline, used));

void ESQ_CheckCompatibleVideoChip(void)
{
    u16 vposr = *(volatile u16 *)0x00dff004u;
    u16 chip = (u16)(vposr & 0x7f00u);

    if (chip != 0x3000u && chip != 0x2000u && chip != 0x3300u) {
        IS_COMPATIBLE_VIDEO_CHIP = 1;
    }
}
