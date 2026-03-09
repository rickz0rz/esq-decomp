typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Context {
    UBYTE pad0[55];
    UBYTE rowPens[4];
} NEWGRID_Context;

LONG NEWGRID_SetRowColor(char *gridCtx, WORD selector, LONG colorIndex)
{
    NEWGRID_Context *ctx;
    LONG pen;
    LONG slot;

    ctx = (NEWGRID_Context *)gridCtx;

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
        ctx->rowPens[slot] = (UBYTE)colorIndex;
    } else {
        ctx->rowPens[slot] = 7;
    }

    return pen;
}
