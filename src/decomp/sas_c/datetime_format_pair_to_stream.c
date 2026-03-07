typedef long LONG;

#define WORD_AT(p, off) (*(short *)((char *)(p) + (off)))

enum {
    DATETIME_PAIR_OUT_PTR_OFFSET = 4,
    DATETIME_IN_PREFIX_TOKEN = 4,
    DATETIME_OUT_PREFIX_TOKEN = 19,
    DATETIME_HOURS_PER_HALF_DAY = 12
};

extern LONG GROUP_AM_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...);
extern char *GROUP_AI_JMPTBL_STRING_AppendAtNull(char *dst, const char *src);
extern LONG GROUP_AG_JMPTBL_MATH_DivS32(LONG a, LONG b);
extern LONG DISKIO_WriteBufferedBytes(LONG fileHandle, const void *src, LONG len);

extern const char *DST_FMT_PCT_C_InTimePrefixChar;
extern const char *DST_FMT_PCT_04D_PCT_03D_InTimeDateCode;
extern const char *DST_FMT_PCT_02D_COLON_PCT_02D_InTimeClock;
extern const char *DST_FMT_PCT_C_OutTimePrefixChar;
extern const char *DST_FMT_PCT_04D_PCT_03D_OutTimeDateCode;
extern const char *DST_FMT_PCT_02D_COLON_PCT_02D_OutTimeClock;
extern const char *DST_STR_NO_IN_TIME;
extern const char *DST_STR_NO_OUT_TIME;
extern const char *DST_STR_NO_DST_DATA;

LONG DATETIME_FormatPairToStream(LONG fileHandle, void *pairStruct)
{
    char outBuf[87];
    char scratch[51];
    char *outCursor;
    void *t;
    LONG hour12;
    LONG writeResult;

    outBuf[0] = 0;
    if (pairStruct == (void *)0) {
        GROUP_AI_JMPTBL_STRING_AppendAtNull(outBuf, DST_STR_NO_DST_DATA);
        goto emit;
    }

    t = *(void **)pairStruct;
    if (t != (void *)0) {
        GROUP_AM_JMPTBL_WDISP_SPrintf(scratch, DST_FMT_PCT_C_InTimePrefixChar, DATETIME_IN_PREFIX_TOKEN);
        GROUP_AI_JMPTBL_STRING_AppendAtNull(outBuf, scratch);

        GROUP_AM_JMPTBL_WDISP_SPrintf(
            scratch,
            DST_FMT_PCT_04D_PCT_03D_InTimeDateCode,
            (LONG)WORD_AT(t, 6),
            (LONG)WORD_AT(t, 16));
        GROUP_AI_JMPTBL_STRING_AppendAtNull(outBuf, scratch);

        (void)GROUP_AG_JMPTBL_MATH_DivS32((LONG)WORD_AT(t, 8), DATETIME_HOURS_PER_HALF_DAY);
        hour12 = ((LONG)WORD_AT(t, 8)) / DATETIME_HOURS_PER_HALF_DAY;
        if (WORD_AT(t, 18) != 0) {
            hour12 += DATETIME_HOURS_PER_HALF_DAY;
        }

        GROUP_AM_JMPTBL_WDISP_SPrintf(
            scratch,
            DST_FMT_PCT_02D_COLON_PCT_02D_InTimeClock,
            hour12,
            (LONG)WORD_AT(t, 10));
        GROUP_AI_JMPTBL_STRING_AppendAtNull(outBuf, scratch);
    } else {
        GROUP_AI_JMPTBL_STRING_AppendAtNull(outBuf, DST_STR_NO_IN_TIME);
    }

    t = *(void **)((char *)pairStruct + DATETIME_PAIR_OUT_PTR_OFFSET);
    if (t != (void *)0) {
        GROUP_AM_JMPTBL_WDISP_SPrintf(scratch, DST_FMT_PCT_C_OutTimePrefixChar, DATETIME_OUT_PREFIX_TOKEN);
        GROUP_AI_JMPTBL_STRING_AppendAtNull(outBuf, scratch);

        GROUP_AM_JMPTBL_WDISP_SPrintf(
            scratch,
            DST_FMT_PCT_04D_PCT_03D_OutTimeDateCode,
            (LONG)WORD_AT(t, 6),
            (LONG)WORD_AT(t, 16));
        GROUP_AI_JMPTBL_STRING_AppendAtNull(outBuf, scratch);

        (void)GROUP_AG_JMPTBL_MATH_DivS32((LONG)WORD_AT(t, 8), DATETIME_HOURS_PER_HALF_DAY);
        hour12 = ((LONG)WORD_AT(t, 8)) / DATETIME_HOURS_PER_HALF_DAY;
        if (WORD_AT(t, 18) != 0) {
            hour12 += DATETIME_HOURS_PER_HALF_DAY;
        }

        GROUP_AM_JMPTBL_WDISP_SPrintf(
            scratch,
            DST_FMT_PCT_02D_COLON_PCT_02D_OutTimeClock,
            hour12,
            (LONG)WORD_AT(t, 10));
        GROUP_AI_JMPTBL_STRING_AppendAtNull(outBuf, scratch);
    } else {
        GROUP_AI_JMPTBL_STRING_AppendAtNull(outBuf, DST_STR_NO_OUT_TIME);
    }

emit:
    outCursor = outBuf;
    while (*outCursor != 0) {
        outCursor++;
    }
    writeResult = DISKIO_WriteBufferedBytes(fileHandle, outBuf, (LONG)(outCursor - outBuf));
    return writeResult;
}
