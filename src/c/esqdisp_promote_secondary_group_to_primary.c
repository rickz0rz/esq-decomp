/* RESTORES: ESQDISP_PromoteSecondaryGroupToPrimary
 * MODULE:   modules/groups/a/n/esqdisp.s
 * STATUS:   behavioural
 *
 * 254 bytes in the original, 252 emitted, only SEVEN differing regions.
 *
 * Reproduces: the entry release, the four-way slot move loop (primary gets the
 * secondary pointers, secondary slots are nulled, both tables indexed off one
 * scaled offset), the metadata copy, the mutation-state transition to 3 and the
 * CTASKS handoff -- including that the CTASKS block sits OUTSIDE the
 * present-flag test and runs on both paths.
 *
 * The chained-assignment rule from AGENTS.md was load-bearing here and is worth
 * a concrete note. Written as separate statements:
 *
 *     TEXTDISP_GroupMutationState = 0;
 *     TEXTDISP_PrimaryGroupRecordLength = 0;
 *
 * SAS/C emits CLR.W twice (4279 xxxxxxxx). The original holds zero in a register
 * and stores it twice (7000 / 33C0 xxxxxxxx). Writing it as
 *
 *     TEXTDISP_PrimaryGroupRecordLength = TEXTDISP_GroupMutationState = 0;
 *
 * reproduces the original exactly. Same for the secondary pair. That single
 * change took this restoration from 244 bytes and 5 mismatched regions to 252
 * and a much closer structural match.
 *
 * SASC-MISMATCH: set-byte-true-idiom
 *   ref:     13fc00ff xxxxxxxx          MOVE.B #$ff,(abs).L      8 bytes
 *   got:     50f9 xxxxxxxx              ST (abs).L               6 bytes
 *   summary: SAS/C reaches for ST to store 0xFF where the original writes the
 *            immediate. This is the entire -2 byte delta. Note the direction:
 *            here SAS/C is the more compact one, another counterexample to
 *            "the original optimises less".
 *   scope:   every byte store of 0xFF / -1.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the two cross-unit calls.
 */
extern void ESQPARS_RemoveGroupEntryAndReleaseStrings(long which);
extern void ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache(void);

extern long  NEWGRID_RefreshStateFlag;
extern short TEXTDISP_GroupMutationState;
extern char  TEXTDISP_PrimaryGroupRecordChecksum;
extern short TEXTDISP_PrimaryGroupRecordLength;
extern char  TEXTDISP_PrimaryGroupHeaderCode;
extern char  TEXTDISP_PrimaryGroupPresentFlag;
extern short TEXTDISP_PrimaryGroupEntryCount;
extern char  TEXTDISP_SecondaryGroupRecordChecksum;
extern short TEXTDISP_SecondaryGroupRecordLength;
extern char  TEXTDISP_SecondaryGroupHeaderCode;
extern char  TEXTDISP_SecondaryGroupPresentFlag;
extern short TEXTDISP_SecondaryGroupEntryCount;
extern void *TEXTDISP_PrimaryEntryPtrTable[];
extern void *TEXTDISP_SecondaryEntryPtrTable[];
extern void *TEXTDISP_PrimaryTitlePtrTable[];
extern void *TEXTDISP_SecondaryTitlePtrTable[];
extern char  CTASKS_PendingPrimaryOiDiskId;
extern char  CTASKS_PendingSecondaryOiDiskId;
extern char  CTASKS_PrimaryOiWritePendingFlag;
extern char  CTASKS_SecondaryOiWritePendingFlag;

void ESQDISP_PromoteSecondaryGroupToPrimary(void)
{
    register short i;

    ESQPARS_RemoveGroupEntryAndReleaseStrings(1);
    NEWGRID_RefreshStateFlag = 1;
    TEXTDISP_PrimaryGroupRecordLength = TEXTDISP_GroupMutationState = 0;
    TEXTDISP_PrimaryGroupRecordChecksum = 0;

    if (TEXTDISP_SecondaryGroupPresentFlag == 1) {
        for (i = 0; i < TEXTDISP_SecondaryGroupEntryCount; i++) {
            TEXTDISP_PrimaryEntryPtrTable[i] = TEXTDISP_SecondaryEntryPtrTable[i];
            TEXTDISP_PrimaryTitlePtrTable[i] = TEXTDISP_SecondaryTitlePtrTable[i];
            TEXTDISP_SecondaryEntryPtrTable[i] = 0;
            TEXTDISP_SecondaryTitlePtrTable[i] = 0;
        }
        TEXTDISP_PrimaryGroupEntryCount     = TEXTDISP_SecondaryGroupEntryCount;
        TEXTDISP_PrimaryGroupRecordChecksum = TEXTDISP_SecondaryGroupRecordChecksum;
        TEXTDISP_PrimaryGroupHeaderCode     = TEXTDISP_SecondaryGroupHeaderCode;
        TEXTDISP_PrimaryGroupRecordLength   = TEXTDISP_SecondaryGroupRecordLength;
        TEXTDISP_PrimaryGroupPresentFlag    = 1;
        TEXTDISP_SecondaryGroupRecordLength   = TEXTDISP_SecondaryGroupEntryCount = 0;
        TEXTDISP_SecondaryGroupPresentFlag    = TEXTDISP_SecondaryGroupRecordChecksum = 0;
        TEXTDISP_GroupMutationState = 3;
    }

    CTASKS_PendingPrimaryOiDiskId      = CTASKS_PendingSecondaryOiDiskId;
    CTASKS_PrimaryOiWritePendingFlag   = CTASKS_SecondaryOiWritePendingFlag;
    CTASKS_PendingSecondaryOiDiskId    = 0xff;
    CTASKS_SecondaryOiWritePendingFlag = 0;

    ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache();
}
