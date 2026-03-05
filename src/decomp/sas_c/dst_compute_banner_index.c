typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern void DST_BuildBannerTimeEntry(LONG arg0, LONG arg1, WORD *out_word, void *ctx);

LONG DST_ComputeBannerIndex(void *ctx, WORD arg_2, UBYTE arg_3)
{
    UBYTE *p = (UBYTE *)ctx;
    WORD out_word = 0;
    LONG rem;
    LONG idx;
    LONG nonzero;
    WORD folded;

    DST_BuildBannerTimeEntry((LONG)arg_2, (LONG)arg_3, &out_word, ctx);

    rem = (LONG)((WORD)(*(WORD *)(p + 8)) % 12);
    if (*(WORD *)(p + 18) != 0) {
        rem += 12;
    }

    idx = rem + rem;
    if ((WORD)(*(WORD *)(p + 10)) > 0x1d) {
        idx += 1;
    }

    nonzero = (idx != 0) ? 1 : 0;
    folded = (WORD)((WORD)(nonzero + 0x26) % 48);

    return (LONG)(WORD)(folded + 1);
}
