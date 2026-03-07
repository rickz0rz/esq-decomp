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
    LONG secondsResult;
    UBYTE *src;
    UBYTE *dst;
    short copyCount;

    secondsResult = (LONG)pair;
    if (pair == (DateTimePair *)PTR_NULL) {
        return secondsResult;
    }
    if (pair->in_ptr == (void *)PTR_NULL) {
        return secondsResult;
    }
    if (pair->out_ptr == (void *)PTR_NULL) {
        return secondsResult;
    }

    src = (UBYTE *)src_in;
    dst = (UBYTE *)pair->in_ptr;
    copyCount = DATETIME_STRUCT_COPY_COUNT;
    do {
        *dst++ = *src++;
    } while ((copyCount--) != 0);

    src = (UBYTE *)src_out;
    dst = (UBYTE *)pair->out_ptr;
    copyCount = DATETIME_STRUCT_COPY_COUNT;
    do {
        *dst++ = *src++;
    } while ((copyCount--) != 0);

    pair->in_seconds = DATETIME_NormalizeStructToSeconds(src_in);
    secondsResult = DATETIME_NormalizeStructToSeconds(src_out);
    pair->out_seconds = secondsResult;
    return secondsResult;
}
