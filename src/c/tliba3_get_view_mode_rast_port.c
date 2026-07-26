/* RESTORES: TLIBA3_GetViewModeRastPort
 * MODULE:   modules/groups/b/a/tliba3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: external-call-width
 *   ref:     2f072e2f00082007724dd2814eba306c41f90000cdbcd1c043e8000a20092e1f4e75
 *   got:     2f072e2f00084878009a2f076100000041f900000000d1c043e8000a504f20092e1f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char TLIBA3_VmArrayRuntimeTable[];
extern long MATH_Mulu32(long a, long b);
char *TLIBA3_GetViewModeRastPort(long index)
{
    return TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(index, 154) + 10;
}
