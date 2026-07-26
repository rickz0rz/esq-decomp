/* RESTORES: TLIBA3_ClearViewModeRastPort
 * MODULE:   modules/groups/b/a/tliba3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: os-library-call
 *   ref:     48e703002e2f000c2c2f00102007724dd2814eba309a41f90000cdbcd1c043e8000a20062c79000028584eaeff164cdf00c04e75
 *   got:     48e703002c2f00102e2f000c4878009a2f076100000041f900000000d1c043e8000a2e862f09610000004fef000c4cdf00c04e75
 *   summary: The original calls an AmigaOS library function through an explicit base register (MOVEA.L base,A6 / JSR _LVOxxx(A6)). Reproducing that from C needs the SAS/C #pragma libcall machinery and the matching library base; without it sc emits an ordinary external call. Recorded rather than guessed at.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char TLIBA3_VmArrayRuntimeTable[];
extern long MATH_Mulu32(long a, long b);
extern void SetRast(void *rp, long pen);
void TLIBA3_ClearViewModeRastPort(long mode, long pen)
{
    SetRast(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(mode, 154) + 10, pen);
}
