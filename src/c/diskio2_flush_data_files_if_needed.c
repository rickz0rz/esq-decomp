/* RESTORES: DISKIO2_FlushDataFilesIfNeeded
 * MODULE:   modules/groups/a/h/diskio2_p2.s
 * STATUS:   behavioural
 *
 * Writes the three day/info data files and any pending OI files, guarded by a
 * re-entry flag.
 *
 * The guard is a WORD (TST.W / MOVE.W #1 / CLR.W), and it is a re-entry lock
 * rather than a done-marker: a non-zero value means somebody is already inside
 * and the call returns at once.
 *
 * The entry-count bound is CMPI.W #$c9 / BCC -- an UNSIGNED compare -- so the
 * count is an unsigned short and the test is `< 201`.
 *
 * The guard is cleared on BOTH exits from the body, including the one that
 * skips all the writing: the BCC jumps directly to the CLR.W, not past it. A
 * restoration that returned early there would leave the lock set forever.
 *
 * 96 ref vs 96 got, and the structure carries it. Every instruction agrees in
 * kind, order and size: the MOVE.W #1 guard set, the CMPI.W #$c9 / BCC bound,
 * the three write calls, both TST.B flag tests, both MOVEQ #0 / MOVE.B disk-id
 * widenings, both ADDQ.W #4,A7 cleanups and the closing CLR.W. Two items
 * differ and neither changes a byte count.
 *
 * SASC-MISMATCH: test-vs-load-and-test
 *   ref:     4a79000016a6        TST.W guard
 *   got:     303900000000        MOVE.W guard,D0
 *   summary: the original tests the word in memory; 6.51 loads it into D0 and
 *            lets the load set the flags. Same six bytes, same condition
 *            codes. Note the other two guard accesses (MOVE.W #1 and CLR.W)
 *            match exactly, so this is specific to the test.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   ref:     4ebaad64 / 4ebaad4c    JSR (d16,PC) for the two OI writes
 *   got:     61000000 x2            BSR.W
 *   summary: same size, same displacement, same semantics, different opcode.
 *            The three day-file calls are BSR.W in the original too
 *            (6100e3bc / 6100ee68 / 6100f598) and those agree in kind.
 *   scope:   every cross-unit restoration; AGENTS.md carries the count.
 *            docs/compiler-version.md, "Call encoding depends on the
 *            callee's translation unit".
 *   retest:  a compiler that emits JSR (d16,PC) for a call to an extern.
 */
extern void DISKIO2_WriteCurDayDataFile(void);
extern void DISKIO2_WriteNxtDayDataFile(void);
extern void DISKIO2_WriteOinfoDataFile(void);
extern void COI_WriteOiDataFile(long diskId);

extern short DISKIO2_FlushDataFilesGuardFlag;
extern unsigned short TEXTDISP_PrimaryGroupEntryCount;
extern unsigned char  CTASKS_PrimaryOiWritePendingFlag;
extern unsigned char  CTASKS_SecondaryOiWritePendingFlag;
extern unsigned char  CTASKS_PendingPrimaryOiDiskId;
extern unsigned char  CTASKS_PendingSecondaryOiDiskId;

void DISKIO2_FlushDataFilesIfNeeded(void)
{
    if (DISKIO2_FlushDataFilesGuardFlag != 0)
        return;

    DISKIO2_FlushDataFilesGuardFlag = 1;

    if (TEXTDISP_PrimaryGroupEntryCount < 0xc9) {
        DISKIO2_WriteCurDayDataFile();
        DISKIO2_WriteNxtDayDataFile();
        DISKIO2_WriteOinfoDataFile();

        if (CTASKS_PrimaryOiWritePendingFlag)
            COI_WriteOiDataFile((long)CTASKS_PendingPrimaryOiDiskId);

        if (CTASKS_SecondaryOiWritePendingFlag)
            COI_WriteOiDataFile((long)CTASKS_PendingSecondaryOiDiskId);
    }

    DISKIO2_FlushDataFilesGuardFlag = 0;
}
