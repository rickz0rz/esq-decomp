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
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 300, 40, Global_STR_VIN_BCK_FWD_SSPD_AD_LINE);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 330, 90, Global_STR_TZ_DST_CONT_TXT_GRPH);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 3);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 100, 300);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ED_DiagVinModeChar, 1);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 190, 300);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ESQ_STR_B, 1);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 280, 300);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ESQ_STR_E, 1);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 385, 300);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED, 1);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 475, 300);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ESQ_TAG_36, 2);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 595, 300);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ED_DiagScrollSpeedChar, 1);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 150, 330);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ESQ_STR_6, 1);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 240, 330);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ESQ_SecondarySlotModeFlagChar, 1);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 345, 330);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ESQ_STR_Y, 1);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 450, 330);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ED_DiagTextModeChar, 1);

    _LVOMove(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 555, 330);
    _LVOText(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ED_DiagGraphModeChar, 1);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
}
