/* RESTORES: ESQPARS_PersistStateDataAfterCommand
 * MODULE:   modules/groups/a/o/esqpars.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-slot-reuse
 *   ref:     4eba002a4eba53cc4879000081604eba002848790000b3e448790000b3cc4eba6eec4eba00784fef000c4e75
 *   got:     61000000610000004879000000006100000048790000000048790000000061000000610000004fef000c4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char DST_BannerWindowPrimary[];
extern char LOCAVAIL_PrimaryFilterState[], LOCAVAIL_SecondaryFilterState[];
extern void DISKIO2_FlushDataFilesIfNeeded(void);
extern void LADFUNC_SaveTextAdsToFile(void);
extern void DATETIME_SavePairToFile(char *p);
extern void LOCAVAIL_SaveAvailabilityDataFile(char *a, char *b);
extern void P_TYPE_WritePromoIdDataFile(void);
void ESQPARS_PersistStateDataAfterCommand(void)
{
    DISKIO2_FlushDataFilesIfNeeded();
    LADFUNC_SaveTextAdsToFile();
    DATETIME_SavePairToFile(DST_BannerWindowPrimary);
    LOCAVAIL_SaveAvailabilityDataFile(LOCAVAIL_PrimaryFilterState,
                                      LOCAVAIL_SecondaryFilterState);
    P_TYPE_WritePromoIdDataFile();
}
