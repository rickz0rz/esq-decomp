/* RESTORES: GCOMMAND_ShiftBannerCopperRowsDead
 * MODULE:   modules/groups/a/u/gcommand3b_p2_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: folded-index-arithmetic
 *   ref:     4e55fff048e733002b7c00002da8fffc2b7c00004168fff87e007010be806c0000a02c0752862007eb802206eb81206dfffc2401068200000086260006830000008631b028003800240106820000008a260006830000008a31b028003800240106820000008e260006830000008e31b028003800206dfff82401068200000086260006830000008631b028003800240106820000008a260006830000008a31b028003800240106820000008e260006830000008e31b02800380052876000ff5c2c39000068b62007eb802206eb81206dfffc24010682000002ea260006830000008631b02800380024010682000002ee260006830000008a31b02800380024010682000002f2260006830000008e31b028003800206dfff824010682000002ea260006830000008631b02800380024010682000002ee260006830000008a31b02800380024010682000002f2260006830000008e31b0280038004cdf00cc4e5d4e75
 *   got:     48e70f364bf90000000047f9000000007e007010be806c5e200752802c002a07eb852806eb84204dd1c543e80086244dd5c44dea0086329643e8008a4dea008a329643e8008e41ea008e3290204bd1c543e80086244bd5c44dea0086329643e8008a4dea008a329643e8008e41ea008e32902e00609c2c39000000002a07eb852806eb84204dd1c543e80086244dd5c44dea02ea329643e8008a4dea02ee329643e8008e41ea02f23290204bd1c543e80086244bd5c44dea02ea329643e8008a4dea02ee329643e8008e41ea02f232904cdf6cf04e754e71
 *   summary: 216 got vs 354 ref, 138 bytes short, and the whole deficit is address arithmetic. The original recomputes both copper offsets into D2 and D3 with a full ADDI.L per word copy -- eighteen bytes a site, twelve sites -- and reloads each list base from its A5 frame slot; 6.51 materialises the base plus row offset once per list and reaches the three words through (d16,An) displacements. The block is unreferenced in the original too; the disassembly marks it dead and left it unlabelled, which is why refbytes.py read it as the tail of _GCOMMAND_ClearBannerQueue until this pass gave it a name. The sixteen-row shift, both copper lists, all three word offsets per row and the phase-indexed final row match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char ESQ_CopperListBannerA[];
extern char ESQ_CopperListBannerB[];
extern long GCOMMAND_BannerPhaseIndexCurrent;

void GCOMMAND_ShiftBannerCopperRowsDead(void)
{
    char *listA;
    char *listB;
    long  row;
    long  next;
    long  dst;
    long  src;

    listA = ESQ_CopperListBannerA;
    listB = ESQ_CopperListBannerB;

    row = 0;
    while (row < 16) {
        next = row + 1;
        dst = row << 5;
        src = next << 5;

        *(short *)(listA + dst + 0x86) = *(short *)(listA + src + 0x86);
        *(short *)(listA + dst + 0x8a) = *(short *)(listA + src + 0x8a);
        *(short *)(listA + dst + 0x8e) = *(short *)(listA + src + 0x8e);

        *(short *)(listB + dst + 0x86) = *(short *)(listB + src + 0x86);
        *(short *)(listB + dst + 0x8a) = *(short *)(listB + src + 0x8a);
        *(short *)(listB + dst + 0x8e) = *(short *)(listB + src + 0x8e);

        row++;
    }

    next = GCOMMAND_BannerPhaseIndexCurrent;
    dst = row << 5;
    src = next << 5;

    *(short *)(listA + dst + 0x86) = *(short *)(listA + src + 0x2ea);
    *(short *)(listA + dst + 0x8a) = *(short *)(listA + src + 0x2ee);
    *(short *)(listA + dst + 0x8e) = *(short *)(listA + src + 0x2f2);

    *(short *)(listB + dst + 0x86) = *(short *)(listB + src + 0x2ea);
    *(short *)(listB + dst + 0x8a) = *(short *)(listB + src + 0x2ee);
    *(short *)(listB + dst + 0x8e) = *(short *)(listB + src + 0x2f2);
}
