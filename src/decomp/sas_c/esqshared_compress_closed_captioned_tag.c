typedef unsigned long ULONG;

extern const char Global_STR_CLOSED_CAPTIONED[];

extern char *GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(const char *text, const char *needle);
extern void CopyMem(const void *src, void *dst, ULONG len);

void ESQSHARED_CompressClosedCaptionedTag(char *text)
{
    char *tag = GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(text, Global_STR_CLOSED_CAPTIONED);

    if (tag != (char *)0) {
        char *dst = tag + 1;
        char *src = tag + 4;
        ULONG len = 0;

        *tag = '|';
        while (src[len] != '\0') {
            ++len;
        }
        CopyMem(src, dst, len + 1);
    }
}
