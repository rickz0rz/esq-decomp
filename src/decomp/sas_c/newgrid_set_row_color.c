typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

LONG NEWGRID_SetRowColor(UBYTE *gridCtx, WORD selector, LONG colorIndex)
{
    LONG pen;
    LONG slot;

    if (selector == -1) {
        pen = 7;
    } else if (selector == 0) {
        pen = 4;
    } else if (selector == 1) {
        pen = 5;
    } else if (selector == 2) {
        pen = 6;
    } else {
        pen = 4;
    }

    slot = pen - 4;

    if (colorIndex >= 0 && colorIndex <= 16) {
        gridCtx[55 + slot] = (UBYTE)colorIndex;
    } else {
        gridCtx[55 + slot] = 7;
    }

    return pen;
}
