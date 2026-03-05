typedef unsigned char UBYTE;
typedef long LONG;

LONG COI_CountEscape14BeforeNull(UBYTE *buf, LONG max_len)
{
    LONG done;
    LONG idx;
    LONG count;

    done = 0;
    idx = 0;
    count = 0;

    while (done == 0) {
        LONG t;
        LONG c;

        t = idx;
        if (t >= max_len) {
            break;
        }

        c = (LONG)buf[(unsigned short)idx];
        if ((short)c == 0) {
            done = 1;
        } else if ((short)(c - 20) == 0) {
            count += 1;
            idx += 1;
        }

        idx += 1;
    }

    return count;
}
