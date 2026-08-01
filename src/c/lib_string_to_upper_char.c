/* RESTORES: STRING_ToUpperChar
 * MODULE:   modules/submodules/unknown3.s
 * STATUS:   behavioural
 *
 * SAS/C library code. Uppercases one character. It takes a long and returns a
 * long, and it modifies only the LOW BYTE.
 *
 * THE COMPARISONS ARE SIGNED BYTE COMPARISONS. `CMPI.B #'a',D0` with `BLT` means
 * a byte with the high bit set reads as negative and is left alone, so the
 * function never touches the range 0x80..0xFF. `(char)` reproduces that; an
 * `unsigned char` cast would uppercase nothing differently for ASCII but would
 * change the answer for the accented range.
 *
 * ONLY THE LOW BYTE IS SUBTRACTED FROM. `SUBI.B #$20,D0` does not borrow into
 * the upper three bytes, so a caller passing a value with rubbish in bits 8..31
 * gets that rubbish back unchanged. Writing `ch - 0x20` on the whole long would
 * differ there. Every caller passes a character, so the distinction is not
 * observable today -- it is reproduced because it is free.
 */
long STRING_ToUpperChar(long ch)
{
    char c = (char)ch;

    if (c >= 'a' && c <= 'z')
        ch = (ch & ~0xffL) | ((unsigned char)(c - 0x20));

    return ch;
}
