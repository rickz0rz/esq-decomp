/* RESTORES: SCRIPT_HandleBrushCommand
 * MODULE:   modules/groups/b/a/script3b2_script_handlebrushcommand.s
 * STATUS:   behavioural
 *
 * One CTRL packet payload, 2214 bytes, and two dispatchers stacked on each other.
 *
 * The OUTER one is a real 22-way PC-relative jump table on payload[0], built by
 * the original as `.brush_cmd_jmptbl` with ten of its twenty-two slots pointing at
 * the same no-op. The bound check is `CMPI.W #22` immediately before the JMP, so
 * per AGENTS.md there is NO explicit range guard here -- `default:` carries it,
 * and writing both makes SAS/C emit the test twice.
 *
 * The INNER one is reached from payload[0] == 1 and dispatches on payload[1] with
 * a chained SUBQ/SUBI, over the sparse set 49, 51..56, 68, 70, 87, 88. Also a
 * `switch`, for the same reason.
 *
 * Case 88 FALLS INTO case 87's neighbour deliberately: the original's last
 * `SUBQ.W #1,D0 / BNE finalize` drops through into the cursor-9 body.
 *
 * TOUPPER IS OPEN-CODED FOUR TIMES against WDISP_CharClassTable, and the
 * restoration repeats it four times rather than hoisting it. The original
 * recomputes `(table[c] & 2) ? c - 32 : c` before each of its four comparisons,
 * and per AGENTS.md hoisting a value the original recomputes changes the emitted
 * code. Bit 1 of that table is the lowercase class, bit 2 the digit class, and
 * bit 7 the hex-digit class; all three are used here.
 *
 * The brush-tag scan has a DEAD BRANCH the restoration keeps by accident of
 * writing the natural source: after `primaryDone = 1` the original tests the
 * just-set constant (`MOVEQ #1,D0 / MOVE.L D0,slot / BEQ`) before testing
 * secondaryDone. That is what `if (primaryDone && secondaryDone) break;` compiles
 * to when the first operand was just assigned 1, so the source form is recovered
 * rather than worked around.
 *
 * SASC-MISMATCH: register-argument-multiply
 *   ref:     223c000003e8 4eba....   MOVE.L #1000,D1 / JSR MATH_Mulu32
 *   got:     the multiply inline
 *   summary: the banner-speed arithmetic calls MATH_Mulu32 with both operands
 *            already in D0/D1. Two sites, both written as `*`.
 *   scope:   program-wide wherever MATH_Mulu32 appears.
 *   retest:  a compiler whose multiply helper IS this routine.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba....                JSR (d16,PC)
 *   got:     61000000                BSR.W
 *   summary: same size, different opcode; costs nothing.
 *   scope:   the whole cross-unit bucket.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55ffdc ... 4e5d       LINK.W A5,#-36 / UNLK A5
 *   got:     A7-relative locals
 *   scope:   program-wide; docs/compiler-version.md.
 *   retest:  a compiler that reserves A5.
 *
 * MEASURED: 2316 against 2214, +102 over 79 regions -- 4.6%. The RTC case reuses
 * the same frame slots the brush-tag case uses for its two done-flags, which this
 * restoration cannot reproduce: separate C locals in separate blocks are the
 * compiler's to overlap or not. So the frame size differs by construction.
 *
 * SASC-MISMATCH: unattributed-body-delta
 *   summary: the +102 is NOT itemised. The two dispatchers mean casm.py aligns the
 *            prologue and then produces one enormous hunk for the jump-table
 *            bodies, which per AGENTS.md rule 1 makes its per-hunk figures
 *            meaningless. Recorded as a known-unknown per rule 3.
 *   tried:   SHARING THE COMMON TAILS was worth 80 bytes, 2396 -> 2316. The
 *            original reaches `cursor4` from two places, `runtime3` from two and
 *            `tryCursor10` from two, and branches to one finalize. Written as
 *            independent case bodies each tail is duplicated; written as labels
 *            reached by `goto` -- which is what the original's BRA does -- they
 *            are shared. This is the same lesson as the key-8 fall-through in
 *            ed_handle_editor_input.c: match the original's SHARING, not just its
 *            arithmetic.
 *   retest:  itemise again once the frame class is resolved.
 */
#include <exec/types.h>
#include <string.h>

