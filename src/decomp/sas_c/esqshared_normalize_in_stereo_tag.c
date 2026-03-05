typedef unsigned char UBYTE;
typedef unsigned long ULONG;

extern const char Global_STR_IN_STEREO[];
extern UBYTE WDISP_CharClassTable[];

extern char *GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(char *text, const char *needle);
extern char *ESQSHARED_JMPTBL_STR_SkipClass3Chars(char *text);
extern void CopyMem(const void *src, void *dst, ULONG len);

void ESQSHARED_NormalizeInStereoTag(char *text, ULONG flags)
{
    char *tag = GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(text, Global_STR_IN_STEREO);
    if (tag == (char *)0) {
        return;
    }

    *tag = (char)0x91;

    {
        char *tail = tag + 9;
        if ((flags & 0x80UL) == 0) {
            if (*tail == '\0') {
                do {
                    *tag = '\0';
                    --tag;
                } while ((WDISP_CharClassTable[(UBYTE)*tag] & 0x08) != 0);
            } else {
                char *src = ESQSHARED_JMPTBL_STR_SkipClass3Chars(tail);
                ULONG len = 0;
                while (src[len] != '\0') {
                    ++len;
                }
                CopyMem(src, tag, len + 1);
            }
        } else {
            ++tag;
            {
                ULONG len2 = 0;
                while (tail[len2] != '\0') {
                    ++len2;
                }
                CopyMem(tail, tag, len2 + 1);
            }
        }
    }
}
