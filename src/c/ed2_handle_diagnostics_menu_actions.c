/* RESTORES: ED2_HandleDiagnosticsMenuActions
 * MODULE:   modules/groups/a/k/ed2.s
 * STATUS:   behavioural
 *
 * The diagnostics screen's key handler: 23 cases plus a default, dispatched on
 * the key byte at the head of the current editor state-ring slot. The key is also
 * latched into ED_LastKeyCode on the way in, so the case bodies do not need it.
 *
 * OPTIONS:  SHORTINT
 *
 * 1052 bytes in the original, 1052 emitted (1050 plus one alignment NOP), and
 * ALL 23 instructions of the dispatch chain reproduce verbatim. That is the
 * number to judge this by, not the size: without SHORTINT the function also lands
 * within four bytes, and reproduces ZERO of the 23. The chain is the function.
 *
 * SHORTINT is load-bearing and needs one companion change. With 16-bit int,
 * `mask &= ~7` folds the constant in 16 bits and emits ANDI.L #$0000FFF8 -- which
 * would clear the top half of the longword, so it is wrong as well as bigger.
 * Writing `~7L` keeps it a long. That is a trap worth knowing about generally:
 * SHORTINT changes the VALUE of a complemented constant, not just its width.
 *
 * There is no symbol called ED_DiagAvailMemPresetBits as far as the source is
 * concerned. The disassembly names the byte at mask+3 separately and shows
 * `BSET #n` against it, but writing `ED_DiagAvailMemMask |= n` on the longword
 * makes SAS/C emit exactly that BSET against exactly that address. So the three
 * AvailMem preset keys are a three-way radio selection in the bottom three bits
 * of one long, and the "second symbol" is an artifact of reading bytes. Going the
 * other way -- declaring the byte and OR-ing it -- costs 8 bytes per site.
 *
 * Case order in this file is the case-BODY order of the original, not ascending
 * key order -- 33 before 64 before 35, and 40/41 last before the default. SAS/C
 * emits bodies in source order and sorts only the compare chain, so the layout is
 * evidence about the original source and is reproduced rather than tidied.
 *
 * Only the default arm clears ED_DiagnosticsScreenActive; every other case
 * branches past it to the shared return. An unrecognised key is what leaves the
 * diagnostics screen.
 *
 * SASC-MISMATCH: key-in-callee-saved-register
 *   ref:     (nothing)                 no register saved at all; the key lives in
 *                                      D0/D1 and is dead after the chain
 *   got:     2f07 ... 2e1f  and  1007  D7 saved, restored, and copied to D0
 *   summary: 6.51 gives the switch selector a callee-saved register even though
 *            the chain consumes it destructively and nothing needs it afterwards.
 *            +2, +2, +2 against -4 for the original's MOVEQ #0/MOVE.B pair, so +2
 *            net. Declaring the local `long` instead removes it -- and destroys
 *            the chain, dropping all 23 matching instructions. Not worth it.
 *
 * SASC-MISMATCH: multiply-strength-reduction
 *   ref:     7228 4eba68ae             MOVEQ #40,D1 / JSR MATH_Mulu32(PC)
 *   got:     2200 e581 d280 e781       inline ASL/ADD/ASL chain
 *   summary: `* 40` as a call to the runtime helper in the original, inlined by
 *            6.51. The documented class. Note the helper takes its arguments in
 *            D0/D1, so this is the compiler's own calling convention and not
 *            something to reproduce by calling MATH_Mulu32 from the source -- an
 *            earlier draft did exactly that and it is wrong as source even though
 *            it was closer in bytes.
 *
 * SASC-MISMATCH: constant-store-form
 *   ref:     33fc00010000a2f0          MOVE.W #1,(abs).L
 *   got:     33c000000000              MOVE.W D0,(abs).L
 *   summary: The original stores the immediate; 6.51 reuses a register that
 *            already holds 1. This is the same pair gcommand_process_ctrl_command.c
 *            records, where the original emitted BOTH forms for `flag = 1` in one
 *            function -- here it picks the immediate, which is the -2.
 *
 * SASC-MISMATCH: read-modify-write-folding
 *   ref:     30390000a2f0 5240 33c00000a2f0   load / ADDQ / store
 *   got:     527900000000                     ADDQ.W #1,(abs).L
 *   summary: `x = x + 1` on a far global. 6.51 folds it to one instruction; the
 *            original does not fold at all. -8, the largest single item here, and
 *            not reachable from the source -- routing it through a named local
 *            makes 6.51 emit MORE, not less (+12 overall).
 *
 * SASC-MISMATCH: subtract-width
 *   ref:     7230 9081        MOVEQ #48,D1 / SUB.L D1,D0
 *   got:     04400030 48c0    SUBI.W #48,D0 / EXT.L D0
 *   summary: Under SHORTINT the `- 48` happens in 16 bits and is widened after.
 *            +2, and one of the two places SHORTINT costs anything here.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the cross-unit calls.
 */

