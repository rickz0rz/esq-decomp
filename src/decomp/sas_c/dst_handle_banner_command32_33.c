typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct DST_ParsedDateTime {
    UBYTE raw[22];
} DST_ParsedDateTime;

extern void *DST_BannerWindowPrimary;
extern void *DST_BannerWindowSecondary;

extern void DATETIME_ParseString(void *out_struct, const char *text, LONG width);
extern LONG DATETIME_CopyPairAndRecalc(void *dst, const void *lhs, const void *rhs);
extern LONG DST_UpdateBannerQueue(void *pair);

void DST_HandleBannerCommand32_33(UBYTE cmd, const char *text)
{
    const UBYTE COMMAND_SECONDARY_WINDOW = 0x32;
    const UBYTE COMMAND_PRIMARY_WINDOW = 0x33;
    DST_ParsedDateTime parsedA;
    DST_ParsedDateTime parsedB;

    if (cmd == COMMAND_SECONDARY_WINDOW) {
        DATETIME_ParseString(&parsedA, text, 4);
        DATETIME_ParseString(&parsedB, text, 19);
        DATETIME_CopyPairAndRecalc(DST_BannerWindowSecondary, &parsedA, &parsedB);
    } else if (cmd == COMMAND_PRIMARY_WINDOW) {
        DATETIME_ParseString(&parsedA, text, 4);
        DATETIME_ParseString(&parsedB, text, 19);
        DATETIME_CopyPairAndRecalc(DST_BannerWindowPrimary, &parsedA, &parsedB);
    }

    DST_UpdateBannerQueue(&DST_BannerWindowPrimary);
}
