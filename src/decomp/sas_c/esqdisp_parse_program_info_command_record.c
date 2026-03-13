typedef signed char BYTE;
typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

enum {
    CHARCLASS_LOWERCASE_MASK = 0x02,
    CHARCLASS_DIGIT_MASK = 0x04,
    CHARCLASS_HEX_MASK = 0x80,
    ASCII_ZERO = 48,
    ASCII_UPPERCASE_DELTA = 32,
    ASCII_Y = 89
};

#define RECORD_ENTRY_MARKER 0x12
#define RECORD_ATTR_MARKER 0x04

typedef struct ESQDISP_ProgramInfoEntry {
    UBYTE pad00[12];
    char titleText[28];
    UBYTE flags40;
    UBYTE field41;
    UBYTE field42;
    char field43[3];
    UWORD field46;
} ESQDISP_ProgramInfoEntry;

extern UBYTE TEXTDISP_SecondaryGroupCode;
extern UBYTE TEXTDISP_SecondaryGroupPresentFlag;
extern WORD TEXTDISP_SecondaryGroupEntryCount;
extern UBYTE TEXTDISP_PrimaryGroupCode;
extern WORD TEXTDISP_PrimaryGroupEntryCount;
extern ESQDISP_ProgramInfoEntry *TEXTDISP_PrimaryEntryPtrTable[];
extern ESQDISP_ProgramInfoEntry *TEXTDISP_SecondaryEntryPtrTable[];
extern const UBYTE WDISP_CharClassTable[];
extern const char ESQDISP_ProgramInfoZeroTag[];

extern LONG ESQIFF_JMPTBL_MATH_Mulu32(LONG value, LONG multiplier);
extern LONG ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit(BYTE ch);
extern char *ESQFUNC_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, LONG count);
extern void ESQDISP_FillProgramInfoHeaderFields(
    ESQDISP_ProgramInfoEntry *header,
    LONG field40,
    LONG field46,
    LONG field41,
    LONG field42,
    char *src);

static LONG ESQDISP_ParseOptionalDecimalDigit(UBYTE ch)
{
    if ((WDISP_CharClassTable[ch] & CHARCLASS_DIGIT_MASK) != 0) {
        return (LONG)ch - ASCII_ZERO;
    }

    return 0;
}

static UBYTE ESQDISP_ParseYesNoFlag(UBYTE ch, UBYTE bitMask)
{
    LONG code;

    code = (LONG)ch;
    if ((WDISP_CharClassTable[ch] & CHARCLASS_LOWERCASE_MASK) != 0) {
        code -= ASCII_UPPERCASE_DELTA;
    }

    if (code == ASCII_Y) {
        return bitMask;
    }

    return 0;
}

static UBYTE ESQDISP_ParseBoundedHexDigit(UBYTE ch, UBYTE maxValue, UBYTE minValue)
{
    LONG value;

    if ((WDISP_CharClassTable[ch] & CHARCLASS_HEX_MASK) == 0) {
        return 0xff;
    }

    value = ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit((BYTE)ch);
    if (value < (LONG)minValue || value > (LONG)maxValue) {
        return 0xff;
    }

    return (UBYTE)value;
}

static LONG ESQDISP_TitleMatches(const char *lhs, const char *rhs)
{
    while (*lhs == *rhs) {
        if (*lhs == 0) {
            return 1;
        }
        lhs++;
        rhs++;
    }

    return 0;
}

