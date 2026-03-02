#include "esq_types.h"

extern void *TEXTDISP_SecondaryEntryPtrTable[];
extern void *TEXTDISP_SecondaryTitlePtrTable[];

char *TLIBA2_FindLastCharInString(char *text, u8 ch) __attribute__((noinline));
s32 TLIBA_FindFirstWildcardMatchIndex(const char *pattern) __attribute__((noinline));
s32 TLIBA2_JMPTBL_ESQ_TestBit1Based(void *bitset, s32 bit_index) __attribute__((noinline));
s32 PARSE_ReadSignedLongSkipClass3_Alt(const char *text) __attribute__((noinline));
s32 MATH_DivS32(s32 dividend, s32 divisor) __attribute__((noinline));
u32 MATH_Mulu32(u32 a, u32 b) __attribute__((noinline));

s32 TLIBA2_ResolveEntryWindowAndSlotCount(
    void *primary_ctx,
    u8 *secondary_ctx,
    s32 index,
    s32 *out_pair,
    s32 mode_flags) __attribute__((noinline, used));

s32 TLIBA2_ResolveEntryWindowAndSlotCount(
    void *primary_ctx,
    u8 *secondary_ctx,
    s32 index,
    s32 *out_pair,
    s32 mode_flags)
{
    s32 stop = 0;
    s32 slot_count = 0;

    if (((mode_flags & 1) != 0) && ((secondary_ctx[7 + index] & (1u << 1)) != 0)) {
        char *base = *(char **)(secondary_ctx + 56 + (index * 4));
        char *quote = TLIBA2_FindLastCharInString(base, (u8)'"');
        if (quote != (char *)0) {
            char *open_paren = TLIBA2_FindLastCharInString(quote, (u8)'(');
            if (open_paren != (char *)0) {
                char *close_paren = TLIBA2_FindLastCharInString(open_paren, (u8)')');
                if (close_paren != (char *)0) {
                    char *colon = TLIBA2_FindLastCharInString(open_paren, (u8)':');
                    if (colon != (char *)0) {
                        *colon = '\0';
                        if (open_paren[1] == ' ') {
                            out_pair[0] = PARSE_ReadSignedLongSkipClass3_Alt(open_paren + 2);
                        } else {
                            out_pair[0] = PARSE_ReadSignedLongSkipClass3_Alt(open_paren + 1);
                        }
                        *colon = ':';
                        *close_paren = '\0';
                        out_pair[1] = PARSE_ReadSignedLongSkipClass3_Alt(colon + 1);
                        *close_paren = ')';
                        return slot_count;
                    }
                }
            }
        }
    }

    if (*(void **)(secondary_ctx + 56 + (index * 4)) != (void *)0) {
        index += 1;
        slot_count += 1;
    }

    while (index < 49) {
        if ((TLIBA2_JMPTBL_ESQ_TestBit1Based((u8 *)primary_ctx + 28, index) + 1) == 0) {
            if (*(void **)(secondary_ctx + 56 + (index * 4)) != (void *)0) {
                stop = 1;
                break;
            }

            index += 1;
            slot_count += 1;
            continue;
        }

        stop = 1;
        break;
    }

    if (stop == 0) {
        s32 match = TLIBA_FindFirstWildcardMatchIndex((const char *)secondary_ctx);
        if ((match + 1) != 0) {
            void *entry_ptr = TEXTDISP_SecondaryEntryPtrTable[match];
            u8 *title_ptr = (u8 *)TEXTDISP_SecondaryTitlePtrTable[match];

            index = 1;
            while (index < 49) {
                if ((TLIBA2_JMPTBL_ESQ_TestBit1Based((u8 *)entry_ptr + 0x1C, index) + 1) != 0) {
                    break;
                }

                if (*(void **)(title_ptr + 56 + (index * 4)) != (void *)0) {
                    if ((title_ptr[7 + index] & (1u << 7)) == 0) {
                        break;
                    }
                }

                index += 1;
                slot_count += 1;
            }
        }
    }

    if ((mode_flags & 1) != 0) {
        s32 half = slot_count;
        if (half < 0) {
            half += 1;
        }
        out_pair[0] = (half >> 1);

        {
            s32 units = MATH_DivS32(slot_count, 2);
            out_pair[1] = (s32)MATH_Mulu32(30u, (u32)units);
        }
    }

    return slot_count;
}
