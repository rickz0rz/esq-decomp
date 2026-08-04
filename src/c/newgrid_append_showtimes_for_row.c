/* RESTORES: NEWGRID_AppendShowtimesForRow
 * MODULE:   modules/groups/b/a/newgrid1bb_p1.s
 * STATUS:   behavioural
 *
 * The single-row counterpart to newgrid_build_showtimes_text.c: same
 * five-field identity test, but it scans forward through ONE channel's slots
 * rather than the whole grid, and it appends directly to the output instead of
 * going through the bucket sort. Read that file first; the differences are
 * below.
 *
 * THE FIRST PARAMETER IS UNUSED. The original reads its arguments from 12, 16
 * and 20(A5) and never touches 8(A5). It is declared here so the stack layout
 * matches; removing it would shift every caller.
 *
 * NO WIDTH BUDGET. Where the grid-wide version measures every fragment with
 * TextLength and stops when the line is full, this one appends unconditionally
 * for up to 32 slots. It cannot overflow the caller's buffer by design rather
 * than by checking.
 *
 * THE SCAN IS BOUNDED AT 32 SLOTS PAST THE START, capped at 96, and then the
 * cap is incremented -- so the loop can reach slot 97 even though the entry
 * guard above rejects a starting slot of 97. The increment is applied after the
 * clamp, not before, and that ordering is what makes the last slot reachable.
 *
 * THE PRESET IS RE-FETCHED EXACTLY ONCE, at slot 49 -- the midnight boundary.
 * Before that the entry and aux pointers are the caller's; after it they belong
 * to the next day. The index is wrapped by 48 independently, so the two stay in
 * step. A scan that never crosses 49 uses one entry throughout.
 *
 * SIX REJECTION TESTS RUN BEFORE THE FIELD COMPARISON, in this order: the
 * occupancy bit must be CLEAR (TestBit1Based returning -1), flag bit 5 must be
 * clear (not already listed), the slot text must exist, and flag bit 7 must be
 * clear. Bit 5 is the one this function SETS on a match, so it is also what
 * stops the same programme being listed twice.
 *
 * THE ELIGIBILITY FLAGS MUST AGREE, which is a test the grid-wide version does
 * not have. Both are computed as `mode == 1 && TestEntryGridEligibility(...)`,
 * so in any mode other than 1 both are 0 and the test always passes. It only
 * bites in mode 1.
 *
 * The empty-string case is handled differently at the two title sites. The
 * reference title RETURNS on an empty string; the candidate title merely skips
 * the `(h:mm)` offset and carries on to be compared. So an empty candidate
 * title is compared, not rejected.
 *
 * 1004 ref vs 1040 got, 26 differing regions. All five guards, the slot wrap,
 * both `(h:mm)` offset tests with their differing empty-string handling, all
 * eight COI_SelectAnimFieldPointer calls, both eligibility computations and
 * their comparison, the 32-slot span with its 96 clamp and post-clamp
 * increment, the single slot-49 refetch, all four rejection tests, all five
 * field comparisons with their pointer-equality shortcuts, the BSET #5 mark,
 * both prefix copies and all five AppendAtNull calls match in kind and size.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ffac ... 2b40ffd8   LINK.W A5,#-84 / MOVE.L D0,-40(A5)
 *   got:     the same slots addressed from A7
 *   summary: the frame class. The original spills all eight field pointers and
 *            both eligibility flags; 6.51 keeps four of them in registers
 *            across the comparison chain and pays for it in reloads at the
 *            call sites. Net 36 bytes over.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>

struct NgRowEntry {
    char pad0[28];
    char bits[12];                      /* +28 = 0x1c */
};

struct NgRowAux {
    char          pad0[7];
    unsigned char flags[49];            /* +7  */
    char         *slots[50];            /* +56 */
};

struct NgRowReq {
    struct NgRowEntry *entry;           /* +0  */
    struct NgRowAux   *aux;             /* +4  */
    long   col;                         /* +8  */
    char   pad12[8];
    short  slot;                        /* +20 */
};

extern char *COI_SelectAnimFieldPointer(void *entry, long idx,
                                                        long field);
extern long  ESQDISP_TestEntryGridEligibility(void *aux,
                                                              long idx);
extern void  TEXTDISP_FormatEntryTimeForIndex(char *buf, long idx, void *aux);
extern short NEWGRID_UpdatePresetEntry(struct NgRowEntry **e,
                                       struct NgRowAux **a, long row,
                                       long col);
extern long  ESQ_TestBit1Based(char *bits, long idx);
extern char *STR_SkipClass3Chars(char *s);
extern void  STRING_AppendAtNull(char *dst, char *src);

