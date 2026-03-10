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
    LONG secondsResult;
    const UBYTE *src;
    UBYTE *dst;
    short copyCount;

    secondsResult = (LONG)pair;
    if (!pair) {
        return secondsResult;
    }
    if (!pair->in_ptr) {
        return secondsResult;
    }
    if (!pair->out_ptr) {
        return secondsResult;
    }

    src = src_in;
    dst = pair->in_ptr;
    copyCount = DATETIME_STRUCT_COPY_COUNT;
    do {
        *dst++ = *src++;
    } while ((copyCount--) != 0);

    src = src_out;
    dst = pair->out_ptr;
    copyCount = DATETIME_STRUCT_COPY_COUNT;
    do {
        *dst++ = *src++;
    } while ((copyCount--) != 0);

    pair->in_seconds = DATETIME_NormalizeStructToSeconds(src_in);
    secondsResult = DATETIME_NormalizeStructToSeconds(src_out);
    pair->out_seconds = secondsResult;
    return secondsResult;
}
