typedef signed long LONG;
typedef unsigned char UBYTE;

#define DISKIO_PARSE_RESULT_FAIL      0xFFFF
#define DISKIO_WORKBUF_SENTINEL_ERROR 0xFFFF

extern char *DISKIO_ConsumeCStringFromWorkBuffer(void);
extern LONG GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(const char *text);

LONG DISKIO_ParseLongFromWorkBuffer(void)
{
    char *numericText;

    numericText = DISKIO_ConsumeCStringFromWorkBuffer();
    if ((LONG)numericText == DISKIO_WORKBUF_SENTINEL_ERROR) {
        return DISKIO_PARSE_RESULT_FAIL;
    }

    return GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(numericText);
}
