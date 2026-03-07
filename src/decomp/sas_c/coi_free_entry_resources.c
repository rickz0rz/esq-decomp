typedef unsigned char UBYTE;
typedef long LONG;

enum {
    COI_AUX_DEALLOC_LINE = 815,
    COI_AUX_DEALLOC_BYTES = 42
};

extern UBYTE Global_STR_COI_C_3[];

void COI_FreeSubEntryTableEntries(void *entry);
void COI_ClearAnimObjectStrings(void *entry);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG bytes);

void COI_FreeEntryResources(void *entry)
{
    UBYTE *e;
    UBYTE *aux;

    e = (UBYTE *)entry;
    if (e == (UBYTE *)0) {
        return;
    }

    aux = *(UBYTE **)(e + 48);
    COI_FreeSubEntryTableEntries((void *)e);
    COI_ClearAnimObjectStrings((void *)e);

    if (aux != (UBYTE *)0) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_COI_C_3,
            COI_AUX_DEALLOC_LINE,
            (void *)aux,
            COI_AUX_DEALLOC_BYTES);
    }

    *(void **)(e + 48) = (void *)0;
}
