/* RESTORES: SCRIPT_UpdateRuntimeModeForPlaybackCursor
 * MODULE:   modules/groups/b/a/script3b_p0.s
 * STATUS:   behavioural
 *
 * Moves the runtime mode on. Mode 1 arms mode 2 and returns 1; mode 3 tears the
 * CTRL line down; every mode ends at 0 except the mode-1 path.
 *
 * The return value is a WORD -- the caller tests it with TST.W -- and it is 1
 * only from the mode-1 path.
 *
 * The banner jump is optional: it happens only when the config flag is 'Y', and
 * the character it jumps to is the head byte PLUS 28 at word width before being
 * widened.
 *
 * The shadow selector is a chained subtract over four LETTERS, and the gaps are
 * what the constants encode: 'B' (0x42), then +10 to 'L', then +2 to 'N', then
 * +4 to 'R'. Both 'N' and the default give 0, and they are SEPARATE arms in the
 * original (0x2A634 and 0x2A638) reached from different places -- the letter
 * chain falls to one, the outer MSN test to the other.
 *
 * The outer MSN test accepts 'M' or 'S'; anything else skips the letter chain
 * entirely and uses 0.
 *
 * OPTIONS: SHORTINT (per-file) -- see the measurement below.
 *
 * 212 ref vs 216 got with SHORTINT, and the four-letter chain is reproduced
 * INSTRUCTION FOR INSTRUCTION:
 *
 *     ref  4880 04400042 6718 0440000a 670a 5540 6712 5940 6706 600c
 *     got  4880 04400042 6710 0440000a 670e 5540 6712 5940 670a 6010
 *
 * -- EXT.W, SUBI.W #$42, BEQ, SUBI.W #10, BEQ, SUBQ.W #2, BEQ, SUBQ.W #4, BEQ,
 * BRA, with only the branch displacements differing because 6.51 orders the
 * four result arms differently.
 *
 * Without SHORTINT the function is 220 bytes and the chain widens to long. This
 * is the sixth sighting of the AGENTS.md pairing: a chained-subtract dispatch
 * wants `switch` and `SHORTINT` together.
 *
 * SASC-MISMATCH: case-body-layout
 *   ref:     7e01 600e / 7e02 600a / 7e03 6006 / 7e00 6002 / 7e00
 *            arms in the order 1, 2, 3, 0, 0
 *   got:     7e03 6012 / 7e01 600e / 7e02 600a / 7e00 6006 / 7e00 6002 / 3007
 *            arms in the order 3, 1, 2, 0, 0
 *   summary: same five arms with the same five constants; 6.51 emits them in a
 *            different order, which shifts every displacement in the chain
 *            above and costs the 4 bytes.
 *   scope:   program-wide. docs/compiler-version.md, "Parameter and case
 *            layout".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern void SCRIPT_BeginBannerCharTransition(long ch, long speed);
extern void WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(void);
extern void TEXTDISP_SetRastForMode(long mode);
extern void SCRIPT_UpdateSerialShadowFromCtrlByte(long shadow);
extern void SCRIPT_ClearSearchTextsAndChannels(void);
extern void SCRIPT_DeassertCtrlLineNow(void);

extern short SCRIPT_RuntimeMode;
extern short SCRIPT_RuntimeModeDispatchLatch;
extern short SCRIPT_CtrlHandshakeRetryCount;
extern short TEXTDISP_CurrentMatchIndex;
extern short CONFIG_BannerCopperHeadByte;
extern char  CONFIG_RuntimeMode12BannerJumpEnabledFlag;
extern char  CONFIG_MSN_FlagChar;
extern char  CONFIG_MsnRuntimeModeSelectorChar_LRBN;

short SCRIPT_UpdateRuntimeModeForPlaybackCursor(void)
{
    short shadow;

    if (SCRIPT_RuntimeMode == 1) {

        if (CONFIG_RuntimeMode12BannerJumpEnabledFlag == 'Y')
            SCRIPT_BeginBannerCharTransition(
                (long)(short)(CONFIG_BannerCopperHeadByte + 28), 1000L);

        SCRIPT_CtrlHandshakeRetryCount = 0;
        TEXTDISP_CurrentMatchIndex     = -1;
        SCRIPT_RuntimeMode             = 2;
        SCRIPT_RuntimeModeDispatchLatch = 1;

        WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight();
        TEXTDISP_SetRastForMode(0L);

        if (CONFIG_MSN_FlagChar == 'M' || CONFIG_MSN_FlagChar == 'S') {
            switch (CONFIG_MsnRuntimeModeSelectorChar_LRBN) {
            case 'B':  shadow = 3; break;
            case 'L':  shadow = 1; break;
            case 'R':  shadow = 2; break;
            case 'N':  shadow = 0; break;
            default:   shadow = 0; break;
            }
        } else {
            shadow = 0;
        }

        SCRIPT_UpdateSerialShadowFromCtrlByte((long)(unsigned char)shadow);
        SCRIPT_ClearSearchTextsAndChannels();
        return 1;
    }

    if (SCRIPT_RuntimeMode == 3) {
        SCRIPT_DeassertCtrlLineNow();
        SCRIPT_RuntimeModeDispatchLatch = 0;
    }

    SCRIPT_RuntimeMode = 0;
    return 0;
}
