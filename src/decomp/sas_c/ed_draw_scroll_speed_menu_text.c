typedef signed long LONG;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_REF_RASTPORT_1;

extern unsigned char ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED;
extern const char Global_STR_SPEED_ZERO_NOT_AVAILABLE[];
extern const char Global_STR_SPEED_ONE_NOT_AVAILABLE[];
extern const char Global_STR_SCROLL_SPEED_2[];
extern const char Global_STR_SCROLL_SPEED_3[];
extern const char Global_STR_SCROLL_SPEED_4[];
extern const char Global_STR_SCROLL_SPEED_5[];
extern const char Global_STR_SCROLL_SPEED_6[];
extern const char Global_STR_SCROLL_SPEED_7[];

extern LONG _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVOSetDrMd(void *gfxBase, void *rastPort, LONG mode);
extern LONG GROUP_AM_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...);
extern LONG DISPLIB_DisplayTextAtPosition(void *rastPort, LONG y, LONG x, const char *text);

void ED_DrawScrollSpeedMenuText(void)
{
    static const char kFmtPercentC[] = "%c";
    char statusLine[80];

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 0);

    GROUP_AM_JMPTBL_WDISP_SPrintf(
        statusLine,
        kFmtPercentC,
        (LONG)ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 90, 40, statusLine);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 120, 40, Global_STR_SPEED_ZERO_NOT_AVAILABLE);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 150, 40, Global_STR_SPEED_ONE_NOT_AVAILABLE);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 180, 40, Global_STR_SCROLL_SPEED_2);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 210, 40, Global_STR_SCROLL_SPEED_3);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 240, 40, Global_STR_SCROLL_SPEED_4);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 270, 40, Global_STR_SCROLL_SPEED_5);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 300, 40, Global_STR_SCROLL_SPEED_6);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 330, 40, Global_STR_SCROLL_SPEED_7);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
}
