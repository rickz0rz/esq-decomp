#include <exec/types.h>

typedef struct COI_SubEntry COI_SubEntry;
typedef struct COI_DetailEntry COI_DetailEntry;
typedef struct COI_EntryTableEntry COI_EntryTableEntry;

struct COI_SubEntry {
    UWORD id;
    char *field2;
    char *field6;
    char *field10;
    char *field14;
    char *field18;
    char *field22;
    LONG field26;
};

struct COI_DetailEntry {
    char field0[4];
    char *field4;
    char *field8;
    char *field12;
    char *field16;
    char *field20;
    char *field24;
    char *field28;
    LONG field32;
    UWORD subEntryCount;
    COI_SubEntry **subEntryTable;
};

struct COI_EntryTableEntry {
    UBYTE pad0[12];
    char name[36];
    COI_DetailEntry *detail;
};

#define COI_MAX_PRIMARY_ENTRIES 0xC8
#define COI_FLAG_SET 1
#define COI_GROUP_PRESENT_BASE 1
#define COI_DISK_SPLIT_DIVISOR 2
#define COI_OPEN_MODE_WRITE 1006
#define COI_OPEN_FAIL 0
#define COI_INVALID_DISK_ID 1
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
extern const char COI_STR_COLON_A[];
extern const char COI_FMT_LONG_DEC_B[];
extern const char COI_FMT_LONG_DEC_C[];
extern const char COI_FMT_LONG_DEC_PAD2[];
extern const char COI_STR_COLON_B[];
extern const char COI_FMT_DEC_B[];
extern const char CLOCK_FileEofMarkerCtrlZ[];

LONG GROUP_AG_JMPTBL_MATH_DivS32(LONG a, LONG b);
LONG GROUP_AE_JMPTBL_WDISP_SPrintf(char *out, const char *fmt, LONG a, LONG b, LONG c);
LONG DISKIO_OpenFileWithBuffer(const char *path, LONG mode);
LONG DISKIO_WriteBufferedBytes(LONG fh, const void *data, LONG len);
LONG DISKIO_CloseBufferedFileAndFlush(LONG fh);
LONG ESQ_WildcardMatch(const char *a, const char *b);

static UWORD COI_StringLength(const char *text)
{
    const char *scan;

    scan = text;
    while (*scan != 0) {
        scan++;
    }

    return (UWORD)(scan - text);
}

static void COI_WriteCStringIfPresent(LONG fh, const char *text)
{
    if (text != (char *)0) {
        DISKIO_WriteBufferedBytes(fh, text, (LONG)COI_StringLength(text));
    }
}

static void COI_WriteFormattedLong(LONG fh, char *buffer, const char *fmt, LONG value)
{
    GROUP_AE_JMPTBL_WDISP_SPrintf(buffer, fmt, value, COI_PRINTF_ARG_ZERO, COI_PRINTF_ARG_ZERO);
    DISKIO_WriteBufferedBytes(fh, buffer, (LONG)COI_StringLength(buffer));
}

