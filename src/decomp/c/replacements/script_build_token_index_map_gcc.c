#include "esq_types.h"

s16 SCRIPT_BuildTokenIndexMap(u8 *input_bytes, s16 *out_index_by_token, s16 token_count, const u8 *token_table, s16 max_scan_count, u8 terminator_byte, s16 fill_missing_flag) __attribute__((noinline, used));

s16 SCRIPT_BuildTokenIndexMap(u8 *input_bytes, s16 *out_index_by_token, s16 token_count, const u8 *token_table, s16 max_scan_count, u8 terminator_byte, s16 fill_missing_flag)
{
    s16 token_i;
    s16 matched_count = 0;
    s16 scan_pos = 0;
    s16 last_match_index = 0;

    for (token_i = 0; token_i < token_count; ++token_i) {
        out_index_by_token[token_i] = -1;
    }

    while (1) {
        u8 ch = input_bytes[scan_pos];

        if (ch == terminator_byte) {
            break;
        }
        if (scan_pos >= max_scan_count) {
            break;
        }

        for (token_i = matched_count; token_i < token_count; ++token_i) {
            if (token_table[token_i] == ch) {
                out_index_by_token[token_i] = (s16)(scan_pos + 1);
                input_bytes[scan_pos] = 0;
                ++matched_count;
                last_match_index = scan_pos;
                break;
            }
        }

        if (out_index_by_token[token_count - 1] != -1) {
            break;
        }

        ++scan_pos;
    }

    if (last_match_index == 0) {
        last_match_index = scan_pos;
    }

    if (fill_missing_flag != 0) {
        for (token_i = 0; token_i < token_count; ++token_i) {
            if (out_index_by_token[token_i] == -1) {
                out_index_by_token[token_i] = last_match_index;
            }
        }
    }

    return scan_pos;
}
