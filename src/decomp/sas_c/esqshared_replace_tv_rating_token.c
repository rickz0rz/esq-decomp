typedef signed long LONG;
typedef unsigned char UBYTE;

extern const char *Global_TBL_TV_PROGRAM_RATINGS[];
extern UBYTE ESQPARS2_TvRatingTokenGlyphMap[];
extern void *AbsExecBase;

extern char *GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(const char *text, const char *needle);
extern void _LVOCopyMem(void *execBase, const void *src, void *dst, LONG size);

void ESQSHARED_ReplaceTvRatingToken(char *text)
{
    LONG found = 0;
    LONG i = 0;

    while (i < 7 && found == 0) {
        char *hit = GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(text, Global_TBL_TV_PROGRAM_RATINGS[i]);
        if (hit != (char *)0) {
            char *dst = hit;
            const char *token = Global_TBL_TV_PROGRAM_RATINGS[i];
            LONG token_len = 0;
            LONG tail_len = 0;
            char *tail;

            *dst++ = (char)ESQPARS2_TvRatingTokenGlyphMap[i];
            while (token[token_len] != '\0') {
                ++token_len;
            }

            tail = dst + (token_len - 1);
            while (tail[tail_len] != '\0') {
                ++tail_len;
            }

            _LVOCopyMem(AbsExecBase, tail, dst, tail_len + 1);
            found = 1;
        }
        ++i;
    }
}
