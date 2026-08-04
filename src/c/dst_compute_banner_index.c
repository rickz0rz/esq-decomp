/* RESTORES: DST_ComputeBannerIndex
 * MODULE:   modules/groups/a/j/dst2_p1_p1.s
 * STATUS:   behavioural
 *
 * Builds a banner time entry, then folds four fields of the record down to a
 * single 1..48 banner slot.
 *
 * The arithmetic is a chain and every step is read off the instructions:
 *
 *   v  = record->f8 % 12          MATH_DivS32, the REMAINDER in D1
 *   v += (record->f18 != 0) ? 12 : 0
 *   v += v                        ADD.L D1,D1
 *   v += (record->f10 > 29) ? 1 : 0   CMPI.W #$1d / SGT / NEG.B
 *   n  = (v != 0) ? 1 : 0
 *   return ((n + 0x26) % 48) + 1
 *
 * Two things there are easy to get wrong. The divide by 12 takes the REMAINDER,
 * not the quotient -- the original moves D1, which is where the register-
 * argument helper leaves it. And the whole chain collapses to a ZERO-OR-ONE
 * before the final modulo, so everything above only decides whether the answer
 * is index 39 or index 40. That looks like a lot of work for one bit, and it is
 * what the bytes say.
 *
 * SGT followed by NEG.B is the booleanize idiom: SGT writes 0xFF and NEG.B
 * turns it into +1, so the C comparison operator is the right spelling.
 *
 * The final divide is DIVS #$30 followed by SWAP, a 16-BIT divide taking the
 * remainder, so the value is a short at that point.
 *
 * 128 ref vs 128 got, and the arithmetic chain is where the confidence comes
 * from rather than the equal size. The MOVEQ #12 divisor, the 12-or-0 select
 * (700c 6002 7000), the CMPI.W #$1d / SGT / NEG.B / EXT.W / EXT.L booleanize,
 * the 1-or-0 select, the ADDI.W #$26 and the DIVS #$30 / SWAP / ADDQ.W #1 tail
 * all match VERBATIM.
 *
 * SASC-MISMATCH: register-argument-helper-vs-operator
 *   ref:     720c 4ebac5c2      MOVEQ #12,D1 / JSR MATH_DivS32(PC)
 *   got:     720c 61000000      the same, calling SAS/C 6.51 own helper
 *   summary: the remainder comes back in D1 from the register-argument helper;
 *            written with % because a C return value cannot reach D1.
 *   scope:   program-wide. See tliba3_get_view_mode_height.c.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55fffc ... 4e5d     LINK.W A5,#-4 / UNLK
 *   got:     594f ... 584f         SUBQ.W #4,A7 / ADDQ.W #4,A7
 *   summary: the frame class, plus the usual A3/A5 allocation difference in the
 *            parameter loads. The two cancel against the extra register moves
 *            6.51 needs, which is why the totals agree.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  a compiler that reserves A5; the same doc gives the probe.
 */
struct DstBannerRecord {
    char  pad0[8];
    short f8;                   /* +8  */
    short f10;                  /* +10 */
    char  pad12[6];
    short f18;                  /* +18 */
};

extern void DST_BuildBannerTimeEntry(long a, long b, short *out,
                                     struct DstBannerRecord *rec);

long DST_ComputeBannerIndex(struct DstBannerRecord *rec, short a,
                            unsigned char b)
{
    short slot;
    long  v;
    short n;

    DST_BuildBannerTimeEntry((long)a, (long)b, &slot, rec);

    v  = ((long)rec->f8 - ((long)rec->f8 / 12) * 12);
    v += (rec->f18 != 0) ? 12 : 0;
    v += v;
    v += (rec->f10 > 29) ? 1 : 0;

    n = (v != 0) ? 1 : 0;
    n += 0x26;

    return (long)(short)((n - (n / 48) * 48) + 1);
}
