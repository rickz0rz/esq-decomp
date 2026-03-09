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
extern char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(const char *newText, char *oldText);
extern long GROUP_AH_JMPTBL_ESQ_WildcardMatch(const char *pattern, const char *text);
extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const char *file, ULONG line, ULONG size, ULONG flags);
extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *file, ULONG line, void *ptr, ULONG size);
extern void GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults(UBYTE *entry);
extern void COI_EnsureAnimObjectAllocated(UBYTE *entry);
extern char *GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(const char *text, ULONG flags);
extern void GROUP_AH_JMPTBL_ESQIFF2_ApplyIncomingStatusPacket(const char *text);
extern long COI_LoadOiDataFile(long diskId);

extern const char CTASKS_PATH_CURDAY_DAT[];
extern const char ESQ_STR_B[];
extern const char DISKIO2_STR_DREV_1[];
extern const char DISKIO2_STR_DREV_2[];
extern const char DISKIO2_STR_DREV_3[];
extern const char DISKIO2_STR_DREV_4[];
extern const char DISKIO2_STR_DREV_5[];
extern const char Global_STR_DISKIO2_C_4[];
extern const char Global_STR_DISKIO2_C_5[];
extern const char Global_STR_DISKIO2_C_6[];
extern const char Global_STR_DISKIO2_C_7[];
extern const char Global_STR_DISKIO2_C_8[];
extern const char Global_STR_DISKIO2_C_9[];
extern const char Global_STR_DISKIO2_C_10[];
extern const char Global_STR_DISKIO2_C_11[];
extern const char Global_STR_DISKIO2_C_12[];
extern const char Global_STR_DISKIO2_C_13[];

volatile ULONG Global_REF_LONG_FILE_SCRATCH;
volatile char *Global_PTR_WORK_BUFFER;
volatile WORD DST_PrimaryCountdown;
volatile UWORD DISKIO_CurrentDriveRevisionIndex;
volatile UBYTE DISKIO_ErrorMessageScratch[64];
volatile UBYTE WDISP_WeatherStatusLabelBuffer[128];
volatile char *WDISP_WeatherStatusTextPtr;

volatile UBYTE TEXTDISP_PrimaryGroupCode;
volatile UBYTE TEXTDISP_PrimaryGroupHeaderCode;
volatile UWORD TEXTDISP_PrimaryGroupEntryCount;
volatile UBYTE TEXTDISP_PrimaryGroupRecordChecksum;
volatile UWORD TEXTDISP_PrimaryGroupRecordLength;
volatile UBYTE TEXTDISP_PrimaryGroupPresentFlag;
volatile UWORD TEXTDISP_GroupMutationState;
volatile UWORD TEXTDISP_MaxEntryTitleLength;
volatile DISKIO2_Entry *TEXTDISP_PrimaryEntryPtrTable[200];
volatile DISKIO2_TitleData *TEXTDISP_PrimaryTitlePtrTable[200];

volatile UBYTE CTASKS_PrimaryOiWritePendingFlag;
volatile UBYTE CTASKS_PendingPrimaryOiDiskId;

