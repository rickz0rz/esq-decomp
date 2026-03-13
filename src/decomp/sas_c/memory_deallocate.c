#include <exec/types.h>

struct ExecBase;
extern struct ExecBase *AbsExecBase;
#pragma libcall AbsExecBase FreeMem d2 902
extern void FreeMem(APTR memoryBlock, ULONG byteSize);

extern ULONG Global_MEM_BYTES_ALLOCATED;
extern ULONG Global_MEM_DEALLOC_COUNT;

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
