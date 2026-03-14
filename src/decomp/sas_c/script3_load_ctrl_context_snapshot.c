#include <exec/types.h>
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

extern char *ESQPARS_ReplaceOwnedString(const char *newPtr, char *oldPtr);

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

void SCRIPT_LoadCtrlContextSnapshot(char *ctx)
{
    SCRIPT_CtrlContextSnapshot *p;
    char *src;
    char *dst;
    UWORD savedMode;
    LONG i;

    p = (SCRIPT_CtrlContextSnapshot *)ctx;

    SCRIPT_Type20SubtypeCache = p->type20SubtypeCache;
    SCRIPT_PendingWeatherCommandChar = p->pendingWeatherCommandChar;
    SCRIPT_PendingTextdispCmdChar = p->pendingTextdispCmdChar;
    SCRIPT_PendingTextdispCmdArg = p->pendingTextdispCmdArg;

    SCRIPT_CommandTextPtr = ESQPARS_ReplaceOwnedString(p->commandTextPtr, SCRIPT_CommandTextPtr);

    SCRIPT_PrimarySearchFirstFlag = p->primarySearchFirstFlag;
    TEXTDISP_PrimaryChannelCode = p->primaryChannelCode;
    TEXTDISP_SecondaryChannelCode = p->secondaryChannelCode;

    src = p->primarySearchText;
    dst = TEXTDISP_PrimarySearchText;
    do {
        *dst++ = *src;
    } while (*src++ != 0);

    src = p->secondarySearchText;
    dst = TEXTDISP_SecondarySearchText;
    do {
        *dst++ = *src;
    } while (*src++ != 0);

    TEXTDISP_CurrentMatchIndex = p->currentMatchIndex;
    SCRIPT_ChannelRangeArmedFlag = p->channelRangeArmedFlag;
    TEXTDISP_ChannelSourceMode = p->channelSourceMode;
    SCRIPT_ChannelRangeDigitChar = p->channelRangeDigitChar;
    SCRIPT_SearchMatchCountOrIndex = p->searchMatchCountOrIndex;
    SCRIPT_PlaybackCursor = p->playbackCursor;

    savedMode = p->runtimeMode;
    if ((SCRIPT_RuntimeMode == 2 && savedMode == 3) || (SCRIPT_RuntimeMode == 0 && savedMode == 1)) {
        SCRIPT_RuntimeMode = savedMode;
    }

    TEXTDISP_ActiveGroupId = p->activeGroupId;
    for (i = 0; i < 4; i++) {
        *(&TEXTDISP_BannerFallbackEntryIndex + i) = p->bannerFallbackEntryIndex[i];
        *(&TEXTDISP_BannerSelectedEntryIndex + i) = p->bannerSelectedEntryIndex[i];
    }
}
