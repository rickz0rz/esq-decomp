/* RESTORES: ESQIFF_ServiceExternalAssetSourceState
 * MODULE:   modules/groups/a/n/esqiffbb_p0_p0.s
 * STATUS:   behavioural
 *
 * Picks the asset source, reloads either catalog whose drive is available, and
 * queues the next IFF job.
 *
 * Two early exits, and the grid pump runs BETWEEN them -- the RAVESC check
 * returns before pumping, the overlay-busy check after. Moving the pump would
 * change how often the grid gets serviced.
 *
 * The two source flags are set to 0 and -1 in opposite pairings depending on
 * the mode, so exactly one source is active either way.
 *
 * Each reload is guarded by TWO conditions: the drive's write-protect code must
 * be zero AND the corresponding bit of ESQIFF_ExternalAssetFlags must be CLEAR.
 * The bit test is written as ANDI.W then SUBQ.W, so it compares the masked
 * value against the mask -- a set bit SKIPS the reload.
 *
 * Note which bit goes with which drive: bit 2 guards drive 0 and the reload
 * with argument 0, bit 1 guards drive 1 and the reload with argument 1.
 *
 * 136 ref vs 136 got. Both ANDI.W bit masks with their SUBQ.W tests, both
 * write-protect guards, both reload calls with their PEA arguments and
 * ADDQ.W #4 cleanups, the -1 and 0 source-flag stores and both grid-pump calls
 * match in kind, order and size.
 *
 * SASC-MISMATCH: test-vs-load-and-test
 *   ref:     4a7900002964 6676     TST.W global / BNE
 *   got:     303900000000 6674     MOVE.W global,D0 / BNE
 *   summary: the original tests the word in memory; 6.51 loads it into D0 and
 *            lets the load set the flags. Same six bytes. Both early-exit
 *            guards do it. Same item as diskio2_flush_data_files_if_needed.c.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: zero-through-register-vs-clr
 *   ref:     7000 33c00000a8b8 72ff 33c10000a8ba
 *            MOVEQ #0 / store / MOVEQ #-1 / store
 *   got:     42790000.... 70ff 33c000000000
 *            CLR.W / MOVEQ #-1 / store
 *   summary: 6.51 emits CLR.W for the zero arm where the original routes it
 *            through a register. Same two values into the same two globals.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern void ESQDISP_ProcessGridMessagesIfIdle(void);
extern void ESQIFF_ReloadExternalAssetCatalogBuffers(long which);
extern void ESQIFF_QueueNextExternalAssetIffJob(void);

extern short Global_WORD_SELECT_CODE_IS_RAVESC;
extern short COI_AttentionOverlayBusyFlag;
extern short ESQIFF_AssetSourceSelect;
extern short ESQIFF_GAdsSourceEnabled;
extern short ESQIFF_ExternalAssetFlags;
extern long  DISKIO_Drive0WriteProtectedCode;
extern long  DISKIO_DriveWriteProtectStatusCodeDrive1;

void ESQIFF_ServiceExternalAssetSourceState(short mode)
{
    if (Global_WORD_SELECT_CODE_IS_RAVESC != 0)
        return;

    ESQDISP_ProcessGridMessagesIfIdle();

    if (COI_AttentionOverlayBusyFlag != 0)
        return;

    if (mode != 0) {
        ESQIFF_AssetSourceSelect = 0;
        ESQIFF_GAdsSourceEnabled = -1;
    } else {
        ESQIFF_GAdsSourceEnabled = 0;
        ESQIFF_AssetSourceSelect = -1;
    }

    if (DISKIO_Drive0WriteProtectedCode == 0
        && (ESQIFF_ExternalAssetFlags & 2) != 2)
        ESQIFF_ReloadExternalAssetCatalogBuffers(0L);

    if (DISKIO_DriveWriteProtectStatusCodeDrive1 == 0
        && (ESQIFF_ExternalAssetFlags & 1) != 1)
        ESQIFF_ReloadExternalAssetCatalogBuffers(1L);

    ESQDISP_ProcessGridMessagesIfIdle();
    ESQIFF_QueueNextExternalAssetIffJob();
}
