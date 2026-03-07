typedef signed long LONG;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_REF_RASTPORT_1;

extern const char Global_STR_SAVE_ALL_TO_DISK[];
extern const char Global_STR_SAVE_DATA_TO_DISK[];
extern const char Global_STR_LOAD_TEXT_ADS_FROM_DISK[];
extern const char Global_STR_REBOOT_COMPUTER[];

extern LONG _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVOSetDrMd(void *gfxBase, void *rastPort, LONG mode);
extern LONG DISPLIB_DisplayTextAtPosition(void *rastPort, LONG y, LONG x, const char *text);

void ED_DrawSpecialFunctionsMenu(void)
{
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 0);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 90, 40, Global_STR_SAVE_ALL_TO_DISK);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 120, 40, Global_STR_SAVE_DATA_TO_DISK);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 150, 40, Global_STR_LOAD_TEXT_ADS_FROM_DISK);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 180, 40, Global_STR_REBOOT_COMPUTER);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
}
