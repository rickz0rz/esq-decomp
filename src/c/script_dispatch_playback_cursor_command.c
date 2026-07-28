/* RESTORES: _SCRIPT_DispatchPlaybackCursorCommand
 * MODULE:   modules/groups/b/a/script3b_p0_script_dispatchplaybackcursorcommand.s
 * STATUS:   behavioural
 *
 * Execute one queued playback command and clear the slot. Fifteen commands
 * dispatched through a PC-relative jump table on *slot, plus a default that just
 * bumps a counter. EVERY path -- including the default and the one early-out --
 * converges on the same tail, which clears the search state and zeroes the slot,
 * so the command is consumed whether it was understood or not.
 *
 * Commands 2, 3, 4, 8, 9 and the default all set the match index to -1 first;
 * that is not a shared prologue in the original either, it is repeated per arm.
 *
 * Command 4 (enter-mode-2 deferred) is the only one that can bail: if the
 * deferred countdown is already running it goes straight to the tail without
 * arming anything. It still clears the slot.
 *
 * TWO DECLARED TYPES ARE WRONG AT THE READ SITE, and both are transcribed as the
 * code reads them, not as the data declares them:
 *
 *   CONFIG_BannerCopperHeadByte is DC.B in the data section but read with
 *   MOVE.W, so it takes two bytes -- itself and whatever follows. Declared short
 *   here. Reading it as a char would silently use a different value.
 *
 *   SCRIPT_SearchMatchCountOrIndex is DS.L, and the original does MOVE.L then
 *   EXT.L -- which sign-extends the LOW WORD and discards the high one. So the
 *   value passed on is (long)(short)x, not x. Written that way deliberately.
 *
 * SCRIPT_PendingTextdispCmdArg is the mirror case and is benign: declared DS.W,
 * read with MOVE.B, which on big-endian takes the high byte. `unsigned char`
 * reads the same byte.
 *
 * 524 against 528 -- the CLOSEST result in the tranche at -0.8%, and 2 of the 524
 * are alignment padding, so the body is 522 against 528. Comparing the raw
 * streams side by side they agree instruction for instruction across the whole
 * dispatch: every 33fcffff match-index store, every 4878 argument push, every
 * 4fef000c frame pop, in the same order within each arm.
 *
 * SASC-MISMATCH: call-encoding-jsr-pcrel
 *   ref:     4eba....   JSR (d16,PC)
 *   got:     6100....   BSR.W
 *   summary: the visible per-instruction differences are almost entirely this
 *            class -- same size, same displacement width, different opcode --
 *            plus the order in which the fifteen case bodies are laid out after
 *            the jump table. See script_read_next_rbf_byte.c for the six-byte
 *            isolation of the encoding class and AGENTS.md on why the `4EBA`
 *            bucket is capped at behavioural under 6.51.
 *   tried:   SHORTINT gives 512, i.e. a LARGER delta in the other direction; kept
 *            off. Nothing source-side reaches the call opcode.
 *   scope:   whole-program.
 *   retest:  a compiler that emits JSR (d16,PC) for a call to an extern. On the
 *            evidence here this function is a strong candidate to go exact.
 */

struct CmdSlot { long cmd; };

extern short SCRIPT_ReadModeActiveLatch;
extern short ESQPARS2_ReadModeFlags;
extern short SCRIPT_PendingBannerSpeedMs;
extern short SCRIPT_PendingBannerTargetChar;
extern short CONFIG_BannerCopperHeadByte;      /* DC.B, but read MOVE.W -- see above */
extern unsigned char CONFIG_MSN_FlagChar;
extern short TEXTDISP_DeferredActionCountdown;
extern short TEXTDISP_DeferredActionArmed;
extern short SCRIPT_PlaybackFallbackCounter;
extern short TEXTDISP_CurrentMatchIndex;
extern short TEXTDISP_ChannelSourceMode;
extern short SCRIPT_ChannelRangeDigitChar;
extern long  SCRIPT_SearchMatchCountOrIndex;   /* long, but truncated -- see above */
extern unsigned char SCRIPT_PendingWeatherCommandChar;
extern unsigned char SCRIPT_PendingTextdispCmdChar;
extern unsigned char SCRIPT_PendingTextdispCmdArg;
extern long  SCRIPT_CommandTextPtr;
extern short SCRIPT_RuntimeMode;

