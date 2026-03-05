char *ESQ_FindSubstringCaseFold(char *haystack, char *needle)
{
    char *start;
    char *pat;
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
            return start;
        }

        if (*pat == 0) {
            return start;
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
