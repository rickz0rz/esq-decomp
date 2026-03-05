extern unsigned short ESQ_CopperStatusDigitsA[];
extern unsigned short ESQ_CopperStatusDigitsB[];
extern unsigned short ESQ_DecColorStep(unsigned short color);

void ESQ_DecCopperListsPrimary(void)
{
    unsigned char *a = (unsigned char *)ESQ_CopperStatusDigitsA;
    unsigned char *b = (unsigned char *)ESQ_CopperStatusDigitsB;
    short off = 0;
    short i;

    for (i = 0; i <= 7; ++i) {
        unsigned short v = *(unsigned short *)(a + off);
        v = ESQ_DecColorStep(v);
        *(unsigned short *)(a + off) = v;
        *(unsigned short *)(b + off) = v;
        off = (short)(off + 4);
    }

    for (i = 0; i <= 23; ++i) {
        unsigned short v = *(unsigned short *)(a + off);
        v = ESQ_DecColorStep(v);
        *(unsigned short *)(a + off) = v;
        off = (short)(off + 4);
    }
}
