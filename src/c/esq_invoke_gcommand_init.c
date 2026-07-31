/* RESTORES: ESQ_InvokeGcommandInit
 * MODULE:   modules/groups/a/a/app3.s
 * STATUS:   behavioural
 * DO-NOT-LINK: takes its arguments in REGISTERS, so the compiled C reads the
 *   stack and gets garbage. Proven: esq_dec_color_step.c linked alone over a
 *   clean 356-entry build paints a green panel over the grid area, and
 *   ESQ_SetCopperEffect_Custom compiles to 610000004e75 -- a call and a
 *   return, doing none of the work. Kept for the analysis, never linked.
 *
 * SASC-MISMATCH: register-argument-convention
 *   ref:     48e700c04eb90001d320508f4e75
 *   got:     48e70014266f00102a6f000c2f0b2f0d61000000504f4cdf28004e75
 *   summary: The original takes its arguments in REGISTERS rather than on the stack, so it is callable only from assembly. No C function can express that convention; this restoration documents the logic but cannot be linked in.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 *
 * DO NOT LINK. This restoration is valid as ANALYSIS and its byte comparison
 * stands, but it must never be substituted into a build: takes its arguments in registers AND preserves them.
 * A C function with an ordinary prologue is not a different encoding of that,
 * it is wrong. tools/gen_all_manifest.py excludes it automatically; this note
 * is here so the reason survives if the tooling changes.
 *
 * This class is what hung the machine on the first whole-program C run.
 */
/* Register-argument wrapper: it pushes A0 and A1 as the callee's two arguments,
 * taking them from whatever the caller left in those registers. No C function
 * can source arguments that way; documented, not linkable. */
extern void GCOMMAND_ProcessCtrlCommand(void *a, void *b);
void ESQ_InvokeGcommandInit(void *a, void *b)
{
    GCOMMAND_ProcessCtrlCommand(a, b);
}
