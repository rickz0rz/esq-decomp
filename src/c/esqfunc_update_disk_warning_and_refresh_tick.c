/* RESTORES: ESQFUNC_UpdateDiskWarningAndRefreshTick
 * MODULE:   modules/groups/a/n/esqfunc.s
 * STATUS:   behavioural
 *
 * Re-probes the drives and, if either fault code is set, parks the refresh tick
 * at -1 and draws the matching warning across the second RastPort. With no fault
 * it releases the tick: -1 means "a warning is on screen", so clearing it back to
 * zero is what lets normal refreshing resume.
 *
 * The two conditions map to the messages the way the original branches, which is
 * not the way the symbol names suggest -- Drive0WriteProtectedCode selects the
 * REINSERT text and DriveMediaStatusCodeTable selects the WRITE PROTECTED text.
 * The branch targets are unambiguous; the symbol names are the disassembler's
 * guesses. Following the bytes.
 *
 * 118 bytes in the original, 118 emitted. Two divergences, neither costing a byte.
 *
 * SASC-MISMATCH: block-ordering
 *   ref:     BNE forward to each warning body, both bodies placed AFTER the
 *            no-fault path
 *   got:     BEQ around each body, both inlined where they are written
 *   summary: The same class p_type_allocate_entry.c records. casm reports it as
 *            +40/+40 against -40/-40 -- identical instructions in a different
 *            order, which is also why the region count is meaningless here.
 *
 * SASC-MISMATCH: lea-vs-adda
 *   ref:     41e8000a       LEA 10(A0),A0
 *   got:     d0fc000a       ADDA.W #10,A0
 *   summary: Advancing to the second RastPort. Four bytes either way and the same
 *            effect. Worth recording because AGENTS.md uses the count of
 *            LEA-into-An sites as a fidelity proxy when sizes differ -- this shows
 *            the two forms are interchangeable to 6.51, so a LEA-count mismatch of
 *            one is not automatically a wrong address computation.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the three cross-unit calls.
 */

extern void ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths(void);
extern void ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(char *rp, char *text,
                                                               long width);

extern long DISKIO_Drive0WriteProtectedCode;
extern long DISKIO_DriveMediaStatusCodeTable;
extern short Global_RefreshTickCounter;
extern char *WDISP_DisplayContextBase;
extern char Global_STR_DISK_0_IS_WRITE_PROTECTED[];
extern char Global_STR_YOU_MUST_REINSERT_SYSTEM_DISK_INTO_DRIVE_0[];

void ESQFUNC_UpdateDiskWarningAndRefreshTick(void)
{
    ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths();

    if (DISKIO_Drive0WriteProtectedCode) {
        Global_RefreshTickCounter = -1;
        ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(
            WDISP_DisplayContextBase + 10,
            Global_STR_YOU_MUST_REINSERT_SYSTEM_DISK_INTO_DRIVE_0, 90L);
    } else if (DISKIO_DriveMediaStatusCodeTable) {
        Global_RefreshTickCounter = -1;
        ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(
            WDISP_DisplayContextBase + 10,
            Global_STR_DISK_0_IS_WRITE_PROTECTED, 90L);
    } else if (Global_RefreshTickCounter == -1) {
        Global_RefreshTickCounter = 0;
    }
}
