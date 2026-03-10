typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;

typedef struct COI_EntryTableEntry {
    UBYTE pad0[1];
} COI_EntryTableEntry;

#define COI_MAX_PRIMARY_ENTRIES 0xC8
#define COI_FLAG_SET 1
#define COI_GROUP_PRESENT_BASE 1
#define COI_DISK_SPLIT_DIVISOR 2
#define COI_OPEN_MODE_WRITE 1006
#define COI_OPEN_FAIL 0
#define COI_WRITE_FAIL 1
#define COI_OPEN_ERROR -3
#define COI_WRITE_OK 0
#define COI_WRITE_ONE 1
#define COI_WRITE_TWO 2
#define COI_PRINTF_ARG_ZERO 0

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
extern COI_EntryTableEntry *TEXTDISP_PrimaryEntryPtrTable[];
extern COI_EntryTableEntry *TEXTDISP_SecondaryEntryPtrTable[];

extern const char Global_STR_DF0_OI_PERCENT_2_LX_DAT_1[];
extern const char COI_FMT_LONG_DEC_A[];
extern const char COI_FMT_DEC_A[];
extern const char COI_FieldDelimiterTab[];
extern const char COI_RecordTerminatorCrLf[];

LONG GROUP_AG_JMPTBL_MATH_DivS32(LONG a, LONG b);
LONG GROUP_AE_JMPTBL_WDISP_SPrintf(char *out, const char *fmt, LONG a, LONG b, LONG c);
LONG DISKIO_OpenFileWithBuffer(const char *path, LONG mode);
LONG DISKIO_WriteBufferedBytes(LONG fh, const void *data, LONG len);
LONG DISKIO_CloseBufferedFileAndFlush(LONG fh);
LONG ESQ_WildcardMatch(const char *a, const char *b);

LONG COI_WriteOiDataFile(UBYTE disk_id)
{
    char path_buf[112];
    char tmp[152];
    LONG fh;
    WORD count;
    WORD i;

    if (TEXTDISP_PrimaryGroupEntryCount > COI_MAX_PRIMARY_ENTRIES) {
        return COI_WRITE_FAIL;
    }

    if (disk_id == TEXTDISP_SecondaryGroupCode &&
        (UBYTE)(TEXTDISP_SecondaryGroupPresentFlag - COI_GROUP_PRESENT_BASE) == 0) {
        CTASKS_SecondaryOiWritePendingFlag = COI_FLAG_SET;
        CTASKS_PendingSecondaryOiDiskId = disk_id;
        count = (WORD)TEXTDISP_SecondaryGroupEntryCount;
    } else if (disk_id == TEXTDISP_PrimaryGroupCode) {
        CTASKS_PrimaryOiWritePendingFlag = COI_FLAG_SET;
        CTASKS_PendingPrimaryOiDiskId = disk_id;
        count = (WORD)TEXTDISP_PrimaryGroupEntryCount;
    } else {
        return COI_WRITE_FAIL;
    }

    GROUP_AG_JMPTBL_MATH_DivS32((LONG)disk_id, COI_DISK_SPLIT_DIVISOR);
    GROUP_AE_JMPTBL_WDISP_SPrintf(path_buf,
                                  Global_STR_DF0_OI_PERCENT_2_LX_DAT_1,
                                  COI_PRINTF_ARG_ZERO,
                                  COI_PRINTF_ARG_ZERO,
                                  COI_PRINTF_ARG_ZERO);
    fh = DISKIO_OpenFileWithBuffer(path_buf, COI_OPEN_MODE_WRITE);
    if (fh == COI_OPEN_FAIL) {
        return COI_OPEN_ERROR;
    }

    GROUP_AE_JMPTBL_WDISP_SPrintf(tmp,
                                  COI_FMT_LONG_DEC_A,
                                  (LONG)disk_id,
                                  COI_PRINTF_ARG_ZERO,
                                  COI_PRINTF_ARG_ZERO);
    DISKIO_WriteBufferedBytes(fh, tmp, COI_WRITE_ONE);
    DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, COI_WRITE_ONE);
    GROUP_AE_JMPTBL_WDISP_SPrintf(tmp,
                                  COI_FMT_DEC_A,
                                  COI_DISK_SPLIT_DIVISOR,
                                  COI_PRINTF_ARG_ZERO,
                                  COI_PRINTF_ARG_ZERO);
    DISKIO_WriteBufferedBytes(fh, tmp, COI_WRITE_ONE);
    DISKIO_WriteBufferedBytes(fh, COI_RecordTerminatorCrLf, COI_WRITE_TWO);

    i = 0;
    while (i < count) {
        COI_EntryTableEntry *entry;

        if (disk_id == TEXTDISP_SecondaryGroupCode &&
            (UBYTE)(TEXTDISP_SecondaryGroupPresentFlag - COI_GROUP_PRESENT_BASE) == 0) {
            entry = TEXTDISP_SecondaryEntryPtrTable[i];
        } else {
            entry = TEXTDISP_PrimaryEntryPtrTable[i];
        }

        if (entry != (void *)0) {
            ESQ_WildcardMatch((const char *)entry, (const char *)entry);
            DISKIO_WriteBufferedBytes(fh, entry, COI_WRITE_ONE);
            DISKIO_WriteBufferedBytes(fh, COI_RecordTerminatorCrLf, COI_WRITE_TWO);
        }

        i += 1;
    }

    DISKIO_WriteBufferedBytes(fh, COI_RecordTerminatorCrLf, COI_WRITE_TWO);
    DISKIO_CloseBufferedFileAndFlush(fh);
    return COI_WRITE_OK;
}
