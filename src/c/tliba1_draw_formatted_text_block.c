/* RESTORES: TLIBA1_DrawFormattedTextBlock
 * MODULE:   modules/groups/b/a/tliba1_p1.s
 * STATUS:   behavioural
 * OPTIONS:  SHORTINT (see src/c/scopts.txt)
 *
 * Lays out a run of markup text into a box and draws it centred, one segment
 * per line. It makes TWO passes over the text: the first only counts lines, so
 * that the segment table can be sized exactly; the second fills the table in
 * and REWRITES THE TEXT IN PLACE.
 *
 * THE SECOND PASS DESTROYS ITS INPUT. Every control byte it consumes is
 * overwritten with a NUL, which is what turns one string into a sequence of
 * per-segment strings that the draw loop can hand to TextLength. Byte 18
 * becomes a SPACE instead, and only when the font flag is clear. A caller that
 * needs its text afterwards must copy it first.
 *
 * The control bytes are 6 (font change), 18 (soft space), 24 (pen 1) and 25
 * (pen 3); 0 ends the pass. Any other byte just clears the run flag.
 *
 * THE RUN FLAG MAKES ADJACENT CONTROL BYTES COLLAPSE. When one control byte
 * immediately follows another, the handler DECREMENTS the row counter, rewrites
 * the row it just wrote, and increments again -- so a run of markup produces one
 * segment carrying the last pen rather than one segment each. That is also why
 * pass one counts a run as a single line.
 *
 * THE TWO FONT SOURCES ARE NOT INTERCHANGEABLE. Byte 6 advances the vertical
 * accumulator by the PREVUE font height with NO plus-one; bytes 24 and 25
 * advance it by the RASTPORT font height PLUS ONE. Both are in the original and
 * the asymmetry is what makes mixed-font blocks line up.
 *
 * The leading is `(boxHeight - accumulated) / segCount`, computed once, and
 * segCount starts at 2 rather than 0 -- so there is always a margin above and
 * below even when every segment is flush.
 *
 * The 8-pixel inset is added to the measured width only when the aligned-inset
 * gate is set AND the primary nibble is not 255. 255 is the "unset" value here,
 * and the compare is against a byte widened to a long.
 *
 * The centring divide rounds toward zero on a negative remainder, which matters
 * because the text can be wider than the box: the width is clamped to the box
 * first, so the difference is never negative in practice, but the original
 * emits the signed sequence and this reproduces it.
 *
 * WRITE THE INDEX AS `(char *)table + row * ten`, NOT `table[row]`, and this is
 * the finding worth carrying out of this file. The original scales its row
 * index with `MULS`, eight times. Written as an ordinary array subscript, 6.51
 * strength-reduces every one of them into shift-and-add pairs: ZERO MULS and
 * TWELVE ASL sequences, at 1216 bytes. Holding the stride in a local and
 * multiplying by it gives EIGHT MULS and two ASLs, at 1180 -- 36 bytes closer
 * and, more importantly, the original's instruction rather than an equivalent.
 *
 * This is the same lever as AGENTS.md's zero-local rule and the nonzero variant
 * in gcommand_parse_ppv_command.c: a literal lets 6.51 reason about the value,
 * a local holding the literal does not. It is the first case where it applies
 * to an ARRAY STRIDE, and it does NOT contradict the cast-and-add warning in
 * AGENTS.md, because the address is materialised once per case into `seg` and
 * the field stores still use `(d16,An)` displacements.
 *
 * SHORTINT is load-bearing. The dispatch is the chained-subtract shape --
 * `SUBQ.W #6` / `SUBI.W #12` / `SUBQ.W #6` / `SUBQ.W #1`, each consuming the
 * running difference -- and a plain `switch` gives that chain at LONG width
 * (`SUBQ.L`). Both together are worth 20 bytes and produce the original's
 * widths. Same rule as the three ED key handlers.
 *
 * 1126 ref vs 1180 got, 26 differing regions. Both passes, the run-flag
 * collapse, all five dispatch arms, the in-place NUL and space rewrites, both
 * font-height advances, the segment-table stores, the leading divide, the
 * TextLength measurement, the inset test, the clamp, the centring divide and
 * both restore calls match in kind and size.
 *
 * SASC-MISMATCH: strength-reduced-index-scaling
 *   ref:     c1fc000a          MULS #10,D0
 *   got:     e581 d280 ...     ASL.L #2 / ADD.L, twice, per remaining site
 *   summary: two sites still scale by shifting rather than multiplying -- the
 *            draw loop's two remaining subscripts. The variable stride above
 *            converts the other eight. docs/compiler-version.md records the
 *            mirror image of this for 32-bit constant multiply, where the
 *            ORIGINAL calls MATH_Mulu32 and 6.51 inlines.
 *   tried:   routing the last two through the stride local as well. They are
 *            already written that way; 6.51 folds these two back to shifts
 *            because the index is the loop variable and it can strength-reduce
 *            across the iteration. That is not reachable from the source.
 *   scope:   any indexed access whose element size is not a power of two.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>
#include "esq-graphics.h"

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L

struct TlibaSeg {                   /* 10 bytes per line */
    short pen;                      /* +0 */
    short offset;                   /* +2 into the caller's text */
    short useFont;                  /* +4 nonzero selects the Prevue font */
    short pad6;
    short spacing;                  /* +8 nonzero adds a line of leading */
};

