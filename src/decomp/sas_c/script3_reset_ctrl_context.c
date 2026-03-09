typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern char *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(char *oldPtr, char *newPtr);

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
    UBYTE pad26[200];
    char primarySearchText[200];
    char secondarySearchText[200];
    UWORD activeGroupId;
    UBYTE bannerFallbackEntryIndex[4];
    UBYTE pad432[4];
    UBYTE type20SubtypeCache;
    UBYTE pendingWeatherCommandChar;
    UBYTE pendingTextdispCmdChar;
    UBYTE pendingTextdispCmdArg;
    char *commandTextPtr;
    UBYTE bannerSelectedEntryIndex[4];
} SCRIPT_CtrlContextSnapshot;

void SCRIPT_ResetCtrlContext(char *ctx)
{
    SCRIPT_CtrlContextSnapshot *p;
    LONG i;

    p = (SCRIPT_CtrlContextSnapshot *)ctx;

    p->type20SubtypeCache = 0;
    p->pendingWeatherCommandChar = 120;
    p->pendingTextdispCmdChar = 0;
    p->pendingTextdispCmdArg = 0;

    p->commandTextPtr = ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(p->commandTextPtr, (char *)0);

    p->secondarySearchText[0] = 0;
    p->primarySearchText[0] = 0;
    p->secondaryChannelCode = 0;
    p->primaryChannelCode = 0;
    p->channelRangeArmedFlag = 0;
    p->channelSourceMode = 0;
    p->channelRangeDigitChar = 0;
    p->searchMatchCountOrIndex = 0;
    p->playbackCursor = 0;
    p->runtimeMode = 0;
    p->activeGroupId = 1;

    for (i = 0; i < 4; i++) {
        p->bannerFallbackEntryIndex[i] = 0;
        p->bannerSelectedEntryIndex[i] = 0;
    }
}
