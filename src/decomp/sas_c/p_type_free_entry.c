#include <exec/types.h>
typedef struct P_TYPE_Entry {
    UBYTE pad0[2];
    LONG payloadLength;
    UBYTE *payload;
} P_TYPE_Entry;

extern const char Global_STR_P_TYPE_C_4[];
extern const char Global_STR_P_TYPE_C_5[];

extern void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(const char *tagName, LONG line, void *ptr, LONG bytes);

void P_TYPE_FreeEntry(UBYTE *entry)
{
    P_TYPE_Entry *entryView;
    UBYTE *payload;

    if (!entry) {
        return;
    }

    entryView = (P_TYPE_Entry *)entry;

    if (*(LONG *)(entry + 6) != 0) {
        payload = entryView->payload;
        SCRIPT_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_P_TYPE_C_4,
            92,
            payload,
            entryView->payloadLength);
    }

    SCRIPT_JMPTBL_MEMORY_DeallocateMemory(Global_STR_P_TYPE_C_5, 95, entry, 10);
}
