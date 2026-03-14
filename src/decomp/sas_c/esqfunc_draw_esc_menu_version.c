#include <exec/types.h>
#define ESQFUNC_PRIMARY_PEN 1
#define ESQFUNC_PROMPT_PEN 3
#define ESQFUNC_DRAW_MODE_JAM1 1
#define ESQFUNC_VERSION_TEXT_X 175
#define ESQFUNC_BUILD_TEXT_Y 330
#define ESQFUNC_ROM_TEXT_Y 360
#define ESQFUNC_PROMPT_TEXT_Y 390

extern WORD ED_DiagnosticsScreenActive;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern char *Global_REF_RASTPORT_1;
extern LONG Global_LONG_BUILD_NUMBER;
extern LONG Global_LONG_ROM_VERSION_CHECK;
extern const char *Global_PTR_STR_BUILD_ID;

extern const char Global_STR_BUILD_NUMBER_FORMATTED[];
extern const char Global_STR_ROM_VERSION_FORMATTED[];
extern const char Global_STR_ROM_VERSION_1_3[];
extern const char Global_STR_ROM_VERSION_2_04[];
extern const char Global_STR_PUSH_ANY_KEY_TO_CONTINUE_1[];

extern LONG WDISP_SPrintf(char *dst, const char *fmt, ...);
extern void DISPLIB_DisplayTextAtPosition(char *rastPort, LONG y, LONG x, const char *text);
extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);

void ESQFUNC_DrawEscMenuVersion(void)
{
    char versionLineBuffer[81];
    const char *romVersionString;

    ED_DiagnosticsScreenActive = 0;

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ESQFUNC_PRIMARY_PEN);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ESQFUNC_DRAW_MODE_JAM1);

    WDISP_SPrintf(
        versionLineBuffer,
        Global_STR_BUILD_NUMBER_FORMATTED,
        Global_LONG_BUILD_NUMBER,
        Global_PTR_STR_BUILD_ID);
    DISPLIB_DisplayTextAtPosition(
        Global_REF_RASTPORT_1,
        ESQFUNC_BUILD_TEXT_Y,
        ESQFUNC_VERSION_TEXT_X,
        versionLineBuffer);

    if (Global_LONG_ROM_VERSION_CHECK == 1) {
        romVersionString = Global_STR_ROM_VERSION_1_3;
    } else {
        romVersionString = Global_STR_ROM_VERSION_2_04;
    }

    WDISP_SPrintf(
        versionLineBuffer,
        Global_STR_ROM_VERSION_FORMATTED,
        romVersionString);
    DISPLIB_DisplayTextAtPosition(
        Global_REF_RASTPORT_1,
        ESQFUNC_ROM_TEXT_Y,
        ESQFUNC_VERSION_TEXT_X,
        versionLineBuffer);

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ESQFUNC_PROMPT_PEN);
    DISPLIB_DisplayTextAtPosition(
        Global_REF_RASTPORT_1,
        ESQFUNC_PROMPT_TEXT_Y,
        ESQFUNC_VERSION_TEXT_X,
        Global_STR_PUSH_ANY_KEY_TO_CONTINUE_1);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, ESQFUNC_PRIMARY_PEN);
}
