#pragma nostackcheck

char *STRING_FindSubstring(char *haystack, char *needle)
{
    register char *currentHaystack;
    register char *currentNeedle;

check_at_current:
    currentHaystack = haystack;
    currentNeedle = needle;

compare_loop:
    if (*currentNeedle == 0) {
        return haystack;
    }

    if (*currentHaystack++ != *currentNeedle++) {
        goto advance_start;
    }

    goto compare_loop;

advance_start:
    if (*currentHaystack == 0) {
        return 0;
    }

    haystack++;
    if (*haystack == 0) {
        return 0;
    }

    goto check_at_current;
}
