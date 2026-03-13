typedef signed long LONG;
typedef unsigned char UBYTE;
typedef unsigned long ULONG;

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR 65536L

typedef struct PARSEINI_WeatherSourceNode {
    char label[8];
    struct PARSEINI_WeatherSourceNode *next;
} PARSEINI_WeatherSourceNode;

typedef struct PARSEINI_WeatherBlock {
    UBYTE pad0[190];
    UBYTE typeByte;
    UBYTE id[3];
    LONG loadColorMode;
    LONG xPos;
    LONG yPos;
    LONG xSource;
    LONG ySource;
    LONG sizeX;
    LONG sizeY;
    LONG horizAlign;
    LONG vertAlign;
    PARSEINI_WeatherSourceNode *sourceList;
} PARSEINI_WeatherBlock;

extern void *PARSEINI_ParsedDescriptorListHead;
extern void *PARSEINI_CurrentWeatherBlockTempPtr;
extern void *PARSEINI_CurrentWeatherBlockPtr;
extern const char Global_STR_PARSEINI_C_3[];

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

extern LONG STRING_CompareNoCase(const char *a, const char *b);
extern void *BRUSH_AllocBrushNode(const char *entryText, void *existingNode);
extern LONG PARSE_ReadSignedLongSkipClass3_Alt(const char *s);
extern void *MEMORY_AllocateMemory(const char *fileName, LONG lineNumber, LONG byteSize, LONG flags);
extern char *STRING_CopyPadNul(char *dst, const char *src, ULONG n);

