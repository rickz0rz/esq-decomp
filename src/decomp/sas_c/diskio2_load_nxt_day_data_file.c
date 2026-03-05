typedef unsigned char UBYTE;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned long ULONG;

extern long DISKIO_LoadFileToWorkBuffer(const char *path);
extern long DISKIO_ParseLongFromWorkBuffer(void);
extern char *DISKIO_ConsumeCStringFromWorkBuffer(void);
extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const char *file, ULONG line, ULONG size, ULONG flags);
extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *file, ULONG line, void *ptr, ULONG size);
extern void GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults(UBYTE *entry);
extern void COI_EnsureAnimObjectAllocated(UBYTE *entry);
extern char *GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(const char *text, ULONG flags);
extern char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(char *oldText, const char *newText);
extern long COI_LoadOiDataFile(long diskId);

extern const char Global_STR_DF0_NXTDAY_DAT[];
extern const char Global_STR_DISKIO2_C_17[];
extern const char Global_STR_DISKIO2_C_18[];
extern const char Global_STR_DISKIO2_C_19[];
extern const char Global_STR_DISKIO2_C_20[];
extern const char Global_STR_DISKIO2_C_21[];
extern const char Global_STR_DISKIO2_C_22[];

volatile ULONG Global_REF_LONG_FILE_SCRATCH;
volatile UBYTE *Global_PTR_WORK_BUFFER;
volatile UWORD DISKIO_CurrentDriveRevisionIndex;

volatile UBYTE TEXTDISP_SecondaryGroupCode;
volatile UBYTE TEXTDISP_SecondaryGroupHeaderCode;
volatile UWORD TEXTDISP_SecondaryGroupEntryCount;
volatile UBYTE TEXTDISP_SecondaryGroupRecordChecksum;
volatile UWORD TEXTDISP_SecondaryGroupRecordLength;
volatile UBYTE TEXTDISP_SecondaryGroupPresentFlag;
volatile UBYTE *TEXTDISP_SecondaryEntryPtrTable[200];
volatile UBYTE *TEXTDISP_SecondaryTitlePtrTable[200];

volatile UBYTE CTASKS_SecondaryOiWritePendingFlag;
volatile UBYTE CTASKS_PendingSecondaryOiDiskId;

long DISKIO2_LoadNxtDayDataFile(void)
{
    long result = 0;
    ULONG fileLen;
    UBYTE *workBuf;
    UBYTE headerCode;
    UWORD loadedCount = 0;
    UWORD parsedCount = 0;
    WORD skipUntil = -1;

    if (DISKIO_LoadFileToWorkBuffer(Global_STR_DF0_NXTDAY_DAT) == -1) {
        return -1;
    }

    fileLen = Global_REF_LONG_FILE_SCRATCH;
    workBuf = (UBYTE *)Global_PTR_WORK_BUFFER;
    headerCode = (UBYTE)(DISKIO_ParseLongFromWorkBuffer() & 0xffL);

    if (headerCode == TEXTDISP_SecondaryGroupCode) {
        UWORD entryIndex;
        parsedCount = (UWORD)DISKIO_ParseLongFromWorkBuffer();
        TEXTDISP_SecondaryGroupRecordChecksum = (UBYTE)DISKIO_ParseLongFromWorkBuffer();
        TEXTDISP_SecondaryGroupRecordLength = (UWORD)DISKIO_ParseLongFromWorkBuffer();
        TEXTDISP_SecondaryGroupPresentFlag = 1;

        for (entryIndex = 0; entryIndex < parsedCount; entryIndex++) {
            UBYTE *entry = (UBYTE *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
                Global_STR_DISKIO2_C_17, 948, 52, 0x10001UL);
            UBYTE *title = (UBYTE *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
                Global_STR_DISKIO2_C_18, 954, 500, 0x10001UL);
            UWORD slot;

            if (entry == 0) {
                result = -1;
                break;
            }
            if (title == 0) {
                result = -1;
                GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
                    Global_STR_DISKIO2_C_19, 958, entry, 52);
                break;
            }

            GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults(entry);
            COI_EnsureAnimObjectAllocated(entry);

            {
                UWORD i;
                UBYTE *dst = entry;
                UBYTE *src = (UBYTE *)Global_PTR_WORK_BUFFER;
                for (i = 0; i < 48; i++) {
                    *dst++ = *src++;
                }
                Global_PTR_WORK_BUFFER = src;
                Global_REF_LONG_FILE_SCRATCH -= 48;
            }

            entry[40] = (UBYTE)(entry[40] & 0x7f);
            {
                char *name = DISKIO_ConsumeCStringFromWorkBuffer();
                if (name == (char *)-1) {
                    result = -1;
                } else {
                    char *d = (char *)title;
                    while ((*d++ = *name++) != 0) {
                    }
                }
            }

            for (slot = 0; slot < 49 && result != -1; slot++) {
                char **slotTextTable = (char **)(title + 56);
                title[7 + slot] = 1;
                slotTextTable[slot] = 0;

                if (DISKIO_CurrentDriveRevisionIndex > 4) {
                    if (skipUntil < 0) {
                        skipUntil = (WORD)DISKIO_ParseLongFromWorkBuffer();
                    }
                    if ((WORD)slot < skipUntil) {
                        continue;
                    }
                    skipUntil = -1;
                }

                title[7 + slot] = (UBYTE)DISKIO_ParseLongFromWorkBuffer();
                title[252 + slot] = (UBYTE)DISKIO_ParseLongFromWorkBuffer();
                title[301 + slot] = (UBYTE)DISKIO_ParseLongFromWorkBuffer();
                title[350 + slot] = (UBYTE)DISKIO_ParseLongFromWorkBuffer();

                {
                    char *slotText = DISKIO_ConsumeCStringFromWorkBuffer();
                    if (slotText == (char *)-1) {
                        result = -1;
                        break;
                    }
                    slotText = GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(
                        slotText,
                        (ULONG)entry[27]);
                    slotTextTable[slot] =
                        GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(slotTextTable[slot], slotText);
                    if (slotTextTable[slot] != 0) {
                        entry[40] = (UBYTE)(entry[40] | 0x80);
                    }
                }
            }

            if (DISKIO_CurrentDriveRevisionIndex > 4 && skipUntil == -1) {
                skipUntil = (WORD)DISKIO_ParseLongFromWorkBuffer();
            }

            if (result == -1) {
                GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
                    Global_STR_DISKIO2_C_20, 1027, entry, 52);
                GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
                    Global_STR_DISKIO2_C_21, 1028, title, 500);
                break;
            }

            TEXTDISP_SecondaryEntryPtrTable[loadedCount] = entry;
            TEXTDISP_SecondaryTitlePtrTable[loadedCount] = title;
            loadedCount++;
        }
    }

    TEXTDISP_SecondaryGroupHeaderCode = headerCode;
    TEXTDISP_SecondaryGroupEntryCount = loadedCount;

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_DISKIO2_C_22,
        1041,
        workBuf,
        fileLen + 1);

    if (COI_LoadOiDataFile((long)headerCode) != -1) {
        CTASKS_SecondaryOiWritePendingFlag = 1;
        CTASKS_PendingSecondaryOiDiskId = headerCode;
    } else {
        CTASKS_SecondaryOiWritePendingFlag = 0;
        CTASKS_PendingSecondaryOiDiskId = 0;
    }

    return result;
}
