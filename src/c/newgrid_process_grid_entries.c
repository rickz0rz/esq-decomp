/* RESTORES: _NEWGRID_ProcessGridEntries
 * MODULE:   modules/groups/b/a/newgrid1b_p2.s
 * STATUS:   behavioural
 *
 * Draws one channel row of the listings grid: up to three half-hour cells,
 * merged where a programme spans more than one slot, with continuation markers
 * on whichever ends run past the visible window. It answers the next workflow
 * state, and the caller drives it until that state stops changing.
 *
 * ONLY STATES 4 AND 5 EXIST. Anything else is forced to 4 and returned. State 5
 * is the "redraw the header and check whether we are done" step; state 4 is the
 * full row draw. A null context also forces 4.
 *
 * THE ROW LOOP ADVANCES BY THE SPAN, NOT BY ONE. A cell that covers two slots
 * sets span to 2 and the loop skips the slot it already drew. Every exit path
 * from the body sets span first, including the failure paths, because the loop
 * increment reads it unconditionally.
 *
 * THE SLOT INDEX WRAPS AT 48 AND THE THREE COPIES ARE NOT INTERCHANGEABLE. When
 * the second key is used, `idxA` and `idxB` hold the wrapped slot while `idxC`
 * holds it PLUS 0x30 -- so the state tests below run on the unwrapped value and
 * the drawing on the wrapped one. When the first key is used all three are the
 * same. Collapsing them into one variable breaks the wrap case only, which is
 * the case that happens once a day.
 *
 * WHICH KEY IS USED IS DECIDED TWICE, by the same three-part test, once before
 * the loop and once inside it. The two are not redundant: the outer one picks
 * the wildcard match index, the inner one picks the entry pointers, and the
 * inner test uses `slot + row` where the outer uses `slot` alone. So a row can
 * cross the boundary mid-draw.
 *
 * THE MARKER-A LADDER IS FOUR-DEEP AND ONLY RUNS ON ROW 0. It decides whether
 * the programme started before the visible window: a gap of more than one slot
 * means "starts earlier" (2), exactly one means "starts here" (1), and the two
 * remaining cases -- slot 1 with the aux flag set, and slot 2 following slot 1
 * -- are special-cased with a second state lookup against slot 48, which is the
 * previous day's last slot. That lookup is what makes a programme running over
 * midnight draw correctly.
 *
 * `aux->flags[1]` IS THE BYTE AT +8. The original BTSTs `8(A0)` there and
 * `7(A0,D0.W)` for the per-slot flags, so the two overlap by construction: the
 * flag array starts at +7 and its element 1 is the +8 byte. They are the same
 * storage and the struct below says so rather than declaring two fields.
 *
 * MARKER B LOOKS ONE SLOT PAST THE END, then one further. It only runs when the
 * row exactly fills the three cells, and it distinguishes "continues" (1) from
 * "continues past the next slot too" (2) with two separate state tests.
 *
 * The pen state 255 is the sentinel for "no selection". At the end, a state-5
 * transition replaces it with the selected entry pointer -- so the same global
 * carries either a marker pen or a pointer depending on the state. That is the
 * original's and it is why the comparison is against the literal 255 rather
 * than against a named constant.
 *
 * The row height is halved with a LOGICAL shift, so an odd height rounds down
 * and a height with the high bit set does not go negative.
 *
 * 1586 ref vs 1536 got, 26 differing regions. Both state arms, the three-part
 * key test at both sites, the 48-slot wrap with its separate +0x30 index, the
 * span scan, the state-3 backtrack, the whole four-deep marker-A ladder
 * including the slot-48 lookup, both marker-B tests, the flag BTSTs at +8 and
 * +7+idx, all four SetLayoutParams call sites with their distinct heights and
 * pens, all four DrawEntryRowOrPlaceholder calls, the marker draw and both
 * closing DrawGridCell arms match in kind and size.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ffd0 ... 2b40ffe2   LINK.W A5,#-48 / MOVE.L D0,-30(A5)
 *   got:     the same slots addressed from A7, with several kept in registers
 *   summary: the frame class. The original spills the state code, both marker
 *            values and the entry pointers; 6.51 keeps four of them live in
 *            registers across the row body. That is the 50 bytes this comes in
 *            under, and it is the same divergence as every other large
 *            restoration in this set.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct NgCtx {
    char  pad0[32];
    long  f32;                          /* +32 */
    char  pad36[16];
    short w52;                          /* +52 */
    char  pad54[6];
    char  panel[4];                     /* +60 */
};

struct NgAux {
    char          pad0[7];
    unsigned char flags[52];            /* +7; flags[1] is the +8 byte */
};

extern void  NEWGRID_DrawGridHeaderRows(struct NgCtx *ctx, long headerPen,
                                        long markerPen);
extern long  DISPTEXT_IsCurrentLineLast(void);
extern short ESQ_GetHalfHourSlotIndex(void *clock);
extern long  TLIBA_FindFirstWildcardMatchIndex(void *title);
extern long  NEWGRID_SelectEntryPen(void *entry);
extern void  NEWGRID_DrawGridFrame(struct NgCtx *ctx, long a, long headerPen,
                                   long selPtr, long height);
