/* RESTORES: BRUSH_FindBrushByPredicate
 * MODULE:   modules/groups/a/a/brush.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: stack-local-pointer
 *   ref:     4e55fffc48e70030266d0008246d000c2b52fffc4aadfffc67222f0b2f2dfffc4eba0b1e504f4a806606202dfffc600e206dfffc2b680170fffc60d87000245f265f4e5d4e75
 *   got:     48e70034266f00142a6f00102453200a671a2f0d2f0a61000000504f4a806604200a600a204a2468017060e270004cdf2c004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct Brush4 { char name[1]; char pad[367]; struct Brush4 *next; };
struct Brush4Head { struct Brush4 *first; };
extern long GROUP_AA_JMPTBL_STRING_CompareNoCase(struct Brush4 *a, char *b);
struct Brush4 *BRUSH_FindBrushByPredicate(char *want, struct Brush4Head *h)
{
    struct Brush4 *cur = h->first;

    while (cur != 0) {
        if (GROUP_AA_JMPTBL_STRING_CompareNoCase(cur, want) == 0)
            return cur;
        cur = cur->next;
    }
    return 0;
}
