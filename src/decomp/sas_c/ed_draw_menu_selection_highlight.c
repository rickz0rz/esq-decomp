typedef signed long LONG;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern char *Global_REF_RASTPORT_1;
extern LONG ED_EditCursorOffset;

extern LONG ESQIFF_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern LONG _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern LONG _LVORectFill(void *gfxBase, char *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);

void ED_DrawMenuSelectionHighlight(LONG menuIndex)
{
    const LONG PEN_MENU_BACKGROUND = 2;
    const LONG PEN_MENU_HIGHLIGHT = 6;
    const LONG ROW_HEIGHT = 30;
    const LONG MENU_TOP_BASE = 67;
    const LONG FILL_MIN_X = 40;
    const LONG FILL_MIN_Y = 68;
    const LONG FILL_MAX_X = 640;
    const LONG MARKER_HEIGHT_DELTA = 29;
    LONG endY;

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_MENU_BACKGROUND);

    endY = ESQIFF_JMPTBL_MATH_Mulu32(menuIndex, ROW_HEIGHT) + MENU_TOP_BASE;
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, FILL_MIN_X, FILL_MIN_Y, FILL_MAX_X, endY);

    if (ED_EditCursorOffset > -1) {
        LONG markerTop;
        LONG markerBottom;

        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_MENU_HIGHLIGHT);

        markerTop = ESQIFF_JMPTBL_MATH_Mulu32(ED_EditCursorOffset, ROW_HEIGHT) + FILL_MIN_Y;
        markerBottom = markerTop + MARKER_HEIGHT_DELTA;

        _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, FILL_MIN_X, markerTop, FILL_MAX_X, markerBottom);
    }
}
