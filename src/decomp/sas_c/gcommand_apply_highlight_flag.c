typedef signed long LONG;
typedef unsigned short UWORD;

extern UWORD GCOMMAND_HighlightFlag;
extern UWORD ESQ_CopperEffectTemplateRowsSet0[];
extern UWORD ESQ_CopperEffectTemplateRowsSet1[];
extern UWORD ESQ_CopperListBannerA[];
extern UWORD ESQ_CopperListBannerB[];

static void GCOMMAND_ApplyHighlightWord(UWORD *base, LONG wordOffset, LONG value)
{
    UWORD w = base[wordOffset];
    w = (UWORD)((w & (UWORD)~3U) | (UWORD)value);
    base[wordOffset] = w;
}

void GCOMMAND_ApplyHighlightFlag(void)
{
    LONG value = (GCOMMAND_HighlightFlag != 0) ? 2 : 0;

    GCOMMAND_ApplyHighlightWord(ESQ_CopperEffectTemplateRowsSet0, 13, value);
    GCOMMAND_ApplyHighlightWord(ESQ_CopperEffectTemplateRowsSet1, 13, value);

    GCOMMAND_ApplyHighlightWord(ESQ_CopperListBannerA, 15, value);
    GCOMMAND_ApplyHighlightWord(ESQ_CopperListBannerA, 57, value);
    GCOMMAND_ApplyHighlightWord(ESQ_CopperListBannerA, 339, value);
    GCOMMAND_ApplyHighlightWord(ESQ_CopperListBannerA, 363, value);
    GCOMMAND_ApplyHighlightWord(ESQ_CopperListBannerA, 1961, value);

    GCOMMAND_ApplyHighlightWord(ESQ_CopperListBannerB, 15, value);
    GCOMMAND_ApplyHighlightWord(ESQ_CopperListBannerB, 57, value);
    GCOMMAND_ApplyHighlightWord(ESQ_CopperListBannerB, 339, value);
    GCOMMAND_ApplyHighlightWord(ESQ_CopperListBannerB, 363, value);
    GCOMMAND_ApplyHighlightWord(ESQ_CopperListBannerB, 1961, value);
}
