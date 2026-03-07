typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE CONFIG_ParseiniLogoScanEnabledFlag;
extern LONG Global_UIBusyFlag;
extern LONG Global_REF_DOS_LIBRARY_2;

extern const char Global_STR_PERCENT_S_2[];

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

extern void PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit0(void);
extern void PARSEINI_JMPTBL_ED1_WaitForFlagAndClearBit1(void);
extern void PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable(void);
extern void PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk(void);
extern void PARSEINI_JMPTBL_ED1_EnterEscMenu(void);
extern void PARSEINI_JMPTBL_ED1_ExitEscMenu(void);
extern void PARSEINI_JMPTBL_ED1_DrawDiagnosticsScreen(void);
extern void PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion(void);

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
            PARSEINI_JMPTBL_ESQFUNC_RebuildPwBrushListFromTagTableFromTagTable();
            return;
        }
        if (c2 == (UBYTE)'7') {
            if (PARSEINI_TestMemoryAndOpenTopazFont(&Global_HANDLE_H26F_FONT, Global_STRUCT_TEXTATTR_H26F_FONT) != 0 &&
                Global_UIBusyFlag != 0) {
                return;
            }
            return;
        }
        if (c2 == (UBYTE)'8') {
            PARSEINI_TestMemoryAndOpenTopazFont(&Global_HANDLE_PREVUEC_FONT, Global_STRUCT_TEXTATTR_PREVUEC_FONT);
            return;
        }
        if (c2 == (UBYTE)'9') {
            PARSEINI_TestMemoryAndOpenTopazFont(&Global_HANDLE_PREVUE_FONT, Global_STRUCT_TEXTATTR_PREVUE_FONT);
            return;
        }
        if (c2 == (UBYTE)'R') {
            PARSEINI_JMPTBL_DISKIO2_ParseIniFileFromDisk();
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
            PARSEINI_JMPTBL_ESQFUNC_DrawEscMenuVersion();
            return;
        }
    }
}
