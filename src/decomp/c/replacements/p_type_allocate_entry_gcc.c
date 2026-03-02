#include "esq_types.h"

extern u8 Global_STR_P_TYPE_C_1;
extern u8 Global_STR_P_TYPE_C_2;
extern u8 Global_STR_P_TYPE_C_3;

void *SCRIPT_JMPTBL_MEMORY_AllocateMemory(const void *tag_name, s32 width, s32 height, s32 flags) __attribute__((noinline));
void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(const void *tag_name, s32 width, void *ptr, s32 size) __attribute__((noinline));

typedef struct PTypeEntry {
    u8 type_byte;
    u8 pad1;
    s32 len;
    u8 *payload;
} PTypeEntry;

PTypeEntry *P_TYPE_AllocateEntry(u8 type_byte, s32 len, const u8 *src) __attribute__((noinline, used));

PTypeEntry *P_TYPE_AllocateEntry(u8 type_byte, s32 len, const u8 *src)
{
    PTypeEntry *entry = (PTypeEntry *)0;

    if (len <= 0) {
        return (PTypeEntry *)0;
    }

    entry = (PTypeEntry *)SCRIPT_JMPTBL_MEMORY_AllocateMemory(&Global_STR_P_TYPE_C_1, 47, 10, 0x10001);
    if (entry == (PTypeEntry *)0) {
        return (PTypeEntry *)0;
    }

    entry->type_byte = type_byte;
    entry->len = len;

    {
        const u8 *p = src;
        while (*p != 0) {
            ++p;
        }

        if ((s32)(p - src) == len) {
            entry->payload = (u8 *)SCRIPT_JMPTBL_MEMORY_AllocateMemory(&Global_STR_P_TYPE_C_2, 58, len, 0x10001);
        } else {
            entry->payload = (u8 *)0;
        }
    }

    if (entry->payload != (u8 *)0) {
        s32 i;
        for (i = 0; i < len; ++i) {
            entry->payload[i] = src[i];
        }
        return entry;
    }

    SCRIPT_JMPTBL_MEMORY_DeallocateMemory(&Global_STR_P_TYPE_C_3, 77, entry, 10);
    return (PTypeEntry *)0;
}
