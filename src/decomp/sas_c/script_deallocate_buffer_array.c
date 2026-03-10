typedef short WORD;
typedef signed long LONG;

extern const char Global_STR_SCRIPT_C_2[];

extern void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(
    const char *fileName,
    LONG lineNumber,
    void *bufferPtr,
    LONG byteSize);

void SCRIPT_DeallocateBufferArray(void **outPtrs, WORD byteSize, WORD count)
{
    WORD i;

    for (i = 0; i < count; ++i) {
        SCRIPT_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_SCRIPT_C_2,
            405L,
            outPtrs[(LONG)i],
            (LONG)byteSize);
        outPtrs[(LONG)i] = (void *)0;
    }
}
