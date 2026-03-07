typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UWORD NEWGRID_RowHeightPx;
extern LONG NEWGRID_JMPTBL_MATH_DivS32(LONG a, LONG b);

LONG NEWGRID_ComputeColumnIndex(void *gridCtx)
{
    UBYTE *grid = (UBYTE *)gridCtx;
    LONG result = 0;

    if (*(UBYTE *)(grid + 54) < '@') {
        LONG quarter;
        LONG width = (LONG)(UWORD)(*(UWORD *)(grid + 52));

        quarter = (LONG)(UWORD)NEWGRID_RowHeightPx;
        if (quarter < 0) {
            quarter += 3;
        }
        quarter >>= 2;
        result = NEWGRID_JMPTBL_MATH_DivS32(width, quarter);
    }

    return result;
}
