typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UBYTE SCRIPT_Type20SubtypeCache;
extern UBYTE SCRIPT_PendingWeatherCommandChar;
extern UBYTE SCRIPT_PendingTextdispCmdChar;
extern UBYTE SCRIPT_PendingTextdispCmdArg;
extern LONG SCRIPT_CommandTextPtr;
extern UWORD SCRIPT_PrimarySearchFirstFlag;
extern UWORD TEXTDISP_PrimaryChannelCode;
extern UWORD TEXTDISP_SecondaryChannelCode;
extern UBYTE TEXTDISP_PrimarySearchText;
extern UBYTE TEXTDISP_SecondarySearchText;
extern UWORD TEXTDISP_CurrentMatchIndex;
extern UWORD SCRIPT_ChannelRangeArmedFlag;
extern UWORD TEXTDISP_ChannelSourceMode;
extern UWORD SCRIPT_ChannelRangeDigitChar;
extern LONG SCRIPT_SearchMatchCountOrIndex;
extern LONG SCRIPT_PlaybackCursor;
extern UWORD SCRIPT_RuntimeMode;
extern UWORD TEXTDISP_ActiveGroupId;
extern UBYTE TEXTDISP_BannerFallbackEntryIndex;
extern UBYTE TEXTDISP_BannerSelectedEntryIndex;

extern LONG ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(LONG oldPtr, LONG newPtr);

void SCRIPT_LoadCtrlContextSnapshot(void *ctx)
{
    UBYTE *p;
    UBYTE *src;
    UBYTE *dst;
    UWORD savedMode;
    LONG i;

    p = (UBYTE *)ctx;

    SCRIPT_Type20SubtypeCache = p[436];
    SCRIPT_PendingWeatherCommandChar = p[437];
    SCRIPT_PendingTextdispCmdChar = p[438];
    SCRIPT_PendingTextdispCmdArg = p[439];

    SCRIPT_CommandTextPtr = ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(SCRIPT_CommandTextPtr, *(LONG *)(p + 440));

    SCRIPT_PrimarySearchFirstFlag = *(UWORD *)(p + 2);
    TEXTDISP_PrimaryChannelCode = *(UWORD *)(p + 4);
    TEXTDISP_SecondaryChannelCode = *(UWORD *)(p + 6);

    src = p + 26;
    dst = &TEXTDISP_PrimarySearchText;
    do {
        *dst++ = *src;
    } while (*src++ != 0);

    src = p + 226;
    dst = &TEXTDISP_SecondarySearchText;
    do {
        *dst++ = *src;
    } while (*src++ != 0);

    TEXTDISP_CurrentMatchIndex = *(UWORD *)(p + 8);
    SCRIPT_ChannelRangeArmedFlag = *(UWORD *)(p + 10);
    TEXTDISP_ChannelSourceMode = *(UWORD *)(p + 12);
    SCRIPT_ChannelRangeDigitChar = *(UWORD *)(p + 14);
    SCRIPT_SearchMatchCountOrIndex = *(LONG *)(p + 16);
    SCRIPT_PlaybackCursor = *(LONG *)(p + 20);

    savedMode = *(UWORD *)(p + 24);
    if ((SCRIPT_RuntimeMode == 2 && savedMode == 3) || (SCRIPT_RuntimeMode == 0 && savedMode == 1)) {
        SCRIPT_RuntimeMode = savedMode;
    }

    TEXTDISP_ActiveGroupId = *(UWORD *)(p + 426);
    for (i = 0; i < 4; i++) {
        *(&TEXTDISP_BannerFallbackEntryIndex + i) = p[0x1ac + i];
        *(&TEXTDISP_BannerSelectedEntryIndex + i) = p[0x1b0 + i];
    }
}
