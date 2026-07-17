#include <exec/types.h>

/* 4-arg (file, line, ptr, size) debug free; forwards ptr/size (args 3/4) to the
   restored 2-arg core, matching the original wrapper's ABI. */
extern void MEMORY_DeallocateMemory(void *memoryBlock, LONG byteSize);

void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *file, LONG line,
                                             void *memoryBlock, LONG byteSize)
{
    (void)file; (void)line;
    MEMORY_DeallocateMemory(memoryBlock, byteSize);
}
