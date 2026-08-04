/* RESTORES: ESQFUNC_SelectAndApplyBrushForCurrentEntry
 * MODULE:   modules/groups/a/n/esqfunc_p4_p0.s
 * STATUS:   behavioural
 *
 * Chooses the background brush for the current entry and installs its palette.
 * There are FIVE ways a brush can be selected and they are tried in a fixed
 * order, each falling through to the next when it does not apply.
 *
 *   1. a script-selected brush, primary or secondary by the mode argument
 *   2. tag "00" on the entry -> whatever BRUSH_SelectedNode holds
 *   3. tag "11" -> a WILDCARD walk over every brush's pattern chain
 *   4. any other tag -> a two-character tag match down the brush list
 *   5. nothing matched -> BRUSH_SelectedNode again
 *
 * THE WILDCARD WALK IS TWO NESTED LOOPS SHARING ONE FLAG. The outer walks the
 * brush list by its +368 link, the inner walks that brush's pattern chain by
 * +8, and both test the same `found` flag at their heads -- so setting it in
 * the inner loop unwinds both. Written with gotos below because the outer loop
 * re-enters at its own head from two different places and there is no
 * structured form that keeps the tests in the original's order.
 *
 * WILDCARD MATCH RETURNS ZERO FOR A MATCH, as everywhere else in this program.
 *
 * THE TYPE-3 FALLBACK IS ONLY REACHABLE FROM THE WILDCARD PATH. Entry bit 4
 * plus a non-null fallback node substitutes it, but only when the "11" tag sent
 * us down that branch and nothing matched. A "00" or plain-tag entry never
 * reaches it.
 *
 * THE BLIT CONDITION IS NOT "a brush was found". It requires a non-null brush
 * AND either a non-null BRUSH_SelectedNode or the found flag -- so a brush that
 * came from the fallback assignment when nothing was selected is NOT blitted,
 * even though the palette work below still runs on it.
 *
 * THE PALETTE MODE AT +328 IS READ THREE TIMES FOR THREE DIFFERENT DECISIONS:
 * modes 0, 1 and 3 copy the brush palette; mode 1 then restores the base
 * palette on top; mode 3 instead restores only the first twelve bytes. So mode
 * 1 copies the palette and immediately throws it away, and mode 3 keeps
 * everything except the first four colours.
 *
 * Both plane-mask bounds are `mask * 3` written as a shift-and-subtract, per
 * the AGENTS.md rule, and the copy is bounded by whichever is smaller.
 *
 * The function returns 1 unconditionally, from all five exits.
 *
 * 684 ref vs 628 got, 26 differing regions. All five selection paths in order,
 * both tag comparisons, the nested wildcard walk with its shared flag, the
 * type-3 fallback with its bit test, both SetRast calls, the two-part blit
 * condition, the seven-argument brush blit, the three-way palette mode test,
 * both plane-mask bounds and both restore paths match in kind and size.
 *
 * SASC-MISMATCH: reloaded-pointer-vs-live-register
 *   ref:     206dfffc 4aa80148   MOVEA.L -4(A5),A0 / TST.L 328(A0), repeated
 *                                at each of the six brush field reads
 *   got:     the brush pointer kept in one register throughout
 *   summary: the frame class in its commonest form. The original spills the
 *            selected brush and reloads it before every field access; 6.51
 *            keeps it live from the selection to the last palette test. Six
 *            reloads at 4 bytes each, plus the frame itself, is the 56 bytes
 *            this comes in under.
 *   tried:   nothing source-level reaches it. The C already reads
 *            `brush->field` at each site rather than hoisting anything; whether
 *            the code generator then reloads the pointer is its decision, and
 *            6.51 never does when the variable is not address-taken.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-graphics.h"

struct EfEntry {
    char          pad0[12];
    char          name[15];             /* +12 */
    unsigned char b27;                  /* +27 */
    char          pad28[15];
    char          tag[2];               /* +43 = 0x2b */
};

struct EfWild {
    char          pad0[8];
    struct EfWild *link;                /* +8 */
};

struct EfBrush {
    char           pad0[33];
    char           tag[2];              /* +33 = 0x21 */
    char           pad35[149];
    unsigned char  b184;                /* +184 */
    char           pad185[47];
    unsigned char  palette[96];         /* +232 = 0xe8 */
    long           mode328;             /* +328 */
    char           pad332[32];
    struct EfWild *wild;                /* +364 */
    struct EfBrush *next;               /* +368 */
};

struct EfCtx {
    short           pad0;
    short           w2;                 /* +2  */
    short           w4;                 /* +4  */
    char            pad6[4];
    struct RastPort rp;                 /* +10 */
};

extern long STRING_CompareN(char *a, char *b, long n);
extern char ESQ_WildcardMatch(char *name, void *node);
extern void BRUSH_SelectBrushSlot(struct EfBrush *b, long z0,
                                                long z1, long w, long h,
                                                struct RastPort *rp, long z2);
