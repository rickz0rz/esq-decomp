#include "esq_types.h"

typedef struct PTypeEntry {
    u8 type_byte;
    u8 subtype_byte;
    s32 len;
    u8 *payload;
} PTypeEntry;

s32 P_TYPE_GetSubtypeIfType20(const PTypeEntry *entry) __attribute__((noinline, used));

s32 P_TYPE_GetSubtypeIfType20(const PTypeEntry *entry)
{
    s32 result = 0;

    if (entry != (const PTypeEntry *)0 && entry->type_byte == 20 && entry->subtype_byte != 0) {
        result = (s32)entry->subtype_byte;
    }

    return result;
}
