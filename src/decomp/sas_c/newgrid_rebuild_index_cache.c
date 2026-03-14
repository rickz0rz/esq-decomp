typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Entry {
    UBYTE pad0[12];
    char title[1];
} NEWGRID_Entry;

extern LONG *NEWGRID_SecondaryIndexCachePtr;
extern UWORD ESQPARS2_ReadModeFlags;
extern WORD TEXTDISP_PrimaryGroupEntryCount;
extern WORD TEXTDISP_SecondaryGroupEntryCount;

extern const NEWGRID_Entry *ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern LONG TLIBA_FindFirstWildcardMatchIndex(const char *pattern);

void NEWGRID_RebuildIndexCache(void)
{
    LONG primaryIndex;
    LONG wildcardIndex;
    UWORD savedReadModeFlags;
    const NEWGRID_Entry *entry;

    if (NEWGRID_SecondaryIndexCachePtr == 0) {
        return;
    }

    savedReadModeFlags = ESQPARS2_ReadModeFlags;
    ESQPARS2_ReadModeFlags = 0x0100;

    for (primaryIndex = 0; primaryIndex < 302; ++primaryIndex) {
        NEWGRID_SecondaryIndexCachePtr[primaryIndex] = -1;
    }

    for (primaryIndex = 0; primaryIndex < (LONG)(UWORD)TEXTDISP_PrimaryGroupEntryCount; ++primaryIndex) {
        entry = ESQDISP_GetEntryPointerByMode(primaryIndex, 1);
        if (entry != 0) {
            wildcardIndex = TLIBA_FindFirstWildcardMatchIndex(entry->title);
            if (wildcardIndex > -1 &&
                wildcardIndex < (LONG)(UWORD)TEXTDISP_SecondaryGroupEntryCount) {
                NEWGRID_SecondaryIndexCachePtr[primaryIndex] = wildcardIndex;
            }
        }
    }

    ESQPARS2_ReadModeFlags = savedReadModeFlags;
}
