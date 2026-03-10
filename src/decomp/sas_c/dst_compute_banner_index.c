typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern void DST_BuildBannerTimeEntry(LONG arg0, LONG arg1, WORD *out_word, void *ctx);

typedef struct DST_BannerTimeContext {
    UBYTE pad0[8];
    WORD hourWord8;
    WORD dayWord10;
    UBYTE pad12[6];
    WORD pmFlag18;
} DST_BannerTimeContext;

LONG DST_ComputeBannerIndex(void *ctx, WORD arg_2, UBYTE arg_3)
{
    DST_BannerTimeContext *p = (DST_BannerTimeContext *)ctx;
    WORD out_word = 0;
    LONG rem;
    LONG idx;
    LONG nonzero;
    WORD folded;

    DST_BuildBannerTimeEntry((LONG)arg_2, (LONG)arg_3, &out_word, ctx);

    rem = (LONG)((WORD)(p->hourWord8) % 12);
    if (p->pmFlag18) {
        rem += 12;
    }

    idx = rem + rem;
    if ((WORD)(p->dayWord10) > 0x1d) {
        idx += 1;
    }

    nonzero = (idx != 0);
    folded = (WORD)((WORD)(nonzero + 0x26) % 48);

    return (LONG)(WORD)(folded + 1);
}
