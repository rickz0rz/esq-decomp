#include <exec/types.h>
char *GCOMMAND_FindPathSeparator(const char *pathPtr)
{
    const char *start = pathPtr;
    const char *p = pathPtr;
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
            return (char *)p;
        }

        if (distance != 1) {
            --p;
        }
        --distance;
    }

    return (char *)p;
}
