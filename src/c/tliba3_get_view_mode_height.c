/* RESTORES: TLIBA3_GetViewModeHeight
 * MODULE:   modules/groups/b/a/tliba3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: trailing-dead-bytes
 *   ref:     2f072e2f00082007724dd2814eba30e041f90000cdbcd1c0302800042e1f4e752f072e2f00082007724dd2814eba30c041f90000cdbcd1c0302800022e1f4e75
 *   got:     48e701042e2f000c4878009a2f076100000041f900000000d1c02a48302d000448c0504f4cdf20804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct VmEntry { short a; short b; short h; };
extern char TLIBA3_VmArrayRuntimeTable[];
extern long MATH_Mulu32(long a, long b);
long TLIBA3_GetViewModeHeight(long mode)
{
    struct VmEntry *e = (struct VmEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(mode, 154));
    return e->h;
}