long DISKIO2_LoadCurDayDataFile(void)
{
    long result = 0;
    ULONG fileLen;
    char *workBuf;
    UBYTE headerCode;
    UWORD loadedCount = 0;
    UWORD parsedCount = 0;
    WORD skipUntil = -1;
    char statusText[32];
    char *str;

    {
        UWORD i;
        for (i = 0; i < 21; i++) {
            statusText[i] = ESQ_STR_B[i];
        }
        statusText[21] = 0;
    }

    if (DISKIO_LoadFileToWorkBuffer(CTASKS_PATH_CURDAY_DAT) == -1) {
        DST_PrimaryCountdown = 0;
        GROUP_AH_JMPTBL_ESQIFF2_ApplyIncomingStatusPacket(statusText);
        return -1;
    }

    fileLen = Global_REF_LONG_FILE_SCRATCH;
    workBuf = (char *)Global_PTR_WORK_BUFFER;

    DST_PrimaryCountdown = (WORD)DISKIO_ParseLongFromWorkBuffer();
    GROUP_AH_JMPTBL_ESQIFF2_ApplyIncomingStatusPacket(statusText);

    str = DISKIO_ConsumeCStringFromWorkBuffer();
    if (str == (char *)-1) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_DISKIO2_C_4, 520, workBuf, fileLen + 1);
        return -1;
    }

    {
        char *d = (char *)DISKIO_ErrorMessageScratch;
        while ((*d++ = *str++) != 0) {
        }
    }

    if (GROUP_AH_JMPTBL_ESQ_WildcardMatch(DISKIO2_STR_DREV_1, (char *)DISKIO_ErrorMessageScratch) != 0) {
        DISKIO_CurrentDriveRevisionIndex = 1;
    } else if (GROUP_AH_JMPTBL_ESQ_WildcardMatch(DISKIO2_STR_DREV_2, (char *)DISKIO_ErrorMessageScratch) != 0) {
        DISKIO_CurrentDriveRevisionIndex = 2;
    } else if (GROUP_AH_JMPTBL_ESQ_WildcardMatch(DISKIO2_STR_DREV_3, (char *)DISKIO_ErrorMessageScratch) != 0) {
        DISKIO_CurrentDriveRevisionIndex = 3;
    } else if (GROUP_AH_JMPTBL_ESQ_WildcardMatch(DISKIO2_STR_DREV_4, (char *)DISKIO_ErrorMessageScratch) != 0) {
        DISKIO_CurrentDriveRevisionIndex = 4;
    } else if (GROUP_AH_JMPTBL_ESQ_WildcardMatch(DISKIO2_STR_DREV_5, (char *)DISKIO_ErrorMessageScratch) != 0) {
        DISKIO_CurrentDriveRevisionIndex = 5;
    } else {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_DISKIO2_C_5, 561, workBuf, fileLen + 1);
        return -1;
    }

    str = DISKIO_ConsumeCStringFromWorkBuffer();
    if (str == (char *)-1) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_DISKIO2_C_6, 570, workBuf, fileLen + 1);
        return -1;
    }
    {
        char *d = (char *)WDISP_WeatherStatusLabelBuffer;
        while ((*d++ = *str++) != 0) {
        }
    }

    if (DISKIO_CurrentDriveRevisionIndex > 0) {
        str = DISKIO_ConsumeCStringFromWorkBuffer();
        if (str == (char *)-1) {
            GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
                Global_STR_DISKIO2_C_7, 588, workBuf, fileLen + 1);
            return -1;
        }
        WDISP_WeatherStatusTextPtr = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
            str,
            (char *)WDISP_WeatherStatusTextPtr);
    }

    headerCode = (UBYTE)(DISKIO_ParseLongFromWorkBuffer() & 0xffL);
    if (headerCode == TEXTDISP_PrimaryGroupCode) {
        UWORD entryIndex;
        parsedCount = (UWORD)DISKIO_ParseLongFromWorkBuffer();
        TEXTDISP_PrimaryGroupRecordChecksum = (UBYTE)DISKIO_ParseLongFromWorkBuffer();
        TEXTDISP_PrimaryGroupRecordLength = (UWORD)DISKIO_ParseLongFromWorkBuffer();
        TEXTDISP_PrimaryGroupPresentFlag = 1;
        TEXTDISP_GroupMutationState = 1;
        TEXTDISP_MaxEntryTitleLength = 0;

        for (entryIndex = 0; entryIndex < parsedCount; entryIndex++) {
            DISKIO2_Entry *entry = (DISKIO2_Entry *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
                Global_STR_DISKIO2_C_8, 634, 52, 0x10001UL);
            DISKIO2_TitleData *title = (DISKIO2_TitleData *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
                Global_STR_DISKIO2_C_9, 640, 500, 0x10001UL);
            UWORD slot;

            if (entry == 0) {
                result = -1;
                break;
            }
            if (title == 0) {
                result = -1;
                GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
                    Global_STR_DISKIO2_C_10, 644, entry, 52);
                break;
            }

            GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults((UBYTE *)entry);
            COI_EnsureAnimObjectAllocated((UBYTE *)entry);

            {
                UWORD i;
                UBYTE *dst = (UBYTE *)entry;
                char *src = (char *)Global_PTR_WORK_BUFFER;
                for (i = 0; i < 48; i++) {
                    *dst++ = (UBYTE)*src++;
                }
                Global_PTR_WORK_BUFFER = src;
                Global_REF_LONG_FILE_SCRATCH -= 48;
            }

            entry->flags40 = (UBYTE)(entry->flags40 & 0x7F);
            {
                UBYTE *scan = entry->titleText;
                UWORD len = 0;
                while (*scan++ != 0) {
                    len++;
                }
                if (len > TEXTDISP_MaxEntryTitleLength) {
                    TEXTDISP_MaxEntryTitleLength = len;
                }
            }

            str = DISKIO_ConsumeCStringFromWorkBuffer();
            if (str == (char *)-1) {
                result = -1;
            } else {
                char *d = (char *)title;
                while ((*d++ = *str++) != 0) {
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
                if (DISKIO_CurrentDriveRevisionIndex > 1) {
                    title->slotAttr252[slot] = (UBYTE)DISKIO_ParseLongFromWorkBuffer();
                    title->slotAttr301[slot] = (UBYTE)DISKIO_ParseLongFromWorkBuffer();
                    title->slotAttr350[slot] = (UBYTE)DISKIO_ParseLongFromWorkBuffer();
                }

                str = DISKIO_ConsumeCStringFromWorkBuffer();
                if (str == (char *)-1) {
                    result = -1;
                    break;
                }

                str = GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(str, (ULONG)entry->flags27);
                title->slotTextTable[slot] = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(str, title->slotTextTable[slot]);
                if (title->slotTextTable[slot] != 0) {
                    entry->flags40 = (UBYTE)(entry->flags40 | 0x80);
                }
            }

            if (DISKIO_CurrentDriveRevisionIndex > 4 && skipUntil == -1) {
                skipUntil = (WORD)DISKIO_ParseLongFromWorkBuffer();
            }

            if (result == -1) {
                GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
                    Global_STR_DISKIO2_C_11, 736, entry, 52);
                GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
                    Global_STR_DISKIO2_C_12, 737, title, 500);
                break;
            }

            TEXTDISP_PrimaryEntryPtrTable[loadedCount] = entry;
            TEXTDISP_PrimaryTitlePtrTable[loadedCount] = title;
            loadedCount++;
        }
    } else {
        result = -1;
    }

    TEXTDISP_PrimaryGroupHeaderCode = headerCode;
    TEXTDISP_PrimaryGroupEntryCount = loadedCount;

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_DISKIO2_C_13,
        764,
        workBuf,
        fileLen + 1);

    if (COI_LoadOiDataFile((long)headerCode) != -1) {
        CTASKS_PrimaryOiWritePendingFlag = 1;
        CTASKS_PendingPrimaryOiDiskId = headerCode;
    } else {
        CTASKS_PrimaryOiWritePendingFlag = 0;
        CTASKS_PendingPrimaryOiDiskId = 0;
    }

    return result;
}
