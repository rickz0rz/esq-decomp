typedef signed long LONG;

extern char *P_TYPE_WeatherCurrentMsgPtr;
extern char *P_TYPE_WeatherForecastMsgPtr;
extern char *P_TYPE_WeatherBottomLineMsgPtr;

extern char PARSEINI_STR_WEATHERCURRENT[];
extern char PARSEINI_STR_WEATHERFORECAST[];
extern char PARSEINI_STR_BOTTOMLINETAG[];

extern LONG PARSEINI_JMPTBL_STRING_CompareNoCase(char *a, char *b);
extern char *PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(char *newValue, char *oldValue);

void PARSEINI_LoadWeatherMessageStrings(char *keyName, char *keyValue)
{
    if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyName, PARSEINI_STR_WEATHERCURRENT) == 0) {
        P_TYPE_WeatherCurrentMsgPtr =
            PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(keyValue, P_TYPE_WeatherCurrentMsgPtr);
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyName, PARSEINI_STR_WEATHERFORECAST) == 0) {
        P_TYPE_WeatherForecastMsgPtr =
            PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(keyValue, P_TYPE_WeatherForecastMsgPtr);
        return;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyName, PARSEINI_STR_BOTTOMLINETAG) == 0) {
        P_TYPE_WeatherBottomLineMsgPtr =
            PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(keyValue, P_TYPE_WeatherBottomLineMsgPtr);
    }
}
