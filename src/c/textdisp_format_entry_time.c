/* RESTORES: TEXTDISP_FormatEntryTime
 * MODULE:   modules/groups/b/a/textdisp2.s
 * STATUS:   behavioural
 *
 * 412 bytes in the original, 392 emitted, 17 differing regions. Here SAS/C is
 * the MORE compact of the two: it needs no frame and reaches the entry fields
 * with indexed addressing where the original spills the title pointer to -4(A5).
 *
 * Reproduces: the primary/secondary table selection on TEXTDISP_ActiveGroupId,
 * the doubly-indexed entry lookup (table[matchIndex] then +row*4, reading the
 * title at +56 and the code byte at +498), the null/empty guard, the
 * "(hh:mm" shape test on title[0]=='(' and title[3]==':', the half-hour
 * rounding, the 48-slot wrap, the clock-format string copy and the two-digit
 * minute rewrite into out[3]/out[4].
 *
 * NOTE on the division helpers: the original calls MATH_DivS32 with the dividend
 * in D0 and divisor in D1, and it returns the quotient in D0 AND the remainder
 * in D1. The original exploits this -- it calls the helper once and uses both
 * results, and for one modulo it drops to an inline DIVS #30 / SWAP instead.
 * Written in C as separate / and % expressions, SAS/C emits its own helper calls
 * and does not share a single call between the two. That is the bulk of the
 * difference and is not something the source can express.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff0 48e70f30      LINK.W A5,#-16 / MOVEM.L D4-D7/A2-A3
 *   got:     594f 48e73736          SUBQ.W #4,A7 / MOVEM.L with a different mask
 *   summary: The A5-frame class. Since the only frame local is the spilled title
 *            pointer, SAS/C keeping it in a register removes the frame entirely
 *            and is why this restoration comes out SMALLER rather than larger.
 *
 * SASC-MISMATCH: divide-helper-result-sharing
 *   summary: See the note above -- the original shares one MATH_DivS32 call
 *            between a quotient and a remainder use, and uses an inline DIVS/SWAP
 *            for another modulo.
 *   scope:   every function doing both / and % on the same operands.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the cross-unit calls.
 */
#include <string.h>

extern long ESQDISP_ComputeScheduleOffsetForRow(long row, long code);
extern void CLEANUP_FormatClockFormatEntry(long offset, char *out);
extern short TEXTDISP_ActiveGroupId;
extern short TEXTDISP_CurrentMatchIndex;
extern char *TEXTDISP_PrimaryTitlePtrTable[];
extern char *TEXTDISP_SecondaryTitlePtrTable[];
extern unsigned char CLOCK_FormatVariantCode;
extern char **Global_REF_STR_CLOCK_FORMAT;

void TEXTDISP_FormatEntryTime(char *out, short row)
{
    char *title;
    register long offset;
    register long mins;
    register unsigned char code;
    char *entry;

    if (TEXTDISP_ActiveGroupId) {
        entry = TEXTDISP_PrimaryTitlePtrTable[TEXTDISP_CurrentMatchIndex];
        title = ((char **)(entry + 56))[row];
        code  = TEXTDISP_PrimaryTitlePtrTable[TEXTDISP_CurrentMatchIndex][498];
    } else {
        entry = TEXTDISP_SecondaryTitlePtrTable[TEXTDISP_CurrentMatchIndex];
        title = ((char **)(entry + 56))[row];
        code  = TEXTDISP_SecondaryTitlePtrTable[TEXTDISP_CurrentMatchIndex][498];
    }

    offset = ESQDISP_ComputeScheduleOffsetForRow((long)row, (long)code);

    if (title == 0 || *title == 0) {
        *out = 0;
        return;
    }

    if (*title == '(' && title[3] == ':') {
        mins = (title[4] - '0') * 10 + title[5] - '0';
        offset = offset + CLOCK_FormatVariantCode / 30;
        if ((mins - (mins / 30) * 30) < (CLOCK_FormatVariantCode - (CLOCK_FormatVariantCode / 30) * 30))
            offset++;
        mins = (mins - (mins / 30) * 30);
        if (offset > 48)
            offset -= 48;
        strcpy(out, Global_REF_STR_CLOCK_FORMAT[offset]);
        mins = (out[3] - '0') * 10 + mins;
        out[3] = mins / 10 + '0';
        out[4] = (mins - (mins / 10) * 10) + '0';
        return;
    }

    offset = offset + CLOCK_FormatVariantCode / 30;
    CLEANUP_FormatClockFormatEntry(offset, out);
}
