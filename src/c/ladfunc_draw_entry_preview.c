/* RESTORES: LADFUNC_DrawEntryPreview
 * MODULE:   modules/groups/a/w/ladfunc_p1.s
 * STATUS:   behavioural
 *
 * Renders a full-screen preview of one entry: builds a display context, sets
 * the palette from the entry's own pen, and draws the text line by line through
 * ladfunc_draw_entry_line_with_attrs.c.
 *
 * IT SPLITS LINES ON THE ALIGNMENT MARKERS, not on newlines. Bytes 24, 25 and
 * 26 end the current line and begin the next; 10 and 13 are SKIPPED entirely.
 * So a text with CRLFs and no markers renders as one very long line, truncated
 * at the column count.
 *
 * A LINE THAT DOES NOT START WITH A MARKER GETS ONE INSERTED. When the column
 * cursor is at zero and the character is not a marker, a 25 -- left-align -- is
 * written into the buffer and the source position is NOT advanced, so the same
 * character is reconsidered on the next pass with the cursor at one. That is
 * how the downstream drawer always sees a marker in the first byte.
 *
 * THE 25 COMES FROM A REGISTER, NOT A LITERAL. The original stores D3, which
 * still holds the 25 from the comparison immediately above it. Same reuse as in
 * ladfunc_reflow_entry_buffers.c.
 *
 * THE ROW LOOP IS BOUNDED BY ED_TextLimit AND NOTHING ELSE. When the text runs
 * out, the remaining rows still call the line drawer with an empty buffer,
 * which is what clears the rest of the screen.
 *
 * THE PALETTE IS SET IN TWO STAGES: all 24 red components are copied from the
 * custom table, and then entry 0's red, green and blue are overwritten from the
 * pen's own triple. The pen index is scaled by three -- written as
 * `(pen << 2) - pen` per AGENTS.md -- because the custom tables are triples.
 *
 * Only the RED base gets the bulk copy; green and blue get one byte each. That
 * asymmetry is in the original and looks like a bug, but it is what ships.
 *
 * THE FONT IS SWAPPED AND SWAPPED BACK, and the restore runs even when the
 * allocations failed -- it is outside the guarded block, alongside the two
 * frees. So a failed allocation still leaves the rastport with the PREVUEC font
 * rather than the H26F one it was given on entry.
 *
 * The two buffers have DIFFERENT sizes -- the line buffer gets one extra byte
 * for the terminator, the attribute buffer does not -- and both frees pass the
 * size their allocation used.
 *
 * 726 ref vs 720 got, 26 differing regions. The context build, both font
 * changes, the space measurement, the 624 division, both allocations with their
 * distinct sizes and line numbers, the double table read, the copper drop and
 * rise, the 24-entry palette copy, the pen scaling and its three overwrites,
 * the SetRast, the marker-based line split with its skipped newlines, the
 * inserted 25 with its non-advancing source cursor, the per-row draw call and
 * both frees match in kind and size.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ffd8 ... 2b40ffe0   LINK.W A5,#-40 / MOVE.L D0,-32(A5)
 *   got:     the source position and column kept in registers
 *   summary: the frame class. The original spills both cursors and reloads them
 *            at every test in the character loop; 6.51 keeps them live, which
 *            is the 6 bytes this comes in under.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>
#include "esq-graphics.h"

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L

struct LadEntry {
    char  pad0[6];
    char *text;                         /* +6  */
    char *attr;                         /* +10 */
};

struct LadCtx {
    char            pad0[10];
    struct RastPort rp;                 /* +10 */
};

extern struct LadCtx *TLIBA3_BuildDisplayContextForViewMode(
                          long mode, long zero, long arg);
extern long __asm MATH_DivS32(register __d0 long a,
                        register __d1 long b);
extern void *MEMORY_AllocateMemory(char *who, long line,
                                                  long size, long flags);
extern void  MEMORY_DeallocateMemory(char *who, long line,
                                                    void *p, long size);
extern void  ESQ_SetCopperEffect_OffDisableHighlight(void);
extern void  ESQIFF_RunCopperDropTransition(void);
extern void  ESQIFF_RunCopperRiseTransition(void);
extern unsigned char LADFUNC_GetPackedPenHighNibble(long packed);
extern void  LADFUNC_DrawEntryLineWithAttrs(struct RastPort *rp, long row,
                                            char *text, char *attr);

extern struct LadEntry *LADFUNC_EntryPtrTable[];
extern struct LadCtx   *WDISP_DisplayContextBase;
extern struct TextFont *Global_HANDLE_H26F_FONT;
extern struct TextFont *Global_HANDLE_PREVUEC_FONT;

