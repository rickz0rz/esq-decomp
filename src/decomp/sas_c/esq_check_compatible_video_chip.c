#include <exec/types.h>
extern volatile UWORD IS_COMPATIBLE_VIDEO_CHIP;

UWORD ESQ_CheckCompatibleVideoChip(void)
{
    volatile UWORD *vposr;
    UWORD chipId;

    vposr = (volatile UWORD *)0xDFF004L;
    chipId = *vposr;
    chipId = (UWORD)(chipId & 0x7F00);

    if (chipId != 0x3000 && chipId != 0x2000 && chipId != 0x3300) {
        IS_COMPATIBLE_VIDEO_CHIP = 1;
    }

    return chipId;
}
