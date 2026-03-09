typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Context {
    UBYTE pad0[52];
    UWORD selectionCode;
    UBYTE modeByte54;
} NEWGRID_Context;

extern UWORD NEWGRID_RowHeightPx;
extern LONG NEWGRID_JMPTBL_MATH_DivS32(LONG a, LONG b);

LONG NEWGRID_ComputeColumnIndex(char *gridCtx)
{
    NEWGRID_Context *grid = (NEWGRID_Context *)gridCtx;
    LONG result = 0;

    if (grid->modeByte54 < '@') {
        LONG quarter;
        LONG width = (LONG)(UWORD)grid->selectionCode;

        quarter = (LONG)(UWORD)NEWGRID_RowHeightPx;
        if (quarter < 0) {
            quarter += 3;
        }
        quarter >>= 2;
        result = NEWGRID_JMPTBL_MATH_DivS32(width, quarter);
    }

    return result;
}
