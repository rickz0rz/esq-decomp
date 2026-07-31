/* RESTORES: LOCAVAIL_FreeResourceChain
 * MODULE:   modules/groups/a/y/locavail_p0.s
 * STATUS:   behavioural
 *
 * Drops a reference on a shared node array and, when the last one goes, frees
 * the array and every node in it. The state struct is reset either way.
 *
 * The refcount is the FIRST longword of the node array, and the decrement is
 * guarded: TST.L (A0) / BLE skips the SUBQ, so a count already at zero or below
 * is not driven further negative.
 *
 * The free only happens when FOUR things hold -- the array exists, the data
 * array exists, the count is positive, and the refcount has reached ZERO. The
 * refcount is RE-READ for that last test (MOVEA.L 16(A3),A0 / TST.L (A0)),
 * after the decrement, which is what makes it the last-reference check.
 *
 * The reset call runs on every path including the early ones, so the struct is
 * always left clean.
 *
 * The node stride is 10 and goes through the 32-bit multiply helper both in the
 * per-node loop and in the total size passed to the free.
 *
 * The struct layout is the one locavail_alloc_node_arrays_for_state.c derived:
 * a packed long count at +2, the node array at +16 and the data array at +20.
 *
 * 162 ref vs 168 got. The guarded decrement, all four guards, the PEA 4 and
 * PEA 164 sizes, both line numbers (159, 164), both LEA 16(A7),A7 cleanups, the
 * per-node loop and the reset call match in kind and size.
 *
 * SASC-MISMATCH: mul32-helper-vs-inline
 *   ref:     720a 4eba2236 / 720a 4eba0ebe    MOVEQ #10,D1 / JSR MATH_Mulu32
 *   got:     e580 d087 d080 / 2200 e581 d280 d281
 *                                             ASL/ADD chains
 *   summary: both * 10 sites go to the helper in the original and are
 *            strength-reduced inline by 6.51 -- 10 = (4 + 1) * 2. Same product,
 *            and the two sites are most of the 6 bytes.
 *   scope:   program-wide. docs/compiler-version.md, "Arithmetic: three more
 *            classes".
 *   retest:  a compiler that emits a helper call for a 32-bit constant multiply.
 */
struct LocavailState {
    char  pad0[2];
    long  count;                /* +2, 2-byte aligned */
    char  pad6[10];
    long *nodes;                /* +16, first long is the refcount */
    char *data;                 /* +20 */
};

extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(char *who, long line,
                                                   void *p, long size);
extern void LOCAVAIL_FreeNodeAtPointer(char *node);
extern void LOCAVAIL_ResetFilterStateStruct(struct LocavailState *s);

extern char Global_STR_LOCAVAIL_C_2[];
extern char Global_STR_LOCAVAIL_C_3[];

void LOCAVAIL_FreeResourceChain(struct LocavailState *s)
{
    long i;

    if (s == 0)
        return;

    if (s->nodes != 0) {
        if (*s->nodes > 0)
            (*s->nodes)--;

        if (s->data != 0 && s->count > 0 && *s->nodes == 0) {

            NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_LOCAVAIL_C_2,
                                                   159L, s->nodes, 4L);

            for (i = 0; i < s->count; i++)
                LOCAVAIL_FreeNodeAtPointer(s->data + i * 10);

            NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_LOCAVAIL_C_3,
                                                   164L, s->data,
                                                   s->count * 10);
        }
    }

    LOCAVAIL_ResetFilterStateStruct(s);
}
