typedef unsigned char UBYTE;

extern UBYTE TEXTDISP_PrimaryGroupCode;
extern UBYTE TEXTDISP_SecondaryGroupCode;
extern UBYTE LOCAVAIL_PrimaryFilterState[];
extern UBYTE LOCAVAIL_SecondaryFilterState[];

extern void LOCAVAIL_CopyFilterStateStructRetainRefs(void *dstState, const void *srcState);
extern void LOCAVAIL_FreeResourceChain(void *state);
extern void LOCAVAIL_ResetFilterCursorState(void *statePtr);

void LOCAVAIL_SyncSecondaryFilterForCurrentGroup(void)
{
    if (LOCAVAIL_SecondaryFilterState[0] != TEXTDISP_SecondaryGroupCode &&
        LOCAVAIL_PrimaryFilterState[0] == TEXTDISP_PrimaryGroupCode) {
        LOCAVAIL_FreeResourceChain(LOCAVAIL_SecondaryFilterState);
        LOCAVAIL_CopyFilterStateStructRetainRefs(LOCAVAIL_SecondaryFilterState, LOCAVAIL_PrimaryFilterState);
        LOCAVAIL_SecondaryFilterState[0] = TEXTDISP_SecondaryGroupCode;
    }
}

void LOCAVAIL_RebuildFilterStateFromCurrentGroup(void)
{
    LOCAVAIL_FreeResourceChain(LOCAVAIL_PrimaryFilterState);
    LOCAVAIL_CopyFilterStateStructRetainRefs(LOCAVAIL_PrimaryFilterState, LOCAVAIL_SecondaryFilterState);
    LOCAVAIL_FreeResourceChain(LOCAVAIL_SecondaryFilterState);
    LOCAVAIL_SecondaryFilterState[0] = (UBYTE)(TEXTDISP_PrimaryGroupCode - 1);
    LOCAVAIL_ResetFilterCursorState(LOCAVAIL_PrimaryFilterState);
}