extern void DISPLIB_DisplayTextAtPosition(void *rp, long x, long y, char *s);
extern long ED_FindNextCharInTable(long c, char *table);
extern void ED_DrawDiagnosticModeText(void);
extern void ED_DrawESCMenuBottomHelp(void);
extern void TLIBA3_DrawViewModeGuides(void *rp);
extern void SCRIPT_UpdateSerialShadowFromCtrlByte(long v);
extern void ESQ_SetCopperEffect_AllOn(void);
extern void ESQ_SetCopperEffect_OffDisableHighlight(void);
extern void ESQ_SetCopperEffect_OnEnableHighlight(void);
extern void ESQ_SetCopperEffect_Default(void);
extern char SCRIPT_ReadHandshakeBit5Mask(void);
extern void SCRIPT_AssertCtrlLineNow(void);
extern void SCRIPT_DeassertCtrlLineNow(void);

extern void *Global_REF_RASTPORT_1;
extern long ED_StateRingIndex;
extern unsigned char ED_StateRingTable[][5];
extern char ED_LastKeyCode;
extern long ED_DiagAvailMemMask;
extern short Global_WORD_MAX_VALUE;
extern short CTRL_HDeltaMax;
extern short ESQIFF_LineErrorCount;
extern short DATACErrs;
extern short ESQIFF_ParseAttemptCount;
extern short SCRIPT_CtrlCmdLengthErrorCount;
extern short SCRIPT_CtrlCmdChecksumErrorCount;
extern short SCRIPT_CtrlCmdCount;
extern unsigned char ED_DiagTextModeChar;
extern unsigned char ED_DiagVinModeChar;
extern unsigned char ED_DiagGraphModeChar;
extern unsigned char ED_DiagScrollSpeedChar;
extern long ED_TextLimit;
extern long ED_BlockOffset;
extern short ED_DiagnosticsViewMode;
extern short ED_DiagnosticsScreenActive;

extern char ED2_TAG_NRLS[];
extern char ED2_STR_NYYLLZ[];
extern char ED2_TAG_NYLRS[];
extern char ED2_STR_SILENCE[];
extern char ED2_STR_LEFT[];
extern char ED2_STR_RIGHT[];
extern char ED2_STR_BACKGROUND[];
extern char ED2_STR_EXT_DOT_VIDEO_ONLY[];
extern char ED2_STR_COMPUTER_ONLY[];
extern char ED2_STR_OVERLAY_EXT_DOT_VIDEO[];
extern char ED2_STR_NEGATIVE_VIDEO[];
extern char ED2_STR_VIDEO_SWITCH[];
extern char ED2_STR_OPEN[];
extern char ED2_STR_CLOSED[];
extern char ED2_STR_START_TAPE_VIDEO[];
extern char ED2_STR_STOP[];