struct BrushNode {
    char  pad0[33];
    char  tag[335];             /*  33 = 0x21 */
    struct BrushNode *next;     /* 368 */
};

extern struct BrushNode *BRUSH_SelectedNode;
extern struct BrushNode *ESQIFF_BrushIniListHead;
extern struct BrushNode *BRUSH_ScriptPrimarySelection;
extern struct BrushNode *BRUSH_ScriptSecondarySelection;

extern unsigned char WDISP_CharClassTable[];
extern unsigned char CTASKS_STR_1;
extern unsigned char CONFIG_LRBN_FlagChar;
extern unsigned char CONFIG_MSN_FlagChar;
extern unsigned char ESQ_DefaultNoFlagChar;
extern unsigned char ED_DiagGraphModeChar;
extern unsigned char ED_DiagVinModeChar;
extern char          HIGHLIGHT_CustomValue;

extern short SCRIPT_RuntimeMode;
extern long  SCRIPT_PlaybackCursor;
extern unsigned char SCRIPT_Type20SubtypeCache;
extern char *SCRIPT_CommandTextPtr;
extern short SCRIPT_PendingBannerTargetChar;
extern short SCRIPT_PendingBannerSpeedMs;
extern unsigned char SCRIPT_PendingWeatherCommandChar;
extern unsigned char SCRIPT_PendingTextdispCmdChar;
extern unsigned char SCRIPT_PendingTextdispCmdArg;
extern short SCRIPT_PrimarySearchFirstFlag;
extern short SCRIPT_ChannelRangeArmedFlag;
extern short SCRIPT_ChannelRangeDigitChar;
extern char  SCRIPT_BrushTag_Default00_Primary[];
extern char  SCRIPT_BrushTag_Default00_Secondary[];
extern char  SCRIPT_BrushTag_Clear11_Primary[];
extern char  SCRIPT_BrushTag_Clear11_Secondary[];

extern short TEXTDISP_PrimaryChannelCode;
extern short TEXTDISP_SecondaryChannelCode;
extern short TEXTDISP_ChannelSourceMode;
extern short TEXTDISP_CurrentMatchIndex;
extern short CLEANUP_AlignedStatusMatchIndex;
extern short Global_WORD_SELECT_CODE_IS_RAVESC;
extern short WDISP_HighlightActive;
extern long  ESQIFF_GAdsBrushListCount;
extern long  LOCAVAIL_FilterModeFlag;
extern long  LOCAVAIL_FilterStep;
extern char  LOCAVAIL_PrimaryFilterState[1];

extern unsigned char P_TYPE_GetSubtypeIfType20(char *payload);
extern long  P_TYPE_ConsumePrimaryTypeIfPresent(unsigned char *cache);
extern long  SCRIPT_SelectPlaybackCursorFromSearchText(long which, char *payload,
                                                       long len);
extern void  SCRIPT_SplitAndNormalizeSearchBuffer(char *payload, long len);
extern void  SCRIPT_LoadCtrlContextSnapshot(void *ctx);
extern void  SCRIPT_SaveCtrlContextSnapshot(void *ctx);
extern void  ESQPARS_ApplyRtcBytesAndPersist(char *rtc);
extern void  LOCAVAIL_SetFilterModeAndResetState(long mode);
extern void  LOCAVAIL_ComputeFilterOffsetForEntry(char *entry,
                                                                 void *state);
extern unsigned char LADFUNC_ParseHexDigit(long c);
extern long  PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern long  STRING_CompareN(char *a, char *b, long n);
extern void  STRING_CopyPadNul(char *dst, char *src, long n);
extern char  SCRIPT_ReadHandshakeBit5Mask(void);
extern short TEXTDISP_FindEntryIndexByWildcard(char *pattern);
extern void  TEXTDISP_HandleScriptCommand(long a, long b, long c);
extern void  TEXTDISP_UpdateChannelRangeFlags(void);
extern char *ESQPARS_ReplaceOwnedString(char *newText,
                                                        char *oldText);

