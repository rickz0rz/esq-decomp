typedef signed long LONG;

extern char *P_TYPE_WeatherCurrentMsgPtr;
extern char *P_TYPE_WeatherForecastMsgPtr;
extern char *P_TYPE_WeatherBottomLineMsgPtr;

extern const char PARSEINI_STR_WEATHERCURRENT[];
extern const char PARSEINI_STR_WEATHERFORECAST[];
extern const char PARSEINI_STR_BOTTOMLINETAG[];

extern LONG STRING_CompareNoCase(const char *a, const char *b);
extern char *ESQPARS_ReplaceOwnedString(const char *newValue, char *oldValue);

void PARSEINI_LoadWeatherMessageStrings(const char *entryKey, char *entryValue)
{
    if (STRING_CompareNoCase(entryKey, PARSEINI_STR_WEATHERCURRENT) == 0) {
        P_TYPE_WeatherCurrentMsgPtr =
            ESQPARS_ReplaceOwnedString(entryValue, P_TYPE_WeatherCurrentMsgPtr);
        return;
    }

    if (STRING_CompareNoCase(entryKey, PARSEINI_STR_WEATHERFORECAST) == 0) {
        P_TYPE_WeatherForecastMsgPtr =
            ESQPARS_ReplaceOwnedString(entryValue, P_TYPE_WeatherForecastMsgPtr);
        return;
    }

    if (STRING_CompareNoCase(entryKey, PARSEINI_STR_BOTTOMLINETAG) == 0) {
        P_TYPE_WeatherBottomLineMsgPtr =
            ESQPARS_ReplaceOwnedString(entryValue, P_TYPE_WeatherBottomLineMsgPtr);
    }
}
