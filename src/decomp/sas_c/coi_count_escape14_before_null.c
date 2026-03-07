typedef unsigned char UBYTE;
typedef long LONG;

enum {
    COI_DONE_FALSE = 0,
    COI_DONE_TRUE = 1
};

LONG COI_CountEscape14BeforeNull(UBYTE *buf, LONG max_len)
{
    LONG done;
    LONG idx;
    LONG count;

    done = COI_DONE_FALSE;
    idx = 0;
    count = 0;

    while (done == COI_DONE_FALSE) {
        LONG t;
        LONG c;

        t = idx;
        if (t >= max_len) {
            break;
        }

        c = (LONG)buf[(unsigned short)idx];
        if ((short)c == 0) {
            done = COI_DONE_TRUE;
        } else if ((short)(c - 20) == 0) {
            count += 1;
            idx += 1;
        }

        idx += 1;
    }

    return count;
}
