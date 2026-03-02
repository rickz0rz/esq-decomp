#include "esq_types.h"

extern u8 *Global_AllocListHead;
extern s32 Global_AllocBlockSize;
extern s32 Global_AllocBytesTotal;

s32 MATH_DivS32(s32 dividend, s32 divisor) __attribute__((noinline));
u32 MATH_Mulu32(u32 a, u32 b) __attribute__((noinline));
u8 *MEMLIST_AllocTracked(u32 size) __attribute__((noinline));
void ALLOC_InsertFreeBlock(u8 *ptr, u32 size) __attribute__((noinline));

void *ALLOC_AllocFromFreeList(s32 size) __attribute__((noinline, used));

void *ALLOC_AllocFromFreeList(s32 size)
{
    u8 **prev;
    u8 *node;

    if (size <= 0) {
        return (void *)0;
    }

    if (size < 8) {
        size = 8;
    }

    size = (size + 3) & ~3;
    prev = &Global_AllocListHead;
    node = Global_AllocListHead;

    while (node != (u8 *)0) {
        s32 block_size = *(s32 *)(node + 4);

        if (block_size >= size) {
            if (block_size == size) {
                *prev = *(u8 **)node;
                Global_AllocBytesTotal -= size;
                return node;
            }

            {
                s32 remaining = block_size - size;
                if (remaining >= 8) {
                    u8 *next = node + size;
                    *prev = next;
                    *(u8 **)next = *(u8 **)node;
                    *(s32 *)(next + 4) = remaining;
                    Global_AllocBytesTotal -= size;
                    return node;
                }
            }
        }

        prev = (u8 **)node;
        node = *(u8 **)node;
    }

    {
        s32 chunk_count = MATH_DivS32(size + Global_AllocBlockSize - 1, Global_AllocBlockSize);
        u32 req = MATH_Mulu32((u32)chunk_count, (u32)Global_AllocBlockSize);
        u32 alloc_size = (req + 8 + 3) & ~3u;
        u8 *fresh = MEMLIST_AllocTracked(alloc_size);

        if (fresh == (u8 *)0) {
            return (void *)0;
        }

        ALLOC_InsertFreeBlock(fresh, alloc_size);
        return ALLOC_AllocFromFreeList(size);
    }
}
