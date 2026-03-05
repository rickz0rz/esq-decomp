unsigned char *ESQ_PackBitsDecode(unsigned char *src, unsigned char *dst, long dstLen)
{
    unsigned short outCount = 0;
    signed char code;
    unsigned char runByte;

    for (;;) {
        if (outCount >= (unsigned short)dstLen) {
            break;
        }

        code = (signed char)*src++;

        if (code >= 0) {
            code = (signed char)(code + 1);
            while (code > 0) {
                *dst++ = *src++;
                outCount++;
                if (outCount >= (unsigned short)dstLen) {
                    goto done;
                }
                code = (signed char)(code - 1);
            }
            continue;
        }

        if (code == -1) {
            continue;
        }

        code = (signed char)(-code + 1);
        runByte = *src++;
        while (code > 0) {
            *dst++ = runByte;
            outCount++;
            if (outCount >= (unsigned short)dstLen) {
                goto done;
            }
            code = (signed char)(code - 1);
        }
    }

done:
    return src;
}
