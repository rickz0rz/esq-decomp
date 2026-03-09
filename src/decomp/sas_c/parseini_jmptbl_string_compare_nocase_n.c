extern long STRING_CompareNoCaseN(const char *a, const char *b, long n);

long PARSEINI_JMPTBL_STRING_CompareNoCaseN(const char *a, const char *b, long n){return STRING_CompareNoCaseN(a, b, n);}
