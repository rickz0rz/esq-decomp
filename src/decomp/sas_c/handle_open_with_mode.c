typedef signed long LONG;

struct PreallocHandleNode {
    struct PreallocHandleNode *next;
    char pad[20];
    LONG openFlags;
};

extern struct PreallocHandleNode Global_PreallocHandleNode0;

extern void *ALLOC_AllocFromFreeList(LONG size);
extern LONG HANDLE_OpenFromModeString(const char *path, const char *mode, struct PreallocHandleNode *node);

struct PreallocHandleNode *HANDLE_OpenWithMode(const char *path, const char *mode, char *unused)
{
    struct PreallocHandleNode *prev = 0;
    struct PreallocHandleNode *node = &Global_PreallocHandleNode0;
    LONG i;

    (void)unused;

    while (node != 0 && node->openFlags != 0) {
        prev = node;
        node = node->next;
    }

    if (node == 0) {
        node = (struct PreallocHandleNode *)ALLOC_AllocFromFreeList(34);
        if (!node) {
            return (struct PreallocHandleNode *)0;
        }

        prev->next = node;

        for (i = 0; i < 34; ++i) {
            ((unsigned char *)node)[i] = 0;
        }
    }

    HANDLE_OpenFromModeString(path, mode, node);
    return node;
}
