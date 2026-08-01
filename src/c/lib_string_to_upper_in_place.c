/* RESTORES: STRING_ToUpperInPlace
 * MODULE:   modules/submodules/unknown4.s
 * STATUS:   behavioural
 *
 * SAS/C library code. Uppercases a string in place and returns the pointer it
 * was given.
 *
 * FUNCTIONAL ANALOGUE, NOT A TRANSCRIPTION, AND THIS IS THE ONE THING TO KNOW
 * ABOUT THIS FILE. The original decides whether a byte is lowercase by indexing
 * SAS/C's own character-class table and testing bit 1:
 *
 *     LEA Global_CharClassTable(A4),A0 / BTST #1,0(A0,D0.L)
 *
 * `Global_CharClassTable` is not a symbol with an address. `src/Prevue.asm`
 * defines it as the equate -1007, an OFFSET into the A4 near-data area that the
 * SAS/C runtime sets up. This project compiles with `DATA=FAR`, so there is no
 * A4 near-data area and the table is not reachable from C at all.
 *
 * So the test is written directly as `c >= 'a' && c <= 'z'`. For the ASCII range
 * the two agree exactly -- bit 1 of that table IS the lowercase flag. They can
 * disagree above 0x7F: a locale table that marks an accented byte lowercase
 * would have the original uppercase it and this will not. ESQ uppercases channel
 * names and command words, which are ASCII, so nothing in the program can tell
 * the difference. It is recorded here because no test in this repository would
 * catch it if that ever stopped being true.
 *
 * THE SUBTRACTION IS DONE ON A ZERO-EXTENDED LONG in the original
 * (`MOVEQ #0,D1 / MOVE.B D0,D1 / SUB.L D2,D1`) and stored back as a byte, which
 * is what `(unsigned char)(*p - 32)` does.
 *
 * IT RETURNS THE ORIGINAL POINTER, held in A3 across the whole loop, not the end
 * of the string.
 */
char *STRING_ToUpperInPlace(char *s)
{
    unsigned char *p = (unsigned char *)s;

    while (*p != 0) {
        if (*p >= 'a' && *p <= 'z')
            *p = (unsigned char)(*p - 32);
        p++;
    }

    return s;
}
