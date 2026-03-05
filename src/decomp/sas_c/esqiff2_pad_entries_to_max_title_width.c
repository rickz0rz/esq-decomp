typedef unsigned char UBYTE;
typedef signed char BYTE;
typedef unsigned short UWORD;
typedef signed short WORD;
typedef signed long LONG;

extern BYTE TEXTDISP_SecondaryGroupCode;
extern BYTE TEXTDISP_PrimaryGroupCode;
extern WORD TEXTDISP_SecondaryGroupEntryCount;
extern WORD TEXTDISP_PrimaryGroupEntryCount;
extern WORD TEXTDISP_MaxEntryTitleLength;
extern UBYTE *TEXTDISP_SecondaryEntryPtrTable[];
extern UBYTE *TEXTDISP_PrimaryEntryPtrTable[];

extern LONG GROUP_AR_JMPTBL_STRING_AppendAtNull(char *dst, const char *src);

LONG ESQIFF2_PadEntriesToMaxTitleWidth(BYTE group_code)
{
    WORD entry_count;
    WORD d6;
    char space_buf[24];

    if (TEXTDISP_SecondaryGroupCode == group_code) {
        entry_count = TEXTDISP_SecondaryGroupEntryCount;
    } else if (TEXTDISP_PrimaryGroupCode == group_code) {
        entry_count = TEXTDISP_PrimaryGroupEntryCount;
    } else {
        return 0;
    }

    d6 = 0;
    while (d6 < entry_count) {
        UBYTE *entry;
        char *title;
        char *p;
        WORD pad;
        WORD d5;

        if (TEXTDISP_SecondaryGroupCode == group_code) {
            entry = TEXTDISP_SecondaryEntryPtrTable[(UWORD)d6];
        } else {
            entry = TEXTDISP_PrimaryEntryPtrTable[(UWORD)d6];
        }

        title = (char *)(entry + 1);
        p = title;
        while (*p != '\0') {
            ++p;
        }

        pad = (WORD)((LONG)TEXTDISP_MaxEntryTitleLength - (LONG)(p - title));
        if (pad > 0) {
            d5 = 0;
            while (d5 < 10) {
                space_buf[(UWORD)d5] = ' ';
                ++d5;
            }

            space_buf[(UWORD)pad] = '\0';
            GROUP_AR_JMPTBL_STRING_AppendAtNull(space_buf, title);

            p = space_buf;
            while (1) {
                *title = *p;
                if (*p == '\0') {
                    break;
                }
                ++title;
                ++p;
            }
        }

        ++d6;
    }

    return 0;
}
