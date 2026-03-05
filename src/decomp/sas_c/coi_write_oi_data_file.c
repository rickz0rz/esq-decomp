typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;

extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UBYTE TEXTDISP_SecondaryGroupCode;
extern UBYTE TEXTDISP_SecondaryGroupPresentFlag;
extern UWORD TEXTDISP_SecondaryGroupEntryCount;
extern UBYTE TEXTDISP_PrimaryGroupCode;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UBYTE CTASKS_SecondaryOiWritePendingFlag;
extern UBYTE CTASKS_PendingSecondaryOiDiskId;
extern UBYTE CTASKS_PrimaryOiWritePendingFlag;
extern UBYTE CTASKS_PendingPrimaryOiDiskId;
extern void *TEXTDISP_PrimaryEntryPtrTable[];
extern void *TEXTDISP_SecondaryEntryPtrTable[];

extern UBYTE Global_STR_DF0_OI_PERCENT_2_LX_DAT_1[];
extern UBYTE COI_FMT_LONG_DEC_A[];
extern UBYTE COI_FMT_DEC_A[];
extern UBYTE COI_FieldDelimiterTab[];
extern UBYTE COI_RecordTerminatorCrLf[];

LONG GROUP_AG_JMPTBL_MATH_DivS32(LONG a, LONG b);
LONG GROUP_AE_JMPTBL_WDISP_SPrintf(UBYTE *out, const UBYTE *fmt, LONG a, LONG b, LONG c);
LONG DISKIO_OpenFileWithBuffer(const UBYTE *path, LONG mode);
LONG DISKIO_WriteBufferedBytes(LONG fh, const void *data, LONG len);
LONG DISKIO_CloseBufferedFileAndFlush(LONG fh);
LONG ESQ_WildcardMatch(const UBYTE *a, const UBYTE *b);

LONG COI_WriteOiDataFile(UBYTE disk_id)
{
    UBYTE path_buf[112];
    UBYTE tmp[152];
    LONG fh;
    WORD count;
    WORD i;

    if (TEXTDISP_PrimaryGroupEntryCount > 0xC8) {
        return 1;
    }

    if (disk_id == TEXTDISP_SecondaryGroupCode && (UBYTE)(TEXTDISP_SecondaryGroupPresentFlag - 1) == 0) {
        CTASKS_SecondaryOiWritePendingFlag = 1;
        CTASKS_PendingSecondaryOiDiskId = disk_id;
        count = (WORD)TEXTDISP_SecondaryGroupEntryCount;
    } else if (disk_id == TEXTDISP_PrimaryGroupCode) {
        CTASKS_PrimaryOiWritePendingFlag = 1;
        CTASKS_PendingPrimaryOiDiskId = disk_id;
        count = (WORD)TEXTDISP_PrimaryGroupEntryCount;
    } else {
        return 1;
    }

    GROUP_AG_JMPTBL_MATH_DivS32((LONG)disk_id, 2);
    GROUP_AE_JMPTBL_WDISP_SPrintf(path_buf, Global_STR_DF0_OI_PERCENT_2_LX_DAT_1, 0, 0, 0);
    fh = DISKIO_OpenFileWithBuffer(path_buf, 1006);
    if (fh == 0) {
        return -3;
    }

    GROUP_AE_JMPTBL_WDISP_SPrintf(tmp, COI_FMT_LONG_DEC_A, (LONG)disk_id, 0, 0);
    DISKIO_WriteBufferedBytes(fh, tmp, 1);
    DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, 1);
    GROUP_AE_JMPTBL_WDISP_SPrintf(tmp, COI_FMT_DEC_A, 2, 0, 0);
    DISKIO_WriteBufferedBytes(fh, tmp, 1);
    DISKIO_WriteBufferedBytes(fh, COI_RecordTerminatorCrLf, 2);

    i = 0;
    while (i < count) {
        void *entry;

        if (disk_id == TEXTDISP_SecondaryGroupCode && (UBYTE)(TEXTDISP_SecondaryGroupPresentFlag - 1) == 0) {
            entry = TEXTDISP_SecondaryEntryPtrTable[i];
        } else {
            entry = TEXTDISP_PrimaryEntryPtrTable[i];
        }

        if (entry != (void *)0) {
            ESQ_WildcardMatch((const UBYTE *)entry, (const UBYTE *)entry);
            DISKIO_WriteBufferedBytes(fh, entry, 1);
            DISKIO_WriteBufferedBytes(fh, COI_RecordTerminatorCrLf, 2);
        }

        i += 1;
    }

    DISKIO_WriteBufferedBytes(fh, COI_RecordTerminatorCrLf, 2);
    DISKIO_CloseBufferedFileAndFlush(fh);
    return 0;
}
