typedef signed long LONG;
typedef short WORD;
typedef unsigned char UBYTE;

extern UBYTE TEXTDISP_PrimarySearchText[];
extern UBYTE TEXTDISP_SecondarySearchText[];

extern void SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(UBYTE *text, LONG maxLen);

void SCRIPT_SplitAndNormalizeSearchBuffer(UBYTE *parseBuffer, LONG parseLen)
{
    const UBYTE SPLIT_TOKEN = 18;
    const WORD SPLIT_SCAN_START = 1;
    const WORD SPLIT_SCAN_LIMIT = 0xc8;
    const LONG FIELD_OFFSET_HEAD = 1;
    const LONG FIELD_OFFSET_BODY = 2;
    const LONG FILTER_MAXLEN = 128;
    const UBYTE CH_NUL = 0;
    WORD i;
    UBYTE *src;
    UBYTE *dst;

    if (parseBuffer[FIELD_OFFSET_HEAD] == SPLIT_TOKEN) {
        src = parseBuffer + FIELD_OFFSET_BODY;
        dst = TEXTDISP_SecondarySearchText;
        do {
            *dst++ = *src;
        } while (*src++ != CH_NUL);
        TEXTDISP_PrimarySearchText[0] = CH_NUL;
    } else if (parseBuffer[parseLen - 1] == SPLIT_TOKEN) {
        parseBuffer[parseLen - 1] = CH_NUL;
        src = parseBuffer + FIELD_OFFSET_HEAD;
        dst = TEXTDISP_PrimarySearchText;
        do {
            *dst++ = *src;
        } while (*src++ != CH_NUL);
        TEXTDISP_SecondarySearchText[0] = CH_NUL;
    } else {
        i = SPLIT_SCAN_START;
        while (1) {
            if (parseBuffer[i] == SPLIT_TOKEN) {
                break;
            }
            if (i >= SPLIT_SCAN_LIMIT) {
                break;
            }
            i++;
        }

        parseBuffer[i] = CH_NUL;
        src = parseBuffer + i + 1;
        dst = TEXTDISP_SecondarySearchText;
        do {
            *dst++ = *src;
        } while (*src++ != CH_NUL);

        src = parseBuffer + FIELD_OFFSET_HEAD;
        dst = TEXTDISP_PrimarySearchText;
        do {
            *dst++ = *src;
        } while (*src++ != CH_NUL);
    }

    if (TEXTDISP_PrimarySearchText[0] != CH_NUL) {
        SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(TEXTDISP_PrimarySearchText, FILTER_MAXLEN);
    }

    if (TEXTDISP_SecondarySearchText[0] != CH_NUL) {
        SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(TEXTDISP_SecondarySearchText, FILTER_MAXLEN);
    }
}
