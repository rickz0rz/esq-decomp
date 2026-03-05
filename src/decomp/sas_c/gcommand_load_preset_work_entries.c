typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct {
    LONG presetIndex;
    LONG currentValue;
    LONG step;
    LONG baseValue;
    LONG phase;
    LONG mode;
} PresetWorkEntry;

typedef struct {
    UBYTE pad0[32];
    LONG baseValue;
    LONG span[4];
    UBYTE pad1[3];
    UBYTE presetIndex[4];
} PresetRecord;

extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern void GCOMMAND_InitPresetWorkEntry(PresetWorkEntry *entry, LONG presetIndex, LONG span, LONG baseValue);
extern PresetWorkEntry GCOMMAND_PresetWorkEntryTable[];

void GCOMMAND_LoadPresetWorkEntries(PresetRecord *record)
{
    LONG i;

    for (i = 0; i < 4; ++i) {
        LONG offset = NEWGRID_JMPTBL_MATH_Mulu32(i, 24);
        PresetWorkEntry *entry = (PresetWorkEntry *)((UBYTE *)GCOMMAND_PresetWorkEntryTable + offset);
        LONG preset = (LONG)record->presetIndex[i];
        LONG span = record->span[i];
        LONG baseValue = record->baseValue;
        GCOMMAND_InitPresetWorkEntry(entry, preset, baseValue, span);
    }
}
