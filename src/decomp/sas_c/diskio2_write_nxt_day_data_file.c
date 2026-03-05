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

extern const char Global_STR_DISKIO2_C_14[];
extern const char Global_STR_DISKIO2_C_15[];
extern const char Global_STR_DISKIO2_C_16[];
extern const char Global_STR_DF0_NXTDAY_DAT[];
extern long MODE_NEWFILE;

volatile UWORD TEXTDISP_SecondaryGroupEntryCount;
volatile UBYTE TEXTDISP_SecondaryGroupCode;
volatile UBYTE TEXTDISP_SecondaryGroupRecordChecksum;
volatile UWORD TEXTDISP_SecondaryGroupRecordLength;
volatile UBYTE *TEXTDISP_SecondaryEntryPtrTable[200];
volatile UBYTE *TEXTDISP_SecondaryTitlePtrTable[200];
volatile long DISKIO_SaveOperationReadyFlag;
volatile long DISKIO2_NxtDayFileHandle;

long DISKIO2_WriteNxtDayDataFile(void)
{
    UWORD entryIndex;
    void *scratch;

    if (TEXTDISP_SecondaryGroupEntryCount > 200U) {
        return 0;
    }
    if (DISKIO_SaveOperationReadyFlag == 0) {
        return 0;
    }
    DISKIO_SaveOperationReadyFlag = 0;

    scratch = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_DISKIO2_C_14,
        817,
        1000,
        0x10001UL);
    if (scratch == 0) {
        DISKIO_SaveOperationReadyFlag = 1;
        return -1;
    }

    DISKIO2_NxtDayFileHandle = DISKIO_OpenFileWithBuffer(Global_STR_DF0_NXTDAY_DAT, MODE_NEWFILE);
    if (DISKIO2_NxtDayFileHandle == 0) {
        DISKIO_SaveOperationReadyFlag = 1;
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DISKIO2_C_15, 839, scratch, 1000);
        return -1;
    }

    DISKIO_WriteDecimalField(DISKIO2_NxtDayFileHandle, (long)TEXTDISP_SecondaryGroupCode);
    DISKIO_WriteDecimalField(DISKIO2_NxtDayFileHandle, (long)TEXTDISP_SecondaryGroupEntryCount);
    DISKIO_WriteDecimalField(DISKIO2_NxtDayFileHandle, (long)TEXTDISP_SecondaryGroupRecordChecksum);
    DISKIO_WriteDecimalField(DISKIO2_NxtDayFileHandle, (long)TEXTDISP_SecondaryGroupRecordLength);

    for (entryIndex = 0; entryIndex < TEXTDISP_SecondaryGroupEntryCount; entryIndex++) {
        UBYTE *entry = (UBYTE *)TEXTDISP_SecondaryEntryPtrTable[entryIndex];
        UBYTE *title = (UBYTE *)TEXTDISP_SecondaryTitlePtrTable[entryIndex];
        UWORD slot;

        if (entry == 0 || title == 0) {
            continue;
        }

        DISKIO_WriteBufferedBytes(DISKIO2_NxtDayFileHandle, entry, 48);
        {
            const char *titleStr = (const char *)title;
            const char *scan = titleStr;
            while (*scan != 0) {
                scan++;
            }
            DISKIO_WriteBufferedBytes(DISKIO2_NxtDayFileHandle, titleStr, (ULONG)(scan - titleStr) + 1);
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

            DISKIO_WriteDecimalField(DISKIO2_NxtDayFileHandle, (long)slot);
            attr = title[7 + slot];
            DISKIO_WriteDecimalField(DISKIO2_NxtDayFileHandle, (long)attr);
            DISKIO_WriteDecimalField(DISKIO2_NxtDayFileHandle, (long)title[252 + slot]);
            DISKIO_WriteDecimalField(DISKIO2_NxtDayFileHandle, (long)title[301 + slot]);
            DISKIO_WriteDecimalField(DISKIO2_NxtDayFileHandle, (long)title[350 + slot]);

            if (TEXTDISP_SecondaryGroupEntryCount > 100U) {
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
                DISKIO_WriteBufferedBytes(DISKIO2_NxtDayFileHandle, slotText, (ULONG)(scan - slotText) + 1);
            }
        }

        DISKIO_WriteDecimalField(DISKIO2_NxtDayFileHandle, 49);
    }

    DISKIO_CloseBufferedFileAndFlush(DISKIO2_NxtDayFileHandle);
    DISKIO_SaveOperationReadyFlag = 1;
    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DISKIO2_C_16, 901, scratch, 1000);
    return 0;
}
