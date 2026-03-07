typedef signed long LONG;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_REF_RASTPORT_1;
extern LONG ED_EditCursorOffset;

extern LONG ESQIFF_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern LONG _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVORectFill(void *gfxBase, void *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);

void ED_DrawMenuSelectionHighlight(LONG menuIndex)
{
    LONG endY;

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 2);

    endY = ESQIFF_JMPTBL_MATH_Mulu32(menuIndex, 30) + 67;
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 40, 68, 640, endY);

    if (ED_EditCursorOffset > -1) {
        LONG markerTop;
        LONG markerBottom;

        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 6);

        markerTop = ESQIFF_JMPTBL_MATH_Mulu32(ED_EditCursorOffset, 30) + 68;
        markerBottom = markerTop + 29;

        _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 40, markerTop, 640, markerBottom);
    }
}
