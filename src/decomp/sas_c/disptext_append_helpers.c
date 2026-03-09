typedef signed long LONG;
typedef unsigned long ULONG;

extern void *AbsExecBase;
extern char *DISPTEXT_TextBufferPtr;
extern const char Global_STR_DISPTEXT_C_1[];

extern ULONG _LVOAvailMem(void *execBase, ULONG attributes);
extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
    const char *file,
    ULONG line,
    ULONG size,
    ULONG flags);
extern char *GROUP_AI_JMPTBL_STRING_AppendAtNull(char *dst, const char *src);
extern char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(const char *newText, char *oldText);

LONG DISPTEXT_AppendToBuffer(char *src)
{
    const ULONG AVAILMEM_CHIP_FLAG = 1;
    const ULONG TEXTBUFFER_ALLOC_FLAGS = 1;
    const ULONG AVAILMEM_MIN_ALLOC_THRESHOLD = 0x2710UL;
    const ULONG ALLOC_SOURCE_LINE = 127;
    char *newBuffer = (char *)0;

    if (DISPTEXT_TextBufferPtr != (char *)0) {
        ULONG dstLen = 0;
        ULONG srcLen = 0;
        ULONG allocSize;
        ULONG avail;
        char *scan;

        scan = DISPTEXT_TextBufferPtr;
        while (*scan++ != 0) {
            dstLen++;
        }

        scan = src;
        while (*scan++ != 0) {
            srcLen++;
        }

        allocSize = dstLen + srcLen + 1;
        avail = _LVOAvailMem(AbsExecBase, AVAILMEM_CHIP_FLAG);

        if (avail > AVAILMEM_MIN_ALLOC_THRESHOLD) {
            newBuffer = (char *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
                Global_STR_DISPTEXT_C_1,
                ALLOC_SOURCE_LINE,
                allocSize,
                TEXTBUFFER_ALLOC_FLAGS);
        }

        if (newBuffer != (char *)0) {
            char *dst = newBuffer;
            char *old = DISPTEXT_TextBufferPtr;

            while ((*dst++ = *old++) != 0) {
            }

            GROUP_AI_JMPTBL_STRING_AppendAtNull(newBuffer, src);
            GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString((const char *)0, DISPTEXT_TextBufferPtr);
            DISPTEXT_TextBufferPtr = newBuffer;
        }
    } else {
        DISPTEXT_TextBufferPtr = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(src, DISPTEXT_TextBufferPtr);
    }

    return (DISPTEXT_TextBufferPtr != (char *)0) ? -1L : 0L;
}
