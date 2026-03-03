#include <stdint.h>

void ESQ_AdjustBracketedHourInString(char *text_ptr, int32_t hour_offset) {
    int8_t off = (int8_t)hour_offset;
    char *p = text_ptr;

    for (;;) {
        char ch;

        do {
            ch = *p++;
            if (ch == '\0') {
                return;
            }
        } while (ch != '[');

        p[-1] = '(';

        if (off != 0) {
            int8_t hour = 0;
            char tens_or_space = *p++;
            char ones = *p++;
            char *q = p;
            char lead = ' ';

            if (tens_or_space != ' ') {
                hour = 10;
            }

            hour = (int8_t)(hour + (int8_t)(ones - '0'));
            hour = (int8_t)(hour + off);
            if (hour < 1) {
                hour = (int8_t)(hour + 12);
            }
            while (hour > 12) {
                hour = (int8_t)(hour - 12);
            }
            if (hour >= 10) {
                hour = (int8_t)(hour - 10);
                lead = '1';
            }

            *--q = (char)(hour + '0');
            *--q = lead;
        }

        do {
            ch = *p++;
            if (ch == '\0') {
                return;
            }
        } while (ch != ']');

        p[-1] = ')';
    }
}
