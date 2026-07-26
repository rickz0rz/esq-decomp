/* RESTORES: BRUSH_AppendBrushNode
 * MODULE:   modules/groups/a/a/brush.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: stack-local-pointer
 *   ref:     4e55fffc48e70030266d0008246d000c200b6604264a60222b4bfffc206dfffc4aa80170670c206dfffc2b680170fffc60ea206dfffc214a0170200b245f265f4e5d4e75
 *   got:     48e70034266f00142a6f0010200d66042a4b6010244d202a01706704244060f6254b0170200d4cdf2c004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct BrushNode2 { char pad[368]; struct BrushNode2 *next; };

struct BrushNode2 *BRUSH_AppendBrushNode(struct BrushNode2 *head, struct BrushNode2 *node)
{
    struct BrushNode2 *p;

    if (head == 0) {
        head = node;
    } else {
        p = head;
        while (p->next != 0)
            p = p->next;
        p->next = node;
    }
    return head;
}
