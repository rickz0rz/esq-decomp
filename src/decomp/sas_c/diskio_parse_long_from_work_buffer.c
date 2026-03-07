typedef signed long LONG;
typedef unsigned char UBYTE;

enum {
    DISKIO_PARSE_RESULT_FAIL = 0xFFFF,
    DISKIO_WORKBUF_SENTINEL_ERROR = 0xFFFF
};

extern UBYTE *DISKIO_ConsumeCStringFromWorkBuffer(void);
extern LONG GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(UBYTE *text);

LONG DISKIO_ParseLongFromWorkBuffer(void)
{
    UBYTE *text;

    text = DISKIO_ConsumeCStringFromWorkBuffer();
    if (text == (UBYTE *)DISKIO_WORKBUF_SENTINEL_ERROR) {
        return DISKIO_PARSE_RESULT_FAIL;
    }

    return GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(text);
}
