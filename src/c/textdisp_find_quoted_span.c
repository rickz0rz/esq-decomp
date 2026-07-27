/* RESTORES: TEXTDISP_FindQuotedSpan
 * MODULE:   modules/groups/b/a/textdisp.s
 * STATUS:   behavioural
 *
 * 234 bytes in the original, 228 emitted, 12 differing regions.
 *
 * Reproduces: the paired quote search where the second starts one past the
 * first, the has-quotes flag written through the caller's pointer only when both
 * were found, the fallback that starts at the string head and skips 8 bytes past
 * a leading '(', the end pointer taken from the caller's limit minus one or from
 * the string's own length when no limit was supplied, both character-class trim
 * loops testing bit 3 of WDISP_CharClassTable, and the inclusive length returned
 * as end - start + 1.
 *
 * Note the class-table index is built with EXT.W then EXT.L -- a SIGNED
 * extension of the character. For bytes >= 0x80 that indexes backwards from the
 * table base. Reproduced as written; a plain unsigned index would be the
 * "obvious" reading and would not match, and would also change behaviour on
 * high-bit characters.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff4                   LINK.W A5,#-12
 *   got:     514f                       SUBQ.W #4,A7
 *   summary: The A5-frame class; the two span pointers stay in registers for
 *            SAS/C, which is the whole -6.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the two cross-unit calls.
 */
#include <string.h>

extern char *STR_FindCharPtr(char *s, long ch);
extern unsigned char WDISP_CharClassTable[];

long TEXTDISP_FindQuotedSpan(char *s, char **outStart, char *limit, long *hasQuotes)
{
    char *start;
    char *end;
    register long len;

    end = 0;
    *hasQuotes = 0;

    start = STR_FindCharPtr(s, '"');
    if (start)
        end = STR_FindCharPtr(start + 1, '"');

    if (end) {
        *hasQuotes = 1;
    } else {
        if (start == 0)
            start = s;
        if (*start == '(')
            start += 8;

        end = limit;
        if (end == 0)
            end = s + strlen(s) - 1;
        else
            end--;
    }

    while (WDISP_CharClassTable[*start] & 8)
        start++;
    while (WDISP_CharClassTable[*end] & 8)
        end--;

    *outStart = start;
    len = end - start;
    len++;
    return len;
}
