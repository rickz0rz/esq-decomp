#include "esq_types.h"

extern u8 Global_STR_P_TYPE_C_4;
extern u8 Global_STR_P_TYPE_C_5;

void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(const void *tag_name, s32 width, void *ptr, s32 size) __attribute__((noinline));

typedef struct PTypeEntry {
    u8 type_byte;
    u8 pad1;
    s32 len;
    u8 *payload;
} PTypeEntry;

void P_TYPE_FreeEntry(PTypeEntry *entry) __attribute__((noinline, used));

void P_TYPE_FreeEntry(PTypeEntry *entry)
{
    if (entry == (PTypeEntry *)0) {
        return;
    }

    if (entry->payload != (u8 *)0) {
        SCRIPT_JMPTBL_MEMORY_DeallocateMemory(&Global_STR_P_TYPE_C_4, 92, entry->payload, entry->len);
    }

    SCRIPT_JMPTBL_MEMORY_DeallocateMemory(&Global_STR_P_TYPE_C_5, 95, entry, 10);
}
