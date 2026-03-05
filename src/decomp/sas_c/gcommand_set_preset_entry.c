typedef signed short WORD;
typedef signed long LONG;

extern WORD GCOMMAND_PresetValueTable[];

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
    *(WORD *)((char *)GCOMMAND_PresetValueTable + (index << 7)) = (WORD)value;
}
