/* RESTORES: SCRIPT_SaveCtrlContextSnapshot
 * MODULE:   modules/groups/b/a/script3.s
 * STATUS:   behavioural
 *
 * 234 bytes in the original and 234 emitted -- the THIRD restoration to land on
 * the exact size by coincidence, with 22 differing regions. As with
 * ed_handle_edit_attributes_menu.c and esqiff2_show_attention_overlay.c, size
 * equality here is not evidence of fidelity.
 *
 * But this one is the cleanest demonstration in the project of WHY the register
 * question matters, because it is the only divergence present:
 *
 *   ref:  1779 xxxxxxxx 01b4     MOVE.B (abs).L,436(A3)
 *   got:  1b79 xxxxxxxx 01b4     MOVE.B (abs).L,436(A5)
 *
 * Every one of the 22 regions is that same two-bit difference in the address
 * register field. The original holds the snapshot pointer in A3; SAS/C holds it
 * in A5. Same instruction, same offset, same operand, same length -- which is
 * why the byte count matches exactly while almost every instruction differs.
 *
 * That is precisely the property the acceptance test in docs/compiler-version.md
 * measures (2f0b versus 2f0d). A compiler that reserves A5 as a frame pointer
 * would put this pointer in A3 and this function would go byte-exact with no
 * other change, since there is nothing else wrong with it.
 *
 * Reproduces otherwise in full: the four control bytes written before the owned
 * string is replaced, both inlined strcpy loops into the embedded 200-byte text
 * fields, all thirteen scalar copies at their exact offsets, and the four-element
 * paired index loop.
 *
 * The struct layout decodes as 444 bytes: scalars to 26, two 200-byte text
 * buffers, the active group at 426, two 4-byte index arrays at 428 and 432, four
 * control bytes at 436, and the owned string pointer at 440.
 *
 * SASC-MISMATCH: a3-vs-a5-register-allocation
 *   summary: see above -- the sole divergence, and the project's central one.
 */
#include <string.h>

struct CtrlSnapshot {
    short pad0;              /*   0 */
    short primaryFirst;      /*   2 */
    short primaryChan;       /*   4 */
    short secondaryChan;     /*   6 */
    short matchIndex;        /*   8 */
    short rangeArmed;        /*  10 */
    short sourceMode;        /*  12 */
    short rangeDigit;        /*  14 */
    long  matchCount;        /*  16 */
    long  cursor;            /*  20 */
    short runtimeMode;       /*  24 */
    char  primaryText[200];  /*  26 */
    char  secondaryText[200];/* 226 */
    short activeGroup;       /* 426 */
    char  fallbackIdx[4];    /* 428 */
    char  selectedIdx[4];    /* 432 */
    char  type20Subtype;     /* 436 */
    char  weatherCmd;        /* 437 */
    char  textdispCmd;       /* 438 */
    char  textdispArg;       /* 439 */
    char *commandText;       /* 440 */
};

extern char *ESQPARS_ReplaceOwnedString(char *newstr, char *old);
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

void SCRIPT_SaveCtrlContextSnapshot(struct CtrlSnapshot *s)
{
    register long i;

    s->type20Subtype = SCRIPT_Type20SubtypeCache;
    s->weatherCmd    = SCRIPT_PendingWeatherCommandChar;
    s->textdispCmd   = SCRIPT_PendingTextdispCmdChar;
    s->textdispArg   = SCRIPT_PendingTextdispCmdArg;

    s->commandText = ESQPARS_ReplaceOwnedString(SCRIPT_CommandTextPtr,
                                                                s->commandText);

    s->primaryFirst   = SCRIPT_PrimarySearchFirstFlag;
    s->primaryChan    = TEXTDISP_PrimaryChannelCode;
    s->secondaryChan  = TEXTDISP_SecondaryChannelCode;
    strcpy(s->primaryText, TEXTDISP_PrimarySearchText);
    strcpy(s->secondaryText, TEXTDISP_SecondarySearchText);
    s->matchIndex     = TEXTDISP_CurrentMatchIndex;
    s->rangeArmed     = SCRIPT_ChannelRangeArmedFlag;
    s->sourceMode     = TEXTDISP_ChannelSourceMode;
    s->rangeDigit     = SCRIPT_ChannelRangeDigitChar;
    s->matchCount     = SCRIPT_SearchMatchCountOrIndex;
    s->cursor         = SCRIPT_PlaybackCursor;
    s->runtimeMode    = SCRIPT_RuntimeMode;
    s->activeGroup    = TEXTDISP_ActiveGroupId;

    for (i = 0; i < 4; i++) {
        s->fallbackIdx[i] = TEXTDISP_BannerFallbackEntryIndex[i];
        s->selectedIdx[i] = TEXTDISP_BannerSelectedEntryIndex[i];
    }
}
