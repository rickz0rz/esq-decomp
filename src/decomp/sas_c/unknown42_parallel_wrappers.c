#include <exec/types.h>
extern void PARALLEL_WriteCharD0(LONG ch);
extern void PARALLEL_WriteCharHw(LONG ch);
extern void PARALLEL_RawDoFmt(char *fmt, void *args, void (*out)(LONG));
extern void PARALLEL_RawDoFmtCommon(char *fmt, void *args);

void PARALLEL_WriteChar(LONG ch)
{
    PARALLEL_WriteCharD0(ch);
}

void PARALLEL_WriteString(const char *s)
{
    while (*s != 0) {
        PARALLEL_WriteCharD0((LONG)*s);
        ++s;
    }
}

void PARALLEL_RawDoFmtPtrs(char *fmt, void *args)
{
    PARALLEL_RawDoFmtCommon(fmt, args);
}

void PARALLEL_RawDoFmtRegs(char *fmt, void *args, void (*out)(LONG), void *dataStream)
{
    (void)dataStream;
    PARALLEL_RawDoFmt(fmt, args, out);
}

void PARALLEL_WriteCharHwFromStack(LONG ch)
{
    PARALLEL_WriteCharHw(ch);
}
