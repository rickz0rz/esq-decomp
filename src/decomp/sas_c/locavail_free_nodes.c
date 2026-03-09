typedef signed long LONG;
typedef unsigned long ULONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern const char Global_STR_LOCAVAIL_C_1[];
extern const char Global_STR_LOCAVAIL_C_2[];
extern const char Global_STR_LOCAVAIL_C_3[];
extern LONG GROUP_AY_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);
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

void LOCAVAIL_ResetFilterStateStruct(void *state)
{
    UBYTE *p = (UBYTE *)state;

    p[0] = 0;
    *(LONG *)(p + 2) = 0;
    *(void **)(p + 16) = (void *)0;
    *(void **)(p + 20) = (void *)0;
    p[6] = 'F';
    *(LONG *)(p + 8) = -1;
    *(LONG *)(p + 12) = -1;
}

void LOCAVAIL_FreeResourceChain(void *state)
{
    UBYTE *p = (UBYTE *)state;

    if (p != (UBYTE *)0) {
        ULONG *sharedRef = *(ULONG **)(p + 16);
        if (sharedRef != (ULONG *)0) {
            if ((LONG)(*sharedRef) > 0) {
                *sharedRef -= 1;
            }

            if (*(void **)(p + 20) != (void *)0 &&
                *(LONG *)(p + 2) > 0 &&
                *sharedRef == 0) {
                LONG i = 0;

                NEWGRID_JMPTBL_MEMORY_DeallocateMemory(
                    Global_STR_LOCAVAIL_C_2,
                    159,
                    sharedRef,
                    4
                );

                while (i < *(LONG *)(p + 2)) {
                    LOCAVAIL_FreeNodeAtPointer(*(UBYTE **)(p + 20) + NEWGRID_JMPTBL_MATH_Mulu32(i, 10));
                    i += 1;
                }

                NEWGRID_JMPTBL_MEMORY_DeallocateMemory(
                    Global_STR_LOCAVAIL_C_3,
                    164,
                    *(void **)(p + 20),
                    GROUP_AY_JMPTBL_MATH_Mulu32(*(LONG *)(p + 2), 10)
                );
            }
        }

        LOCAVAIL_ResetFilterStateStruct(state);
    }
}
