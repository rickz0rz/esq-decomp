#include <exec/types.h>

struct ExecBase;
extern struct ExecBase *AbsExecBase;
#pragma libcall AbsExecBase AllocMem c6 1002
#pragma libcall AbsExecBase FreeMem d2 902
extern APTR AllocMem(ULONG byteSize, ULONG requirements);
extern void FreeMem(APTR memoryBlock, ULONG byteSize);

extern ULONG Global_MEM_BYTES_ALLOCATED;
extern ULONG Global_MEM_ALLOC_COUNT;
extern ULONG Global_MEM_DEALLOC_COUNT;

APTR MEMORY_AllocateMemory(ULONG byteSize, ULONG attributes)
{
    APTR memoryBlock;

    memoryBlock = AllocMem(byteSize, attributes);
    Global_MEM_BYTES_ALLOCATED += byteSize;
    Global_MEM_ALLOC_COUNT += 1;

    return memoryBlock;
}

void MEMORY_DeallocateMemory(APTR memoryBlock, ULONG byteSize)
{
    if (memoryBlock == 0) {
        return;
    }

    if (byteSize == 0) {
        return;
    }

    FreeMem(memoryBlock, byteSize);
    Global_MEM_BYTES_ALLOCATED -= byteSize;
    Global_MEM_DEALLOC_COUNT += 1;
}