extern void *ESQDISP_GetEntryPointerByMode(long i, long mode);
extern struct NgAux *ESQDISP_GetEntryAuxPointerByMode(long i,
                                                                      long mode);
extern long  NEWGRID_GetEntryStateCode(void *entry, void *aux, long idx);
extern long  NEWGRID_TestEntryState(long state, long index, long match,
                                    long idx);
extern short DISPLIB_FindPreviousValidEntryIndex(void *entry,
                                                                 void *aux,
                                                                 long idx);
extern void  DISPTEXT_SetLayoutParams(long w, long h,
                                                      long pen);
extern void  DISPTEXT_ComputeMarkerWidths(char *panel,
                                                          long a, long b);
extern void  NEWGRID_DrawEntryRowOrPlaceholder(char *panel, void *entry,
                                               void *aux, long idx, long span,
                                               long state);
extern void  NEWGRID_DrawSelectionMarkers(struct NgCtx *ctx, long row,
                                          long span, long pen, long a,
                                          long b);
extern void  NEWGRID_DrawGridCell(char *panel, void *entry, long flag);
extern long  DISPTEXT_ComputeVisibleLineCount(long n);

extern void *TEXTDISP_PrimaryEntryPtrTable[];
extern void *TEXTDISP_PrimaryTitlePtrTable[];

extern long  NEWGRID_GridEntriesWorkflowState;
extern long  NEWGRID_SelectionMarkerPenState;
extern long  NEWGRID_RowLayoutCommitPenId;
extern long  NEWGRID_HeaderFramePenId;
extern long  NEWGRID_SelectedGridEntryPtr;
extern long  NEWGRID_GridOperationId;
extern long  GCOMMAND_NicheFramePen;
extern long  NEWGRID_OverridePenIndex;
extern short NEWGRID_RowHeightPx;
extern short NEWGRID_ColumnWidthPx;
extern char  CONFIG_NewgridPlaceholderBevelFlag;
extern char  CLOCK_DaySlotIndex[];

