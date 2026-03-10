typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

#define MEMF_PUBLIC 0x00000001L
#define MEMF_CLEAR  0x00010000L

typedef struct AliasPair {
    char *key;
    char *value;
} AliasPair;

enum {
    PARSEINI_SECTION_NONE = 0,
    PARSEINI_SECTION_QTABLE = 1,
    PARSEINI_SECTION_BACKDROP = 2,
    PARSEINI_SECTION_GRADIENT = 3,
    PARSEINI_SECTION_TEXTADS = 4,
    PARSEINI_SECTION_BRUSH = 5,
    PARSEINI_SECTION_BANNER = 6,
    PARSEINI_SECTION_DEFAULT_TEXT = 7,
    PARSEINI_SECTION_SOURCE_CONFIG = 8
};

extern LONG Global_REF_LONG_FILE_SCRATCH;
extern char *Global_PTR_WORK_BUFFER;
extern const UBYTE WDISP_CharClassTable[];

extern AliasPair *TEXTDISP_AliasPtrTable[];
extern UWORD TEXTDISP_AliasCount;

extern const char P_TYPE_STR_QTABLE[];
extern const char P_TYPE_TAG_BACKDROP[];
extern const char P_TYPE_TAG_GRADIENT[];
extern const char P_TYPE_TAG_TEXTADS[];
extern const char P_TYPE_TAG_BRUSH[];
extern const char P_TYPE_TAG_BANNER[];
extern const char P_TYPE_STR_DEFAULT_TEXT[];
extern const char P_TYPE_STR_SOURCE_CONFIG[];

extern const char PARSEINI_DelimSpaceTab_Section1[];
extern const char PARSEINI_DelimSpaceTab_Section2[];
extern const char PARSEINI_DelimSpaceTab_Section4_5[];
extern const char PARSEINI_DelimSpaceTab_Section6[];
extern const char PARSEINI_DelimSpaceTab_Section7[];
extern const char PARSEINI_DelimSpaceTab_Section8[];

extern const char PARSEINI_MODE_RB[];
extern const char PARSEINI_TAG_FILENAME[];
extern const char PARSEINI_TAG_BRUSH[];
extern const char Global_STR_PARSEINI_C_1[];
extern const char Global_STR_PARSEINI_C_2[];
extern const char Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE[];
extern const char SCRIPT_PtrNoForecastWeatherData[];
extern const char SCRIPT_PtrWeatherDataAvailabilityDisclaimer[];

extern char *P_TYPE_WeatherCurrentMsgPtr;
extern char *P_TYPE_WeatherForecastMsgPtr;
extern char *P_TYPE_WeatherBottomLineMsgPtr;
extern LONG P_TYPE_WeatherBrushRefreshPendingFlag;
extern LONG GCOMMAND_GradientPresetTable[];

extern LONG PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer(const char *path);
extern LONG PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer(void);
extern char *PARSEINI_JMPTBL_STR_FindCharPtr(const char *s, LONG ch);
extern char *PARSEINI_JMPTBL_STR_FindAnyCharPtr(const char *s, const char *delim);
extern LONG PARSEINI_JMPTBL_STRING_CompareNoCase(const char *a, const char *b);
extern void PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette(LONG *table);
extern char *PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(const char *newValue, char *oldValue);
extern char *PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator(const char *path);
extern LONG PARSEINI_JMPTBL_HANDLE_OpenWithMode(char *path, const char *modeStr);
extern void PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad(char *brushPath);
extern void PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey(void);
extern void *SCRIPT_JMPTBL_MEMORY_AllocateMemory(const char *fileName, LONG lineNumber, LONG byteSize, LONG flags);
extern void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(const char *tagName, LONG line, void *ptr, LONG bytes);

extern void TEXTDISP_ClearSourceConfig(void);
extern void TEXTDISP_AddSourceConfigEntry(char *name, const char *tag);
extern void PARSEINI_ProcessWeatherBlocks(const char *entryKey, char *entryValue);
extern void PARSEINI_LoadWeatherStrings(const char *entryKey, char *entryValue);
extern void PARSEINI_LoadWeatherMessageStrings(const char *entryKey, char *entryValue);
extern LONG PARSEINI_ParseRangeKeyValue(char *sourceLine, short *rangeTable);
extern void PARSEINI_ParseColorTable(const char *entryKey, char *entryValue, LONG mode);

static char *PARSEINI_SkipClass3Chars(const char *s)
{
    while (*s != 0 && (WDISP_CharClassTable[(UBYTE)*s] & 8) != 0) {
        ++s;
    }
    return (char *)s;
}

