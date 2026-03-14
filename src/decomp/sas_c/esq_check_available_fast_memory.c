#include <exec/types.h>
extern void *AbsExecBase;
extern ULONG _LVOAvailMem(void *execBase, ULONG attributes);
extern volatile UWORD HAS_REQUESTED_FAST_MEMORY;

ULONG ESQ_CheckAvailableFastMemory(void)
{
    ULONG bytes = _LVOAvailMem(AbsExecBase, 2);

    if (bytes < 600000UL) {
        HAS_REQUESTED_FAST_MEMORY = 1;
    }

    return bytes;
}
