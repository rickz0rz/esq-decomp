typedef signed long LONG;

extern LONG ED_TextLimit;
extern LONG ED_CursorColumnIndex;
extern LONG ED_ViewportOffset;
extern LONG ED_EditCursorOffset;

void ED_UpdateCursorPosFromIndex(LONG index)
{
    ED_CursorColumnIndex = index % 40;
    ED_ViewportOffset = index / 40;

    while (ED_ViewportOffset >= ED_TextLimit) {
        ED_ViewportOffset -= 1;
        ED_EditCursorOffset -= 40;
    }
}
