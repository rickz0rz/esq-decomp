/* RESTORES: LADFUNC_DrawEntryLineWithAttrs
 * MODULE:   modules/groups/a/w/ladfunc_p1_p0.s
 * STATUS:   behavioural
 *
 * Draws one line of an entry, splitting it into RUNS OF CONSTANT ATTRIBUTE and
 * issuing one draw call per run. The column count is derived from the font at
 * run time rather than fixed.
 *
 * THE COLUMN COUNT IS 624 DIVIDED BY THE WIDTH OF A SPACE, capped at 40. So a
 * wide font gives fewer columns and the text is truncated to fit rather than
 * scaled. The 624 is a pixel width and the cap is the buffer the rest of the
 * subsystem assumes.
 *
 * THE ATTRIBUTE POINTER IS ADVANCED PAST THE MARKER, and the original does it
 * by writing back into its own argument slot at 20(A5). A local copy is used
 * below because C parameters are not shared with the caller -- and they are not
 * in the original either; the write is to the callee's copy.
 *
 * THE PAD ATTRIBUTE COMES FROM ONE PAST THE TEXT. When the line is shorter than
 * the column count and there was no leading marker, the attribute used for the
 * trailing spaces is `attr[textLen]` -- the attribute of the character that
 * would have followed. With a marker, it is the marker's own attribute
 * instead.
 *
 * THE CENTRING USES THE BITMAP, NOT THE RASTPORT. The horizontal centre comes
 * from `BytesPerRow * 8` -- written as a shift per AGENTS.md -- less the full
 * column width; the vertical from `Rows` less the total text height, plus one
 * row's worth per line. Both are clamped at zero AFTER the division, so a
 * font too large for the display draws from the top-left rather than off it.
 *
 * THE INDENT DIVISOR IS THE SAME THREE-WAY MARKER MAPPING as
 * ladfunc_reflow_entry_buffers.c: 24 gives 2 (centred), 26 gives 1 (right),
 * anything else 0 (left). The leading pad is drawn as its own run before the
 * text.
 *
 * THE RUN SCAN COMPARES EVERY CHARACTER'S ATTRIBUTE AGAINST THE RUN'S FIRST,
 * not against its predecessor, so a run ends at the first difference from the
 * start. Comparing pairwise would merge runs the original splits.
 *
 * 714 ref vs 764 got, 26 differing regions.
 *
 * WRITE memset, NOT A FILL LOOP -- worth 40 bytes and measured both ways. The
 * original fills with `SUBQ.L #1 / BCC` over a `MOVE.B (A0)+`. `memset(buf, 32,
 * n)` inlines to an equivalent byte loop at 764 bytes; an explicit
 * `for (k = 0; k < n; k++) buf[k] = 32;` gives 804, because 6.51 re-evaluates
 * the bound and indexes rather than walking a cursor. Same rule as the
 * ed_capture_key_sequence.c entry in AGENTS.md.
 *
 * THE LAST TWO DIVISIONS SHARE ONE CALL. The original calls MATH_DivS32 three
 * times in the indent block -- once for the fill count, once for the terminator
 * index, and once whose result feeds BOTH the x advance and the pad subtraction
 * through a stack slot. Writing that third one as a local is worth 4 bytes over
 * calling it twice.
 *
 * The space measurement, the 624 division with its 40 cap, the allocation and
 * matching free, the marker detection, the truncation, the pad attribute
 * selection, both centring computations with their post-division clamps, the
 * three-way indent divisor, all three DisplayTextPackedPens call sites with
 * their five arguments, the run scan and both x advances match in kind and
 * size.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ffd4 ... 2b40ffe2   LINK.W A5,#-44 / MOVE.L D0,-30(A5)
 *   got:     the pad and column counts kept in registers
 *   summary: the frame class. The original spills all nine of its longs and
 *            reloads them at each of the three draw sites; 6.51 keeps four
 *            live. Most of the 50 bytes, with the rest in the strength-reduced
 *            multiplies the original calls MATH_Mulu32 for.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>
#include "esq-graphics.h"

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L

extern long __asm NEWGRID_JMPTBL_MATH_DivS32(register __d0 long a,
                        register __d1 long b);
extern long __asm NEWGRID_JMPTBL_MATH_Mulu32(register __d0 long a,
                        register __d1 long b);
extern void *NEWGRID_JMPTBL_MEMORY_AllocateMemory(char *who, long line,
                                                  long size, long flags);
extern void  NEWGRID_JMPTBL_MEMORY_DeallocateMemory(char *who, long line,
                                                    void *p, long size);
extern void  LADFUNC_DisplayTextPackedPens(struct RastPort *rp, long x, long y,
                                           long pen, char *text);

extern long ED_TextLimit;
extern char Global_STR_SINGLE_SPACE_1[];
extern char Global_STR_LADFUNC_C_14[];
extern char Global_STR_LADFUNC_C_15[];

void LADFUNC_DrawEntryLineWithAttrs(struct RastPort *rp, long row, char *text,
                                    char *attrArg)
{
    char *buf;
    char *attr;
    char  mode;
    char  attrByte;
    long  charWidth;
    long  maxCols;
    long  textLen;
    long  pad;
    long  indent;
    long  segStart;
    long  segLen;
    long  x;
    long  y;
    long  k;

    attr = attrArg;
    mode = 0;

    charWidth = TextLength(rp, Global_STR_SINGLE_SPACE_1, 1L);

    maxCols = NEWGRID_JMPTBL_MATH_DivS32(624L, charWidth);
    if (maxCols > 40)
        maxCols = 40;

    buf = NEWGRID_JMPTBL_MEMORY_AllocateMemory(Global_STR_LADFUNC_C_14, 712L,
                                               maxCols + 1,
                                               MEMF_PUBLIC | MEMF_CLEAR);
    if (buf == 0)
        return;

    if (*text == 24 || *text == 25 || *text == 26) {
        mode     = *text;
        attrByte = *attr++;
        text++;
    }

    textLen = strlen(text);
    if (textLen > maxCols)
        textLen = maxCols;

    pad = maxCols - textLen;

    if (pad > 0 && mode == 0)
        attrByte = attr[textLen];

    x = ((long)(rp->BitMap->BytesPerRow << 3)
         - NEWGRID_JMPTBL_MATH_Mulu32(charWidth, maxCols)) / 2;

    y = ((long)rp->BitMap->Rows
         - NEWGRID_JMPTBL_MATH_Mulu32((long)rp->Font->tf_YSize, ED_TextLimit))
        / 2;

    y += NEWGRID_JMPTBL_MATH_Mulu32(row + 1, (long)rp->Font->tf_YSize);

    if (x < 0)
        x = 0;

    if (y < 0)
        y = 0;

    if (mode == 24)
        indent = 2;
    else if (mode == 26)
        indent = 1;
    else
        indent = 0;

    if (indent != 0 && pad != 0) {

        memset(buf, 32, NEWGRID_JMPTBL_MATH_DivS32(pad, indent));
        buf[NEWGRID_JMPTBL_MATH_DivS32(pad, indent)] = 0;

        LADFUNC_DisplayTextPackedPens(rp, x, y, (long)attrByte, buf);

        k = NEWGRID_JMPTBL_MATH_DivS32(pad, indent);
        x += NEWGRID_JMPTBL_MATH_Mulu32(k, charWidth);
        pad -= k;
    }

    for (segStart = 0; segStart < textLen; segStart += segLen) {

        segLen = 0;

        while (segStart + segLen < textLen
               && attr[segStart] == attr[segStart + segLen]) {
            buf[segLen] = text[segStart + segLen];
            segLen++;
        }

        buf[segLen] = 0;

        LADFUNC_DisplayTextPackedPens(rp, x, y, (long)attr[segStart], buf);

        x += NEWGRID_JMPTBL_MATH_Mulu32(charWidth, segLen);
    }

    if (pad != 0) {

        memset(buf, 32, pad);
        buf[pad] = 0;

        LADFUNC_DisplayTextPackedPens(rp, x, y, (long)attrByte, buf);
    }

    NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_15, 824L, buf,
                                           maxCols + 1);
}
