unsigned short ESQ_BumpColorTowardTargets(unsigned short color, unsigned char *targets)
{
    unsigned short red;
    unsigned short green;
    unsigned short blue;
    unsigned short t;

    red = (unsigned short)(color & 0x0F00);
    green = (unsigned short)(color & 0x00F0);
    blue = (unsigned short)(color & 0x000F);

    t = (unsigned short)(*targets++);
    t = (unsigned short)(t << 8);
    if (red != t) {
        red = (unsigned short)(red + 0x0100);
    }

    t = (unsigned short)(*targets++);
    t = (unsigned short)(t << 4);
    if (green != t) {
        green = (unsigned short)(green + 0x0010);
    }

    t = (unsigned short)(*targets++);
    if (blue != t) {
        blue = (unsigned short)(blue + 0x0001);
    }

    return (unsigned short)(blue + red + green);
}
