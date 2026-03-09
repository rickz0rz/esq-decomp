typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct TEXTDISP_EntryTextFields {
    char shortName[10];
    char longName[200];
} TEXTDISP_EntryTextFields;

extern UBYTE CONFIG_LRBN_FlagChar;
extern UWORD TEXTDISP_LrbnEntryWidthPx;
extern UWORD CONFIG_BannerCopperHeadByte;
extern LONG TEXTDISP_EntryTextBaseWidthPx;

extern void STRING_CopyPadNul(char *dst, const char *src, LONG n);

void TEXTDISP_SetEntryTextFields(TEXTDISP_EntryTextFields *entry, const char *shortText, const char *longText)
{
    if (CONFIG_LRBN_FlagChar == 'Y') {
        TEXTDISP_EntryTextBaseWidthPx = (LONG)TEXTDISP_LrbnEntryWidthPx;
    } else {
        TEXTDISP_EntryTextBaseWidthPx = (LONG)CONFIG_BannerCopperHeadByte;
    }

    if (entry == (TEXTDISP_EntryTextFields *)0) {
        return;
    }

    if (shortText != (const char *)0) {
        STRING_CopyPadNul(entry->shortName, shortText, 9);
        entry->shortName[9] = 0;
    } else {
        entry->shortName[0] = 0;
    }

    if (shortText != (const char *)0) {
        STRING_CopyPadNul(entry->longName, longText, 199);
        entry->longName[199] = 0;
    } else {
        entry->longName[0] = 0;
    }
}
