typedef signed long LONG;
typedef signed short WORD;

extern LONG COI_TestEntryWithinTimeWindow(const void *entry, const void *aux, WORD slot, LONG win, LONG tol);

LONG COI_ProcessEntrySelectionState(void *entry, void *aux, LONG idx, LONG win, LONG tol)
{
    return COI_TestEntryWithinTimeWindow(entry, aux, (WORD)idx, win, tol);
}
