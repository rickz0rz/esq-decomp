typedef signed long LONG;
typedef signed short WORD;

extern WORD ESQPARS2_StateIndex;
extern LONG WDISP_DisplayContextBase;

extern const char ED2_FMT_SCRSPD_PCT_D[];

extern LONG GROUP_AM_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...);
extern LONG ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(void *rastPort, const char *text, LONG y);

void ED1_DrawStatusLine1(void)
{
    char statusLine[41];

    GROUP_AM_JMPTBL_WDISP_SPrintf(statusLine, ED2_FMT_SCRSPD_PCT_D, (LONG)ESQPARS2_StateIndex);

    ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(
        (void *)((unsigned char *)WDISP_DisplayContextBase + 2),
        statusLine,
        210
    );
}
