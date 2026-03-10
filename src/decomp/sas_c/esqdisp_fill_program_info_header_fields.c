typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef signed short WORD;
typedef unsigned long ULONG;

typedef struct ProgramInfoHeader {
    UBYTE pad_00[40];
    UBYTE field40;
    UBYTE field41;
    UBYTE field42;
    UBYTE field43[2];
    UBYTE field45;
    UWORD field46;
} ProgramInfoHeader;

extern char *ESQFUNC_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, ULONG count);

void ESQDISP_FillProgramInfoHeaderFields(
    ProgramInfoHeader *header,
    UBYTE b40,
    WORD w46,
    UBYTE b41,
    UBYTE b42,
    char *src)
{
    if (header == 0) {
        return;
    }

    header->field40 = b40;
    header->field46 = (UWORD)w46;
    header->field41 = b41;
    header->field42 = b42;

    ESQFUNC_JMPTBL_STRING_CopyPadNul(header->field43, src, 2);

    header->field45 = 0;
}
