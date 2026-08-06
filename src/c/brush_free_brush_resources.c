/* RESTORES: BRUSH_FreeBrushResources
 * MODULE:   modules/groups/a/a/brush.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: stack-local-pointer
 *   ref:     4e55fff82f0b266d000842adfffc2b53fff84aadfff8672a206dfff82b6800eafffc487800ee2f08487803774879000002044eba6cd64fef00102b6dfffcfff860d04293265f4e5d4e75
 *   got:     48e700342a6f001097cb2455200a6720266a00ea487800ee2f0a48780377487900000000610000004fef0010244b60dc42954cdf2c004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct BrushRes { char pad[234]; struct BrushRes *next; };
struct BrushResHead { struct BrushRes *first; };
extern void MEMORY_DeallocateMemory(char *who, long line, void *p, long size);
void BRUSH_FreeBrushResources(struct BrushResHead *h)
{
    struct BrushRes *next = 0;
    struct BrushRes *cur  = h->first;

    while (cur != 0) {
        next = cur->next;
        MEMORY_DeallocateMemory("BRUSH.c", 887, cur, 238);
        cur = next;
    }
    h->first = 0;
}
