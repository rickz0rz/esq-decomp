typedef signed long LONG;
typedef unsigned char UBYTE;

extern void *PARSEINI_BannerBrushResourceHead;
extern void *PARSEINI_WeatherBrushNodePtr;
extern LONG P_TYPE_WeatherBrushRefreshPendingFlag;

extern char PARSEINI_TAG_FILENAME_WeatherString[];

extern LONG PARSEINI_JMPTBL_STRING_CompareNoCase(char *a, char *b);
extern void *PARSEINI_JMPTBL_BRUSH_AllocBrushNode(char *entryText, void *existingNode);

void PARSEINI_LoadWeatherStrings(char *keyName, char *keyValue)
{
    void *node;

    if (PARSEINI_BannerBrushResourceHead == (void *)0) {
        PARSEINI_WeatherBrushNodePtr = (void *)0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyName, PARSEINI_TAG_FILENAME_WeatherString) != 0) {
        return;
    }

    node = PARSEINI_JMPTBL_BRUSH_AllocBrushNode(keyValue, PARSEINI_WeatherBrushNodePtr);
    *((UBYTE *)node + 190) = 10;
    PARSEINI_WeatherBrushNodePtr = node;

    if (PARSEINI_BannerBrushResourceHead == (void *)0) {
        PARSEINI_BannerBrushResourceHead = node;
    }
}
