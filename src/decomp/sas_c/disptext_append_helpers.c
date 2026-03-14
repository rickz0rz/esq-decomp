#include <exec/types.h>
#define MEMF_PUBLIC 1UL
#define DISPTEXT_AVAILMEM_THRESHOLD 0x2710UL
#define DISPTEXT_ALLOC_SOURCE_LINE 127UL

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

LONG DISPTEXT_AppendToBuffer(const char *src)
{
    char *newBuffer = (char *)0;

    if (DISPTEXT_TextBufferPtr != (char *)0) {
        char *dstEnd;
        const char *srcEnd;
        ULONG allocSize;

        dstEnd = DISPTEXT_TextBufferPtr;
        while (*dstEnd++ != 0) {
        }
        dstEnd--;

        srcEnd = src;
        while (*srcEnd++ != 0) {
        }
        srcEnd--;

        allocSize = (ULONG)(dstEnd - DISPTEXT_TextBufferPtr);
        allocSize += (ULONG)(srcEnd - src);
        allocSize += 1;

        if (_LVOAvailMem(AbsExecBase, MEMF_PUBLIC) > DISPTEXT_AVAILMEM_THRESHOLD) {
            newBuffer = (char *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
                Global_STR_DISPTEXT_C_1,
                DISPTEXT_ALLOC_SOURCE_LINE,
                allocSize,
                MEMF_PUBLIC);
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

    if (DISPTEXT_TextBufferPtr != (char *)0) {
        return -1L;
    }
    return 0L;
}
