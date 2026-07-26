/* RESTORES: ED1_WaitForFlagAndClearBit1
 * MODULE:   modules/groups/a/k/ed1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: loop-shape
 *   ref:     4a790000047867f833fc002e0000a2e030390000a8240240fffd33c00000a82442a74eba6a44584f4e75
 *   got:     30390000000067f833fc002e0000000030390000000048c002800000fffd33c00000000042a761000000584f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short CTASKS_IffTaskDoneFlag, LADFUNC_EntryCount, ESQIFF_ExternalAssetFlags;
extern void  ESQIFF_ReloadExternalAssetCatalogBuffers(long mode);
void ED1_WaitForFlagAndClearBit1(void)
{
    while (CTASKS_IffTaskDoneFlag == 0)
        ;
    LADFUNC_EntryCount = 0x2e;
    ESQIFF_ExternalAssetFlags = ESQIFF_ExternalAssetFlags & 0xfffd;
    ESQIFF_ReloadExternalAssetCatalogBuffers(0);
}
