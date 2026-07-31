/* RESTORES: ESQFUNC_CommitSecondaryStateAndPersist
 * MODULE:   modules/groups/a/n/esqfunc_p1.s
 * STATUS:   behavioural
 *
 * Promotes the secondary group into the primary one and writes every data file
 * that depends on it, with the read-mode flags forced to 0x100 for the
 * duration and restored afterwards.
 *
 * The save/restore of ESQPARS2_ReadModeFlags is the whole reason the function
 * has a register variable: the original reads the word into D7 first and writes
 * it back last, so a caller's mode survives the twelve calls in between.
 *
 * The order of those calls is the function -- nothing else happens here -- so it
 * is reproduced exactly as listed rather than regrouped.
 *
 * LOCAVAIL_SaveAvailabilityDataFile takes the PRIMARY state first and the
 * secondary second; the original pushes Secondary then Primary, and the push
 * order is the reverse of the argument order.
 *
 * 104 ref vs 104 got, and this is as clean as a call-heavy function gets: the
 * ONLY divergence is the call opcode. Every one of the twelve calls is at the
 * same offset with the same width, both MOVE.W constant stores match, both
 * PEA state addresses match, the PEA banner window matches, and so do the
 * LEA 12(A7),A7 cleanup and the mode save/restore pair.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   ref:     4eba0cbc 4eba4f6e 4eba4fc6 4eba4fac 4eba8634 4eba0bfa 4eba4fb8
 *            JSR (d16,PC) for the seven cross-unit callees
 *   got:     61000000 x7        BSR.W
 *   summary: same size, same displacement, same semantics, different opcode.
 *            The five intra-unit callees are BSR.W in the original too
 *            (6100fa16 / 6100fbfc / 6100f932 / 6100fcf2 / 6100ff22) and those
 *            agree in kind, so this function is a clean isolation of the class
 *            in the same way esqiff_handle_brush_ini_reload_hotkey.c is.
 *   scope:   every cross-unit restoration; AGENTS.md carries the count.
 *            docs/compiler-version.md, "Call encoding depends on the
 *            callee's translation unit".
 *   retest:  a compiler that emits JSR (d16,PC) for a call to an extern.
 */
extern void ESQDISP_PropagatePrimaryTitleMetadataToSecondary(void);
extern void ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup(void);
extern void ESQDISP_PromoteSecondaryGroupToPrimary(void);
extern void ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty(void);
extern void ESQDISP_PromoteSecondaryLineHeadTailIfMarked(void);
extern void ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded(void);
extern void ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile(void);
extern void ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile(char *primary,
                                                             char *secondary);
extern long DATETIME_SavePairToFile(char *window);
extern void ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList(void);
extern void ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile(void);
extern void ESQFUNC_UpdateDiskWarningAndRefreshTick(void);

extern short ESQPARS2_ReadModeFlags;
extern short ESQDISP_PendingGridReinitFlag;
extern char  LOCAVAIL_PrimaryFilterState[];
extern char  LOCAVAIL_SecondaryFilterState[];
extern char  DST_BannerWindowPrimary[];

void ESQFUNC_CommitSecondaryStateAndPersist(void)
{
    short savedMode;

    savedMode = ESQPARS2_ReadModeFlags;
    ESQPARS2_ReadModeFlags = 0x100;
    ESQDISP_PendingGridReinitFlag = 1;

    ESQDISP_PropagatePrimaryTitleMetadataToSecondary();
    ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup();
    ESQDISP_PromoteSecondaryGroupToPrimary();
    ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty();
    ESQDISP_PromoteSecondaryLineHeadTailIfMarked();

    ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded();
    ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile();
    ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile(LOCAVAIL_PrimaryFilterState,
                                                     LOCAVAIL_SecondaryFilterState);
    DATETIME_SavePairToFile(DST_BannerWindowPrimary);
    ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList();
    ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile();
    ESQFUNC_UpdateDiskWarningAndRefreshTick();

    ESQPARS2_ReadModeFlags = savedMode;
}
