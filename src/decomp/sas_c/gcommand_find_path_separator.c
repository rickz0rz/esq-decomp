typedef signed long LONG;

char *GCOMMAND_FindPathSeparator(char *pathPtr)
{
    char *start = pathPtr;
    char *p = pathPtr;
    LONG distance;

    while (*p != '\0') {
        ++p;
    }

    distance = (LONG)(p - start);
    if (distance == 0) {
        return start;
    }

    p = start + distance - 1;
    while (distance != 0) {
        if (*p == ':' || *p == '/') {
            ++p;
            return p;
        }

        if (distance != 1) {
            --p;
        }
        --distance;
    }

    return p;
}
