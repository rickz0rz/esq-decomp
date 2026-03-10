typedef unsigned char UBYTE;
typedef signed short WORD;
typedef signed long LONG;

extern LONG DST_BuildBannerTimeWord(WORD row, LONG unused, UBYTE slot);
extern LONG DISPLIB_NormalizeValueByStep(LONG value, LONG step, LONG base);

LONG ESQDISP_ComputeScheduleOffsetForRow(WORD row, UBYTE slot)
{
    LONG timeWord;
    LONG offset;

    timeWord = DST_BuildBannerTimeWord(row, 0, slot);
    offset = (LONG)row + (timeWord + timeWord);

    return DISPLIB_NormalizeValueByStep(offset, 1, 48);
}
