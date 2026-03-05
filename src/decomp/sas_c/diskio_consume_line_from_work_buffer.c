typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG Global_REF_LONG_FILE_SCRATCH;
extern UBYTE *Global_PTR_WORK_BUFFER;

UBYTE *DISKIO_ConsumeLineFromWorkBuffer(void)
{
    UBYTE *start;

    start = Global_PTR_WORK_BUFFER;

    while (Global_REF_LONG_FILE_SCRATCH-- > 0) {
        UBYTE ch;

        ch = *Global_PTR_WORK_BUFFER;
        if (ch == 13 || ch == 10) {
            break;
        }
        Global_PTR_WORK_BUFFER++;
    }

    *Global_PTR_WORK_BUFFER++ = 0;

    if (Global_REF_LONG_FILE_SCRATCH < 0) {
        return (UBYTE *)0xFFFF;
    }

    while (1) {
        UBYTE ch;

        ch = *Global_PTR_WORK_BUFFER;
        if (ch != 13 && ch != 10) {
            break;
        }
        Global_PTR_WORK_BUFFER++;
        Global_REF_LONG_FILE_SCRATCH--;
    }

    return start;
}