extern long BRUSH_PlaneMaskForIndex(long index);
extern void ESQIFF_RestoreBasePaletteTriples(void);

extern struct EfBrush *ESQIFF_BrushIniListHead;
extern struct EfBrush *BRUSH_ScriptPrimarySelection;
extern struct EfBrush *BRUSH_ScriptSecondarySelection;
extern struct EfBrush *BRUSH_SelectedNode;
extern struct EfBrush *ESQFUNC_FallbackType3BrushNode;
extern struct EfEntry *TEXTDISP_PrimaryEntryPtrTable[];
extern struct EfEntry *TEXTDISP_SecondaryEntryPtrTable[];
extern struct EfCtx   *WDISP_DisplayContextBase;
extern struct RastPort *Global_REF_RASTPORT_2;

extern short TEXTDISP_ActiveGroupId;
extern short TEXTDISP_CurrentMatchIndex;
extern unsigned char WDISP_PaletteTriplesRBase[];
extern unsigned char ESQFUNC_BasePaletteRgbTriples[];
extern char ESQFUNC_TAG_00[];
extern char ESQFUNC_TAG_11[];

long ESQFUNC_SelectAndApplyBrushForCurrentEntry(short mode)
{
    struct EfBrush *brush;
    struct EfBrush *scriptSel;
    struct EfEntry *entry;
    struct EfWild  *node;
    long found;
    long mask5;
    long maskDepth;
    long i;

    brush = ESQIFF_BrushIniListHead;
    found = 0;

    if (mode == 0)
        scriptSel = BRUSH_ScriptPrimarySelection;
    else
        scriptSel = BRUSH_ScriptSecondarySelection;

    if (scriptSel != 0) {
        found = 1;
        brush = scriptSel;
        goto ensureFallback;
    }

    if (TEXTDISP_ActiveGroupId == 1)
        entry = TEXTDISP_PrimaryEntryPtrTable[TEXTDISP_CurrentMatchIndex];
    else
        entry = TEXTDISP_SecondaryEntryPtrTable[TEXTDISP_CurrentMatchIndex];

    if (STRING_CompareN(entry->tag, ESQFUNC_TAG_00, 2L) == 0) {
        brush = BRUSH_SelectedNode;
        found = 1;
        goto ensureFallback;
    }

    if (STRING_CompareN(entry->tag, ESQFUNC_TAG_11, 2L) == 0) {

wildcardScan:
        if (brush == 0)
            goto fallbackType3;
        if (found)
            goto fallbackType3;

        node = brush->wild;

        while (node != 0 && !found) {
            if (ESQ_WildcardMatch(entry->name, node) == 0)
                found = 1;
            node = node->link;
        }

        if (!found)
            brush = brush->next;

        goto wildcardScan;

fallbackType3:
        if (!found && (entry->b27 & 0x10)
            && ESQFUNC_FallbackType3BrushNode != 0) {
            found = 1;
            brush = ESQFUNC_FallbackType3BrushNode;
        }
        goto ensureFallback;
    }

tagScan:
    if (brush == 0)
        goto ensureFallback;
    if (found)
        goto ensureFallback;

    if (STRING_CompareN(entry->tag, brush->tag, 2L) == 0)
        found = 1;

    if (!found)
        brush = brush->next;

    goto tagScan;

ensureFallback:
    if (!found)
        brush = BRUSH_SelectedNode;

    SetRast(Global_REF_RASTPORT_2, 31L);
    SetRast(&WDISP_DisplayContextBase->rp, 31L);

    if (brush != 0 && (BRUSH_SelectedNode != 0 || found))
        BRUSH_SelectBrushSlot(
            brush, 0L, 0L, (long)WDISP_DisplayContextBase->w2 - 1,
            (long)WDISP_DisplayContextBase->w4 - 1, Global_REF_RASTPORT_2, 0L);

    if (brush == 0) {
        ESQIFF_RestoreBasePaletteTriples();
        return 1;
    }

    if (brush->mode328 == 0 || brush->mode328 == 1 || brush->mode328 == 3) {

        mask5 = BRUSH_PlaneMaskForIndex(5L);
        mask5 = (mask5 << 2) - mask5;

        maskDepth = BRUSH_PlaneMaskForIndex((long)brush->b184);
        maskDepth = (maskDepth << 2) - maskDepth;

        for (i = 0; i < maskDepth && i < mask5; i++)
            WDISP_PaletteTriplesRBase[i] = brush->palette[i];
    }

    if (brush->mode328 == 1) {
        ESQIFF_RestoreBasePaletteTriples();
        return 1;
    }

    if (brush->mode328 == 3) {
        for (i = 0; i < 12; i++)
            WDISP_PaletteTriplesRBase[i] = ESQFUNC_BasePaletteRgbTriples[i];
    }

    return 1;
}
