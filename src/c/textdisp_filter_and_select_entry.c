/* RESTORES: TEXTDISP_FilterAndSelectEntry
 * MODULE:   modules/groups/b/a/textdisp_p2.s
 * STATUS:   behavioural
 *
 * Finds the first entry matching a name pattern and a text prefix, and selects
 * it. It is a STATE MACHINE, not a nested loop: three cursors -- the mode, the
 * channel slot and the candidate index -- advance independently, and the code
 * jumps back to whichever level needs to move next.
 *
 * WRITTEN WITH `goto`, DELIBERATELY. The original's back-edges do not nest:
 * `advance_channel_index` re-enters `advance_cursor_set`, which is inside the
 * block `advance_mode` re-enters, and `advance_mode` itself jumps back to
 * `ensure_filter_ready` above it. There is no loop structure that expresses
 * that without either duplicating blocks or adding a flag variable the original
 * does not have. The labels below carry the disassembly's names so the two can
 * be read side by side.
 *
 * THE MODE ARGUMENT IS A CHARACTER. The dispatch subtracts 70 and then 18, so
 * the live values are 0, 70 ('F') and 88 ('X'); everything else falls to the
 * default. 'F' rebuilds the candidate list from scratch, 'X' resumes scanning
 * with the list already built.
 *
 * A NULL RECORD OR AN EMPTY NAME OR TAG FORCES MODE 0, which sets the filter
 * mode to 3 and returns without scanning. Mode 3 is the "stop" state -- the
 * ready check bails on it too, which is how the machine terminates.
 *
 * WILDCARD MATCH RETURNS ZERO FOR A MATCH here as elsewhere, so the PPV and SBE
 * tests read inverted: either one matching sets the flag to 1.
 *
 * THE SPORTS FLAG IS BUILT WITH THE BOOLEANIZE IDIOM -- `SEQ` then `NEG.B` --
 * which yields +1, not -1. Writing `= (match == 0)` reproduces it. This is the
 * bug class recorded in memory as booleanize-neg-b-sign; getting the sign wrong
 * here inverts the grid-eligibility test further down.
 *
 * THE BACKTRACK LOOP RE-READS THE SLOT IT ALREADY READ. The code loads
 * `slots[slot]`, then enters a loop that tests and loads `slots[ch]` with ch
 * still equal to slot. The first iteration therefore repeats the load it just
 * did. That is in the original and is reproduced; removing it would change the
 * instruction sequence for no behavioural gain.
 *
 * The backtrack only runs for mode 1 AND only when the clock slot equals the
 * channel slot. Every other case takes the slot directly with no search.
 *
 * TestBit1Based must return exactly -1 for the entry to qualify -- the
 * `ADDQ.L #1 / BNE` idiom again, meaning the bit must be CLEAR.
 *
 * The channel-slot bound 0x31 and the mode-advance bound 0x30 are compared
 * UNSIGNED (`BCC`, `BLS`), so a slot that somehow went negative reads as huge
 * and exits rather than looping.
 *
 * 1068 ref vs 1052 got, 26 differing regions. The mode dispatch, all three
 * wildcard calls with their inverted sense, the booleanize, the candidate scan
 * with its two flag shortcuts and its bit-3 skip, the match-count bounds, the
 * backtrack loop including its redundant first load, the time-window call with
 * its five arguments, the control-code skip, the case-insensitive prefix
 * compare, the TestBit1Based check and both selection calls match in kind and
 * size.
 *
 * SHORTINT WAS MEASURED AND REJECTED. It gives 1036 bytes against the plain
 * form's 1052, with the same 26 regions -- but the reference is 1068, so
 * SHORTINT moves the candidate 32 bytes UNDER where the plain form is 16 under.
 * Further from the original in the direction that matters, at no gain in
 * structure. Not every chained-subtract dispatch wants it; this is the second
 * counter-example after ed_get_esc_menu_action_code.c.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ffdc ... 2b48ffe2   LINK.W A5,#-36 / MOVE.L A0,-30(A5)
 *   got:     the same slots addressed from A7, with fewer of them
 *   summary: the frame class. 6.51 keeps the name and tag pointers in registers
 *            where the original spills both, which is most of the 16 bytes this
 *            comes in under.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>

struct TdEntry {
    char          pad0[12];
    char          name[15];             /* +12 */
    unsigned char b27;                  /* +27 */
    char          bits[8];              /* +28 */
};

