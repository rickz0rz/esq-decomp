/* RESTORES: NEWGRID_DrawGridEntry
 * MODULE:   modules/groups/b/a/newgrid1b_p0.s
 * STATUS:   behavioural
 *
 * Turns one listing entry into the lines the grid draws. The entry text is
 * copied to a scratch buffer, reformatted for 12- or 24-hour clocks, then cut
 * into a title, an optional year in parentheses, an optional subtitle, and an
 * optional bar-delimited tail. Each piece is appended through
 * DISPTEXT_LayoutAndAppendToBuffer.
 *
 * Six tests send the entry to the "no data" placeholder: no entry record, no
 * aux record, a selector outside 1..48, a null text pointer, and an empty text.
 *
 * NOTE the aux record is dereferenced to fetch the text pointer BEFORE it is
 * tested for NULL. That is the original's order and this file keeps it. A null
 * aux therefore reads address 56 + selector*4 in both.
 *
 * A leading "(hh:" time stamp is skipped, but only for variant 3 and variant
 * -1. The test is on the two characters '(' and ':' at fixed offsets, not on a
 * parse.
 *
 * The cutting idiom repeats four times: walk to the next space, write a NUL
 * there and step past it, or give up and set the cursor to NULL when the string
 * ends first. A NULL cursor is what stops each following stage.
 *
 * The subtitle stage has a fallback. If the piece up to the first '.' does not
 * lay out, and a ',' was found earlier, the ',' becomes a '.' and a terminator,
 * and the text after it is retried instead.
 *
 * Variant -1 appends one more clock-format line at the very end, with the
 * scratch buffer emptied first so the renderer writes into a clean buffer.
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55ffec                   LINK.W A5,#-20
 *   got:     9efc0020                   SUBA.W #32,A7
 *   summary: 1000 bytes in the original against 996 emitted, 4 SHORT over 39
 *            regions. The frame class plus 4EBA against 6100 on the calls. Four
 *            bytes over a thousand is the closest large result in this tranche
 *            and it means the control flow above is the original's, not a
 *            rearrangement of it. Not itemised further -- see AGENTS.md rule 3.
 *   scope:   program-wide.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include "esq-graphics.h"
#include <string.h>

struct GridEntry {
    char          pad0[27];
    unsigned char flags27;          /* 27 */
};

struct GridAux {
    char           pad0[7];
    unsigned char  flags[49];       /* 7 */
    char          *slots[110];      /* 56 */
    char           pad1[2];
    unsigned char  fmtCode;         /* 498 */
};

extern void  NEWGRID_Apply24HourFormatting(char *text, long sel, long fmt);
extern void  COI_RenderClockFormatEntryVariant(
                 struct GridEntry *e, struct GridAux *aux, long sel,
                 char *text, long variant);
extern void  DISPTEXT_LayoutAndAppendToBuffer(
                 struct RastPort *rp, char *text);
extern long  DISPTEXT_LayoutSourceToLines(struct RastPort *rp,
                                                          char *text);
extern char *STR_SkipClass3Chars(char *s);
extern char *STR_FindCharPtr(char *s, long c);
extern char *STR_FindAnyCharPtr(char *s, char *set);

extern char  NEWGRID_GridEntryDelimiterBar[];
extern char  NEWGRID_EntrySplitDelimiterMask[];
extern char *NEWGRID_EntryTextScratchPtr;
extern char *SCRIPT_PtrNoDataPlaceholder;

