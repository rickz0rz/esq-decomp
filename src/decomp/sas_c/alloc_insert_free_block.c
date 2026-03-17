#include <exec/memory.h>
#include <exec/types.h>

typedef struct MemChunk MemChunk;

extern MemChunk *Global_AllocListHead;
extern LONG Global_AllocBytesTotal;

LONG ALLOC_InsertFreeBlock(MemChunk *chunk, LONG size)
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
    block_end = (UBYTE *)chunk + size;
    Global_AllocBytesTotal += size;

    prevLink = &Global_AllocListHead;
    freeNode = Global_AllocListHead;

    while (freeNode != (MemChunk *)0) {
        UBYTE *node_end = (UBYTE *)freeNode + freeNode->mc_Bytes;

        if ((UBYTE *)freeNode > block_end) {
            chunk->mc_Next = freeNode;
            chunk->mc_Bytes = size;
            *prevLink = chunk;
            return 0;
        }

        if ((UBYTE *)freeNode == block_end) {
            chunk->mc_Next = freeNode->mc_Next;
            chunk->mc_Bytes = size + freeNode->mc_Bytes;
            *prevLink = chunk;
            return 0;
        }

        if ((UBYTE *)chunk < node_end) {
            Global_AllocBytesTotal -= size;
            return -1;
        }

        if ((UBYTE *)chunk == node_end) {
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

    *prevLink = chunk;
    chunk->mc_Next = (MemChunk *)0;
    chunk->mc_Bytes = size;
    return 0;
}
