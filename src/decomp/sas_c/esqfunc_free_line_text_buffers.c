typedef signed long LONG;
typedef unsigned long ULONG;
typedef signed short WORD;

extern const char Global_STR_ESQFUNC_C_6[];
extern void *LADFUNC_LineTextBufferPtrs[];

extern void MEMORY_DeallocateMemory(void *ptr, ULONG bytes);

void ESQFUNC_FreeLineTextBuffers(void)
{
    WORD i;

    (void)Global_STR_ESQFUNC_C_6;
    for (i = 0; i < 20; ++i) {
        MEMORY_DeallocateMemory(LADFUNC_LineTextBufferPtrs[i], 60);
        LADFUNC_LineTextBufferPtrs[i] = 0;
    }
}