static void PARSEINI_TrimTrailingClass3(char *s)
{
    char *end = s;

    while (*end != 0) {
        ++end;
    }

    while (end > s && (WDISP_CharClassTable[(UBYTE)end[-1]] & 8) != 0) {
        *--end = 0;
    }
}

static char *PARSEINI_SplitKeyValueLine(char *line, const char *keyDelim)
{
    char *valuePtr;
    char *cutPtr;

    valuePtr = PARSEINI_JMPTBL_STR_FindCharPtr(line, 61);
    if (valuePtr == (char *)0) {
        return (char *)0;
    }

    *valuePtr++ = 0;
    valuePtr = PARSEINI_SkipClass3Chars(valuePtr);

    cutPtr = PARSEINI_JMPTBL_STR_FindAnyCharPtr(line, keyDelim);
    if (cutPtr != (char *)0) {
        *cutPtr = 0;
    }

    PARSEINI_TrimTrailingClass3(valuePtr);
    return valuePtr;
}

LONG PARSEINI_ParseIniBufferAndDispatch(const char *path)
{
    const LONG QTABLE_ALLOC_LINE = 219;
    const LONG QTABLE_ALLOC_SIZE = 8;
    const LONG FREE_WORKBUF_LINE = 403;
    LONG section;
    LONG aliasIndex;
    LONG workBufferSize;
    char *workBuffer;
    char *linePtr;

    section = PARSEINI_SECTION_NONE;
    aliasIndex = -1;

    if (PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer(path) == -1) {
        return -1;
    }

    workBufferSize = Global_REF_LONG_FILE_SCRATCH;
    workBuffer = Global_PTR_WORK_BUFFER;

    for (;;) {
        char *headerEnd;

        linePtr = (char *)PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer();
        if ((LONG)linePtr == -1) {
            break;
        }

        linePtr = PARSEINI_SkipClass3Chars(linePtr);
        if (*linePtr == 0) {
            continue;
        }

        if (*linePtr == '[') {
            headerEnd = PARSEINI_JMPTBL_STR_FindCharPtr(linePtr + 1, 93);
            if (headerEnd == (char *)0) {
                continue;
            }

            *headerEnd = 0;
            ++linePtr;

            if (PARSEINI_JMPTBL_STRING_CompareNoCase(linePtr, P_TYPE_STR_QTABLE) == 0) {
                section = PARSEINI_SECTION_QTABLE;
                continue;
            }
            if (PARSEINI_JMPTBL_STRING_CompareNoCase(linePtr, P_TYPE_TAG_BACKDROP) == 0) {
                section = PARSEINI_SECTION_BACKDROP;
                continue;
            }
            if (PARSEINI_JMPTBL_STRING_CompareNoCase(linePtr, P_TYPE_TAG_GRADIENT) == 0) {
                section = PARSEINI_SECTION_GRADIENT;
                PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette(GCOMMAND_GradientPresetTable);
                continue;
            }
            if (PARSEINI_JMPTBL_STRING_CompareNoCase(linePtr, P_TYPE_TAG_TEXTADS) == 0) {
                section = PARSEINI_SECTION_TEXTADS;
                continue;
            }
            if (PARSEINI_JMPTBL_STRING_CompareNoCase(linePtr, P_TYPE_TAG_BRUSH) == 0) {
                section = PARSEINI_SECTION_BRUSH;
                continue;
            }
            if (PARSEINI_JMPTBL_STRING_CompareNoCase(linePtr, P_TYPE_TAG_BANNER) == 0) {
                section = PARSEINI_SECTION_BANNER;
                P_TYPE_WeatherBrushRefreshPendingFlag = 0;
                continue;
            }
            if (PARSEINI_JMPTBL_STRING_CompareNoCase(linePtr, P_TYPE_STR_DEFAULT_TEXT) == 0) {
                section = PARSEINI_SECTION_DEFAULT_TEXT;
                P_TYPE_WeatherCurrentMsgPtr = PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(
                    (char *)Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE,
                    P_TYPE_WeatherCurrentMsgPtr);
                P_TYPE_WeatherForecastMsgPtr = PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(
                    (char *)SCRIPT_PtrNoForecastWeatherData,
                    P_TYPE_WeatherForecastMsgPtr);
                P_TYPE_WeatherBottomLineMsgPtr = PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(
                    (char *)SCRIPT_PtrWeatherDataAvailabilityDisclaimer,
                    P_TYPE_WeatherBottomLineMsgPtr);
                continue;
            }
            if (PARSEINI_JMPTBL_STRING_CompareNoCase(linePtr, P_TYPE_STR_SOURCE_CONFIG) == 0) {
                TEXTDISP_ClearSourceConfig();
                section = PARSEINI_SECTION_SOURCE_CONFIG;
                continue;
            }

            section = PARSEINI_SECTION_NONE;
            continue;
        }

        if (section == PARSEINI_SECTION_QTABLE) {
            AliasPair *alias;
            char *valuePtr;
            char *quoteStart;
            char *quoteEnd;

            valuePtr = PARSEINI_SplitKeyValueLine(linePtr, PARSEINI_DelimSpaceTab_Section1);
            if (valuePtr == (char *)0) {
                TEXTDISP_AliasCount = 0;
                continue;
            }

            ++aliasIndex;
            TEXTDISP_AliasPtrTable[aliasIndex] = (AliasPair *)SCRIPT_JMPTBL_MEMORY_AllocateMemory(
                Global_STR_PARSEINI_C_1,
                QTABLE_ALLOC_LINE,
                QTABLE_ALLOC_SIZE,
                MEMF_PUBLIC + MEMF_CLEAR);
            alias = TEXTDISP_AliasPtrTable[aliasIndex];
            if (alias == (AliasPair *)0) {
                continue;
            }

            alias->key = (char *)0;
            alias->value = (char *)0;
            alias->key = PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(linePtr, alias->key);

            quoteStart = PARSEINI_JMPTBL_STR_FindCharPtr(valuePtr, 34);
            if (quoteStart == (char *)0) {
                TEXTDISP_AliasCount = 0;
                return 0;
            }

            ++quoteStart;
            quoteEnd = PARSEINI_JMPTBL_STR_FindCharPtr(quoteStart, 34);
            if (quoteEnd == (char *)0) {
                TEXTDISP_AliasCount = 0;
                return 0;
            }

            *quoteEnd = 0;
            alias->value = PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(quoteStart, alias->value);
            TEXTDISP_AliasCount = (UWORD)(aliasIndex + 1);
            continue;
        }

        if (section == PARSEINI_SECTION_BACKDROP) {
            char *valuePtr = PARSEINI_SplitKeyValueLine(linePtr, PARSEINI_DelimSpaceTab_Section2);
            if (valuePtr != (char *)0) {
                PARSEINI_ProcessWeatherBlocks(linePtr, valuePtr);
            }
            continue;
        }

        if (section == PARSEINI_SECTION_GRADIENT) {
            PARSEINI_ParseRangeKeyValue(linePtr, (short *)GCOMMAND_GradientPresetTable);
            continue;
        }

        if (section == PARSEINI_SECTION_TEXTADS || section == PARSEINI_SECTION_BRUSH) {
            char *valuePtr = PARSEINI_SplitKeyValueLine(linePtr, PARSEINI_DelimSpaceTab_Section4_5);
            if (valuePtr == (char *)0) {
                continue;
            }

            if (section == PARSEINI_SECTION_BRUSH) {
                if (PARSEINI_JMPTBL_STRING_CompareNoCase(linePtr, PARSEINI_TAG_FILENAME) == 0 ||
                    PARSEINI_JMPTBL_STRING_CompareNoCase(linePtr, PARSEINI_TAG_BRUSH) == 0) {
                    valuePtr = PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator(valuePtr);
                    if (PARSEINI_JMPTBL_HANDLE_OpenWithMode(valuePtr, PARSEINI_MODE_RB) != 0) {
                        PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad(valuePtr);
                        PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey();
                    }
                }
            } else {
                PARSEINI_ParseColorTable(linePtr, valuePtr, section);
            }
            continue;
        }

        if (section == PARSEINI_SECTION_BANNER) {
            char *valuePtr = PARSEINI_SplitKeyValueLine(linePtr, PARSEINI_DelimSpaceTab_Section6);
            if (valuePtr != (char *)0) {
                PARSEINI_LoadWeatherStrings(linePtr, valuePtr);
            }
            continue;
        }

        if (section == PARSEINI_SECTION_DEFAULT_TEXT) {
            char *valuePtr = PARSEINI_SplitKeyValueLine(linePtr, PARSEINI_DelimSpaceTab_Section7);
            if (valuePtr != (char *)0) {
                PARSEINI_LoadWeatherMessageStrings(linePtr, valuePtr);
            }
            continue;
        }

        if (section == PARSEINI_SECTION_SOURCE_CONFIG) {
            char *valuePtr = PARSEINI_SplitKeyValueLine(linePtr, PARSEINI_DelimSpaceTab_Section8);
            if (valuePtr != (char *)0) {
                TEXTDISP_AddSourceConfigEntry(linePtr, valuePtr);
            }
            continue;
        }
    }

    SCRIPT_JMPTBL_MEMORY_DeallocateMemory(
        (char *)Global_STR_PARSEINI_C_2,
        FREE_WORKBUF_LINE,
        workBuffer,
        workBufferSize + 1);
    return 0;
}
