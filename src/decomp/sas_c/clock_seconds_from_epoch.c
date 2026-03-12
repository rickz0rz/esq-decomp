typedef signed long LONG;

extern void *Global_REF_UTILITY_LIBRARY;
extern LONG _LVODate2Amiga(void *utilityBase, void *clockData);

LONG CLOCK_SecondsFromEpoch(void *clockData)
{
    return _LVODate2Amiga(Global_REF_UTILITY_LIBRARY, clockData);
}
