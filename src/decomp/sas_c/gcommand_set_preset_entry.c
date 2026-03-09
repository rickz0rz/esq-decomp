typedef signed short WORD;
typedef signed long LONG;

typedef struct GCOMMAND_PresetEntry {
    WORD value0;
    char pad2[126];
} GCOMMAND_PresetEntry;

extern GCOMMAND_PresetEntry GCOMMAND_PresetValueTable[];

void GCOMMAND_SetPresetEntry(LONG index, LONG value)
{
    if (index <= 0) {
        return;
    }
    if (index >= 16) {
        return;
    }
    if (value < 0) {
        return;
    }
    if (value >= 0x1000) {
        return;
    }

    /* Original code uses a 0x80-byte stride and writes a word at offset 0. */
    GCOMMAND_PresetValueTable[index].value0 = (WORD)value;
}