void ESQDISP_ParseProgramInfoCommandRecord(char *record)
{
    LONG entryCount;
    LONG fieldLength;
    char *namePtr;
    char *attrPtr;
    char attrText[3];
    ESQDISP_ProgramInfoEntry **entryTable;
    UBYTE groupCode;

    entryCount = 0;
    entryTable = (ESQDISP_ProgramInfoEntry **)0;
    groupCode = (UBYTE)*record++;

    if (groupCode == TEXTDISP_SecondaryGroupCode &&
        TEXTDISP_SecondaryGroupPresentFlag == 1) {
        entryCount = (LONG)(UWORD)TEXTDISP_SecondaryGroupEntryCount;
        entryTable = TEXTDISP_SecondaryEntryPtrTable;
    } else if (groupCode == TEXTDISP_PrimaryGroupCode) {
        entryCount = (LONG)(UWORD)TEXTDISP_PrimaryGroupEntryCount;
        entryTable = TEXTDISP_PrimaryEntryPtrTable;
    }

    fieldLength =
        ESQIFF_JMPTBL_MATH_Mulu32(ESQDISP_ParseOptionalDecimalDigit((UBYTE)record[0]), 10) +
        ESQDISP_ParseOptionalDecimalDigit((UBYTE)record[1]);
    record += 2;

    if (entryCount <= 0 || fieldLength < 6) {
        return;
    }

    attrText[2] = 0;

    for (;;) {
        LONG entryIndex;

        if ((UBYTE)*record != RECORD_ENTRY_MARKER) {
            return;
        }

        record += 1;
        namePtr = record;
        attrPtr = (char *)0;

        {
            LONG scanCount;

            for (scanCount = 0; scanCount < 6; ++scanCount) {
                record += 1;
                if ((UBYTE)*record == RECORD_ATTR_MARKER) {
                    *record++ = 0;
                    attrPtr = record;
                    record += fieldLength;
                    break;
                }
            }
        }

        if (attrPtr == 0) {
            continue;
        }

        for (entryIndex = 0; entryIndex < entryCount; ++entryIndex) {
            ESQDISP_ProgramInfoEntry *entry;
            UBYTE field40;
            UWORD field46;
            UBYTE field41;
            UBYTE field42;

            entry = entryTable[entryIndex];
            if (ESQDISP_TitleMatches(entry->titleText, namePtr) == 0) {
                continue;
            }

            field40 = entry->flags40;
            field46 = entry->field46;

            if (fieldLength > 0) {
                field40 =
                    (UBYTE)((field40 & (UBYTE)~0x02) |
                            ESQDISP_ParseYesNoFlag((UBYTE)attrPtr[0], 0x02));
            }

            if (fieldLength > 1) {
                field40 =
                    (UBYTE)((field40 & (UBYTE)~0x04) |
                            ESQDISP_ParseYesNoFlag((UBYTE)attrPtr[1], 0x04));
            }

            field41 = ESQDISP_ParseBoundedHexDigit((UBYTE)attrPtr[2], 15, 0);
            field42 = ESQDISP_ParseBoundedHexDigit((UBYTE)attrPtr[3], 3, 1);

            if (fieldLength > 5) {
                ESQFUNC_JMPTBL_STRING_CopyPadNul(attrText, &attrPtr[4], 2);
            } else {
                attrText[0] = ESQDISP_ProgramInfoZeroTag[0];
                attrText[1] = ESQDISP_ProgramInfoZeroTag[1];
            }

            if (fieldLength > 6) {
                field46 =
                    (UWORD)((field46 & (UWORD)~0x0001) |
                            (UWORD)ESQDISP_ParseYesNoFlag((UBYTE)attrPtr[6], 0x01));
            }

            if (fieldLength > 7) {
                field46 =
                    (UWORD)((field46 & (UWORD)~0x0002) |
                            (UWORD)ESQDISP_ParseYesNoFlag((UBYTE)attrPtr[7], 0x02));
            }

            if (fieldLength > 8) {
                field46 =
                    (UWORD)((field46 & (UWORD)~0x0004) |
                            (UWORD)ESQDISP_ParseYesNoFlag((UBYTE)attrPtr[8], 0x04));
            }

            if (fieldLength > 9) {
                field46 =
                    (UWORD)((field46 & (UWORD)~0x0008) |
                            (UWORD)ESQDISP_ParseYesNoFlag((UBYTE)attrPtr[9], 0x08));
            }

            if (fieldLength > 10) {
                field46 =
                    (UWORD)((field46 & (UWORD)~0x0010) |
                            (UWORD)ESQDISP_ParseYesNoFlag((UBYTE)attrPtr[10], 0x10));
            }

            ESQDISP_FillProgramInfoHeaderFields(
                entry,
                (LONG)field40,
                (LONG)field46,
                (LONG)field41,
                (LONG)field42,
                attrText
            );
        }
    }
}