struct TdAux {
    char  pad0[56];
    char *slots[50];                    /* +56 */
};

extern char  ESQ_WildcardMatch(char *pattern, char *s);
extern short TEXTDISP_GetGroupEntryCount(long mode);
extern struct TdEntry *ESQDISP_GetEntryPointerByMode(long i,
                                                                   long mode);
extern struct TdAux *ESQDISP_GetEntryAuxPointerByMode(long i,
                                                                    long mode);
extern long  TEXTDISP_ShouldOpenEditorForEntry(struct TdEntry *e);
extern long  COI_TestEntryWithinTimeWindow(struct TdEntry *e,
                                                         struct TdAux *aux,
                                                         long ch, long span,
                                                         long window);
extern char *TEXTDISP_SkipControlCodes(char *s);
extern long  ESQDISP_TestEntryGridEligibility(struct TdAux *aux,
                                                              long ch);
extern long  STRING_CompareNoCaseN(char *a, char *b, long n);
extern long  ESQ_TestBit1Based(char *bits, long ch);
extern void  TEXTDISP_SetSelectionFields(void *rec, long mode, long index,
                                         long ch);
extern void  TEXTDISP_BuildEntryDetailLine(void *rec);
extern void  TEXTDISP_ResetSelectionState(void *rec);

extern unsigned char TEXTDISP_CandidateIndexList[];
extern char  SCRIPT_FilterTag_PPV[];
extern char  SCRIPT_FilterTag_SBE[];
extern char  SCRIPT_FilterTag_SPORTS[];
extern short TEXTDISP_FilterChannelSlotIndex;
extern char  TEXTDISP_FilterModeId;
extern short TEXTDISP_FilterPpvSbeMatchFlag;
extern short TEXTDISP_FilterSportsMatchFlag;
extern short TEXTDISP_FilterMatchCount;
extern short TEXTDISP_FilterCandidateCursor;
extern short CLOCK_HalfHourSlotIndex;
extern long  CONFIG_TimeWindowMinutes;

