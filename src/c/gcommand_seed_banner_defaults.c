/* RESTORES: GCOMMAND_SeedBannerDefaults
 * MODULE:   modules/groups/a/u/gcommand3b_p4_p0.s
 * STATUS:   behavioural
 *
 * Builds the banner tables with the default parameters and seeds SIX bytes of
 * each copper list: a three-field header at the start and the same shape again
 * at +3916.
 *
 * The two headers are not identical. The first byte differs (31 at the head,
 * -8 at the tail) while the other two fields are the same (-39 and -2), which
 * is why the original keeps -39 in D1 and -2 in D2 across all four stores and
 * only reloads the first byte.
 *
 * All four constants are written as they appear -- MOVEQ #31, #-39, #-2, #-8 --
 * rather than as unsigned spellings. Writing 0xD9 or 0xFFFE would compile the
 * same and misdescribe what the original loads.
 *
 * Both offsets come off ONE base register in the original (displacements 0, 1,
 * 2, 3916, 3917, 3918), so the struct below carries both headers rather than
 * being applied twice at different addresses. That keeps the accesses as
 * (d16,An) displacements, which is the shape AGENTS.md records for struct
 * member access.
 *
 * 112 ref vs 96 got. All six field stores per list match exactly, including the
 * shared registers -- 72d9 (-39) and 74fe (-2) are loaded once and used four
 * times each in both, and the displacements 0f4c / 0f4d / 0f4e confirm the
 * single-base struct is the right modeling.
 *
 * SASC-MISMATCH: address-through-frame-vs-register
 *   ref:     2b7c00002da8fffc 206dfffc   MOVE.L #list,-4(A5) / MOVEA.L -4(A5),A0
 *   got:     4bf900000000                LEA list,A5
 *   summary: the original materialises each list address into a FRAME SLOT and
 *            loads an address register back out of it -- 12 bytes to get a
 *            constant address into a register, where 6.51 emits a 6-byte LEA.
 *            Twice, which with the frame is the whole 16-byte delta. Identical
 *            to the item in gcommand_seed_banner_from_prefs.c, which is the
 *            sibling seeding routine.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct BannerCopperList {
    unsigned char head;         /* +0    */
    unsigned char headSecond;   /* +1    */
    short         headWord;     /* +2    */
    char          pad4[3912];
    unsigned char tail;         /* +3916 */
    unsigned char tailSecond;   /* +3917 */
    short         tailWord;     /* +3918 */
};

extern void GCOMMAND_BuildBannerTables(long a, long b, long c);
extern char ESQ_CopperListBannerA[];
extern char ESQ_CopperListBannerB[];

void GCOMMAND_SeedBannerDefaults(void)
{
    struct BannerCopperList *p;

    GCOMMAND_BuildBannerTables(32L, 0xfffeL, 1L);

    p = (struct BannerCopperList *)ESQ_CopperListBannerA;
    p->head       = 31;
    p->headSecond = (unsigned char)-39;
    p->headWord   = -2;
    p->tail       = (unsigned char)-8;
    p->tailSecond = (unsigned char)-39;
    p->tailWord   = -2;

    p = (struct BannerCopperList *)ESQ_CopperListBannerB;
    p->head       = 31;
    p->headSecond = (unsigned char)-39;
    p->headWord   = -2;
    p->tail       = (unsigned char)-8;
    p->tailSecond = (unsigned char)-39;
    p->tailWord   = -2;
}
