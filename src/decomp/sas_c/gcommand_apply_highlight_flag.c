#include <exec/types.h>
extern UWORD GCOMMAND_HighlightFlag;
extern UWORD ESQ_CopperEffectTemplateRowsSet0[];
extern UWORD ESQ_CopperEffectTemplateRowsSet1[];
extern UWORD ESQ_CopperListBannerA[];
extern UWORD ESQ_CopperListBannerB[];

void GCOMMAND_ApplyHighlightFlag(void)
{
    UWORD value;
    UWORD *base;
    UWORD temp;

    if (GCOMMAND_HighlightFlag != 0) {
        value = 2U;
    } else {
        value = 0U;
    }

    base = ESQ_CopperEffectTemplateRowsSet0;
    temp = base[13];
    temp &= (UWORD)-3;
    temp |= value;
    base[13] = temp;

    base = ESQ_CopperEffectTemplateRowsSet1;
    temp = base[13];
    temp &= (UWORD)-3;
    temp |= value;
    base[13] = temp;

    base = ESQ_CopperListBannerA;
    temp = base[15];
    temp &= (UWORD)-3;
    temp |= value;
    base[15] = temp;
    temp = base[57];
    temp &= (UWORD)-3;
    temp |= value;
    base[57] = temp;
    temp = base[339];
    temp &= (UWORD)-3;
    temp |= value;
    base[339] = temp;
    temp = base[363];
    temp &= (UWORD)-3;
    temp |= value;
    base[363] = temp;
    temp = base[1961];
    temp &= (UWORD)-3;
    temp |= value;
    base[1961] = temp;

    base = ESQ_CopperListBannerB;
    temp = base[15];
    temp &= (UWORD)-3;
    temp |= value;
    base[15] = temp;
    temp = base[57];
    temp &= (UWORD)-3;
    temp |= value;
    base[57] = temp;
    temp = base[339];
    temp &= (UWORD)-3;
    temp |= value;
    base[339] = temp;
    temp = base[363];
    temp &= (UWORD)-3;
    temp |= value;
    base[363] = temp;
    temp = base[1961];
    temp &= (UWORD)-3;
    temp |= value;
    base[1961] = temp;
}
