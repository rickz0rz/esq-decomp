/* RESTORES: _DST_BuildBannerTimeEntry
 * MODULE:   modules/groups/a/j/dst2_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: divide-recomputation
 *   ref:     4e55ffdc48e737303e2d000a1c2d000f266d0010246d001441f900009aa243edffea700422d851c8fffc329070001006323900009ab23b40ffe20c4100ff6d24b24067202401024200ffb440671048c1528174004602c28248c0b081660608ed0000ffe2302dffe27201b0416614343900009ab25342670a342dfff052423b42fff07427be426d04526dffe2303900009aa848c02f00610003a6584f4a406708203c0000016e6006203c0000016d3b40ffdc322dffe2b2406f0e916dffe2302dfff052403b40fff03b6dffe2fffa70003b40fff6220748c15381200172024ebac746701e4ebac78e3b40fff4200748c053804a806a025280e2805a80720c4ebac7263b41fff266063b7c000cfff2200748c053804a806a025280e2805a8072184ebac704700bb2806f0470ff600270003b40fffc302dfff848c02f004878003641edffea2f082f086100f4e24fef00102a001039000028da7259b00166122f052f39000081646100f55e504f48c0600270002f052f39000081603b40ffe06100f546504f72001239000028d9743692823b40ffde48ad0002ffe47401b0426604536dffe4b46dffe06604526dffe4322dffe43681260a67385340660470016002700048c1d2803b41ffe4c3fc0e10da8170001039000028e3723c4ebac698da802f0a2f056100f164504f356dffe0000e4cdf0cec4e5d4e75
 *   got:     9efc002848e737141c2f004f3e2f004a266f00542a6f005041f90000000043ef002a700422d851c8fffc32d83039000000007a001a0648af000100220c4000ff6d3448c072001206b081672a302f002248c072004601c08174001406b0826712302f002248c05280c08172001206b280660408c500007001ba4066143239000000005341670a322f003052413f4100307227be416d02524530390000000048c02f0061000000584f4a4067083f7c016e00406008303c016d3f400040302f0040ba406f0c9a40302f003052403f4000303f45003a426f0036300748c053807202610000002f014878001e61000000504f3f400034300748c053804a806a025280e2805a80720c610000003f41003266063f7c000c0032300748c053804a806a025280e2805a80721861000000700bb2806f083f7cffff003c6004426f003c302f003848c02f004878003641ef00322f082f08610000004fef00101239000000002f40001e7059b20066162f2f001e2f390000000061000000504f3f4000266004426f00262f2f001e2f390000000061000000504f7200123900000000743692823f40002848af000200247401b0426604536f0024b46f00266604526f0024322f00243a81260b675253406606526f002460043f410024302f002448c02200e98192802401e9829481e982d5af001e70001039000000004878003c2f0061000000d1af00262e8b2f2f00266100000041eb000e30af00324fef000c4cdf28ecdefc00284e75
 *   summary: 548 got vs 504 ref. The original divides the slot by 2 once and reuses the quotient for both the month and the overflow test; 6.51 recomputes the whole (slot-1)/2+5 expression at each of the three uses, which is a helper call apiece. The 22-byte clock block is copied through a struct assignment, which is what produces the original's MOVE.L (A0)+,(A1)+ chain. The 255-cursor wrap detection with its three-way match, the leap-year day count, the year rollover, the minute and month derivations, the 11-hour overflow flag, both range classifications, the row adjustment by primary and secondary class, the 3600-second row offset and the variant-code minute offset all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct ClockBlock {
    char  pad0[6];
    short year;                 /* +6 */
    short month;                /* +8 */
    short minute;               /* +10 */
    short hourFlag;             /* +12 */
    short baseDay;              /* +14 */
    short dayOfYear;            /* +16 */
    short overflow;             /* +18 */
    short tail;                 /* +20 */
};

extern struct ClockBlock CLOCK_DaySlotIndex;
extern short WDISP_BannerSlotCursor;
extern short CLOCK_CacheYear;
extern unsigned char ESQ_SecondarySlotModeFlagChar;
extern unsigned char ESQ_STR_6;
extern unsigned char CLOCK_FormatVariantCode;
extern long DST_BannerWindowSecondary;
extern long DST_BannerWindowPrimary;

extern short DATETIME_IsLeapYear(long year);
extern long __asm GROUP_AG_JMPTBL_MATH_DivS32(register __d0 long a,
                        register __d1 long b);
extern long __asm GROUP_AG_JMPTBL_MATH_Mulu32(register __d0 long a,
                        register __d1 long b);
extern long  DATETIME_BuildFromBaseDay(struct ClockBlock *out,
                 struct ClockBlock *in, long mode, long baseDay);
extern short DATETIME_ClassifyValueInRange(long window, long value);
extern void  DATETIME_SecondsToStruct(long seconds, char *out);

void DST_BuildBannerTimeEntry(short slot, unsigned char day, short *outRow,
                              char *outStruct)
{
    struct ClockBlock block;
    short dayOfYear;
    short yearDays;
    short primary;
    short secondary;
    short row;
    short cursor;
    long  base;

    block = CLOCK_DaySlotIndex;

    cursor = WDISP_BannerSlotCursor;
    dayOfYear = day;

    if (cursor >= 0xff && cursor != day
        && ((cursor & 0xff) == day || day == (((long)cursor + 1) & 0xff)))
        dayOfYear |= 1;

    if (dayOfYear == 1 && WDISP_BannerSlotCursor != 1)
        block.year = block.year + 1;

    if (slot >= 39)
        dayOfYear++;

    if (DATETIME_IsLeapYear((long)CLOCK_CacheYear) != 0)
        yearDays = 366;
    else
        yearDays = 365;

    if (dayOfYear > yearDays) {
        dayOfYear -= yearDays;
        block.year = block.year + 1;
    }

    block.dayOfYear = dayOfYear;
    block.hourFlag = 0;
    block.minute = GROUP_AG_JMPTBL_MATH_Mulu32(30,
        ((long)slot - 1) % 2);

    block.month = (((long)slot - 1) / 2 + 5) % 12;
    if (block.month == 0)
        block.month = 12;

    if ((((long)slot - 1) / 2 + 5) % 24 > 11)
        block.overflow = -1;
    else
        block.overflow = 0;

    base = DATETIME_BuildFromBaseDay(&block, &block, 54, (long)block.baseDay);

    if (ESQ_SecondarySlotModeFlagChar == 89)
        secondary = DATETIME_ClassifyValueInRange(DST_BannerWindowSecondary, base);
    else
        secondary = 0;

    primary = DATETIME_ClassifyValueInRange(DST_BannerWindowPrimary, base);

    row = ESQ_STR_6 - 54;
    if (primary == 1)
        row--;
    if (secondary == 1)
        row++;

    *outRow = row;

    if (outStruct == 0)
        return;

    if (primary == 1)
        row = row + 1;
    else
        row = row + 0;

    base += (long)row * 3600;
    base += GROUP_AG_JMPTBL_MATH_Mulu32((long)CLOCK_FormatVariantCode, 60);

    DATETIME_SecondsToStruct(base, outStruct);
    *(short *)(outStruct + 14) = secondary;
}
