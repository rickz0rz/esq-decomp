#include "esq_types.h"

typedef struct PTypeEntry {
    u8 type_byte;
    u8 subtype_byte;
    s32 len;
    u8 *payload;
} PTypeEntry;

void P_TYPE_FreeEntry(PTypeEntry *entry) __attribute__((noinline));
PTypeEntry *P_TYPE_AllocateEntry(u8 type_byte, s32 len, const u8 *src) __attribute__((noinline));

PTypeEntry *P_TYPE_CloneEntry(PTypeEntry *dst, const PTypeEntry *src) __attribute__((noinline, used));

PTypeEntry *P_TYPE_CloneEntry(PTypeEntry *dst, const PTypeEntry *src)
{
    PTypeEntry *result = (PTypeEntry *)0;

    P_TYPE_FreeEntry(dst);

    if (src != (const PTypeEntry *)0) {
        u8 tmp[100];
        s32 i;

        for (i = 0; i < src->len; ++i) {
            tmp[i] = src->payload[i];
        }
        tmp[i] = 0;
        result = P_TYPE_AllocateEntry(src->type_byte, src->len, tmp);
    }

    return result;
}
