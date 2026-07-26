/* RESTORES: SCRIPT_AssertCtrlLineIfEnabled
 * MODULE:   modules/groups/b/a/script2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: external-call-width
 *   ref:     4a790000a354670261ce4e75
 *   got:     3039000000006704610000004e75
 *   summary: SAS/C 6.51 emits JSR (xxx).L (6 bytes) for a call to an external function where the original uses BSR.W (4 bytes), because with separate compilation the callee is not in the same section. That accounts for +2 bytes per call site. See docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short SCRIPT_CtrlInterfaceEnabledFlag;
extern void  SCRIPT_AssertCtrlLine(void);
void SCRIPT_AssertCtrlLineIfEnabled(void)
{
    if (SCRIPT_CtrlInterfaceEnabledFlag != 0)
        SCRIPT_AssertCtrlLine();
}
