typedef signed long LONG;

extern void *Global_REF_UTILITY_LIBRARY;
extern LONG _LVOCheckDate(void *utilityBase, void *clockData);
extern LONG _LVODate2Amiga(void *utilityBase, void *clockData);

LONG CLOCK_CheckDateOrSecondsFromEpoch(void *clockData)
{
    return _LVOCheckDate(Global_REF_UTILITY_LIBRARY, clockData);
}

LONG CLOCK_SecondsFromEpoch(void *clockData)
{
    return _LVODate2Amiga(Global_REF_UTILITY_LIBRARY, clockData);
}
