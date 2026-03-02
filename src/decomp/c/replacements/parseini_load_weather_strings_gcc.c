#include "esq_types.h"

extern void *PARSEINI_BannerBrushResourceHead;
extern void *PARSEINI_WeatherBrushNodePtr;
extern s32 P_TYPE_WeatherBrushRefreshPendingFlag;

extern const char PARSEINI_TAG_FILENAME_WeatherString[];
extern const char PARSEINI_TAG_WEATHER[];

s32 PARSEINI_JMPTBL_STRING_CompareNoCase(const char *a, const char *b) __attribute__((noinline));
void *PARSEINI_JMPTBL_BRUSH_AllocBrushNode(const char *value, void *prev) __attribute__((noinline));

void PARSEINI_LoadWeatherStrings(const char *key, const char *value) __attribute__((noinline, used));

void PARSEINI_LoadWeatherStrings(const char *key, const char *value)
{
    if (PARSEINI_BannerBrushResourceHead == 0) {
        PARSEINI_WeatherBrushNodePtr = 0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_TAG_FILENAME_WeatherString) == 0) {
        void *node = PARSEINI_JMPTBL_BRUSH_AllocBrushNode(value, PARSEINI_WeatherBrushNodePtr);
        ((u8 *)node)[190] = 10;
        PARSEINI_WeatherBrushNodePtr = node;
        if (PARSEINI_BannerBrushResourceHead == 0) {
            PARSEINI_BannerBrushResourceHead = node;
        }
        return;
    }

    /* Mirrors current assembly: this branch is unreachable due to immediate zero-test. */
    if ((s32)0 != 0) {
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(key, PARSEINI_TAG_WEATHER) == 0) {
            void *node;
            P_TYPE_WeatherBrushRefreshPendingFlag = 1;
            node = PARSEINI_JMPTBL_BRUSH_AllocBrushNode(key, PARSEINI_WeatherBrushNodePtr);
            ((u8 *)node)[190] = 10;
            PARSEINI_WeatherBrushNodePtr = node;
            if (PARSEINI_BannerBrushResourceHead == 0) {
                PARSEINI_BannerBrushResourceHead = node;
            }
        }
    }
}
