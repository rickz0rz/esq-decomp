/* RESTORES: SCRIPT_UpdateCtrlStateMachine
 * MODULE:   modules/groups/b/a/script3b_p0.s
 * STATUS:   behavioural
 *
 * Drives the CTRL handshake: sample the line, then act on the current stage.
 *
 * THIS EXTRACT IS TWO FUNCTIONS, and that is why the file defines two. The
 * original opens with BSR to a label INSIDE its own extract (0x2A6E2) and
 * carries TWO RTS instructions -- one at 0x2A6E0 ending the state machine and
 * one at 0x2A71E ending the sampler. A single C function cannot produce a
 * BSR/RTS pair to itself, so the sampler is a `static` helper. It is declared
 * before the caller and DEFINED after it, which is what puts the two bodies in
 * the original's order.
 *
 * The sampler decides the stage from two inputs: whether the current VIN mode
 * character appears in the YL tag, and if so what the handshake bit reads.
 * Absent from the tag clears the stage to 0; present with the bit CLEAR gives
 * stage 1; present with it set gives stage 2. The bit test is TST.B on a byte
 * result.
 *
 * In the state machine, mode 2 is the only active mode -- anything else just
 * clears the retry count. Stage 1 counts retries and gives up at 3, stage 2
 * clears the count, and any other stage falls through to the UI-busy check.
 *
 * The give-up path reuses the SAME MOVEQ #3 for both the retry threshold and
 * the new runtime mode, which is why the two constants are equal in the
 * original rather than by coincidence.
 *
 * 176 ref vs 180 got, counting BOTH functions -- the extract covers the state
 * machine and the sampler, and so does the object.
 *
 * The two-function split reproduces the original structure: the opening BSR is
 * present with a forward displacement (61000072 against the original 61000070),
 * both bodies appear in the original order, and there are two RTS. Every stage
 * comparison, the MOVEQ #3 shared between the retry threshold and the runtime
 * mode, the FindCharPtr call with its ADDQ.W #8 cleanup, the TST.B on the
 * handshake bit and all four MOVE.W stage stores match in kind and size.
 *
 * SASC-MISMATCH: register-variable-for-retry-count
 *   ref:     2200 5241 33c1....     MOVE.L D0,D1 / ADDQ.W #1,D1 / store D1
 *   got:     3e00 5247 33c7....     MOVE.W D0,D7 / ADDQ.W #1,D7 / store D7
 *   summary: the retry count lands in a saved register in 6.51, which then has
 *            to be pushed and popped (2f07 / 2e1f) -- 4 bytes the original does
 *            not spend because it uses the scratch D1. Same arithmetic.
 *   scope:   program-wide register allocation. docs/compiler-version.md,
 *            "A third divergence: register allocation order".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
static void SCRIPT_RefreshCtrlState(void);

extern char *STR_FindCharPtr(char *s, long ch);
extern char  SCRIPT_ReadHandshakeBit3Flag(void);
extern void  SCRIPT_DeassertCtrlLineNow(void);
extern void  TEXTDISP_ResetSelectionAndRefresh(void);

extern short SCRIPT_RuntimeMode;
extern short SCRIPT_CtrlHandshakeStage;
extern short SCRIPT_CtrlHandshakeRetryCount;
extern short Global_UIBusyFlag;
extern unsigned char ED_DiagVinModeChar;
extern char  SCRIPT_Tag_YL[];

void SCRIPT_UpdateCtrlStateMachine(void)
{
    short retries;

    SCRIPT_RefreshCtrlState();

    if (SCRIPT_RuntimeMode != 2) {
        SCRIPT_CtrlHandshakeRetryCount = 0;
        return;
    }

    if (SCRIPT_CtrlHandshakeStage == 1) {
        retries = SCRIPT_CtrlHandshakeRetryCount + 1;
        SCRIPT_CtrlHandshakeRetryCount = retries;

        if (retries >= 3) {
            SCRIPT_CtrlHandshakeRetryCount = 0;
            SCRIPT_RuntimeMode = 3;
            SCRIPT_DeassertCtrlLineNow();
            TEXTDISP_ResetSelectionAndRefresh();
        }
        return;
    }

    if (SCRIPT_CtrlHandshakeStage == 2) {
        SCRIPT_CtrlHandshakeRetryCount = 0;
        return;
    }

    if (Global_UIBusyFlag != 0)
        SCRIPT_RuntimeMode = 3;
}

static void SCRIPT_RefreshCtrlState(void)
{
    if (STR_FindCharPtr(SCRIPT_Tag_YL, (long)ED_DiagVinModeChar) != 0) {
        if (SCRIPT_ReadHandshakeBit3Flag())
            SCRIPT_CtrlHandshakeStage = 2;
        else
            SCRIPT_CtrlHandshakeStage = 1;
    } else {
        SCRIPT_CtrlHandshakeStage = 0;
    }
}
