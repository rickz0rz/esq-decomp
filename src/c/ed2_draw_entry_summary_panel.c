/* RESTORES: _ED2_DrawEntrySummaryPanel
 * MODULE:   modules/groups/a/k/ed2_ed2_drawentrysummarypanel.s
 * STATUS:   behavioural
 *
 * Draws the four-line entry-summary panel on the diagnostics screen, 734 bytes,
 * and the sibling of ed2_draw_entry_details_panel.c. Two formatted lines, then two
 * lines built by appending flag names.
 *
 * THE TWO FLAG LINES READ DIFFERENT WIDTHS. The first tests eight bits of the BYTE
 * at entry+27; the second tests five bits of the WORD at entry+46. Both are re-read
 * from the global before every single test -- thirteen reloads -- which is what the
 * original does and what this restoration reproduces. Hoisting either into a local
 * would be shorter and would not be the original.
 *
 * THE INDEX CLAMP AND THE POINTER SELECT ARE SEPARATE DECISIONS, and they test
 * different things: the index is reset when it is out of range, but the entry
 * pointer is cleared only when the entry COUNT is zero. So an in-range index with a
 * zero count clears both pointers, while an out-of-range index with a non-zero
 * count is reset to 0 and then used. Two ifs, not one.
 *
 * Selecting an entry also clears ED2_SelectedFlagByteOffset; clearing the pointers
 * does not. That asymmetry is in the original.
 *
 * MEASURED: 740 emitted against 734 in the original, +6 over 28 regions.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba....              JSR (d16,PC)
 *   got:     61000000              BSR.W
 *   summary: same size, different opcode; costs nothing.
 *   scope:   the whole cross-unit bucket.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: a5-frame-and-large-locals
 *   ref:     4e55ff88 ... 4e5d     LINK.W A5,#-120 / UNLK A5
 *   got:     A7-relative locals
 *   scope:   program-wide; docs/compiler-version.md.
 *   retest:  a compiler that reserves A5.
 *
 * SASC-MISMATCH: bit-test-width
 *   ref:     0800 000n              BTST #n,D0
 *   got:     a mask on the loaded value
 *   summary: thirteen single-bit tests, eight on a byte and five on a word.
 *            Written as `& (1 << n)`.
 *   scope:   anywhere a flag field is tested a bit at a time.
 *   retest:  a compiler that narrows a mask to BTST.
 *
 * SASC-MISMATCH: unattributed-body-delta
 *   summary: NOT itemised. Recorded as a known-unknown per AGENTS.md rule 3.
 *   retest:  itemise again on a compiler that reserves A5.
 */
#include <exec/types.h>
#include <graphics/gfx.h>
#include <graphics/rastport.h>
#include <graphics/gfxbase.h>

#include "esq-graphics.h"

