typedef unsigned char UBYTE;
typedef unsigned long ULONG;

extern const char Global_STR_IN_STEREO[];
extern const UBYTE WDISP_CharClassTable[];

extern char *ESQ_FindSubstringCaseFold(const char *text, const char *needle);
extern char *STR_SkipClass3Chars(const char *text);
extern void CopyMem(const void *src, void *dst, ULONG len);

void ESQSHARED_NormalizeInStereoTag(char *text, ULONG flags)
{
    const ULONG IN_STEREO_LEN = 9;
    const UBYTE CHARCLASS_3_MASK = 0x08;
    const char CH_NUL = '\0';
    const ULONG ONE = 1;
    char *tag = ESQ_FindSubstringCaseFold(text, Global_STR_IN_STEREO);
    if (tag == (char *)0) {
        return;
    }

    *tag = (char)0x91;

    {
        char *tail = tag + IN_STEREO_LEN;
        if ((((UBYTE)flags) & 0x80) == 0) {
            if (*tail == CH_NUL) {
                do {
                    *tag = CH_NUL;
                    --tag;
                } while ((WDISP_CharClassTable[(UBYTE)*tag] & CHARCLASS_3_MASK) != 0);
            } else {
                char *src = STR_SkipClass3Chars(tail);
                ULONG len = 0;
                while (src[len] != CH_NUL) {
                    ++len;
                }
                CopyMem(src, tag, len + ONE);
            }
        } else {
            ++tag;
            {
                ULONG len2 = 0;
                while (tail[len2] != CH_NUL) {
                    ++len2;
                }
                CopyMem(tail, tag, len2 + ONE);
            }
        }
    }
}
