#include "esq_types.h"

typedef struct PTypeEntry {
    u8 type_byte;
    u8 subtype_byte;
    s32 len;
    u8 *payload;
} PTypeEntry;

extern PTypeEntry *P_TYPE_PrimaryGroupListPtr;

s32 P_TYPE_ConsumePrimaryTypeIfPresent(u8 *in_out_value) __attribute__((noinline, used));

s32 P_TYPE_ConsumePrimaryTypeIfPresent(u8 *in_out_value)
{
    s32 result = 0;

    if (P_TYPE_PrimaryGroupListPtr != (PTypeEntry *)0 && P_TYPE_PrimaryGroupListPtr->len > 0) {
        s32 i = 0;
        while (result == 0 && i < P_TYPE_PrimaryGroupListPtr->len) {
            if (P_TYPE_PrimaryGroupListPtr->payload[i] == *in_out_value) {
                result = 1;
            }
            ++i;
        }
    }

    *in_out_value = 0;
    return result;
}