long TEXTDISP_FilterAndSelectEntry(char *rec, char mode)
{
    struct TdEntry *e;
    struct TdAux   *aux;
    char *namePtr;
    char *tagPtr;
    char *str;
    long  found;
    long  count;
    long  i;
    long  t;
    short ch;

    found = 0;

    if (rec == 0) {
        mode = 0;
    } else {
        namePtr = rec;
        tagPtr  = rec + 10;
        if (*namePtr == 0 || *tagPtr == 0)
            mode = 0;
    }

    switch ((short)(unsigned char)mode) {
    case 0:
        goto defaultMode3;
    case 70:
        goto handleModeF;
    case 88:
        goto ensureFilterReady;
    default:
        goto defaultMode3;
    }

handleModeF:
    TEXTDISP_FilterChannelSlotIndex = 0;
    TEXTDISP_FilterModeId           = 1;

    if (ESQ_WildcardMatch(SCRIPT_FilterTag_PPV, namePtr) == 0)
        t = 1;
    else if (ESQ_WildcardMatch(SCRIPT_FilterTag_SBE,
                                              namePtr) == 0)
        t = 1;
    else
        t = 0;

    TEXTDISP_FilterPpvSbeMatchFlag = (short)t;

    TEXTDISP_FilterSportsMatchFlag =
        (short)(ESQ_WildcardMatch(SCRIPT_FilterTag_SPORTS,
                                                 namePtr) == 0);

ensureFilterReady:
    if (found)
        goto afterDispatch;

    if (TEXTDISP_FilterModeId == 3)
        goto afterDispatch;

    if (TEXTDISP_FilterChannelSlotIndex != 0)
        goto advanceCursorSet;

    count = TEXTDISP_GetGroupEntryCount((long)TEXTDISP_FilterModeId);
    TEXTDISP_FilterMatchCount = 0;

    for (i = 0; i < count; i++) {

        e = ESQDISP_GetEntryPointerByMode(
                i, (long)TEXTDISP_FilterModeId);

        if (e->b27 & 8)
            continue;

        if (TEXTDISP_FilterPpvSbeMatchFlag != 0 && (e->b27 & 0x10))
            goto record;

        if (TEXTDISP_FilterSportsMatchFlag != 0
            && TEXTDISP_ShouldOpenEditorForEntry(e) != 0)
            goto record;

        if (ESQ_WildcardMatch(e->name, namePtr) != 0)
            continue;

record:
        TEXTDISP_CandidateIndexList[TEXTDISP_FilterMatchCount++] =
            (unsigned char)i;
    }

    if (TEXTDISP_FilterMatchCount > 0) {
        TEXTDISP_FilterCandidateCursor = 0;
        if (TEXTDISP_FilterModeId == 1)
            TEXTDISP_FilterChannelSlotIndex = CLOCK_HalfHourSlotIndex;
        else
            TEXTDISP_FilterChannelSlotIndex = 1;
    } else {
        TEXTDISP_FilterChannelSlotIndex = 0x31;
    }

advanceCursorSet:
    if (found)
        goto advanceMode;

    if ((unsigned short)TEXTDISP_FilterChannelSlotIndex >= 0x31)
        goto advanceMode;

cursorLoop:
    if (found)
        goto advanceChannelIndex;

    if ((unsigned short)TEXTDISP_FilterCandidateCursor
        >= (unsigned short)TEXTDISP_FilterMatchCount)
        goto advanceChannelIndex;

    aux = ESQDISP_GetEntryAuxPointerByMode(
              (long)TEXTDISP_CandidateIndexList[TEXTDISP_FilterCandidateCursor],
              (long)TEXTDISP_FilterModeId);

    if (aux == 0)
        goto nextCursorEntry;

    if (TEXTDISP_FilterModeId == 1
        && CLOCK_HalfHourSlotIndex == TEXTDISP_FilterChannelSlotIndex) {

        ch  = TEXTDISP_FilterChannelSlotIndex;
        str = aux->slots[ch];

        while (ch > 0 && str == 0) {
            str = aux->slots[ch];
            ch--;
        }

        if (str != 0) {
            e = ESQDISP_GetEntryPointerByMode(
                    (long)TEXTDISP_CandidateIndexList[
                              TEXTDISP_FilterCandidateCursor],
                    (long)TEXTDISP_FilterModeId);

            if (COI_TestEntryWithinTimeWindow(
                    e, aux, (long)ch, 1440L, CONFIG_TimeWindowMinutes) == 0)
                str = 0;
        }

    } else {
        ch  = TEXTDISP_FilterChannelSlotIndex;
        str = aux->slots[ch];
    }

    if (str == 0)
        goto nextCursorEntry;

    str = TEXTDISP_SkipControlCodes(str);

    if (TEXTDISP_FilterSportsMatchFlag != 0) {
        if (ESQDISP_TestEntryGridEligibility(aux,
                                                             (long)ch) == 0)
            goto nextCursorEntry;
    }

    if (STRING_CompareNoCaseN(tagPtr, str, strlen(tagPtr)) != 0)
        goto nextCursorEntry;

    e = ESQDISP_GetEntryPointerByMode(
            (long)TEXTDISP_CandidateIndexList[TEXTDISP_FilterCandidateCursor],
            (long)TEXTDISP_FilterModeId);

    if (ESQ_TestBit1Based(e->bits, (long)ch) != -1)
        goto nextCursorEntry;

    found = 1;

    TEXTDISP_SetSelectionFields(
        rec, (long)TEXTDISP_FilterModeId,
        (long)TEXTDISP_CandidateIndexList[TEXTDISP_FilterCandidateCursor],
        (long)ch);
    TEXTDISP_BuildEntryDetailLine(rec);

nextCursorEntry:
    TEXTDISP_FilterCandidateCursor++;
    goto cursorLoop;

advanceChannelIndex:
    if (found)
        goto advanceCursorSet;

    TEXTDISP_FilterChannelSlotIndex++;
    TEXTDISP_FilterCandidateCursor = 0;
    goto advanceCursorSet;

advanceMode:
    if ((unsigned short)TEXTDISP_FilterChannelSlotIndex <= 0x30)
        goto ensureFilterReady;

    TEXTDISP_FilterChannelSlotIndex = 0;

    if (TEXTDISP_FilterModeId == 1) {
        TEXTDISP_FilterModeId = 2;
        goto ensureFilterReady;
    }

    TEXTDISP_FilterModeId = 3;
    goto ensureFilterReady;

defaultMode3:
    TEXTDISP_FilterModeId = 3;

afterDispatch:
    if (!found)
        TEXTDISP_ResetSelectionState(rec);

    return found;
}
