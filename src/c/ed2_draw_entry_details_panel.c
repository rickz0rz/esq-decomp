/* RESTORES: _ED2_DrawEntryDetailsPanel
 * MODULE:   modules/groups/a/k/ed2_ed2_drawentrydetailspanel.s
 * STATUS:   behavioural
 *
 * Draws the four-line entry-details panel on the diagnostics screen. 868 bytes:
 * clamp the two selection indices, format three lines, then append up to eight
 * flag names and draw those as a fourth.
 *
 * TWO OF THE THREE NULL TESTS ARE PROVABLY DEAD. The channel name and the call
 * letters are tested as `&data[1]` and `&data[19]` -- the address of a member,
 * which can never be zero -- so the fallback strings behind them are unreachable.
 * Per AGENTS.md that means the source went through a pointer local, so `namePtr`
 * and `callPtr` are locals here rather than the array expressions; testing the
 * address directly lets the compiler drop the branch and costs the match. Only the
 * source test, on ED2_SelectedEntryTitlePtr, can actually fire.
 *
 * THE FLAG BYTE IS RE-READ EIGHT TIMES, once per bit, and this restoration re-reads
 * it too. AGENTS.md notes the original often recomputes rather than hoisting, and
 * that is exactly what it does here: `title->slotFlag[offset]` reloaded before each
 * `BTST`. Hoisting it into a local would be one instruction shorter per test and
 * would not be the original.
 *
 * The flag byte lands on `DkTitle.slotFlag[offset]`, the same 49-byte array the
 * DISKIO2 loaders fill, because the original's `title + offset + 7` is that array
 * indexed. Naming it that way is what keeps the offset out of the source.
 *
 * MEASURED: 864 emitted against 868 in the original, -4 over 24 regions.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba....              JSR (d16,PC)
 *   got:     61000000              BSR.W
 *   summary: same size, different opcode; costs nothing.
 *   scope:   the whole cross-unit bucket.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: a5-frame-and-large-locals
 *   ref:     4e55ff6c ... 4e5d     LINK.W A5,#-148 / UNLK A5
 *   got:     A7-relative locals
 *   scope:   program-wide; docs/compiler-version.md.
 *   retest:  a compiler that reserves A5.
 *
 * SASC-MISMATCH: bit-test-width
 *   ref:     0828 0000 0007        BTST #n,7(A0)
 *   got:     a byte mask
 *   summary: eight single-bit tests on one byte. Written as `& (1 << n)`.
 *   scope:   anywhere a flag byte is tested a bit at a time.
 *   retest:  a compiler that narrows a byte mask to BTST.
 *
 * SASC-MISMATCH: unattributed-body-delta
 *   summary: NOT itemised. Recorded as a known-unknown per AGENTS.md rule 3.
 *   retest:  itemise again on a compiler that reserves A5.
 */
#include <exec/types.h>
#include <exec/memory.h>
#include <graphics/gfx.h>
#include <graphics/rastport.h>
#include <graphics/gfxbase.h>

#include "esq-graphics.h"

struct DkTitle {
    char          pad0[7];      /*   0 */
    unsigned char slotFlag[49]; /*   7 */
    char         *slotText[49]; /*  56 */
    unsigned char extA[49];     /* 252 */
    unsigned char extB[49];     /* 301 */
    unsigned char extC[49];     /* 350 */
    char          pad399[101];  /* 399, to the 500-byte record */
};

struct EsqDisplayContext {
    char  pad0[2];
    short width;
    short height;
    char  pad6[4];
    struct RastPort rp2;        /* 10 */
};

extern short ED2_SelectedEntryIndex;
extern short ED2_SelectedFlagByteOffset;
extern struct DkTitle *ED2_SelectedEntryTitlePtr;
extern char  *ED2_SelectedEntryDataPtr;
extern short TEXTDISP_PrimaryGroupEntryCount;
extern struct DkTitle *TEXTDISP_PrimaryTitlePtrTable[];
extern struct EsqDisplayContext *WDISP_DisplayContextBase;

extern char Global_STR_ED2_C_1[];
extern char Global_STR_ED2_C_2[];
extern char Global_STR_PI_CLU_POS1[];
extern char Global_STR_CHAN_SOURCE_CALLLTRS_1[];
extern char Global_STR_TS_TITLE_TIME[];
extern char ED2_STR_NullFallbackChannel[];
extern char ED2_STR_NullFallbackSource[];
extern char ED2_STR_NullFallbackCallLetters[];
extern char ED2_STR_NullFallbackTitle[];
extern char ED2_STR_NONE_ProgramFlagSummary[];
extern char ED2_STR_MOVIE[];
extern char ED2_STR_ALTHILITEPROG[];
extern char ED2_STR_TAGPROG[];
extern char ED2_STR_SPORTSPROG[];
extern char ED2_STR_DVIEW_USED[];
extern char ED2_STR_REPEATPROG[];
extern char ED2_STR_PREVDAYSDATA[];

extern void *MEMORY_AllocateMemory(char *who, long line, long size,
                                                 long flags);
extern void  MEMORY_DeallocateMemory(char *who, long line, void *p,
                                                   long size);
extern void  WDISP_SPrintf();
extern void  TLIBA3_DrawCenteredWrappedTextLines(void *rp,
                                                                char *text,
                                                                long y);
extern void  STRING_AppendAtNull(char *dst, char *src);
extern char *DISKIO2_CopyAndSanitizeSlotString(char *buf, char *entry,
                                               struct DkTitle *t, long slot);
