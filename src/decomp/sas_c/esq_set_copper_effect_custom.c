extern unsigned char HIGHLIGHT_CustomValue;
extern void ESQ_SetCopperEffectParams(unsigned char a, unsigned char b);

void ESQ_SetCopperEffect_Custom(void)
{
    volatile unsigned char *ciab_pra = (volatile unsigned char *)0x00BFE001UL;
    unsigned char v = *ciab_pra;
    v |= (unsigned char)((1u << 6) | (1u << 7));
    *ciab_pra = v;
    ESQ_SetCopperEffectParams(0x3F, HIGHLIGHT_CustomValue);
}
