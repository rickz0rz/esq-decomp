/* RESTORES: ESQ_PackBitsDecode
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 *
 * ByteRun1 (PackBits) decoder: a non-negative control byte n means copy n+1
 * literal bytes, a negative one means repeat the next byte 1-n times. Stops as
 * soon as the output count reaches the limit, mid-run if necessary, and returns
 * how far it got through the source.
 *
 * The 0xFF special case is DEAD CODE and is reproduced as such. The original
 * sign-extends the control byte to a long and compares it with 255, which a
 * sign-extended byte can never equal -- 0xFF extends to -1. The standard PackBits
 * no-op code is -128, so this looks like the wrong constant, and the branch has
 * never been taken in any run of the shipped program. Written as `n == 255` it
 * compiles to the same never-taken test.
 *
 * 96 bytes in the original, 98 emitted plus one alignment NOP.
 *
 * SASC-MISMATCH: arg-load-width
 *   ref:     202f000c   MOVE.L 12(A7),D0 for the limit
 *   got:     a word load of the same slot
 *   summary: `limit` is declared `short` because every comparison against it in
 *            the original is CMP.W. Declaring it `long` makes this one load match
 *            and turns all six comparisons into CMP.L, which is the worse trade --
 *            the same decision as esq_clamp_banner_char_range.c, and for the same
 *            reason.
 *
 * SASC-MISMATCH: constant-materialisation
 *   ref:     0c87000000ff   CMPI.L #255,D7
 *   got:     7000 4600 ba80 MOVEQ #0,D0 / NOT.B D0 / CMP.L D0,D5
 *   summary: Worth recording because it is BACKWARDS from the documented rule.
 *            255 is the canonical ~n case and the table in
 *            docs/compiler-version.md lists the original taking the four-byte
 *            NOT.B form for it -- but here the original spends six bytes on the
 *            immediate and 6.51 takes the short form. Combined with
 *            gcommand_compute_preset_increment.c, where the same pair went the
 *            other way, the pattern is that the short forms are used when the
 *            value is being MATERIALISED and not when it is a comparison operand
 *            -- and even that is context-dependent.
 *
 * SASC-MISMATCH: block-ordering
 *   summary: The repeat-run body is placed after the literal loop in the original
 *            and inline in 6.51, so casm cannot pair the middle of the function
 *            instruction for instruction. The +2 is confidently the arg-load and
 *            constant items above; the interior ordering is not separately
 *            itemised.
 */

char *ESQ_PackBitsDecode(char *src, char *dst, short limit)
{
    short out;
    long n;
    char c;

    out = 0;
    while (out < limit) {
        n = *src++;
        if (n < 0) {
            if (n == 255)
                continue;
            n = -n + 1;
            c = *src++;
            while (n > 0) {
                *dst++ = c;
                out++;
                if (out >= limit)
                    return src;
                n--;
            }
        } else {
            n = n + 1;
            while (n > 0) {
                *dst++ = *src++;
                out++;
                if (out >= limit)
                    return src;
                n--;
            }
        }
    }
    return src;
}
