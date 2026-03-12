#pragma nostackcheck

char *STRING_FindSubstring(const char *haystack, const char *needle)
{
    const char *currentHaystack;
    const char *currentNeedle;

check_at_current:
    currentHaystack = haystack;
    currentNeedle = needle;

compare_loop:
    if (*currentNeedle == 0) {
        return (char *)haystack;
    }

    if (*currentHaystack++ != *currentNeedle++) {
        goto advance_start;
    }

    goto compare_loop;

advance_start:
    if (*currentHaystack == 0) {
        return (char *)0;
    }

    haystack++;
    if (*haystack == 0) {
        return (char *)0;
    }

    goto check_at_current;
}
