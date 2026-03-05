typedef signed long LONG;
typedef short WORD;
typedef unsigned char UBYTE;

extern UBYTE TEXTDISP_PrimarySearchText[];
extern UBYTE TEXTDISP_SecondarySearchText[];

extern void SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(UBYTE *text, LONG maxLen);

void SCRIPT_SplitAndNormalizeSearchBuffer(UBYTE *parseBuffer, LONG parseLen)
{
    WORD i;
    UBYTE *src;
    UBYTE *dst;

    if (parseBuffer[1] == 18) {
        src = parseBuffer + 2;
        dst = TEXTDISP_SecondarySearchText;
        do {
            *dst++ = *src;
        } while (*src++ != 0);
        TEXTDISP_PrimarySearchText[0] = 0;
    } else if (parseBuffer[parseLen - 1] == 18) {
        parseBuffer[parseLen - 1] = 0;
        src = parseBuffer + 1;
        dst = TEXTDISP_PrimarySearchText;
        do {
            *dst++ = *src;
        } while (*src++ != 0);
        TEXTDISP_SecondarySearchText[0] = 0;
    } else {
        i = 1;
        while (1) {
            if (parseBuffer[i] == 18) {
                break;
            }
            if (i >= 0xc8) {
                break;
            }
            i++;
        }

        parseBuffer[i] = 0;
        src = parseBuffer + i + 1;
        dst = TEXTDISP_SecondarySearchText;
        do {
            *dst++ = *src;
        } while (*src++ != 0);

        src = parseBuffer + 1;
        dst = TEXTDISP_PrimarySearchText;
        do {
            *dst++ = *src;
        } while (*src++ != 0);
    }

    if (TEXTDISP_PrimarySearchText[0] != 0) {
        SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(TEXTDISP_PrimarySearchText, 128);
    }

    if (TEXTDISP_SecondarySearchText[0] != 0) {
        SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(TEXTDISP_SecondarySearchText, 128);
    }
}
