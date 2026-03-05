extern unsigned char WDISP_PaletteTriplesRBase[];
extern unsigned short ESQ_CopperStatusDigitsA[];
extern unsigned short ESQ_CopperStatusDigitsB[];
extern unsigned short ESQ_BumpColorTowardTargets(unsigned short color, const unsigned char *targets);

void ESQ_IncCopperListsTowardsTargets(void)
{
    unsigned char *targets = WDISP_PaletteTriplesRBase;
    unsigned char *a = (unsigned char *)ESQ_CopperStatusDigitsA;
    unsigned char *b = (unsigned char *)ESQ_CopperStatusDigitsB;
    short off = 0;
    short i;

    for (i = 0; i <= 7; ++i) {
        unsigned short v = *(unsigned short *)(a + off);
        v = ESQ_BumpColorTowardTargets(v, targets);
        *(unsigned short *)(a + off) = v;
        *(unsigned short *)(b + off) = v;
        off = (short)(off + 4);
        targets += 3;
    }

    for (i = 0; i <= 23; ++i) {
        unsigned short v = *(unsigned short *)(a + off);
        v = ESQ_BumpColorTowardTargets(v, targets);
        *(unsigned short *)(a + off) = v;
        off = (short)(off + 4);
        targets += 3;
    }
}
