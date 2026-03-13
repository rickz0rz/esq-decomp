typedef signed long LONG;

extern const char Global_STR_PERCENT_LD[];
extern LONG WDISP_SPrintf(char *dst, const char *fmt, LONG value);
extern LONG DISKIO_WriteBufferedBytes(LONG handle, const void *src, LONG len);

void DISKIO_WriteDecimalField(LONG handle, LONG value)
{
    char scratch[10];
    char *scan;

    WDISP_SPrintf(scratch, Global_STR_PERCENT_LD, value);

    scan = scratch;
    while (*scan != 0) {
        scan++;
    }

    DISKIO_WriteBufferedBytes(handle, scratch, (LONG)(scan - scratch) + 1);
}
