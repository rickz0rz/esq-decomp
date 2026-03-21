#include <exec/types.h>

extern void *Global_REF_UTILITY_LIBRARY;
#pragma libcall Global_REF_UTILITY_LIBRARY CheckDate 84 801
extern LONG CheckDate(void *clockData);

LONG CLOCK_CheckDateOrSecondsFromEpoch(void *clockData)
{
    return CheckDate(clockData);
}
