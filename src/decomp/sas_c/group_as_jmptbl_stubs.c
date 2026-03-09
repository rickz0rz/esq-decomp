extern char *STR_FindCharPtr(char *s, long ch);
extern char *ESQ_FindSubstringCaseFold(char *haystack, char *needle);

char *GROUP_AS_JMPTBL_STR_FindCharPtr(char *s, long ch)
{
    return STR_FindCharPtr(s, ch);
}

char *GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(char *haystack, char *needle)
{
    return ESQ_FindSubstringCaseFold(haystack, needle);
}
