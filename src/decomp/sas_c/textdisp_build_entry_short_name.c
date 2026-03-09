typedef signed long LONG;

extern void *TEXTDISP_AliasPtrTable[];
extern char TEXTDISP_CenterAlignToken[];

extern LONG TEXTDISP_FindAliasIndexByName(const char *name);
extern char *STRING_AppendAtNull(char *dst, const char *src);

void TEXTDISP_BuildEntryShortName(char *entry, char *out)
{
    out[0] = 0;
    if (entry != (char *)0) {
        LONG aliasIndex;

        aliasIndex = TEXTDISP_FindAliasIndexByName(entry);
        if (aliasIndex != -1) {
            char *src = *(char **)((char *)TEXTDISP_AliasPtrTable + (aliasIndex << 2));
            src = *(char **)(src + 4);
            do {
                *out++ = *src;
            } while (*src++ != 0);
            return;
        }

        {
            char *fallback = entry + 19;
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
