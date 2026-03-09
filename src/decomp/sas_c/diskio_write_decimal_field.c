typedef signed long LONG;
typedef unsigned char UBYTE;

enum {
    DISKIO_PRINTF_ARG_UNUSED = 0,
    DISKIO_DECIMAL_FIELD_BUFFER_LEN = 10
};

extern const char Global_STR_PERCENT_LD[];

extern LONG GROUP_AE_JMPTBL_WDISP_SPrintf(char *out, const char *fmt, LONG a, LONG b, LONG c);
extern LONG DISKIO_WriteBufferedBytes(LONG handle, const void *data, LONG len);

void DISKIO_WriteDecimalField(LONG handle, LONG value)
{
    char fieldBuffer[DISKIO_DECIMAL_FIELD_BUFFER_LEN];
    char *cursor = fieldBuffer;

    GROUP_AE_JMPTBL_WDISP_SPrintf(fieldBuffer,
                                  Global_STR_PERCENT_LD,
                                  value,
                                  DISKIO_PRINTF_ARG_UNUSED,
                                  DISKIO_PRINTF_ARG_UNUSED);

    while (*cursor++) {
    }

    DISKIO_WriteBufferedBytes(handle, fieldBuffer, (LONG)(cursor - fieldBuffer));
}
