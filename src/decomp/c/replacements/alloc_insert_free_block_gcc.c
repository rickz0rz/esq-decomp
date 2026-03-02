#include "esq_types.h"

typedef struct AllocNode {
    struct AllocNode *next;
    s32 size;
} AllocNode;

extern AllocNode *Global_AllocListHead;
extern s32 Global_AllocBytesTotal;

s32 ALLOC_InsertFreeBlock(AllocNode *block, s32 size) __attribute__((noinline, used));

s32 ALLOC_InsertFreeBlock(AllocNode *block, s32 size)
{
    AllocNode **prev;
    AllocNode *node;
    u8 *block_end;

    if (size <= 0) {
        return -1;
    }

    if (size < 8) {
        size = 8;
    }

    size = (size + 3) & ~3;
    block_end = (u8 *)block + size;
    Global_AllocBytesTotal += size;

    prev = &Global_AllocListHead;
    node = Global_AllocListHead;

    while (node != (AllocNode *)0) {
        u8 *node_end = (u8 *)node + node->size;

        if ((u8 *)node > block_end) {
            block->next = node;
            block->size = size;
            *prev = block;
            return 0;
        }

        if ((u8 *)node == block_end) {
            block->next = node->next;
            block->size = size + node->size;
            *prev = block;
            return 0;
        }

        if ((u8 *)block < node_end) {
            Global_AllocBytesTotal -= size;
            return -1;
        }

        if ((u8 *)block == node_end) {
            if (node->next != (AllocNode *)0 && (u8 *)node->next > block_end) {
                Global_AllocBytesTotal -= size;
                return -1;
            }

            node->size += size;
            if (node->next != (AllocNode *)0 && (u8 *)node->next == block_end) {
                node->size += node->next->size;
                node->next = node->next->next;
            }
            return 0;
        }

        prev = &node->next;
        node = node->next;
    }

    *prev = block;
    block->next = (AllocNode *)0;
    block->size = size;
    return 0;
}
