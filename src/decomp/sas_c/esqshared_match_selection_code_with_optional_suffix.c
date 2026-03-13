typedef unsigned char UBYTE;
typedef signed short WORD;
typedef signed long LONG;

extern UBYTE ESQ_STR_A;
extern char ESQ_SelectCodeBuffer[];
extern char ESQPARS_SelectionSuffixBuffer[];

extern UBYTE ESQ_WildcardMatch(const char *text, const char *pattern);

UBYTE ESQSHARED_MatchSelectionCodeWithOptionalSuffix(const char *src)
{
    char main_part[20];
    char suffix_part[20];
    UBYTE split_seen = 0;
    UBYTE prev_char = ESQ_STR_A;
    UBYTE suffix_gate = ESQ_STR_A;
    WORD i = 0;
    WORD match_main;
    WORD match_suffix = 0;

    for (;;) {
        UBYTE c = (UBYTE)*src++;
        if (c == 0) {
            break;
        }

        if (c == '.') {
            main_part[i] = '\0';
            split_seen = 1;
            i = 0;
            continue;
        }

        if (c == ':') {
            if (prev_char == '?' || prev_char == '*' || i == 0) {
                suffix_gate = ESQ_STR_A;
            } else {
                suffix_gate = prev_char;
            }
            i = 0;
            continue;
        }

        prev_char = c;
        if (split_seen != 0) {
            suffix_part[i] = (char)c;
        } else {
            main_part[i] = (char)c;
        }
        ++i;
    }

    if (split_seen != 0) {
        suffix_part[i] = '\0';
    } else {
        main_part[i] = '\0';
    }

    if (main_part[0] == '\0') {
        match_main = -1;
    } else {
        match_main = (WORD)(signed char)ESQ_WildcardMatch(ESQ_SelectCodeBuffer, main_part);
    }

    if (split_seen == 1) {
        match_suffix = (WORD)(signed char)ESQ_WildcardMatch(ESQPARS_SelectionSuffixBuffer, suffix_part);
    }

    if (match_main == 0 && match_suffix == 0 && suffix_gate == ESQ_STR_A) {
        return 1;
    }

    return 0;
}
