typedef signed long LONG;
typedef short WORD;

extern WORD CTRL_H;
extern WORD CTRL_HPreviousSample;
extern WORD CTRL_HDeltaMax;

LONG PARSEINI_UpdateCtrlHDeltaMax(void)
{
    LONG delta;

    delta = (LONG)CTRL_H - (LONG)CTRL_HPreviousSample;
    if (delta < 0) {
        delta += 500L;
    }

    if ((LONG)CTRL_HDeltaMax < delta) {
        CTRL_HDeltaMax = (WORD)delta;
    }

    return delta;
}
