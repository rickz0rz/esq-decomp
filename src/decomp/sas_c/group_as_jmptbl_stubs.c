extern char *STR_FindCharPtr(const char *s, long ch);
extern char *ESQ_FindSubstringCaseFold(const char *haystack, const char *needle);

char *GROUP_AS_JMPTBL_STR_FindCharPtr(const char *s, long ch)
{
    return STR_FindCharPtr(s, ch);
}

char *GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(const char *haystack, const char *needle)
{
    return ESQ_FindSubstringCaseFold(haystack, needle);
}
