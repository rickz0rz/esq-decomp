/* RESTORES: ESQ_InvokeGcommandInit
 * MODULE:   modules/groups/a/a/app3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     48e700c04eb90001d320508f4e75
 *   got:     48e70014266f00102a6f000c2f0b2f0d61000000504f4cdf28004e75
 *   summary: The original takes its arguments in REGISTERS rather than on the stack, so it is callable only from assembly. No C function can express that convention; this restoration documents the logic but cannot be linked in.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
/* Register-argument wrapper: it pushes A0 and A1 as the callee's two arguments,
 * taking them from whatever the caller left in those registers. No C function
 * can source arguments that way; documented, not linkable. */
extern void GCOMMAND_ProcessCtrlCommand(void *a, void *b);
void ESQ_InvokeGcommandInit(void *a, void *b)
{
    GCOMMAND_ProcessCtrlCommand(a, b);
}
