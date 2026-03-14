#include <exec/types.h>
typedef LONG (*WdispOutputFunc)(LONG);

extern char *FORMAT_ParseFormatSpec(char *fmt, void **varArgsPtr, WdispOutputFunc outputFunc);

void WDISP_FormatWithCallback(WdispOutputFunc outputFunc, char *formatStr, void *varArgsPtr)
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
