void ESQ_ReverseBitsIn6Bytes(unsigned char *dst, unsigned char *src)
{
    unsigned short i;
    unsigned char inb;
    unsigned char outb;
    unsigned char bit;

    for (i = 0; i < 6; i++) {
        inb = *src++;

        if (inb == 0 || inb == 0xFF) {
            *dst++ = inb;
            continue;
        }

        outb = 0;
        for (bit = 0; bit < 8; bit++) {
            if (inb & (1U << bit)) {
                outb |= (unsigned char)(1U << (7 - bit));
            }
        }

        *dst++ = outb;
    }
}
