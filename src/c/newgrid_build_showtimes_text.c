/* RESTORES: NEWGRID_BuildShowtimesText
 * MODULE:   modules/groups/b/a/newgrid1bb.s
 * STATUS:   behavioural
 *
 * Builds the "Showtimes: 7:00, 9:30, ..." line for a pay-per-view programme by
 * scanning the whole grid for OTHER slots showing the same thing, and stops
 * when the accumulated text would no longer fit.
 *
 * "THE SAME THING" MEANS FIVE FIELDS AGREE, not one. A candidate qualifies only
 * if its title and all four animation fields (1, 2, 6 and 7) match the
 * reference entry's. Each comparison has the same three-part shape: identical
 * POINTERS pass immediately, a null on either side fails, and otherwise the
 * strings are compared. Collapsing that to a plain strcmp crashes on the null
 * case, which is reachable whenever a programme has no rating or no genre.
 *
 * THE TITLE COMPARISON IS THE ODD ONE OUT. For the four fields, equal pointers
 * mean "matches, move on". For the title, equal pointers mean "this IS the
 * reference entry" and the candidate is REJECTED. The two tests look identical
 * in the disassembly and branch opposite ways.
 *
 * THE `(h:mm)` PREFIX IS SKIPPED BY OFFSET, NOT BY PARSING. If the slot text
 * begins with '(' and has ':' at index 3, eight bytes are skipped. That is done
 * for both the reference title and every candidate, and the constant 8 is not
 * derived from the match -- a title of the form `(x:yz)` shorter than 8 bytes
 * would skip past its own terminator.
 *
 * THE WIDTH BUDGET IS 612 PIXELS AND IT IS SPENT, NOT CHECKED. Every appended
 * fragment is measured with TextLength and subtracted. Once it goes negative
 * the loops stop -- but only for rows at or past the row limit, so a negative
 * budget does not end the scan on its own. Both loops carry that same
 * two-part condition.
 *
 * The genre field is charged against the budget UP FRONT, before any showtime
 * is added, because it is appended at the very end regardless. That is why the
 * subtraction happens before the reset call rather than with the other appends.
 *
 * THE BUCKET KEY IS BIASED BY 48 FOR THE SECOND HALF OF THE DAY. Rows above 48
 * add 48 to the entry index before storing, which is how the bucket sort keeps
 * a programme running past midnight in order. The first append -- the one that
 * writes the "Showtimes: " prefix -- uses the UNWRAPPED slot from the request
 * instead, which is why that value is kept in its own variable.
 *
 * A FAILED BUCKET APPEND SKIPS THE WIDTH CHARGE. When AddShowtimeBucketEntry
 * returns zero the code goes straight to the next column without subtracting,
 * so a full bucket table does not consume budget. When the budget was already
 * too small to try the append, the charge IS made -- the fall-through is
 * deliberate and is what eventually drives the budget negative and ends the
 * scan.
 *
 * THE OUTPUT BUFFER DOUBLES AS THE "have we started" FLAG. Its first byte is
 * cleared on entry and tested at three points; the closing block picks the
 * "Showing at" prefix over the bucket list purely on that test.
 *
 * 1530 ref vs 1604 got, 26 differing regions. All five guards, the slot wrap at
 * 48, both `(h:mm)` offset tests, all eight COI_SelectAnimFieldPointer calls,
 * both index clamps with their signed-and-upper form, the row span with its 97
 * cap, the two-part loop conditions, the preset lookup, the 0xa0 flag mask, the
 * TestBit1Based check, all five field comparisons with their pointer-equality
 * shortcuts, the BSET #5 mark, all seven TextLength measurements, both bucket
 * appends with their 48 bias and both closing prefixes match in kind and size.
 *
 * The 74 bytes are spread across the whole function at 2 to 8 bytes a site --
 * the frame class -- with one identifiable component, below.
 *
 * SASC-MISMATCH: volatile-a6-reload
 *   ref:     5 loads of the graphics base for 7 library calls
 *   got:     7 loads for 7 calls
 *   summary: the original caches A6 across two adjacent TextLength pairs. We
 *            reload every time, because esq-graphics.h declares the base
 *            volatile and this function calls ESQ assembly between measurements
 *            -- which is exactly the case the volatile header exists for. 12 of
 *            the 74 bytes, and they are the correct 12 to spend.
 *   tried:   NOT attempted, and must not be. esq-graphics-leaf.h is restricted
 *            to the `no-calls` bucket; this function calls
 *            COI_SelectAnimFieldPointer and STR_SkipClass3Chars between library
 *            calls, so a cached base is the A6 bug src/c/esq-libbase.md
 *            documents. tools/a6_audit.py would flag it.
 *   scope:   every restoration that mixes library and ESQ calls.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>
#include "esq-graphics.h"

struct NgShowCtx {
    char            pad0[60];
    struct RastPort rp;                 /* +60 */
};

