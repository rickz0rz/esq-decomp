typedef signed long LONG;

extern LONG ED_AdActiveFlag;
extern LONG ED_ActiveIndicatorCachedState;

extern char *Global_REF_RASTPORT_1;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern LONG _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern LONG _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);
extern void _LVORectFill(char *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern LONG DISPLIB_DisplayTextAtPosition(char *rastPort, LONG y, LONG x, const char *text);

extern const char Global_STR_ACTIVE_INACTIVE[];

void ED_UpdateActiveInactiveIndicator(void)
{
    const LONG FLAG_ACTIVE = 1;
    const LONG PEN_BG_DARK = 2;
    const LONG PEN_BG_LIGHT = 6;
    const LONG PEN_TEXT = 1;
    const LONG DRAWMODE_JAM1 = 0;
    const LONG DRAWMODE_COMPLEMENT = 1;
    const LONG X_LEFT = 40;
    const LONG X_LEFT_ACTIVE = 130;
    const LONG X_RIGHT_ACTIVE = 265;
    const LONG Y_TOP = 68;
    const LONG Y_BOTTOM = 98;
    const LONG TEXT_Y = 90;
    const LONG INVERTED_LEFT = (LONG)(unsigned char)(~110);
    LONG x1a;
    LONG x2a;
    LONG x1b;
    LONG x2b;

    if (ED_AdActiveFlag != ED_ActiveIndicatorCachedState) {
        if ((ED_AdActiveFlag - FLAG_ACTIVE) == 0) {
            x1a = INVERTED_LEFT;
            x2a = X_RIGHT_ACTIVE;
            x1b = X_LEFT;
            x2b = X_LEFT_ACTIVE;
        } else {
            x1a = X_LEFT;
            x2a = X_LEFT_ACTIVE;
            x1b = INVERTED_LEFT;
            x2b = X_RIGHT_ACTIVE;
        }

        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_BG_DARK);
        _LVORectFill(Global_REF_RASTPORT_1, x1a, Y_TOP, x2a, Y_BOTTOM);

        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_BG_LIGHT);
        _LVORectFill(Global_REF_RASTPORT_1, x1b, Y_TOP, x2b, Y_BOTTOM);

        _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_JAM1);
        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_TEXT);

        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, TEXT_Y, X_LEFT, Global_STR_ACTIVE_INACTIVE);

        ED_ActiveIndicatorCachedState = ED_AdActiveFlag;
    }

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_TEXT);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_COMPLEMENT);
}
