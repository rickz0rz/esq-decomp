typedef unsigned short UWORD;
typedef signed long LONG;

typedef struct ESQDISP_EntryTableEntry {
    char pad0[1];
} ESQDISP_EntryTableEntry;

typedef struct ESQDISP_TitleTableEntry {
    char pad0[1];
} ESQDISP_TitleTableEntry;

extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UWORD TEXTDISP_SecondaryGroupEntryCount;
extern ESQDISP_EntryTableEntry *TEXTDISP_PrimaryEntryPtrTable[];
extern ESQDISP_EntryTableEntry *TEXTDISP_SecondaryEntryPtrTable[];
extern ESQDISP_TitleTableEntry *TEXTDISP_PrimaryTitlePtrTable[];
extern ESQDISP_TitleTableEntry *TEXTDISP_SecondaryTitlePtrTable[];

ESQDISP_EntryTableEntry *ESQDISP_GetEntryPointerByMode(LONG index, LONG mode)
{
    if (mode == 1) {
        if (index < 0) {
            return (ESQDISP_EntryTableEntry *)0;
        }
        if (index >= (LONG)TEXTDISP_PrimaryGroupEntryCount) {
            return (ESQDISP_EntryTableEntry *)0;
        }
        return TEXTDISP_PrimaryEntryPtrTable[index];
    }

    if (mode == 2) {
        if (index < 0) {
            return (ESQDISP_EntryTableEntry *)0;
        }
        if (index >= (LONG)TEXTDISP_SecondaryGroupEntryCount) {
            return (ESQDISP_EntryTableEntry *)0;
        }
        return TEXTDISP_SecondaryEntryPtrTable[index];
    }

    return (ESQDISP_EntryTableEntry *)0;
}

ESQDISP_TitleTableEntry *ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode)
{
    if (mode == 1) {
        if (index < 0) {
            return (ESQDISP_TitleTableEntry *)0;
        }
        if (index >= (LONG)TEXTDISP_PrimaryGroupEntryCount) {
            return (ESQDISP_TitleTableEntry *)0;
        }
        return TEXTDISP_PrimaryTitlePtrTable[index];
    }

    if (mode == 2) {
        if (index < 0) {
            return (ESQDISP_TitleTableEntry *)0;
        }
        if (index >= (LONG)TEXTDISP_SecondaryGroupEntryCount) {
            return (ESQDISP_TitleTableEntry *)0;
        }
        return TEXTDISP_SecondaryTitlePtrTable[index];
    }

    return (ESQDISP_TitleTableEntry *)0;
}
