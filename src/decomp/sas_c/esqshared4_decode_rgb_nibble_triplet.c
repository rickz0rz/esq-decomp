typedef unsigned char UBYTE;
typedef unsigned short UWORD;

UWORD ESQSHARED4_DecodeRgbNibbleTriplet(UBYTE *src)
{
    UWORD r;
    UWORD g;
    UWORD b;

    r = (UWORD)(*src++ & 0x0F);
    g = (UWORD)(*src++ & 0x0F);
    b = (UWORD)(*src++ & 0x0F);

    return (UWORD)((r << 8) + (g << 4) + b);
}
