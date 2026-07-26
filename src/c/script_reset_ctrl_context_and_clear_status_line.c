/* RESTORES: SCRIPT_ResetCtrlContextAndClearStatusLine
 * MODULE:   modules/groups/b/a/script3b.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     42a7700046002f002f004eba138048790000c0be6100fd644fef00104e75
 *   got:     42a7700046002f002f0061000000487900000000610000004fef00104e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char SCRIPT_CTRL_CONTEXT[];
extern void TEXTDISP_HandleScriptCommand(long a, long b, long c);
extern void SCRIPT_ResetCtrlContext(char *ctx);
void SCRIPT_ResetCtrlContextAndClearStatusLine(void)
{
    TEXTDISP_HandleScriptCommand(0xff, 0xff, 0);
    SCRIPT_ResetCtrlContext(SCRIPT_CTRL_CONTEXT);
}
