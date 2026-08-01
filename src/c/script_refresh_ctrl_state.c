/* RESTORES: SCRIPT_RefreshCtrlState
 * MODULE:   modules/groups/b/a/script3b_p0_p1_2.s
 * STATUS:   behavioural
 *
 * Sets the control handshake stage from the VIN mode character. The character
 * has to be one of the two in _SCRIPT_Tag_YL for the handshake to run at all,
 * and the stage is then 2 or 1 on the handshake bit. Anything else clears it.
 *
 * The membership test is a call to _STR_FindCharPtr, which is strchr, so the
 * character is pushed as a LONG and the tag pointer with it. Written as C
 * strchr the compiler inlines its own scan loop and the call disappears, which
 * would lose the original's shape, so the helper is called by name.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the two cross-unit calls. The size and the
 *            displacement agree; only the call opcode differs. This is the
 *            whole cross-unit class AGENTS.md records as capped at behavioural
 *            under 6.51.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern char *STR_FindCharPtr(char *s, long c);
extern char SCRIPT_ReadHandshakeBit3Flag(void);

extern unsigned char ED_DiagVinModeChar;
extern char SCRIPT_Tag_YL[];
extern short SCRIPT_CtrlHandshakeStage;

void SCRIPT_RefreshCtrlState(void)
{
    if (STR_FindCharPtr(SCRIPT_Tag_YL, (long)ED_DiagVinModeChar) == 0) {
        SCRIPT_CtrlHandshakeStage = 0;
        return;
    }

    if (SCRIPT_ReadHandshakeBit3Flag() != 0)
        SCRIPT_CtrlHandshakeStage = 2;
    else
        SCRIPT_CtrlHandshakeStage = 1;
}
