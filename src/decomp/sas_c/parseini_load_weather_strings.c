typedef signed long LONG;
typedef unsigned char UBYTE;

extern void *PARSEINI_BannerBrushResourceHead;
extern void *PARSEINI_WeatherBrushNodePtr;
extern LONG P_TYPE_WeatherBrushRefreshPendingFlag;

extern const char PARSEINI_TAG_FILENAME_WeatherString[];

extern LONG PARSEINI_JMPTBL_STRING_CompareNoCase(const char *a, const char *b);
extern void *PARSEINI_JMPTBL_BRUSH_AllocBrushNode(char *entryText, void *existingNode);

void PARSEINI_LoadWeatherStrings(char *entryKey, char *entryValue)
{
    void *weatherNode;

    if (PARSEINI_BannerBrushResourceHead == (void *)0) {
        PARSEINI_WeatherBrushNodePtr = (void *)0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryKey, PARSEINI_TAG_FILENAME_WeatherString) != 0) {
        return;
    }

    weatherNode = PARSEINI_JMPTBL_BRUSH_AllocBrushNode(entryValue, PARSEINI_WeatherBrushNodePtr);
    *((UBYTE *)weatherNode + 190) = 10;
    PARSEINI_WeatherBrushNodePtr = weatherNode;

    if (PARSEINI_BannerBrushResourceHead == (void *)0) {
        PARSEINI_BannerBrushResourceHead = weatherNode;
    }
}
