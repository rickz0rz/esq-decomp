typedef signed long LONG;
typedef unsigned char UBYTE;

#define MEMF_PUBLIC 0x00000001L
#define MEMF_CLEAR  0x00010000L

typedef struct TEXTDISP_SourceConfigEntry {
    char *name;
    UBYTE pad0[3];
    UBYTE flagMask;
} TEXTDISP_SourceConfigEntry;

extern TEXTDISP_SourceConfigEntry *TEXTDISP_SourceConfigEntryTable[];
extern LONG TEXTDISP_SourceConfigEntryCount;
extern UBYTE TEXTDISP_SourceConfigFlagMask;
extern const char *TEXTDISP_PtrPrevueSportsTag;

extern const char Global_STR_TEXTDISP_C_4[];
extern void *MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);
extern char *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(char *newStr, char *oldStr);
extern LONG STRING_CompareNoCase(const char *a, const char *b);

void TEXTDISP_AddSourceConfigEntry(char *name, const char *tag)
{
    LONG idx = TEXTDISP_SourceConfigEntryCount;
    TEXTDISP_SourceConfigEntry **slot = &TEXTDISP_SourceConfigEntryTable[idx];

    *slot = (TEXTDISP_SourceConfigEntry *)MEMORY_AllocateMemory(
        Global_STR_TEXTDISP_C_4,
        1229,
        6,
        (MEMF_PUBLIC + MEMF_CLEAR)
    );

    if (*slot == (TEXTDISP_SourceConfigEntry *)0) {
        return;
    }

    TEXTDISP_SourceConfigEntryCount = idx + 1;

    (*slot)->name = ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(name, (*slot)->name);

    if (STRING_CompareNoCase(tag, TEXTDISP_PtrPrevueSportsTag) == 0) {
        (*slot)->flagMask = 8;
    }

    TEXTDISP_SourceConfigFlagMask |= (*slot)->flagMask;
}
