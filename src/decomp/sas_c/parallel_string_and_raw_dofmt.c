#include <exec/types.h>
extern void PARALLEL_WriteCharD0(LONG ch);
extern void PARALLEL_RawDoFmt(char *fmt, void *args, void (*out)(LONG));

void PARALLEL_WriteStringLoop(const char *s)
{
    for (;;) {
        char ch = *s++;
        if (ch == 0) {
            return;
        }
        PARALLEL_WriteCharD0((LONG)ch);
    }
}

void PARALLEL_RawDoFmtCommon(char *fmt, void *args)
{
    PARALLEL_RawDoFmt(fmt, args, PARALLEL_WriteCharD0);
}

void PARALLEL_RawDoFmtStackArgs(char *fmt, ...)
{
    PARALLEL_RawDoFmtCommon(fmt, (void *)(&fmt + 1));
}