struct NgShowEntry {
    char          pad0[28];
    char          bits[12];             /* +28 = 0x1c */
    unsigned char b40;                  /* +40 */
    char          pad41[5];
    short         w46;                  /* +46 */
    unsigned char b47pad;
};

struct NgShowAux {
    char          pad0[7];
    unsigned char flags[49];            /* +7  */
    char         *slots[50];            /* +56 */
};

struct NgShowReq {
    struct NgShowEntry *entry;          /* +0  */
    struct NgShowAux   *aux;            /* +4  */
    char   pad8[4];
    long   startIndex;                  /* +12 */
    long   endIndex;                    /* +16 */
    short  slot;                        /* +20 */
    short  rowStart;                    /* +22 */
    short  rowLimit;                    /* +24 */
};

extern char *COI_SelectAnimFieldPointer(void *entry, long idx,
                                                        long field);
extern void  TEXTDISP_FormatEntryTimeForIndex(char *buf, long idx, void *aux);
extern void  NEWGRID_ResetShowtimeBuckets(void);
extern short NEWGRID_UpdatePresetEntry(struct NgShowEntry **e,
                                       struct NgShowAux **a, long row,
                                       long col);
extern short DISPLIB_FindPreviousValidEntryIndex(void *e,
                                                                 void *a,
                                                                 long idx);
extern long  COI_ProcessEntrySelectionState(void *e, void *a,
                                                            long idx,
                                                            long window,
                                                            long tolerance);
extern long  ESQ_TestBit1Based(char *bits, long idx);
extern char *STR_SkipClass3Chars(char *s);
extern long  NEWGRID_AddShowtimeBucketEntry(char *text, long key);
extern void  NEWGRID_AppendShowtimeBuckets(char *out);
extern void  STRING_AppendAtNull(char *dst, char *src);

extern char  TEXTDISP_PrimaryGroupPresentFlag;
extern short TEXTDISP_PrimaryGroupEntryCount;
extern long  GCOMMAND_PpvShowtimesRowSpan;
extern long  GCOMMAND_PpvSelectionWindowMinutes;
extern long  GCOMMAND_PpvSelectionToleranceMinutes;
extern char  Global_STR_SINGLE_SPACE_3[];
extern char  Global_STR_COMMA_AND_SINGLE_SPACE_1[];
extern char  Global_STR_SHOWTIMES_AND_SINGLE_SPACE[];
extern char  Global_STR_SHOWING_AT_AND_SINGLE_SPACE[];
extern char  NEWGRID_ShowtimeGenreSpacer[];

