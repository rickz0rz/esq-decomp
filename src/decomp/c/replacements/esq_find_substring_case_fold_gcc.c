#include <stdint.h>

char *ESQ_FindSubstringCaseFold(char *haystack, const char *needle) {
    char *scan = haystack;
    const char *pat = needle;
    char *candidate;

    if (*pat == '\0') {
        return 0;
    }

    candidate = scan;

    for (;;) {
        if (*scan == '\0') {
            if (*pat != '\0') {
                return 0;
            }
            return candidate;
        }

        if (*pat == '\0') {
            return candidate;
        }

        {
            uint8_t ch = (uint8_t)*scan++;
            uint8_t pc = (uint8_t)*pat;

            if (ch == pc || ((uint8_t)(ch ^ 0x20u) == pc)) {
                pat++;
                continue;
            }
        }

        if (pat != needle) {
            scan--;
        }
        candidate = scan;
        pat = needle;
    }
}
