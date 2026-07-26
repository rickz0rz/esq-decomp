/* RESTORES: BRUSH_FindType3Brush
 * MODULE:   modules/groups/a/a/brush.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: stack-local-pointer
 *   ref:     4e55fff848e70110266d00082b53fffc7e004aadfffc671e4a87661a7003206dfffcb028002066027e014a8766e42b680170fffc60dc4a876706206dfffc600291c820084cdf08804e5d4e75
 *   got:     48e701142a6f001026557e00200b671a4a8766167003b02b002066027e014a8766ea204b2668017060e24a87660297cb200b4cdf28804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct BrushNode { char pad[32]; unsigned char type; char pad2[335]; struct BrushNode *next; };
struct BrushHead { struct BrushNode *first; };

struct BrushNode *BRUSH_FindType3Brush(struct BrushHead *head)
{
    struct BrushNode *p = head->first;
    long found = 0;

    while (p != 0 && !found) {
        if (p->type == 3)
            found = 1;
        if (!found)
            p = p->next;
    }
    if (!found)
        p = 0;
    return p;
}
