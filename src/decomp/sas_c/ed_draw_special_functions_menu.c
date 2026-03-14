#include <exec/types.h>
extern void *Global_REF_GRAPHICS_LIBRARY;
extern char *Global_REF_RASTPORT_1;

extern const char Global_STR_SAVE_ALL_TO_DISK[];
extern const char Global_STR_SAVE_DATA_TO_DISK[];
extern const char Global_STR_LOAD_TEXT_ADS_FROM_DISK[];
extern const char Global_STR_REBOOT_COMPUTER[];

extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);
extern void DISPLIB_DisplayTextAtPosition(char *rastPort, LONG y, LONG x, const char *text);

void ED_DrawSpecialFunctionsMenu(void)
{
    const LONG PEN_PRIMARY = 1;
    const LONG DRAWMODE_JAM1 = 0;
    const LONG DRAWMODE_JAM2 = 1;
    const LONG TEXT_X = 40;
    const LONG ROW0_Y = 90;
    const LONG ROW_STEP_Y = 30;

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, PEN_PRIMARY);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_JAM1);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW0_Y + (ROW_STEP_Y * 0), TEXT_X, Global_STR_SAVE_ALL_TO_DISK);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW0_Y + (ROW_STEP_Y * 1), TEXT_X, Global_STR_SAVE_DATA_TO_DISK);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW0_Y + (ROW_STEP_Y * 2), TEXT_X, Global_STR_LOAD_TEXT_ADS_FROM_DISK);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, ROW0_Y + (ROW_STEP_Y * 3), TEXT_X, Global_STR_REBOOT_COMPUTER);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, DRAWMODE_JAM2);
}
