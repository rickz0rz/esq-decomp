#include <exec/types.h>

struct ExecBase;
extern struct ExecBase *AbsExecBase;
#pragma libcall AbsExecBase AllocMem c6 1002
extern APTR AllocMem(ULONG byteSize, ULONG requirements);

APTR Test_AllocMemCall(ULONG bytes, ULONG flags)
{
    return AllocMem(bytes, flags);
}
