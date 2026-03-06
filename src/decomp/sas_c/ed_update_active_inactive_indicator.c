typedef signed long LONG;

extern LONG ED_AdActiveFlag;
extern LONG ED_ActiveIndicatorCachedState;

extern void *Global_REF_RASTPORT_1;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern LONG _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVOSetDrMd(void *gfxBase, void *rastPort, LONG mode);
extern void _LVORectFill(void *rastPort, LONG x1, LONG y1, LONG x2, LONG y2);
extern LONG DISPLIB_DisplayTextAtPosition(void *rastPort, LONG y, LONG x, const char *text);

extern const char Global_STR_ACTIVE_INACTIVE[];

void ED_UpdateActiveInactiveIndicator(void)
{
    LONG x1a;
    LONG x2a;
    LONG x1b;
    LONG x2b;

    if (ED_AdActiveFlag != ED_ActiveIndicatorCachedState) {
        if ((ED_AdActiveFlag - 1) == 0) {
            x1a = (LONG)(unsigned char)(~110);
            x2a = 265;
            x1b = 40;
            x2b = 130;
        } else {
            x1a = 40;
            x2a = 130;
            x1b = (LONG)(unsigned char)(~110);
            x2b = 265;
        }

        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 2);
        _LVORectFill(Global_REF_RASTPORT_1, x1a, 68, x2a, 98);

        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 6);
        _LVORectFill(Global_REF_RASTPORT_1, x1b, 68, x2b, 98);

        _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 0);
        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);

        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 90, 40, Global_STR_ACTIVE_INACTIVE);

        ED_ActiveIndicatorCachedState = ED_AdActiveFlag;
    }

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
}
