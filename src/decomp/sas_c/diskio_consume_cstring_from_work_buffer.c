typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG Global_REF_LONG_FILE_SCRATCH;
extern UBYTE *Global_PTR_WORK_BUFFER;

UBYTE *DISKIO_ConsumeCStringFromWorkBuffer(void)
{
    UBYTE *start;

    start = Global_PTR_WORK_BUFFER;

    while (Global_REF_LONG_FILE_SCRATCH-- > 0) {
        UBYTE ch;
        UBYTE *p;

        p = Global_PTR_WORK_BUFFER;
        ch = *p++;
        Global_PTR_WORK_BUFFER = p;
        if (ch == 0) {
            break;
        }
    }

    if (Global_REF_LONG_FILE_SCRATCH < 0) {
        start = (UBYTE *)0xFFFF;
    }

    return start;
}
