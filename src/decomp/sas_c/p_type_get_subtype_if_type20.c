#include <exec/types.h>
typedef struct P_TYPE_Entry {
    UBYTE typeByte;
    UBYTE subtypeByte;
} P_TYPE_Entry;

LONG P_TYPE_GetSubtypeIfType20(UBYTE *entry)
{
    LONG subtype;
    P_TYPE_Entry *entryView;

    subtype = 0;
    if (entry) {
        entryView = (P_TYPE_Entry *)entry;
        if (entryView->typeByte == (UBYTE)20 && entryView->subtypeByte != (UBYTE)0) {
            subtype = (LONG)entryView->subtypeByte;
        }
    }

    return subtype;
}
