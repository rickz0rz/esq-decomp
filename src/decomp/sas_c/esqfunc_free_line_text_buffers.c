typedef signed long LONG;
typedef unsigned long ULONG;
typedef signed short WORD;

extern const char Global_STR_ESQFUNC_C_6[];
extern void *LADFUNC_LineTextBufferPtrs[];

extern void ESQIFF_JMPTBL_MEMORY_DeallocateMemory(const char *fileTag, LONG line, void *ptr, ULONG bytes);

void ESQFUNC_FreeLineTextBuffers(void)
{
    WORD i;

    for (i = 0; i < 20; ++i) {
        ESQIFF_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_ESQFUNC_C_6,
            1235,
            LADFUNC_LineTextBufferPtrs[i],
            60);
        LADFUNC_LineTextBufferPtrs[i] = 0;
    }
}
