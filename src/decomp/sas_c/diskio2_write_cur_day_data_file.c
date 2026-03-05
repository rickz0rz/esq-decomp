typedef unsigned char UBYTE;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned long ULONG;

extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const char *file, ULONG line, ULONG size, ULONG flags);
extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *file, ULONG line, void *ptr, ULONG size);
extern long DISKIO_OpenFileWithBuffer(const char *path, long mode);
extern void DISKIO_WriteDecimalField(long handle, long value);
extern void DISKIO_WriteBufferedBytes(long handle, const void *buf, ULONG len);
extern void DISKIO_CloseBufferedFileAndFlush(long handle);
extern long GROUP_AH_JMPTBL_ESQ_TestBit1Based(const UBYTE *mask, long oneBasedBit);
extern char *DISKIO2_CopyAndSanitizeSlotString(char *dst, const UBYTE *entry, const UBYTE *title, UWORD slot);

extern const char Global_STR_DISKIO2_C_1[];
extern const char Global_STR_DISKIO2_C_2[];
extern const char Global_STR_DISKIO2_C_3[];
extern const char CTASKS_PATH_CURDAY_DAT[];
extern const char ESQ_STR_B[];
extern const char Global_STR_DREV_5_1[];
extern long MODE_NEWFILE;

volatile WORD DST_PrimaryCountdown;
volatile UBYTE WDISP_WeatherStatusLabelBuffer[128];
volatile char *WDISP_WeatherStatusTextPtr;
volatile UWORD TEXTDISP_PrimaryGroupEntryCount;
volatile UBYTE TEXTDISP_PrimaryGroupCode;
volatile UBYTE TEXTDISP_PrimaryGroupRecordChecksum;
volatile UWORD TEXTDISP_PrimaryGroupRecordLength;
volatile UBYTE *TEXTDISP_PrimaryEntryPtrTable[200];
volatile UBYTE *TEXTDISP_PrimaryTitlePtrTable[200];
volatile long DISKIO_SaveOperationReadyFlag;
volatile long DISKIO2_OutputFileHandle;

long DISKIO2_WriteCurDayDataFile(void)
{
    UWORD entryIndex;
    void *scratch;
    UBYTE empty = 0;

    if (TEXTDISP_PrimaryGroupEntryCount > 200U) {
        return 0;
    }
    if (DISKIO_SaveOperationReadyFlag == 0) {
        return 0;
    }
    DISKIO_SaveOperationReadyFlag = 0;

    scratch = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_DISKIO2_C_1,
        152,
        1000,
        0x10001UL);
    if (scratch == 0) {
        DISKIO_SaveOperationReadyFlag = 1;
        return -1;
    }

    DISKIO2_OutputFileHandle = DISKIO_OpenFileWithBuffer(CTASKS_PATH_CURDAY_DAT, MODE_NEWFILE);
    if (DISKIO2_OutputFileHandle == 0) {
        DISKIO_SaveOperationReadyFlag = 1;
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DISKIO2_C_2, 176, scratch, 1000);
        return -1;
    }

    DISKIO_WriteBufferedBytes(DISKIO2_OutputFileHandle, ESQ_STR_B, 21);
    DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle, (long)DST_PrimaryCountdown);
    DISKIO_WriteBufferedBytes(DISKIO2_OutputFileHandle, Global_STR_DREV_5_1, 7);

    {
        const char *scan = (const char *)WDISP_WeatherStatusLabelBuffer;
        while (*scan != 0) {
            scan++;
        }
        DISKIO_WriteBufferedBytes(
            DISKIO2_OutputFileHandle,
            WDISP_WeatherStatusLabelBuffer,
            (ULONG)(scan - (const char *)WDISP_WeatherStatusLabelBuffer) + 1);
    }

    {
        const char *status = WDISP_WeatherStatusTextPtr ? WDISP_WeatherStatusTextPtr : (const char *)&empty;
        const char *scan = status;
        while (*scan != 0) {
            scan++;
        }
        DISKIO_WriteBufferedBytes(DISKIO2_OutputFileHandle, status, (ULONG)(scan - status) + 1);
    }

    DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle, (long)TEXTDISP_PrimaryGroupCode);
    DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle, (long)TEXTDISP_PrimaryGroupEntryCount);
    DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle, (long)TEXTDISP_PrimaryGroupRecordChecksum);
    DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle, (long)TEXTDISP_PrimaryGroupRecordLength);

    for (entryIndex = 0; entryIndex < TEXTDISP_PrimaryGroupEntryCount; entryIndex++) {
        UBYTE *entry = (UBYTE *)TEXTDISP_PrimaryEntryPtrTable[entryIndex];
        UBYTE *title = (UBYTE *)TEXTDISP_PrimaryTitlePtrTable[entryIndex];
        UWORD slot;

        if (entry == 0 || title == 0) {
            continue;
        }

        DISKIO_WriteBufferedBytes(DISKIO2_OutputFileHandle, entry, 48);
        {
            const char *titleStr = (const char *)title;
            const char *scan = titleStr;
            while (*scan != 0) {
                scan++;
            }
            DISKIO_WriteBufferedBytes(DISKIO2_OutputFileHandle, titleStr, (ULONG)(scan - titleStr) + 1);
        }

        for (slot = 0; slot < 49; slot++) {
            char **slotTextTable = (char **)(title + 56);
            char *slotText;
            UBYTE attr;

            if (slotTextTable[slot] == 0) {
                continue;
            }
            if (GROUP_AH_JMPTBL_ESQ_TestBit1Based(entry + 28, (long)slot) != -1) {
                continue;
            }

            DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle, (long)slot);
            attr = title[7 + slot];
            DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle, (long)attr);
            DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle, (long)title[252 + slot]);
            DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle, (long)title[301 + slot]);
            DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle, (long)title[350 + slot]);

            if (TEXTDISP_PrimaryGroupEntryCount > 100U) {
                slotText = DISKIO2_CopyAndSanitizeSlotString((char *)scratch, entry, title, slot);
            } else {
                slotText = slotTextTable[slot];
            }
            if (slotText == 0) {
                continue;
            }

            {
                const char *scan = slotText;
                while (*scan != 0) {
                    scan++;
                }
                DISKIO_WriteBufferedBytes(DISKIO2_OutputFileHandle, slotText, (ULONG)(scan - slotText) + 1);
            }
        }

        DISKIO_WriteDecimalField(DISKIO2_OutputFileHandle, 49);
    }

    DISKIO_CloseBufferedFileAndFlush(DISKIO2_OutputFileHandle);
    DISKIO_SaveOperationReadyFlag = 1;
    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DISKIO2_C_3, 275, scratch, 1000);
    return 0;
}
