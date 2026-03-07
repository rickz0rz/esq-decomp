typedef unsigned char UBYTE;
typedef unsigned long ULONG;

extern long DISKIO_LoadFileToWorkBuffer(const char *path);
extern long DISKIO_ParseLongFromWorkBuffer(void);
extern char *DISKIO_ConsumeCStringFromWorkBuffer(void);
extern char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(char *oldText, const char *newText);
extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *ptr, ULONG size, const char *file, ULONG line);

extern const char CTASKS_PATH_OINFO_DAT[];
extern const char Global_STR_DISKIO2_C_23[];
volatile ULONG Global_REF_LONG_FILE_SCRATCH;
volatile void *Global_PTR_WORK_BUFFER;
volatile UBYTE TEXTDISP_PrimaryGroupCode;
volatile char *ESQIFF_PrimaryLineHeadPtr;
volatile char *ESQIFF_PrimaryLineTailPtr;

long DISKIO2_LoadOinfoDataFile(void)
{
    const long RESULT_FAIL = -1;
    const long RESULT_OK = 0;
    const ULONG GROUPCODE_MASK = 0xffUL;
    const ULONG STR_TERM_BYTES = 1;
    const ULONG FREE_LINE = 1191;
    char *newHead = 0;
    char *newTail = 0;
    ULONG fileLen;
    void *workBuf;
    ULONG parsedGroupCode;

    if (DISKIO_LoadFileToWorkBuffer(CTASKS_PATH_OINFO_DAT) == RESULT_FAIL) {
        return RESULT_FAIL;
    }

    fileLen = Global_REF_LONG_FILE_SCRATCH;
    workBuf = (void *)Global_PTR_WORK_BUFFER;

    parsedGroupCode = (ULONG)DISKIO_ParseLongFromWorkBuffer();
    parsedGroupCode &= GROUPCODE_MASK;

    if ((UBYTE)parsedGroupCode == TEXTDISP_PrimaryGroupCode) {
        newHead = DISKIO_ConsumeCStringFromWorkBuffer();
        newTail = DISKIO_ConsumeCStringFromWorkBuffer();
    }

    if (newHead != (char *)-1 && newTail != (char *)-1) {
        ESQIFF_PrimaryLineHeadPtr =
            GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(ESQIFF_PrimaryLineHeadPtr, newHead);
        ESQIFF_PrimaryLineTailPtr =
            GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(ESQIFF_PrimaryLineTailPtr, newTail);
    }

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        workBuf,
        fileLen + STR_TERM_BYTES,
        Global_STR_DISKIO2_C_23,
        FREE_LINE);
    return RESULT_OK;
}
