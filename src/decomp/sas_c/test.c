#include <exec/types.h>

struct ExecBase;
extern struct ExecBase *AbsExecBase;
#pragma libcall AbsExecBase AllocMem c6 1002
extern APTR AllocMem(ULONG byteSize, ULONG requirements);

extern ULONG Global_MEM_BYTES_ALLOCATED;
extern ULONG Global_MEM_ALLOC_COUNT;

void AllocateMemory(ULONG bytesToAllocate, ULONG attributes)
{
    AllocMem(bytesToAllocate, attributes);

    Global_MEM_BYTES_ALLOCATED += bytesToAllocate;
    Global_MEM_ALLOC_COUNT += 1;
}

