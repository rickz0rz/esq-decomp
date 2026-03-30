#include <exec/types.h>

enum {
    FLAG_FALSE = 0,
    FLAG_TRUE = 1,
    CMD_CASE_COUNT = 22,
    BRUSH_TAG_LEN = 2,
    BRUSH_NODE_LABEL_OFFSET = 0x21,
    RTC_PACKET_LEN = 12,
    RTC_YEAR_TEXT_LEN = 4,
    CHARCLASS_DECIMAL_DIGIT_BIT = 2,
    CHARCLASS_ALPHA_BIT = 7,
    CHARCLASS_LOWERCASE_BIT = 1,
    ASCII_ZERO = 48,
    ASCII_Y = 89,
    ASCII_L = 76,
    ASCII_R = 82,
    ASCII_M = 77,
    ASCII_N = 78,
    CURSOR_FALLBACK = 1,
    CURSOR_MATCH_RESET = 2,
    CURSOR_WILDCARD = 3,
    CURSOR_CHANNEL_RANGE = 5,
    CURSOR_TEXTDISP_PRIMARY = 6,
    CURSOR_TEXTDISP_SECONDARY = 7,
    CURSOR_WEATHER = 8,
    CURSOR_TEXTDISP = 9,
    CURSOR_RUNTIME = 10,
    CURSOR_CUSTOM = 13,
    CURSOR_READ_ENABLE = 14,
    CURSOR_READ_DISABLE = 15
};

typedef struct SCRIPT3_BrushNode {
    UBYTE pad0[BRUSH_NODE_LABEL_OFFSET];
    char label[368 - BRUSH_NODE_LABEL_OFFSET];
    struct SCRIPT3_BrushNode *next;
} SCRIPT3_BrushNode;

extern WORD SCRIPT_RuntimeMode;
extern LONG SCRIPT_PlaybackCursor;
extern WORD SCRIPT_PrimarySearchFirstFlag;
extern WORD TEXTDISP_PrimaryChannelCode;
extern WORD TEXTDISP_SecondaryChannelCode;
extern WORD TEXTDISP_CurrentMatchIndex;
extern WORD TEXTDISP_ChannelSourceMode;
extern WORD CLEANUP_AlignedStatusMatchIndex;
extern WORD SCRIPT_PendingBannerTargetChar;
extern WORD SCRIPT_PendingBannerSpeedMs;
extern WORD SCRIPT_ChannelRangeArmedFlag;
extern WORD SCRIPT_ChannelRangeDigitChar;
extern UBYTE SCRIPT_Type20SubtypeCache;
extern UBYTE SCRIPT_PendingWeatherCommandChar;
extern UBYTE SCRIPT_PendingTextdispCmdChar;
extern UBYTE SCRIPT_PendingTextdispCmdArg;
extern char *SCRIPT_CommandTextPtr;
extern WORD SCRIPT_ReadModeActiveLatch;
extern WORD ESQPARS2_ReadModeFlags;
extern WORD SCRIPT_PlaybackFallbackCounter;
extern UBYTE CTASKS_STR_1;
extern LONG LOCAVAIL_FilterStep;
extern LONG LOCAVAIL_FilterModeFlag;
extern WORD WDISP_HighlightActive;
extern UBYTE ED_DiagGraphModeChar;
extern UBYTE ED_DiagVinModeChar;
extern LONG ESQIFF_GAdsBrushListCount;
extern UWORD Global_WORD_SELECT_CODE_IS_RAVESC;
extern char CONFIG_LRBN_FlagChar;
extern char CONFIG_MSN_FlagChar;
extern char ESQ_DefaultNoFlagChar;
extern void *LOCAVAIL_PrimaryFilterState;
extern void *ESQIFF_BrushIniListHead;
extern void *BRUSH_SelectedNode;
extern void *BRUSH_ScriptPrimarySelection;
extern void *BRUSH_ScriptSecondarySelection;
extern UBYTE HIGHLIGHT_CustomValue;
extern const UBYTE WDISP_CharClassTable[];
extern const char SCRIPT_BrushTag_Default00_Primary[];
extern const char SCRIPT_BrushTag_Default00_Secondary[];
extern const char SCRIPT_BrushTag_Clear11_Primary[];
extern const char SCRIPT_BrushTag_Clear11_Secondary[];

