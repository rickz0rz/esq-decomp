typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE *NEWGRID2_JMPTBL_STR_SkipClass3Chars(UBYTE *s);

LONG NEWGRID_ShouldOpenEditor(UBYTE *entry)
{
    UBYTE *primaryScan;
    UBYTE *secondaryScan;

    if (entry == (UBYTE *)0) {
        return 0;
    }

    primaryScan = NEWGRID2_JMPTBL_STR_SkipClass3Chars(entry + 19);
    secondaryScan = NEWGRID2_JMPTBL_STR_SkipClass3Chars(entry + 1);

    if (primaryScan != (UBYTE *)0 && *primaryScan != 0) {
        return 0;
    }

    if (secondaryScan != (UBYTE *)0 && *secondaryScan != 0) {
        return 0;
    }

    if ((entry[27] & 0x20) == 0) {
        return 0;
    }

    return 1;
}
