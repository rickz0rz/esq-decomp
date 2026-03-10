typedef signed long LONG;

extern LONG TLIBA2_ResolveEntryWindowAndSlotCount(
    void *entryTable,
    void *entryState,
    LONG entryIndex,
    LONG *outRange,
    LONG flags,
    LONG *outSlotCount,
    LONG *outStart,
    LONG *outEnd,
    LONG wildcardMode);

LONG TLIBA2_ResolveEntryWindowWithDefaultRange(void *entryTable, void *entryState, LONG entryIndex)
{
    return TLIBA2_ResolveEntryWindowAndSlotCount(
        entryTable,
        entryState,
        entryIndex,
        (LONG *)0,
        0,
        (LONG *)0,
        (LONG *)0,
        (LONG *)0,
        0);
}
