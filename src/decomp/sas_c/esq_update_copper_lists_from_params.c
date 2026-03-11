extern unsigned short HIGHLIGHT_CopperEffectSeed;
extern unsigned char ESQ_CopperEffectTemplateRowsSet0[];
extern unsigned char ESQ_CopperEffectListA[];
extern unsigned char ESQ_CopperEffectListB[];

#define ESQ_ROL32(v, n) (((v) << (n)) | ((v) >> (32u - (n))))

short ESQ_UpdateCopperListsFromParams(void)
{
    unsigned short d1;
    unsigned long d0 = *(unsigned long *)&HIGHLIGHT_CopperEffectSeed;
    unsigned char *a0 = ESQ_CopperEffectListA;
    unsigned char *a1 = ESQ_CopperEffectListB;
    unsigned short d3;
    unsigned short d4;

    d1 = *(unsigned short *)(ESQ_CopperEffectTemplateRowsSet0 + 26);
    a0 += 6;
    a1 += 6;

    d0 = (d0 & 0xFFFFFF00UL) | (unsigned long)((unsigned char)((unsigned char)d0 << 1));
    d0 = (d0 & 0xFFFFFF00UL) | (unsigned long)((unsigned char)((unsigned char)d0 << 1));
    d0 = (d0 & 0xFFFF0000UL) | (unsigned long)((unsigned short)((unsigned short)d0 << 1));
    d0 = (d0 & 0xFFFF0000UL) | (unsigned long)((unsigned short)((unsigned short)d0 << 1));
    d0 = (d0 << 16) | (d0 >> 16);
    if (((unsigned char)d0) == 0) {
        d0 = 0;
    }

    d0 = ESQ_ROL32(d0, 5);
    d3 = (unsigned short)(d1 & (unsigned short)~0x0100u);
    for (d4 = 0; d4 <= 15; ++d4) {
        unsigned short d2 = (unsigned short)(0x0100u & (unsigned short)d0);
        d2 = (unsigned short)(d2 | d3);

        *(unsigned short *)(a0 + 0) = d2;
        *(unsigned short *)(a1 + 0) = d2;
        *(unsigned short *)(a0 + 4) = d2;
        *(unsigned short *)(a1 + 4) = d2;
        *(unsigned short *)(a0 + 136) = d2;
        *(unsigned short *)(a1 + 136) = d2;
        *(unsigned short *)(a0 + 140) = d2;
        *(unsigned short *)(a1 + 140) = d2;

        a0 += 8;
        a1 += 8;
        d0 = ESQ_ROL32(d0, 1);
    }

    *(unsigned short *)(a0 + 0) = d1;
    *(unsigned short *)(a1 + 0) = d1;
    *(unsigned short *)(a0 + 136) = d1;
    *(unsigned short *)(a1 + 136) = d1;
    return 0;
}
