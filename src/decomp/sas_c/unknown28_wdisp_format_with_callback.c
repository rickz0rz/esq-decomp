typedef signed long LONG;

extern char *FORMAT_ParseFormatSpec(char *fmt, void **varArgsPtr, void (*outputFunc)(LONG));

void WDISP_FormatWithCallback(void (*outputFunc)(LONG), char *formatStr, void *varArgsPtr)
{
    char ch;

    for (;;) {
        ch = *formatStr++;
        if (!ch) {
            return;
        }

        if (ch == '%') {
            if (*formatStr != '%') {
                char *next = FORMAT_ParseFormatSpec(formatStr, (void **)&varArgsPtr, outputFunc);
                if (next != 0) {
                    formatStr = next;
                    continue;
                }
            } else {
                formatStr++;
            }
        }

        outputFunc((LONG)(unsigned char)ch);
    }
}
