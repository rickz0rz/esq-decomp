typedef unsigned char UBYTE;
typedef signed long LONG;

typedef struct AllocNode {
    struct AllocNode *next;
    LONG size;
} AllocNode;

extern AllocNode *Global_AllocListHead;
extern LONG Global_AllocBytesTotal;

UBYTE *STRING_FindSubstring(UBYTE *haystack, const UBYTE *needle)
{
    UBYTE *start;
    const UBYTE *p;
    UBYTE *q;

    for (;;) {
        q = haystack;
        p = needle;

        for (;;) {
            if (*p == 0) {
                return haystack;
            }
            if (*q++ != *p++) {
                break;
            }
        }

        if (*q == 0) {
            return (UBYTE *)0;
        }

        haystack++;
        if (*haystack == 0) {
            return (UBYTE *)0;
        }

        start = haystack;
        (void)start;
    }
}

LONG ALLOC_InsertFreeBlock(AllocNode *block, LONG size)
{
    AllocNode **prev;
    AllocNode *node;
    UBYTE *block_end;

    if (size <= 0) {
        return -1;
    }

    if (size < 8) {
        size = 8;
    }

    size = (size + 3) & ~3;
    block_end = (UBYTE *)block + size;
    Global_AllocBytesTotal += size;

    prev = &Global_AllocListHead;
    node = Global_AllocListHead;

    while (node != (AllocNode *)0) {
        UBYTE *node_end = (UBYTE *)node + node->size;

        if ((UBYTE *)node > block_end) {
            block->next = node;
            block->size = size;
            *prev = block;
            return 0;
        }

        if ((UBYTE *)node == block_end) {
            block->next = node->next;
            block->size = size + node->size;
            *prev = block;
            return 0;
        }

        if ((UBYTE *)block < node_end) {
            Global_AllocBytesTotal -= size;
            return -1;
        }

        if ((UBYTE *)block == node_end) {
            if (node->next != (AllocNode *)0 && (UBYTE *)node->next > block_end) {
                Global_AllocBytesTotal -= size;
                return -1;
            }

            node->size += size;
            if (node->next != (AllocNode *)0 && (UBYTE *)node->next == block_end) {
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
