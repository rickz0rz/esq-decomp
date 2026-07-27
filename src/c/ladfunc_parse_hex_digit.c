/* RESTORES: LADFUNC_ParseHexDigit
 * MODULE:   modules/groups/a/w/ladfunc.s
 * STATUS:   behavioural
 *
 * Converts one hex digit to its value using the character-class table rather than
 * range compares: class bit 2 marks a digit, bit 7 marks a letter, and bit 1
 * distinguishes lower case. Anything that is neither a digit nor a letter yields
 * zero, so a malformed digit reads as 0 rather than being rejected.
 *
 * Lower case is folded by subtracting 32 and then taking the letter path, which is
 * why the two letter cases share the final `- 55` rather than each having their
 * own bias. The class index is the signed char, so bytes >= 0x80 index backwards
 * from the table base -- the same detail recorded in
 * esqshared_normalize_in_stereo_tag.c and textdisp_find_quoted_span.c.
 *
 * 100 bytes in the original, 100 emitted, and the ONLY thing that differs is one
 * two-byte instruction repeated six times: `2007` against `1007`. 88 of the 100
 * bytes are identical, including the argument load, both constant subtractions,
 * all three BTSTs, the shared `- 55` tail and the whole block layout.
 *
 * That makes it the second isolated single-class function in the project, after
 * SCRIPT_SaveCtrlContextSnapshot (which isolates A3/A5). A compiler that widens a
 * char through the full register makes this exact with no source change:
 *
 *     tools/cmatch.sh src/c/ladfunc_parse_hex_digit.c LADFUNC_ParseHexDigit
 *
 * Three source shapes were needed to get here and all three are load-bearing --
 * see the notes under the mismatch below, since two of them are general.
 *
 * SASC-MISMATCH: char-widen-move-width
 *   ref:     2007 4880 48c0    MOVE.L D7,D0 / EXT.W D0 / EXT.L D0
 *   got:     1007 4880 48c0    MOVE.B D7,D0 / EXT.W D0 / EXT.L D0
 *   summary: Widening the char parameter to long. Both are correct and both are
 *            two bytes -- only the low byte of the copy can matter, since EXT.W
 *            immediately overwrites bits 8-15. The original copies the whole
 *            register anyway; 6.51 copies just the byte. Six sites, every use of
 *            the parameter.
 *   tried:   SHORTINT (worse -- also drops ADDA.L to ADDA.W), NOOPTIMIZE (no
 *            change). Declaring the parameter `long` and writing `(char)ch` at
 *            each use DOES emit MOVE.L at all six sites, but then the argument
 *            load becomes MOVE.L 8(A7),D7 where the original has
 *            MOVE.B 11(A7),D7 -- which is direct evidence the parameter really is
 *            a char. Trading six matching sites for one and misdeclaring the
 *            signature to do it is the distortion this project exists to avoid,
 *            so the honest signature is kept and the divergence recorded.
 *   scope:   every function taking a char parameter and widening it. Find with
 *            a search for `2007 4880 48c0` against `1007 4880 48c0`.
 *   retest:  MATCH on the cmatch above.
 *
 * Source shapes that were required, two of which generalise:
 *
 *   - `WDISP_CharClassTable[(long)c]`, not `[c]`. Without the cast SAS/C computes
 *     the index in a word (EXT.W then ADDA.W) where the original computes a full
 *     long (EXT.W, EXT.L, ADDA.L). This is the same family as the SHORTINT rule:
 *     the original's index arithmetic is 32-bit and has to be asked for.
 *   - No shared local for the letter value. Writing `v = c - 32; ... return v - 55`
 *     to mirror the original's shared tail costs a register: SAS/C parks `v` in D6
 *     and adds it to the save mask, +6 bytes. Two separate returns let it CSE the
 *     `- 55` by itself, which is what the original did.
 *   - `return 0` textually LAST. As an early `if (!(class & 0x80)) return 0;` the
 *     zero is emitted inline with a branch around it; as the final statement it
 *     lands after the letter paths exactly where the original has it. Net zero
 *     bytes, but four bytes of layout.
 */

extern unsigned char WDISP_CharClassTable[];

long LADFUNC_ParseHexDigit(char c)
{
    if (WDISP_CharClassTable[(long)c] & 4)
        return c - 48;

    if (WDISP_CharClassTable[(long)c] & 0x80) {
        if (WDISP_CharClassTable[(long)c] & 2)
            return (c - 32) - 55;
        return c - 55;
    }

    return 0;
}
