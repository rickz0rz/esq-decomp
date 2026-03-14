#include <exec/types.h>
extern char *GROUP_AI_JMPTBL_STR_FindCharPtr(const char *table, LONG ch);

UBYTE ED_FindNextCharInTable(UBYTE ch, const char *table)
{
    char *ptr = GROUP_AI_JMPTBL_STR_FindCharPtr(table, (LONG)ch);

    if (ptr != 0) {
        ptr += 1;
    } else {
        ptr = (char *)table;
    }

    if (*ptr == 0) {
        ptr = (char *)table;
    }

    return (UBYTE)*ptr;
}
