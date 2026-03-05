extern void ESQ_SetCopperEffectParams(unsigned char a, unsigned char b);

void ESQ_SetCopperEffect_Default(void)
{
    ESQ_SetCopperEffectParams(0, 0x3F);
}