long NEWGRID_ProcessGridEntries(struct NgCtx *ctx, long index, short slot)
{
    struct NgAux *aux;
    void  *entry;
    void  *firstEntry;
    long   match;
    long   ok;
    long   state;
    long   markerA;
    long   markerB;
    long   cellH;
    long   t;
    long   w;
    short  row;
    short  span;
    short  idxA;
    short  idxB;
    short  idxC;

    match = -1;
    ok    = 1;

    if (ctx == 0) {
        NEWGRID_GridEntriesWorkflowState = 4;
        goto returnState;
    }

    if (NEWGRID_GridEntriesWorkflowState == 4)
        goto state4;

    if (NEWGRID_GridEntriesWorkflowState != 5) {
        NEWGRID_GridEntriesWorkflowState = 4;
        goto returnState;
    }

    NEWGRID_DrawGridHeaderRows(ctx, NEWGRID_HeaderFramePenId,
                               NEWGRID_SelectionMarkerPenState);
    ctx->f32 = -1;

    if (DISPTEXT_IsCurrentLineLast() == 0)
        goto returnState;

    NEWGRID_GridEntriesWorkflowState = 4;
    goto returnState;

state4:
    if (slot > 44 || slot == 1
        || ESQ_GetHalfHourSlotIndex(CLOCK_DaySlotIndex) == 1)
        match = TLIBA_FindFirstWildcardMatchIndex(
                    TEXTDISP_PrimaryTitlePtrTable[index]);
    else
        match = -1;

    NEWGRID_SelectedGridEntryPtr =
        NEWGRID_SelectEntryPen(TEXTDISP_PrimaryEntryPtrTable[index]);

    if (NEWGRID_GridOperationId == 5)
        NEWGRID_HeaderFramePenId = GCOMMAND_NicheFramePen;
    else
        NEWGRID_HeaderFramePenId = 7;

    NEWGRID_DrawGridFrame(ctx, 7L, NEWGRID_HeaderFramePenId,
                          NEWGRID_SelectedGridEntryPtr,
                          (long)NEWGRID_RowHeightPx + 3);

    for (row = 0; row < 3; row += span) {

        span    = 0;
        markerB = markerA = 0;
        NEWGRID_RowLayoutCommitPenId = NEWGRID_SelectionMarkerPenState = 0xff;
        entry = aux = 0;

        if ((long)slot + (long)row > 48 || slot == 1
            || ESQ_GetHalfHourSlotIndex(CLOCK_DaySlotIndex)
                   == 1) {

            entry = ESQDISP_GetEntryPointerByMode(match, 2L);
            aux   = ESQDISP_GetEntryAuxPointerByMode(match,
                                                                     2L);

            t = (long)slot + (long)row;
            if (t > 48)
                t = t - 48;

            idxB = idxA = (short)t;
            idxC = (short)t + 0x30;

        } else {

            entry = ESQDISP_GetEntryPointerByMode(index, 1L);
            aux   = ESQDISP_GetEntryAuxPointerByMode(index,
                                                                     1L);

            idxB = idxA = idxC = slot + row;
        }

        if (entry == 0 || aux == 0) {

            span = 3 - row;
            if (span >= 3) {
                ok = 0;
                goto maybeDrawMarkers;
            }

            NEWGRID_SelectionMarkerPenState = 0xff;
            NEWGRID_RowLayoutCommitPenId    = 1;
            t = 1;

            w = (long)NEWGRID_ColumnWidthPx * span - 12;
            DISPTEXT_SetLayoutParams(w, 2L, 1L);
            NEWGRID_DrawEntryRowOrPlaceholder(ctx->panel, entry, aux,
                                              (long)idxB, (long)span, t);
            goto maybeDrawMarkers;
        }

        if (row == 0)
            firstEntry = entry;

        t = NEWGRID_GetEntryStateCode(entry, aux, (long)idxA);

        span = 1;
        while ((long)row + (long)span < 3) {
            if (NEWGRID_TestEntryState(t, index, match,
                                       (long)(short)(idxC + span)) == 0)
                break;
            span++;
        }

        if (t == 3) {
            idxB = DISPLIB_FindPreviousValidEntryIndex(
                       entry, aux, (long)idxA);
            if (idxB == 0)
                t = 1;
            else
                t = 2;
        }

        if (t != 2)
            goto drawSimpleCell;

        if (row == 0) {

            if ((long)idxA - (long)idxB > 1) {
                markerA = 2;
            } else if ((long)idxA - (long)idxB - 1 == 0) {
                markerA = 1;
            } else if (idxA == 1 && (aux->flags[1] & 0x80)) {
                if (NEWGRID_GetEntryStateCode(TEXTDISP_PrimaryEntryPtrTable[index],
                                              TEXTDISP_PrimaryTitlePtrTable[index],
                                              48L) == 2)
                    markerA = 1;
                else
                    markerA = 2;
            } else if (idxA == 2 && idxB == 1) {
                if (aux->flags[1] & 0x80)
                    markerA = 2;
                else
                    markerA = 1;
            }
        }

        if ((long)row + (long)span == 3) {
            if (NEWGRID_TestEntryState(t, index, match,
                                       (long)(short)(idxC + span)) != 0) {
                if (NEWGRID_TestEntryState(t, index, match,
                                           (long)(short)(idxC + span + 1))
                    != 0)
                    markerB = 2;
                else
                    markerB = 1;
            }
        }

        NEWGRID_RowLayoutCommitPenId = NEWGRID_OverridePenIndex;

        if (aux->flags[idxB] & 4)
            NEWGRID_SelectionMarkerPenState = 5;
        else
            NEWGRID_SelectionMarkerPenState = 0xff;

        if (span == 3 && CONFIG_NewgridPlaceholderBevelFlag == 89)
            cellH = 20;
        else
            cellH = 2;

        w = (long)NEWGRID_ColumnWidthPx * span - 12;
        DISPTEXT_SetLayoutParams(w, cellH,
                                                 NEWGRID_RowLayoutCommitPenId);
        DISPTEXT_ComputeMarkerWidths(ctx->panel, markerA,
                                                     markerB);
        NEWGRID_DrawEntryRowOrPlaceholder(ctx->panel, entry, aux, (long)idxB,
                                          (long)span, t);
        goto maybeDrawMarkers;

drawSimpleCell:
        if (span >= 3) {
            ok = 0;
            goto maybeDrawMarkers;
        }

        NEWGRID_SelectionMarkerPenState = 0xff;
        NEWGRID_RowLayoutCommitPenId    = 1;

        w = (long)NEWGRID_ColumnWidthPx * span - 12;
        DISPTEXT_SetLayoutParams(w, 2L, 1L);
        NEWGRID_DrawEntryRowOrPlaceholder(ctx->panel, entry, aux, (long)idxB,
                                          (long)span, t);

maybeDrawMarkers:
        if (ok)
            NEWGRID_DrawSelectionMarkers(ctx, (long)row, (long)span,
                                         NEWGRID_SelectionMarkerPenState,
                                         markerA, markerB);
    }

    if (!ok) {
        ctx->w52 = 0;
        NEWGRID_GridEntriesWorkflowState = 4;
        goto returnState;
    }

    if (span == 3 && CONFIG_NewgridPlaceholderBevelFlag == 89
        && DISPTEXT_IsCurrentLineLast() == 0) {

        NEWGRID_DrawGridCell(ctx->panel, firstEntry, 0L);
        NEWGRID_GridEntriesWorkflowState = 5;

        if (NEWGRID_SelectionMarkerPenState == 255)
            NEWGRID_SelectionMarkerPenState = NEWGRID_SelectedGridEntryPtr;

    } else {
        NEWGRID_DrawGridCell(ctx->panel, firstEntry, 1L);
        NEWGRID_GridEntriesWorkflowState = 4;
    }

    ctx->w52 = (short)((unsigned short)NEWGRID_RowHeightPx >> 1);
    ctx->f32 = DISPTEXT_ComputeVisibleLineCount(2L);

returnState:
    state = NEWGRID_GridEntriesWorkflowState;
    return state;
}
