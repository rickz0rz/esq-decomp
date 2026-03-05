typedef signed long LONG;
typedef short WORD;

extern WORD Global_WORD_H_VALUE;
extern WORD Global_WORD_T_VALUE;
extern WORD Global_WORD_MAX_VALUE;

LONG PARSEINI_ComputeHTCMaxValues(void)
{
    LONG delta;

    delta = (LONG)Global_WORD_H_VALUE - (LONG)Global_WORD_T_VALUE;
    if (delta < 0) {
        delta += 64000L;
    }

    if ((LONG)Global_WORD_MAX_VALUE < delta) {
        Global_WORD_MAX_VALUE = (WORD)delta;
    }

    return delta;
}
