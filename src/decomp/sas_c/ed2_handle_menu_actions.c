typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern LONG ED_StateRingIndex;
extern UBYTE ED_StateRingTable[];
extern UBYTE ED_LastKeyCode;

extern UWORD ESQPARS2_StateIndex;
extern UWORD ED2_SelectedEntryIndex;
extern UWORD ED2_SelectedFlagByteOffset;
extern UBYTE ED_MenuStateId;
extern UWORD SCRIPT_StatusRefreshHoldFlag;

extern UBYTE WDISP_WeatherStatusCountdown;
extern UBYTE WDISP_WeatherStatusColorCode;
extern UBYTE WDISP_WeatherStatusBrushIndex;
extern UWORD WDISP_WeatherStatusDigitChar;
extern UWORD WDISP_WeatherCycleOffsetCount;
extern UBYTE CLEANUP_DiagOverlayAutoRefreshFlag;

extern UBYTE CONFIG_RefreshIntervalMinutes;
extern UBYTE ED_SavedCtasksIntervalByte;
extern LONG CONFIG_RefreshIntervalSeconds;
extern UWORD CONFIG_BannerCopperHeadByte;
extern UBYTE HIGHLIGHT_CustomValue;
extern LONG WDISP_DisplayContextBase;

extern LONG LOCAVAIL_FilterStep;
extern char *Global_REF_RASTPORT_1;
extern void *Global_REF_DOS_LIBRARY_2;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern const char Global_STR_DF0_CLOCK_CMD[];

extern void ED1_DrawStatusLine1(void);
extern void ED1_DrawStatusLine2(void);
extern void ED2_DrawEntrySummaryPanel(void);
extern void ED2_DrawEntryDetailsPanel(void);
extern void ED1_EnterEscMenu(void);
extern void ED_InitRastport2Pens(void);
extern void ED_DrawESCMenuBottomHelp(void);
extern void ED_DrawESCMenuHelpText(void);

extern LONG _LVORead(void *dosBase, LONG fh, void *buf, LONG len);
extern LONG _LVOClose(void *dosBase, LONG fh);
extern LONG ESQIFF_JMPTBL_DOS_OpenFileWithMode(const char *path, LONG mode);
extern void GROUP_AK_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist(const UBYTE *ptr);

extern LONG ESQIFF_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern LONG GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar(void);
extern void ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(LONG nextChar, LONG flags);
extern void GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom(void);
extern void GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(void);
extern LONG ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(LONG mode, LONG a, LONG b);

static void restore_display_state(void)
{
    ED_DrawESCMenuHelpText();
    ED_DrawESCMenuBottomHelp();
}

void ED2_HandleMenuActions(void)
{
    UBYTE key;

    key = ED_StateRingTable[ED_StateRingIndex * 5];
    ED_LastKeyCode = key;

    switch (key) {
    case 2:
        ED1_DrawStatusLine1();
        break;
    case 3:
        ESQPARS2_StateIndex += 1;
        ED1_DrawStatusLine1();
        break;
    case 4:
        if (ESQPARS2_StateIndex != 0) {
            ESQPARS2_StateIndex -= 1;
        }
        ED1_DrawStatusLine1();
        break;
    case 5:
        ED2_SelectedEntryIndex += 1;
        ED2_DrawEntrySummaryPanel();
        break;
    case 6:
        ED2_SelectedEntryIndex -= 1;
        ED2_DrawEntrySummaryPanel();
        break;
    case 7:
        ED2_SelectedFlagByteOffset += 1;
        ED2_DrawEntryDetailsPanel();
        break;
    case 8:
        ED2_SelectedFlagByteOffset -= 1;
        ED2_DrawEntryDetailsPanel();
        break;
    case 20:
        WDISP_WeatherStatusCountdown = 0x3c;
        WDISP_WeatherStatusColorCode = 1;
        WDISP_WeatherStatusBrushIndex = 2;
        WDISP_WeatherStatusDigitChar = 0x32;
        WDISP_WeatherCycleOffsetCount = 0;
        break;
    case 21:
        if (CONFIG_RefreshIntervalMinutes != 0) {
            ED_SavedCtasksIntervalByte = CONFIG_RefreshIntervalMinutes;
            CONFIG_RefreshIntervalMinutes = 0;
        } else {
            CONFIG_RefreshIntervalMinutes = ED_SavedCtasksIntervalByte;
        }
        CONFIG_RefreshIntervalSeconds = ESQIFF_JMPTBL_MATH_Mulu32((LONG)CONFIG_RefreshIntervalMinutes, 60);
        break;
    case 22:
        ED1_EnterEscMenu();
        break;
    case 23: {
        LONG ch = GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar() - 1;
        ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(ch, 0);
        break;
    }
    case 24: {
        LONG ch = GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar() + 1;
        ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(ch, 0);
        break;
    }
    case 25:
        ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition((LONG)CONFIG_BannerCopperHeadByte, 0);
        break;
    case 26:
        HIGHLIGHT_CustomValue = 0x1f;
        GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom();
        break;
    case 27:
        WDISP_DisplayContextBase = ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(3, 0, 4);
        ED_InitRastport2Pens();
        GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight();
        SCRIPT_StatusRefreshHoldFlag = 1;
        break;
    case 28:
        ED_MenuStateId = 0x18;
        break;
    case 29:
        CLEANUP_DiagOverlayAutoRefreshFlag = (UBYTE)~CLEANUP_DiagOverlayAutoRefreshFlag;
        break;
    case 30: {
        LONG fh;
        UBYTE buf[50];
        LONG rd;
        LONG i;
        LONG sync;

        fh = ESQIFF_JMPTBL_DOS_OpenFileWithMode(Global_STR_DF0_CLOCK_CMD, 1005);
        if (fh != 0) {
            rd = _LVORead(Global_REF_DOS_LIBRARY_2, fh, buf, 50);
            sync = 0;
            for (i = 0; i < rd; i++) {
                if (sync == 0 && buf[i] == 'U') sync = 1;
                else if (sync == 1 && buf[i] == 0xAA) sync = 2;
                else if (sync == 2 && buf[i] == 'K') sync = 3;
                else if (sync == 3) {
                    GROUP_AK_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist(&buf[i]);
                    break;
                } else sync = 0;
            }
            _LVOClose(Global_REF_DOS_LIBRARY_2, fh);
        }
        break;
    }
    default:
        break;
    }

    restore_display_state();
}
