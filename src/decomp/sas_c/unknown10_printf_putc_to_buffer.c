typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG Global_PrintfByteCount;
extern UBYTE *Global_PrintfBufferPtr;

void UNKNOWN10_PrintfPutcToBuffer(LONG ch)
{
    UBYTE *p;

    Global_PrintfByteCount += 1;
    p = Global_PrintfBufferPtr;
    *p++ = (UBYTE)ch;
    Global_PrintfBufferPtr = p;
}
