void ESQ_AdjustBracketedHourInString(char *text_ptr, long hour_offset)
{
    char off = (char)hour_offset;
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
            char hour = 0;
            char tens_or_space = *p++;
            char ones = *p++;
            char *q = p;
            char lead = ' ';

            if (tens_or_space != ' ') {
                hour = 10;
            }

            hour = (char)(hour + (char)(ones - '0'));
            hour = (char)(hour + off);
            if (hour < 1) {
                hour = (char)(hour + 12);
            }
            while (hour > 12) {
                hour = (char)(hour - 12);
            }
            if (hour >= 10) {
                hour = (char)(hour - 10);
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
