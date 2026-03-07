typedef unsigned char UBYTE;
typedef long LONG;

typedef struct DateTimePair {
    void *in_ptr;      /* +0 */
    void *out_ptr;     /* +4 */
    LONG in_seconds;   /* +8 */
    LONG out_seconds;  /* +12 */
} DateTimePair;

enum {
    DATETIME_STRUCT_COPY_COUNT = 21
};

extern LONG DATETIME_NormalizeStructToSeconds(void *dt);

LONG DATETIME_CopyPairAndRecalc(DateTimePair *pair, void *src_in, void *src_out)
{
    const LONG PTR_NULL = 0;
    LONG d0;
    UBYTE *src;
    UBYTE *dst;
    short count;

    d0 = (LONG)pair;
    if (pair == (DateTimePair *)PTR_NULL) {
        return d0;
    }
    if (pair->in_ptr == (void *)PTR_NULL) {
        return d0;
    }
    if (pair->out_ptr == (void *)PTR_NULL) {
        return d0;
    }

    src = (UBYTE *)src_in;
    dst = (UBYTE *)pair->in_ptr;
    count = DATETIME_STRUCT_COPY_COUNT;
    do {
        *dst++ = *src++;
    } while ((count--) != 0);

    src = (UBYTE *)src_out;
    dst = (UBYTE *)pair->out_ptr;
    count = DATETIME_STRUCT_COPY_COUNT;
    do {
        *dst++ = *src++;
    } while ((count--) != 0);

    pair->in_seconds = DATETIME_NormalizeStructToSeconds(src_in);
    d0 = DATETIME_NormalizeStructToSeconds(src_out);
    pair->out_seconds = d0;
    return d0;
}
