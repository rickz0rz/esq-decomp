typedef signed long LONG;
typedef unsigned char UBYTE;

enum {
    DISKIO_WORKBUF_SENTINEL_ERROR = 0xFFFF
};

#define DISKIO_COUNT_ZERO 0
#define DISKIO_CSTRING_CH_NUL 0

extern LONG Global_REF_LONG_FILE_SCRATCH;
extern char *Global_PTR_WORK_BUFFER;

char *DISKIO_ConsumeCStringFromWorkBuffer(void)
{
    char *cstringStart;

    cstringStart = Global_PTR_WORK_BUFFER;

    while (Global_REF_LONG_FILE_SCRATCH-- > DISKIO_COUNT_ZERO) {
        UBYTE ch;
        char *p;

        p = Global_PTR_WORK_BUFFER;
        ch = *p++;
        Global_PTR_WORK_BUFFER = p;
        if (ch == DISKIO_CSTRING_CH_NUL) {
            break;
        }
    }

    if (Global_REF_LONG_FILE_SCRATCH < DISKIO_COUNT_ZERO) {
        cstringStart = (char *)DISKIO_WORKBUF_SENTINEL_ERROR;
    }

    return cstringStart;
}
