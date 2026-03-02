#include "esq_types.h"

extern u8 CONFIG_ParseiniLogoScanEnabledFlag;
extern s16 Global_UIBusyFlag;
extern s16 CTASKS_IffTaskDoneFlag;
extern u8 GCOMMAND_HighlightMessageSlotTable[];
extern void *Global_REF_DOS_LIBRARY_2;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_REF_RASTPORT_1;
extern void *Global_REF_RASTPORT_2;
extern void *NEWGRID_MainRastPortPtr;
extern void *NEWGRID_HeaderRastPortPtr;
extern void *Global_HANDLE_H26F_FONT;
extern void *Global_HANDLE_PREVUEC_FONT;
extern void *Global_HANDLE_PREVUE_FONT;
extern void *Global_STRUCT_TEXTATTR_H26F_FONT;
extern void *Global_STRUCT_TEXTATTR_PREVUEC_FONT;
extern void *Global_STRUCT_TEXTATTR_PREVUE_FONT;
extern void *WDISP_WeatherStatusBrushListHead;
extern void *PARSEINI_BannerBrushResourceHead;
extern const char Global_STR_PERCENT_S_2[];
extern const char Global_STR_DF0_GRADIENT_INI_3[];
extern const char Global_STR_DF0_BANNER_INI_2[];
extern const char Global_STR_DF0_BANNER_INI_3[];
extern const char Global_STR_DF0_DEFAULT_INI_2[];
extern const char Global_STR_DF0_SOURCECFG_INI_1[];

s32 PARSEINI_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...) __attribute__((noinline));
s32 _LVOExecute(const char *command, s32 in_fh, s32 out_fh) __attribute__((noinline));
s32 PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0(void) __attribute__((noinline));
s32 PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit1(void) __attribute__((noinline));
void PARSEINI_ScanLogoDirectory(void) __attribute__((noinline));
void PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable(void) __attribute__((noinline));
s32 PARSEINI_TestMemoryAndOpenTopazFont(void **slot, void *text_attr) __attribute__((noinline));
void _LVOSetFont(void *rastport, void *font) __attribute__((noinline));
s32 SCRIPT3_JMPTBL_MATH_Mulu32(s32 a, s32 b) __attribute__((noinline));
void TLIBA3_SetFontForAllViewModes(void *font) __attribute__((noinline));
void PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk(void) __attribute__((noinline));
void PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey(s32 code) __attribute__((noinline));
s32 PARSEINI_ParseIniBufferAndDispatch(const char *path) __attribute__((noinline));
s32 SCRIPT_CheckPathExists(const char *path) __attribute__((noinline));
void PARSEINI_JMPTBL_BRUSH_FreeBrushList(void *head, s32 clear_code) __attribute__((noinline));
void PARSEINI_JMPTBL_BRUSH_FreeBrushResources(void *head) __attribute__((noinline));
void PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad(s32 code) __attribute__((noinline));
void PARSEINI_JMPTBL_ED1_EnterEscMenu(void) __attribute__((noinline));
void PARSEINI_JMPTBL_ED1_ExitEscMenu(void) __attribute__((noinline));
void PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen(void) __attribute__((noinline));
void PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion(void) __attribute__((noinline));
void TEXTDISP_ApplySourceConfigAllEntries(void) __attribute__((noinline));

s32 PARSEINI_HandleFontCommand(const char *command) __attribute__((noinline, used));

s32 PARSEINI_HandleFontCommand(const char *command)
{
    const char *p = command;
    char tmp[80];
    s32 i;

    if ((u8)*p++ != (u8)'3') {
        return 0;
    }

    switch ((u8)*p++) {
    case (u8)'2':
        PARSEINI_JMPTBL_WDISP_SPrintf(tmp, Global_STR_PERCENT_S_2, p);
        _LVOExecute(tmp, 0, 0);
        break;

    case (u8)'3': {
        u8 sub = (u8)*p++;

        switch (sub) {
        case (u8)'4':
            PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0();
            break;
        case (u8)'5':
            if (CONFIG_ParseiniLogoScanEnabledFlag == (u8)'Y') {
                PARSEINI_ScanLogoDirectory();
            }
            PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit1();
            break;
        case (u8)'6':
            PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable();
            break;
        case (u8)'7':
            if (PARSEINI_TestMemoryAndOpenTopazFont(&Global_HANDLE_H26F_FONT, Global_STRUCT_TEXTATTR_H26F_FONT) != 0 &&
                Global_UIBusyFlag != 0) {
                _LVOSetFont(Global_REF_RASTPORT_1, Global_HANDLE_H26F_FONT);
            }
            break;
        case (u8)'8':
            if (PARSEINI_TestMemoryAndOpenTopazFont(&Global_HANDLE_PREVUEC_FONT, Global_STRUCT_TEXTATTR_PREVUEC_FONT) != 0) {
                _LVOSetFont(Global_REF_RASTPORT_1, Global_HANDLE_PREVUEC_FONT);
                _LVOSetFont(Global_REF_RASTPORT_2, Global_HANDLE_PREVUEC_FONT);
                _LVOSetFont(NEWGRID_MainRastPortPtr, Global_HANDLE_PREVUEC_FONT);
                _LVOSetFont(NEWGRID_HeaderRastPortPtr, Global_HANDLE_PREVUEC_FONT);

                for (i = 0; i < 4; i++) {
                    s32 off = SCRIPT3_JMPTBL_MATH_Mulu32(i, 160);
                    _LVOSetFont((void *)(GCOMMAND_HighlightMessageSlotTable + off + 60), Global_HANDLE_PREVUEC_FONT);
                }

                TLIBA3_SetFontForAllViewModes(Global_HANDLE_PREVUEC_FONT);
            }
            break;
        case (u8)'9':
            PARSEINI_TestMemoryAndOpenTopazFont(&Global_HANDLE_PREVUE_FONT, Global_STRUCT_TEXTATTR_PREVUE_FONT);
            break;
        case (u8)'Q':
            PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk();
            break;
        case (u8)'a':
            PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey(97);
            break;
        case (u8)'b':
            PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_GRADIENT_INI_3);
            break;
        case (u8)'c':
            if (SCRIPT_CheckPathExists(Global_STR_DF0_BANNER_INI_2) != 0) {
                while (CTASKS_IffTaskDoneFlag == 0) {
                }
                PARSEINI_JMPTBL_BRUSH_FreeBrushList(WDISP_WeatherStatusBrushListHead, 0);
                PARSEINI_JMPTBL_BRUSH_FreeBrushResources(PARSEINI_BannerBrushResourceHead);
                PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_BANNER_INI_3);
                PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad(1);
            }
            break;
        case (u8)'d':
            PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_DEFAULT_INI_2);
            break;
        case (u8)'s':
            PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_SOURCECFG_INI_1);
            TEXTDISP_ApplySourceConfigAllEntries();
            break;
        default:
            break;
        }
        break;
    }

    case (u8)'4': {
        u8 sub = (u8)*p++;
        if (sub == (u8)'0') {
            PARSEINI_JMPTBL_ED1_EnterEscMenu();
            PARSEINI_JMPTBL_ED1_ExitEscMenu();
        } else if (sub == (u8)'1') {
            PARSEINI_JMPTBL_ED1_EnterEscMenu();
            PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen();
        } else if (sub == (u8)'2') {
            PARSEINI_JMPTBL_ED1_EnterEscMenu();
            PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion();
        }
        break;
    }

    default:
        break;
    }

    return 0;
}
