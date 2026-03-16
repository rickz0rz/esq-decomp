#include <exec/memory.h>
#include <exec/types.h>

#define MEMF_PUBLIC_CLEAR (MEMF_PUBLIC | MEMF_CLEAR)

extern const char Global_STR_ESQFUNC_C_5[];
extern void *LADFUNC_LineTextBufferPtrs[];
extern WORD LADFUNC_LineSlotWriteIndex;
extern WORD LADFUNC_LineSlotSecondaryIndex;

extern void *ESQIFF_JMPTBL_MEMORY_AllocateMemory(const char *fileTag, LONG line, ULONG bytes, ULONG flags);

void ESQFUNC_AllocateLineTextBuffers(void)
{
    WORD i;

    for (i = 0; i < 20; ++i) {
        LADFUNC_LineTextBufferPtrs[i] = ESQIFF_JMPTBL_MEMORY_AllocateMemory(
            Global_STR_ESQFUNC_C_5,
            1222,
            60,
            MEMF_PUBLIC_CLEAR);
    }

    LADFUNC_LineSlotWriteIndex = 0;
    LADFUNC_LineSlotSecondaryIndex = 0;
}