extern char Global_STR_SHOWTIMES_AND_SINGLE_SPACE[];
extern char Global_STR_SHOWING_AT_AND_SINGLE_SPACE[];
extern char NEWGRID_ShowtimeListSeparator[];

void NEWGRID_AppendShowtimesForRow(void *unused, struct NgRowReq *req,
                                   char *out, long mode)
{
    struct NgRowEntry *entry2;
    struct NgRowAux   *aux2;
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
    char  timeBuf[21];
    char  elig;
    char  elig2;
    long  off;
    short slot;
    short row;
    short rowEnd;
    short idx;

    *out = 0;
    slot = req->slot;

    if (req->entry == 0)
        return;
    if (req->aux == 0)
        return;
    if (out == 0)
        return;
    if (slot <= 0)
        return;
    if (slot >= 97)
        return;

    if (slot > 48)
        slot -= 48;

    titlePtr = req->aux->slots[slot];

    if (titlePtr == 0)
        return;
    if (*titlePtr == 0)
        return;

    if (titlePtr[0] == 40 && titlePtr[3] == 58)
        off = 8;
    else
        off = 0;
    titlePtr += off;

    field1 = COI_SelectAnimFieldPointer(req->entry,
                                                        (long)slot, 1L);
    field2 = COI_SelectAnimFieldPointer(req->entry,
                                                        (long)slot, 2L);
    field6 = COI_SelectAnimFieldPointer(req->entry,
                                                        (long)slot, 6L);
    field7 = COI_SelectAnimFieldPointer(req->entry,
                                                        (long)slot, 7L);

    if (mode == 1
        && ESQDISP_TestEntryGridEligibility(req->aux,
                                                            (long)slot) != 0)
        elig = 1;
    else
        elig = 0;

    TEXTDISP_FormatEntryTimeForIndex(timeBuf, (long)slot, req->aux);

    entry2 = req->entry;
    aux2   = req->aux;

    rowEnd = 32 + req->slot;
    if (rowEnd > 96)
        rowEnd = 96;
    rowEnd++;

    for (row = req->slot + 1; row < rowEnd; row++) {

        if (row == 49)
            NEWGRID_UpdatePresetEntry(&entry2, &aux2, (long)row, req->col);

        if (row > 48)
            idx = row - 48;
        else
            idx = row;

        if (entry2 == 0)
            continue;
        if (aux2 == 0)
            continue;

        if (ESQ_TestBit1Based(entry2->bits, (long)idx) != -1)
            continue;

        if (aux2->flags[idx] & 0x20)
            continue;

        if (aux2->slots[idx] == 0)
            continue;

        if (aux2->flags[idx] & 0x80)
            continue;

        title2 = aux2->slots[idx];

        if (title2 != 0 && *title2 != 0) {
            if (title2[0] == 40 && title2[3] == 58)
                off = 8;
            else
                off = 0;
            title2 += off;
        }

        g1 = COI_SelectAnimFieldPointer(entry2, (long)idx, 1L);
        g2 = COI_SelectAnimFieldPointer(entry2, (long)idx, 2L);
        g6 = COI_SelectAnimFieldPointer(entry2, (long)idx, 6L);
        g7 = COI_SelectAnimFieldPointer(entry2, (long)idx, 7L);

        if (mode == 1
            && ESQDISP_TestEntryGridEligibility(
                   aux2, (long)idx) != 0)
            elig2 = 1;
        else
            elig2 = 0;

        if (title2 == 0)
            continue;

        if (titlePtr == title2)
            continue;

        if (strcmp(titlePtr, title2) != 0)
            continue;

        if (elig != elig2)
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

        if (*out == 0) {
            strcpy(out, Global_STR_SHOWTIMES_AND_SINGLE_SPACE);
            textPtr = STR_SkipClass3Chars(timeBuf);
            STRING_AppendAtNull(out, textPtr);
        }

        TEXTDISP_FormatEntryTimeForIndex(timeBuf, (long)idx, aux2);
        textPtr = STR_SkipClass3Chars(timeBuf);

        STRING_AppendAtNull(out, NEWGRID_ShowtimeListSeparator);
        STRING_AppendAtNull(out, textPtr);

        aux2->flags[idx] |= 0x20;
    }

    if (*out != 0)
        return;

    strcpy(out, Global_STR_SHOWING_AT_AND_SINGLE_SPACE);
    textPtr = STR_SkipClass3Chars(timeBuf);
    STRING_AppendAtNull(out, textPtr);
}
