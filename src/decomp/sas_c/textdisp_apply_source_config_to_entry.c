typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct TEXTDISP_Entry {
    UBYTE pad0[12];
    char name[1];
    UBYTE pad1[27];
    UBYTE flags40;
} TEXTDISP_Entry;

typedef struct TEXTDISP_SourceConfigEntry {
    char *name;
    UBYTE pad0[3];
    UBYTE flagMask;
} TEXTDISP_SourceConfigEntry;

extern UBYTE TEXTDISP_SourceConfigFlagMask;
extern LONG TEXTDISP_SourceConfigEntryCount;
extern TEXTDISP_SourceConfigEntry *TEXTDISP_SourceConfigEntryTable[];

extern LONG STRING_CompareNoCaseN(const char *a, const char *b, LONG n);

void TEXTDISP_ApplySourceConfigToEntry(TEXTDISP_Entry *entry)
{
    const UBYTE CH_NUL = 0;
    LONG i;

    if (entry == (TEXTDISP_Entry *)0) {
        return;
    }

    entry->flags40 &= (UBYTE)~TEXTDISP_SourceConfigFlagMask;

    for (i = 0; i < TEXTDISP_SourceConfigEntryCount; ++i) {
        TEXTDISP_SourceConfigEntry *cfg = TEXTDISP_SourceConfigEntryTable[i];
        LONG n = 0;

        while (cfg->name[n] != CH_NUL) {
            ++n;
        }

        if (STRING_CompareNoCaseN(cfg->name, entry->name, n) == 0) {
            entry->flags40 |= cfg->flagMask;
        }
    }
}
