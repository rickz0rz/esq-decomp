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

void SCRIPT_SaveCtrlContextSnapshot(void *ctx)
{
    UBYTE *p;
    UBYTE *src;
    UBYTE *dst;
    LONG i;

    p = (UBYTE *)ctx;

    p[436] = SCRIPT_Type20SubtypeCache;
    p[437] = SCRIPT_PendingWeatherCommandChar;
    p[438] = SCRIPT_PendingTextdispCmdChar;
    p[439] = SCRIPT_PendingTextdispCmdArg;
    *(LONG *)(p + 440) = ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(*(LONG *)(p + 440), SCRIPT_CommandTextPtr);

    *(UWORD *)(p + 2) = SCRIPT_PrimarySearchFirstFlag;
    *(UWORD *)(p + 4) = TEXTDISP_PrimaryChannelCode;
    *(UWORD *)(p + 6) = TEXTDISP_SecondaryChannelCode;

    dst = p + 26;
    src = &TEXTDISP_PrimarySearchText;
    do {
        *dst++ = *src;
    } while (*src++ != 0);

    dst = p + 226;
    src = &TEXTDISP_SecondarySearchText;
    do {
        *dst++ = *src;
    } while (*src++ != 0);

    *(UWORD *)(p + 8) = TEXTDISP_CurrentMatchIndex;
    *(UWORD *)(p + 10) = SCRIPT_ChannelRangeArmedFlag;
    *(UWORD *)(p + 12) = TEXTDISP_ChannelSourceMode;
    *(UWORD *)(p + 14) = SCRIPT_ChannelRangeDigitChar;
    *(LONG *)(p + 16) = SCRIPT_SearchMatchCountOrIndex;
    *(LONG *)(p + 20) = SCRIPT_PlaybackCursor;
    *(UWORD *)(p + 24) = SCRIPT_RuntimeMode;
    *(UWORD *)(p + 426) = TEXTDISP_ActiveGroupId;

    for (i = 0; i < 4; i++) {
        p[0x1ac + i] = *(&TEXTDISP_BannerFallbackEntryIndex + i);
        p[0x1b0 + i] = *(&TEXTDISP_BannerSelectedEntryIndex + i);
    }
}
