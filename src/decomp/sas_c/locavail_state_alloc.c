typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

#define MEMF_PUBLIC 0x00000001L
#define MEMF_CLEAR  0x00010000L

extern const char Global_STR_LOCAVAIL_C_4[];
extern const char Global_STR_LOCAVAIL_C_5[];

extern LONG GROUP_AY_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern void *NEWGRID_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);

void LOCAVAIL_CopyFilterStateStructRetainRefs(void *dst_state, const void *src_state)
{
    UBYTE *dst = (UBYTE *)dst_state;
    const UBYTE *src = (const UBYTE *)src_state;
    ULONG *ref_hdr;

    dst[0] = src[0];
    *(LONG *)(dst + 2) = *(const LONG *)(src + 2);
    dst[6] = src[6];
    ref_hdr = *(ULONG **)(src + 16);
    *(ULONG **)(dst + 16) = ref_hdr;
    *(ULONG **)(dst + 20) = *(ULONG **)(src + 20);

    if (*(ULONG **)(dst + 16) != (ULONG *)0) {
        ++(*ref_hdr);
    }
}

LONG LOCAVAIL_AllocNodeArraysForState(void *state)
{
    UBYTE *s = (UBYTE *)state;
    LONG ok = 0;
    LONG count = *(LONG *)(s + 2);

    if (count > 0 && count < 100) {
        ULONG *ref_hdr = (ULONG *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(
            Global_STR_LOCAVAIL_C_4, 218, 4, MEMF_PUBLIC + MEMF_CLEAR);
        *(ULONG **)(s + 16) = ref_hdr;
        if (ref_hdr != (ULONG *)0) {
            LONG bytes;
            *ref_hdr = 0;
            bytes = GROUP_AY_JMPTBL_MATH_Mulu32(*(LONG *)(s + 2), 10);
            *(void **)(s + 20) = NEWGRID_JMPTBL_MEMORY_AllocateMemory(
                Global_STR_LOCAVAIL_C_5, 229, bytes, MEMF_PUBLIC + MEMF_CLEAR);
            if (*(void **)(s + 20) != (void *)0) {
                ok = 1;
            }
        }
    }

    return ok;
}
