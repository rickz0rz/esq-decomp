typedef unsigned short UWORD;
typedef signed short WORD;
typedef signed long LONG;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern WORD DISPTEXT_CurrentLineIndex;
extern LONG DISPTEXT_ControlMarkerWidthPx;
extern LONG DISPTEXT_LineWidthPx;
extern WORD DISPTEXT_ControlMarkersEnabledFlag;

extern const char DISPTEXT_STR_SINGLE_SPACE_MEASURE[];
extern const char DISPTEXT_STR_SINGLE_SPACE_APPEND[];
extern const char DISPTEXT_STR_SINGLE_SPACE_DELIM[];

extern LONG _LVOTextLength(void *gfxBase, char *rp, const char *text, LONG count);
extern char *GROUP_AI_JMPTBL_STRING_AppendAtNull(char *dst, const char *src);
extern char *GROUP_AI_JMPTBL_STR_SkipClass3Chars(const char *s);
extern char *GROUP_AI_JMPTBL_STR_CopyUntilAnyDelimN(const char *src, char *dst, LONG maxLen, const char *delims);

char *DISPTEXT_BuildLineWithWidth(char *rp, char *src, char *out, LONG widthPx)
{
    char wordBuf[50];
    LONG sepWidth;

    sepWidth = _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rp, DISPTEXT_STR_SINGLE_SPACE_MEASURE, 1);
    out[0] = 0;

    for (;;) {
        char *wordStart;
        LONG wordLen;
        LONG wordWidth;

        if (src == (char *)0) {
            break;
        }
        if (*src == 0) {
            break;
        }
        if (widthPx <= sepWidth) {
            break;
        }

        if (out[0] != 0) {
            GROUP_AI_JMPTBL_STRING_AppendAtNull(out, DISPTEXT_STR_SINGLE_SPACE_APPEND);
            widthPx -= sepWidth;
        }

        src = GROUP_AI_JMPTBL_STR_SkipClass3Chars(src);
        wordStart = src;
        src = GROUP_AI_JMPTBL_STR_CopyUntilAnyDelimN(src, wordBuf, 50, DISPTEXT_STR_SINGLE_SPACE_DELIM);

        wordLen = 0;
        while (wordBuf[wordLen] != 0) {
            wordLen++;
        }

        wordWidth = _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rp, wordBuf, wordLen);
        if ((unsigned char)wordStart[0] == 19U) {
            wordWidth += 8;
        }

        if (wordWidth > widthPx) {
            LONG markerAdjust;
            LONG remainingLineWidth;

            markerAdjust = ((UWORD)DISPTEXT_CurrentLineIndex < 2U) ? DISPTEXT_ControlMarkerWidthPx : 0;
            remainingLineWidth = DISPTEXT_LineWidthPx - markerAdjust;

            if (wordWidth <= remainingLineWidth) {
                src = wordStart;
                widthPx = 0;
                continue;
            }

            if ((unsigned char)wordStart[0] == 19U) {
                continue;
            }

            while (wordWidth > widthPx && wordLen > 0) {
                wordLen--;
                wordWidth = _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rp, wordBuf, wordLen);
            }

            if (wordLen > 0) {
                wordBuf[wordLen] = 0;
                GROUP_AI_JMPTBL_STRING_AppendAtNull(out, wordBuf);
            }

            src = wordStart + wordLen;
            widthPx = 0;
            continue;
        }

        GROUP_AI_JMPTBL_STRING_AppendAtNull(out, wordBuf);
        widthPx -= wordWidth;

        if ((unsigned char)wordStart[0] == 19U) {
            DISPTEXT_ControlMarkersEnabledFlag =
                (WORD)((LONG)DISPTEXT_ControlMarkersEnabledFlag | -1L);
        }
    }

    if (*src == 0) {
        src = (char *)0;
    }

    return src;
}
