typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern LONG DST_BuildBannerTimeEntry(WORD lane, UBYTE slot_hint, WORD *out_word, void *ctx);

typedef struct DST_BannerTimeContext {
    UBYTE pad0[8];
    WORD hourWord8;
    WORD dayWord10;
    UBYTE pad12[6];
    WORD pmFlag18;
} DST_BannerTimeContext;

LONG DST_ComputeBannerIndex(void *ctx, WORD lane, UBYTE slot_hint)
{
    const LONG HOURS_PER_HALF_DAY = 12;
    const LONG PM_HOUR_OFFSET = 12;
    const WORD LATE_MONTH_DAY_THRESHOLD = 0x1d;
    const WORD BANNER_INDEX_BASE = 0x26;
    const WORD BANNER_INDEX_MODULUS = 48;
    const WORD BANNER_INDEX_BIAS = 1;
    DST_BannerTimeContext *p = (DST_BannerTimeContext *)ctx;
    WORD out_word = 0;
    LONG rem;
    LONG idx;
    LONG nonzero;
    WORD folded;

    DST_BuildBannerTimeEntry(lane, slot_hint, &out_word, ctx);

    rem = (LONG)((WORD)(p->hourWord8) % HOURS_PER_HALF_DAY);
    if (p->pmFlag18) {
        rem += PM_HOUR_OFFSET;
    }

    idx = rem + rem;
    if ((WORD)(p->dayWord10) > LATE_MONTH_DAY_THRESHOLD) {
        idx += 1;
    }

    nonzero = (idx != 0);
    folded = (WORD)((WORD)(nonzero + BANNER_INDEX_BASE) % BANNER_INDEX_MODULUS);

    return (LONG)(WORD)(folded + BANNER_INDEX_BIAS);
}
