extern void __regargs ESQ_SetCopperEffectParams(unsigned char a, unsigned char b);
extern void GCOMMAND_EnableHighlight(void);

void ESQ_SetCopperEffect_OnEnableHighlight(void)
{
    volatile unsigned char *ciab_pra = (volatile unsigned char *)0x00BFE001UL;
    unsigned char v = *ciab_pra;
    v |= (unsigned char)((1u << 6) | (1u << 7));
    *ciab_pra = v;
    ESQ_SetCopperEffectParams(0x3F, 0);
    GCOMMAND_EnableHighlight();
}
