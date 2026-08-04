/* RESTORES: BRUSH_FreeBrushList
 * MODULE:   modules/groups/a/a/brush.s
 * STATUS:   behavioural
 *
 * 226 bytes in the original, 216 emitted, 7 differing regions.
 *
 * Reproduces: the guard that returns without touching the head when the list is
 * already empty, the outer walk that caches the next pointer BEFORE freeing the
 * node, the inner raster loop bounded by the byte count at +184 and indexing the
 * plane array at +144, the nested sub-list walk at +364 freeing 12-byte nodes
 * through their own next pointer at +8, the three distinct source-line constants
 * (549, 561, 567), and the head being rewritten from whatever the walk stopped on.
 *
 * The mode parameter is a single-step flag: when it is 1 the outer loop breaks
 * after one brush, so the head is left pointing at the remainder rather than
 * NULL. That is why the head assignment sits outside the loop and uses the walk
 * variable rather than a literal zero -- writing `*head = 0` would be wrong for
 * mode 1 and is the obvious way to get this function subtly incorrect.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffec                   LINK.W A5,#-20
 *   got:     514f                       SUBQ.W #4,A7
 *   summary: The A5-frame class. Four pointer locals stay in registers for
 *            SAS/C, which is the whole -10.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the three cross-unit calls.
 */
extern void GRAPHICS_FreeRaster(char *who, long line, void *p,
                                                long w, long h);
extern void MEMORY_DeallocateMemory(char *who, long line, void *p,
                                                    long size);
extern char Global_STR_BRUSH_C_5[];
extern char Global_STR_BRUSH_C_6[];
extern char Global_STR_BRUSH_C_7[];

void BRUSH_FreeBrushList(unsigned char **head, long mode)
{
    unsigned char *next;
    unsigned char *node;
    unsigned char *brush;
    unsigned char *nextBrush;
    register long i;

    next = 0;
    node = 0;

    if (*head == 0)
        return;

    brush = *head;
    while (brush) {
        nextBrush = *(unsigned char **)(brush + 368);

        for (i = 0; i < brush[184]; i++)
            GRAPHICS_FreeRaster(Global_STR_BRUSH_C_5, 549,
                                                ((void **)(brush + 144))[i],
                                                (long)*(short *)(brush + 176),
                                                (long)*(short *)(brush + 178));

        node = *(unsigned char **)(brush + 364);
        while (node) {
            next = *(unsigned char **)(node + 8);
            MEMORY_DeallocateMemory(Global_STR_BRUSH_C_6, 561, node, 12);
            node = next;
        }

        MEMORY_DeallocateMemory(Global_STR_BRUSH_C_7, 567, brush, 372);
        brush = nextBrush;

        if (mode == 1)
            break;
    }

    *head = brush;
}
