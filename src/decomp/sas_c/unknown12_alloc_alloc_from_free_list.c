typedef signed long LONG;

typedef struct FreeBlock {
    struct FreeBlock *next;
    LONG size;
} FreeBlock;

extern FreeBlock *Global_AllocListHead;
extern LONG Global_AllocBlockSize;
extern LONG Global_AllocBytesTotal;

extern LONG MATH_DivS32(LONG dividend, LONG divisor);
extern LONG MATH_Mulu32(LONG lhs, LONG rhs);
extern void *MEMLIST_AllocTracked(LONG size);
extern void ALLOC_InsertFreeBlock(void *block, LONG size);

void *ALLOC_AllocFromFreeList(LONG size)
{
    FreeBlock **link;
    FreeBlock *node;

    if (size <= 0) {
        return (void *)0;
    }

    if (size < 8) {
        size = 8;
    }

    size = (size + 3) & ~3;

    link = &Global_AllocListHead;
    node = *link;

    while (node != (FreeBlock *)0) {
        if (node->size >= size) {
            if (node->size == size) {
                *link = node->next;
                Global_AllocBytesTotal -= size;
                return node;
            } else {
                LONG remainder = node->size - size;
                if (remainder >= 8) {
                    FreeBlock *split = (FreeBlock *)((char *)node + size);
                    *link = split;
                    split->next = node->next;
                    split->size = remainder;
                    Global_AllocBytesTotal -= size;
                    return node;
                }
            }
        }

        link = &node->next;
        node = node->next;
    }

    {
        LONG blocks = MATH_DivS32(size + Global_AllocBlockSize - 1, Global_AllocBlockSize);
        LONG bytes = MATH_Mulu32(blocks, Global_AllocBlockSize);
        LONG allocBytes = (bytes + 8 + 3) & ~3;
        void *newBlock = MEMLIST_AllocTracked(allocBytes);

        if (newBlock == (void *)0) {
            return (void *)0;
        }

        ALLOC_InsertFreeBlock(newBlock, allocBytes);
    }

    return ALLOC_AllocFromFreeList(size);
}
