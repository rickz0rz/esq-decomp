typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern const char Global_STR_LOCAVAIL_C_1[];
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);

void LOCAVAIL_FreeNodeRecord(void *node)
{
    UBYTE *p = (UBYTE *)node;
    p[0] = 0;
    *(UWORD *)(p + 2) = 0;
    *(UWORD *)(p + 4) = 0;
    *(void **)(p + 6) = (void *)0;
}

void LOCAVAIL_FreeNodeAtPointer(void *node)
{
    UBYTE *p = (UBYTE *)node;

    if (p != (UBYTE *)0) {
        void *buf = *(void **)(p + 6);
        if (buf != (void *)0) {
            WORD size = *(WORD *)(p + 4);
            if (size > 0) {
                NEWGRID_JMPTBL_MEMORY_DeallocateMemory(
                    Global_STR_LOCAVAIL_C_1,
                    106,
                    buf,
                    (LONG)size
                );
            }
        }
        LOCAVAIL_FreeNodeRecord(node);
    }
}
