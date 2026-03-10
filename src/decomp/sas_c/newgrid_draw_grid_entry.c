typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Entry {
    UBYTE pad0[27];
    UBYTE flags27;
} NEWGRID_Entry;

typedef struct NEWGRID_AuxBase {
    UBYTE pad0[56];
    char *titleTable[49];
} NEWGRID_AuxBase;

typedef struct CoiSet {
    NEWGRID_AuxBase *ptr;
    UBYTE *rows;
    UBYTE timeFmtByte498;
} CoiSet;

extern UWORD Global_WORD_SELECT_CODE_IS_RAVESC;
extern char *NEWGRID_EntryTextScratchPtr;
extern const char NEWGRID_GridEntryDelimiterBar[];
extern const char NEWGRID_EntrySplitDelimiterMask[];
extern const char *SCRIPT_PtrNoDataPlaceholder;

extern char *PARSEINI_JMPTBL_STRING_AppendAtNull(char *dst, const char *src);
extern char *PARSEINI_JMPTBL_STR_FindCharPtr(const char *s, LONG ch);
extern char *PARSEINI_JMPTBL_STR_FindAnyCharPtr(const char *s, const char *set);
extern LONG NEWGRID_Apply24HourFormatting(char *dst, LONG row, LONG mode);
extern LONG NEWGRID2_JMPTBL_COI_RenderClockFormatEntryVariant(char *ctx, char *coi, LONG row, char *text, LONG fmt);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(char *layout, const char *src);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines(char *layout, const char *src);
extern char *NEWGRID2_JMPTBL_STR_SkipClass3Chars(const char *s);

static char *advance_until_space(char *p)
{
    if (!p) return 0;
    while (*p != 0 && *p != ' ') p++;
    return p;
}

void NEWGRID_DrawGridEntry(char *layout, char *rowMeta, CoiSet *coi, UWORD row, UWORD textLines, LONG renderMode, LONG clockFmt)
{
    NEWGRID_Entry *entry;
    char splitMask[4];
    char *timeText;
    char *split;
    char *tail;
    char *subtitle;

    entry = (NEWGRID_Entry *)rowMeta;
    splitMask[0] = NEWGRID_GridEntryDelimiterBar[0];
    splitMask[1] = NEWGRID_GridEntryDelimiterBar[1];
    splitMask[2] = NEWGRID_GridEntryDelimiterBar[2];
    splitMask[3] = 0;

    if (!rowMeta || !coi || row <= 0 || row >= 49 || !coi->ptr) {
        NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(layout, SCRIPT_PtrNoDataPlaceholder);
        return;
    }

    timeText = coi->ptr->titleTable[(LONG)row];
    if (!timeText || !*timeText) {
        NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(layout, SCRIPT_PtrNoDataPlaceholder);
        return;
    }

    if ((clockFmt == 3 || clockFmt == -1) && timeText[0] == '(' && timeText[3] == ':') {
        timeText += 8;
    }

    {
        char *dst = NEWGRID_EntryTextScratchPtr;
        const char *src = timeText;
        while ((*dst++ = *src++) != 0) {}
    }

    NEWGRID_Apply24HourFormatting(NEWGRID_EntryTextScratchPtr, row, coi->timeFmtByte498);

    if ((((UBYTE *)coi)[7 + row] & 0x02) == 0 && ((entry->flags27 & 0x10) == 0)) {
        NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(layout, NEWGRID_EntryTextScratchPtr);
        return;
    }

    if (renderMode && textLines == 3) {
        NEWGRID2_JMPTBL_COI_RenderClockFormatEntryVariant(rowMeta, (char *)coi, row, NEWGRID_EntryTextScratchPtr, clockFmt);
        NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(layout, NEWGRID_EntryTextScratchPtr);
        return;
    }

    split = PARSEINI_JMPTBL_STR_FindCharPtr(NEWGRID_EntryTextScratchPtr, 34);
    if (split) {
        split = PARSEINI_JMPTBL_STR_FindCharPtr(split + 1, 34);
    }
    if (split) {
        tail = PARSEINI_JMPTBL_STR_FindAnyCharPtr(split, NEWGRID_EntrySplitDelimiterMask);
        if (tail) split = tail;
        split = advance_until_space(split);
        if (*split) {
            *split++ = 0;
        } else {
            split = 0;
        }
    }

    NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(layout, NEWGRID_EntryTextScratchPtr);

    if (renderMode && split && textLines > 1) {
        char *p = PARSEINI_JMPTBL_STR_FindCharPtr(split, 40);
        if (p && p[5] == ')') {
            split = p + 6;
        }

        split = advance_until_space(split);
        if (*split) {
            *split++ = 0;
            if (NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines(layout, p) != 0) {
                NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(layout, p);
            }
        }

        if (split) {
            subtitle = NEWGRID2_JMPTBL_STR_SkipClass3Chars(split);
            if (subtitle) {
                char *d1 = PARSEINI_JMPTBL_STR_FindCharPtr(subtitle, 44);
                char *d2;
                char *fallback = 0;
                if (d1) {
                    d2 = PARSEINI_JMPTBL_STR_FindCharPtr(d1, 46);
                    if (d2) {
                        split = d2;
                    } else {
                        split = d1;
                        fallback = d1;
                        *split = '.';
                    }
                } else {
                    d2 = PARSEINI_JMPTBL_STR_FindCharPtr(subtitle, 46);
                    split = d2;
                    if (!d2) subtitle = 0;
                }

                if (subtitle) {
                    split = advance_until_space(split);
                    if (*split) {
                        *split++ = 0;
                    } else {
                        split = 0;
                    }

                    if (NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines(layout, subtitle) != 0) {
                        NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(layout, subtitle);
                    } else if (fallback) {
                        fallback[0] = '.';
                        fallback[1] = 0;
                        fallback += 2;
                        fallback = NEWGRID2_JMPTBL_STR_SkipClass3Chars(fallback);
                        if (NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines(layout, subtitle) != 0) {
                            NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(layout, subtitle);
                        } else if (NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines(layout, fallback) != 0) {
                            NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(layout, fallback);
                        }
                    }
                }
            }
        }
    }

    if (split) {
        char *delim = PARSEINI_JMPTBL_STR_FindAnyCharPtr(split, splitMask);
        char *next = 0;
        if (delim) {
            next = PARSEINI_JMPTBL_STR_FindAnyCharPtr(delim + 1, splitMask);
            while (next) {
                split = next + 1;
                next = PARSEINI_JMPTBL_STR_FindAnyCharPtr(split, splitMask);
            }
            *split = 0;
            NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(layout, delim);
        }
    }

    if (clockFmt == -1 && renderMode && textLines > 1) {
        NEWGRID_EntryTextScratchPtr[0] = 0;
        NEWGRID2_JMPTBL_COI_RenderClockFormatEntryVariant(rowMeta, (char *)coi, row, NEWGRID_EntryTextScratchPtr, -1);
        NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(layout, NEWGRID_EntryTextScratchPtr);
    }
}