void ED2_HandleDiagnosticsMenuActions(void)
{
    unsigned char key;

    key = ED_StateRingTable[ED_StateRingIndex][0];
    ED_LastKeyCode = key;

    switch (key) {
    case 1:
        if ((ED_DiagAvailMemMask & 7) == 7)
            ED_DiagAvailMemMask &= ~7L;
        else
            ED_DiagAvailMemMask |= 7;
        break;

    case 3:
        ED_DiagAvailMemMask &= ~7L;
        ED_DiagAvailMemMask |= 1;
        break;

    case 6:
        ED_DiagAvailMemMask &= ~7L;
        ED_DiagAvailMemMask |= 2;
        break;

    case 7:
        TLIBA3_DrawViewModeGuides(Global_REF_RASTPORT_1);
        break;

    case 13:
        ED_DiagAvailMemMask &= ~7L;
        ED_DiagAvailMemMask |= 4;
        break;

    case 18:
        SCRIPT_CtrlCmdCount = SCRIPT_CtrlCmdChecksumErrorCount =
            SCRIPT_CtrlCmdLengthErrorCount = ESQIFF_ParseAttemptCount =
            DATACErrs = ESQIFF_LineErrorCount = CTRL_HDeltaMax =
            Global_WORD_MAX_VALUE = 0;
        break;

    case 33:
        ED_DiagTextModeChar = ED_FindNextCharInTable(ED_DiagTextModeChar, ED2_TAG_NRLS);
        ED_DrawDiagnosticModeText();
        break;

    case 64:
        ED_DiagVinModeChar = ED_FindNextCharInTable(ED_DiagVinModeChar, ED2_STR_NYYLLZ);
        ED_DrawDiagnosticModeText();
        break;

    case 35:
        ED_DiagScrollSpeedChar = ED_DiagScrollSpeedChar - 1;
        if (ED_DiagScrollSpeedChar < 51)
            ED_DiagScrollSpeedChar = 54;
        ED_TextLimit = ED_DiagScrollSpeedChar - 48;
        ED_BlockOffset = ED_TextLimit * 40;
        ED_DrawDiagnosticModeText();
        break;

    case 36:
        ED_DiagGraphModeChar = ED_FindNextCharInTable(ED_DiagGraphModeChar, ED2_TAG_NYLRS);
        ED_DrawDiagnosticModeText();
        break;

    case 99:
        if (ED_DiagnosticsViewMode == 1)
            ED_DiagnosticsViewMode = 0;
        else
            ED_DiagnosticsViewMode = 1;
        break;

    case 67:
        ED_DiagnosticsViewMode = ED_DiagnosticsViewMode + 1;
        break;

    case 49:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 175L, 360L, ED2_STR_SILENCE);
        SCRIPT_UpdateSerialShadowFromCtrlByte(0L);
        break;

    case 50:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 175L, 360L, ED2_STR_LEFT);
        SCRIPT_UpdateSerialShadowFromCtrlByte(1L);
        break;

    case 51:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 175L, 360L, ED2_STR_RIGHT);
        SCRIPT_UpdateSerialShadowFromCtrlByte(2L);
        break;

    case 52:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 175L, 360L, ED2_STR_BACKGROUND);
        SCRIPT_UpdateSerialShadowFromCtrlByte(3L);
        break;

    case 53:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 390L,
                                      ED2_STR_EXT_DOT_VIDEO_ONLY);
        ESQ_SetCopperEffect_AllOn();
        break;

    case 54:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 390L,
                                      ED2_STR_COMPUTER_ONLY);
        ESQ_SetCopperEffect_OffDisableHighlight();
        break;

    case 55:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 390L,
                                      ED2_STR_OVERLAY_EXT_DOT_VIDEO);
        ESQ_SetCopperEffect_OnEnableHighlight();
        break;

    case 56:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 390L,
                                      ED2_STR_NEGATIVE_VIDEO);
        ESQ_SetCopperEffect_Default();
        break;

    case 57:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 270L,
                                      ED2_STR_VIDEO_SWITCH);
        if (SCRIPT_ReadHandshakeBit5Mask())
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 235L, 270L,
                                          ED2_STR_CLOSED);
        else
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 235L, 270L,
                                          ED2_STR_OPEN);
        break;

    case 40:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 270L,
                                      ED2_STR_START_TAPE_VIDEO);
        SCRIPT_AssertCtrlLineNow();
        break;

    case 41:
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 270L, ED2_STR_STOP);
        SCRIPT_DeassertCtrlLineNow();
        break;

    default:
        ED_DrawESCMenuBottomHelp();
        ED_DiagnosticsScreenActive = 0;
        break;
    }
}
