typedef signed long LONG;

extern LONG TLIBA2_ResolveEntryWindowAndSlotCount(void *entryTable, void *entryState, LONG entryIndex, LONG outStart, LONG outEnd);

LONG TLIBA2_ResolveEntryWindowWithDefaultRange(void *entryTable, void *entryState, LONG entryIndex)
{
    return TLIBA2_ResolveEntryWindowAndSlotCount(entryTable, entryState, entryIndex, 0, 0);
}
