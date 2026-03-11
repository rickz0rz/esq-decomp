void ESQ_AdjustBracketedHourInString(char *text_ptr, long hour_offset)
{
    char *p = text_ptr;
    char off = (char)hour_offset;

    for (;;) {
        char ch;

        while ((ch = *p++) != '[') {
            if (ch == '\0') {
                return;
            }
        }

        p[-1] = '(';

        if (off != 0) {
            char hour = 0;
            char digit;

            ch = *p++;
            if (ch != ' ') {
                hour = 10;
            }

            digit = *p++;
            hour = (char)(hour + (char)(digit - '0'));
            hour = (char)(hour + off);
            if (hour < 1) {
                hour = (char)(hour + 12);
            }
            while (hour > 12) {
                hour = (char)(hour - 12);
            }
            if (hour < 10) {
                p[-1] = (char)(hour + '0');
                p[-2] = ' ';
            } else {
                hour = (char)(hour - 10);
                p[-1] = (char)(hour + '0');
                p[-2] = '1';
            }
        }

        while ((ch = *p++) != ']') {
            if (ch == '\0') {
                return;
            }
        }

        p[-1] = ')';
    }
}
