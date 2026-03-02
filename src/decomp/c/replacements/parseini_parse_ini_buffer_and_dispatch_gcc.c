#include "esq_types.h"

extern void *Global_PTR_WORK_BUFFER;
extern s32 Global_REF_LONG_FILE_SCRATCH;
extern s16 TEXTDISP_AliasCount;
extern s32 P_TYPE_WeatherBrushRefreshPendingFlag;
extern void *P_TYPE_WeatherCurrentMsgPtr;
extern void *P_TYPE_WeatherForecastMsgPtr;
extern void *P_TYPE_WeatherBottomLineMsgPtr;
extern void *Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE;
extern void *SCRIPT_PtrNoForecastWeatherData;
extern void *SCRIPT_PtrWeatherDataAvailabilityDisclaimer;
extern const char P_TYPE_STR_QTABLE[];
extern const char P_TYPE_TAG_BACKDROP[];
extern const char P_TYPE_TAG_GRADIENT[];
extern const char P_TYPE_TAG_TEXTADS[];
extern const char P_TYPE_TAG_BRUSH[];
extern const char P_TYPE_TAG_BANNER[];
extern const char P_TYPE_STR_DEFAULT_TEXT[];
extern const char P_TYPE_STR_SOURCE_CONFIG[];
extern u16 GCOMMAND_GradientPresetTable[];

s32 PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer(const char *path) __attribute__((noinline));
s32 PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer(void) __attribute__((noinline));
char *PARSEINI_JMPTBL_STR_FindCharPtr(char *s, s32 ch) __attribute__((noinline));
s32 PARSEINI_JMPTBL_STRING_CompareNoCase(const char *a, const char *b) __attribute__((noinline));
void PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette(u16 *table) __attribute__((noinline));
void *PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(const char *src, void *owned) __attribute__((noinline));
void TEXTDISP_ClearSourceConfig(void) __attribute__((noinline));
s32 PARSEINI_ProcessWeatherBlocks(const char *key, const char *value) __attribute__((noinline));
s32 PARSEINI_ParseRangeKeyValue(const char *line, u16 *table) __attribute__((noinline));
s32 PARSEINI_ParseColorTable(const char *key, const char *value, s32 mode) __attribute__((noinline));
void PARSEINI_LoadWeatherStrings(const char *key, const char *value) __attribute__((noinline));
void PARSEINI_LoadWeatherMessageStrings(const char *key, const char *value) __attribute__((noinline));

static int is_space(u8 c)
{
    return c == ' ' || c == '\t' || c == '\r' || c == '\n';
}

s32 PARSEINI_ParseIniBufferAndDispatch(const char *path) __attribute__((noinline, used));

s32 PARSEINI_ParseIniBufferAndDispatch(const char *path)
{
    s32 section = 0;
    s32 alias_idx = -1;
    s32 eof = -1;
    char *line;

    if (PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer(path) == eof) {
        return -1;
    }

    Global_REF_LONG_FILE_SCRATCH = (s32)(u32)Global_PTR_WORK_BUFFER;

    for (;;) {
        line = (char *)(u32)PARSEINI_JMPTBL_DISKIO_ConsumeLineFromWorkBuffer();
        if ((s32)(u32)line == eof) {
            break;
        }

        while (*line != '\0' && is_space((u8)*line)) {
            line++;
        }

        if (*line == '[') {
            char *name = line + 1;
            char *end = PARSEINI_JMPTBL_STR_FindCharPtr(name, ']');
            if (end == 0) {
                continue;
            }
            *end = '\0';

            if (PARSEINI_JMPTBL_STRING_CompareNoCase(name, P_TYPE_STR_QTABLE) == 0) {
                section = 1;
            } else if (PARSEINI_JMPTBL_STRING_CompareNoCase(name, P_TYPE_TAG_BACKDROP) == 0) {
                section = 2;
            } else if (PARSEINI_JMPTBL_STRING_CompareNoCase(name, P_TYPE_TAG_GRADIENT) == 0) {
                section = 3;
                PARSEINI_JMPTBL_GCOMMAND_InitPresetTableFromPalette(GCOMMAND_GradientPresetTable);
            } else if (PARSEINI_JMPTBL_STRING_CompareNoCase(name, P_TYPE_TAG_TEXTADS) == 0) {
                section = 4;
            } else if (PARSEINI_JMPTBL_STRING_CompareNoCase(name, P_TYPE_TAG_BRUSH) == 0) {
                section = 5;
            } else if (PARSEINI_JMPTBL_STRING_CompareNoCase(name, P_TYPE_TAG_BANNER) == 0) {
                section = 6;
                P_TYPE_WeatherBrushRefreshPendingFlag = 0;
            } else if (PARSEINI_JMPTBL_STRING_CompareNoCase(name, P_TYPE_STR_DEFAULT_TEXT) == 0) {
                section = 7;
                P_TYPE_WeatherCurrentMsgPtr =
                    PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString((const char *)Global_STR_PTR_NO_CURRENT_WEATHER_DATA_AVIALABLE, P_TYPE_WeatherCurrentMsgPtr);
                P_TYPE_WeatherForecastMsgPtr =
                    PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString((const char *)SCRIPT_PtrNoForecastWeatherData, P_TYPE_WeatherForecastMsgPtr);
                P_TYPE_WeatherBottomLineMsgPtr =
                    PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString((const char *)SCRIPT_PtrWeatherDataAvailabilityDisclaimer, P_TYPE_WeatherBottomLineMsgPtr);
            } else if (PARSEINI_JMPTBL_STRING_CompareNoCase(name, P_TYPE_STR_SOURCE_CONFIG) == 0) {
                section = 8;
                TEXTDISP_ClearSourceConfig();
            } else {
                section = 0;
            }
            continue;
        }

        if (section <= 0 || section >= 9) {
            continue;
        }

        {
            char *eq = PARSEINI_JMPTBL_STR_FindCharPtr(line, '=');
            if (eq == 0) {
                if (section == 1) {
                    TEXTDISP_AliasCount = 0;
                }
                continue;
            }

            *eq = '\0';
            eq++;
            while (*eq != '\0' && is_space((u8)*eq)) {
                eq++;
            }

            if (section == 1) {
                alias_idx++;
                TEXTDISP_AliasCount = (s16)(alias_idx + 1);
            } else if (section == 2) {
                PARSEINI_ProcessWeatherBlocks(line, eq);
            } else if (section == 3) {
                PARSEINI_ParseRangeKeyValue(line, GCOMMAND_GradientPresetTable);
            } else if (section == 4 || section == 5) {
                PARSEINI_ParseColorTable(line, eq, section);
            } else if (section == 6) {
                PARSEINI_LoadWeatherStrings(line, eq);
            } else if (section == 7) {
                PARSEINI_LoadWeatherMessageStrings(line, eq);
            }
        }
    }

    return 0;
}
