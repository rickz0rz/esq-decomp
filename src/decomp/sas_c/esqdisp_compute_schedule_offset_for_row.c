typedef unsigned char UBYTE;
typedef signed short WORD;
typedef signed long LONG;

extern LONG DST_BuildBannerTimeWord(void);
extern LONG DISPLIB_NormalizeValueByStep(void);

LONG ESQDISP_ComputeScheduleOffsetForRow(WORD row, UBYTE slot)
{
    LONG timeWord;
    LONG offset;

    timeWord = DST_BuildBannerTimeWord((LONG)row, (LONG)slot);
    offset = (LONG)row + (timeWord + timeWord);

    return DISPLIB_NormalizeValueByStep(offset, 1, 48);
}