extern void  TEXTDISP_FormatEntryTimeForIndex(char *buf,
                                                              long idx,
                                                              struct DkTitle *t);

void ED2_DrawEntryDetailsPanel(void)
{
    char  panelText[120];
    char  timeText[20];
    char *scratch;
    char *titleText;
    char *namePtr;
    char *srcPtr;
    char *callPtr;
    char *data;

    if (ED2_SelectedEntryIndex >= TEXTDISP_PrimaryGroupEntryCount ||
        ED2_SelectedEntryIndex < 0) {
        ED2_SelectedEntryTitlePtr = 0;
        ED2_SelectedEntryIndex = 0;
    } else {
        ED2_SelectedEntryTitlePtr =
            TEXTDISP_PrimaryTitlePtrTable[ED2_SelectedEntryIndex];
    }

    if (ED2_SelectedEntryTitlePtr == 0)
        return;
    if (ED2_SelectedEntryDataPtr == 0)
        return;

    scratch = (char *)MEMORY_AllocateMemory(
        Global_STR_ED2_C_1, 374, 1000, MEMF_PUBLIC | MEMF_CLEAR);

    SetRast(&WDISP_DisplayContextBase->rp2, 2L);

    if (ED2_SelectedFlagByteOffset > 48 || ED2_SelectedFlagByteOffset < 1)
        ED2_SelectedFlagByteOffset = 1;

    ED2_SelectedEntryTitlePtr =
        TEXTDISP_PrimaryTitlePtrTable[ED2_SelectedEntryIndex];

    WDISP_SPrintf(panelText, Global_STR_PI_CLU_POS1,
                                  (long)ED2_SelectedEntryIndex,
                                  (long)TEXTDISP_PrimaryGroupEntryCount);
    TLIBA3_DrawCenteredWrappedTextLines(
        &WDISP_DisplayContextBase->rp2, panelText, 90L);

    data = ED2_SelectedEntryDataPtr;

    namePtr = &data[1];
    if (namePtr == 0)
        namePtr = ED2_STR_NullFallbackChannel;

    if (ED2_SelectedEntryTitlePtr != 0)
        srcPtr = (char *)ED2_SelectedEntryTitlePtr;
    else
        srcPtr = ED2_STR_NullFallbackSource;

    callPtr = &data[19];
    if (callPtr == 0)
        callPtr = ED2_STR_NullFallbackCallLetters;

    WDISP_SPrintf(panelText, Global_STR_CHAN_SOURCE_CALLLTRS_1,
                                  namePtr, srcPtr, callPtr);
    TLIBA3_DrawCenteredWrappedTextLines(
        &WDISP_DisplayContextBase->rp2, panelText, 120L);

    titleText = DISKIO2_CopyAndSanitizeSlotString(
        scratch, ED2_SelectedEntryDataPtr, ED2_SelectedEntryTitlePtr,
        (long)ED2_SelectedFlagByteOffset);

    if (titleText != 0)
        TEXTDISP_FormatEntryTimeForIndex(
            timeText, (long)ED2_SelectedFlagByteOffset,
            ED2_SelectedEntryTitlePtr);
    else
        timeText[0] = 0;

    if (titleText == 0)
        titleText = ED2_STR_NullFallbackTitle;

    WDISP_SPrintf(panelText, Global_STR_TS_TITLE_TIME,
                                  (long)ED2_SelectedFlagByteOffset, titleText,
                                  timeText);
    TLIBA3_DrawCenteredWrappedTextLines(
        &WDISP_DisplayContextBase->rp2, panelText, 150L);

    panelText[0] = 0;

    if ((ED2_SelectedEntryTitlePtr->slotFlag[ED2_SelectedFlagByteOffset] & 1) != 0)
        STRING_AppendAtNull(panelText,
                                            ED2_STR_NONE_ProgramFlagSummary);
    if ((ED2_SelectedEntryTitlePtr->slotFlag[ED2_SelectedFlagByteOffset] & 2) != 0)
        STRING_AppendAtNull(panelText, ED2_STR_MOVIE);
    if ((ED2_SelectedEntryTitlePtr->slotFlag[ED2_SelectedFlagByteOffset] & 4) != 0)
        STRING_AppendAtNull(panelText, ED2_STR_ALTHILITEPROG);
    if ((ED2_SelectedEntryTitlePtr->slotFlag[ED2_SelectedFlagByteOffset] & 8) != 0)
        STRING_AppendAtNull(panelText, ED2_STR_TAGPROG);
    if ((ED2_SelectedEntryTitlePtr->slotFlag[ED2_SelectedFlagByteOffset] & 16) != 0)
        STRING_AppendAtNull(panelText, ED2_STR_SPORTSPROG);
    if ((ED2_SelectedEntryTitlePtr->slotFlag[ED2_SelectedFlagByteOffset] & 32) != 0)
        STRING_AppendAtNull(panelText, ED2_STR_DVIEW_USED);
    if ((ED2_SelectedEntryTitlePtr->slotFlag[ED2_SelectedFlagByteOffset] & 64) != 0)
        STRING_AppendAtNull(panelText, ED2_STR_REPEATPROG);
    if ((ED2_SelectedEntryTitlePtr->slotFlag[ED2_SelectedFlagByteOffset] & 128) != 0)
        STRING_AppendAtNull(panelText, ED2_STR_PREVDAYSDATA);

    TLIBA3_DrawCenteredWrappedTextLines(
        &WDISP_DisplayContextBase->rp2, panelText, 210L);

    MEMORY_DeallocateMemory(Global_STR_ED2_C_2, 427, scratch, 1000);
}
