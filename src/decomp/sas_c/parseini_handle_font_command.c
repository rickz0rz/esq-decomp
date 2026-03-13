typedef signed long LONG;
typedef unsigned char UBYTE;
typedef unsigned short UWORD;

extern UBYTE CONFIG_ParseiniLogoScanEnabledFlag;
extern LONG Global_UIBusyFlag;
extern LONG Global_REF_DOS_LIBRARY_2;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern char *Global_REF_RASTPORT_1;
extern char *Global_REF_RASTPORT_2;
extern void *WDISP_DisplayContextBase;
extern char *NEWGRID_MainRastPortPtr;
extern char *NEWGRID_HeaderRastPortPtr;
extern UBYTE GCOMMAND_HighlightMessageSlotTable[];
extern UWORD CTASKS_IffTaskDoneFlag;
extern void *WDISP_WeatherStatusBrushListHead;
extern void *PARSEINI_BannerBrushResourceHead;

extern const char Global_STR_PERCENT_S_2[];
extern const char Global_STR_DF0_GRADIENT_INI_3[];
extern const char Global_STR_DF0_BANNER_INI_2[];
extern const char Global_STR_DF0_BANNER_INI_3[];
extern const char Global_STR_DF0_DEFAULT_INI_2[];
extern const char Global_STR_DF0_SOURCECFG_INI_1[];

extern void PARSEINI_ScanLogoDirectory(void);
extern LONG PARSEINI_TestMemoryAndOpenTopazFont(void **fontHandleOut, void *textAttr);

extern void *Global_HANDLE_H26F_FONT;
extern void *Global_HANDLE_PREVUEC_FONT;
extern void *Global_HANDLE_PREVUE_FONT;
extern void *Global_STRUCT_TEXTATTR_H26F_FONT;
extern void *Global_STRUCT_TEXTATTR_PREVUEC_FONT;
extern void *Global_STRUCT_TEXTATTR_PREVUE_FONT;

extern LONG PARSEINI_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, const char *arg);
extern LONG _LVOExecute(const char *command, LONG input, LONG output);
extern void _LVOSetFont(void *graphicsBase, char *rastPort, void *font);
extern LONG SCRIPT3_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern void TLIBA3_SetFontForAllViewModes(void *font);
extern LONG SCRIPT_CheckPathExists(const char *path);
extern LONG PARSEINI_ParseIniBufferAndDispatch(const char *path);
extern void TEXTDISP_ApplySourceConfigAllEntries(void);
extern void ESQIFF_HandleBrushIniReloadHotkey(LONG hotkey);
extern void ESQIFF_QueueIffBrushLoad(short mode);
extern void BRUSH_FreeBrushList(void **headPtr, LONG flags);
extern void BRUSH_FreeBrushResources(void **headPtr);

extern void PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0(void);
extern void PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit1(void);
extern void ESQFUNC_RebuildPwBrushListFromTagTable(void);
extern void PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk(void);
extern void PARSEINI_JMPTBL_ED1_EnterEscMenu(void);
extern void PARSEINI_JMPTBL_ED1_ExitEscMenu(void);
extern void PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen(void);
extern void ESQFUNC_DrawEscMenuVersion(void);

typedef struct PARSEINI_DisplayContext {
    UBYTE pad0[2];
    UBYTE rastPort[1];
} PARSEINI_DisplayContext;

