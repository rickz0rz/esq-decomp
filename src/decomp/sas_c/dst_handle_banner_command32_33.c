typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct DST_ParsedDateTime {
    UBYTE raw[22];
} DST_ParsedDateTime;

typedef struct DST_BannerWindowPair {
    void *in_ptr;
    void *out_ptr;
} DST_BannerWindowPair;

extern DST_BannerWindowPair *DST_BannerWindowPrimary;
extern DST_BannerWindowPair *DST_BannerWindowSecondary;

extern void DATETIME_ParseString(void *out_struct, const char *text, LONG width);
extern LONG DATETIME_CopyPairAndRecalc(DST_BannerWindowPair *dst, const void *lhs, const void *rhs);
extern LONG DST_UpdateBannerQueue(DST_BannerWindowPair **pair);

void DST_HandleBannerCommand32_33(UBYTE cmd, const char *text)
{
    const UBYTE COMMAND_SECONDARY_WINDOW = 0x32;
    const UBYTE COMMAND_PRIMARY_WINDOW = 0x33;
    const LONG PARSE_PREFIX_WIDTH = 4;
    const LONG PARSE_DATETIME_WIDTH = 19;
    DST_ParsedDateTime parsedA;
    DST_ParsedDateTime parsedB;

    if (cmd == COMMAND_SECONDARY_WINDOW) {
        DATETIME_ParseString(&parsedA, text, PARSE_PREFIX_WIDTH);
        DATETIME_ParseString(&parsedB, text, PARSE_DATETIME_WIDTH);
        DATETIME_CopyPairAndRecalc(DST_BannerWindowSecondary, &parsedA, &parsedB);
    } else if (cmd == COMMAND_PRIMARY_WINDOW) {
        DATETIME_ParseString(&parsedA, text, PARSE_PREFIX_WIDTH);
        DATETIME_ParseString(&parsedB, text, PARSE_DATETIME_WIDTH);
        DATETIME_CopyPairAndRecalc(DST_BannerWindowPrimary, &parsedA, &parsedB);
    }

    DST_UpdateBannerQueue(&DST_BannerWindowPrimary);
}