extern short WDISP_AccumulatorFlushPending;
extern long  ED_TextLimit;
extern unsigned char WDISP_PaletteTriplesRBase[];
extern unsigned char WDISP_PaletteTriplesGBase[];
extern unsigned char WDISP_PaletteTriplesBBase[];
extern unsigned char KYBD_CustomPaletteTriplesRBase[];
extern unsigned char KYBD_CustomPaletteTriplesGBase[];
extern unsigned char KYBD_CustomPaletteTriplesBBase[];
extern char Global_STR_SINGLE_SPACE_2[];
extern char Global_STR_LADFUNC_C_16[];
extern char Global_STR_LADFUNC_C_17[];
extern char Global_STR_LADFUNC_C_18[];
extern char Global_STR_LADFUNC_C_19[];

void LADFUNC_DrawEntryPreview(long index)
{
    char *lineBuf;
    char *attrBuf;
    char *text;
    char *attrSrc;
    long  maxCols;
    long  textLen;
    long  srcPos;
    long  col;
    long  row;
    long  off;
    long  i;
    long  w;
    unsigned char pen;
    char  c;

    WDISP_DisplayContextBase =
        TLIBA3_BuildDisplayContextForViewMode(4L, 0L, 3L);

    SetFont(&WDISP_DisplayContextBase->rp, Global_HANDLE_H26F_FONT);

    w = TextLength(&WDISP_DisplayContextBase->rp, Global_STR_SINGLE_SPACE_2,
                   1L);

    maxCols = MATH_DivS32(624L, w);

    lineBuf = MEMORY_AllocateMemory(Global_STR_LADFUNC_C_16,
                                                   857L, maxCols + 1,
                                                   MEMF_PUBLIC | MEMF_CLEAR);

    attrBuf = MEMORY_AllocateMemory(Global_STR_LADFUNC_C_17,
                                                   858L, maxCols,
                                                   MEMF_PUBLIC | MEMF_CLEAR);

    if (lineBuf != 0 && attrBuf != 0) {

        text    = LADFUNC_EntryPtrTable[index]->text;
        attrSrc = LADFUNC_EntryPtrTable[index]->attr;

        WDISP_AccumulatorFlushPending = 0;

        ESQ_SetCopperEffect_OffDisableHighlight();

        SetDrMd(&WDISP_DisplayContextBase->rp, 1L);

        ESQIFF_RunCopperDropTransition();

        for (i = 0; i < 24; i++)
            WDISP_PaletteTriplesRBase[i] = KYBD_CustomPaletteTriplesRBase[i];

        textLen = strlen(text);

        pen = LADFUNC_GetPackedPenHighNibble((long)(unsigned char)*attrSrc);

        off = ((long)pen << 2) - (long)pen;

        WDISP_PaletteTriplesRBase[0] = KYBD_CustomPaletteTriplesRBase[off];
        WDISP_PaletteTriplesGBase[0] = KYBD_CustomPaletteTriplesGBase[off];
        WDISP_PaletteTriplesBBase[0] = KYBD_CustomPaletteTriplesBBase[off];

        SetRast(&WDISP_DisplayContextBase->rp, (long)pen);

        row    = 0;
        srcPos = 0;
        col    = 0;

        while (row < ED_TextLimit) {

            for (;;) {

                if (srcPos >= textLen)
                    break;

                if (col >= maxCols)
                    break;

                c = text[srcPos];

                if (c == 10 || c == 13) {
                    srcPos++;
                    continue;
                }

                if (col == 0 && c != 24 && c != 25 && c != 26) {
                    lineBuf[col] = 25;
                    attrBuf[col] = attrSrc[srcPos];
                    col++;
                    continue;
                }

                if (col > 0 && (c == 24 || c == 25 || c == 26))
                    break;

                attrBuf[col] = attrSrc[srcPos];
                lineBuf[col] = c;
                col++;
                srcPos++;
            }

            lineBuf[col] = 0;

            LADFUNC_DrawEntryLineWithAttrs(&WDISP_DisplayContextBase->rp, row,
                                           lineBuf, attrBuf);
            row++;
            col = 0;
        }

        ESQIFF_RunCopperRiseTransition();
    }

    SetFont(&WDISP_DisplayContextBase->rp, Global_HANDLE_PREVUEC_FONT);

    if (lineBuf != 0)
        MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_18, 926L,
                                               lineBuf, maxCols + 1);

    if (attrBuf != 0)
        MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_19, 928L,
                                               attrBuf, maxCols);
}
