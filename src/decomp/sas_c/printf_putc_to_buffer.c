typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG Global_PrintfByteCount;
extern UBYTE *Global_PrintfBufferPtr;

LONG UNKNOWN10_PrintfPutcToBuffer(LONG ch)
{
    Global_PrintfByteCount += 1;
    *Global_PrintfBufferPtr++ = (UBYTE)ch;

    return ch;
}