void PARSEINI_ProcessWeatherBlocks(const char *entryKey, char *entryValue)
{
    void *prevSourceNode;
    void *newAllocNode;
    LONG parsedValue;
    LONG sourceLen;
    char *sourceEnd;
    char *sourceDst;
    char *sourceSrc;
    PARSEINI_WeatherBlock *weatherBlock;

    if (PARSEINI_ParsedDescriptorListHead == (void *)0) {
        PARSEINI_CurrentWeatherBlockTempPtr = (void *)0;
        PARSEINI_CurrentWeatherBlockPtr = (void *)0;
    }

    if (STRING_CompareNoCase(entryKey, PARSEINI_TAG_FILENAME_WeatherBlock) == 0) {
        PARSEINI_CurrentWeatherBlockTempPtr = (void *)0;
        newAllocNode = BRUSH_AllocBrushNode(entryValue, PARSEINI_CurrentWeatherBlockPtr);
        weatherBlock = (PARSEINI_WeatherBlock *)newAllocNode;
        weatherBlock->typeByte = (UBYTE)1;
        PARSEINI_CurrentWeatherBlockPtr = newAllocNode;
        if (PARSEINI_ParsedDescriptorListHead == (void *)0) {
            PARSEINI_ParsedDescriptorListHead = newAllocNode;
        }
    }

    if (PARSEINI_CurrentWeatherBlockPtr == (void *)0) {
        return;
    }

    if (STRING_CompareNoCase(entryKey, PARSEINI_STR_LOADCOLOR) == 0) {
        weatherBlock = (PARSEINI_WeatherBlock *)PARSEINI_CurrentWeatherBlockPtr;
        if (STRING_CompareNoCase(entryValue, PARSEINI_TAG_ALL) == 0) {
            weatherBlock->loadColorMode = 0;
            return;
        }
        if (STRING_CompareNoCase(entryValue, PARSEINI_TAG_NONE) == 0) {
            weatherBlock->loadColorMode = 2;
            return;
        }
        if (STRING_CompareNoCase(entryValue, PARSEINI_TAG_TEXT) == 0) {
            weatherBlock->loadColorMode = 3;
            return;
        }
        weatherBlock->loadColorMode = 1;
        return;
    }

    if (STRING_CompareNoCase(entryKey, PARSEINI_TAG_XPOS) == 0) {
        parsedValue = PARSE_ReadSignedLongSkipClass3_Alt(entryValue);
        ((PARSEINI_WeatherBlock *)PARSEINI_CurrentWeatherBlockPtr)->xPos = parsedValue;
        return;
    }

    if (STRING_CompareNoCase(entryKey, PARSEINI_TAG_TYPE) == 0) {
        if (STRING_CompareNoCase(entryValue, PARSEINI_TAG_DITHER) == 0) {
            ((PARSEINI_WeatherBlock *)PARSEINI_CurrentWeatherBlockPtr)->typeByte = (UBYTE)2;
        }
        return;
    }

    if (STRING_CompareNoCase(entryKey, PARSEINI_TAG_YPOS) == 0) {
        parsedValue = PARSE_ReadSignedLongSkipClass3_Alt(entryValue);
        ((PARSEINI_WeatherBlock *)PARSEINI_CurrentWeatherBlockPtr)->yPos = parsedValue;
        return;
    }

    if (STRING_CompareNoCase(entryKey, PARSEINI_TAG_XSOURCE) == 0) {
        parsedValue = PARSE_ReadSignedLongSkipClass3_Alt(entryValue);
        ((PARSEINI_WeatherBlock *)PARSEINI_CurrentWeatherBlockPtr)->xSource = parsedValue;
        return;
    }

    if (STRING_CompareNoCase(entryKey, PARSEINI_TAG_YSOURCE) == 0) {
        parsedValue = PARSE_ReadSignedLongSkipClass3_Alt(entryValue);
        ((PARSEINI_WeatherBlock *)PARSEINI_CurrentWeatherBlockPtr)->ySource = parsedValue;
        return;
    }

    if (STRING_CompareNoCase(entryKey, PARSEINI_TAG_SIZEX) == 0) {
        parsedValue = PARSE_ReadSignedLongSkipClass3_Alt(entryValue);
        ((PARSEINI_WeatherBlock *)PARSEINI_CurrentWeatherBlockPtr)->sizeX = parsedValue;
        return;
    }

    if (STRING_CompareNoCase(entryKey, PARSEINI_TAG_SIZEY) == 0) {
        parsedValue = PARSE_ReadSignedLongSkipClass3_Alt(entryValue);
        ((PARSEINI_WeatherBlock *)PARSEINI_CurrentWeatherBlockPtr)->sizeY = parsedValue;
        return;
    }

    if (STRING_CompareNoCase(entryKey, PARSEINI_TAG_SOURCE) == 0) {
        sourceEnd = entryValue;
        while (*sourceEnd != 0) {
            ++sourceEnd;
        }
        sourceLen = (LONG)(sourceEnd - entryValue);

        if (sourceLen > 0) {
            if (STRING_CompareNoCase(entryValue, PARSEINI_TAG_PPV) == 0) {
                ((PARSEINI_WeatherBlock *)PARSEINI_CurrentWeatherBlockPtr)->typeByte = (UBYTE)3;
                return;
            }

            prevSourceNode = PARSEINI_CurrentWeatherBlockTempPtr;
            newAllocNode = MEMORY_AllocateMemory(Global_STR_PARSEINI_C_3, 670, 12, MEMF_PUBLIC + MEMF_CLEAR);
            PARSEINI_CurrentWeatherBlockTempPtr = newAllocNode;
            if (newAllocNode == (void *)0) {
                return;
            }
            ((PARSEINI_WeatherSourceNode *)newAllocNode)->next = (PARSEINI_WeatherSourceNode *)0;

            sourceDst = (char *)newAllocNode;
            sourceSrc = entryValue;
            do {
                *sourceDst++ = *sourceSrc++;
            } while (sourceDst[-1] != 0);

            weatherBlock = (PARSEINI_WeatherBlock *)PARSEINI_CurrentWeatherBlockPtr;
            if (weatherBlock->sourceList == (PARSEINI_WeatherSourceNode *)0) {
                weatherBlock->sourceList = (PARSEINI_WeatherSourceNode *)newAllocNode;
            } else if (prevSourceNode != (void *)0) {
                ((PARSEINI_WeatherSourceNode *)prevSourceNode)->next = (PARSEINI_WeatherSourceNode *)newAllocNode;
            }
        }
        return;
    }

    if (STRING_CompareNoCase(entryKey, PARSEINI_STR_HORIZONTAL) == 0) {
        weatherBlock = (PARSEINI_WeatherBlock *)PARSEINI_CurrentWeatherBlockPtr;
        if (STRING_CompareNoCase(entryValue, PARSEINI_TAG_RIGHT) == 0) {
            weatherBlock->horizAlign = 2;
            return;
        }
        if (STRING_CompareNoCase(entryValue, PARSEINI_TAG_CENTER_HorizontalAlign) == 0) {
            weatherBlock->horizAlign = 1;
            return;
        }
        weatherBlock->horizAlign = 0;
        return;
    }

    if (STRING_CompareNoCase(entryKey, PARSEINI_TAG_VERTICAL) == 0) {
        weatherBlock = (PARSEINI_WeatherBlock *)PARSEINI_CurrentWeatherBlockPtr;
        if (STRING_CompareNoCase(entryValue, PARSEINI_TAG_BOTTOM) == 0) {
            weatherBlock->vertAlign = 2;
            return;
        }
        if (STRING_CompareNoCase(entryValue, PARSEINI_TAG_CENTER_VerticalAlign) == 0) {
            weatherBlock->vertAlign = 1;
            return;
        }
        weatherBlock->vertAlign = 0;
        return;
    }

    if (STRING_CompareNoCase(entryKey, PARSEINI_TAG_ID) == 0) {
        weatherBlock = (PARSEINI_WeatherBlock *)PARSEINI_CurrentWeatherBlockPtr;
        STRING_CopyPadNul((char *)weatherBlock->id, entryValue, 2);
        weatherBlock->id[2] = 0;
    }
}
