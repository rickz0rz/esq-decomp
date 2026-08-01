/* RESTORES: _STRING_CompareNoCaseN, _STRING_CopyPadNul, STRING_CompareN,
 *           STRING_AppendN, _STRING_CompareNoCase
 * MODULE:   modules/submodules/unknown5.s
 * STATUS:   behavioural
 *
 * SAS/C library code: strncasecmp, strncpy, strncmp, strncat and strcasecmp.
 * Five functions, one module, so they are restored together.
 *
 * THE LOOPS ARE WRITTEN OUT RATHER THAN CALLED. AGENTS.md records that strlen,
 * strcmp and strcpy INLINE under 6.51, but the `n`-limited forms do not -- they
 * are real calls into sc.lib, and this build does not link sc.lib. Writing
 * `strncpy` here would compile and then fail to link. The loops below are what
 * the original does anyway.
 *
 * THE THREE COMPARISONS SHARE ONE TAIL, and it is not the C standard's. When the
 * loop stops, the answer is decided in this order:
 *
 *   n exhausted        ->  0, whatever is left in either string
 *   a ended, b did not -> -1
 *   b ended, a did not ->  1
 *   both ended         ->  0
 *
 * So the result is -1, 0 or +1 from the tail but the DIFFERENCE OF TWO
 * CHARACTERS from the body. A caller that only tests the sign is safe; one that
 * expects a normalised -1/0/1 is not.
 *
 * _STRING_CompareNoCaseN CALLS STRING_ToUpperChar; _STRING_CompareNoCase INLINES
 * the same range test. The original does exactly that -- one is a call per
 * character, the other is not -- and the two are kept different because the call
 * is observable in a profile and in the emitted bytes.
 *
 * _STRING_CopyPadNul PADS TO THE FULL LENGTH. It is strncpy: once the source's
 * NUL is copied the remainder of `n` is filled with NULs, so a short string into
 * a long buffer clears the whole buffer. It returns the destination.
 *
 * IT DOES NOT TERMINATE A FULL BUFFER. If the source is `n` characters or longer
 * no NUL is written, exactly as strncpy. Callers pass a length one short of the
 * buffer for that reason.
 *
 * STRING_AppendN MEASURES BOTH STRINGS FIRST, then clamps the source length to
 * `n`, copies, and terminates at the end -- so unlike the copy above it always
 * terminates. `BLS` on the clamp is an UNSIGNED compare.
 */

extern long STRING_ToUpperChar(long ch);

long STRING_CompareNoCaseN(char *a, char *b, long n)
{
    while (n != 0 && *a != 0 && *b != 0) {
        long d = STRING_ToUpperChar((long)(unsigned char)*a++)
               - STRING_ToUpperChar((long)(unsigned char)*b++);
        if (d != 0)
            return d;
        n--;
    }

    if (n == 0)
        return 0;
    if (*a != 0)
        return 1;
    if (*b != 0)
        return -1;
    return 0;
}

long STRING_CompareN(char *a, char *b, long n)
{
    while (n != 0 && *a != 0 && *b != 0) {
        long d = (long)(unsigned char)*a++ - (long)(unsigned char)*b++;
        if (d != 0)
            return d;
        n--;
    }

    if (n == 0)
        return 0;
    if (*a != 0)
        return 1;
    if (*b != 0)
        return -1;
    return 0;
}

long STRING_CompareNoCase(char *a, char *b)
{
    for (;;) {
        long ca = (long)(unsigned char)*a++;
        long cb = (long)(unsigned char)*b++;
        long d;

        if ((char)ca >= 'a' && (char)ca <= 'z')
            ca -= 0x20;
        if ((char)cb >= 'a' && (char)cb <= 'z')
            cb -= 0x20;

        d = ca - cb;
        if (d != 0)
            return d;
        if (cb == 0)
            return 0;
    }
}

char *STRING_CopyPadNul(char *dst, char *src, long n)
{
    char *p = dst;

    /* THE PADDING IS REACHED ONLY BY HITTING THE SOURCE'S NUL. If the count runs
     * out first the original branches straight to the return -- `BRA .return`
     * between the two loops -- and pads nothing.
     *
     * Written the obvious way, as two sequential `while (n-- != 0)` loops with a
     * `break` between them, the count is ALREADY -1 when the first loop ends
     * normally, so the second loop sees a non-zero n and pads about four billion
     * bytes over whatever follows the buffer. That build killed the machine
     * outright: 0 of 10 frames with Amiga content. The nesting is what keeps the
     * two cases apart. */
    while (n != 0) {
        n--;
        if ((*p++ = *src++) == 0) {
            while (n != 0) {
                n--;
                *p++ = 0;
            }
            break;
        }
    }

    return dst;
}

char *STRING_AppendN(char *dst, char *src, long n)
{
    char *s = src;
    char *d = dst;
    long srcLen, dstLen;
    char *end;

    while (*s != 0)
        s++;
    srcLen = (long)(s - src);

    while (*d != 0)
        d++;
    dstLen = (long)(d - dst);

    end = dst + dstLen;

    if ((unsigned long)srcLen > (unsigned long)n)
        srcLen = n;

    {
        long i;
        for (i = 0; i < srcLen; i++)
            end[i] = src[i];
        end[srcLen] = 0;
    }

    return dst;
}
