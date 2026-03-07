typedef signed long LONG;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_REF_RASTPORT_1;

extern char Global_STR_VIN_BCK_FWD_SSPD_AD_LINE[];
extern char Global_STR_TZ_DST_CONT_TXT_GRPH[];

extern char ED_DiagVinModeChar[];
extern char ESQ_STR_B[];
extern char ESQ_STR_E[];
extern char ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED[];
extern char ESQ_TAG_36[];
extern char ED_DiagScrollSpeedChar[];
extern char ESQ_STR_6[];
extern char ESQ_SecondarySlotModeFlagChar[];
extern char ESQ_STR_Y[];
extern char ED_DiagTextModeChar[];
extern char ED_DiagGraphModeChar[];

extern LONG _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVOSetDrMd(void *gfxBase, void *rastPort, LONG mode);
extern LONG _LVOMove(void *gfxBase, void *rastPort, LONG x, LONG y);
extern LONG _LVOText(void *gfxBase, void *rastPort, char *text, LONG len);
extern LONG DISPLIB_DisplayTextAtPosition(void *rastPort, LONG y, LONG x, const char *text);

void ED_DrawDiagnosticModeText(void)
{
    const LONG PEN_PRIMARY = 1;
    const LONG PEN_ACCENT = 3;
    const LONG DRAWMODE_JAM2 = 1;
    const LONG LINE1_Y = 300;
    const LONG LINE2_Y = 330;
    const LONG TEXT_X_LINE1 = 40;
    const LONG TEXT_X_LINE2 = 90;
    const LONG CHAR_LEN_1 = 1;
    const LONG CHAR_LEN_2 = 2;

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_PRIMARY);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_JAM2);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, LINE1_Y, TEXT_X_LINE1, Global_STR_VIN_BCK_FWD_SSPD_AD_LINE);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, LINE2_Y, TEXT_X_LINE2, Global_STR_TZ_DST_CONT_TXT_GRPH);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_ACCENT);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 100, LINE1_Y);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ED_DiagVinModeChar, CHAR_LEN_1);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 190, LINE1_Y);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ESQ_STR_B, CHAR_LEN_1);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 280, LINE1_Y);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ESQ_STR_E, CHAR_LEN_1);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 385, LINE1_Y);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED, CHAR_LEN_1);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 475, LINE1_Y);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ESQ_TAG_36, CHAR_LEN_2);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 595, LINE1_Y);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ED_DiagScrollSpeedChar, CHAR_LEN_1);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 150, LINE2_Y);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ESQ_STR_6, CHAR_LEN_1);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 240, LINE2_Y);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ESQ_SecondarySlotModeFlagChar, CHAR_LEN_1);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 345, LINE2_Y);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ESQ_STR_Y, CHAR_LEN_1);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 450, LINE2_Y);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ED_DiagTextModeChar, CHAR_LEN_1);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 555, LINE2_Y);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ED_DiagGraphModeChar, CHAR_LEN_1);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_PRIMARY);
}
