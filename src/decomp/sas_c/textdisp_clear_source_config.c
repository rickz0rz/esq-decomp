typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct TEXTDISP_SourceConfigEntry {
    char *ownedName;
    unsigned short flags;
} TEXTDISP_SourceConfigEntry;

extern TEXTDISP_SourceConfigEntry *TEXTDISP_SourceConfigEntryTable[];
extern LONG TEXTDISP_SourceConfigEntryCount;
extern UBYTE TEXTDISP_SourceConfigFlagMask;

extern const char Global_STR_TEXTDISP_C_3[];
extern char *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(char *newStr, char *oldStr);
extern void MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);

void TEXTDISP_ClearSourceConfig(void)
{
    LONG i;

    for (i = 0; i < TEXTDISP_SourceConfigEntryCount; ++i) {
        TEXTDISP_SourceConfigEntry *entry = TEXTDISP_SourceConfigEntryTable[i];
        if (entry != (TEXTDISP_SourceConfigEntry *)0) {
            entry->ownedName = ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString((char *)0, entry->ownedName);
            MEMORY_DeallocateMemory(Global_STR_TEXTDISP_C_3, 1153, entry, 6);
            TEXTDISP_SourceConfigEntryTable[i] = (TEXTDISP_SourceConfigEntry *)0;
        }
    }

    TEXTDISP_SourceConfigEntryCount = 0;
    TEXTDISP_SourceConfigFlagMask = 0;
}
