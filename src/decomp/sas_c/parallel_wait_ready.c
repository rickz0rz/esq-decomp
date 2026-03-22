#include <exec/types.h>

extern LONG PARALLEL_CheckReady(void);

void PARALLEL_WaitReady(void)
{
    while (PARALLEL_CheckReady() < 0) {
    }
}
