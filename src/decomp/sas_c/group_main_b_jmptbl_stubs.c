#include <exec/types.h>
extern LONG DOS_Delay(LONG ticks);
extern void STREAM_BufferedWriteString(const char *s);
extern unsigned long MATH_Mulu32(unsigned long a, unsigned long b);
extern LONG BUFFER_FlushAllAndCloseWithCode(LONG code);

LONG GROUP_MAIN_B_JMPTBL_DOS_Delay(LONG ticks)
{
    return DOS_Delay(ticks);
}

void GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString(const char *s)
{
    STREAM_BufferedWriteString(s);
}

unsigned long GROUP_MAIN_B_JMPTBL_MATH_Mulu32(unsigned long a, unsigned long b)
{
    return MATH_Mulu32(a, b);
}

LONG GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode(LONG code)
{
    return BUFFER_FlushAllAndCloseWithCode(code);
}