void NEWGRID_BuildShowtimesText(struct NgShowCtx *ctx, struct NgShowReq *req,
                                char *out)
{
    struct NgShowEntry *entry2;
    struct NgShowAux   *aux2;
    char *titlePtr;
    char *field1;
    char *field2;
    char *field6;
    char *field7;
    char *title2;
    char *g1;
    char *g2;
    char *g6;
    char *g7;
    char *textPtr;
    char *s;
    char  timeBuf[21];
    long  widthLeft;
    long  commaWidth;
    long  col;
    long  need;
    long  w;
    long  off;
    long  n;
    long  k;
    short row;
    short rowEnd;
    short slot;
    short rawSlot;
    short idx;

    if (req->entry == 0)
        return;
    if (req->aux == 0)
        return;
    if (!(req->entry->w46 & 0x10))
        return;
    if (TEXTDISP_PrimaryGroupPresentFlag == 0)
        return;
    if (out == 0)
        return;

    *out = 0;

    slot = rawSlot = req->slot;
    if (slot > 48)
        slot -= 48;

    titlePtr = req->aux->slots[slot];

    if (titlePtr != 0 && *titlePtr != 0) {
        if (titlePtr[0] == 40 && titlePtr[3] == 58)
            off = 8;
        else
            off = 0;
        titlePtr += off;
    } else {
        titlePtr = 0;
    }

    field1 = COI_SelectAnimFieldPointer(req->entry,
                                                        (long)slot, 1L);
    field2 = COI_SelectAnimFieldPointer(req->entry,
                                                        (long)slot, 2L);
    field6 = COI_SelectAnimFieldPointer(req->entry,
                                                        (long)slot, 6L);
    field7 = COI_SelectAnimFieldPointer(req->entry,
                                                        (long)slot, 7L);

    TEXTDISP_FormatEntryTimeForIndex(timeBuf, (long)slot, req->aux);

    widthLeft = 612;

    if (field2 != 0 && *field2 != 0) {
        w = TextLength(&ctx->rp, field2, strlen(field2));
        w += TextLength(&ctx->rp, Global_STR_SINGLE_SPACE_3, 1L);
        widthLeft -= w;
    }

    commaWidth = TextLength(&ctx->rp, Global_STR_COMMA_AND_SINGLE_SPACE_1, 2L);

    if (titlePtr == 0)
        return;

    NEWGRID_ResetShowtimeBuckets();

    n = TEXTDISP_PrimaryGroupEntryCount;
    if (req->startIndex > n || req->startIndex < 0)
        req->startIndex = n;

    n = TEXTDISP_PrimaryGroupEntryCount;
    if (req->endIndex > n || req->endIndex < 0)
        req->endIndex = n;

    rowEnd = (short)((long)req->rowStart + GCOMMAND_PpvShowtimesRowSpan + 1);
    if (rowEnd > 97)
        rowEnd = 97;

    for (row = req->rowStart; row < rowEnd; row++) {

        if (widthLeft < 0 && row >= req->rowLimit)
            break;

        for (col = req->startIndex; col < req->endIndex; col++) {

            if (widthLeft < 0 && row >= req->rowLimit)
                break;

            idx = NEWGRID_UpdatePresetEntry(&entry2, &aux2, (long)row, col);

            if (entry2 == 0 || aux2 == 0)
                continue;

            if (!(entry2->w46 & 0x10))
                continue;

            if (!(entry2->b40 & 0x80))
                continue;

            if (row == req->rowStart) {

                idx = DISPLIB_FindPreviousValidEntryIndex(
                          entry2, aux2, (long)idx);

                if (COI_ProcessEntrySelectionState(
                        entry2, aux2, (long)idx,
                        GCOMMAND_PpvSelectionWindowMinutes,
                        GCOMMAND_PpvSelectionToleranceMinutes) == 0)
                    aux2 = 0;
            }

            if (aux2 == 0)
                continue;

            if (aux2->slots[idx] == 0)
                continue;

            if (aux2->flags[idx] & 0xa0)
                continue;

            if (ESQ_TestBit1Based(entry2->bits,
                                                  (long)idx) != -1)
                continue;

            s = aux2->slots[idx];
            if (s[0] == 40 && aux2->slots[idx][3] == 58)
                off = 8;
            else
                off = 0;
            title2 = aux2->slots[idx] + off;

            g1 = COI_SelectAnimFieldPointer(entry2, (long)idx,
                                                            1L);
            g2 = COI_SelectAnimFieldPointer(entry2, (long)idx,
                                                            2L);
            g6 = COI_SelectAnimFieldPointer(entry2, (long)idx,
                                                            6L);
            g7 = COI_SelectAnimFieldPointer(entry2, (long)idx,
                                                            7L);

            if (title2 == 0)
                continue;

            if (titlePtr == title2)
                continue;

            if (strcmp(titlePtr, title2) != 0)
                continue;

            if (field1 != g1) {
                if (field1 == 0 || g1 == 0)
                    continue;
                if (strcmp(field1, g1) != 0)
                    continue;
            }

            if (field2 != g2) {
                if (field2 == 0 || g2 == 0)
                    continue;
                if (strcmp(field2, g2) != 0)
                    continue;
            }

            if (field6 != g6) {
                if (field6 == 0 || g6 == 0)
                    continue;
                if (strcmp(field6, g6) != 0)
                    continue;
            }

            if (field7 != g7) {
                if (field7 == 0 || g7 == 0)
                    continue;
                if (strcmp(field7, g7) != 0)
                    continue;
            }

            aux2->flags[idx] |= 0x20;

            if (widthLeft <= 0)
                continue;

            if (*out == 0) {

                strcpy(out, Global_STR_SHOWTIMES_AND_SINGLE_SPACE);

                textPtr = STR_SkipClass3Chars(timeBuf);
                NEWGRID_AddShowtimeBucketEntry(textPtr, (long)rawSlot);

                widthLeft -= TextLength(
                    &ctx->rp, Global_STR_SHOWTIMES_AND_SINGLE_SPACE,
                    strlen(Global_STR_SHOWTIMES_AND_SINGLE_SPACE));

                widthLeft -= TextLength(&ctx->rp, textPtr, strlen(textPtr));
            }

            TEXTDISP_FormatEntryTimeForIndex(timeBuf, (long)idx, aux2);
            textPtr = STR_SkipClass3Chars(timeBuf);

            w    = TextLength(&ctx->rp, textPtr, strlen(textPtr));
            need = commaWidth + w;

            if (widthLeft >= need) {
                if (row > 48)
                    k = (long)idx + 48;
                else
                    k = (long)idx;
                if (NEWGRID_AddShowtimeBucketEntry(textPtr, k) == 0)
                    continue;
            }

            w = TextLength(&ctx->rp, textPtr, strlen(textPtr));
            widthLeft -= commaWidth + w;
        }
    }

    if (*out == 0) {
        strcpy(out, Global_STR_SHOWING_AT_AND_SINGLE_SPACE);
        textPtr = STR_SkipClass3Chars(timeBuf);
        STRING_AppendAtNull(out, textPtr);
    } else {
        NEWGRID_AppendShowtimeBuckets(out);
    }

    if (field2 == 0)
        return;
    if (*field2 == 0)
        return;

    STRING_AppendAtNull(out, NEWGRID_ShowtimeGenreSpacer);
    STRING_AppendAtNull(out, field2);
}
