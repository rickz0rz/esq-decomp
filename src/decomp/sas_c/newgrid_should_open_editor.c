typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Entry {
    UBYTE pad0[1];
    UBYTE shortText[18];
    UBYTE primaryText[1];
    UBYTE pad1[8];
    UBYTE flags27;
} NEWGRID_Entry;

extern char *NEWGRID2_JMPTBL_STR_SkipClass3Chars(const char *s);

LONG NEWGRID_ShouldOpenEditor(const char *entry)
{
    const NEWGRID_Entry *entryView;
    const char *primaryScan;
    const char *secondaryScan;

    if (entry == (char *)0) {
        return 0;
    }

    entryView = (const NEWGRID_Entry *)entry;
    primaryScan = NEWGRID2_JMPTBL_STR_SkipClass3Chars(entryView->primaryText);
    secondaryScan = NEWGRID2_JMPTBL_STR_SkipClass3Chars(entryView->shortText);

    if (primaryScan != (char *)0 && *primaryScan != 0) {
        return 0;
    }

    if (secondaryScan != (char *)0 && *secondaryScan != 0) {
        return 0;
    }

    if ((entryView->flags27 & 0x20) == 0) {
        return 0;
    }

    return 1;
}
