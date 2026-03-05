typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;
typedef unsigned long ULONG;

extern void DST_BuildBannerTimeEntry(LONG arg0, LONG arg1, WORD *out_word, ULONG arg3);

LONG DST_BuildBannerTimeWord(WORD arg_1, LONG arg_2, UBYTE arg_3)
{
    WORD out_word = 0;
    DST_BuildBannerTimeEntry((LONG)arg_1, (LONG)arg_3, &out_word, 0);
    (void)arg_2;
    return (LONG)out_word;
}
