#include <exec/types.h>
extern char *ESQIFF_SecondaryLineHeadPtr;
extern char *ESQIFF_SecondaryLineTailPtr;
extern char *ESQIFF_PrimaryLineHeadPtr;
extern char *ESQIFF_PrimaryLineTailPtr;

extern char *ESQPARS_ReplaceOwnedString(const char *new_ptr, char *old_ptr);

char *ESQIFF2_ClearLineHeadTailByMode(WORD mode)
{
    char *result;

    if (mode == 2) {
        result = ESQPARS_ReplaceOwnedString((const char *)0, ESQIFF_SecondaryLineHeadPtr);
        ESQIFF_SecondaryLineHeadPtr = result;
        result = ESQPARS_ReplaceOwnedString((const char *)0, ESQIFF_SecondaryLineTailPtr);
        ESQIFF_SecondaryLineTailPtr = result;
    } else {
        result = ESQPARS_ReplaceOwnedString((const char *)0, ESQIFF_PrimaryLineHeadPtr);
        ESQIFF_PrimaryLineHeadPtr = result;
        result = ESQPARS_ReplaceOwnedString((const char *)0, ESQIFF_PrimaryLineTailPtr);
        ESQIFF_PrimaryLineTailPtr = result;
    }

    return result;
}
