typedef signed long LONG;
typedef signed short WORD;

typedef struct {
    LONG presetIndex;
    LONG currentValue;
    LONG step;
    LONG baseValue;
    LONG phase;
    LONG mode;
} PresetWorkEntry;

extern PresetWorkEntry GCOMMAND_PresetWorkEntryTable[];
extern WORD GCOMMAND_PresetWorkResetPendingFlag;

void GCOMMAND_ResetPresetWorkTables(void)
{
    LONG i;

    for (i = 0; i < 4; ++i) {
        GCOMMAND_PresetWorkEntryTable[i].presetIndex = i + 4;
        GCOMMAND_PresetWorkEntryTable[i].currentValue = 0;
        GCOMMAND_PresetWorkEntryTable[i].step = 0;
        GCOMMAND_PresetWorkEntryTable[i].baseValue = 0;
        GCOMMAND_PresetWorkEntryTable[i].phase = 0;
    }

    GCOMMAND_PresetWorkResetPendingFlag = 0;
}
