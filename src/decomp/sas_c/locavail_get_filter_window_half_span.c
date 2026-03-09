typedef signed long LONG;
typedef signed short WORD;

extern LONG LOCAVAIL_FilterModeFlag;
extern WORD LOCAVAIL_FilterWindowHalfSpan;

LONG LOCAVAIL_GetFilterWindowHalfSpan(void)
{
    WORD span;

    if (LOCAVAIL_FilterModeFlag == 1) {
        if (LOCAVAIL_FilterWindowHalfSpan > 0) {
            span = LOCAVAIL_FilterWindowHalfSpan;
        } else {
            span = 30;
        }
    } else {
        span = 30;
    }

    span = (WORD)(span >> 1);
    span += 1;
    return (LONG)span;
}
