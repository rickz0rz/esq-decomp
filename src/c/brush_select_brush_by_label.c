/* RESTORES: BRUSH_SelectBrushByLabel
 * MODULE:   modules/groups/a/a/brush_p3_p1.s
 * STATUS:   behavioural
 *
 * Picks a brush node by a two-character alias code, falling back to the dither
 * brush when nothing matches.
 *
 * The label is copied into BRUSH_LabelScratch on entry with an inline strcpy,
 * and that copy is never read again in this function -- it is a side effect the
 * rest of the subsystem depends on, not working storage.
 *
 * The alias code is chosen by TWO negative tests: if the label starts with
 * neither "00" nor "11", the first two characters of the label ARE the code;
 * otherwise the code is the literal "DT". Reading either compare the wrong way
 * round selects the fallback for exactly the labels that should not get it.
 *
 * The scratch code is a 2-character copy plus an explicit terminator at [2],
 * which is the CLR.B at -5(A5).
 *
 * The list walk compares at offset 0x21 of each node -- not 0 -- and follows
 * the +368 link, the same link field brush_populate_brush_list.c builds.
 *
 * The fallback runs only when the walk selected nothing, and its result is
 * stored to THREE globals: the selection itself and the two script-visible
 * copies, both taken from a single reload of the first.
 *
 * 242 ref vs 256 got. Both alias compares with their PEA 2 lengths, the
 * CopyPadNul on both arms, the CLR.B terminator, the ADDA.W #$21 field offset,
 * the list compare, the +368 link follow, the fallback call and all three
 * result stores match in kind and size.
 *
 * SASC-MISMATCH: loop-shape
 *   ref:     ... 60c8              one BRA back to the loop head, with the
 *                                  match arm falling into the advance
 *   got:     ... 6008 204b 26680170 60cc
 *                                  6.51 duplicates the link-follow into both
 *                                  arms and branches from each
 *   summary: the original shares the "advance to the next node" tail between
 *            the match and no-match paths; 6.51 emits it twice. That is most of
 *            the 14 bytes. AGENTS.md records the same lesson from
 *            SCRIPT_HandleBrushCommand -- matching the original SHARING, not
 *            just its arithmetic, was worth 80 bytes there.
 *   tried:   restructuring the loop so the match arm falls through to a single
 *            advance rather than breaking. The C below already does that (the
 *            break follows the advance); 6.51 duplicates it regardless, because
 *            the break target and the loop head differ.
 *   scope:   any search loop with an early exit.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern long  GROUP_AA_JMPTBL_STRING_CompareN(char *a, char *b, long n);
extern void  GROUP_AG_JMPTBL_STRING_CopyPadNul(char *dst, char *src, long n);
extern void *BRUSH_FindBrushByPredicate(char *name, void *head);

struct BrushSelectNode {
    char pad0[0x21];
    char code[2];               /* +0x21 */
    char pad35[333];
    struct BrushSelectNode *link368;    /* +368 */
};

extern struct BrushSelectNode *ESQIFF_BrushIniListHead;
extern struct BrushSelectNode *BRUSH_SelectedNode;
extern void *BRUSH_ScriptPrimarySelection;
extern void *BRUSH_ScriptSecondarySelection;
extern char  BRUSH_LabelScratch[];
extern char  BRUSH_STR_ALIAS_CODE_00[];
extern char  BRUSH_STR_ALIAS_CODE_11[];
extern char  BRUSH_STR_ALIAS_CODE_DT[];
extern char  BRUSH_STR_FALLBACK_DITHER[];

void BRUSH_SelectBrushByLabel(char *label)
{
    struct BrushSelectNode *node;
    char code[3];
    char *src;
    char *dst;

    src = label;
    dst = BRUSH_LabelScratch;
    while ((*dst++ = *src++) != 0)
        ;

    node = ESQIFF_BrushIniListHead;
    BRUSH_SelectedNode = 0;

    if (GROUP_AA_JMPTBL_STRING_CompareN(label, BRUSH_STR_ALIAS_CODE_00, 2L) != 0
        && GROUP_AA_JMPTBL_STRING_CompareN(label, BRUSH_STR_ALIAS_CODE_11, 2L) != 0)
        GROUP_AG_JMPTBL_STRING_CopyPadNul(code, label, 2L);
    else
        GROUP_AG_JMPTBL_STRING_CopyPadNul(code, BRUSH_STR_ALIAS_CODE_DT, 2L);

    code[2] = 0;

    while (node != 0) {
        if (GROUP_AA_JMPTBL_STRING_CompareN(node->code, code, 2L) == 0) {
            BRUSH_SelectedNode = node;
            node = node->link368;
            break;
        }
        node = node->link368;
    }

    if (BRUSH_SelectedNode == 0)
        BRUSH_SelectedNode = BRUSH_FindBrushByPredicate(
            BRUSH_STR_FALLBACK_DITHER, &ESQIFF_BrushIniListHead);

    BRUSH_ScriptPrimarySelection   = BRUSH_SelectedNode;
    BRUSH_ScriptSecondarySelection = BRUSH_SelectedNode;
}
