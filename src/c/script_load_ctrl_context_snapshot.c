/* RESTORES: _SCRIPT_LoadCtrlContextSnapshot
 * MODULE:   modules/groups/b/a/script3b_p0_p1_p0.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-only
 *   ref:     48e70110266f000c13eb01b4000075ea13eb01b50000760213eb01b60000760313eb01b7000076042f39000076062f2b01b84eba6bea504f23c00000760633eb00020000c27e33eb00040000c0aa33eb00060000c0ac41eb001a43f90000bf1a12d866fc41eb00e243f90000bfe212d866fc33eb00080000c75833eb000a0000c28033eb000c0000c75a33eb000e0000c0ae23eb00100000c0b023eb00140000c0b430390000bf105540660a302b00187203b041671230390000bf106610302b00187201b041660633c00000bf1033eb01aa000076e87e007004be806c2c41f90000cd96d1c720070680000001ac10b3080041f90000cd9ad1c720070680000001b010b30800528760ce4cdf08804e75
 *   got:     48e701042a6f000c13ed01b40000000013ed01b50000000013ed01b60000000013ed01b7000000002f39000000002f2d01b86100000023c000000000504f33ed00020000000033ed00040000000033ed00060000000041ed001a43f90000000012d866fc41ed00e243f90000000012d866fc33ed00080000000033ed000a0000000033ed000c0000000033ed000e0000000023ed00100000000023ed0014000000003039000000005540660a302d00187203b04167123039000000006610302d00187201b041660633c00000000033ed01aa000000007e007004be806c2c41f900000000d1c720070680000001ac10b5080041f900000000d1c720070680000001b010b50800528760ce4cdf20804e75
 *   summary: 272 got vs 272 ref, and the first divergence is at byte 3 -- the register holding the snapshot pointer. The original picks A3, 6.51 picks A5, so every field access reads 13ed/33ed/23ed where the original reads 13eb/33eb/23eb, and the entry and exit MOVEM masks differ to match. One instruction moves: the original stores the ReplaceOwnedString result after popping the argument block, 6.51 stores it before. Everything else is identical in kind, size and order, including both inlined strcpy loops, the two-arm runtime-mode gate and the four-iteration shadow-byte copy with its ADDI.L #$1ac / #$1b0 index.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

struct CtrlSnapshot {
    char  pad0[2];
    short searchFirstFlag;          /* +2 */
    short primaryChannelCode;       /* +4 */
    short secondaryChannelCode;     /* +6 */
    short currentMatchIndex;        /* +8 */
    short rangeArmedFlag;           /* +10 */
    short channelSourceMode;        /* +12 */
    short rangeDigitChar;           /* +14 */
    long  matchCountOrIndex;        /* +16 */
    long  playbackCursor;           /* +20 */
    short savedMode;                /* +24 */
    char  primarySearch[200];       /* +26 */
    char  secondarySearch[200];     /* +226 */
    short activeGroupId;            /* +426 */
    char  fallbackEntry[4];         /* +428 */
    char  selectedEntry[4];         /* +432 */
    char  type20Subtype;            /* +436 */
    char  weatherCommandChar;       /* +437 */
    char  textdispCmdChar;          /* +438 */
    char  textdispCmdArg;           /* +439 */
    char *commandText;              /* +440 */
};

extern char  SCRIPT_Type20SubtypeCache;
extern char  SCRIPT_PendingWeatherCommandChar;
extern char  SCRIPT_PendingTextdispCmdChar;
extern char  SCRIPT_PendingTextdispCmdArg;
extern char *SCRIPT_CommandTextPtr;
extern short SCRIPT_PrimarySearchFirstFlag;
extern short TEXTDISP_PrimaryChannelCode;
extern short TEXTDISP_SecondaryChannelCode;
extern char  TEXTDISP_PrimarySearchText[];
extern char  TEXTDISP_SecondarySearchText[];
extern short TEXTDISP_CurrentMatchIndex;
extern short SCRIPT_ChannelRangeArmedFlag;
extern short TEXTDISP_ChannelSourceMode;
extern short SCRIPT_ChannelRangeDigitChar;
extern long  SCRIPT_SearchMatchCountOrIndex;
extern long  SCRIPT_PlaybackCursor;
extern short SCRIPT_RuntimeMode;
extern short TEXTDISP_ActiveGroupId;
extern char  TEXTDISP_BannerFallbackEntryIndex[];
extern char  TEXTDISP_BannerSelectedEntryIndex[];

extern char *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(char *src, char *owned);

void SCRIPT_LoadCtrlContextSnapshot(struct CtrlSnapshot *s)
{
    long i;

    SCRIPT_Type20SubtypeCache        = s->type20Subtype;
    SCRIPT_PendingWeatherCommandChar = s->weatherCommandChar;
    SCRIPT_PendingTextdispCmdChar    = s->textdispCmdChar;
    SCRIPT_PendingTextdispCmdArg     = s->textdispCmdArg;

    SCRIPT_CommandTextPtr = ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(
        s->commandText, SCRIPT_CommandTextPtr);

    SCRIPT_PrimarySearchFirstFlag = s->searchFirstFlag;
    TEXTDISP_PrimaryChannelCode   = s->primaryChannelCode;
    TEXTDISP_SecondaryChannelCode = s->secondaryChannelCode;

    strcpy(TEXTDISP_PrimarySearchText, s->primarySearch);
    strcpy(TEXTDISP_SecondarySearchText, s->secondarySearch);

    TEXTDISP_CurrentMatchIndex     = s->currentMatchIndex;
    SCRIPT_ChannelRangeArmedFlag   = s->rangeArmedFlag;
    TEXTDISP_ChannelSourceMode     = s->channelSourceMode;
    SCRIPT_ChannelRangeDigitChar   = s->rangeDigitChar;
    SCRIPT_SearchMatchCountOrIndex = s->matchCountOrIndex;
    SCRIPT_PlaybackCursor          = s->playbackCursor;

    if ((SCRIPT_RuntimeMode == 2 && s->savedMode == 3)
        || (SCRIPT_RuntimeMode == 0 && s->savedMode == 1))
        SCRIPT_RuntimeMode = s->savedMode;

    TEXTDISP_ActiveGroupId = s->activeGroupId;

    for (i = 0; i < 4; i++) {
        TEXTDISP_BannerFallbackEntryIndex[i] = s->fallbackEntry[i];
        TEXTDISP_BannerSelectedEntryIndex[i] = s->selectedEntry[i];
    }
}
