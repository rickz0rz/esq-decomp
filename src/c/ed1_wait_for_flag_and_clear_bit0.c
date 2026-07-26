/* RESTORES: ED1_WaitForFlagAndClearBit0
 * MODULE:   modules/groups/a/k/ed1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: loop-shape
 *   ref:     4a790000047867f833fc002e0000a2e030390000a8240240fffe33c00000a824487800014eba6a18584f4e75
 *   got:     30390000000067f833fc002e0000000030390000000048c002800000fffe33c0000000004878000161000000584f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short CTASKS_IffTaskDoneFlag, LADFUNC_EntryCount, ESQIFF_ExternalAssetFlags;
extern void  ESQIFF_ReloadExternalAssetCatalogBuffers(long mode);
void ED1_WaitForFlagAndClearBit0(void)
{
    while (CTASKS_IffTaskDoneFlag == 0)
        ;
    LADFUNC_EntryCount = 0x2e;
    ESQIFF_ExternalAssetFlags = ESQIFF_ExternalAssetFlags & 0xfffe;
    ESQIFF_ReloadExternalAssetCatalogBuffers(1);
}
