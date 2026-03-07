typedef signed long LONG;
typedef unsigned char UBYTE;

enum {
    DISKIO_COUNT_ZERO = 0,
    DISKIO_CH_NUL = 0,
    DISKIO_CH_LF = 10,
    DISKIO_CH_CR = 13,
    DISKIO_WORKBUF_SENTINEL_ERROR = 0xFFFF
};

extern LONG Global_REF_LONG_FILE_SCRATCH;
extern UBYTE *Global_PTR_WORK_BUFFER;

UBYTE *DISKIO_ConsumeLineFromWorkBuffer(void)
{
    UBYTE *start;

    start = Global_PTR_WORK_BUFFER;

    while (Global_REF_LONG_FILE_SCRATCH-- > DISKIO_COUNT_ZERO) {
        UBYTE ch;

        ch = *Global_PTR_WORK_BUFFER;
        if (ch == DISKIO_CH_CR || ch == DISKIO_CH_LF) {
            break;
        }
        Global_PTR_WORK_BUFFER++;
    }

    *Global_PTR_WORK_BUFFER++ = DISKIO_CH_NUL;

    if (Global_REF_LONG_FILE_SCRATCH < DISKIO_COUNT_ZERO) {
        return (UBYTE *)DISKIO_WORKBUF_SENTINEL_ERROR;
    }

    while (1) {
        UBYTE ch;

        ch = *Global_PTR_WORK_BUFFER;
        if (ch != DISKIO_CH_CR && ch != DISKIO_CH_LF) {
            break;
        }
        Global_PTR_WORK_BUFFER++;
        Global_REF_LONG_FILE_SCRATCH--;
    }

    return start;
}
