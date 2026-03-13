typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Entry {
    UBYTE pad0[1];
    UBYTE shortText[18];
    UBYTE primaryText[8];
    UBYTE flags27;
} NEWGRID_Entry;

extern char *STR_SkipClass3Chars(const char *s);

LONG NEWGRID_ShouldOpenEditor(const char *entry)
{
    const NEWGRID_Entry *entryView;
    const char *primaryScan;
    const char *secondaryScan;
    LONG shouldOpen;

    shouldOpen = 0;
    entryView = (const NEWGRID_Entry *)entry;
    if (entryView != 0) {
        primaryScan = STR_SkipClass3Chars(entryView->primaryText);
        secondaryScan = STR_SkipClass3Chars(entryView->shortText);

        if ((primaryScan == 0 || *primaryScan == 0) &&
            (secondaryScan == 0 || *secondaryScan == 0) &&
            (entryView->flags27 & 0x20) != 0) {
            shouldOpen = 1;
        }
    }

    return shouldOpen;
}
