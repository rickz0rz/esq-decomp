#include <graphics/rastport.h>

extern char *ESQIFF_RecordBufferPtr;
extern LONG Global_LONG_PATCH_VERSION_NUMBER;
extern WORD Global_UIBusyFlag;
extern WORD ED_DiagnosticsScreenActive;
extern WORD ESQPARS2_ReadModeFlags;

extern struct RastPort *Global_REF_RASTPORT_1;
extern void *Global_REF_696_400_BITMAP;

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
extern void DISPLIB_DisplayTextAtPosition(char *rp, WORD x, WORD y, const char *text);
extern char *STRING_AppendAtNull(char *dst, const char *src);

extern void Disable(void);
extern void Enable(void);
extern void SetAPen(struct RastPort *rp, LONG pen);
extern void RectFill(struct RastPort *rp, LONG x1, LONG y1, LONG x2, LONG y2);

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

    Global_REF_RASTPORT_1->BitMap = Global_REF_696_400_BITMAP;
    ED_DiagnosticsScreenActive = 0;

    SetAPen(Global_REF_RASTPORT_1, 2);
    RectFill(Global_REF_RASTPORT_1, 0, 60, 679, (UBYTE)(~100));
    SetAPen(Global_REF_RASTPORT_1, 3);

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
