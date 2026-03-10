typedef signed long LONG;

typedef struct TEXTDISP_AliasEntry {
    LONG pad0;
    const char *aliasText;
} TEXTDISP_AliasEntry;

typedef struct TEXTDISP_Entry {
    char shortName[19];
    char fallbackName[1];
} TEXTDISP_Entry;

extern TEXTDISP_AliasEntry *TEXTDISP_AliasPtrTable[];
extern const char TEXTDISP_CenterAlignToken[];

extern LONG TEXTDISP_FindAliasIndexByName(const char *name);
extern char *STRING_AppendAtNull(char *dst, const char *src);

void TEXTDISP_BuildEntryShortName(const char *entry, char *out)
{
    out[0] = 0;
    if (entry != 0) {
        const TEXTDISP_Entry *entryView;
        LONG aliasIndex;

        entryView = (const TEXTDISP_Entry *)entry;
        aliasIndex = TEXTDISP_FindAliasIndexByName(entry);
        if (aliasIndex != -1) {
            const char *src = TEXTDISP_AliasPtrTable[aliasIndex]->aliasText;
            do {
                *out++ = *src;
            } while (*src++ != 0);
            return;
        }

        {
            const char *fallback = entryView->fallbackName;
            const char *scan = fallback;
            LONG len = 0;

            while (*scan++ != 0) {
                ++len;
            }

            if (len < 8 && len != 0) {
                STRING_AppendAtNull(out, TEXTDISP_CenterAlignToken);
                STRING_AppendAtNull(out, fallback);
            }
        }
    }
}
