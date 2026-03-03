#include <stdint.h>

void ESQ_TerminateAfterSecondQuote(char *text) {
    char c;

    while ((c = *text++) != '\0') {
        if ((uint8_t)c == 34u) {
            break;
        }
    }

    if (c == '\0') {
        return;
    }

    while ((c = *text++) != '\0') {
        if ((uint8_t)c == 34u) {
            *text = '\0';
            return;
        }
    }
}
