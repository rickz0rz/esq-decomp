#include "esq_types.h"

/*
 * Target 627 GCC trial function.
 * Return pointer to the last occurrence of a character in a NUL-terminated string.
 */
char *TLIBA2_FindLastCharInString(char *text, u8 ch) __attribute__((noinline, used));

char *TLIBA2_FindLastCharInString(char *text, u8 ch)
{
    char *result = (char *)0;
    char *p = text;

    while (*p != '\0') {
        p++;
    }

    p--;
    while (p >= text) {
        if ((u8)*p == ch) {
            result = p;
            break;
        }
        p--;
    }

    return result;
}
