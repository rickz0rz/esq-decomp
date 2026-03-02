#include "esq_types.h"

extern const char PARSEINI_STR_WEATHERCURRENT[];
extern const char PARSEINI_STR_WEATHERFORECAST[];
extern const char PARSEINI_STR_BOTTOMLINETAG[];

extern char *P_TYPE_WeatherCurrentMsgPtr;
extern char *P_TYPE_WeatherForecastMsgPtr;
extern char *P_TYPE_WeatherBottomLineMsgPtr;

s32 PARSEINI_JMPTBL_STRING_CompareNoCase(const char *a, const char *b) __attribute__((noinline));
char *PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(const char *src, char *old_ptr) __attribute__((noinline));

void PARSEINI_LoadWeatherMessageStrings(const char *key, const char *value) __attribute__((noinline, used));

void PARSEINI_LoadWeatherMessageStrings(const char *key, const char *value)
{
    if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_STR_WEATHERCURRENT) == 0) {
        P_TYPE_WeatherCurrentMsgPtr =
            PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(value, P_TYPE_WeatherCurrentMsgPtr);
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_STR_WEATHERFORECAST) == 0) {
        P_TYPE_WeatherForecastMsgPtr =
            PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(value, P_TYPE_WeatherForecastMsgPtr);
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_STR_BOTTOMLINETAG) == 0) {
        P_TYPE_WeatherBottomLineMsgPtr =
            PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(value, P_TYPE_WeatherBottomLineMsgPtr);
    }
}
