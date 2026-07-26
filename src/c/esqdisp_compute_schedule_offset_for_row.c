/* RESTORES: ESQDISP_ComputeScheduleOffsetForRow
 * MODULE:   modules/groups/a/n/esqdispb.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     48e707003e2f00121c2f0017200748c0720012062f012f004eba9dda220048c1d281200748c0d0812a00200548c048780030487800012f004eba831c4fef00142a0020054cdf00e04e75
 *   got:     594f48e727001c2f001f3e2f001a300748c0320748c1740014062f022f012f400018610000002200d281202f0018d0812a0048780030487800012f05610000002a004fef001420054cdf00e4584f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern long DST_BuildBannerTimeWord(long a, long b);
extern long DISPLIB_NormalizeValueByStep(long v, long low, long step);
long ESQDISP_ComputeScheduleOffsetForRow(short row, unsigned char variant)
{
    long off;

    off = (long)row + DST_BuildBannerTimeWord((long)row, (long)variant) * 2;
    off = DISPLIB_NormalizeValueByStep(off, 1, 48);
    return off;
}
