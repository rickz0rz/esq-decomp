#include <exec/types.h>
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

void SCRIPT_ResetCtrlContext(char *ctx)
{
    SCRIPT_CtrlContextSnapshot *p;
    LONG i;

    p = (SCRIPT_CtrlContextSnapshot *)ctx;

    p->type20SubtypeCache = 0;
    p->pendingWeatherCommandChar = 120;
    p->pendingTextdispCmdChar = 0;
    p->pendingTextdispCmdArg = 0;

    p->commandTextPtr = ESQPARS_ReplaceOwnedString((const char *)0, p->commandTextPtr);

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