struct DkEntrySummary {
    char           pad0;        /*  0 */
    char           channel[11]; /*  1 */
    char           source[7];   /* 12 */
    char           callSign[8]; /* 19 */
    unsigned char  byteFlags;   /* 27 */
    char           pad28[18];   /* 28 */
    unsigned short wordFlags;   /* 46 */
    char           pad48[4];    /* 48, to the 52-byte record */
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
extern struct DkEntrySummary *ED2_SelectedEntryDataPtr;
extern void *ED2_SelectedEntryTitlePtr;
extern short TEXTDISP_PrimaryGroupEntryCount;
extern struct DkEntrySummary *TEXTDISP_PrimaryEntryPtrTable[];
extern struct EsqDisplayContext *WDISP_DisplayContextBase;

extern char Global_STR_CLU_CLU_POS1[];
extern char Global_STR_CHAN_SOURCE_CALLLTRS_2[];
extern char ED2_STR_NONE_SourceFlagSummary[];
extern char ED2_STR_HILITESRC[];
extern char ED2_STR_SUMBYSRC[];
extern char ED2_STR_VIDEO_TAG_DISABLE[];
extern char ED2_STR_CAF_PPVSRC[];
extern char ED2_STR_DITTO[];
extern char ED2_STR_ALTHILITESRC[];
extern char ED2_STR_STEREO[];
extern char ED2_STR_GRID[];
extern char ED2_STR_MR[];
extern char ED2_STR_DNICHE[];
extern char ED2_STR_DMPLEX[];
extern char ED2_STR_CF2_DPPV[];

extern void WDISP_SPrintf();
extern void TLIBA3_DrawCenteredWrappedTextLines(void *rp,
                                                               char *text,
                                                               long y);
extern void STRING_AppendAtNull(char *dst, char *src);

void ED2_DrawEntrySummaryPanel(void)
{
    char panelText[120];

    if (ED2_SelectedEntryIndex >= TEXTDISP_PrimaryGroupEntryCount ||
        ED2_SelectedEntryIndex < 0)
        ED2_SelectedEntryIndex = 0;

    if (TEXTDISP_PrimaryGroupEntryCount == 0) {
        ED2_SelectedEntryDataPtr = 0;
        ED2_SelectedEntryTitlePtr = 0;
    } else {
        ED2_SelectedEntryDataPtr =
            TEXTDISP_PrimaryEntryPtrTable[ED2_SelectedEntryIndex];
        ED2_SelectedFlagByteOffset = 0;
    }

    if (ED2_SelectedEntryDataPtr == 0)
        return;

    SetRast(&WDISP_DisplayContextBase->rp2, 2L);

    WDISP_SPrintf(panelText, Global_STR_CLU_CLU_POS1,
                                  (long)ED2_SelectedEntryIndex,
                                  (long)TEXTDISP_PrimaryGroupEntryCount);
    TLIBA3_DrawCenteredWrappedTextLines(
        &WDISP_DisplayContextBase->rp2, panelText, 120L);

    WDISP_SPrintf(panelText, Global_STR_CHAN_SOURCE_CALLLTRS_2,
                                  ED2_SelectedEntryDataPtr->channel,
                                  ED2_SelectedEntryDataPtr->source,
                                  ED2_SelectedEntryDataPtr->callSign);
    TLIBA3_DrawCenteredWrappedTextLines(
        &WDISP_DisplayContextBase->rp2, panelText, 150L);

    panelText[0] = 0;

    if ((ED2_SelectedEntryDataPtr->byteFlags & 1) != 0)
        STRING_AppendAtNull(panelText,
                                            ED2_STR_NONE_SourceFlagSummary);
    if ((ED2_SelectedEntryDataPtr->byteFlags & 2) != 0)
        STRING_AppendAtNull(panelText, ED2_STR_HILITESRC);
    if ((ED2_SelectedEntryDataPtr->byteFlags & 4) != 0)
        STRING_AppendAtNull(panelText, ED2_STR_SUMBYSRC);
    if ((ED2_SelectedEntryDataPtr->byteFlags & 8) != 0)
        STRING_AppendAtNull(panelText,
                                            ED2_STR_VIDEO_TAG_DISABLE);
    if ((ED2_SelectedEntryDataPtr->byteFlags & 16) != 0)
        STRING_AppendAtNull(panelText, ED2_STR_CAF_PPVSRC);
    if ((ED2_SelectedEntryDataPtr->byteFlags & 32) != 0)
        STRING_AppendAtNull(panelText, ED2_STR_DITTO);
    if ((ED2_SelectedEntryDataPtr->byteFlags & 64) != 0)
        STRING_AppendAtNull(panelText, ED2_STR_ALTHILITESRC);
    if ((ED2_SelectedEntryDataPtr->byteFlags & 128) != 0)
        STRING_AppendAtNull(panelText, ED2_STR_STEREO);

    TLIBA3_DrawCenteredWrappedTextLines(
        &WDISP_DisplayContextBase->rp2, panelText, 180L);

    panelText[0] = 0;

    if ((ED2_SelectedEntryDataPtr->wordFlags & 1) != 0)
        STRING_AppendAtNull(panelText, ED2_STR_GRID);
    if ((ED2_SelectedEntryDataPtr->wordFlags & 2) != 0)
        STRING_AppendAtNull(panelText, ED2_STR_MR);
    if ((ED2_SelectedEntryDataPtr->wordFlags & 4) != 0)
        STRING_AppendAtNull(panelText, ED2_STR_DNICHE);
    if ((ED2_SelectedEntryDataPtr->wordFlags & 8) != 0)
        STRING_AppendAtNull(panelText, ED2_STR_DMPLEX);
    if ((ED2_SelectedEntryDataPtr->wordFlags & 16) != 0)
        STRING_AppendAtNull(panelText, ED2_STR_CF2_DPPV);

    TLIBA3_DrawCenteredWrappedTextLines(
        &WDISP_DisplayContextBase->rp2, panelText, 210L);
}
