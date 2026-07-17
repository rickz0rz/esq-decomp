#include <graphics/rastport.h>

extern char *ESQIFF_RecordBufferPtr;
extern LONG Global_LONG_PATCH_VERSION_NUMBER;
extern WORD Global_UIBusyFlag;
extern WORD ED_DiagnosticsScreenActive;
extern WORD ESQPARS2_ReadModeFlags;

extern struct RastPort *Global_REF_RASTPORT_1;
extern struct BitMap Global_REF_696_400_BITMAP;  /* a STRUCT, not a pointer (wdisp.s) */

extern const char Global_STR_MAJOR_MINOR_VERSION_1[];
extern const char ESQIFF_FMT_PCT_S_DOT_PCT_LD[];
extern const char Global_STR_MAJOR_MINOR_VERSION_2[];
extern const char ESQIFF_FMT_YOUR_VERSION_IS_PCT_S_DOT_PCT_LD[];
extern const char ESQIFF_STR_INCORRECT_VERSION_PLEASE_CORRECT_ASA[];
extern const char ESQIFF_STR_CORRECT_VERSION_IS[];
extern const char Global_STR_APOSTROPHE[];

extern LONG WDISP_SPrintf(char *dst, const char *fmt, ...);
extern UBYTE ESQ_WildcardMatch(const char *pattern, const char *text);
extern void GCOMMAND_SeedBannerFromPrefs(void);
/* DISPLIB_DisplayTextAtPosition takes LONG x,y (WORD here truncated the pushed args). */
extern void DISPLIB_DisplayTextAtPosition(char *rp, LONG x, LONG y, const char *text);
extern char *STRING_AppendAtNull(char *dst, const char *src);

extern void Disable(void);
extern void Enable(void);
/* base-explicit graphics (bare SetAPen/RectFill use amiga.lib's uninitialized _GfxBase). */
extern void *Global_REF_GRAPHICS_LIBRARY;
extern void _LVOSetAPen(void *graphicsBase, void *rastPort, LONG pen);
extern void _LVORectFill(void *graphicsBase, void *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);

void ESQIFF2_ShowVersionMismatchOverlay(void)
{
    char textbuf[40];
    char *p;
    LONG i;

    ESQIFF_RecordBufferPtr[20] = (char)0;
    WDISP_SPrintf(textbuf, ESQIFF_FMT_PCT_S_DOT_PCT_LD, Global_STR_MAJOR_MINOR_VERSION_1, Global_LONG_PATCH_VERSION_NUMBER);

    if (ESQ_WildcardMatch(textbuf, ESQIFF_RecordBufferPtr + 1) == 0) {
        return;
    }

    if (Global_UIBusyFlag != 0 && ED_DiagnosticsScreenActive == 0) {
        return;
    }

    Disable();
    ESQPARS2_ReadModeFlags = 0x100;
    GCOMMAND_SeedBannerFromPrefs();
    Enable();

    Global_REF_RASTPORT_1->BitMap = (struct BitMap *)&Global_REF_696_400_BITMAP;
    ED_DiagnosticsScreenActive = 0;

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 2);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 0, 60, 679, (UBYTE)(~100));
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 3);

    DISPLIB_DisplayTextAtPosition((char *)Global_REF_RASTPORT_1, 30, 90, ESQIFF_STR_INCORRECT_VERSION_PLEASE_CORRECT_ASA);

    WDISP_SPrintf(textbuf, ESQIFF_FMT_YOUR_VERSION_IS_PCT_S_DOT_PCT_LD, Global_STR_MAJOR_MINOR_VERSION_2, Global_LONG_PATCH_VERSION_NUMBER);
    DISPLIB_DisplayTextAtPosition((char *)Global_REF_RASTPORT_1, 30, 120, textbuf);

    p = textbuf;
    for (i = 0; i <= 4; ++i) {
        *(LONG *)p = *(const LONG *)(ESQIFF_STR_CORRECT_VERSION_IS + (i * 4));
        p += 4;
    }
    *p = '\0';
    STRING_AppendAtNull(textbuf, ESQIFF_RecordBufferPtr + 1);
    STRING_AppendAtNull(textbuf, Global_STR_APOSTROPHE);

    DISPLIB_DisplayTextAtPosition((char *)Global_REF_RASTPORT_1, 30, 150, textbuf);
}
