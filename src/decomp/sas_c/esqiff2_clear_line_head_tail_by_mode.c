typedef short WORD;

extern void *ESQIFF_SecondaryLineHeadPtr;
extern void *ESQIFF_SecondaryLineTailPtr;
extern void *ESQIFF_PrimaryLineHeadPtr;
extern void *ESQIFF_PrimaryLineTailPtr;

extern void *ESQPARS_ReplaceOwnedString(void *new_ptr, void *old_ptr);

void *ESQIFF2_ClearLineHeadTailByMode(WORD mode)
{
    void *result;

    if (mode == 2) {
        result = ESQPARS_ReplaceOwnedString((void *)0, ESQIFF_SecondaryLineHeadPtr);
        ESQIFF_SecondaryLineHeadPtr = result;
        result = ESQPARS_ReplaceOwnedString((void *)0, ESQIFF_SecondaryLineTailPtr);
        ESQIFF_SecondaryLineTailPtr = result;
    } else {
        result = ESQPARS_ReplaceOwnedString((void *)0, ESQIFF_PrimaryLineHeadPtr);
        ESQIFF_PrimaryLineHeadPtr = result;
        result = ESQPARS_ReplaceOwnedString((void *)0, ESQIFF_PrimaryLineTailPtr);
        ESQIFF_PrimaryLineTailPtr = result;
    }

    return result;
}
