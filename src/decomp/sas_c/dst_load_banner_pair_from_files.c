typedef signed long LONG;
typedef unsigned char UBYTE;
typedef unsigned long ULONG;

extern const char *DST_DefaultDatPathPtr;
extern char *Global_PTR_WORK_BUFFER;
extern LONG Global_REF_LONG_FILE_SCRATCH;
extern const char Global_STR_G2[];
extern const char Global_STR_G3[];
extern const char Global_STR_DST_C_7[];

extern void DST_RebuildBannerPair(void *pair);
extern LONG DISKIO_LoadFileToWorkBuffer(const char *path);
extern char *GROUP_AJ_JMPTBL_STRING_FindSubstring(const char *text, const char *needle);
extern void DATETIME_ParseString(void *out_struct, const char *text, LONG width);
extern void DATETIME_CopyPairAndRecalc(void *dst, const void *lhs, const void *rhs);
extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, ULONG size);
extern void DST_UpdateBannerQueue(void *pair);

typedef struct DST_BannerPair {
    void *primaryBanner;
    void *secondaryBanner;
} DST_BannerPair;

LONG DST_LoadBannerPairFromFiles(void *pair)
{
    const LONG RESULT_FAIL = 0;
    const LONG RESULT_OK = 1;
    const LONG LINE_PARSE_WIDTH = 4;
    const LONG DATETIME_PARSE_WIDTH = 19;
    const LONG FREE_LINE = 889;
    const ULONG STR_TERM_BYTES = 1;
    DST_BannerPair *p = (DST_BannerPair *)pair;
    UBYTE parsed_a[22];
    UBYTE parsed_b[22];
    char *work;
    LONG scratch_len;
    char *hit;

    DST_RebuildBannerPair(p);

    if (DISKIO_LoadFileToWorkBuffer(DST_DefaultDatPathPtr) == -1) {
        return RESULT_FAIL;
    }

    work = Global_PTR_WORK_BUFFER;
    scratch_len = Global_REF_LONG_FILE_SCRATCH;

    hit = GROUP_AJ_JMPTBL_STRING_FindSubstring(work, Global_STR_G2);
    if (hit != 0) {
        DATETIME_ParseString(parsed_a, hit, LINE_PARSE_WIDTH);
        DATETIME_ParseString(parsed_b, hit, DATETIME_PARSE_WIDTH);
        DATETIME_CopyPairAndRecalc(p->secondaryBanner, parsed_a, parsed_b);
    }

    hit = GROUP_AJ_JMPTBL_STRING_FindSubstring(work, Global_STR_G3);
    if (hit != 0) {
        DATETIME_ParseString(parsed_a, hit, LINE_PARSE_WIDTH);
        DATETIME_ParseString(parsed_b, hit, DATETIME_PARSE_WIDTH);
        DATETIME_CopyPairAndRecalc(p->primaryBanner, parsed_a, parsed_b);
    }

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_DST_C_7, FREE_LINE, work, (ULONG)(scratch_len + STR_TERM_BYTES));
    DST_UpdateBannerQueue(p);

    return RESULT_OK;
}
