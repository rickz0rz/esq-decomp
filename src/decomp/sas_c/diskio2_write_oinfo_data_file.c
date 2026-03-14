#include <exec/types.h>
extern long DISKIO_OpenFileWithBuffer(const char *path, long mode);
extern void DISKIO_WriteDecimalField(long handle, long value);
extern long DISKIO_WriteBufferedBytes(long handle, const char *buf, ULONG len);
extern long DISKIO_CloseBufferedFileAndFlush(long handle);

extern const char CTASKS_PATH_OINFO_DAT[];
extern long MODE_NEWFILE;

volatile long DISKIO2_OinfoFileHandle;
volatile UBYTE TEXTDISP_PrimaryGroupCode;
volatile char *ESQIFF_PrimaryLineHeadPtr;
volatile char *ESQIFF_PrimaryLineTailPtr;

long DISKIO2_WriteOinfoDataFile(void)
{
    const long FILEHANDLE_INVALID = 0;
    const long RESULT_FAIL = -1;
    const long RESULT_OK = 0;
    const char CH_NUL = 0;
    const ULONG STR_TERM_BYTES = 1;
    char empty = 0;
    const volatile char *line;
    const volatile char *scan;
    ULONG len;

    DISKIO2_OinfoFileHandle = DISKIO_OpenFileWithBuffer(
        CTASKS_PATH_OINFO_DAT,
        MODE_NEWFILE);
    if (DISKIO2_OinfoFileHandle == FILEHANDLE_INVALID) {
        return RESULT_FAIL;
    }

    DISKIO_WriteDecimalField(
        DISKIO2_OinfoFileHandle,
        (long)TEXTDISP_PrimaryGroupCode);

    line = ESQIFF_PrimaryLineHeadPtr != 0
        ? (const volatile char *)ESQIFF_PrimaryLineHeadPtr
        : (const volatile char *)&empty;
    scan = line;
    while (*scan != CH_NUL) {
        scan++;
    }
    len = (ULONG)(scan - line) + STR_TERM_BYTES;
    DISKIO_WriteBufferedBytes(DISKIO2_OinfoFileHandle, (const char *)line, len);

    line = ESQIFF_PrimaryLineTailPtr != 0
        ? (const volatile char *)ESQIFF_PrimaryLineTailPtr
        : (const volatile char *)&empty;
    scan = line;
    while (*scan != CH_NUL) {
        scan++;
    }
    len = (ULONG)(scan - line) + STR_TERM_BYTES;
    DISKIO_WriteBufferedBytes(DISKIO2_OinfoFileHandle, (const char *)line, len);

    DISKIO_CloseBufferedFileAndFlush(DISKIO2_OinfoFileHandle);
    return RESULT_OK;
}
