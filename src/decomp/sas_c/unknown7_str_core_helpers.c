typedef signed long LONG;
typedef unsigned char UBYTE;

extern const UBYTE Global_CharClassTable[];

char *STR_CopyUntilAnyDelimN(const char *src, char *dst, LONG maxLen, const char *delims)
{
    LONG i;

    i = 0;
    while (i < (maxLen - 1)) {
        LONG j;

        if (src[i] == '\0') {
            break;
        }

        j = 0;
        while (delims[j] != '\0') {
            if (src[i] == delims[j]) {
                break;
            }
            ++j;
        }

        if (delims[j] != '\0') {
            break;
        }

        dst[i] = src[i];
        ++i;
    }

    dst[i] = '\0';
    return src + i;
}

char *STR_FindChar(const char *s, LONG ch)
{
    UBYTE target = (UBYTE)ch;

    while (1) {
        if ((UBYTE)*s == target) {
            return (char *)s;
        }
        if (*s++ == '\0') {
            return (char *)0;
        }
    }
}

char *STR_FindCharPtr(const char *s, LONG ch)
{
    return STR_FindChar(s, ch);
}

char *STR_FindAnyCharInSet(const char *s, const char *charset)
{
    while (*s != '\0') {
        const char *p = charset;
        while (*p != '\0') {
            if (*p == *s) {
                return (char *)s;
            }
            ++p;
        }
        ++s;
    }
    return (char *)0;
}

char *STR_FindAnyCharPtr(const char *s, const char *charset)
{
    return STR_FindAnyCharInSet(s, charset);
}

char *STR_SkipClass3Chars(const char *s)
{
    while ((Global_CharClassTable[(UBYTE)*s] & (1U << 3)) != 0U) {
        ++s;
    }
    return (char *)s;
}
