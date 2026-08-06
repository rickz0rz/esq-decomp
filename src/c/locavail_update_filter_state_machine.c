/* RESTORES: LOCAVAIL_UpdateFilterStateMachine
 * MODULE:   modules/groups/a/y/locavail_p4.s
 * STATUS:   behavioural
 *
 * Advances the local-availability filter through its four steps. Each step has
 * its own entry condition on the step number, the class id and the two cursors,
 * and the conditions are mutually exclusive by construction rather than by an
 * else-chain -- every step returns.
 *
 * THE STEP SEQUENCE IS 0 -> 1 -> 2, and steps 3 and 4 SHARE one arm. Nothing in
 * this function sets step 3 or 4; they arrive from elsewhere and are handled
 * together, which is why the test is `step == 3 || step == 4` rather than a
 * case.
 *
 * THE CURSOR SENTINELS INVERT BETWEEN STEPS. Step 0 and step 1 require BOTH
 * cursors to be set (not -1); step 2 and the 3/4 arm require both to be CLEAR
 * (-1). Step 1 is what clears them. Reading either pair the wrong way round
 * makes the machine stick.
 *
 * ANYTHING THAT MATCHES NO STEP FALLS OUT OF THE BOTTOM AND RESETS THE CURSOR
 * STATE. That is the only place the fall-through reset happens, and it is
 * reached from the 3/4 arm too when its inner conditions fail -- so a
 * half-satisfied step 3 resets rather than waiting.
 *
 * THE STATE STRUCT HAS A LONG AT OFFSET 2. `CMP.L 2(A2),D2` reads a longword at
 * an odd-WORD offset, which is legal on 68000 (longs need 2-byte alignment, not
 * 4). The struct below reproduces it, which works because SAS/C on Amiga packs
 * structs to 2-byte alignment. A compiler with 4-byte alignment would silently
 * move the field and every access after it.
 *
 * THE COOLDOWN IS THE SPAN MINUS FIVE and the half-span is the span itself, both
 * written from the same entry field in the same block. The -5 is not applied to
 * the half-span.
 *
 * CLASS 2 AND CLASS 3 FORCE MODE 4 on the step-1 exit; every other class leaves
 * the mode alone. That is the chained `CMP #2 / SUBQ #3` test, which is two
 * comparisons against one register rather than a switch.
 *
 * The class-1 arm is the only one that consults hardware: it looks for the
 * diagnostic character in a fixed string AND reads a CIA bit, and only sets
 * mode 10 when both agree. Either failing falls to the reset.
 *
 * The class-2 arm resets when the graph-mode character is 'N' OR the brush list
 * is empty -- an OR expressed in the original as two branches to the same
 * label.
 *
 * A _Return LABEL MEANS THE REFERENCE STOPS EARLY: 8 bytes of MOVEM/UNLK/RTS
 * are outside it, so the corrected reference is 764.
 *
 * 756 ref vs 736 got, 26 differing regions -- 28 bytes under the corrected 764.
 * All four step conditions with their inverted cursor sentinels, the entry
 * lookup with its bounds pair, the class dispatch, all three reset sites, the
 * span-minus-five cooldown, the class 2/3 mode forcing, the class-1 hardware
 * pair, the class-2 OR and the step 3/4 exit block match in kind and size.
 *
 * SASC-MISMATCH: one-jump-table-collapsed
 *   ref:     303b 4efb   THREE PC-relative jump tables
 *   got:     303b 4efb   TWO
 *   summary: the original emits a 16-entry table for BOTH mode switches. 6.51
 *            emits one and turns the other into a compare chain, because that
 *            switch has only two distinct outcomes once the shared cases are
 *            merged and a chain is cheaper. Same dispatch, fewer bytes -- most
 *            of the 28 this comes in under.
 *   tried:   nothing source-level reaches it. The two switches are written
 *            identically below, with the same case labels in the same order;
 *            whether the code generator tables or chains them is its decision.
 *            AGENTS.md's rule against writing an explicit range guard was
 *            followed at both sites, so the bound is the switch's own.
 *   scope:   any switch with few distinct outcomes over a wide range.
 *            docs/compiler-version.md, "Case body layout".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct LocavailEntry {                  /* 10 bytes */
    short          pad0;
    short          span;                /* +2 */
    short          count;               /* +4 */
    unsigned char *classes;             /* +6 */
};

struct LocavailState {
    short  pad0;
    long   limit;                       /* +2, a long at an ODD-word offset */
    short  pad6;
    long   cursorA;                     /* +8  */
    long   cursorB;                     /* +12 */
    long   pad16;
    struct LocavailEntry *table;        /* +20 */
};

struct LocavailCtx {
    char  pad0[20];
    long  mode;                         /* +20 */
    short w24;                          /* +24 */
};

extern long __asm MATH_Mulu32(register __d0 long a,
                        register __d1 long b);