void PARSEINI_HandleFontCommand(const char *command)
{
    UBYTE c0;
    UBYTE c1;
    UBYTE c2;
    char cmdBuf[80];

    c0 = (UBYTE)*command++;
    if (c0 != (UBYTE)'3') {
        return;
    }

    c1 = (UBYTE)*command++;
    if (c1 == (UBYTE)'2') {
        PARSEINI_JMPTBL_WDISP_SPrintf(cmdBuf, Global_STR_PERCENT_S_2, command);
        _LVOExecute(cmdBuf, 0, 0);
        return;
    }

    if (c1 == (UBYTE)'3') {
        c2 = (UBYTE)*command++;
        if (c2 == (UBYTE)'4') {
            PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0();
            return;
        }
        if (c2 == (UBYTE)'5') {
            if (CONFIG_ParseiniLogoScanEnabledFlag == (UBYTE)89) {
                PARSEINI_ScanLogoDirectory();
            }
            PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit1();
            return;
        }
        if (c2 == (UBYTE)'6') {
            ESQFUNC_RebuildPwBrushListFromTagTable();
            return;
        }
        if (c2 == (UBYTE)'7') {
            if (PARSEINI_TestMemoryAndOpenTopazFont(&Global_HANDLE_H26F_FONT, Global_STRUCT_TEXTATTR_H26F_FONT) != 0) {
                if (Global_UIBusyFlag != 0) {
                    _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, Global_HANDLE_H26F_FONT);
                }
            }
            return;
        }
        if (c2 == (UBYTE)'8') {
            LONG i;
            PARSEINI_DisplayContext *context;

            if (PARSEINI_TestMemoryAndOpenTopazFont(&Global_HANDLE_PREVUEC_FONT, Global_STRUCT_TEXTATTR_PREVUEC_FONT) == 0) {
                return;
            }

            context = (PARSEINI_DisplayContext *)WDISP_DisplayContextBase;
            _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, (char *)context->rastPort, Global_HANDLE_PREVUEC_FONT);
            _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, Global_HANDLE_PREVUEC_FONT);
            _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2, Global_HANDLE_PREVUEC_FONT);
            _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, NEWGRID_MainRastPortPtr, Global_HANDLE_PREVUEC_FONT);
            _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, NEWGRID_HeaderRastPortPtr, Global_HANDLE_PREVUEC_FONT);

            for (i = 0; i < 4; ++i) {
                LONG offset = SCRIPT3_JMPTBL_MATH_Mulu32(i, 160);
                _LVOSetFont(
                    Global_REF_GRAPHICS_LIBRARY,
                    (char *)(GCOMMAND_HighlightMessageSlotTable + offset + 60),
                    Global_HANDLE_PREVUEC_FONT);
            }

            TLIBA3_SetFontForAllViewModes(Global_HANDLE_PREVUEC_FONT);
            return;
        }
        if (c2 == (UBYTE)'9') {
            PARSEINI_TestMemoryAndOpenTopazFont(&Global_HANDLE_PREVUE_FONT, Global_STRUCT_TEXTATTR_PREVUE_FONT);
            return;
        }
        if (c2 == (UBYTE)'Q') {
            PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk();
            return;
        }
        if (c2 == (UBYTE)'a') {
            ESQIFF_HandleBrushIniReloadHotkey(97);
            return;
        }
        if (c2 == (UBYTE)'b') {
            PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_GRADIENT_INI_3);
            return;
        }
        if (c2 == (UBYTE)'c') {
            if (SCRIPT_CheckPathExists(Global_STR_DF0_BANNER_INI_2) == 0) {
                return;
            }

            while (CTASKS_IffTaskDoneFlag == 0) {
            }

            BRUSH_FreeBrushList(&WDISP_WeatherStatusBrushListHead, 0);
            BRUSH_FreeBrushResources(&PARSEINI_BannerBrushResourceHead);
            PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_BANNER_INI_3);
            ESQIFF_QueueIffBrushLoad(1);
            return;
        }
        if (c2 == (UBYTE)'d') {
            PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_DEFAULT_INI_2);
            return;
        }
        if (c2 == (UBYTE)'s') {
            PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_SOURCECFG_INI_1);
            TEXTDISP_ApplySourceConfigAllEntries();
            return;
        }
        return;
    }

    if (c1 == (UBYTE)'4') {
        c2 = (UBYTE)*command++;
        if (c2 == (UBYTE)'0') {
            PARSEINI_JMPTBL_ED1_EnterEscMenu();
            PARSEINI_JMPTBL_ED1_ExitEscMenu();
            return;
        }
        if (c2 == (UBYTE)'1') {
            PARSEINI_JMPTBL_ED1_EnterEscMenu();
            PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen();
            return;
        }
        if (c2 == (UBYTE)'2') {
            PARSEINI_JMPTBL_ED1_EnterEscMenu();
            ESQFUNC_DrawEscMenuVersion();
            return;
        }
    }
}
