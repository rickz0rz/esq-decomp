typedef unsigned char UBYTE;
typedef unsigned long ULONG;

extern long DISKIO_OpenFileWithBuffer(const char *path, long mode);
extern void DISKIO_WriteDecimalField(long handle, long value);
extern void DISKIO_WriteBufferedBytes(long handle, const char *buf, ULONG len);
extern void DISKIO_CloseBufferedFileAndFlush(long handle);

extern const char CTASKS_PATH_OINFO_DAT[];
extern long MODE_NEWFILE;

volatile long DISKIO2_OinfoFileHandle;
volatile UBYTE TEXTDISP_PrimaryGroupCode;
volatile char *ESQIFF_PrimaryLineHeadPtr;
volatile char *ESQIFF_PrimaryLineTailPtr;

long DISKIO2_WriteOinfoDataFile(void)
{
    char empty = 0;
    const char *line;
    const char *scan;
    ULONG len;

    DISKIO2_OinfoFileHandle = DISKIO_OpenFileWithBuffer(
        CTASKS_PATH_OINFO_DAT,
        MODE_NEWFILE);
    if (DISKIO2_OinfoFileHandle == 0) {
        return -1;
    }

    DISKIO_WriteDecimalField(
        DISKIO2_OinfoFileHandle,
        (long)TEXTDISP_PrimaryGroupCode);

    line = ESQIFF_PrimaryLineHeadPtr != 0 ? ESQIFF_PrimaryLineHeadPtr : &empty;
    scan = line;
    while (*scan != 0) {
        scan++;
    }
    len = (ULONG)(scan - line) + 1;
    DISKIO_WriteBufferedBytes(DISKIO2_OinfoFileHandle, line, len);

    line = ESQIFF_PrimaryLineTailPtr != 0 ? ESQIFF_PrimaryLineTailPtr : &empty;
    scan = line;
    while (*scan != 0) {
        scan++;
    }
    len = (ULONG)(scan - line) + 1;
    DISKIO_WriteBufferedBytes(DISKIO2_OinfoFileHandle, line, len);

    DISKIO_CloseBufferedFileAndFlush(DISKIO2_OinfoFileHandle);
    return 0;
}