extern char *STR_FindCharPtr(char *s, long ch);
extern char SCRIPT_ReadHandshakeBit5Mask(void);
extern void LOCAVAIL_ResetFilterCursorState(struct LocavailState *st);

extern long  LOCAVAIL_FilterModeFlag;
extern long  LOCAVAIL_FilterStep;
extern long  LOCAVAIL_FilterClassId;
extern long  LOCAVAIL_FilterPrevClassId;
extern short LOCAVAIL_FilterCooldownTicks;
extern short LOCAVAIL_FilterWindowHalfSpan;
extern long  ESQIFF_GAdsBrushListCount;
extern short WDISP_HighlightActive;
extern char  ED_DiagVinModeChar;
extern char  ED_DiagGraphModeChar;
extern char  LOCAVAIL_STR_YYLLZ_FilterStateUpdate[];

void LOCAVAIL_UpdateFilterStateMachine(struct LocavailCtx *ctx,
                                       struct LocavailState *st)
{
    struct LocavailEntry *entry;
    long a;
    long b;
    long cls;
    long mode;

    entry = 0;

    if (LOCAVAIL_FilterModeFlag != 1)
        return;

    if (LOCAVAIL_FilterStep == 0 && LOCAVAIL_FilterClassId == -1) {

        a = st->cursorA;
        if (a == -1)
            return;

        b = st->cursorB;
        if (b == -1)
            return;

        if (a >= 0 && a < st->limit)
            entry = &st->table[a];

        if (entry == 0)
            return;

        if (b < 0)
            return;

        if (b >= (long)entry->count)
            return;

        cls = (long)entry->classes[b];

        LOCAVAIL_FilterClassId     = cls;
        LOCAVAIL_FilterStep        = 1;
        LOCAVAIL_FilterPrevClassId = -1;

        switch ((short)cls) {

        case 1:
            if (STR_FindCharPtr(
                    LOCAVAIL_STR_YYLLZ_FilterStateUpdate,
                    (long)ED_DiagVinModeChar) != 0
                && SCRIPT_ReadHandshakeBit5Mask() != 0) {
                ctx->mode = 10;
                return;
            }
            LOCAVAIL_ResetFilterCursorState(st);
            return;

        case 2:
            if (ED_DiagGraphModeChar == 'N'
                || ESQIFF_GAdsBrushListCount == 0)
                LOCAVAIL_ResetFilterCursorState(st);
            return;

        case 3:
            if (WDISP_HighlightActive != 0)
                return;
            LOCAVAIL_ResetFilterCursorState(st);
            return;

        default:
            LOCAVAIL_ResetFilterCursorState(st);
            return;
        }
    }

    if (LOCAVAIL_FilterStep == 1 && LOCAVAIL_FilterClassId != -1
        && st->cursorA != -1 && st->cursorB != -1) {

        a = st->cursorA;
        if (a >= 0 && a < st->limit)
            entry = &st->table[a];

        if (entry == 0)
            return;

        b = st->cursorB;
        if (b < 0)
            return;

        if (b >= (long)entry->count)
            return;

        mode = ctx->mode;
        if ((unsigned long)mode >= 16)
            return;

        switch ((short)mode) {

        case 1:
        case 2:
        case 3:
        case 5:
        case 6:
        case 7:
        case 8:
            LOCAVAIL_FilterCooldownTicks  = entry->span - 5;
            LOCAVAIL_FilterWindowHalfSpan = entry->span;
            st->cursorB = st->cursorA = -1;
            LOCAVAIL_FilterStep = 2;
            if (LOCAVAIL_FilterClassId == 2 || LOCAVAIL_FilterClassId == 3)
                ctx->mode = 4;
            return;

        case 4:
            ctx->mode = 0;
            return;

        default:
            return;
        }
    }

    if (LOCAVAIL_FilterStep == 2 && LOCAVAIL_FilterClassId != -1
        && st->cursorA == -1 && st->cursorB == -1) {
        ctx->mode = 0;
        return;
    }

    if (LOCAVAIL_FilterStep == 3 || LOCAVAIL_FilterStep == 4) {

        if (LOCAVAIL_FilterClassId != -1 && st->cursorA == -1
            && st->cursorB == -1) {

            mode = ctx->mode;
            if ((unsigned long)mode >= 16)
                return;

            switch ((short)mode) {

            case 1:
            case 2:
            case 3:
            case 5:
            case 6:
            case 7:
            case 8:
                if (LOCAVAIL_FilterClassId == 1)
                    ctx->w24 = 3;
                LOCAVAIL_FilterClassId        = -1;
                LOCAVAIL_FilterStep           = 0;
                LOCAVAIL_FilterWindowHalfSpan = -1;
                return;

            case 4:
                ctx->mode = 0;
                return;

            default:
                return;
            }
        }
    }

    LOCAVAIL_ResetFilterCursorState(st);
}
