#include <exec/memory.h>
#include <exec/types.h>

extern MemChunk *Global_AllocListHead;
extern LONG Global_AllocBytesTotal;

LONG ALLOC_InsertFreeBlock(MemChunk *block, LONG size)
{
    MemChunk **prevLink;
    MemChunk *freeNode;
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

    prevLink = &Global_AllocListHead;
    freeNode = Global_AllocListHead;

    while (freeNode != (MemChunk *)0) {
        UBYTE *node_end = (UBYTE *)freeNode + freeNode->mc_Bytes;

        if ((UBYTE *)freeNode > block_end) {
            block->mc_Next = freeNode;
            block->mc_Bytes = size;
            *prevLink = block;
            return 0;
        }

        if ((UBYTE *)freeNode == block_end) {
            block->mc_Next = freeNode->mc_Next;
            block->mc_Bytes = size + freeNode->mc_Bytes;
            *prevLink = block;
            return 0;
        }

        if ((UBYTE *)block < node_end) {
            Global_AllocBytesTotal -= size;
            return -1;
        }

        if ((UBYTE *)block == node_end) {
            if (freeNode->mc_Next != (MemChunk *)0 && (UBYTE *)freeNode->mc_Next > block_end) {
                Global_AllocBytesTotal -= size;
                return -1;
            }

            freeNode->mc_Bytes += size;
            if (freeNode->mc_Next != (MemChunk *)0 && (UBYTE *)freeNode->mc_Next == block_end) {
                freeNode->mc_Bytes += freeNode->mc_Next->mc_Bytes;
                freeNode->mc_Next = freeNode->mc_Next->mc_Next;
            }
            return 0;
        }

        prevLink = &freeNode->mc_Next;
        freeNode = freeNode->mc_Next;
    }

    *prevLink = block;
    block->mc_Next = (MemChunk *)0;
    block->mc_Bytes = size;
    return 0;
}
