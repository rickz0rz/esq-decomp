typedef signed long LONG;

typedef struct TEXTDISP_AliasEntry {
    LONG pad0;
    char *aliasText;
} TEXTDISP_AliasEntry;

typedef struct TEXTDISP_Entry {
    char shortName[19];
    char fallbackName[1];
} TEXTDISP_Entry;

extern TEXTDISP_AliasEntry *TEXTDISP_AliasPtrTable[];
extern const char TEXTDISP_CenterAlignToken[];

extern LONG TEXTDISP_FindAliasIndexByName(const char *name);
extern char *STRING_AppendAtNull(char *dst, const char *src);

void TEXTDISP_BuildEntryShortName(char *entry, char *out)
{
    out[0] = 0;
    if (entry != (char *)0) {
        TEXTDISP_Entry *entryView;
        LONG aliasIndex;

        entryView = (TEXTDISP_Entry *)entry;
        aliasIndex = TEXTDISP_FindAliasIndexByName(entry);
        if (aliasIndex != -1) {
            char *src = TEXTDISP_AliasPtrTable[aliasIndex]->aliasText;
            do {
                *out++ = *src;
            } while (*src++ != 0);
            return;
        }

        {
            char *fallback = entryView->fallbackName;
            LONG len = 0;

            while (fallback[len] != 0) {
                ++len;
            }

            if (len < 8 && len != 0) {
                STRING_AppendAtNull(out, TEXTDISP_CenterAlignToken);
                STRING_AppendAtNull(out, fallback);
            }
        }
    }
}
