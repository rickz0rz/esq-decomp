char *STRING_FindSubstring(char *haystack, char *needle)
{
    register char *a2;
    register char *a3;

check_at_current:
    a2 = haystack;
    a3 = needle;

compare_loop:
    if (*a3 == 0) {
        return haystack;
    }

    if (*a2++ != *a3++) {
        goto advance_start;
    }

    goto compare_loop;

advance_start:
    if (*a2 == 0) {
        return 0;
    }

    haystack++;
    if (*haystack == 0) {
        return 0;
    }

    goto check_at_current;
}
