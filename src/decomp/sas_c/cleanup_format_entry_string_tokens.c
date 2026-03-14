#include <exec/types.h>
enum {
    TOKEN_BUF_LEN = 11,
    TOKEN_MAX_LEN = 10,
    TOKEN_PREFIX_MAX_LEN = 5,
    TOKEN_FIELD_HEX_MAX_INDEX = 7,
    TOKEN_SEPARATOR = ':',
    ASCII_CASE_DELTA = 32,
    CHARCLASS_ALPHA_MASK = 2,
    CHARCLASS_HEX_MASK = 0x80
};

#define TOKEN_FIELD_BOOL_MAX_INDEX 5
#define CHARCLASS_ALNUM_MASK 7

extern const char CLOCK_STR_TOKEN_PAIR_DEFAULTS[];
extern char CLEANUP_TokenPairScratch[];
extern const char CLOCK_STR_TOKEN_OUTPUT_TEMPLATE[];
extern const char CLOCK_STR_EMPTY_TOKEN_TEMPLATE[];
extern const char CLOCK_STR_BOOL_CHARS_YyNn[];
extern const UBYTE WDISP_CharClassTable[];

char *STR_FindCharPtr(const char *s, LONG c);
char *ESQPARS_ReplaceOwnedString(const char *new_ptr, char *old_ptr);

void CLEANUP_FormatEntryStringTokens(void **field_a, void **field_b, char *input)
{
    char defaultTokenText[11];
    char formattedTokenText[11];
    LONG i;
    char *separatorPtr;
    const char *scan;
    const char *inputScan;

    if (input == (char *)0 || input[0] == 0 || STR_FindCharPtr(input, TOKEN_SEPARATOR) == (char *)0) {
        *field_a = (void *)ESQPARS_ReplaceOwnedString((const char *)0, (char *)*field_a);
        *field_b = (void *)ESQPARS_ReplaceOwnedString(CLOCK_STR_EMPTY_TOKEN_TEMPLATE, *field_b);
        return;
    }

    for (i = 0; i < TOKEN_MAX_LEN; i += 1) {
        defaultTokenText[i] = CLOCK_STR_TOKEN_PAIR_DEFAULTS[i];
    }
    defaultTokenText[TOKEN_MAX_LEN] = 0;

    i = 0;
    scan = CLEANUP_TokenPairScratch;
    while (*scan != 0) {
        formattedTokenText[i] = *scan++;
        i += 1;
    }
    formattedTokenText[i] = 0;

    i = 0;
    inputScan = input;
    while (i < TOKEN_PREFIX_MAX_LEN && *inputScan != TOKEN_SEPARATOR && *inputScan != 0) {
        formattedTokenText[i] = *inputScan++;
        i += 1;
    }
    formattedTokenText[i] = 0;

    *field_a = (void *)ESQPARS_ReplaceOwnedString(formattedTokenText, (char *)*field_a);

    i = 0;
    scan = CLOCK_STR_TOKEN_OUTPUT_TEMPLATE;
    while (*scan != 0) {
        formattedTokenText[i] = *scan++;
        i += 1;
    }
    formattedTokenText[i] = 0;

    separatorPtr = STR_FindCharPtr(input, TOKEN_SEPARATOR);
    if (separatorPtr != (char *)0) {
        separatorPtr += 1;
    }

    i = 0;
    while (i < TOKEN_MAX_LEN && separatorPtr != (char *)0 && separatorPtr[i] != 0) {
        UBYTE c = separatorPtr[i];

        if (i <= TOKEN_FIELD_BOOL_MAX_INDEX) {
            if (STR_FindCharPtr(CLOCK_STR_BOOL_CHARS_YyNn, (LONG)c) != (char *)0) {
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

    *field_b = (void *)ESQPARS_ReplaceOwnedString(formattedTokenText, (char *)*field_b);
}
