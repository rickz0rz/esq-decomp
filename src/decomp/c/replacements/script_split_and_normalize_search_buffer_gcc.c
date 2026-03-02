#include "esq_types.h"

extern u8 TEXTDISP_PrimarySearchText[];
extern u8 TEXTDISP_SecondarySearchText[];

void SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(u8 *text, s32 max_len) __attribute__((noinline));

void SCRIPT_SplitAndNormalizeSearchBuffer(u8 *parse_buffer, s32 parse_len) __attribute__((noinline, used));

void SCRIPT_SplitAndNormalizeSearchBuffer(u8 *parse_buffer, s32 parse_len)
{
    s16 i;
    u8 *src;
    u8 *dst;

    if (parse_buffer[1] == 18) {
        src = parse_buffer + 2;
        dst = TEXTDISP_SecondarySearchText;
        do {
            *dst++ = *src;
        } while (*src++ != 0);
        TEXTDISP_PrimarySearchText[0] = 0;
    } else if (parse_buffer[parse_len - 1] == 18) {
        parse_buffer[parse_len - 1] = 0;
        src = parse_buffer + 1;
        dst = TEXTDISP_PrimarySearchText;
        do {
            *dst++ = *src;
        } while (*src++ != 0);
        TEXTDISP_SecondarySearchText[0] = 0;
    } else {
        i = 1;
        while (1) {
            if (parse_buffer[i] == 18) {
                break;
            }
            if (i >= 0xc8) {
                break;
            }
            i++;
        }

        parse_buffer[i] = 0;
        src = parse_buffer + i + 1;
        dst = TEXTDISP_SecondarySearchText;
        do {
            *dst++ = *src;
        } while (*src++ != 0);

        src = parse_buffer + 1;
        dst = TEXTDISP_PrimarySearchText;
        do {
            *dst++ = *src;
        } while (*src++ != 0);
    }

    if (TEXTDISP_PrimarySearchText[0] != 0) {
        SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(TEXTDISP_PrimarySearchText, 128);
    }

    if (TEXTDISP_SecondarySearchText[0] != 0) {
        SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(TEXTDISP_SecondarySearchText, 128);
    }
}
