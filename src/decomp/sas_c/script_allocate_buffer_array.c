typedef short WORD;
typedef signed long LONG;

extern const char Global_STR_SCRIPT_C_1[];

extern void *MEMORY_AllocateMemory(
    const char *fileName,
    LONG lineNumber,
    LONG byteSize,
    LONG flags);

void SCRIPT_AllocateBufferArray(void **outPtrs, WORD byteSize, WORD count)
{
    WORD i;

    for (i = 0; i < count; ++i) {
        outPtrs[(LONG)i] = MEMORY_AllocateMemory(
            Global_STR_SCRIPT_C_1,
            394L,
            (LONG)byteSize,
            65537L);
    }
}
