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
    DST_BannerTimeContext *p = (DST_BannerTimeContext *)ctx;
    WORD out_word = 0;
    LONG rem;
    LONG idx;
    LONG nonzero;
    WORD folded;
    LONG result;

    DST_BuildBannerTimeEntry(lane, slot_hint, &out_word, ctx);

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
    result = (LONG)folded;
    result += 1;

    return result;
}