extern void SCRIPT_LoadCtrlContextSnapshot(char *ctx);
extern void SCRIPT_SaveCtrlContextSnapshot(char *ctx);
extern LONG SCRIPT_SelectPlaybackCursorFromSearchText(LONG matchCountOrIndex, char *parseBuffer);
extern void SCRIPT_SplitAndNormalizeSearchBuffer(char *parseBuffer, LONG parseLen);
extern LONG TEXTDISP_HandleScriptCommand(UBYTE scriptType, UBYTE command, char *arg);
extern char *ESQPARS_ReplaceOwnedString(const char *newValue, char *oldValue);
extern LONG STRING_CompareN(const char *a, const char *b, LONG maxLen);
extern char *STRING_CopyPadNul(char *dst, const char *src, ULONG n);
extern LONG P_TYPE_GetSubtypeIfType20(UBYTE *entry);
extern LONG P_TYPE_ConsumePrimaryTypeIfPresent(UBYTE *inOutBytePtr);
extern void ESQPARS_ApplyRtcBytesAndPersist(BYTE *src);
extern LONG PARSE_ReadSignedLongSkipClass3_Alt(const char *s);
extern WORD TEXTDISP_FindEntryIndexByWildcard(char *path);
extern LONG LADFUNC_ParseHexDigit(BYTE ch);
extern LONG MATH_Mulu32(LONG a, LONG b);
extern void TEXTDISP_UpdateChannelRangeFlags(void);
extern void LOCAVAIL_SetFilterModeAndResetState(LONG mode);
extern void LOCAVAIL_ComputeFilterOffsetForEntry(const BYTE *text, void *statePtr);
extern LONG SCRIPT_ReadHandshakeBit5Mask(void);

static LONG SCRIPT3_IsUpper(UBYTE ch)
{
    if ((WDISP_CharClassTable[ch] & (1u << CHARCLASS_ALPHA_BIT)) == 0) {
        return FLAG_FALSE;
    }
    if ((WDISP_CharClassTable[ch] & (1u << CHARCLASS_LOWERCASE_BIT)) != 0) {
        return FLAG_FALSE;
    }
    return FLAG_TRUE;
}

static LONG SCRIPT3_ToUpper(UBYTE ch)
{
    if (SCRIPT3_IsUpper(ch) != FLAG_FALSE) {
        return (LONG)ch;
    }
    if ((WDISP_CharClassTable[ch] & (1u << CHARCLASS_ALPHA_BIT)) != 0 &&
        (WDISP_CharClassTable[ch] & (1u << CHARCLASS_LOWERCASE_BIT)) != 0) {
        return (LONG)(ch - 32);
    }
    return (LONG)ch;
}

static LONG SCRIPT3_IsDigit(UBYTE ch)
{
    return (WDISP_CharClassTable[ch] & (1u << CHARCLASS_DECIMAL_DIGIT_BIT)) != 0;
}

