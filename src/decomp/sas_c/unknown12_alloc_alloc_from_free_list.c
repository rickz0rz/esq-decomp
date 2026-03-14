#include <exec/types.h>
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
extern LONG ALLOC_InsertFreeBlock(void *block, LONG size);

void *ALLOC_AllocFromFreeList(LONG size)
{
    FreeBlock **freeListLink;
    FreeBlock *freeNode;

    if (size <= 0) {
        return (void *)0;
    }

    if (size < 8) {
        size = 8;
    }

    size = (size + 3) & ~3;

    freeListLink = &Global_AllocListHead;
    freeNode = *freeListLink;

    while (freeNode != (FreeBlock *)0) {
        if (freeNode->size >= size) {
            if (freeNode->size == size) {
                *freeListLink = freeNode->next;
                Global_AllocBytesTotal -= size;
                return freeNode;
            } else {
                LONG remainder = freeNode->size - size;
                if (remainder >= 8) {
                    FreeBlock *split = (FreeBlock *)((char *)freeNode + size);
                    *freeListLink = split;
                    split->next = freeNode->next;
                    split->size = remainder;
                    Global_AllocBytesTotal -= size;
                    return freeNode;
                }
            }
        }

        freeListLink = &freeNode->next;
        freeNode = freeNode->next;
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
