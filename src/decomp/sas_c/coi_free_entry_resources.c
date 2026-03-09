typedef unsigned char UBYTE;
typedef long LONG;

enum {
    COI_ENTRY_AUX_OFFSET = 48,
    COI_AUX_DEALLOC_LINE = 815,
    COI_AUX_DEALLOC_BYTES = 42
};

extern UBYTE Global_STR_COI_C_3[];

void COI_FreeSubEntryTableEntries(void *entry);
void COI_ClearAnimObjectStrings(void *entry);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG bytes);

typedef struct COI_Entry {
    UBYTE pad0[COI_ENTRY_AUX_OFFSET];
    void *auxPtr;
} COI_Entry;

void COI_FreeEntryResources(void *entry)
{
    COI_Entry *e;
    void *aux;

    e = (COI_Entry *)entry;
    if (e == (COI_Entry *)0) {
        return;
    }

    aux = e->auxPtr;
    COI_FreeSubEntryTableEntries((void *)e);
    COI_ClearAnimObjectStrings((void *)e);

    if (aux != (void *)0) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_COI_C_3,
            COI_AUX_DEALLOC_LINE,
            aux,
            COI_AUX_DEALLOC_BYTES);
    }

    e->auxPtr = (void *)0;
}
