/* RESTORES: LADFUNC2_EmitEscapedCharToScratch
 * MODULE:   modules/groups/a/x/ladfunc2.s
 * STATUS:   behavioural
 *
 * 154 bytes in the original, 160 emitted, 12 differing regions.
 *
 * A five-way character escaper. Reproduces: control characters below 32 emitted
 * as caret-plus-64, the two specific high bytes remapped to a quote and a comma,
 * anything else above 126 emitted as a hex escape, and everything remaining
 * passed through literally.
 *
 * The two remapped constants are both built with the original's short forms,
 * which is a compact demonstration of the rule in docs/compiler-version.md:
 *
 *     168 -> 7254 d281      MOVEQ #84,D1 / ADD.L D1,D1     (2n)
 *     169 -> 7256 4601      MOVEQ #86,D1 / NOT.B D1        (~n)
 *
 * Two adjacent constants, one byte apart, reached by two different four-byte
 * tricks -- neither of which SAS/C uses. If a candidate compiler reproduces this
 * function's constants it has both forms.
 *
 * SASC-MISMATCH: byte-vs-long-register-width
 *   ref:     1e2f000b 7020 be00        MOVE.B 11(A7),D7 / MOVEQ #32,D0 / CMP.B D0,D7
 *   got:     1e2f000f 1c07 7020 bc00   an extra byte copy into a second register
 *   summary: SAS/C keeps a separate byte copy of the character, costing a
 *            register and shifting the parameter offset. Same class as
 *            gcommand_map_keycode_to_preset.c.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the five cross-unit format calls.
 */
extern void FORMAT_RawDoFmtWithScratchBuffer(char *fmt, long v);
extern char LADFUNC_FMT_ControlCharCaretEscape[];
extern char LADFUNC_FMT_ReplacementQuoteChar[];
extern char LADFUNC_FMT_ReplacementCommaChar[];
extern char LADFUNC_FMT_HexEscapeByte[];
extern char LADFUNC_FMT_LiteralChar[];

void LADFUNC2_EmitEscapedCharToScratch(char c)
{
    register unsigned char ch;

    ch = c;

    if (ch < 32) {
        FORMAT_RawDoFmtWithScratchBuffer(
            LADFUNC_FMT_ControlCharCaretEscape, (long)ch + 64);
        return;
    }

    if (ch == 168) {
        ch = 34;
        FORMAT_RawDoFmtWithScratchBuffer(
            LADFUNC_FMT_ReplacementQuoteChar, (long)ch);
        return;
    }

    if (ch == 169) {
        ch = 44;
        FORMAT_RawDoFmtWithScratchBuffer(
            LADFUNC_FMT_ReplacementCommaChar, (long)ch);
        return;
    }

    if (ch > 126) {
        FORMAT_RawDoFmtWithScratchBuffer(
            LADFUNC_FMT_HexEscapeByte, (long)ch);
        return;
    }

    FORMAT_RawDoFmtWithScratchBuffer(LADFUNC_FMT_LiteralChar, (long)ch);
}