long SCRIPT_HandleBrushCommand(void *ctx, char *payload, long len)
{
    struct BrushNode *node;
    char  yearText[8];
    char  rtc[9];
    long  primaryDone;
    long  secondaryDone;
    long  ok;
    long  dispatchAfter;
    long  year;
    long  value;
    long  speed;
    short savedRuntimeMode;
    short digitOffset;
    unsigned char upper;
    unsigned char c;

    ok = 1;
    dispatchAfter = 1;
    savedRuntimeMode = SCRIPT_RuntimeMode;
    SCRIPT_LoadCtrlContextSnapshot(ctx);
    SCRIPT_PlaybackCursor = 0;
    payload[len] = 0;

    switch ((unsigned char)payload[0]) {

    case 1:
        if (P_TYPE_ConsumePrimaryTypeIfPresent(&SCRIPT_Type20SubtypeCache) != 0) {
            SCRIPT_PlaybackCursor = 1;
            break;
        }

        switch ((unsigned char)payload[1]) {

        case 49:
            ok = SCRIPT_SelectPlaybackCursorFromSearchText(0L, payload, len);
            break;

        case 56:
            ok = SCRIPT_SelectPlaybackCursorFromSearchText(1L, payload, len);
            break;

        case 51:
            TEXTDISP_CurrentMatchIndex = -1;
            if (ESQ_DefaultNoFlagChar == 'Y')
                SCRIPT_PlaybackCursor = 1;
            else
                SCRIPT_PlaybackCursor = 2;
            break;

        case 68:
            TEXTDISP_CurrentMatchIndex = -1;
            SCRIPT_PlaybackCursor = 1;
            break;

        case 52:
        case 54:
            if (TEXTDISP_FindEntryIndexByWildcard(&payload[2]) != 0) {
                SCRIPT_PlaybackCursor = 3;
            } else {
                ok = 0;
                SCRIPT_PlaybackCursor = 1;
            }
            break;

        case 55:
            if (SCRIPT_ChannelRangeArmedFlag == 0) {
                ok = 0;
                break;
            }
            if (TEXTDISP_ChannelSourceMode == 1)
                digitOffset = 2;
            else
                digitOffset = 3;
            SCRIPT_ChannelRangeDigitChar =
                (unsigned char)payload[digitOffset];
            if (SCRIPT_ChannelRangeDigitChar == '0') {
                ok = 0;
                break;
            }
            if (TEXTDISP_CurrentMatchIndex == -1 &&
                CLEANUP_AlignedStatusMatchIndex == -1) {
                ok = 0;
                break;
            }
            if (TEXTDISP_CurrentMatchIndex == -1)
                TEXTDISP_CurrentMatchIndex = CLEANUP_AlignedStatusMatchIndex;
            TEXTDISP_UpdateChannelRangeFlags();
            SCRIPT_PlaybackCursor = 5;
            break;

        case 53:
            if (CONFIG_LRBN_FlagChar != 'Y') {
                SCRIPT_PendingBannerTargetChar = -1;
                SCRIPT_PlaybackCursor = 1;
                break;
            }
            if ((WDISP_CharClassTable[(unsigned char)payload[2]] & 0x80) == 0 ||
                (WDISP_CharClassTable[(unsigned char)payload[3]] & 0x80) == 0) {
                SCRIPT_PendingBannerTargetChar = -1;
                SCRIPT_PlaybackCursor = 1;
                break;
            }
            SCRIPT_PendingBannerTargetChar = (short)
                ((LADFUNC_ParseHexDigit((long)payload[2]) << 4) +
                 LADFUNC_ParseHexDigit((long)payload[3]));

            if ((WDISP_CharClassTable[(unsigned char)payload[4]] & 4) != 0 &&
                (WDISP_CharClassTable[(unsigned char)payload[5]] & 4) != 0) {
                speed = ((long)(unsigned char)payload[4] - 48) * 1000;
                speed = speed + ((long)(unsigned char)payload[5] - 48) * 100;
                SCRIPT_PendingBannerSpeedMs = (short)speed;
            } else {
                SCRIPT_PendingBannerSpeedMs = 1000;
            }

            if (payload[6] == 0) {
                TEXTDISP_CurrentMatchIndex = -1;
                SCRIPT_PlaybackCursor = 2;
                break;
            }
            if (Global_WORD_SELECT_CODE_IS_RAVESC != 0 ||
                CONFIG_MSN_FlagChar == 'M' ||
                TEXTDISP_FindEntryIndexByWildcard(&payload[6]) != 0) {
                SCRIPT_PlaybackCursor = 3;
            } else {
                SCRIPT_PlaybackCursor = 1;
                SCRIPT_PendingBannerTargetChar = -1;
            }
            break;

        case 87:
            SCRIPT_PlaybackCursor = 8;
            SCRIPT_PendingWeatherCommandChar = payload[2];
            break;

        case 88:
        case 70:
            SCRIPT_PlaybackCursor = 9;
            SCRIPT_PendingTextdispCmdChar = payload[1];
            SCRIPT_PendingTextdispCmdArg = payload[2];
            SCRIPT_CommandTextPtr = ESQPARS_ReplaceOwnedString(
                &payload[3], SCRIPT_CommandTextPtr);
            dispatchAfter = 0;
            SCRIPT_PendingBannerTargetChar = -2;
            break;

        default:
            break;
        }
        break;

    case 2:
        primaryDone = secondaryDone = 0;

        if (STRING_CompareN(SCRIPT_BrushTag_Default00_Primary,
                                           &payload[3], 2L) == 0) {
            BRUSH_ScriptPrimarySelection = BRUSH_SelectedNode;
            primaryDone = 1;
        }
        if (STRING_CompareN(SCRIPT_BrushTag_Default00_Secondary,
                                           &payload[1], 2L) == 0) {
            BRUSH_ScriptSecondarySelection = BRUSH_SelectedNode;
            secondaryDone = 1;
        }
        if (STRING_CompareN(SCRIPT_BrushTag_Clear11_Primary,
                                           &payload[3], 2L) == 0 &&
            primaryDone == 0) {
            BRUSH_ScriptPrimarySelection = 0;
            primaryDone = 1;
        }
        if (STRING_CompareN(SCRIPT_BrushTag_Clear11_Secondary,
                                           &payload[1], 2L) == 0 &&
            secondaryDone == 0) {
            BRUSH_ScriptSecondarySelection = 0;
            secondaryDone = 1;
        }

        if (primaryDone && secondaryDone)
            break;

        node = ESQIFF_BrushIniListHead;
        while (node != 0) {
            if (STRING_CompareN(node->tag, &payload[3], 2L) == 0 &&
                primaryDone == 0) {
                BRUSH_ScriptPrimarySelection = node;
                primaryDone = 1;
                if (primaryDone && secondaryDone)
                    break;
            }
            if (STRING_CompareN(node->tag, &payload[1], 2L) == 0 &&
                secondaryDone == 0) {
                BRUSH_ScriptSecondarySelection = node;
                secondaryDone = 1;
                if (primaryDone && secondaryDone)
                    break;
            }
            node = node->next;
        }

        if (primaryDone == 0)
            BRUSH_ScriptPrimarySelection = BRUSH_SelectedNode;
        if (secondaryDone == 0)
            BRUSH_ScriptSecondarySelection = BRUSH_SelectedNode;
        break;

    case 4:
        if (payload[1] == 76) {
            SCRIPT_PrimarySearchFirstFlag = 1;
        } else if (payload[1] == 82) {
            SCRIPT_PrimarySearchFirstFlag = 0;
        } else if (SCRIPT_PrimarySearchFirstFlag != 0) {
            SCRIPT_PrimarySearchFirstFlag = 0;
        } else {
            SCRIPT_PrimarySearchFirstFlag = 1;
        }
        break;

    case 5:
        TEXTDISP_PrimaryChannelCode = (unsigned char)payload[1];
        TEXTDISP_SecondaryChannelCode = (unsigned char)payload[2];
        break;

    case 7:
        SCRIPT_PlaybackCursor = 15;
        break;

    case 11:
        if (CTASKS_STR_1 != '1')
            break;
        if (strlen(payload) != 12)
            break;
        STRING_CopyPadNul(yearText, &payload[4], 4L);
        year = PARSE_ReadSignedLongSkipClass3_Alt(yearText);
        rtc[0] = payload[1] - 48;
        rtc[1] = payload[2] - 48;
        rtc[2] = payload[3] - 48;
        rtc[3] = (char)(year - 1900);
        rtc[4] = payload[8] - 48;
        rtc[5] = payload[9] - 48;
        rtc[6] = payload[10] - 48;
        rtc[7] = payload[11] - 48;
        rtc[8] = 0;
        if (rtc[0] >= 7)
            break;
        if (rtc[1] >= 12)
            break;
        if (rtc[6] >= 60)
            break;
        ESQPARS_ApplyRtcBytesAndPersist(rtc);
        break;

    case 12:
        if (LOCAVAIL_FilterStep == 1 || LOCAVAIL_FilterStep == 2) {
            TEXTDISP_CurrentMatchIndex = -1;
            SCRIPT_PlaybackCursor = 2;
            break;
        }
        if (LOCAVAIL_FilterModeFlag != 1) {
            if (ED_DiagGraphModeChar != 'N' && ESQIFF_GAdsBrushListCount != 0)
                goto cursor4;
            if (WDISP_HighlightActive != 0)
                goto cursor4;
        }
        if (P_TYPE_ConsumePrimaryTypeIfPresent(&SCRIPT_Type20SubtypeCache) != 0) {
            SCRIPT_PlaybackCursor = 1;
            break;
        }
        if (payload[1] == 49) {
            ok = SCRIPT_SelectPlaybackCursorFromSearchText(0L, payload, len);
        } else if (payload[1] == 51) {
            TEXTDISP_CurrentMatchIndex = -1;
            SCRIPT_PlaybackCursor = 2;
        }
        break;

    case 15:
        value = PARSE_ReadSignedLongSkipClass3_Alt(&payload[1]);
        HIGHLIGHT_CustomValue = (char)(63 - value);
        if (HIGHLIGHT_CustomValue > 63 || HIGHLIGHT_CustomValue < 0)
            HIGHLIGHT_CustomValue = 63;
        SCRIPT_PlaybackCursor = 13;
        break;

    case 16:
        SCRIPT_PlaybackCursor = 14;
        break;

    case 17:
        SCRIPT_SplitAndNormalizeSearchBuffer(payload, len);
        break;

    case 20:
        SCRIPT_Type20SubtypeCache = P_TYPE_GetSubtypeIfType20(payload);
        break;

    case 22:
        if (payload[1] == 57) {
            LOCAVAIL_SetFilterModeAndResetState(1L);
            LOCAVAIL_ComputeFilterOffsetForEntry(
                &payload[2], LOCAVAIL_PrimaryFilterState);
            break;
        }
        if (LOCAVAIL_FilterModeFlag == 1 && payload[1] == 56) {
            LOCAVAIL_SetFilterModeAndResetState(0L);
            break;
        }
        if (LOCAVAIL_FilterModeFlag == 1) {
            ok = 0;
            break;
        }

        c = ED_DiagVinModeChar;
        upper = (WDISP_CharClassTable[c] & 2) ? (unsigned char)(c - 32) : c;
        if (upper == 89 && payload[1] == 48)
            goto runtime3;
        c = ED_DiagVinModeChar;
        upper = (WDISP_CharClassTable[c] & 2) ? (unsigned char)(c - 32) : c;
        if (upper == 76 && payload[1] == 50)
            goto runtime3;
        c = ED_DiagVinModeChar;
        upper = (WDISP_CharClassTable[c] & 2) ? (unsigned char)(c - 32) : c;
        if (upper == 89 && payload[1] == 49)
            goto tryCursor10;
        c = ED_DiagVinModeChar;
        upper = (WDISP_CharClassTable[c] & 2) ? (unsigned char)(c - 32) : c;
        if (upper == 76 && payload[1] == 51)
            goto tryCursor10;
        goto fail;

    default:
        break;
    }
    goto finalize;

    /* The original shares each of these tails between two or four entry points
     * and branches to the common finalize. Keeping them shared is what stops the
     * restoration from carrying four copies. */
cursor4:
    SCRIPT_PlaybackCursor = 4;
    SCRIPT_ChannelRangeArmedFlag = 0;
    goto finalize;

runtime3:
    SCRIPT_RuntimeMode = 3;
    goto finalize;

tryCursor10:
    if (SCRIPT_ReadHandshakeBit5Mask() == 0)
        goto fail;
    SCRIPT_PlaybackCursor = 10;
    goto finalize;

fail:
    ok = 0;

finalize:
    SCRIPT_SaveCtrlContextSnapshot(ctx);

    if (dispatchAfter != 0 && SCRIPT_PlaybackCursor != 0)
        TEXTDISP_HandleScriptCommand(255L, 255L, 0L);

    SCRIPT_RuntimeMode = savedRuntimeMode;
    return ok;
}
