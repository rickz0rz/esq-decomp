typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct TEXTDISP_AuxData {
    UBYTE pad0[56];
    UBYTE *titleTable[49];
} TEXTDISP_AuxData;

typedef struct TEXTDISP_SelectionEntry {
    UBYTE shortName[10];
    UBYTE longName[200];
    LONG mode;
    LONG groupIndex;
    UWORD selectionIndex;
    UBYTE detailLine[524];
} TEXTDISP_SelectionEntry;

enum {
    TEXTDISP_NULL = 0,
    ENTRY_PROGRAM_TEXT_START_OFFSET = 1,
    MODE_BLOCKED = 3,
    INVALID_INDEX = -1,
    CLASS_SKIP_MASK = 8,
    CONTROL_TOKEN_A = 24,
    CONTROL_TOKEN_B = 25,
    CHAR_LPAREN = 40,
    ASCII_SPACE = ' ',
    TMP_BUFFER_LEN = 524,
    DETAIL_TRIM_PIXEL_WIDTH = 284
};

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
    TEXTDISP_AuxData *auxData;
    LONG i;
    LONG out;
    LONG mode;
    LONG groupIndex;
    LONG entryIndex;
    LONG titleLen;
    LONG longLen;
    char tmp[TMP_BUFFER_LEN];

    entry = (UBYTE *)entryPtr;
    if (entry == (UBYTE *)TEXTDISP_NULL) {
        return;
    }

    mode = ((TEXTDISP_SelectionEntry *)entry)->mode;
    groupIndex = ((TEXTDISP_SelectionEntry *)entry)->groupIndex;
    entryIndex = (LONG)(UWORD)((TEXTDISP_SelectionEntry *)entry)->selectionIndex;

    if (mode == MODE_BLOCKED || groupIndex == INVALID_INDEX || entryIndex == INVALID_INDEX) {
        TEXTDISP_ResetSelectionState(entry);
        return;
    }

    aux = TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(groupIndex, mode);
    program = (UBYTE *)TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(groupIndex, mode);
    detail = ((TEXTDISP_SelectionEntry *)entry)->detailLine;
    detail[TEXTDISP_NULL] = TEXTDISP_NULL;

    TEXTDISP_BuildEntryShortName(program, tmp);

    segment = (UBYTE *)tmp;
    while (segment[TEXTDISP_NULL] != TEXTDISP_NULL) {
        UBYTE cls = WDISP_CharClassTable[segment[TEXTDISP_NULL]];
        if ((cls & CLASS_SKIP_MASK) == TEXTDISP_NULL &&
            segment[TEXTDISP_NULL] != CONTROL_TOKEN_A &&
            segment[TEXTDISP_NULL] != CONTROL_TOKEN_B) {
            break;
        }
        segment++;
    }
    if (segment[TEXTDISP_NULL] != TEXTDISP_NULL) {
        STRING_AppendAtNull((char *)detail, SCRIPT_AlignedPrefixEmptyF);
        STRING_AppendAtNull((char *)detail, (const char *)segment);
    }

    if (aux != (void *)TEXTDISP_NULL && entryIndex >= TEXTDISP_NULL) {
        auxData = (TEXTDISP_AuxData *)aux;
        segment = TEXTDISP_SkipControlCodes(auxData->titleTable[entryIndex]);
    } else {
        segment = (UBYTE *)TEXTDISP_NULL;
    }

    if (segment != (UBYTE *)TEXTDISP_NULL && segment[TEXTDISP_NULL] != TEXTDISP_NULL) {
        titleLen = TEXTDISP_NULL;
        while (segment[titleLen] != TEXTDISP_NULL) {
            titleLen++;
        }

        longLen = TEXTDISP_NULL;
        while (((TEXTDISP_SelectionEntry *)entry)->longName[longLen] != TEXTDISP_NULL) {
            longLen++;
        }

        if (titleLen >= longLen) {
            segment += longLen;
        }

        while (segment[TEXTDISP_NULL] != TEXTDISP_NULL &&
               (WDISP_CharClassTable[segment[TEXTDISP_NULL]] & CLASS_SKIP_MASK) != TEXTDISP_NULL) {
            segment++;
        }

        WDISP_SPrintf(tmp, SCRIPT_AlignedStringFormat, (const char *)segment);

        hit = (UBYTE *)TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(tmp, SCRIPT_StrAtSeparator);
        if (hit == (UBYTE *)TEXTDISP_NULL) {
            hit = (UBYTE *)TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(tmp, SCRIPT_StrVsDotSeparator);
        }
        if (hit == (UBYTE *)TEXTDISP_NULL) {
            hit = (UBYTE *)TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(tmp, SCRIPT_StrVsSeparator);
        }

        if (hit != (UBYTE *)TEXTDISP_NULL) {
            hit[TEXTDISP_NULL] = CONTROL_TOKEN_A;
            while (hit[TEXTDISP_NULL] != TEXTDISP_NULL &&
                   (WDISP_CharClassTable[hit[TEXTDISP_NULL]] & CLASS_SKIP_MASK) == TEXTDISP_NULL) {
                hit++;
            }
            hit[TEXTDISP_NULL] = CONTROL_TOKEN_A;
        }

        hit = (UBYTE *)STR_FindCharPtr(tmp, CHAR_LPAREN);
        if (hit != (UBYTE *)TEXTDISP_NULL) {
            hit[TEXTDISP_NULL] = TEXTDISP_NULL;
        }

        STRING_AppendAtNull((char *)detail, tmp);
    }

    TEXTDISP_FormatEntryTimeForIndex(tmp, entryIndex, aux);
    segment = (UBYTE *)tmp;
    while (segment[TEXTDISP_NULL] != TEXTDISP_NULL &&
           (WDISP_CharClassTable[segment[TEXTDISP_NULL]] & CLASS_SKIP_MASK) != TEXTDISP_NULL) {
        segment++;
    }

    if (segment[TEXTDISP_NULL] != TEXTDISP_NULL) {
        STRING_AppendAtNull((char *)detail, SCRIPT_AlignedPrefixEmptyG);
        STRING_AppendAtNull((char *)detail, (const char *)segment);
    }

    out = TEXTDISP_NULL;
    for (i = TEXTDISP_NULL;
         program != (UBYTE *)TEXTDISP_NULL &&
         program[i + ENTRY_PROGRAM_TEXT_START_OFFSET] != TEXTDISP_NULL;
         i++) {
        if (program[i + ENTRY_PROGRAM_TEXT_START_OFFSET] != ASCII_SPACE) {
            tmp[out++] = (char)program[i + ENTRY_PROGRAM_TEXT_START_OFFSET];
        }
    }
    tmp[out] = TEXTDISP_NULL;

    if (tmp[TEXTDISP_NULL] != TEXTDISP_NULL) {
        STRING_AppendAtNull((char *)detail, Global_STR_ALIGNED_CHANNEL_2);
        STRING_AppendAtNull((char *)detail, tmp);
    }

    TEXTDISP_TrimTextToPixelWidth((char *)detail, DETAIL_TRIM_PIXEL_WIDTH);
}
