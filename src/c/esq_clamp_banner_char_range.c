/* RESTORES: ESQ_ClampBannerCharRange
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 *
 * Clamps the two banner range characters to their legal letters -- the first to
 * 'A' or 'B', the second to 'A'..'I' with 'E' as the fallback -- then converts
 * them to 1-based slot numbers and derives the start and end of the character
 * range, wrapping at 48.
 *
 * MEASUREMENT NOTE: this function used to be reported as 192 bytes. It is 98. The
 * 94 bytes after it are ESQ_AdvanceBannerCharIndex, which had NO LABEL AT ALL in
 * the disassembly -- only its `_Return` was exported -- so refbytes.py, going
 * label to label, folded a whole second routine into this one. Adding the label
 * (byte-neutral; both gates stay green) fixes the measurement.
 *
 * 98 bytes in the original, 100 emitted. The parameters are `short` even though
 * the original loads them with MOVE.L: see below.
 *
 * SASC-MISMATCH: arg-load-width
 *   ref:     202f0004 222f0008 206f000c   MOVE.L 4(A7),D0 / MOVE.L 8(A7),D1
 *                                         / MOVEA.L 12(A7),A0
 *   got:     3a2f001e 3c2f001a 3e2f0016   MOVE.W of the low word of each slot
 *   summary: The arguments are four bytes apart on the stack in both, so they are
 *            passed identically; the original loads all four bytes and uses only
 *            the low word. Same habit as the MOVE.L in
 *            ladfunc_parse_hex_digit.c. Four bytes either way, no cost.
 *
 *            Declaring the parameters `long` instead makes this instruction match
 *            AND lands the function at exactly 98 -- but then every arithmetic
 *            operation in the body is .L where the original is .W, which is the
 *            wrong trade by the rule in AGENTS.md. Width of the computation beats
 *            two bytes and one load. Recorded because the size-exact variant is
 *            the tempting one.
 *
 * SASC-MISMATCH: constant-in-register
 *   ref:     7641 9243 9443   MOVEQ #65,D3 / SUB.W D3,D1 / SUB.W D3,D2
 *   got:     04460041 04450041   SUBI.W #$41 twice
 *   summary: The original parks 65 in D3 and 48 in D4 and reuses them across the
 *            whole function; 6.51 emits an immediate per site. That is the whole
 *            +2. Trying to force it by putting the constants in locals is worse
 *            (+10, and the locals get spilled).
 *   scope:   related to the constant rule in docs/compiler-version.md, which
 *            covers how a constant is MATERIALISED. This is about whether it is
 *            KEPT once materialised, which is a separate question.
 *
 * SASC-MISMATCH: args-loaded-before-save
 *   ref:     the three argument loads precede the MOVEM
 *   got:     the MOVEM comes first and the loads use adjusted offsets
 *   summary: No cost, but it is the shape that made me file this function as
 *            hand-written assembly on a first read. It is not: everything else
 *            about it compiles cleanly from ordinary C.
 */

extern short WDISP_BannerCharRangeStart;
extern short WDISP_BannerCharRangeEnd;

void ESQ_ClampBannerCharRange(short start, short first, short second)
{
    short end;

    if (first < 65 || first >= 67)
        first = 65;
    if (second < 65 || second > 73)
        second = 69;

    first -= 65;
    second -= 65;
    second += 1;

    end = start;
    if (first) {
        start -= first;
        if (start < 1)
            start += 48;
    }

    end += second;
    if (end > 48)
        end -= 48;

    WDISP_BannerCharRangeStart = start;
    WDISP_BannerCharRangeEnd = end;
}
