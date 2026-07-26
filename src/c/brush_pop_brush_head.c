/* RESTORES: BRUSH_PopBrushHead
 * MODULE:   modules/groups/a/a/brush.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: stack-local-pointer
 *   ref:     4e55fffc4aad0008660642adfffc6018206d00082b680170fffc48780001486d00086100f1dc504f202dfffc4e5d4e75
 *   got:     2f0d4aaf000866049bcd6016206f00082a68017048780001486f000c61000000504f200d2a5f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct BrushNode3 { char pad[368]; struct BrushNode3 *next; };
extern void BRUSH_FreeBrushList(struct BrushNode3 **head, long flag);
struct BrushNode3 *BRUSH_PopBrushHead(struct BrushNode3 *head)
{
    struct BrushNode3 *next;

    if (head == 0) {
        next = 0;
    } else {
        next = head->next;
        BRUSH_FreeBrushList(&head, 1);
    }
    return next;
}