extern void *MEMORY_AllocateMemory(char *who, long line, long size,
                                   long flags);
extern void  MEMORY_DeallocateMemory(char *who, long line, void *p, long size);
extern void  TLIBA1_DrawInlineStyledText(struct RastPort *rp, long x, long y,
                                         char *text);

extern struct TextFont *Global_HANDLE_PREVUE_FONT;
extern short TEXTDISP_LinePenOverrideEnabledFlag;
extern char  CLOCK_AlignedInsetRenderGateFlag;
extern unsigned char CLEANUP_AlignedInsetNibblePrimary;
extern char  Global_STR_TLIBA1_C_3[];
extern char  TLIBA1_STR_TLIBA1_DOT_C[];

void TLIBA1_DrawFormattedTextBlock(struct RastPort *rp, char *text, short x1,
                                   short y1, short x2, short y2)
{
    struct TlibaSeg *table;
    struct TlibaSeg *seg;
    struct TextFont *savedFont;
    char  *cursor;
    char  *p;
    char   savedPen;
    short  done;
    short  i;
    short  row;
    short  boxWidth;
    short  boxHeight;
    short  lineCount;
    short  textWidth;
    short  yAccum;
    short  segCount;
    short  lineSpacing;
    short  charPos;
    short  flagA;
    short  flagB;
    short  c;
    long   w;
    long   extra;
    long   dx;
    short  ten;

    ten = 10;
    boxWidth  = x2 - x1 + 1;
    boxHeight = y2 - y1 + 1;

    cursor      = text;
    row         = 0;
    yAccum      = 0;
    segCount    = 0;
    lineSpacing = 0;
    charPos     = 0;
    i           = 0;
    lineCount   = 0;
    textWidth   = 0;
    flagA       = 0;
    flagB       = 0;
    done        = 0;

    while (*cursor != 0) {
        c = (short)*cursor;
        if (c == 24 || c == 25 || c == 6) {
            if (flagA == 0) {
                lineCount++;
                flagA = 1;
            }
        } else {
            flagA = 0;
        }
        cursor++;
    }

    flagA = 0;

    if (lineCount == 0)
        return;

    table = MEMORY_AllocateMemory(Global_STR_TLIBA1_C_3, 2115L,
                                  (long)lineCount * 10,
                                  MEMF_PUBLIC | MEMF_CLEAR);
    if (table == 0)
        return;

    cursor   = text;
    segCount = 2;

    do {
        c = (short)*cursor;

        switch (c) {

        case 0:
            segCount++;
            done = 1;
            break;

        case 6:
            if (flagA != 0)
                row--;
            seg = (struct TlibaSeg *)((char *)table + row * ten);
            seg->useFont = 1;
            seg->pen     = 1;
            seg->offset  = charPos + 1;
            if (flagB != 0) {
                seg->spacing = 0;
            } else {
                seg->spacing = 1;
                segCount++;
            }
            row++;
            *cursor = 0;
            yAccum += Global_HANDLE_PREVUE_FONT->tf_YSize;
            flagA = 0;
            flagB = 1;
            break;

        case 18:
            if (flagB == 0)
                *cursor = 0x20;
            break;

        case 24:
            if (flagA != 0) {
                row--;
                seg = (struct TlibaSeg *)((char *)table + row * ten);
                seg->pen    = 1;
                seg->offset = charPos + 1;
                row++;
            } else {
                seg = (struct TlibaSeg *)((char *)table + row * ten);
                seg->useFont = 0;
                seg->pen     = 1;
                seg->offset  = charPos + 1;
                seg->spacing = 1;
                row++;
                *cursor = 0;
                yAccum += rp->Font->tf_YSize + 1;
                segCount++;
                flagB = 0;
                flagA = 1;
            }
            break;

        case 25:
            if (flagA != 0) {
                row--;
                seg = (struct TlibaSeg *)((char *)table + row * ten);
                seg->pen    = 3;
                seg->offset = charPos + 1;
                row++;
            } else {
                seg = (struct TlibaSeg *)((char *)table + row * ten);
                seg->useFont = 0;
                seg->pen     = 3;
                seg->offset  = charPos + 1;
                seg->spacing = 1;
                row++;
                *cursor = 0;
                yAccum += rp->Font->tf_YSize + 1;
                segCount++;
                flagA = 1;
                flagB = 0;
            }
            break;

        default:
            flagA = 0;
            break;
        }

        charPos++;
        cursor++;

    } while (done == 0);

    lineSpacing = (short)((long)(boxHeight - yAccum) / (long)segCount);

    savedPen  = rp->FgPen;
    savedFont = rp->Font;

    i      = 0;
    yAccum = lineSpacing;

    while (i < lineCount) {

        if (TEXTDISP_LinePenOverrideEnabledFlag != 0)
            SetAPen(rp, (long)((struct TlibaSeg *)((char *)table + i * ten))->pen);

        if (((struct TlibaSeg *)((char *)table + i * ten))->useFont != 0)
            SetFont(rp, Global_HANDLE_PREVUE_FONT);
        else
            SetFont(rp, savedFont);

        p = text + ((struct TlibaSeg *)((char *)table + i * ten))->offset;
        w = TextLength(rp, p, strlen(p));

        if (CLOCK_AlignedInsetRenderGateFlag != 0
            && (long)CLEANUP_AlignedInsetNibblePrimary != 255)
            extra = 8;
        else
            extra = 0;

        w += extra;
        textWidth = (short)w;
        if (w > boxWidth)
            textWidth = boxWidth;

        if (((struct TlibaSeg *)((char *)table + i * ten))->spacing != 0)
            yAccum += lineSpacing + 1;

        yAccum += rp->TxHeight;

        dx = (long)boxWidth - (long)textWidth;
        dx = dx / 2;

        TLIBA1_DrawInlineStyledText(rp, (long)x1 + dx, (long)y1 + (long)yAccum,
                                    text + ((struct TlibaSeg *)((char *)table + i * ten))->offset);
        i++;
    }

    SetAPen(rp, (long)savedPen);
    SetFont(rp, savedFont);

    if (table != 0)
        MEMORY_DeallocateMemory(TLIBA1_STR_TLIBA1_DOT_C, 2385L, table,
                                (long)lineCount * 10);
}
