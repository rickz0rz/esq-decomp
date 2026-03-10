unsigned char ESQ_WildcardMatch(const char *str, const char *pattern)
{
    unsigned char c0;
    unsigned char c1;

    if (!str || !pattern) {
        return 1;
    }

    for (;;) {
        c0 = (unsigned char)*str++;
        c1 = (unsigned char)*pattern++;

        if (c1 == '*') {
            return 0;
        }

        if (!c0) {
            return (unsigned char)((c1 != 0) ? 1 : 0);
        }

        if (c1 == '?') {
            continue;
        }

        if ((unsigned char)(c0 - c1) == 0) {
            continue;
        }

        return 1;
    }
}
