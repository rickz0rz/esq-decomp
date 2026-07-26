/* RESTORES: BRUSH_NormalizeBrushNames
 * MODULE:   modules/groups/a/a/brush.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: stack-local-pointer
 *   ref:     4e55ffd848e70030266d00082b53fffc4aadfffc6732206dfffc2b48fff8224845edffd814d966fc486dffd84eba0994584f2040226dfffc12d866fc206dfffc2b680170fffc60c8245f265f4e5d4e75
 *   got:     9efc002c48e700342a6f003c2655200b6742244b41ef00102f48000c206f000c52af000c101a10804a0066f0486f0010610000002440584f2f4b000c206f000c52af000c101a10804a0066f0204b2668017060ba4cdf2c00defc002c4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct Brush5 { char name[1]; char pad[367]; struct Brush5 *next; };
struct Brush5Head { struct Brush5 *first; };
extern char *GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator(char *s);
void BRUSH_NormalizeBrushNames(struct Brush5Head *h)
{
    char scratch[40];
    struct Brush5 *cur = h->first;
    char *s, *d;

    while (cur != 0) {
        s = cur->name;
        d = scratch;
        while ((*d++ = *s++) != 0)
            ;
        s = GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator(scratch);
        d = cur->name;
        while ((*d++ = *s++) != 0)
            ;
        cur = cur->next;
    }
}