extern void WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(void);
extern void SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom(void);
extern void SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen(long a, long b, long c);
extern void TEXTDISP_SetRastForMode(long mode);
extern void TEXTDISP_ResetSelectionAndRefresh(void);
extern void SCRIPT_UpdateSerialShadowFromCtrlByte(long v);
extern void WDISP_HandleWeatherStatusCommand(long ch);
extern void TEXTDISP_HandleScriptCommand(long ch, long arg, long text);
extern void SCRIPT_AssertCtrlLineNow(void);
extern void SCRIPT_ClearSearchTextsAndChannels(void);

void SCRIPT_DispatchPlaybackCursorCommand(struct CmdSlot *slot)
{
    switch (slot->cmd) {

    case 1:
        TEXTDISP_ResetSelectionAndRefresh();
        break;

    case 2:
        TEXTDISP_CurrentMatchIndex = -1;
        WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight();
        TEXTDISP_SetRastForMode(0L);
        if (CONFIG_MSN_FlagChar == 77)
            SCRIPT_UpdateSerialShadowFromCtrlByte(3L);
        else
            SCRIPT_UpdateSerialShadowFromCtrlByte(1L);
        break;

    case 3:
        TEXTDISP_CurrentMatchIndex = -1;
        WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight();
        TEXTDISP_SetRastForMode(0L);
        SCRIPT_UpdateSerialShadowFromCtrlByte(1L);
        break;

    case 4:
        TEXTDISP_CurrentMatchIndex = -1;
        if (TEXTDISP_DeferredActionCountdown)
            break;
        SCRIPT_UpdateSerialShadowFromCtrlByte(3L);
        TEXTDISP_DeferredActionCountdown = 3;
        TEXTDISP_DeferredActionArmed = 1;
        break;

    case 5:
        SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen(
            TEXTDISP_ChannelSourceMode, SCRIPT_ChannelRangeDigitChar, 0L);
        break;

    case 6:
        SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen(
            1L, 53L, (long)(short)SCRIPT_SearchMatchCountOrIndex);
        break;

    case 7:
        SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen(
            0L, 53L, (long)(short)SCRIPT_SearchMatchCountOrIndex);
        break;

    case 8:
        TEXTDISP_CurrentMatchIndex = -1;
        WDISP_HandleWeatherStatusCommand(SCRIPT_PendingWeatherCommandChar);
        break;

    case 9:
        TEXTDISP_CurrentMatchIndex = -1;
        TEXTDISP_HandleScriptCommand(SCRIPT_PendingTextdispCmdChar,
                                     SCRIPT_PendingTextdispCmdArg,
                                     SCRIPT_CommandTextPtr);
        break;

    case 10:
        SCRIPT_AssertCtrlLineNow();
        SCRIPT_RuntimeMode = 1;
        break;

    case 11:
        WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight();
        TEXTDISP_SetRastForMode(0L);
        SCRIPT_PendingBannerSpeedMs = 1000;
        SCRIPT_PendingBannerTargetChar = CONFIG_BannerCopperHeadByte + 28;
        break;

    case 12:
        SCRIPT_PendingBannerSpeedMs = 1000;
        SCRIPT_PendingBannerTargetChar = CONFIG_BannerCopperHeadByte;
        break;

    case 13:
        SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom();
        break;

    case 14:
        SCRIPT_ReadModeActiveLatch = 1;
        ESQPARS2_ReadModeFlags = 256;
        break;

    case 15:
        SCRIPT_ReadModeActiveLatch = ESQPARS2_ReadModeFlags = 0;
        break;

    default:
        TEXTDISP_CurrentMatchIndex = -1;
        SCRIPT_PlaybackFallbackCounter++;
        break;
    }

    SCRIPT_ClearSearchTextsAndChannels();
    slot->cmd = 0;
}
