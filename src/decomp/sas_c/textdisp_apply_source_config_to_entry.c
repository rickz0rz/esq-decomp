#include <exec/types.h>
typedef struct TEXTDISP_Entry {
    UBYTE pad0[12];
    char name[1];
    UBYTE pad1[27];
    UBYTE flags40;
} TEXTDISP_Entry;

typedef struct TEXTDISP_SourceConfigEntry {
    char *name;
    UBYTE flagMask;
} TEXTDISP_SourceConfigEntry;

extern UBYTE TEXTDISP_SourceConfigFlagMask;
extern LONG TEXTDISP_SourceConfigEntryCount;
extern TEXTDISP_SourceConfigEntry *TEXTDISP_SourceConfigEntryTable[];

extern LONG STRING_CompareNoCaseN(const char *a, const char *b, LONG n);

void TEXTDISP_ApplySourceConfigToEntry(TEXTDISP_Entry *entry)
{
    LONG i;

    if (entry == 0) {
        return;
    }

    entry->flags40 &= (UBYTE)~TEXTDISP_SourceConfigFlagMask;

    for (i = 0; i < TEXTDISP_SourceConfigEntryCount; ++i) {
        TEXTDISP_SourceConfigEntry *cfg = TEXTDISP_SourceConfigEntryTable[i];
        char *name = cfg->name;
        char *scan = name;
        LONG n;

        while (*scan != 0) {
            ++scan;
        }

        n = (LONG)(scan - name);

        if (STRING_CompareNoCaseN(name, entry->name, n) == 0) {
            entry->flags40 |= cfg->flagMask;
        }
    }
}