void NEWGRID_DrawGridEntry(struct RastPort *rp, struct GridEntry *entry,
                           struct GridAux *aux, short sel, short mode,
                           long flag, long variant)
{
    char bar[3];
    char *src, *cut, *mark, *body, *comma, *tail;
    long skip;

    memcpy(bar, NEWGRID_GridEntryDelimiterBar, 3);
    src = aux->slots[sel];

    if (entry == 0 || aux == 0 || sel <= 0 || sel >= 49 || src == 0 ||
        *src == 0) {
        DISPTEXT_LayoutAndAppendToBuffer(rp,
                                              SCRIPT_PtrNoDataPlaceholder);
        return;
    }

    if (variant == 3 || variant == -1) {
        if (src[0] == 40 && src[3] == 58)
            skip = 8;
        else
            skip = 0;
    } else {
        skip = 0;
    }
    src += skip;

    strcpy(NEWGRID_EntryTextScratchPtr, src);
    NEWGRID_Apply24HourFormatting(NEWGRID_EntryTextScratchPtr, (long)sel,
                                  (long)aux->fmtCode);

    if ((aux->flags[sel] & 2) == 0 && (entry->flags27 & 0x10) == 0) {
        DISPTEXT_LayoutAndAppendToBuffer(rp,
                                              NEWGRID_EntryTextScratchPtr);
        return;
    }

    if (flag != 0 && mode == 3) {
        COI_RenderClockFormatEntryVariant(entry, aux,
            (long)sel, NEWGRID_EntryTextScratchPtr, variant);
        DISPTEXT_LayoutAndAppendToBuffer(rp,
                                              NEWGRID_EntryTextScratchPtr);
        return;
    }

    cut = STR_FindCharPtr(NEWGRID_EntryTextScratchPtr, 34L);
    if (cut != 0) {
        cut++;
        cut = STR_FindCharPtr(cut, 34L);
    }
    if (cut != 0) {
        mark = STR_FindAnyCharPtr(cut,
                                        NEWGRID_EntrySplitDelimiterMask);
        if (mark != 0)
            cut = mark;
        while (*cut != 0 && *cut != 32)
            cut++;
        if (*cut != 0) {
            *cut = 0;
            cut++;
        } else {
            cut = 0;
        }
    }

    DISPTEXT_LayoutAndAppendToBuffer(rp,
                                          NEWGRID_EntryTextScratchPtr);

    if (flag != 0 && cut != 0 && mode > 1) {
        mark = STR_FindCharPtr(cut, 40L);
        if (mark != 0 && mark[5] == 41) {
            cut = mark + 6;
            while (*cut != 0 && *cut != 32)
                cut++;
            if (*cut != 0) {
                *cut = 0;
                cut++;
            } else {
                cut = 0;
            }
            if (DISPTEXT_LayoutSourceToLines(rp, mark) != 0)
                DISPTEXT_LayoutAndAppendToBuffer(rp, mark);
        }

        if (cut != 0) {
            body = STR_SkipClass3Chars(cut);
            if (body != 0) {
                comma = STR_FindCharPtr(body, 44L);
                if (comma != 0) {
                    cut = STR_FindCharPtr(comma, 46L);
                    if (cut == 0) {
                        cut = comma;
                        comma = 0;
                        *cut = 46;
                    }
                } else {
                    cut = STR_FindCharPtr(body, 46L);
                    if (cut == 0)
                        body = 0;
                }
            }

            if (body != 0) {
                while (*cut != 0 && *cut != 32)
                    cut++;
                if (*cut != 0) {
                    *cut = 0;
                    cut++;
                } else {
                    cut = 0;
                }

                if (DISPTEXT_LayoutSourceToLines(rp, body) != 0)
                    DISPTEXT_LayoutAndAppendToBuffer(rp, body);
                else if (comma != 0) {
                    comma[0] = 46;
                    comma[1] = 0;
                    tail = STR_SkipClass3Chars(comma + 2);
                    if (DISPTEXT_LayoutSourceToLines(rp, body)
                        != 0)
                        DISPTEXT_LayoutAndAppendToBuffer(rp,
                                                                        body);
                    else if (DISPTEXT_LayoutSourceToLines(rp,
                                 tail) != 0)
                        DISPTEXT_LayoutAndAppendToBuffer(rp,
                                                                        tail);
                }
            }
        }
    }

    if (cut != 0) {
        mark = STR_FindAnyCharPtr(cut, bar);
        if (mark != 0) {
            cut = mark + 1;
            tail = STR_FindAnyCharPtr(cut, bar);
            while (tail != 0) {
                cut = tail + 1;
                tail = STR_FindAnyCharPtr(cut, bar);
            }
            *cut = 0;
            DISPTEXT_LayoutAndAppendToBuffer(rp, mark);
        }
    }

    if (variant == -1 && flag != 0 && mode > 1) {
        NEWGRID_EntryTextScratchPtr[0] = 0;
        COI_RenderClockFormatEntryVariant(entry, aux,
            (long)sel, NEWGRID_EntryTextScratchPtr, variant);
        DISPTEXT_LayoutAndAppendToBuffer(rp,
                                              NEWGRID_EntryTextScratchPtr);
    }
}
