#include "esq_types.h"

/*
 * Target 618 GCC trial function.
 * Rebuild banner pair, load DAT payload, parse G2/G3 fragments, then refresh queue.
 */
extern const char *DST_DefaultDatPathPtr;
extern void *Global_PTR_WORK_BUFFER;
extern s32 Global_REF_LONG_FILE_SCRATCH;
extern u8 Global_STR_G2[];
extern u8 Global_STR_G3[];
extern u8 Global_STR_DST_C_7[];

void DST_RebuildBannerPair(void *pair) __attribute__((noinline));
s32 DISKIO_LoadFileToWorkBuffer(const char *path) __attribute__((noinline));
char *GROUP_AJ_JMPTBL_STRING_FindSubstring(const char *text, const char *needle) __attribute__((noinline));
void DATETIME_ParseString(void *out_struct, const char *text, s32 width) __attribute__((noinline));
void DATETIME_CopyPairAndRecalc(void *dst, const void *lhs, const void *rhs) __attribute__((noinline));
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, s32 line, void *ptr, u32 size) __attribute__((noinline));
void DST_UpdateBannerQueue(void *pair) __attribute__((noinline));

s32 DST_LoadBannerPairFromFiles(void *pair) __attribute__((noinline, used));

s32 DST_LoadBannerPairFromFiles(void *pair)
{
    u8 *p = (u8 *)pair;
    u8 parsed_a[22];
    u8 parsed_b[22];
    char *work;
    s32 scratch_len;
    char *hit;

    DST_RebuildBannerPair(p);

    if (DISKIO_LoadFileToWorkBuffer(DST_DefaultDatPathPtr) == -1) {
        return 0;
    }

    work = (char *)Global_PTR_WORK_BUFFER;
    scratch_len = Global_REF_LONG_FILE_SCRATCH;

    hit = GROUP_AJ_JMPTBL_STRING_FindSubstring(work, (const char *)Global_STR_G2);
    if (hit != (char *)0) {
        DATETIME_ParseString(parsed_a, hit, 4);
        DATETIME_ParseString(parsed_b, hit, 19);
        DATETIME_CopyPairAndRecalc(*(void **)(p + 4), parsed_a, parsed_b);
    }

    hit = GROUP_AJ_JMPTBL_STRING_FindSubstring(work, (const char *)Global_STR_G3);
    if (hit != (char *)0) {
        DATETIME_ParseString(parsed_a, hit, 4);
        DATETIME_ParseString(parsed_b, hit, 19);
        DATETIME_CopyPairAndRecalc(*(void **)(p + 0), parsed_a, parsed_b);
    }

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DST_C_7, 889, work, (u32)(scratch_len + 1));
    DST_UpdateBannerQueue(p);

    return 1;
}
