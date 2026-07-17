extern void ESQ_SetCopperEffectParams(unsigned char a, unsigned char b);
extern void GCOMMAND_DisableHighlight(void);

void ESQ_SetCopperEffect_OffDisableHighlight(void)
{
    volatile unsigned char *ciab_pra = (volatile unsigned char *)0x00BFE001UL;
    unsigned char v = *ciab_pra;
    v &= (unsigned char)~(1u << 6);
    v |= (unsigned char)(1u << 7);
    *ciab_pra = v;
    ESQ_SetCopperEffectParams(0, 0);
    GCOMMAND_DisableHighlight();
}
