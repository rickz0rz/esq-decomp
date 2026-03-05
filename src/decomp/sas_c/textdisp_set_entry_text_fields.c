typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct TEXTDISP_EntryTextFields {
    UBYTE shortName[10];
    UBYTE longName[200];
} TEXTDISP_EntryTextFields;

extern UBYTE CONFIG_LRBN_FlagChar;
extern UWORD TEXTDISP_LrbnEntryWidthPx;
extern UWORD CONFIG_BannerCopperHeadByte;
extern LONG TEXTDISP_EntryTextBaseWidthPx;

extern void STRING_CopyPadNul(char *dst, const char *src, LONG n);

void TEXTDISP_SetEntryTextFields(TEXTDISP_EntryTextFields *entry, const UBYTE *shortText, const UBYTE *longText)
{
    if (CONFIG_LRBN_FlagChar == 'Y') {
        TEXTDISP_EntryTextBaseWidthPx = (LONG)TEXTDISP_LrbnEntryWidthPx;
    } else {
        TEXTDISP_EntryTextBaseWidthPx = (LONG)CONFIG_BannerCopperHeadByte;
    }

    if (entry == (TEXTDISP_EntryTextFields *)0) {
        return;
    }

    if (shortText != (const UBYTE *)0) {
        STRING_CopyPadNul((char *)entry->shortName, (const char *)shortText, 9);
        entry->shortName[9] = 0;
    } else {
        entry->shortName[0] = 0;
    }

    if (shortText != (const UBYTE *)0) {
        STRING_CopyPadNul((char *)entry->longName, (const char *)longText, 199);
        entry->longName[199] = 0;
    } else {
        entry->longName[0] = 0;
    }
}
