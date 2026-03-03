#include <stdint.h>

int32_t ESQ_WildcardMatch(const char *str, const char *pattern) {
    if (str == 0 || pattern == 0) {
        return 1;
    }

    for (;;) {
        char sc = *str++;
        char pc = *pattern++;

        if (pc == '*') {
            return 0;
        }

        if (sc == '\0') {
            return (pc == '\0') ? 0 : 1;
        }

        if (pc == '?') {
            continue;
        }

        if (sc != pc) {
            return 1;
        }
    }
}
