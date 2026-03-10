char *ESQ_FindSubstringCaseFold(const char *haystack, const char *needle)
{
    const char *start;
    const char *pat;
    char c;

    if (*needle == 0) {
        return 0;
    }

    start = haystack;
    pat = needle;

    for (;;) {
        if (*haystack == 0) {
            if (*pat != 0) {
                return 0;
            }
            return (char *)start;
        }

        if (*pat == 0) {
            return (char *)start;
        }

        c = *haystack++;
        if (c == *pat) {
            pat++;
            continue;
        }

        c ^= 0x20;
        if (c == *pat) {
            pat++;
            continue;
        }

        if (pat != needle) {
            haystack--;
        }

        start = haystack;
        pat = needle;
    }
}
