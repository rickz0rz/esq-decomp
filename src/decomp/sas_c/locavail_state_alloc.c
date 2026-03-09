typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;
typedef unsigned short UWORD;

typedef struct LOCAVAIL_NodeRecord {
    UBYTE flag0;
    UBYTE pad1;
    UWORD duration2;
    UWORD payloadSize4;
    UBYTE *payload6;
} LOCAVAIL_NodeRecord;

typedef struct LOCAVAIL_FilterState {
    UBYTE mode0;
    UBYTE pad1;
    LONG nodeCount2;
    UBYTE modeChar6;
    UBYTE pad7;
    LONG field8;
    LONG field12;
    ULONG *sharedRef16;
    LOCAVAIL_NodeRecord *nodeTable20;
} LOCAVAIL_FilterState;

#define MEMF_PUBLIC 0x00000001L
#define MEMF_CLEAR  0x00010000L

extern const char Global_STR_LOCAVAIL_C_4[];
extern const char Global_STR_LOCAVAIL_C_5[];

extern LONG GROUP_AY_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern void *NEWGRID_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);

void LOCAVAIL_CopyFilterStateStructRetainRefs(void *dst_state, const void *src_state)
{
    LOCAVAIL_FilterState *dst = (LOCAVAIL_FilterState *)dst_state;
    const LOCAVAIL_FilterState *src = (const LOCAVAIL_FilterState *)src_state;
    ULONG *ref_hdr;

    dst->mode0 = src->mode0;
    dst->nodeCount2 = src->nodeCount2;
    dst->modeChar6 = src->modeChar6;
    ref_hdr = src->sharedRef16;
    dst->sharedRef16 = ref_hdr;
    dst->nodeTable20 = src->nodeTable20;

    if (dst->sharedRef16 != (ULONG *)0) {
        ++(*ref_hdr);
    }
}

LONG LOCAVAIL_AllocNodeArraysForState(void *state)
{
    LOCAVAIL_FilterState *s = (LOCAVAIL_FilterState *)state;
    LONG ok = 0;
    LONG count = s->nodeCount2;

    if (count > 0 && count < 100) {
        ULONG *ref_hdr = (ULONG *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(
            Global_STR_LOCAVAIL_C_4, 218, 4, MEMF_PUBLIC + MEMF_CLEAR);
        s->sharedRef16 = ref_hdr;
        if (ref_hdr != (ULONG *)0) {
            LONG bytes;
            *ref_hdr = 0;
            bytes = GROUP_AY_JMPTBL_MATH_Mulu32(s->nodeCount2, 10);
            s->nodeTable20 = (LOCAVAIL_NodeRecord *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(
                Global_STR_LOCAVAIL_C_5, 229, bytes, MEMF_PUBLIC + MEMF_CLEAR);
            if (s->nodeTable20 != (LOCAVAIL_NodeRecord *)0) {
                ok = 1;
            }
        }
    }

    return ok;
}
