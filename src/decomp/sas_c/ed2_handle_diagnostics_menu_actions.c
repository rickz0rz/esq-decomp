typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern LONG ED_StateRingIndex;
extern UBYTE ED_StateRingTable[];
extern UBYTE ED_LastKeyCode;

extern LONG ED_DiagAvailMemMask;
extern LONG ED_DiagAvailMemPresetBits;
extern UWORD Global_WORD_MAX_VALUE;
extern UWORD CTRL_HDeltaMax;
extern UWORD ESQIFF_LineErrorCount;
extern UWORD DATACErrs;
extern UWORD ESQIFF_ParseAttemptCount;
extern UWORD SCRIPT_CtrlCmdLengthErrorCount;
extern UWORD SCRIPT_CtrlCmdChecksumErrorCount;
extern UWORD SCRIPT_CtrlCmdCount;

extern UBYTE ED_DiagTextModeChar;
extern UBYTE ED_DiagVinModeChar;
extern UBYTE ED_DiagScrollSpeedChar;
extern UBYTE ED_DiagGraphModeChar;
extern LONG ED_TextLimit;
extern LONG ED_BlockOffset;
extern UWORD ED_DiagnosticsViewMode;
extern UWORD ED_DiagnosticsScreenActive;
extern void *Global_REF_RASTPORT_1;

extern const char ED2_TAG_NRLS[];
extern const char ED2_STR_NYYLLZ[];
extern const char ED2_TAG_NYLRS[];
extern const char ED2_STR_SILENCE[];
extern const char ED2_STR_LEFT[];
extern const char ED2_STR_RIGHT[];
extern const char ED2_STR_BACKGROUND[];
extern const char ED2_STR_EXT_DOT_VIDEO_ONLY[];
extern const char ED2_STR_COMPUTER_ONLY[];
extern const char ED2_STR_OVERLAY_EXT_DOT_VIDEO[];
extern const char ED2_STR_NEGATIVE_VIDEO[];
extern const char ED2_STR_VIDEO_SWITCH[];
extern const char ED2_STR_OPEN[];
extern const char ED2_STR_CLOSED[];
extern const char ED2_STR_START_TAPE_VIDEO[];
extern const char ED2_STR_STOP[];

extern UBYTE ED_FindNextCharInTable(LONG ch, const char *table);
extern void ED_DrawDiagnosticModeText(void);
extern LONG ESQIFF_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern void GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides(void *rp);
extern void DISPLIB_DisplayTextAtPosition(void *rp, LONG x, LONG y, const char *text);
extern void GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(LONG value);
extern void GROUP_AK_JMPTBL_ESQ_SetCopperEffect_AllOn(void);
extern void GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(void);
extern void GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(void);
extern void GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Default(void);
extern UBYTE ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask(void);
extern void GROUP_AK_JMPTBL_SCRIPT_AssertCtrlLineNow(void);
extern void GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow(void);
extern void ED_DrawESCMenuBottomHelp(void);

void ED2_HandleDiagnosticsMenuActions(void)
{
    UBYTE key;

    key = ED_StateRingTable[ED_StateRingIndex * 5];
    ED_LastKeyCode = key;

    switch (key) {
    case 1:
        if ((ED_DiagAvailMemMask & 7) == 7) {
            ED_DiagAvailMemMask &= ~7;
        } else {
            ED_DiagAvailMemMask |= 7;
        }
        break;
    case 3:
        ED_DiagAvailMemMask &= ~7;
        ED_DiagAvailMemPresetBits |= (1 << 0);
        break;
    case 6:
        ED_DiagAvailMemMask &= ~7;
        ED_DiagAvailMemPresetBits |= (1 << 1);
        break;
    case 7:
        GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides(Global_REF_RASTPORT_1);
        break;
    case 13:
        Global_WORD_MAX_VALUE = 0;
        CTRL_HDeltaMax = 0;
        ESQIFF_LineErrorCount = 0;
        DATACErrs = 0;
        ESQIFF_ParseAttemptCount = 0;
        SCRIPT_CtrlCmdLengthErrorCount = 0;
        SCRIPT_CtrlCmdChecksumErrorCount = 0;
        SCRIPT_CtrlCmdCount = 0;
        break;
    case 28:
        ED_DiagTextModeChar = ED_FindNextCharInTable((LONG)ED_DiagTextModeChar, ED2_TAG_NRLS);
        ED_DrawDiagnosticModeText();
        break;
    case 30:
        ED_DiagVinModeChar = ED_FindNextCharInTable((LONG)ED_DiagVinModeChar, ED2_STR_NYYLLZ);
        ED_DrawDiagnosticModeText();
        break;
    case 31:
        ED_DiagGraphModeChar = ED_FindNextCharInTable((LONG)ED_DiagGraphModeChar, ED2_TAG_NYLRS);
        ED_DrawDiagnosticModeText();
        break;
    case 26:
        ED_DiagScrollSpeedChar = (ED_DiagScrollSpeedChar <= '3') ? '6' : (UBYTE)(ED_DiagScrollSpeedChar - 1);
        ED_TextLimit = (LONG)(ED_DiagScrollSpeedChar - '0');
        ED_BlockOffset = ESQIFF_JMPTBL_MATH_Mulu32(ED_TextLimit, 40);
        ED_DrawDiagnosticModeText();
        break;
    case 40:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 175, 360, ED2_STR_SILENCE);
        GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(0);
        break;
    case 41:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 175, 360, ED2_STR_LEFT);
        GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(1);
        break;
    case 42:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 175, 360, ED2_STR_RIGHT);
        GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(2);
        break;
    case 43:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 175, 360, ED2_STR_BACKGROUND);
        GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(3);
        break;
    case 50:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 390, ED2_STR_EXT_DOT_VIDEO_ONLY);
        GROUP_AK_JMPTBL_ESQ_SetCopperEffect_AllOn();
        break;
    case 51:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 390, ED2_STR_COMPUTER_ONLY);
        GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight();
        break;
    case 52:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 390, ED2_STR_OVERLAY_EXT_DOT_VIDEO);
        GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight();
        break;
    case 53:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 390, ED2_STR_NEGATIVE_VIDEO);
        GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Default();
        break;
    case 54:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 270, ED2_STR_VIDEO_SWITCH);
        if (ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask() == 0) {
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 235, 270, ED2_STR_OPEN);
        } else {
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 235, 270, ED2_STR_CLOSED);
        }
        break;
    case 55:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 270, ED2_STR_START_TAPE_VIDEO);
        GROUP_AK_JMPTBL_SCRIPT_AssertCtrlLineNow();
        break;
    case 56:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 270, ED2_STR_STOP);
        GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow();
        break;
    case 90:
        ED_DiagnosticsViewMode += 1;
        break;
    case 122:
        ED_DiagnosticsViewMode = (ED_DiagnosticsViewMode == 1) ? 0 : 1;
        break;
    default:
        ED_DrawESCMenuBottomHelp();
        ED_DiagnosticsScreenActive = 0;
        break;
    }
}
