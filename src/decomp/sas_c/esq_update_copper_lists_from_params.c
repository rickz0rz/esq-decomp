extern unsigned short HIGHLIGHT_CopperEffectSeed;
extern unsigned char ESQ_CopperEffectTemplateRowsSet0[];
extern unsigned char ESQ_CopperEffectListA[];
extern unsigned char ESQ_CopperEffectListB[];

static unsigned long rol32(unsigned long v, unsigned short n)
{
    const unsigned short ROL_WIDTH = 32u;
    return (v << n) | (v >> (ROL_WIDTH - n));
}

short ESQ_UpdateCopperListsFromParams(void)
{
    const unsigned short TEMPLATE_WORD_OFFSET = 26;
    const unsigned short LIST_WORD_OFFSET = 6;
    const unsigned short MASK_CLEAR_BIT8 = (unsigned short)~0x0100u;
    const unsigned short MASK_KEEP_BIT8 = 0x0100u;
    const unsigned short LOOP_MAX = 15;
    const unsigned short SLOT_DELTA = 8;
    const unsigned short ROW2_OFFSET = 136;
    const unsigned short ROW2_NEXT_OFFSET = 140;
    const unsigned short ENTRY_NEXT_OFFSET = 4;
    const unsigned short ROL_SEED = 5;
    const unsigned short ROL_STEP = 1;
    const unsigned long MASK_KEEP_HI24 = 0xFFFFFF00UL;
    const unsigned long MASK_KEEP_HI16 = 0xFFFF0000UL;
    const unsigned short SWAP16_SHIFT = 16;
    unsigned short d1 = *(unsigned short *)(ESQ_CopperEffectTemplateRowsSet0 + 26);
    unsigned long d0 = *(unsigned long *)&HIGHLIGHT_CopperEffectSeed;
    unsigned char *a0 = ESQ_CopperEffectListA + LIST_WORD_OFFSET;
    unsigned char *a1 = ESQ_CopperEffectListB + LIST_WORD_OFFSET;
    unsigned short d3;
    unsigned short d4;

    d1 = *(unsigned short *)(ESQ_CopperEffectTemplateRowsSet0 + TEMPLATE_WORD_OFFSET);
    d0 = (d0 & MASK_KEEP_HI24) | (unsigned long)((unsigned char)((unsigned char)d0 << 1));
    d0 = (d0 & MASK_KEEP_HI24) | (unsigned long)((unsigned char)((unsigned char)d0 << 1));
    d0 = (d0 & MASK_KEEP_HI16) | (unsigned long)((unsigned short)((unsigned short)d0 << 1));
    d0 = (d0 & MASK_KEEP_HI16) | (unsigned long)((unsigned short)((unsigned short)d0 << 1));
    d0 = (d0 << SWAP16_SHIFT) | (d0 >> SWAP16_SHIFT);
    if (((unsigned char)d0) == 0) {
        d0 = 0;
    }

    d0 = rol32(d0, ROL_SEED);
    d3 = (unsigned short)(d1 & MASK_CLEAR_BIT8);
    for (d4 = 0; d4 <= LOOP_MAX; ++d4) {
        unsigned short d2 = (unsigned short)(MASK_KEEP_BIT8 & (unsigned short)d0);
        d2 = (unsigned short)(d2 | d3);

        *(unsigned short *)(a0 + 0) = d2;
        *(unsigned short *)(a1 + 0) = d2;
        *(unsigned short *)(a0 + ENTRY_NEXT_OFFSET) = d2;
        *(unsigned short *)(a1 + ENTRY_NEXT_OFFSET) = d2;
        *(unsigned short *)(a0 + ROW2_OFFSET) = d2;
        *(unsigned short *)(a1 + ROW2_OFFSET) = d2;
        *(unsigned short *)(a0 + ROW2_NEXT_OFFSET) = d2;
        *(unsigned short *)(a1 + ROW2_NEXT_OFFSET) = d2;

        a0 += SLOT_DELTA;
        a1 += SLOT_DELTA;
        d0 = rol32(d0, ROL_STEP);
    }

    *(unsigned short *)(a0 + 0) = d1;
    *(unsigned short *)(a1 + 0) = d1;
    *(unsigned short *)(a0 + ROW2_OFFSET) = d1;
    *(unsigned short *)(a1 + ROW2_OFFSET) = d1;
    return 0;
}
