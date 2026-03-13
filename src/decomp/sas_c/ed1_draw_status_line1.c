typedef signed long LONG;
typedef signed short WORD;

extern WORD ESQPARS2_StateIndex;
extern LONG WDISP_DisplayContextBase;

extern const char ED2_FMT_SCRSPD_PCT_D[];

extern LONG WDISP_SPrintf(char *dst, const char *fmt, ...);
extern void TLIBA3_DrawCenteredWrappedTextLines(char *rastPort, const char *text, LONG y);

typedef struct ED1_DisplayContext {
    unsigned char pad0[2];
    unsigned char rastPort[1];
} ED1_DisplayContext;

void ED1_DrawStatusLine1(void)
{
    ED1_DisplayContext *context;
    char statusLine[41];

    WDISP_SPrintf(statusLine, ED2_FMT_SCRSPD_PCT_D, (LONG)ESQPARS2_StateIndex);
    context = (ED1_DisplayContext *)WDISP_DisplayContextBase;

    TLIBA3_DrawCenteredWrappedTextLines(
        (char *)context->rastPort,
        statusLine,
        210
    );
}
