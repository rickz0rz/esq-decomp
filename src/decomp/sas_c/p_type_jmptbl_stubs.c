extern char *STRING_FindSubstring(char *haystack, const char *needle);

char *P_TYPE_JMPTBL_STRING_FindSubstring(const char *haystack, const char *needle){return STRING_FindSubstring((char *)haystack, needle);}
