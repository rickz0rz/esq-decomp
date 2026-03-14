#include <exec/types.h>
extern void *Global_REF_UTILITY_LIBRARY;
extern LONG _LVOAmiga2Date(void *utilityBase, LONG seconds, void *clockData);

LONG CLOCK_ConvertAmigaSecondsToClockData(LONG seconds, void *clockData)
{
    return _LVOAmiga2Date(Global_REF_UTILITY_LIBRARY, seconds, clockData);
}
