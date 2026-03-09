typedef signed long LONG;
typedef unsigned char UBYTE;

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR 65536L

extern void *PARSEINI_ParsedDescriptorListHead;
extern void *PARSEINI_CurrentWeatherBlockTempPtr;
extern void *PARSEINI_CurrentWeatherBlockPtr;
extern char Global_STR_PARSEINI_C_3[];

extern const char PARSEINI_TAG_FILENAME_WeatherBlock[];
extern const char PARSEINI_STR_LOADCOLOR[];
extern const char PARSEINI_TAG_ALL[];
extern const char PARSEINI_TAG_NONE[];
extern const char PARSEINI_TAG_TEXT[];
extern const char PARSEINI_TAG_XPOS[];
extern const char PARSEINI_TAG_TYPE[];
extern const char PARSEINI_TAG_DITHER[];
extern const char PARSEINI_TAG_YPOS[];
extern const char PARSEINI_TAG_XSOURCE[];
extern const char PARSEINI_TAG_YSOURCE[];
extern const char PARSEINI_TAG_SIZEX[];
extern const char PARSEINI_TAG_SIZEY[];
extern const char PARSEINI_TAG_SOURCE[];
extern const char PARSEINI_TAG_PPV[];
extern const char PARSEINI_STR_HORIZONTAL[];
extern const char PARSEINI_TAG_RIGHT[];
extern const char PARSEINI_TAG_CENTER_HorizontalAlign[];
extern const char PARSEINI_TAG_VERTICAL[];
extern const char PARSEINI_TAG_BOTTOM[];
extern const char PARSEINI_TAG_CENTER_VerticalAlign[];
extern const char PARSEINI_TAG_ID[];

extern LONG PARSEINI_JMPTBL_STRING_CompareNoCase(const char *a, const char *b);
extern void *PARSEINI_JMPTBL_BRUSH_AllocBrushNode(char *entryText, void *existingNode);
extern LONG SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern void *SCRIPT_JMPTBL_MEMORY_AllocateMemory(char *fileName, LONG lineNumber, LONG byteSize, LONG flags);
extern void SCRIPT3_JMPTBL_STRING_CopyPadNul(char *dst, char *src, LONG n);

void PARSEINI_ProcessWeatherBlocks(const char *entryKey, char *entryValue)
{
    void *prevSourceNode;
    void *newAllocNode;
    LONG parsedValue;
    LONG sourceLen;
    char *sourceEnd;
    char *sourceDst;
    char *sourceSrc;
    UBYTE *weatherBlock;

    if (PARSEINI_ParsedDescriptorListHead == (void *)0) {
        PARSEINI_CurrentWeatherBlockTempPtr = (void *)0;
        PARSEINI_CurrentWeatherBlockPtr = (void *)0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryKey, PARSEINI_TAG_FILENAME_WeatherBlock) == 0) {
        PARSEINI_CurrentWeatherBlockTempPtr = (void *)0;
        newAllocNode = PARSEINI_JMPTBL_BRUSH_AllocBrushNode(entryValue, PARSEINI_CurrentWeatherBlockPtr);
        weatherBlock = (UBYTE *)newAllocNode;
        weatherBlock[190] = 1;
        PARSEINI_CurrentWeatherBlockPtr = newAllocNode;
        if (PARSEINI_ParsedDescriptorListHead == (void *)0) {
            PARSEINI_ParsedDescriptorListHead = newAllocNode;
        }
    }

    if (PARSEINI_CurrentWeatherBlockPtr == (void *)0) {
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryKey, PARSEINI_STR_LOADCOLOR) == 0) {
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryValue, PARSEINI_TAG_ALL) == 0) {
            *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 194)) = 0;
            return;
        }
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryValue, PARSEINI_TAG_NONE) == 0) {
            *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 194)) = 2;
            return;
        }
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryValue, PARSEINI_TAG_TEXT) == 0) {
            *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 194)) = 3;
            return;
        }
        *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 194)) = 1;
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryKey, PARSEINI_TAG_XPOS) == 0) {
        parsedValue = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(entryValue);
        *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 198)) = parsedValue;
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryKey, PARSEINI_TAG_TYPE) == 0) {
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryValue, PARSEINI_TAG_DITHER) == 0) {
            ((UBYTE *)PARSEINI_CurrentWeatherBlockPtr)[190] = 2;
        }
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryKey, PARSEINI_TAG_YPOS) == 0) {
        parsedValue = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(entryValue);
        *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 202)) = parsedValue;
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryKey, PARSEINI_TAG_XSOURCE) == 0) {
        parsedValue = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(entryValue);
        *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 206)) = parsedValue;
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryKey, PARSEINI_TAG_YSOURCE) == 0) {
        parsedValue = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(entryValue);
        *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 210)) = parsedValue;
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryKey, PARSEINI_TAG_SIZEX) == 0) {
        parsedValue = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(entryValue);
        *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 214)) = parsedValue;
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryKey, PARSEINI_TAG_SIZEY) == 0) {
        parsedValue = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(entryValue);
        *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 218)) = parsedValue;
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryKey, PARSEINI_TAG_SOURCE) == 0) {
        sourceEnd = entryValue;
        while (*sourceEnd != 0) {
            ++sourceEnd;
        }
        sourceLen = (LONG)(sourceEnd - entryValue);

        if (sourceLen > 0) {
            if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryValue, PARSEINI_TAG_PPV) == 0) {
                ((UBYTE *)PARSEINI_CurrentWeatherBlockPtr)[190] = 3;
                return;
            }

            prevSourceNode = PARSEINI_CurrentWeatherBlockTempPtr;
            newAllocNode = SCRIPT_JMPTBL_MEMORY_AllocateMemory(Global_STR_PARSEINI_C_3, 670, 12, MEMF_PUBLIC + MEMF_CLEAR);
            PARSEINI_CurrentWeatherBlockTempPtr = newAllocNode;
            if (newAllocNode == (void *)0) {
                return;
            }
            *((LONG *)((UBYTE *)newAllocNode + 8)) = 0;

            sourceDst = (char *)newAllocNode;
            sourceSrc = entryValue;
            do {
                *sourceDst++ = *sourceSrc++;
            } while (sourceDst[-1] != 0);

            if (*((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 230)) == 0) {
                *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 230)) = (LONG)newAllocNode;
            } else if (prevSourceNode != (void *)0) {
                *((LONG *)((UBYTE *)prevSourceNode + 8)) = (LONG)newAllocNode;
            }
        }
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryKey, PARSEINI_STR_HORIZONTAL) == 0) {
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryValue, PARSEINI_TAG_RIGHT) == 0) {
            *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 222)) = 2;
            return;
        }
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryValue, PARSEINI_TAG_CENTER_HorizontalAlign) == 0) {
            *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 222)) = 1;
            return;
        }
        *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 222)) = 0;
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryKey, PARSEINI_TAG_VERTICAL) == 0) {
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryValue, PARSEINI_TAG_BOTTOM) == 0) {
            *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 226)) = 2;
            return;
        }
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryValue, PARSEINI_TAG_CENTER_VerticalAlign) == 0) {
            *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 226)) = 1;
            return;
        }
        *((LONG *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 226)) = 0;
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryKey, PARSEINI_TAG_ID) == 0) {
        SCRIPT3_JMPTBL_STRING_CopyPadNul((char *)((UBYTE *)PARSEINI_CurrentWeatherBlockPtr + 191), entryValue, 2);
        ((UBYTE *)PARSEINI_CurrentWeatherBlockPtr)[193] = 0;
    }
}
