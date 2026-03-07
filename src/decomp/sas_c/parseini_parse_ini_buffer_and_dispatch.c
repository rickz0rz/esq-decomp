typedef signed long LONG;

enum {
    PARSEINI_SECTION_NONE = 0,
    PARSEINI_SECTION_QTABLE = 1,
    PARSEINI_SECTION_GRADIENT = 3,
    PARSEINI_SECTION_BRUSH = 5,
    PARSEINI_SECTION_WEATHER_BLOCKS = 6,
    PARSEINI_SECTION_DEFAULT_TEXT = 7,
    PARSEINI_SECTION_SOURCE_CONFIG = 8
};

extern const char P_TYPE_STR_QTABLE[];
extern const char P_TYPE_TAG_GRADIENT[];
extern const char P_TYPE_TAG_DEFAULT_TEXT[];
extern const char P_TYPE_STR_SOURCE_CONFIG[];
extern const char P_TYPE_TAG_BRUSH[];

extern const char PARSEINI_MODE_RB[];
extern const char PARSEINI_TAG_FILENAME[];
extern const char PARSEINI_TAG_BRUSH[];
extern const char PARSEINI_STR_LOADWEATHER[];
extern const char PARSEINI_STR_LOADWEATHERMESSAGE[];
extern const char PARSEINI_STR_LOADCOLORTABLE[];

extern char *P_TYPE_WeatherCurrentMsgPtr;
extern char *P_TYPE_WeatherForecastMsgPtr;
extern char *P_TYPE_WeatherBottomLineMsgPtr;
extern char Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE[];
extern char SCRIPT_PtrNoForecastWeatherData[];
extern char SCRIPT_PtrWeatherDataAvailabilityDisclaimer[];
extern LONG GCOMMAND_GradientPresetTable[];

extern LONG PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer(char *path);
extern LONG PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer(void);
extern char *PARSEINI_JMPTBL_STR_FindCharPtr(char *s, LONG ch);
extern LONG PARSEINI_JMPTBL_STRING_CompareNoCase(char *a, char *b);
extern void PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette(LONG *table);
extern void TEXTDISP_ClearSourceConfig(void);
extern char *PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(char *dst, char *src);
extern char *PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator(char *path);
extern LONG PARSEINI_JMPTBL_HANDLE_OpenWithMode(char *path, char *modeStr);
extern void PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad(char *brushPath);
extern void PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey(void);
extern void PARSEINI_ProcessWeatherBlocks(char *entryKey, char *entryValue);
extern void PARSEINI_LoadWeatherStrings(char *entryKey, char *entryValue);
extern void PARSEINI_LoadWeatherMessageStrings(char *entryKey, char *entryValue);
extern void PARSEINI_ParseColorTable(char *entryKey, char *entryValue);

LONG PARSEINI_ParseIniBufferAndDispatch(char *path)
{
    LONG section;
    char *entryLine;
    char *separatorPtr;
    char *entryValue;

    section = PARSEINI_SECTION_NONE;
    if (PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer(path) == -1) {
        return -1;
    }

    for (;;) {
        entryLine = (char *)PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer();
        if ((LONG)entryLine == -1) {
            break;
        }
        if (*entryLine == 0) {
            continue;
        }

        if (*entryLine == '[') {
            separatorPtr = PARSEINI_JMPTBL_STR_FindCharPtr(entryLine + 1, ']');
            if (separatorPtr == (char *)0) {
                continue;
            }
            *separatorPtr = 0;
            entryLine += 1;

            if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryLine, P_TYPE_STR_QTABLE) == 0) {
                section = PARSEINI_SECTION_QTABLE;
                continue;
            }
            if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryLine, P_TYPE_TAG_GRADIENT) == 0) {
                section = PARSEINI_SECTION_GRADIENT;
                PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette(GCOMMAND_GradientPresetTable);
                continue;
            }
            if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryLine, P_TYPE_TAG_DEFAULT_TEXT) == 0) {
                section = PARSEINI_SECTION_DEFAULT_TEXT;
                P_TYPE_WeatherCurrentMsgPtr = PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(P_TYPE_WeatherCurrentMsgPtr, Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE);
                P_TYPE_WeatherForecastMsgPtr = PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(P_TYPE_WeatherForecastMsgPtr, SCRIPT_PtrNoForecastWeatherData);
                P_TYPE_WeatherBottomLineMsgPtr = PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(P_TYPE_WeatherBottomLineMsgPtr, SCRIPT_PtrWeatherDataAvailabilityDisclaimer);
                continue;
            }
            if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryLine, P_TYPE_STR_SOURCE_CONFIG) == 0) {
                section = PARSEINI_SECTION_SOURCE_CONFIG;
                TEXTDISP_ClearSourceConfig();
                continue;
            }
            if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryLine, P_TYPE_TAG_BRUSH) == 0) {
                section = PARSEINI_SECTION_BRUSH;
                continue;
            }

            section = PARSEINI_SECTION_NONE;
            continue;
        }

        separatorPtr = PARSEINI_JMPTBL_STR_FindCharPtr(entryLine, '=');
        if (separatorPtr == (char *)0) {
            continue;
        }
        *separatorPtr = 0;
        entryValue = separatorPtr + 1;

        if (section == PARSEINI_SECTION_BRUSH) {
            if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryLine, PARSEINI_TAG_FILENAME) == 0 ||
                PARSEINI_JMPTBL_STRING_CompareNoCase(entryLine, PARSEINI_TAG_BRUSH) == 0) {
                entryValue = PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator(entryValue);
                if (PARSEINI_JMPTBL_HANDLE_OpenWithMode(entryValue, PARSEINI_MODE_RB) != 0) {
                    PARSEINI_JMPTBL_ESQIFF_QueueIffBrushLoad(entryValue);
                    PARSEINI_JMPTBL_ESQIFF_HandleBrushIniReloadHotkey();
                }
            }
        } else if (section == PARSEINI_SECTION_WEATHER_BLOCKS) {
            PARSEINI_ProcessWeatherBlocks(entryLine, entryValue);
        } else if (section == PARSEINI_SECTION_DEFAULT_TEXT) {
            if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryLine, PARSEINI_STR_LOADWEATHER) == 0) {
                PARSEINI_LoadWeatherStrings(entryLine, entryValue);
            } else if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryLine, PARSEINI_STR_LOADWEATHERMESSAGE) == 0) {
                PARSEINI_LoadWeatherMessageStrings(entryLine, entryValue);
            } else if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryLine, PARSEINI_STR_LOADCOLORTABLE) == 0) {
                PARSEINI_ParseColorTable(entryLine, entryValue);
            }
        }
    }

    return 0;
}
