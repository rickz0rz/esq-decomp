/* RESTORES: STR_CopyUntilAnyDelimN, STR_FindChar, _STR_FindCharPtr,
 *           STR_FindCharPtr_UnreachableLastMatchStub, STR_FindAnyCharInSet,
 *           STR_FindAnyCharPtr, _STR_SkipClass3Chars
 * MODULE:   modules/submodules/unknown7.s
 * STATUS:   behavioural
 *
 * SAS/C library code: strchr, strrchr, strpbrk, a bounded delimited copy and a
 * character-class skip. Seven labels, one module, so they move together.
 *
 * THE ARGUMENT ORDER OF STR_CopyUntilAnyDelimN IS SOURCE FIRST, DESTINATION
 * SECOND, which is the opposite of every str* function beside it. The original
 * takes the source in A3 from 36(A7) and reaches the destination as `12(A5)`,
 * which after the LINK is the SECOND argument. Getting this backwards writes the
 * delimiter set over the input.
 *
 * IT STOPS AT n-1, NOT n. `MOVE.L D7,D0 / SUBQ.L #1,D0 / CMP.L D0,D6 / BGE` --
 * so `n` is the buffer size including the terminator, and the copy leaves room
 * for it. It returns a pointer INTO THE SOURCE at the stopping point, which is
 * how the caller resumes at the delimiter.
 *
 * STR_FindChar COMPARES BEFORE IT TESTS FOR THE TERMINATOR, so searching for 0
 * finds the NUL rather than failing. That is strchr's contract and it is easy to
 * lose by writing the loop condition first.
 *
 * THE COMPARISON IS AGAINST A ZERO-EXTENDED BYTE. `MOVEQ #0,D0 / MOVE.B (A3),D0
 * / CMP.L D7,D0` compares the character as 0..255 against the full long, so
 * searching for 256 or for a negative value never matches. Writing
 * `*s == (char)ch` would make 0x80..0xFF match a negative argument.
 *
 * STR_FindCharPtr_UnreachableLastMatchStub IS DEAD AND IS KEPT. It carries no
 * XDEF and nothing calls it -- it is strrchr, left behind. It is restored because
 * a C file replaces the WHOLE module, and dropping it would shorten the module
 * rather than leave the program unchanged.
 *
 * _STR_SkipClass3Chars reads the same character-class table STRING_ToUpperInPlace
 * does, testing bit 3 rather than bit 1. See lib_string_to_upper_in_place.c for
 * why that table is reachable at all: it is `_WDISP_CharClassTable`, an ordinary
 * DATA label, and the A4 displacement resolves onto it.
 *
 * IT HAS NO TERMINATOR TEST. The loop runs while bit 3 is set, and the class
 * table's entry for 0 has that bit clear, so the NUL stops it. Adding an explicit
 * `*p != 0` would be harmless but is not what the original does.
 *
 * SASC-MISMATCH: near-data-addressing
 *   ref:     LEA Global_CharClassTable(A4),A0
 *   got:     an absolute reference to _WDISP_CharClassTable
 *   scope:   every A4 reference in modules/submodules/.
 *   retest:  a build using SAS/C near data.
 */
extern unsigned char WDISP_CharClassTable[];

char *STR_FindChar(char *s, long ch)
{
    for (;;) {
        if ((long)(unsigned char)*s == ch)
            return s;
        if (*s++ == 0)
            return 0;
    }
}

char *STR_FindCharPtr(char *s, long ch)
{
    return STR_FindChar(s, ch);
}

/* Dead in the stock image: no XDEF, no caller. strrchr. */
char *STR_FindCharPtr_UnreachableLastMatchStub(char *s, long ch)
{
    char *last = 0;

    while (*s != 0) {
        if ((long)(unsigned char)*s == ch)
            last = s;
        s++;
    }

    return last;
}

char *STR_FindAnyCharInSet(char *s, char *set)
{
    while (*s != 0) {
        char *p = set;
        while (*p != 0) {
            if (*p == *s)
                return s;
            p++;
        }
        s++;
    }

    return 0;
}

char *STR_FindAnyCharPtr(char *s, char *set)
{
    return STR_FindAnyCharInSet(s, set);
}

char *STR_SkipClass3Chars(char *s)
{
    while (WDISP_CharClassTable[(unsigned char)*s] & 8)
        s++;

    return s;
}

char *STR_CopyUntilAnyDelimN(char *src, char *dst, long n, char *delims)
{
    long i = 0;

    while (i < n - 1 && src[i] != 0) {
        long j = 0;

        while (delims[j] != 0 && src[i] != delims[j])
            j++;
        if (delims[j] != 0)             /* hit a delimiter */
            break;

        dst[i] = src[i];
        i++;
    }

    dst[i] = 0;
    return src + i;
}
