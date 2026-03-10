typedef signed long LONG;
typedef unsigned char UBYTE;

extern void *DST_BannerWindowPrimary;
extern void *DST_BannerWindowSecondary;

extern void DATETIME_ParseString(void *out_struct, const char *text, LONG width);
extern LONG DATETIME_CopyPairAndRecalc(void *dst, const void *lhs, const void *rhs);
extern LONG DST_UpdateBannerQueue(void *pair);

void DST_HandleBannerCommand32_33(UBYTE cmd, const char *text)
{
    UBYTE parsed_a[22];
    UBYTE parsed_b[22];

    if (cmd == 0x32) {
        DATETIME_ParseString(parsed_a, text, 4);
        DATETIME_ParseString(parsed_b, text, 19);
        DATETIME_CopyPairAndRecalc(DST_BannerWindowSecondary, parsed_a, parsed_b);
    } else if (cmd == 0x33) {
        DATETIME_ParseString(parsed_a, text, 4);
        DATETIME_ParseString(parsed_b, text, 19);
        DATETIME_CopyPairAndRecalc(DST_BannerWindowPrimary, parsed_a, parsed_b);
    }

    DST_UpdateBannerQueue(&DST_BannerWindowPrimary);
}
