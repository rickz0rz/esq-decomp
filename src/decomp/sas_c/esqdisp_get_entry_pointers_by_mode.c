#include <exec/types.h>
extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UWORD TEXTDISP_SecondaryGroupEntryCount;
extern const char *TEXTDISP_PrimaryEntryPtrTable[];
extern const char *TEXTDISP_SecondaryEntryPtrTable[];
extern const char *TEXTDISP_PrimaryTitlePtrTable[];
extern const char *TEXTDISP_SecondaryTitlePtrTable[];

const char *ESQDISP_GetEntryPointerByMode(LONG index, LONG mode)
{
    if (mode == 1) {
        if (index < 0) {
            return (const char *)0;
        }
        if (index >= (LONG)TEXTDISP_PrimaryGroupEntryCount) {
            return (const char *)0;
        }
        return TEXTDISP_PrimaryEntryPtrTable[index];
    }

    if (mode == 2) {
        if (index < 0) {
            return (const char *)0;
        }
        if (index >= (LONG)TEXTDISP_SecondaryGroupEntryCount) {
            return (const char *)0;
        }
        return TEXTDISP_SecondaryEntryPtrTable[index];
    }

    return (const char *)0;
}

const char *ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode)
{
    if (mode == 1) {
        if (index < 0) {
            return (const char *)0;
        }
        if (index >= (LONG)TEXTDISP_PrimaryGroupEntryCount) {
            return (const char *)0;
        }
        return TEXTDISP_PrimaryTitlePtrTable[index];
    }

    if (mode == 2) {
        if (index < 0) {
            return (const char *)0;
        }
        if (index >= (LONG)TEXTDISP_SecondaryGroupEntryCount) {
            return (const char *)0;
        }
        return TEXTDISP_SecondaryTitlePtrTable[index];
    }

    return (const char *)0;
}
