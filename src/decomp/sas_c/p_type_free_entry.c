typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct P_TYPE_Entry {
    UBYTE pad0[2];
    LONG payloadLength;
    UBYTE *payload;
} P_TYPE_Entry;

extern UBYTE Global_STR_P_TYPE_C_4;
extern UBYTE Global_STR_P_TYPE_C_5;

extern void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(UBYTE *tagName, LONG line, void *ptr, LONG bytes);

void P_TYPE_FreeEntry(UBYTE *entry)
{
    P_TYPE_Entry *entryView;

    if (entry == (UBYTE *)0) {
        return;
    }

    entryView = (P_TYPE_Entry *)entry;

    if (entryView->payload != (UBYTE *)0) {
        SCRIPT_JMPTBL_MEMORY_DeallocateMemory(
            &Global_STR_P_TYPE_C_4,
            92,
            entryView->payload,
            entryView->payloadLength);
    }

    SCRIPT_JMPTBL_MEMORY_DeallocateMemory(&Global_STR_P_TYPE_C_5, 95, entry, 10);
}
