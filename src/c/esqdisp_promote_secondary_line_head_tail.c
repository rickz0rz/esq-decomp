/* RESTORES: ESQDISP_PromoteSecondaryLineHeadTailIfMarked
 * MODULE:   modules/groups/a/n/esqdispb.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: global-store-order
 *   ref:     4a790000a348672c487800014eba2b06584f23f900002946000023f90000294a000091c823c80000294623c80000294a42790000a3484e75
 *   got:     303900000000672a4878000161000000584f23f9000000000000000023f9000000000000000042b90000000042b9000000004279000000004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short ESQDISP_SecondaryLinePromotePendingFlag;
extern void *ESQIFF_SecondaryLineHeadPtr, *ESQIFF_SecondaryLineTailPtr;
extern void *ESQIFF_PrimaryLineHeadPtr, *ESQIFF_PrimaryLineTailPtr;
extern void  ESQIFF2_ClearLineHeadTailByMode(long mode);
void ESQDISP_PromoteSecondaryLineHeadTailIfMarked(void)
{
    if (ESQDISP_SecondaryLinePromotePendingFlag != 0) {
        ESQIFF2_ClearLineHeadTailByMode(1);
        ESQIFF_PrimaryLineHeadPtr = ESQIFF_SecondaryLineHeadPtr;
        ESQIFF_PrimaryLineTailPtr = ESQIFF_SecondaryLineTailPtr;
        ESQIFF_SecondaryLineHeadPtr = 0;
        ESQIFF_SecondaryLineTailPtr = 0;
    }
    ESQDISP_SecondaryLinePromotePendingFlag = 0;
}
