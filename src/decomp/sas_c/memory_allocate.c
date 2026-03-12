#include <exec/types.h>

struct ExecBase;
extern struct ExecBase *AbsExecBase;
#pragma libcall AbsExecBase AllocMem c6 1002
extern APTR AllocMem(ULONG byteSize, ULONG requirements);

extern ULONG Global_MEM_BYTES_ALLOCATED;
extern ULONG Global_MEM_ALLOC_COUNT;

APTR MEMORY_AllocateMemory(ULONG byteSize, ULONG attributes)
{
    APTR memoryBlock;

    memoryBlock = AllocMem(byteSize, attributes);
    Global_MEM_BYTES_ALLOCATED += byteSize;
    Global_MEM_ALLOC_COUNT += 1;

    return memoryBlock;
}
