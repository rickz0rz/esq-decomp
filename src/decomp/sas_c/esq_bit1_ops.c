long ESQ_TestBit1Based(unsigned char *base, unsigned long bitIndex)
{
    unsigned long n = bitIndex - 1;
    unsigned long byte_i = (n & 0xFFFFUL) >> 3;
    unsigned long bit_i = n & 7UL;
    return (base[byte_i] & (1UL << bit_i)) ? -1L : 0L;
}

void ESQ_SetBit1Based(unsigned char *base, unsigned long bitIndex)
{
    unsigned long n = bitIndex - 1;
    unsigned long byte_i = (n & 0xFFFFUL) >> 3;
    unsigned long bit_i = n & 7UL;
    base[byte_i] |= (unsigned char)(1UL << bit_i);
}
