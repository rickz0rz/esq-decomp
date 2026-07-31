/* RESTORES: ESQ_PollCtrlInput
 * MODULE:   modules/groups/a/a/app_esq_pollctrlinput.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-save-shape
 *   ref:     2f0d2f0c612649f9000028d0122c00120c01004e66044ebafeae207c00dff000317c0100009c285f2a5f4e75
 *   got:     61000000103900000006724eb001660461000000207c00dff09c30bc01004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 *
 * DO NOT LINK. This restoration is valid as ANALYSIS and its byte comparison
 * stands, but it must never be substituted into a build: installed as the AUD1 interrupt vector: entered with is_Data in A1, nothing on the stack.
 * A C function with an ordinary prologue is not a different encoding of that,
 * it is wrong. tools/gen_all_manifest.py excludes it automatically; this note
 * is here so the reason survives if the tooling changes.
 *
 * This class is what hung the machine on the first whole-program C run.
 */
extern char ESQ_STR_B[];
extern void ESQ_CaptureCtrlBit4Stream(void);
extern void ESQ_CaptureCtrlBit3Stream(void);
#define INTREQW (*(volatile unsigned short *)0xDFF09CL)
void ESQ_PollCtrlInput(void)
{
    ESQ_CaptureCtrlBit4Stream();
    if (ESQ_STR_B[6] == 'N')
        ESQ_CaptureCtrlBit3Stream();
    INTREQW = 0x100;
}