LONG SCRIPT_HandleBrushCommand(char *ctx, char *cmd, LONG cmdLen)
{
    LONG ok;
    LONG dispatchTextdisp;
    WORD savedRuntimeMode;
    LONG sub;

    ok = FLAG_TRUE;
    dispatchTextdisp = FLAG_TRUE;
    savedRuntimeMode = SCRIPT_RuntimeMode;
    SCRIPT_LoadCtrlContextSnapshot(ctx);

    SCRIPT_PlaybackCursor = 0;
    cmd[cmdLen] = 0;

    sub = (LONG)(UBYTE)cmd[0] - 1;
    if (sub >= 0 && sub < CMD_CASE_COUNT) {
        switch (sub) {
        case 0:
        {
            UBYTE type20Subtype;

            type20Subtype = SCRIPT_Type20SubtypeCache;
            if (P_TYPE_ConsumePrimaryTypeIfPresent(&type20Subtype) != FLAG_FALSE) {
                SCRIPT_PlaybackCursor = CURSOR_FALLBACK;
                break;
            }

            switch ((UBYTE)cmd[1]) {
            case '1':
                ok = SCRIPT_SelectPlaybackCursorFromSearchText(0, cmd);
                break;
            case '3':
                TEXTDISP_CurrentMatchIndex = -1;
                if (ESQ_DefaultNoFlagChar == 'Y') {
                    SCRIPT_PlaybackCursor = CURSOR_FALLBACK;
                } else {
                    SCRIPT_PlaybackCursor = CURSOR_MATCH_RESET;
                }
                break;
            case '4':
            case '6':
                if (TEXTDISP_FindEntryIndexByWildcard(cmd + 2) != 0) {
                    SCRIPT_PlaybackCursor = CURSOR_WILDCARD;
                } else {
                    ok = FLAG_FALSE;
                    SCRIPT_PlaybackCursor = CURSOR_FALLBACK;
                }
                break;
            case '5':
                if (CONFIG_LRBN_FlagChar != 'Y') {
                    SCRIPT_PendingBannerTargetChar = -1;
                    SCRIPT_PlaybackCursor = CURSOR_FALLBACK;
                } else {
                    UBYTE digit2;
                    UBYTE digit3;

                    digit2 = (UBYTE)cmd[2];
                    digit3 = (UBYTE)cmd[3];
                    if ((WDISP_CharClassTable[digit2] & (1u << CHARCLASS_ALPHA_BIT)) == 0 ||
                        (WDISP_CharClassTable[digit3] & (1u << CHARCLASS_ALPHA_BIT)) == 0) {
                        SCRIPT_PendingBannerTargetChar = -1;
                        SCRIPT_PlaybackCursor = CURSOR_FALLBACK;
                        break;
                    }

                    SCRIPT_PendingBannerTargetChar =
                        (WORD)(((UBYTE)LADFUNC_ParseHexDigit((BYTE)digit2) << 4) +
                               (UBYTE)LADFUNC_ParseHexDigit((BYTE)digit3));

                    if (SCRIPT3_IsDigit((UBYTE)cmd[4]) != FLAG_FALSE &&
                        SCRIPT3_IsDigit((UBYTE)cmd[5]) != FLAG_FALSE) {
                        SCRIPT_PendingBannerSpeedMs =
                            (WORD)(MATH_Mulu32((LONG)((UBYTE)cmd[4] - ASCII_ZERO), 1000) +
                                   MATH_Mulu32((LONG)((UBYTE)cmd[5] - ASCII_ZERO), 100));
                    } else {
                        SCRIPT_PendingBannerSpeedMs = 1000;
                    }

                    if (cmd[6] == 0) {
                        TEXTDISP_CurrentMatchIndex = -1;
                        SCRIPT_PlaybackCursor = CURSOR_MATCH_RESET;
                    } else if (Global_WORD_SELECT_CODE_IS_RAVESC != 0 ||
                               CONFIG_MSN_FlagChar == ASCII_M ||
                               TEXTDISP_FindEntryIndexByWildcard(cmd + 6) != 0) {
                        SCRIPT_PlaybackCursor = CURSOR_WILDCARD;
                    } else {
                        SCRIPT_PendingBannerTargetChar = -1;
                        SCRIPT_PlaybackCursor = CURSOR_FALLBACK;
                    }
                }
                break;
            case '7':
                if (SCRIPT_ChannelRangeArmedFlag == 0) {
                    ok = FLAG_FALSE;
                    break;
                }

                if (TEXTDISP_ChannelSourceMode == 1) {
                    SCRIPT_ChannelRangeDigitChar = (WORD)(UBYTE)cmd[2];
                } else {
                    SCRIPT_ChannelRangeDigitChar = (WORD)(UBYTE)cmd[3];
                }

                if (SCRIPT_ChannelRangeDigitChar == ASCII_ZERO) {
                    ok = FLAG_FALSE;
                    break;
                }

                if (TEXTDISP_CurrentMatchIndex == -1) {
                    if (CLEANUP_AlignedStatusMatchIndex == -1) {
                        ok = FLAG_FALSE;
                        break;
                    }
                    TEXTDISP_CurrentMatchIndex = CLEANUP_AlignedStatusMatchIndex;
                }

                TEXTDISP_UpdateChannelRangeFlags();
                SCRIPT_PlaybackCursor = CURSOR_CHANNEL_RANGE;
                break;
            case '8':
                ok = SCRIPT_SelectPlaybackCursorFromSearchText(1, cmd);
                break;
            case 'Q':
                TEXTDISP_CurrentMatchIndex = -1;
                SCRIPT_PlaybackCursor = CURSOR_FALLBACK;
                break;
            case 'S':
                SCRIPT_PlaybackCursor = CURSOR_TEXTDISP;
                SCRIPT_PendingTextdispCmdChar = (UBYTE)cmd[1];
                SCRIPT_PendingTextdispCmdArg = (UBYTE)cmd[2];
                SCRIPT_CommandTextPtr = ESQPARS_ReplaceOwnedString(cmd + 3, SCRIPT_CommandTextPtr);
                dispatchTextdisp = FLAG_FALSE;
                SCRIPT_PendingBannerTargetChar = -2;
                break;
            case 'j':
                SCRIPT_PlaybackCursor = CURSOR_WEATHER;
                SCRIPT_PendingWeatherCommandChar = (UBYTE)cmd[2];
                break;
            default:
                break;
            }
            break;
        }
        case 1:
        {
            LONG havePrimary;
            LONG haveSecondary;
            SCRIPT3_BrushNode *node;

            havePrimary = FLAG_FALSE;
            haveSecondary = FLAG_FALSE;

            if (STRING_CompareN(SCRIPT_BrushTag_Default00_Primary, cmd + 3, BRUSH_TAG_LEN) == 0) {
                BRUSH_ScriptPrimarySelection = BRUSH_SelectedNode;
                havePrimary = FLAG_TRUE;
            }
            if (STRING_CompareN(SCRIPT_BrushTag_Default00_Secondary, cmd + 1, BRUSH_TAG_LEN) == 0) {
                BRUSH_ScriptSecondarySelection = BRUSH_SelectedNode;
                haveSecondary = FLAG_TRUE;
            }
            if (STRING_CompareN(SCRIPT_BrushTag_Clear11_Primary, cmd + 3, BRUSH_TAG_LEN) == 0 &&
                havePrimary == FLAG_FALSE) {
                BRUSH_ScriptPrimarySelection = (void *)0;
                havePrimary = FLAG_TRUE;
            }
            if (STRING_CompareN(SCRIPT_BrushTag_Clear11_Secondary, cmd + 1, BRUSH_TAG_LEN) == 0 &&
                haveSecondary == FLAG_FALSE) {
                BRUSH_ScriptSecondarySelection = (void *)0;
                haveSecondary = FLAG_TRUE;
            }

            if (havePrimary == FLAG_FALSE || haveSecondary == FLAG_FALSE) {
                node = (SCRIPT3_BrushNode *)ESQIFF_BrushIniListHead;
                while (node != (SCRIPT3_BrushNode *)0) {
                    if (havePrimary == FLAG_FALSE &&
                        STRING_CompareN(node->label, cmd + 3, BRUSH_TAG_LEN) == 0) {
                        BRUSH_ScriptPrimarySelection = (void *)node;
                        havePrimary = FLAG_TRUE;
                        if (haveSecondary != FLAG_FALSE) {
                            break;
                        }
                    }
                    if (haveSecondary == FLAG_FALSE &&
                        STRING_CompareN(node->label, cmd + 1, BRUSH_TAG_LEN) == 0) {
                        BRUSH_ScriptSecondarySelection = (void *)node;
                        haveSecondary = FLAG_TRUE;
                        if (havePrimary != FLAG_FALSE) {
                            break;
                        }
                    }
                    node = node->next;
                }
            }

            if (havePrimary == FLAG_FALSE) {
                BRUSH_ScriptPrimarySelection = BRUSH_SelectedNode;
            }
            if (haveSecondary == FLAG_FALSE) {
                BRUSH_ScriptSecondarySelection = BRUSH_SelectedNode;
            }
            break;
        }
        case 3:
            if (cmd[1] == ASCII_L) {
                SCRIPT_PrimarySearchFirstFlag = 1;
            } else if (cmd[1] == ASCII_R) {
                SCRIPT_PrimarySearchFirstFlag = 0;
            } else {
                SCRIPT_PrimarySearchFirstFlag = (WORD)(SCRIPT_PrimarySearchFirstFlag == 0);
            }
            break;
        case 4:
            TEXTDISP_PrimaryChannelCode = (WORD)(UBYTE)cmd[1];
            TEXTDISP_SecondaryChannelCode = (WORD)(UBYTE)cmd[2];
            break;
        case 6:
            SCRIPT_PlaybackCursor = CURSOR_READ_DISABLE;
            break;
        case 10:
            if (CTASKS_STR_1 == '1') {
                LONG packetLen;
                char yearText[RTC_YEAR_TEXT_LEN];
                BYTE rtcBytes[8];
                LONG year;

                packetLen = 0;
                while (cmd[packetLen] != 0) {
                    packetLen += 1;
                }

                if (packetLen == RTC_PACKET_LEN) {
                    STRING_CopyPadNul(yearText, cmd + 4, RTC_YEAR_TEXT_LEN);
                    year = PARSE_ReadSignedLongSkipClass3_Alt(yearText);

                    rtcBytes[0] = (BYTE)((UBYTE)cmd[1] - ASCII_ZERO);
                    rtcBytes[1] = (BYTE)((UBYTE)cmd[2] - ASCII_ZERO);
                    rtcBytes[2] = (BYTE)((UBYTE)cmd[3] - ASCII_ZERO);
                    rtcBytes[3] = (BYTE)(year - 1900);
                    rtcBytes[4] = (BYTE)((UBYTE)cmd[8] - ASCII_ZERO);
                    rtcBytes[5] = (BYTE)((UBYTE)cmd[9] - ASCII_ZERO);
                    rtcBytes[6] = (BYTE)((UBYTE)cmd[10] - ASCII_ZERO);
                    rtcBytes[7] = (BYTE)((UBYTE)cmd[11] - ASCII_ZERO);

                    if ((LONG)rtcBytes[0] < 7 &&
                        (LONG)rtcBytes[1] < 12 &&
                        (LONG)rtcBytes[6] < 60) {
                        ESQPARS_ApplyRtcBytesAndPersist(rtcBytes);
                    }
                }
            }
            break;
        case 11:
        {
            UBYTE type20Subtype;

            if (LOCAVAIL_FilterStep == 1 || LOCAVAIL_FilterStep == 2) {
                TEXTDISP_CurrentMatchIndex = -1;
                SCRIPT_PlaybackCursor = CURSOR_MATCH_RESET;
                break;
            }

            if (LOCAVAIL_FilterModeFlag != 1) {
                if ((ED_DiagGraphModeChar != ASCII_N && ESQIFF_GAdsBrushListCount != 0) ||
                    WDISP_HighlightActive != 0) {
                    SCRIPT_PlaybackCursor = 4;
                    SCRIPT_ChannelRangeArmedFlag = 0;
                    break;
                }
            }

            type20Subtype = SCRIPT_Type20SubtypeCache;
            if (P_TYPE_ConsumePrimaryTypeIfPresent(&type20Subtype) != FLAG_FALSE) {
                SCRIPT_PlaybackCursor = CURSOR_FALLBACK;
                break;
            }

            if (cmd[1] == '1') {
                ok = SCRIPT_SelectPlaybackCursorFromSearchText(0, cmd);
            } else if (cmd[1] == '3') {
                TEXTDISP_CurrentMatchIndex = -1;
                SCRIPT_PlaybackCursor = CURSOR_MATCH_RESET;
            }
            break;
        }
        case 14:
        {
            LONG parsed;

            parsed = PARSE_ReadSignedLongSkipClass3_Alt(cmd + 1);
            HIGHLIGHT_CustomValue = (UBYTE)(63 - parsed);
            if ((BYTE)HIGHLIGHT_CustomValue < 0 || HIGHLIGHT_CustomValue > 63) {
                HIGHLIGHT_CustomValue = 63;
            }
            SCRIPT_PlaybackCursor = CURSOR_CUSTOM;
            break;
        }
        case 15:
            SCRIPT_PlaybackCursor = CURSOR_READ_ENABLE;
            break;
        case 16:
            SCRIPT_SplitAndNormalizeSearchBuffer(cmd, cmdLen);
            break;
        case 19:
            SCRIPT_Type20SubtypeCache = (UBYTE)P_TYPE_GetSubtypeIfType20((UBYTE *)cmd);
            break;
        case 21:
            if (cmd[1] == '9') {
                LOCAVAIL_SetFilterModeAndResetState(1);
                LOCAVAIL_ComputeFilterOffsetForEntry((BYTE *)(cmd + 2), LOCAVAIL_PrimaryFilterState);
            } else if (LOCAVAIL_FilterModeFlag == 1 && cmd[1] == '8') {
                LOCAVAIL_SetFilterModeAndResetState(0);
            } else if (LOCAVAIL_FilterModeFlag == 1) {
                ok = FLAG_FALSE;
            } else {
                LONG diagMode;
                LONG subcode;

                diagMode = SCRIPT3_ToUpper(ED_DiagVinModeChar);
                subcode = (LONG)(UBYTE)cmd[1];

                if ((diagMode == ASCII_Y && subcode == '0') ||
                    (diagMode == ASCII_L && subcode == '2')) {
                    SCRIPT_RuntimeMode = 3;
                } else if (((diagMode == ASCII_Y && subcode == '1') ||
                            (diagMode == ASCII_L && subcode == '3')) &&
                           SCRIPT_ReadHandshakeBit5Mask() != 0) {
                    SCRIPT_PlaybackCursor = CURSOR_RUNTIME;
                } else {
                    ok = FLAG_FALSE;
                }
            }
            break;
        default:
            break;
        }
    }

    SCRIPT_SaveCtrlContextSnapshot(ctx);

    if (dispatchTextdisp != 0 && SCRIPT_PlaybackCursor != 0) {
        TEXTDISP_HandleScriptCommand((UBYTE)0xffu, (UBYTE)0xffu, (char *)0);
    }

    SCRIPT_RuntimeMode = savedRuntimeMode;
    return ok;
}
