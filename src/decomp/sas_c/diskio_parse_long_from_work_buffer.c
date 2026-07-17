#include <exec/types.h>
#define DISKIO_PARSE_RESULT_FAIL      0xFFFF
#define DISKIO_WORKBUF_SENTINEL_ERROR (-1)   /* ConsumeCString returns (char*)-1 */

extern char *DISKIO_ConsumeCStringFromWorkBuffer(void);
extern LONG PARSE_ReadSignedLongSkipClass3_Alt(const char *text);

LONG DISKIO_ParseLongFromWorkBuffer(void)
{
    char *numericText;

    numericText = DISKIO_ConsumeCStringFromWorkBuffer();
    if ((LONG)numericText == DISKIO_WORKBUF_SENTINEL_ERROR) {
        return DISKIO_PARSE_RESULT_FAIL;
    }

    return PARSE_ReadSignedLongSkipClass3_Alt(numericText);
}
