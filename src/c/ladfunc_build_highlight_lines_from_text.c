/* RESTORES: LADFUNC_BuildHighlightLinesFromText
 * MODULE:   modules/groups/a/w/ladfunc.s
 * STATUS:   behavioural
 *
 * 454 bytes in the original, 428 emitted, 15 differing regions.
 *
 * Reproduces: the leading control-code-4 slot write and its wrapping index
 * increment, the leading alignment byte consumed only when it is one of 24/25/26,
 * the character loop skipping CR and LF, the flush condition (width exhausted OR
 * a new alignment control code), the segment flush that NUL-terminates, applies
 * inline alignment padding, copies into the slot's text buffer, clears the
 * control code and advances the wrapping slot index, the per-character width
 * decrement measured by TextLength on a single character held in a stack byte,
 * and the identical final flush after the loop.
 *
 * The two 20-slot wrap checks use BCS (unsigned lower) rather than BLT, which is
 * what an unsigned short index produces; declaring the index unsigned is
 * load-bearing here.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffa4                   LINK.W A5,#-92
 *   got:     9efc005c                   SUBA.W #92,A7
 *   summary: The A5-frame class. The 90-byte segment buffer and the single
 *            character byte both move to A7-relative addressing.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the cross-unit calls.
 */
#include "esq-graphics.h"
#include <string.h>

extern void DISPLIB_ApplyInlineAlignmentPadding(char *seg, long align);
extern struct RastPort *Global_REF_RASTPORT_1;
extern unsigned short LADFUNC_LineSlotWriteIndex;
extern unsigned short LADFUNC_LineControlCodeTable[];
extern char *LADFUNC_LineTextBufferPtrs[];

void LADFUNC_BuildHighlightLinesFromText(char *text)
{
    char seg[90];
    char curChar;
    register long remaining;
    register long segLen;
    register char align;
    char c;

    LADFUNC_LineControlCodeTable[LADFUNC_LineSlotWriteIndex] = 4;
    LADFUNC_LineSlotWriteIndex++;
    if (LADFUNC_LineSlotWriteIndex >= 20)
        LADFUNC_LineSlotWriteIndex = 0;

    segLen = 0;
    remaining = 624;
    align = *text;
    if (align == 24 || align == 25 || align == 26)
        text++;

    for (;;) {
        c = *text++;
        curChar = c;
        if (c == 0)
            break;
        if (c == 13)
            continue;
        if (c == 10)
            continue;

        if (remaining > 0 && c != 24 && c != 25 && c != 26) {
            seg[segLen++] = c;
            remaining -= TextLength(Global_REF_RASTPORT_1, &curChar, 1L);
            continue;
        }

        seg[segLen] = 0;
        DISPLIB_ApplyInlineAlignmentPadding(seg, (long)align);
        strcpy(LADFUNC_LineTextBufferPtrs[LADFUNC_LineSlotWriteIndex], seg);
        LADFUNC_LineControlCodeTable[LADFUNC_LineSlotWriteIndex] = 0;
        LADFUNC_LineSlotWriteIndex++;
        if (LADFUNC_LineSlotWriteIndex >= 20)
            LADFUNC_LineSlotWriteIndex = 0;
        segLen = 0;
        remaining = 624;
        align = curChar;
    }

    seg[segLen] = 0;
    DISPLIB_ApplyInlineAlignmentPadding(seg, (long)align);
    strcpy(LADFUNC_LineTextBufferPtrs[LADFUNC_LineSlotWriteIndex], seg);
    LADFUNC_LineControlCodeTable[LADFUNC_LineSlotWriteIndex] = 0;
    LADFUNC_LineSlotWriteIndex++;
    if (LADFUNC_LineSlotWriteIndex >= 20)
        LADFUNC_LineSlotWriteIndex = 0;
}
