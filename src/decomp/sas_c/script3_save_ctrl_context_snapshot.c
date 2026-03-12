typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UBYTE SCRIPT_Type20SubtypeCache;
extern UBYTE SCRIPT_PendingWeatherCommandChar;
extern UBYTE SCRIPT_PendingTextdispCmdChar;
extern UBYTE SCRIPT_PendingTextdispCmdArg;
extern char *SCRIPT_CommandTextPtr;
extern UWORD SCRIPT_PrimarySearchFirstFlag;
extern UWORD TEXTDISP_PrimaryChannelCode;
extern UWORD TEXTDISP_SecondaryChannelCode;
extern char TEXTDISP_PrimarySearchText[];
extern char TEXTDISP_SecondarySearchText[];
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

extern char *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(const char *newPtr, char *oldPtr);

typedef struct SCRIPT_CtrlContextSnapshot {
    UBYTE pad0[2];
    UWORD primarySearchFirstFlag;
    UWORD primaryChannelCode;
    UWORD secondaryChannelCode;
    UWORD currentMatchIndex;
    UWORD channelRangeArmedFlag;
    UWORD channelSourceMode;
    UWORD channelRangeDigitChar;
    LONG searchMatchCountOrIndex;
    LONG playbackCursor;
    UWORD runtimeMode;
    char primarySearchText[200];
    char secondarySearchText[200];
    UWORD activeGroupId;
    UBYTE bannerFallbackEntryIndex[4];
    UBYTE bannerSelectedEntryIndex[4];
    UBYTE type20SubtypeCache;
    UBYTE pendingWeatherCommandChar;
    UBYTE pendingTextdispCmdChar;
    UBYTE pendingTextdispCmdArg;
    char *commandTextPtr;
} SCRIPT_CtrlContextSnapshot;

void SCRIPT_SaveCtrlContextSnapshot(char *ctx)
{
    SCRIPT_CtrlContextSnapshot *p;
    char *src;
    char *dst;
    LONG i;

    p = (SCRIPT_CtrlContextSnapshot *)ctx;

    p->type20SubtypeCache = SCRIPT_Type20SubtypeCache;
    p->pendingWeatherCommandChar = SCRIPT_PendingWeatherCommandChar;
    p->pendingTextdispCmdChar = SCRIPT_PendingTextdispCmdChar;
    p->pendingTextdispCmdArg = SCRIPT_PendingTextdispCmdArg;
    p->commandTextPtr = ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(SCRIPT_CommandTextPtr, p->commandTextPtr);

    p->primarySearchFirstFlag = SCRIPT_PrimarySearchFirstFlag;
    p->primaryChannelCode = TEXTDISP_PrimaryChannelCode;
    p->secondaryChannelCode = TEXTDISP_SecondaryChannelCode;

    dst = p->primarySearchText;
    src = TEXTDISP_PrimarySearchText;
    do {
        *dst++ = *src;
    } while (*src++ != 0);

    dst = p->secondarySearchText;
    src = TEXTDISP_SecondarySearchText;
    do {
        *dst++ = *src;
    } while (*src++ != 0);

    p->currentMatchIndex = TEXTDISP_CurrentMatchIndex;
    p->channelRangeArmedFlag = SCRIPT_ChannelRangeArmedFlag;
    p->channelSourceMode = TEXTDISP_ChannelSourceMode;
    p->channelRangeDigitChar = SCRIPT_ChannelRangeDigitChar;
    p->searchMatchCountOrIndex = SCRIPT_SearchMatchCountOrIndex;
    p->playbackCursor = SCRIPT_PlaybackCursor;
    p->runtimeMode = SCRIPT_RuntimeMode;
    p->activeGroupId = TEXTDISP_ActiveGroupId;

    for (i = 0; i < 4; i++) {
        p->bannerFallbackEntryIndex[i] = *(&TEXTDISP_BannerFallbackEntryIndex + i);
        p->bannerSelectedEntryIndex[i] = *(&TEXTDISP_BannerSelectedEntryIndex + i);
    }
}
