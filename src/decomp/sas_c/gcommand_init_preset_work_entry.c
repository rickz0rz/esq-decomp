typedef signed long LONG;
typedef unsigned short UWORD;

typedef struct {
    LONG presetIndex;
    LONG currentValue;
    LONG step;
    LONG baseValue;
    LONG phase;
    LONG mode;
} PresetWorkEntry;

extern void GCOMMAND_SetPresetEntry(LONG row, LONG value);
extern UWORD GCOMMAND_DefaultPresetTable[];

void GCOMMAND_InitPresetWorkEntry(PresetWorkEntry *entry, LONG presetIndex, LONG span, LONG baseValue)
{
    if (presetIndex < 0 || presetIndex >= 16) {
        entry->presetIndex = 6;
        entry->phase = 0;
        entry->baseValue = 0;
        entry->currentValue = 0;
        entry->mode = 0;
        entry->step = 0;
        GCOMMAND_SetPresetEntry(6, 1365);
        return;
    }

    entry->presetIndex = presetIndex;
    entry->phase = 0;

    if (span > 4) {
        entry->baseValue = baseValue;
        entry->currentValue = (LONG)GCOMMAND_DefaultPresetTable[presetIndex] - 1;
        entry->mode = 2;
        entry->step = 1;
        return;
    }

    if (span >= 0) {
        entry->baseValue = 0;
        entry->currentValue = 0;
        entry->mode = 0;
        entry->step = 0;
    }
}
