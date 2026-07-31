/* RESTORES: NEWGRID_ShouldOpenEditor
 * MODULE:   modules/groups/b/a/newgrid_p4.s
 * STATUS:   behavioural
 *
 * Answers whether the editor should open for an entry: both of its text fields
 * must be empty once leading class-3 characters are skipped, and bit 5 of the
 * byte at +27 must be set.
 *
 * "Empty" here means EITHER the skip helper returned null OR it returned a
 * pointer to a NUL. The original tests both, separately, for each field:
 * TST.L the saved pointer, and only if non-zero does it TST.B what it points
 * at. Collapsing that to a single `*p == 0` would dereference null.
 *
 * The two fields are at +19 and +1 of the entry, and the +19 one is skipped
 * FIRST -- the original passes 19(A3) to the first call and 1(A3) to the
 * second. The order matters if the helper has any state.
 *
 * The original parks both results in frame slots across the second call, which
 * is the reserved-A5 spill class.
 *
 * 106 ref vs 84 got -- the restoration is 22 bytes SMALLER, and all 22 are the
 * reserved-A5 spill class. The two LEA field addresses, both skip calls, the
 * argument-slot reuse (2e88), the ADDQ.W #4,A7, both null-then-byte guard
 * pairs and the BTST #5 all match in kind.
 *
 * SASC-MISMATCH: results-through-frame-vs-register
 *   ref:     2b48fff4 2b40fff4 2b48fff8 2b40fff8 4aadfff4 206dfff4
 *            six frame stores and reloads, plus LINK.W A5,#-12 / UNLK
 *   got:     2640 2440 200b 4a13 200a 4a12
 *            both results kept in address registers throughout
 *   summary: the original writes each skip result into a frame slot and reads
 *            it back to test it -- and writes the FIRST slot twice, once with
 *            the argument address and once with the result. 6.51 keeps both in
 *            registers, so the frame, the six stores and the reloads all
 *            disappear.
 *   tried:   nothing from the source side. Forcing the spills would mean
 *            writing C aimed at defeating the register allocator, which is what
 *            the ESQ_EXACT arm exists for and is not justified here -- the
 *            function is cross-unit and capped at behavioural anyway.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct NewGridEditorEntry {
    char          pad0;
    char          text1[18];    /* +1 */
    char          text19[8];    /* +19 */
    unsigned char flags27;      /* +27 */
};

extern char *NEWGRID2_JMPTBL_STR_SkipClass3Chars(char *s);

long NEWGRID_ShouldOpenEditor(struct NewGridEditorEntry *e)
{
    char *a, *b;
    long  r = 0;

    if (e == 0)
        return r;

    a = NEWGRID2_JMPTBL_STR_SkipClass3Chars(e->text19);
    b = NEWGRID2_JMPTBL_STR_SkipClass3Chars(e->text1);

    if ((a == 0 || *a == 0) && (b == 0 || *b == 0) && (e->flags27 & 0x20))
        r = 1;
    else
        r = 0;

    return r;
}
