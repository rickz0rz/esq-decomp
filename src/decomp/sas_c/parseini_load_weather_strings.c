#include <exec/types.h>
typedef struct PARSEINI_BrushNode {
    UBYTE pad0[190];
    UBYTE typeByte;
} PARSEINI_BrushNode;

extern void *PARSEINI_BannerBrushResourceHead;
extern void *PARSEINI_WeatherBrushNodePtr;
extern LONG P_TYPE_WeatherBrushRefreshPendingFlag;

extern const char PARSEINI_TAG_FILENAME_WeatherString[];

extern LONG STRING_CompareNoCase(const char *a, const char *b);
extern void *BRUSH_AllocBrushNode(char *entryText, void *existingNode);

void PARSEINI_LoadWeatherStrings(const char *entryKey, char *entryValue)
{
    PARSEINI_BrushNode *weatherNode;

    if (PARSEINI_BannerBrushResourceHead == (void *)0) {
        PARSEINI_WeatherBrushNodePtr = (void *)0;
    }

    if (STRING_CompareNoCase(entryKey, PARSEINI_TAG_FILENAME_WeatherString) != 0) {
        return;
    }

    weatherNode = (PARSEINI_BrushNode *)BRUSH_AllocBrushNode(entryValue, PARSEINI_WeatherBrushNodePtr);
    weatherNode->typeByte = (UBYTE)10;
    PARSEINI_WeatherBrushNodePtr = (void *)weatherNode;

    if (PARSEINI_BannerBrushResourceHead == (void *)0) {
        PARSEINI_BannerBrushResourceHead = (void *)weatherNode;
    }
}
