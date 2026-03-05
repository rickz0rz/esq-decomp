typedef unsigned short UWORD;
typedef signed long LONG;

extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UWORD TEXTDISP_SecondaryGroupEntryCount;
extern void *TEXTDISP_PrimaryEntryPtrTable[];
extern void *TEXTDISP_SecondaryEntryPtrTable[];
extern void *TEXTDISP_PrimaryTitlePtrTable[];
extern void *TEXTDISP_SecondaryTitlePtrTable[];

void *ESQDISP_GetEntryPointerByMode(LONG index, LONG mode)
{
    if (mode == 1) {
        if (index < 0) {
            return 0;
        }
        if (index >= (LONG)TEXTDISP_PrimaryGroupEntryCount) {
            return 0;
        }
        return TEXTDISP_PrimaryEntryPtrTable[index];
    }

    if (mode == 2) {
        if (index < 0) {
            return 0;
        }
        if (index >= (LONG)TEXTDISP_SecondaryGroupEntryCount) {
            return 0;
        }
        return TEXTDISP_SecondaryEntryPtrTable[index];
    }

    return 0;
}

void *ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode)
{
    if (mode == 1) {
        if (index < 0) {
            return 0;
        }
        if (index >= (LONG)TEXTDISP_PrimaryGroupEntryCount) {
            return 0;
        }
        return TEXTDISP_PrimaryTitlePtrTable[index];
    }

    if (mode == 2) {
        if (index < 0) {
            return 0;
        }
        if (index >= (LONG)TEXTDISP_SecondaryGroupEntryCount) {
            return 0;
        }
        return TEXTDISP_SecondaryTitlePtrTable[index];
    }

    return 0;
}
