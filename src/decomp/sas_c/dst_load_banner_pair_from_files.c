typedef signed long LONG;
typedef unsigned char UBYTE;
typedef unsigned long ULONG;

extern const char *DST_DefaultDatPathPtr;
extern void *Global_PTR_WORK_BUFFER;
extern LONG Global_REF_LONG_FILE_SCRATCH;
extern UBYTE Global_STR_G2[];
extern UBYTE Global_STR_G3[];
extern UBYTE Global_STR_DST_C_7[];

extern void DST_RebuildBannerPair(void *pair);
extern LONG DISKIO_LoadFileToWorkBuffer(const char *path);
extern char *GROUP_AJ_JMPTBL_STRING_FindSubstring(const char *text, const char *needle);
extern void DATETIME_ParseString(void *out_struct, const char *text, LONG width);
extern void DATETIME_CopyPairAndRecalc(void *dst, const void *lhs, const void *rhs);
extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, ULONG size);
extern void DST_UpdateBannerQueue(void *pair);

LONG DST_LoadBannerPairFromFiles(void *pair)
{
    UBYTE *p = (UBYTE *)pair;
    UBYTE parsed_a[22];
    UBYTE parsed_b[22];
    char *work;
    LONG scratch_len;
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

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DST_C_7, 889, work, (ULONG)(scratch_len + 1));
    DST_UpdateBannerQueue(p);

    return 1;
}
