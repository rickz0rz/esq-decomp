extern long STRING_CompareNoCase(const char *a, const char *b);
extern void TLIBA3_BuildDisplayContextForViewMode(void);
extern long DISKIO_GetFilesizeFromHandle(long fileHandle);
extern long MATH_DivS32(long dividend, long divisor);

long ESQIFF_JMPTBL_STRING_CompareNoCase(const char *a, const char *b){return STRING_CompareNoCase(a, b);}
void ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(void){TLIBA3_BuildDisplayContextForViewMode();}
long ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle(long fileHandle){return DISKIO_GetFilesizeFromHandle(fileHandle);}
long ESQIFF_JMPTBL_MATH_DivS32(long dividend, long divisor){return MATH_DivS32(dividend, divisor);}
