typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern LONG NEWGRID_RefreshStateFlag;
extern WORD TEXTDISP_GroupMutationState;
extern UBYTE TEXTDISP_PrimaryGroupRecordChecksum;
extern WORD TEXTDISP_PrimaryGroupRecordLength;
extern UBYTE TEXTDISP_SecondaryGroupPresentFlag;
extern WORD TEXTDISP_SecondaryGroupEntryCount;
extern WORD TEXTDISP_PrimaryGroupEntryCount;
extern void *TEXTDISP_PrimaryEntryPtrTable[];
extern void *TEXTDISP_SecondaryEntryPtrTable[];
extern void *TEXTDISP_PrimaryTitlePtrTable[];
extern void *TEXTDISP_SecondaryTitlePtrTable[];
extern UBYTE TEXTDISP_SecondaryGroupRecordChecksum;
extern UBYTE TEXTDISP_SecondaryGroupHeaderCode;
extern WORD TEXTDISP_SecondaryGroupRecordLength;
extern UBYTE TEXTDISP_PrimaryGroupHeaderCode;
extern UBYTE TEXTDISP_PrimaryGroupPresentFlag;
extern UBYTE CTASKS_PendingSecondaryOiDiskId;
extern UBYTE CTASKS_PendingPrimaryOiDiskId;
extern UBYTE CTASKS_SecondaryOiWritePendingFlag;
extern UBYTE CTASKS_PrimaryOiWritePendingFlag;

extern void ESQPARS_RemoveGroupEntryAndReleaseStrings(WORD mode);
extern void ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache(void);

void ESQDISP_PromoteSecondaryGroupToPrimary(void)
{
    LONG idx;

    ESQPARS_RemoveGroupEntryAndReleaseStrings(1);

    NEWGRID_RefreshStateFlag = 1;
    TEXTDISP_GroupMutationState = 0;
    TEXTDISP_PrimaryGroupRecordChecksum = 0;
    TEXTDISP_PrimaryGroupRecordLength = 0;

    if ((UBYTE)(TEXTDISP_SecondaryGroupPresentFlag - 1) == 0) {
        for (idx = 0; idx < (LONG)(unsigned short)TEXTDISP_SecondaryGroupEntryCount; ++idx) {
            TEXTDISP_PrimaryEntryPtrTable[idx] = TEXTDISP_SecondaryEntryPtrTable[idx];
            TEXTDISP_PrimaryTitlePtrTable[idx] = TEXTDISP_SecondaryTitlePtrTable[idx];
            TEXTDISP_SecondaryEntryPtrTable[idx] = 0;
            TEXTDISP_SecondaryTitlePtrTable[idx] = 0;
        }

        TEXTDISP_PrimaryGroupEntryCount = TEXTDISP_SecondaryGroupEntryCount;
        TEXTDISP_PrimaryGroupRecordChecksum = TEXTDISP_SecondaryGroupRecordChecksum;
        TEXTDISP_PrimaryGroupHeaderCode = TEXTDISP_SecondaryGroupHeaderCode;
        TEXTDISP_PrimaryGroupRecordLength = TEXTDISP_SecondaryGroupRecordLength;
        TEXTDISP_PrimaryGroupPresentFlag = 1;

        TEXTDISP_SecondaryGroupEntryCount = 0;
        TEXTDISP_SecondaryGroupRecordChecksum = 0;
        TEXTDISP_SecondaryGroupRecordLength = 0;
        TEXTDISP_SecondaryGroupPresentFlag = 0;
        TEXTDISP_GroupMutationState = 3;
    }

    CTASKS_PendingPrimaryOiDiskId = CTASKS_PendingSecondaryOiDiskId;
    CTASKS_PrimaryOiWritePendingFlag = CTASKS_SecondaryOiWritePendingFlag;
    CTASKS_PendingSecondaryOiDiskId = 0xFF;
    CTASKS_SecondaryOiWritePendingFlag = 0;
    ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache();
}
