/* RESTORES: LOCAVAIL_CopyFilterStateStructRetainRefs
 * MODULE:   modules/groups/a/y/locavail.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-order
 *   ref:     48e70030266f000c246f00101692276a00020002176a00060006206a001027480010276a001400144aab00106706206b00105290245f265f4e75
 *   got:     48e70014266f00102a6f000c1a932b6b000200021b6b00060006206b00102b4800102b6b00140014202d0010670820402210528120814cdf28004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct LocAvailFilterState2 {
    char  flag;
    char  pad;
    long  word;
    char  kind;
    char  pad2[9];
    long *refA;
    long  refB;
};
void LOCAVAIL_CopyFilterStateStructRetainRefs(struct LocAvailFilterState2 *dst,
                                              struct LocAvailFilterState2 *src)
{
    dst->flag = src->flag;
    dst->word = src->word;
    dst->kind = src->kind;
    dst->refA = src->refA;
    dst->refB = src->refB;
    if (dst->refA != 0)
        *(dst->refA) += 1;
}
