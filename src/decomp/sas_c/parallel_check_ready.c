#include <exec/types.h>

extern LONG PARALLEL_CheckReadyStub(void);

LONG PARALLEL_CheckReady(void)
{
    return PARALLEL_CheckReadyStub();
}
