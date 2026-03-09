typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct GCOMMAND_PresetEntry {
    UBYTE pad0[32];
    LONG value32;
    LONG cache36[4];
    UBYTE values55[4];
} GCOMMAND_PresetEntry;

extern LONG GCOMMAND_ComputePresetIncrement(LONG value, LONG step);

void GCOMMAND_UpdatePresetEntryCache(UBYTE *preset_base)
{
    GCOMMAND_PresetEntry *entryView;
    LONG value;
    LONG i;
    LONG *dst;
    UBYTE *src;

    entryView = (GCOMMAND_PresetEntry *)preset_base;
    value = entryView->value32;
    if (value < 0) {
        return;
    }

    dst = entryView->cache36;
    src = entryView->values55;

    for (i = 0; i < 4; ++i) {
        *dst++ = GCOMMAND_ComputePresetIncrement((LONG)(*src++), value);
    }
}
