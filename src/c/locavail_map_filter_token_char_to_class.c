/* RESTORES: _LOCAVAIL_MapFilterTokenCharToClass
 * MODULE:   modules/groups/a/y/locavail_p2_p0.s
 * STATUS:   behavioural
 *
 * Converts one character to its HEXADECIMAL DIGIT VALUE. The name says "class",
 * and the arithmetic says otherwise: '0'-'9' give 0-9, 'A'-'F' and 'a'-'f' give
 * 10-15, and everything else gives 0.
 *
 * The three magic numbers are the tell. 48 is '0'. 55 is 'A' minus 10, the
 * standard hex fold. 32 is the case difference, applied to a lowercase letter
 * BEFORE the fold so one subtraction serves both cases.
 *
 * IT CLASSIFIES BY TABLE, NOT BY RANGE. Bit 2 of WDISP_CharClassTable is digit,
 * bits 0 and 1 are uppercase and lowercase. A letter beyond 'F' therefore
 * returns a value ABOVE 15 rather than 0 -- 'z' gives 35. The original does no
 * range check and neither does this, so a caller passing an arbitrary letter
 * gets a number rather than a rejection.
 *
 * THE TABLE INDEX IS A SIGNED CHAR, sign-extended by `MOVE.B / EXT.W / EXT.L`,
 * so a character at or above 128 indexes before the table. Reproduced as
 * written. See esqfunc_trim_text_to_pixel_width_word_boundary.c, which indexes
 * the same table the same way.
 */

extern unsigned char WDISP_CharClassTable[];

long LOCAVAIL_MapFilterTokenCharToClass(char c)
{
    long value;

    if (WDISP_CharClassTable[c] & 4)
        return (long)c - 48;                /* '0'-'9' */

    if ((WDISP_CharClassTable[c] & 3) == 0)
        return 0;                           /* neither letter nor digit */

    value = (WDISP_CharClassTable[c] & 2) ? (long)c - 32 : (long)c;
    return value - 55;                      /* 'A' -> 10 */
}
