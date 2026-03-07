typedef signed long LONG;
typedef unsigned long ULONG;
typedef signed short WORD;

extern char Global_STR_ESQFUNC_C_5[];
extern void *LADFUNC_LineTextBufferPtrs[];
extern WORD LADFUNC_LineSlotWriteIndex;
extern WORD LADFUNC_LineSlotSecondaryIndex;

extern void *ESQIFF_JMPTBL_MEMORY_AllocateMemory(const char *fileTag, LONG line, ULONG bytes, ULONG flags);

#ifndef MEMF_PUBLIC
#define MEMF_PUBLIC 1UL
#endif
#ifndef MEMF_CLEAR
#define MEMF_CLEAR 65536UL
#endif

void ESQFUNC_AllocateLineTextBuffers(void)
{
    WORD i;

    for (i = 0; i < 20; ++i) {
        LADFUNC_LineTextBufferPtrs[i] = ESQIFF_JMPTBL_MEMORY_AllocateMemory(
            Global_STR_ESQFUNC_C_5,
            1222,
            60,
            MEMF_PUBLIC + MEMF_CLEAR);
    }

    LADFUNC_LineSlotWriteIndex = 0;
    LADFUNC_LineSlotSecondaryIndex = 0;
}
