typedef signed long LONG;
typedef unsigned char UBYTE;

extern char *TEXTDISP_SecondaryTitlePtrTable[];

extern char *TLIBA2_FindLastCharInString(char *str, LONG targetChar);
extern LONG PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern LONG TLIBA2_JMPTBL_ESQ_TestBit1Based(UBYTE *bitsetBase, LONG bitIndex);
extern LONG TLIBA_FindFirstWildcardMatchIndex(char *pattern);
extern LONG MATH_DivS32(LONG num, LONG den);
extern LONG MATH_Mulu32(LONG a, LONG b);

LONG TLIBA2_ResolveEntryWindowAndSlotCount(void *entryContext, void *entryState, LONG entryIndex, LONG *outRange, LONG flags, LONG *outSlotCount, LONG *outStart, LONG *outEnd, LONG wildcardMode)
{
    char *title;
    char *pOpen;
    char *pColon;
    char *pClose;
    LONG count;
    LONG i;
    LONG wildcardIndex;

    (void)entryState;

    title = TEXTDISP_SecondaryTitlePtrTable[entryIndex];
    pOpen = TLIBA2_FindLastCharInString(title, 34);
    pColon = (pOpen != (char *)0) ? TLIBA2_FindLastCharInString(pOpen, 40) : (char *)0;
    pClose = (pColon != (char *)0) ? TLIBA2_FindLastCharInString(pColon, 41) : (char *)0;

    if (pOpen != (char *)0 && pColon != (char *)0 && pClose != (char *)0 && (flags & 1) != 0) {
        outRange[0] = PARSE_ReadSignedLongSkipClass3_Alt(pOpen + 1);
        outRange[1] = PARSE_ReadSignedLongSkipClass3_Alt(pColon + 1);
        if (outStart != (LONG *)0) {
            *outStart = outRange[0];
        }
        if (outEnd != (LONG *)0) {
            *outEnd = outRange[1];
        }
        return 0;
    }

    count = 0;
    for (i = entryIndex; i < 49; ++i) {
        if (TLIBA2_JMPTBL_ESQ_TestBit1Based((char *)entryContext + 28, i) != 0) {
            ++count;
        }
    }

    if (wildcardMode != 0) {
        wildcardIndex = TLIBA_FindFirstWildcardMatchIndex("*");
        if (wildcardIndex >= 0) {
            count = wildcardIndex;
        }
    }

    if (count > 0) {
        outRange[0] = MATH_DivS32(count, 2);
        outRange[1] = MATH_Mulu32(outRange[0], 2);
    } else {
        outRange[0] = 0;
        outRange[1] = 0;
    }

    if (outSlotCount != (LONG *)0) {
        *outSlotCount = count;
    }
    if (outStart != (LONG *)0) {
        *outStart = outRange[0];
    }
    if (outEnd != (LONG *)0) {
        *outEnd = outRange[1];
    }

    return count;
}
