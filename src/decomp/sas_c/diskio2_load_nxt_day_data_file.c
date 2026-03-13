typedef unsigned char UBYTE;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned long ULONG;

typedef struct DISKIO2_Entry {
    UBYTE pad0[1];
    UBYTE titleText[26];
    UBYTE flags27;
    UBYTE pad1[12];
    UBYTE flags40;
    UBYTE pad2[7];
} DISKIO2_Entry;

typedef struct DISKIO2_TitleData {
    UBYTE pad0[7];
    UBYTE slotFlags[49];
    char *slotTextTable[49];
    UBYTE slotAttr252[49];
    UBYTE slotAttr301[49];
    UBYTE slotAttr350[49];
} DISKIO2_TitleData;

extern long DISKIO_LoadFileToWorkBuffer(const char *path);
extern long DISKIO_ParseLongFromWorkBuffer(void);
extern char *DISKIO_ConsumeCStringFromWorkBuffer(void);
extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const char *file, ULONG line, ULONG size, ULONG flags);
extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *file, ULONG line, void *ptr, ULONG size);
extern void GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults(UBYTE *entry);
extern void COI_EnsureAnimObjectAllocated(void *entry);
extern char *ESQSHARED_ApplyProgramTitleTextFilters(const char *text, ULONG flags);
extern char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(const char *newText, char *oldText);
extern long COI_LoadOiDataFile(long diskId);

extern const char Global_STR_DF0_NXTDAY_DAT[];
extern const char Global_STR_DISKIO2_C_17[];
extern const char Global_STR_DISKIO2_C_18[];
extern const char Global_STR_DISKIO2_C_19[];
extern const char Global_STR_DISKIO2_C_20[];
extern const char Global_STR_DISKIO2_C_21[];
extern const char Global_STR_DISKIO2_C_22[];

volatile ULONG Global_REF_LONG_FILE_SCRATCH;
volatile char *Global_PTR_WORK_BUFFER;
volatile UWORD DISKIO_CurrentDriveRevisionIndex;

volatile UBYTE TEXTDISP_SecondaryGroupCode;
volatile UBYTE TEXTDISP_SecondaryGroupHeaderCode;
volatile UWORD TEXTDISP_SecondaryGroupEntryCount;
volatile UBYTE TEXTDISP_SecondaryGroupRecordChecksum;
volatile UWORD TEXTDISP_SecondaryGroupRecordLength;
volatile UBYTE TEXTDISP_SecondaryGroupPresentFlag;
volatile DISKIO2_Entry *TEXTDISP_SecondaryEntryPtrTable[200];
volatile DISKIO2_TitleData *TEXTDISP_SecondaryTitlePtrTable[200];

volatile UBYTE CTASKS_SecondaryOiWritePendingFlag;
volatile UBYTE CTASKS_PendingSecondaryOiDiskId;

long DISKIO2_LoadNxtDayDataFile(void)
{
    long result = 0;
    ULONG fileLen;
    volatile char *workBuf;
    UBYTE headerCode;
    UWORD loadedCount = 0;
    UWORD parsedCount = 0;
    WORD skipUntil = -1;

    if (DISKIO_LoadFileToWorkBuffer(Global_STR_DF0_NXTDAY_DAT) == -1) {
        return -1;
    }

    fileLen = Global_REF_LONG_FILE_SCRATCH;
    workBuf = Global_PTR_WORK_BUFFER;
    headerCode = (UBYTE)(DISKIO_ParseLongFromWorkBuffer() & 0xffL);

    if (headerCode == TEXTDISP_SecondaryGroupCode) {
        UWORD entryIndex;
        parsedCount = (UWORD)DISKIO_ParseLongFromWorkBuffer();
        TEXTDISP_SecondaryGroupRecordChecksum = (UBYTE)DISKIO_ParseLongFromWorkBuffer();
        TEXTDISP_SecondaryGroupRecordLength = (UWORD)DISKIO_ParseLongFromWorkBuffer();
        TEXTDISP_SecondaryGroupPresentFlag = 1;

        for (entryIndex = 0; entryIndex < parsedCount; entryIndex++) {
            DISKIO2_Entry *entry = (DISKIO2_Entry *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
                Global_STR_DISKIO2_C_17, 948, 52, 0x10001UL);
            DISKIO2_TitleData *title = (DISKIO2_TitleData *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
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

            GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults((UBYTE *)entry);
            COI_EnsureAnimObjectAllocated((void *)entry);

            {
                UWORD i;
                UBYTE *dst = (UBYTE *)entry;
                volatile char *src = Global_PTR_WORK_BUFFER;
                for (i = 0; i < 48; i++) {
                    *dst++ = (UBYTE)*src++;
                }
                Global_PTR_WORK_BUFFER = src;
                Global_REF_LONG_FILE_SCRATCH -= 48;
            }

            entry->flags40 = (UBYTE)(entry->flags40 & 0x7f);
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
                title->slotFlags[slot] = 1;
                title->slotTextTable[slot] = 0;

                if (DISKIO_CurrentDriveRevisionIndex > 4) {
                    if (skipUntil < 0) {
                        skipUntil = (WORD)DISKIO_ParseLongFromWorkBuffer();
                    }
                    if ((WORD)slot < skipUntil) {
                        continue;
                    }
                    skipUntil = -1;
                }

                title->slotFlags[slot] = (UBYTE)DISKIO_ParseLongFromWorkBuffer();
                title->slotAttr252[slot] = (UBYTE)DISKIO_ParseLongFromWorkBuffer();
                title->slotAttr301[slot] = (UBYTE)DISKIO_ParseLongFromWorkBuffer();
                title->slotAttr350[slot] = (UBYTE)DISKIO_ParseLongFromWorkBuffer();

                {
                    char *slotText = DISKIO_ConsumeCStringFromWorkBuffer();
                    if (slotText == (char *)-1) {
                        result = -1;
                        break;
                    }
                    slotText = ESQSHARED_ApplyProgramTitleTextFilters(
                        slotText,
                        (ULONG)entry->flags27);
                    title->slotTextTable[slot] =
                        GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(slotText, title->slotTextTable[slot]);
                    if (title->slotTextTable[slot] != 0) {
                        entry->flags40 = (UBYTE)(entry->flags40 | 0x80);
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
        (char *)workBuf,
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
