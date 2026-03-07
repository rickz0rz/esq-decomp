typedef unsigned char UBYTE;
typedef long LONG;

enum {
    TOKEN_BUF_LEN = 11,
    TOKEN_MAX_LEN = 10,
    TOKEN_PREFIX_MAX_LEN = 5,
    TOKEN_FIELD_BOOL_MAX_INDEX = 5,
    TOKEN_FIELD_HEX_MAX_INDEX = 7,
    TOKEN_SEPARATOR = ':',
    ASCII_CASE_DELTA = 32,
    CHARCLASS_ALPHA_MASK = 2,
    CHARCLASS_ALNUM_MASK = 7,
    CHARCLASS_HEX_MASK = 0x80
};

extern UBYTE CLOCK_STR_TOKEN_PAIR_DEFAULTS[];
extern UBYTE CLEANUP_TokenPairScratch[];
extern UBYTE CLOCK_STR_TOKEN_OUTPUT_TEMPLATE[];
extern UBYTE CLOCK_STR_EMPTY_TOKEN_TEMPLATE[];
extern UBYTE CLOCK_STR_BOOL_CHARS_YyNn[];
extern UBYTE WDISP_CharClassTable[];

UBYTE *GROUP_AI_JMPTBL_STR_FindCharPtr(const UBYTE *s, LONG c);
LONG GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(void *old_ptr, const void *new_ptr);

void CLEANUP_FormatEntryStringTokens(void **field_a, void **field_b, UBYTE *input)
{
    UBYTE defaultTokenText[11];
    UBYTE formattedTokenText[11];
    LONG i;
    UBYTE *separatorPtr;

    if (input == (UBYTE *)0 || input[0] == 0 || GROUP_AI_JMPTBL_STR_FindCharPtr(input, TOKEN_SEPARATOR) == (UBYTE *)0) {
        *field_a = (void *)GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*field_a, (void *)0);
        *field_b = (void *)GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*field_b, CLOCK_STR_EMPTY_TOKEN_TEMPLATE);
        return;
    }

    for (i = 0; i < TOKEN_MAX_LEN; i += 1) {
        defaultTokenText[i] = CLOCK_STR_TOKEN_PAIR_DEFAULTS[i];
    }
    defaultTokenText[TOKEN_MAX_LEN] = 0;

    i = 0;
    while (CLEANUP_TokenPairScratch[i] != 0) {
        formattedTokenText[i] = CLEANUP_TokenPairScratch[i];
        i += 1;
    }
    formattedTokenText[i] = 0;

    i = 0;
    while (i < TOKEN_PREFIX_MAX_LEN && input[i] != TOKEN_SEPARATOR && input[i] != 0) {
        formattedTokenText[i] = input[i];
        i += 1;
    }
    formattedTokenText[i] = 0;

    *field_a = (void *)GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*field_a, formattedTokenText);

    i = 0;
    while (CLOCK_STR_TOKEN_OUTPUT_TEMPLATE[i] != 0) {
        formattedTokenText[i] = CLOCK_STR_TOKEN_OUTPUT_TEMPLATE[i];
        i += 1;
    }
    formattedTokenText[i] = 0;

    separatorPtr = GROUP_AI_JMPTBL_STR_FindCharPtr(input, TOKEN_SEPARATOR);
    if (separatorPtr != (UBYTE *)0) {
        separatorPtr += 1;
    }

    i = 0;
    while (i < TOKEN_MAX_LEN && separatorPtr != (UBYTE *)0 && separatorPtr[i] != 0) {
        UBYTE c = separatorPtr[i];

        if (i <= TOKEN_FIELD_BOOL_MAX_INDEX) {
            if (GROUP_AI_JMPTBL_STR_FindCharPtr(CLOCK_STR_BOOL_CHARS_YyNn, (LONG)c) != (UBYTE *)0) {
                if ((WDISP_CharClassTable[c] & CHARCLASS_ALPHA_MASK) != 0) {
                    c = (UBYTE)(c - ASCII_CASE_DELTA);
                }
                formattedTokenText[i] = c;
            } else {
                formattedTokenText[i] = defaultTokenText[i];
            }
        } else if (i <= TOKEN_FIELD_HEX_MAX_INDEX) {
            if ((WDISP_CharClassTable[c] & CHARCLASS_HEX_MASK) != 0) {
                formattedTokenText[i] = c;
            } else {
                formattedTokenText[i] = defaultTokenText[i];
            }
        } else {
            if ((WDISP_CharClassTable[c] & CHARCLASS_ALNUM_MASK) != 0 &&
                separatorPtr[i + 1] != 0 &&
                (WDISP_CharClassTable[separatorPtr[i + 1]] & CHARCLASS_ALNUM_MASK) != 0) {
                if ((WDISP_CharClassTable[c] & CHARCLASS_ALPHA_MASK) != 0) {
                    formattedTokenText[i] = (UBYTE)(c - ASCII_CASE_DELTA);
                } else {
                    formattedTokenText[i] = c;
                }
                i += 1;
                c = separatorPtr[i];
                if ((WDISP_CharClassTable[c] & CHARCLASS_ALPHA_MASK) != 0) {
                    formattedTokenText[i] = (UBYTE)(c - ASCII_CASE_DELTA);
                } else {
                    formattedTokenText[i] = c;
                }
            } else {
                formattedTokenText[i] = defaultTokenText[i];
                if (i + 1 < TOKEN_MAX_LEN) {
                    formattedTokenText[i + 1] = defaultTokenText[i + 1];
                    i += 1;
                }
            }
        }

        i += 1;
    }

    *field_b = (void *)GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(*field_b, formattedTokenText);
}
