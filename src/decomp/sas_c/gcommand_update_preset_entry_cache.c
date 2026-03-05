typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG GCOMMAND_ComputePresetIncrement(LONG value, LONG step);

void GCOMMAND_UpdatePresetEntryCache(UBYTE *preset_base)
{
    LONG value = *(LONG *)(preset_base + 32);
    LONG i;
    LONG *dst;
    UBYTE *src;

    if (value < 0) {
        return;
    }

    dst = (LONG *)(preset_base + 36);
    src = preset_base + 55;

    for (i = 0; i < 4; ++i) {
        *dst++ = GCOMMAND_ComputePresetIncrement((LONG)(*src++), value);
    }
}
