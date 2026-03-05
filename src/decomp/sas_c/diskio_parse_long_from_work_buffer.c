typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE *DISKIO_ConsumeCStringFromWorkBuffer(void);
extern LONG GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(UBYTE *text);

LONG DISKIO_ParseLongFromWorkBuffer(void)
{
    UBYTE *text;

    text = DISKIO_ConsumeCStringFromWorkBuffer();
    if (text == (UBYTE *)0xFFFF) {
        return 0xFFFF;
    }

    return GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(text);
}
