/* RESTORES: _DISKIO2_ReloadDataFilesAndRebuildIndex
 * MODULE:   modules/groups/a/h/diskio2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: jsr-pcrel-vs-bsr
 *   ref:     6100<d> 6100<d> 6100<d> 4eba000a 4e75   (three BSR.W, then JSR (d16,PC))
 *   got:     6100<d> 6100<d> 6100<d> 6100000c 4e75   (four BSR.W)
 *   summary: The original encodes the fourth call as JSR (d16,PC) where SAS/C
 *            emits BSR.W. Both are four-byte PC-relative subroutine calls with
 *            identical semantics and identical size, so only the opcode differs.
 *            The original's own assembly mixes the two forms, so this is a
 *            code-generator choice rather than something the source controls.
 *   tried:   call ordering, direct call vs through the JMPTBL wrapper.
 *   retest:  a compiler emitting JSR (d16,PC) for the last call in a sequence
 *            would match this source unchanged.
 *
 * NOTE: this was briefly recorded as `exact`. tools/cmatch.sh masked four bytes
 * at every external reference, but a 16-bit PC-relative reference is only two
 * bytes wide, so the mask also blanked the following opcode and hid the
 * difference. Masking is now width-aware; re-checking every exact restoration
 * afterwards demoted this one and confirmed the other seventeen.
 */
extern void DISKIO2_LoadCurDayDataFile(void);
extern void DISKIO2_LoadNxtDayDataFile(void);
extern void DISKIO2_LoadOinfoDataFile(void);
extern void NEWGRID_RebuildIndexCache(void);
void DISKIO2_ReloadDataFilesAndRebuildIndex(void)
{
    DISKIO2_LoadCurDayDataFile();
    DISKIO2_LoadNxtDayDataFile();
    DISKIO2_LoadOinfoDataFile();
    NEWGRID_RebuildIndexCache();
}
