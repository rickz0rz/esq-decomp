extern unsigned short ESQ_CopperStatusDigitsA[];
extern unsigned short ESQ_CopperStatusDigitsB[];

void ESQ_MoveCopperEntryTowardStart(long dst_index, long src_index)
{
    short d1 = (short)(dst_index & 0x1F);
    short d2 = (short)(src_index & 0x1F);
    short d4 = 0x001C;
    unsigned char *a1 = (unsigned char *)ESQ_CopperStatusDigitsA;
    unsigned char *a0 = (unsigned char *)ESQ_CopperStatusDigitsB;
    short d3;
    unsigned short keep;

    d1 = (short)(d1 << 2);
    d2 = (short)(d2 << 2);
    d3 = (short)(d2 - 4);
    keep = *(unsigned short *)(a1 + d2);

    while (d2 >= d1) {
        unsigned short moved = *(unsigned short *)(a1 + d3);
        *(unsigned short *)(a1 + d2) = moved;
        if (d2 <= d4) {
            *(unsigned short *)(a0 + d2) = moved;
        }
        d2 = (short)(d2 - 4);
        d3 = (short)(d3 - 4);
    }

    *(unsigned short *)(a1 + d1) = keep;
    if (d2 < d4) {
        *(unsigned short *)(a0 + d1) = keep;
    }
}
