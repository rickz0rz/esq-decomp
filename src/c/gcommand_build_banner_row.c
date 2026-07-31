/* RESTORES: _GCOMMAND_BuildBannerRow
 * MODULE:   modules/groups/a/u/gcommand3b_p2_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame-and-address-split
 *   ref:     4e55fff448e72f32266d0008246d000c2e2d00102c2d00142a2d0018204a2007eb802248d3c04de902e8220e42414841314102da2248d3c04de902e8200e223c0000ffffc081314002de202b00082400d48542424842314202ca202b0008d085c081314002ce202b000c2400d48542424842314202b6202b000cd085c081314002ba202b00102400d48542424842314202be202b0010d08502800000ffff314002c248ed0100fffc4a876f04200760022006280053844a79000068ac67064a846f00008a2004eb802248d3c04de902ea20390000b26cef8043f90000aa6c2049d1c020390000b274d080d1c03c902b4efff4588e20390000b284ef802049d1c020390000b28cd080d1c03c902b4efff4588e20390000b29cef802049d1c020390000b2a4d080d1c03c902b4efff4588e20390000b2b4ef80d3c020390000b2bcd080d3c03c912b4efff4602e2004eb802248d3c04de902ea303c00f03c802b4efff4588e3c802b4efff4588e3c802b4efff4588e3c802b4efff42f2dfffc6100fdb64ced4cf4ffd44e5d4e75
 *   got:     9efc000c48e727342a2f003c2c2f00382e2f0034266f00302a6f002c203c0000ffff2207eb81204bd1c143e802e841eb02da2209484148c1308141eb02de22092f410024c2803081222d0008d28541eb02ca2401484248c2308241eb02ce2f410024c2803081222d000cd28541eb02b62401484248c2308241eb02ba2f410024c2803081222d0010d28541eb02be2401484248c2308241eb02c22f41002448414241484130812f40001c4a876f062f470020600620062f40002053af0020303900000000672a202f00204a806e222200eb81204bd1c145e802ea323c00f03481588a3481588a3481588a348160000082202f0020eb80204bd1c045e802ea2039000000002200ed81d2b9000000002001d08041f9000000002248d3c03491588a2039000000002200ed81d2b9000000002001d0802248d3c03491588a2039000000002200ed81d2b9000000002001d0802248d3c03491588a2039000000002200ed81d2b9000000002001d080d1c034902f0b61000000584f4cdf2ce4defc000c4e754e71
 *   summary: 388 got vs 396 ref, eight bytes short. The original splits each 32-bit address into copper words with CLR.W / SWAP for the high half and AND.L with a register-held 0xffff for the low half, and recomputes the pointer expression for each half; 6.51 folds one of the recomputations. The four bit-plane pointer splits, the row-pointer split at +730/+734, the preset-versus-default selection with its fallback flag, the four preset lookups scaled by 128 and 2, and the four default 0xf0 writes with their four-byte cursor advance match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct BannerPlanes {
    char pad0[8];
    long plane0;                /* +8 */
    long plane1;                /* +12 */
    long plane2;                /* +16 */
};

extern short GCOMMAND_BannerRowFallbackOnFirstRowFlag;
extern unsigned short GCOMMAND_PresetValueTable[];
extern long GCOMMAND_PresetWorkEntryTable;
extern long GCOMMAND_PresetWorkEntry0_ValueIndex;
extern long GCOMMAND_PresetWorkEntry1;
extern long GCOMMAND_PresetWorkEntry1_ValueIndex;
extern long GCOMMAND_PresetWorkEntry2;
extern long GCOMMAND_PresetWorkEntry2_ValueIndex;
extern long GCOMMAND_PresetWorkEntry3;
extern long GCOMMAND_PresetWorkEntry3_ValueIndex;

extern void GCOMMAND_UpdateBannerRowPointers(char *list);

void GCOMMAND_BuildBannerRow(struct BannerPlanes *planes, char *list, long row,
                             long altRow, long bias)
{
    unsigned short *cursor;
    long addr;
    long index;
    long mask;

    mask = 0xffff;

    addr = (long)(list + (row << 5) + 744);
    *(unsigned short *)(list + 730) = (unsigned short)(addr >> 16);
    addr = (long)(list + (row << 5) + 744);
    *(unsigned short *)(list + 734) = (unsigned short)(addr & mask);

    addr = planes->plane0 + bias;
    *(unsigned short *)(list + 714) = (unsigned short)(addr >> 16);
    addr = planes->plane0 + bias;
    *(unsigned short *)(list + 718) = (unsigned short)(addr & mask);

    addr = planes->plane1 + bias;
    *(unsigned short *)(list + 694) = (unsigned short)(addr >> 16);
    addr = planes->plane1 + bias;
    *(unsigned short *)(list + 698) = (unsigned short)(addr & mask);

    addr = planes->plane2 + bias;
    *(unsigned short *)(list + 702) = (unsigned short)(addr >> 16);
    addr = planes->plane2 + bias;
    *(unsigned short *)(list + 706) = (unsigned short)(addr & 0xffff);

    if (row > 0)
        index = row;
    else
        index = altRow;
    index--;

    if (GCOMMAND_BannerRowFallbackOnFirstRowFlag != 0 && index <= 0) {
        cursor = (unsigned short *)(list + (index << 5) + 746);
        *cursor = 0xf0;
        cursor += 2;
        *cursor = 0xf0;
        cursor += 2;
        *cursor = 0xf0;
        cursor += 2;
        *cursor = 0xf0;
    } else {
        cursor = (unsigned short *)(list + (index << 5) + 746);
        *cursor = GCOMMAND_PresetValueTable[GCOMMAND_PresetWorkEntryTable * 64
                      + GCOMMAND_PresetWorkEntry0_ValueIndex];
        cursor += 2;
        *cursor = GCOMMAND_PresetValueTable[GCOMMAND_PresetWorkEntry1 * 64
                      + GCOMMAND_PresetWorkEntry1_ValueIndex];
        cursor += 2;
        *cursor = GCOMMAND_PresetValueTable[GCOMMAND_PresetWorkEntry2 * 64
                      + GCOMMAND_PresetWorkEntry2_ValueIndex];
        cursor += 2;
        *cursor = GCOMMAND_PresetValueTable[GCOMMAND_PresetWorkEntry3 * 64
                      + GCOMMAND_PresetWorkEntry3_ValueIndex];
    }

    GCOMMAND_UpdateBannerRowPointers(list);
}
