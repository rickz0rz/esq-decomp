typedef signed long LONG;
typedef unsigned char UBYTE;

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR 65536L

extern void *PARSEINI_ParsedDescriptorListHead;
extern void *PARSEINI_CurrentWeatherBlockTempPtr;
extern void *PARSEINI_CurrentWeatherBlockPtr;
extern char Global_STR_PARSEINI_C_3[];

extern char PARSEINI_TAG_FILENAME_WeatherBlock[];
extern char PARSEINI_STR_LOADCOLOR[];
extern char PARSEINI_TAG_ALL[];
extern char PARSEINI_TAG_NONE[];
extern char PARSEINI_TAG_TEXT[];
extern char PARSEINI_TAG_XPOS[];
extern char PARSEINI_TAG_TYPE[];
extern char PARSEINI_TAG_DITHER[];
extern char PARSEINI_TAG_YPOS[];
extern char PARSEINI_TAG_XSOURCE[];
extern char PARSEINI_TAG_YSOURCE[];
extern char PARSEINI_TAG_SIZEX[];
extern char PARSEINI_TAG_SIZEY[];
extern char PARSEINI_TAG_SOURCE[];
extern char PARSEINI_TAG_PPV[];
extern char PARSEINI_STR_HORIZONTAL[];
extern char PARSEINI_TAG_RIGHT[];
extern char PARSEINI_TAG_CENTER_HorizontalAlign[];
extern char PARSEINI_TAG_VERTICAL[];
extern char PARSEINI_TAG_BOTTOM[];
extern char PARSEINI_TAG_CENTER_VerticalAlign[];
extern char PARSEINI_TAG_ID[];

extern LONG PARSEINI_JMPTBL_STRING_CompareNoCase(char *a, char *b);
extern void *PARSEINI_JMPTBL_BRUSH_AllocBrushNode(char *entryText, void *existingNode);
extern LONG SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern void *SCRIPT_JMPTBL_MEMORY_AllocateMemory(char *fileName, LONG lineNumber, LONG byteSize, LONG flags);
extern void SCRIPT3_JMPTBL_STRING_CopyPadNul(char *dst, char *src, LONG n);

void PARSEINI_ProcessWeatherBlocks(char *keyName, char *keyValue)
{
    void *previousNode;
    void *newNode;
    LONG v;
    LONG len;
    char *cursor;
    UBYTE *block;

    if (PARSEINI_ParsedDescriptorListHead == (void *)0) {
        PARSEINI_CurrentWeatherBlockTempPtr = (void *)0;
        PARSEINI_CurrentWeatherBlockPtr = (void *)0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyName, PARSEINI_TAG_FILENAME_WeatherBlock) == 0) {
        PARSEINI_CurrentWeatherBlockTempPtr = (void *)0;
        newNode = PARSEINI_JMPTBL_BRUSH_AllocBrushNode(keyValue, PARSEINI_CurrentWeatherBlockPtr);
        block = (UBYTE *)newNode;
        block[190] = 1;
        PARSEINI_CurrentWeatherBlockPtr = newNode;
        if (PARSEINI_ParsedDescriptorListHead == (void *)0) {
            PARSEINI_ParsedDescriptorListHead = newNode;
        }
    }

    if (PARSEINI_CurrentWeatherBlockPtr == (void *)0) {
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyName, PARSEINI_STR_LOADCOLOR) == 0) {
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyValue, PARSEINI_TAG_ALL) == 0) {
            *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 194)) = 0;
            return;
        }
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyValue, PARSEINI_TAG_NONE) == 0) {
            *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 194)) = 2;
            return;
        }
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyValue, PARSEINI_TAG_TEXT) == 0) {
            *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 194)) = 3;
            return;
        }
        *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 194)) = 1;
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyName, PARSEINI_TAG_XPOS) == 0) {
        v = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(keyValue);
        *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 198)) = v;
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyName, PARSEINI_TAG_TYPE) == 0) {
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyValue, PARSEINI_TAG_DITHER) == 0) {
            ((UBYTE *)PARSEINI_CurrentWeatherBlockPtr)[190] = 2;
        }
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyName, PARSEINI_TAG_YPOS) == 0) {
        v = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(keyValue);
        *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 202)) = v;
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyName, PARSEINI_TAG_XSOURCE) == 0) {
        v = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(keyValue);
        *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 206)) = v;
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyName, PARSEINI_TAG_YSOURCE) == 0) {
        v = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(keyValue);
        *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 210)) = v;
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyName, PARSEINI_TAG_SIZEX) == 0) {
        v = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(keyValue);
        *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 214)) = v;
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyName, PARSEINI_TAG_SIZEY) == 0) {
        v = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(keyValue);
        *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 218)) = v;
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyName, PARSEINI_TAG_SOURCE) == 0) {
        len = 0;
        cursor = keyValue;
        while (*cursor != 0) {
            ++cursor;
            ++len;
        }

        if (len > 0) {
            if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyValue, PARSEINI_TAG_PPV) == 0) {
                ((UBYTE *)PARSEINI_CurrentWeatherBlockPtr)[190] = 3;
                return;
            }

            previousNode = PARSEINI_CurrentWeatherBlockTempPtr;
            newNode = SCRIPT_JMPTBL_MEMORY_AllocateMemory(Global_STR_PARSEINI_C_3, 670, 12, MEMF_PUBLIC + MEMF_CLEAR);
            PARSEINI_CurrentWeatherBlockTempPtr = newNode;
            if (newNode == (void *)0) {
                return;
            }
            *((LONG *)((UBYTE *)newNode + 8)) = 0;

            cursor = (char *)newNode;
            while (*keyValue != 0) {
                *cursor++ = *keyValue++;
            }
            *cursor = 0;

            if (*((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 230)) == 0) {
                *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 230)) = (LONG)newNode;
            } else if (previousNode != (void *)0) {
                *((LONG *)((UBYTE *)previousNode + 8)) = (LONG)newNode;
            }
        }
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyName, PARSEINI_STR_HORIZONTAL) == 0) {
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyValue, PARSEINI_TAG_RIGHT) == 0) {
            *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 222)) = 2;
            return;
        }
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyValue, PARSEINI_TAG_CENTER_HorizontalAlign) == 0) {
            *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 222)) = 1;
            return;
        }
        *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 222)) = 0;
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyName, PARSEINI_TAG_VERTICAL) == 0) {
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyValue, PARSEINI_TAG_BOTTOM) == 0) {
            *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 226)) = 2;
            return;
        }
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyValue, PARSEINI_TAG_CENTER_VerticalAlign) == 0) {
            *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 226)) = 1;
            return;
        }
        *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 226)) = 0;
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyName, PARSEINI_TAG_ID) == 0) {
        SCRIPT3_JMPTBL_STRING_CopyPadNul((char *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 191), keyValue, 2);
        ((UBYTE *)PARSEINI_CurrentWeatherBlockPtr)[193] = 0;
    }
}
