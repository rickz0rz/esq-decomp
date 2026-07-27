/* RESTORES: COI_FreeSubEntryTableEntries
 * MODULE:   modules/groups/a/e/coi.s
 * STATUS:   behavioural
 *
 * 220 bytes in the original and 220 emitted, with only SEVEN differing regions.
 *
 * Unlike the three earlier size coincidences in this directory
 * (ed_handle_edit_attributes_menu.c at 29 regions, esqiff2_show_attention_
 * overlay.c at 19, script_save_ctrl_context_snapshot.c at 22), here the size and
 * the structure genuinely agree -- the only divergences are the frame and the
 * register allocation. That is the distinction the region count exists to make.
 *
 * Reproduces: the null-context guard producing a null entry rather than an early
 * return, the per-slot loop that zeroes the flag word, releases all six owned
 * strings through ReplaceOwnedString(0, ...) with each result stored back, and
 * clears the trailing long; the count-guarded teardown of the table itself
 * through both the buffer-array release and the memory deallocation; and the
 * count/table clears that happen unconditionally afterwards.
 *
 * The sub-entry struct is 30 bytes -- a short flag then six owned char pointers
 * then a long -- which the PEA 30.W passed to SCRIPT_DeallocateBufferArray
 * independently confirms. The stride the code frees by and the layout the field
 * offsets imply agree exactly, which is a useful cross-check when reconstructing
 * a struct from offsets alone.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff4                   LINK.W A5,#-12
 *   got:     (none)                     MOVEM only
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the eight cross-unit calls.
 */
struct SubEntry {          /* 30 bytes -- confirmed by the PEA 30.W below */
    short flag;            /*  0 */
    char *name;            /*  2 */
    char *city;            /*  6 */
    char *order;           /* 10 */
    char *price;           /* 14 */
    char *tele;            /* 18 */
    char *event;           /* 22 */
    long  tail;            /* 26 */
};

struct CoiEntry {
    char pad[36];
    short count;                 /* 36 */
    struct SubEntry **table;     /* 38 */
};

extern char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(char *newstr, char *old);
extern void  GROUP_AE_JMPTBL_SCRIPT_DeallocateBufferArray(void *table, long stride,
                                                          long count);
extern void  GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(char *who, long line, void *p,
                                                     long size);
extern char Global_STR_COI_C_4[];

void COI_FreeSubEntryTableEntries(unsigned char *ctx)
{
    struct CoiEntry *e;
    struct SubEntry *sub;
    register short i;

    if (ctx)
        e = *(struct CoiEntry **)(ctx + 48);
    else
        e = 0;
    if (e == 0)
        return;

    for (i = 0; i < e->count; i++) {
        sub = e->table[i];
        sub->flag  = 0;
        sub->name  = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, sub->name);
        sub->city  = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, sub->city);
        sub->order = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, sub->order);
        sub->price = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, sub->price);
        sub->tele  = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, sub->tele);
        sub->event = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, sub->event);
        sub->tail  = 0;
    }

    if (e->count) {
        GROUP_AE_JMPTBL_SCRIPT_DeallocateBufferArray(e->table, 30, (long)e->count);
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_COI_C_4, 876, e->table,
                                                (long)e->count * 4);
    }

    e->count = 0;
    e->table = 0;
}
