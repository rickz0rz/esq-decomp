extern unsigned char HIGHLIGHT_CopperEffectParamA;
extern unsigned char HIGHLIGHT_CopperEffectParamB;
extern unsigned short HIGHLIGHT_CopperEffectSeed;
extern void ESQ_UpdateCopperListsFromParams(void);

void ESQ_SetCopperEffectParams(unsigned char a, unsigned char b)
{
    HIGHLIGHT_CopperEffectParamA = a;
    HIGHLIGHT_CopperEffectParamB = b;
    HIGHLIGHT_CopperEffectSeed = 5;
    ESQ_UpdateCopperListsFromParams();
}
