#include "esq_types.h"

/*
 * Target 630 GCC trial function.
 * Parse "(start:end)" style window from an entry string into out_pair[0..1].
 */
char *STR_FindCharPtr(const char *text, s32 ch) __attribute__((noinline));
s32 PARSE_ReadSignedLongSkipClass3_Alt(const char *text) __attribute__((noinline));

s32 TLIBA2_ParseEntryTimeWindow(void *entry, s32 index, s32 *out_pair) __attribute__((noinline, used));

s32 TLIBA2_ParseEntryTimeWindow(void *entry, s32 index, s32 *out_pair)
{
    u8 *base = (u8 *)entry;
    char *src = (char *)0;
    char *open_paren;
    char *colon;
    char *close_paren;
    char *quote;
    s32 ok = 0;

    if (base != (u8 *)0) {
        src = *(char **)(base + 56 + (index * 4));
    }

    if (src != (char *)0) {
        open_paren = STR_FindCharPtr(src, 40);
        if (open_paren != (char *)0) {
            colon = STR_FindCharPtr(open_paren, 58);
            if (colon != (char *)0) {
                close_paren = STR_FindCharPtr(colon, 41);
                if (close_paren != (char *)0) {
                    quote = STR_FindCharPtr(src, 34);
                    if (quote == (char *)0 || close_paren < quote) {
                        *colon = '\0';
                        if (*(open_paren + 1) == ' ') {
                            out_pair[0] = PARSE_ReadSignedLongSkipClass3_Alt(open_paren + 2);
                        } else {
                            out_pair[0] = PARSE_ReadSignedLongSkipClass3_Alt(open_paren + 1);
                        }

                        *colon = ':';
                        *close_paren = '\0';
                        out_pair[1] = PARSE_ReadSignedLongSkipClass3_Alt(colon + 1);
                        *close_paren = ')';
                        ok = 1;
                    }
                }
            }
        }
    }

    return ok;
}
