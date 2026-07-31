/* RESTORES: GCOMMAND_SeedBannerFromPrefs
 * MODULE:   modules/groups/a/u/gcommand3b_p4_p0.s
 * STATUS:   behavioural
 *
 * Builds the banner tables and then seeds the first four bytes of both copper
 * lists from the configured head byte.
 *
 * The two constants are written as they appear rather than as their unsigned
 * spellings: MOVEQ #-39 and MOVEQ #-2. Writing 0xD9 and 0xFFFE would compile to
 * the same bytes here but would misdescribe what the original loads.
 *
 * The head byte is read with MOVE.W, so CONFIG_BannerCopperHeadByte is a short,
 * and only its low byte reaches the copper list.
 *
 * The original parks each list address in a frame local and reloads it
 * (MOVE.L #list,-4(A5) / MOVEA.L -4(A5),A0) rather than keeping it in the
 * address register it just built. That is the reserved-A5 spill class, not
 * something the source asks for.
 *
 * 92 ref vs 80 got. The three argument pushes, the MOVEQ #-39, the MOVEQ #-2
 * and all six field stores match in kind and size.
 *
 * SASC-MISMATCH: address-through-frame-vs-register
 *   ref:     2b7c00002da8fffc 206dfffc   MOVE.L #list,-4(A5) / MOVEA.L -4(A5),A0
 *   got:     4bf900000000                LEA list,A5
 *   summary: the original materialises each list address into a FRAME SLOT and
 *            then loads an address register back out of it -- 12 bytes to get a
 *            constant address into a register. 6.51 emits a single LEA, 6
 *            bytes. Twice, which is the whole 12-byte delta.
 *   tried:   nothing from the source side; the C is already a plain pointer
 *            assignment, which is the shape the original compiled from.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct BannerCopperHead {
    unsigned char head;         /* +0 */
    unsigned char second;       /* +1 */
    short         word2;        /* +2 */
};

extern void GCOMMAND_BuildBannerTables(long a, long b, long c);

extern char  ESQ_CopperListBannerA[];
extern char  ESQ_CopperListBannerB[];
extern short CONFIG_BannerCopperHeadByte;

void GCOMMAND_SeedBannerFromPrefs(void)
{
    struct BannerCopperHead *p;

    GCOMMAND_BuildBannerTables(128L, 0x80feL, 0L);

    p = (struct BannerCopperHead *)ESQ_CopperListBannerA;
    p->head   = (unsigned char)CONFIG_BannerCopperHeadByte;
    p->second = (unsigned char)-39;
    p->word2  = -2;

    p = (struct BannerCopperHead *)ESQ_CopperListBannerB;
    p->head   = (unsigned char)CONFIG_BannerCopperHeadByte;
    p->second = (unsigned char)-39;
    p->word2  = -2;
}
