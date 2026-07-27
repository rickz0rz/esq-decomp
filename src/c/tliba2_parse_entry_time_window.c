/* RESTORES: TLIBA2_ParseEntryTimeWindow
 * MODULE:   modules/groups/b/a/tliba2.s
 * STATUS:   behavioural
 *
 * 238 bytes in the original, 260 emitted, 15 differing regions.
 *
 * Reproduces: the entry-string lookup at ctx+56 indexed by the scaled row, the
 * four sequential STR_FindCharPtr probes for '(' ':' ')' and '"' -- each
 * starting from the previous hit rather than from the string head, so the
 * delimiters must appear in order -- the guard rejecting a ')' that falls at or
 * after the quote, the temporary NUL written over the colon and restored
 * afterwards, the same trick on the close paren, the optional space skip that
 * chooses between lparen+1 and lparen+2, and the sentinel returned through a
 * register that every early exit shares.
 *
 * The four probes are the interesting shape: the original never re-scans from
 * the start, so a string like "12:30)" with the paren before the colon fails the
 * ordering check rather than parsing.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffe8                   LINK.W A5,#-24
 *   got:     9efc0010                   SUBA.W #16,A7
 *   summary: The A5-frame class. Five pointer locals move to A7-relative, and
 *            SAS/C also reloads a couple of them where the original kept them
 *            addressable off A5 -- which is why this one comes out larger rather
 *            than smaller.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the seven cross-unit calls.
 */
extern char *STR_FindCharPtr(char *s, long ch);
extern long  PARSE_ReadSignedLongSkipClass3_Alt(char *s);

long TLIBA2_ParseEntryTimeWindow(unsigned char *ctx, long idx, long *out)
{
    char *s;
    char *lparen;
    char *colon;
    char *rparen;
    char *quote;
    register long ok;

    ok = 0;

    if (ctx)
        s = ((char **)(ctx + 56))[idx];
    else
        s = 0;
    if (s == 0)
        return ok;

    lparen = STR_FindCharPtr(s, '(');
    if (lparen == 0)
        return ok;
    colon = STR_FindCharPtr(lparen, ':');
    if (colon == 0)
        return ok;
    rparen = STR_FindCharPtr(colon, ')');
    if (rparen == 0)
        return ok;

    quote = STR_FindCharPtr(s, '"');
    if (quote && rparen >= quote)
        return ok;

    *colon = 0;
    if (lparen[1] == ' ')
        out[0] = PARSE_ReadSignedLongSkipClass3_Alt(lparen + 2);
    else
        out[0] = PARSE_ReadSignedLongSkipClass3_Alt(lparen + 1);
    *colon = ':';

    *rparen = 0;
    out[1] = PARSE_ReadSignedLongSkipClass3_Alt(colon + 1);
    *rparen = ')';

    ok = 1;
    return ok;
}