LONG COI_WriteOiDataFile(UBYTE disk_id)
{
    char path_buf[112];
    char tmp[40];
    LONG fh;
    WORD entry_count;
    WORD entry_index;
    WORD disk_path_index;
    LONG use_secondary_table;
    COI_EntryTableEntry **entry_table;

    if (TEXTDISP_PrimaryGroupEntryCount > COI_MAX_PRIMARY_ENTRIES) {
        return COI_INVALID_DISK_ID;
    }

    use_secondary_table = 0;
    if (disk_id == TEXTDISP_SecondaryGroupCode &&
        (UBYTE)(TEXTDISP_SecondaryGroupPresentFlag - COI_GROUP_PRESENT_BASE) == 0) {
        CTASKS_SecondaryOiWritePendingFlag = COI_FLAG_SET;
        CTASKS_PendingSecondaryOiDiskId = disk_id;
        entry_count = (WORD)TEXTDISP_SecondaryGroupEntryCount;
        use_secondary_table = -1;
    } else if (disk_id == TEXTDISP_PrimaryGroupCode) {
        CTASKS_PrimaryOiWritePendingFlag = COI_FLAG_SET;
        CTASKS_PendingPrimaryOiDiskId = disk_id;
        entry_count = (WORD)TEXTDISP_PrimaryGroupEntryCount;
    } else {
        return COI_INVALID_DISK_ID;
    }

    (void)GROUP_AG_JMPTBL_MATH_DivS32((LONG)disk_id, COI_DISK_SPLIT_DIVISOR);
    disk_path_index = (WORD)((LONG)disk_id % COI_DISK_SPLIT_DIVISOR);
    GROUP_AE_JMPTBL_WDISP_SPrintf(
        path_buf,
        Global_STR_DF0_OI_PERCENT_2_LX_DAT_1,
        (LONG)disk_path_index,
        COI_PRINTF_ARG_ZERO,
        COI_PRINTF_ARG_ZERO);

    fh = DISKIO_OpenFileWithBuffer(path_buf, COI_OPEN_MODE_WRITE);
    if (fh == COI_OPEN_FAIL) {
        return COI_OPEN_ERROR;
    }

    COI_WriteFormattedLong(fh, tmp, COI_FMT_LONG_DEC_A, (LONG)disk_id);
    DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, COI_WRITE_ONE);
    COI_WriteFormattedLong(fh, tmp, COI_FMT_DEC_A, COI_DISK_SPLIT_DIVISOR);
    DISKIO_WriteBufferedBytes(fh, COI_RecordTerminatorCrLf, COI_WRITE_TWO);

    if (use_secondary_table != 0) {
        entry_table = TEXTDISP_SecondaryEntryPtrTable;
    } else {
        entry_table = TEXTDISP_PrimaryEntryPtrTable;
    }

    entry_index = 0;
    while (entry_index < entry_count) {
        COI_EntryTableEntry *entry;
        WORD compare_index;
        LONG duplicate_found;

        entry = entry_table[entry_index];
        compare_index = 0;
        duplicate_found = 0;

        while (compare_index < entry_index && duplicate_found == 0) {
            COI_EntryTableEntry *compare_entry;

            compare_entry = entry_table[compare_index];
            duplicate_found = (LONG)(WORD)-(ESQ_WildcardMatch(entry->name, compare_entry->name) == 0);
            compare_index++;
        }

        if (duplicate_found == 0) {
            COI_DetailEntry *detail;
            WORD subentry_index;

            detail = entry->detail;

            COI_WriteCStringIfPresent(fh, entry->name);
            DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, COI_WRITE_ONE);
            COI_WriteCStringIfPresent(fh, detail->field24);
            DISKIO_WriteBufferedBytes(fh, COI_STR_COLON_A, COI_WRITE_ONE);
            COI_WriteCStringIfPresent(fh, detail->field28);
            DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, COI_WRITE_ONE);
            COI_WriteFormattedLong(fh, tmp, COI_FMT_LONG_DEC_B, detail->field32);
            DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, COI_WRITE_ONE);
            COI_WriteCStringIfPresent(fh, detail->field4);
            DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, COI_WRITE_ONE);
            COI_WriteCStringIfPresent(fh, detail->field0);
            DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, COI_WRITE_ONE);
            COI_WriteCStringIfPresent(fh, detail->field12);
            DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, COI_WRITE_ONE);
            COI_WriteCStringIfPresent(fh, detail->field16);
            DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, COI_WRITE_ONE);
            COI_WriteCStringIfPresent(fh, detail->field20);
            DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, COI_WRITE_ONE);
            COI_WriteCStringIfPresent(fh, detail->field8);
            DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, COI_WRITE_ONE);
            COI_WriteFormattedLong(fh, tmp, COI_FMT_LONG_DEC_C, (LONG)detail->subEntryCount);
            DISKIO_WriteBufferedBytes(fh, COI_RecordTerminatorCrLf, COI_WRITE_TWO);

            subentry_index = 0;
            while (subentry_index < (WORD)detail->subEntryCount) {
                COI_SubEntry *subentry;

                subentry = detail->subEntryTable[subentry_index];
                COI_WriteFormattedLong(fh, tmp, COI_FMT_LONG_DEC_PAD2, (LONG)subentry->id);
                DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, COI_WRITE_ONE);
                COI_WriteCStringIfPresent(fh, subentry->field18);
                DISKIO_WriteBufferedBytes(fh, COI_STR_COLON_B, COI_WRITE_ONE);
                COI_WriteCStringIfPresent(fh, subentry->field22);
                DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, COI_WRITE_ONE);
                COI_WriteFormattedLong(fh, tmp, COI_FMT_DEC_B, subentry->field26);
                DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, COI_WRITE_ONE);
                COI_WriteCStringIfPresent(fh, subentry->field6);
                DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, COI_WRITE_ONE);
                COI_WriteCStringIfPresent(fh, subentry->field10);
                DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, COI_WRITE_ONE);
                COI_WriteCStringIfPresent(fh, subentry->field14);
                DISKIO_WriteBufferedBytes(fh, COI_FieldDelimiterTab, COI_WRITE_ONE);
                COI_WriteCStringIfPresent(fh, subentry->field2);
                DISKIO_WriteBufferedBytes(fh, COI_RecordTerminatorCrLf, COI_WRITE_TWO);
                subentry_index++;
            }
        }

        entry_index++;
    }

    DISKIO_WriteBufferedBytes(fh, CLOCK_FileEofMarkerCtrlZ, COI_WRITE_ONE);
    DISKIO_CloseBufferedFileAndFlush(fh);
    return COI_WRITE_OK;
}
