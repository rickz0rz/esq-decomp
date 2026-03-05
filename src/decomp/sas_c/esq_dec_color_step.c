unsigned short ESQ_DecColorStep(unsigned short color)
{
    unsigned short hi;
    unsigned short mid;
    unsigned short lo;

    hi = (unsigned short)(color & 0x0F00);
    mid = (unsigned short)(color & 0x00F0);
    lo = (unsigned short)(color & 0x000F);

    if (hi != 0) {
        hi = (unsigned short)(hi - 0x0100);
    }

    if (mid != 0) {
        mid = (unsigned short)(mid - 0x0010);
    }

    if (lo != 0) {
        lo = (unsigned short)(lo - 0x0001);
    }

    return (unsigned short)(lo + hi + mid);
}
