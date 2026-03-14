#include <exec/types.h>
extern void *Global_REF_UTILITY_LIBRARY;
extern LONG _LVOCheckDate(void *utilityBase, void *clockData);

LONG CLOCK_CheckDateOrSecondsFromEpoch(void *clockData)
{
    return _LVOCheckDate(Global_REF_UTILITY_LIBRARY, clockData);
}
