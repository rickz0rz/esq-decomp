typedef unsigned char UBYTE;
typedef signed long LONG;

typedef struct AllocNode {
    struct AllocNode *next;
    LONG size;
} AllocNode;

extern AllocNode *Global_AllocListHead;
extern LONG Global_AllocBytesTotal;

char *STRING_FindSubstring(const char *haystack, const char *needle)
{
    register const char *currentHaystack;
    register const char *currentNeedle;

check_at_current:
    currentHaystack = haystack;
    currentNeedle = needle;

compare_loop:
    if (*currentNeedle == 0) {
        return (char *)haystack;
    }

    if (*currentHaystack++ != *currentNeedle++) {
        goto advance_start;
    }

    goto compare_loop;

advance_start:
    if (*currentHaystack == 0) {
        return (char *)0;
    }

    haystack++;
    if (*haystack == 0) {
        return (char *)0;
    }

    goto check_at_current;
}

LONG ALLOC_InsertFreeBlock(AllocNode *block, LONG size)
{
    AllocNode **prevLink;
    AllocNode *freeNode;
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

    while (freeNode != (AllocNode *)0) {
        UBYTE *node_end = (UBYTE *)freeNode + freeNode->size;

        if ((UBYTE *)freeNode > block_end) {
            block->next = freeNode;
            block->size = size;
            *prevLink = block;
            return 0;
        }

        if ((UBYTE *)freeNode == block_end) {
            block->next = freeNode->next;
            block->size = size + freeNode->size;
            *prevLink = block;
            return 0;
        }

        if ((UBYTE *)block < node_end) {
            Global_AllocBytesTotal -= size;
            return -1;
        }

        if ((UBYTE *)block == node_end) {
            if (freeNode->next != (AllocNode *)0 && (UBYTE *)freeNode->next > block_end) {
                Global_AllocBytesTotal -= size;
                return -1;
            }

            freeNode->size += size;
            if (freeNode->next != (AllocNode *)0 && (UBYTE *)freeNode->next == block_end) {
                freeNode->size += freeNode->next->size;
                freeNode->next = freeNode->next->next;
            }
            return 0;
        }

        prevLink = &freeNode->next;
        freeNode = freeNode->next;
    }

    *prevLink = block;
    block->next = (AllocNode *)0;
    block->size = size;
    return 0;
}
