typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UBYTE WDISP_CharClassTable[];
extern const char SCRIPT_AlignedPrefixEmptyF[];
extern const char SCRIPT_AlignedPrefixEmptyG[];
extern const char SCRIPT_AlignedStringFormat[];
extern const char SCRIPT_StrAtSeparator[];
extern const char SCRIPT_StrVsDotSeparator[];
extern const char SCRIPT_StrVsSeparator[];
extern const char Global_STR_ALIGNED_CHANNEL_2[];

extern void *TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern void *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern void TEXTDISP_ResetSelectionState(void *entry);
extern void TEXTDISP_BuildEntryShortName(void *entry, char *dst);
extern UBYTE *TEXTDISP_SkipControlCodes(UBYTE *text);
extern void STRING_AppendAtNull(char *dst, const char *src);
extern void WDISP_SPrintf(char *dst, const char *fmt, const char *arg);
extern char *TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(const char *haystack, const char *needle);
extern char *STR_FindCharPtr(char *s, LONG ch);
extern void TEXTDISP_FormatEntryTimeForIndex(char *dst, LONG index, void *aux);
extern void TEXTDISP_TrimTextToPixelWidth(char *text, LONG px);

void TEXTDISP_BuildEntryDetailLine(void *entryPtr)
{
    UBYTE *entry;
    void *aux;
    UBYTE *program;
    UBYTE *detail;
    UBYTE *segment;
    UBYTE *hit;
    ULONG *titleTable;
    LONG i;
    LONG out;
    LONG mode;
    LONG groupIndex;
    LONG entryIndex;
    LONG titleLen;
    LONG longLen;
    char tmp[524];

    entry = (UBYTE *)entryPtr;
    if (entry == (UBYTE *)0) {
        return;
    }

    mode = *(LONG *)(entry + 210);
    groupIndex = *(LONG *)(entry + 214);
    entryIndex = (LONG)(*(short *)(entry + 218));

    if (mode == 3 || groupIndex == -1 || entryIndex == -1) {
        TEXTDISP_ResetSelectionState(entry);
        return;
    }

    aux = TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(groupIndex, mode);
    program = (UBYTE *)TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(groupIndex, mode);
    detail = entry + 220;
    detail[0] = 0;

    TEXTDISP_BuildEntryShortName(program, tmp);

    segment = (UBYTE *)tmp;
    while (segment[0] != 0) {
        UBYTE cls = WDISP_CharClassTable[segment[0]];
        if ((cls & 8) == 0 && segment[0] != 24 && segment[0] != 25) {
            break;
        }
        segment++;
    }
    if (segment[0] != 0) {
        STRING_AppendAtNull((char *)detail, SCRIPT_AlignedPrefixEmptyF);
        STRING_AppendAtNull((char *)detail, (const char *)segment);
    }

    if (aux != (void *)0 && entryIndex >= 0) {
        titleTable = (ULONG *)((UBYTE *)aux + 56);
        segment = TEXTDISP_SkipControlCodes((UBYTE *)titleTable[entryIndex]);
    } else {
        segment = (UBYTE *)0;
    }

    if (segment != (UBYTE *)0 && segment[0] != 0) {
        titleLen = 0;
        while (segment[titleLen] != 0) {
            titleLen++;
        }

        longLen = 0;
        while (entry[10 + longLen] != 0) {
            longLen++;
        }

        if (titleLen >= longLen) {
            segment += longLen;
        }

        while (segment[0] != 0 && (WDISP_CharClassTable[segment[0]] & 8) != 0) {
            segment++;
        }

        WDISP_SPrintf(tmp, SCRIPT_AlignedStringFormat, (const char *)segment);

        hit = (UBYTE *)TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(tmp, SCRIPT_StrAtSeparator);
        if (hit == (UBYTE *)0) {
            hit = (UBYTE *)TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(tmp, SCRIPT_StrVsDotSeparator);
        }
        if (hit == (UBYTE *)0) {
            hit = (UBYTE *)TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(tmp, SCRIPT_StrVsSeparator);
        }

        if (hit != (UBYTE *)0) {
            hit[0] = 24;
            while (hit[0] != 0 && (WDISP_CharClassTable[hit[0]] & 8) == 0) {
                hit++;
            }
            hit[0] = 24;
        }

        hit = (UBYTE *)STR_FindCharPtr(tmp, 40);
        if (hit != (UBYTE *)0) {
            hit[0] = 0;
        }

        STRING_AppendAtNull((char *)detail, tmp);
    }

    TEXTDISP_FormatEntryTimeForIndex(tmp, entryIndex, aux);
    segment = (UBYTE *)tmp;
    while (segment[0] != 0 && (WDISP_CharClassTable[segment[0]] & 8) != 0) {
        segment++;
    }

    if (segment[0] != 0) {
        STRING_AppendAtNull((char *)detail, SCRIPT_AlignedPrefixEmptyG);
        STRING_AppendAtNull((char *)detail, (const char *)segment);
    }

    out = 0;
    for (i = 0; program != (UBYTE *)0 && program[i + 1] != 0; i++) {
        if (program[i + 1] != ' ') {
            tmp[out++] = (char)program[i + 1];
        }
    }
    tmp[out] = 0;

    if (tmp[0] != 0) {
        STRING_AppendAtNull((char *)detail, Global_STR_ALIGNED_CHANNEL_2);
        STRING_AppendAtNull((char *)detail, tmp);
    }

    TEXTDISP_TrimTextToPixelWidth((char *)detail, 284);
}
