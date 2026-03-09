typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Entry {
    UBYTE pad0[1];
    UBYTE shortText[18];
    UBYTE primaryText[1];
    UBYTE pad1[8];
    UBYTE flags27;
} NEWGRID_Entry;

extern UBYTE *NEWGRID2_JMPTBL_STR_SkipClass3Chars(UBYTE *s);

LONG NEWGRID_ShouldOpenEditor(UBYTE *entry)
{
    NEWGRID_Entry *entryView;
    UBYTE *primaryScan;
    UBYTE *secondaryScan;

    if (entry == (UBYTE *)0) {
        return 0;
    }

    entryView = (NEWGRID_Entry *)entry;
    primaryScan = NEWGRID2_JMPTBL_STR_SkipClass3Chars(entryView->primaryText);
    secondaryScan = NEWGRID2_JMPTBL_STR_SkipClass3Chars(entryView->shortText);

    if (primaryScan != (UBYTE *)0 && *primaryScan != 0) {
        return 0;
    }

    if (secondaryScan != (UBYTE *)0 && *secondaryScan != 0) {
        return 0;
    }

    if ((entryView->flags27 & 0x20) == 0) {
        return 0;
    }

    return 1;
}
