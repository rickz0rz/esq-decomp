/* RESTORES: LADFUNC_ReflowEntryBuffers
 * MODULE:   modules/groups/a/w/ladfunc_p1.s
 * STATUS:   behavioural
 *
 * The inverse of ladfunc_repack_entry_text_and_attr_buffers.c: takes the packed
 * marker-prefixed stream and expands it back into fixed 40-column rows, padding
 * each row according to the marker that introduced it. Same private-copy
 * technique, same in-place rewrite of both caller buffers.
 *
 * THE MARKER SETS THE ALIGNMENT DIVISOR, NOT THE PAD DIRECTLY:
 *
 *   24  divisor 2 -> half the slack goes in front  -> CENTRED
 *   26  divisor 1 -> all the slack goes in front   -> RIGHT-ALIGNED
 *   25  divisor 0 -> no leading pad                -> LEFT-ALIGNED
 *
 * so the three markers are one expression, not three cases. The remaining slack
 * always goes on the end, which is what makes every row exactly 40 columns.
 *
 * A CHARACTER THAT IS NOT A MARKER SETS THE MODE TO 25 WITHOUT CONSUMING
 * ITSELF. The original does `MOVE.L D4,D7` where D4 still holds the 25 from the
 * comparison just above -- a register reused as a constant. The loop then
 * re-reads the same character on the next pass and takes the body path. So an
 * unmarked line is left-aligned, and the character is not lost.
 *
 * THAT REUSE IS WHY THE ATTRIBUTE FETCH DIFFERS BETWEEN THE TWO ARMS. The
 * marker arm increments the cursor and then reads the attribute at the OLD
 * position; the default arm reads at the current one. Both take the attribute
 * belonging to the character that decided the mode.
 *
 * LINE BREAKS ARE SKIPPED, NOT HONOURED. Bytes 10 and 13 advance the cursor and
 * contribute nothing -- the row break comes from the 40-column limit or from
 * the next marker, never from a newline in the data.
 *
 * THE DIVISION IS RECOMPUTED INSIDE THE PAD LOOP. The original calls MATH_DivS32
 * on every iteration to get the bound, and again afterwards to subtract it.
 * Hoisting it into a variable is the obvious cleanup and would be two fewer
 * calls than the original makes, so the C keeps both calls where they are.
 *
 * THE ROW COUNT IS FIXED BY ED_TextLimit, not by the data: rows keep being
 * emitted after the source is exhausted, each one a full 40 columns of padding.
 * That is how the output reaches a constant size.
 *
 * 654 ref vs 660 got, 26 differing regions. Both allocations with their
 * distinct sizes and line numbers, both copies, the four-way scan loop with its
 * newline skip and its 40-column bound, the mode-25 fallthrough with its
 * register-reused constant, both attribute fetch positions, the three-way
 * divisor selection, the recomputed division in and after the pad loop, the
 * body copy, the trailing pad and both frees match in kind and size.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ff88 ... 2b40ff9c   LINK.W A5,#-120 / MOVE.L D0,-100(A5)
 *   got:     the cursor and line length kept in registers
 *   summary: the frame class, and small -- 6 bytes. Two 40-byte working buffers
 *            dominate the frame, so most accesses are displacements either way.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L

extern void *MEMORY_AllocateMemory(char *who, long line,
                                                  long size, long flags);
extern void  MEMORY_DeallocateMemory(char *who, long line,
                                                    void *p, long size);
extern long __asm MATH_DivS32(register __d0 long a,
                        register __d1 long b);

extern long ED_TextLimit;
extern char Global_STR_LADFUNC_C_20[];
extern char Global_STR_LADFUNC_C_21[];
extern char Global_STR_LADFUNC_C_22[];
extern char Global_STR_LADFUNC_C_23[];

void LADFUNC_ReflowEntryBuffers(char *text, char *attr)
{
    char *textCopy;
    char *attrCopy;
    char  line[41];
    char  attrLine[40];
    char  mode;
    char  attrByte;
    char  c;
    long  srcLen;
    long  srcPos;
    long  lineLen;
    long  outPos;
    long  indent;
    long  pad;
    long  n;
    long  k;
    long  row;

    srcLen = strlen(text);

    textCopy = MEMORY_AllocateMemory(Global_STR_LADFUNC_C_20,
                                                    1025L, srcLen + 1,
                                                    MEMF_PUBLIC | MEMF_CLEAR);

    attrCopy = MEMORY_AllocateMemory(Global_STR_LADFUNC_C_21,
                                                    1026L, srcLen,
                                                    MEMF_PUBLIC | MEMF_CLEAR);

    if (textCopy != 0 && attrCopy != 0) {

        strcpy(textCopy, text);
        memcpy(attrCopy, attr, srcLen);

        mode    = 0;
        row     = 0;
        srcPos  = 0;
        lineLen = 0;
        outPos  = 0;

        while (row < ED_TextLimit) {

            for (;;) {

                c = textCopy[srcPos];

                if (c == 0)
                    break;

                if (lineLen >= 40)
                    break;

                if (c == 10 || c == 13) {
                    srcPos++;
                    continue;
                }

                if (mode == 0) {

                    if (c == 24 || c == 25 || c == 26) {
                        mode = c;
                        srcPos++;
                        attrByte = attrCopy[srcPos - 1];
                        continue;
                    }

                    mode     = 25;
                    attrByte = attrCopy[srcPos];
                    continue;
                }

                if (c == 24 || c == 25 || c == 26)
                    break;

                line[lineLen]     = c;
                attrLine[lineLen] = attrCopy[srcPos];
                lineLen++;
                srcPos++;
            }

            line[lineLen] = 0;

            n   = strlen(line);
            pad = 40 - n;

            if (mode == 24)
                indent = 2;
            else if (mode == 26)
                indent = 1;
            else
                indent = 0;

            if (indent > 0 && pad > 0) {

                k = 0;
                while (k < MATH_DivS32(pad, indent)) {
                    text[outPos] = 32;
                    attr[outPos] = attrByte;
                    k++;
                    outPos++;
                }

                pad -= MATH_DivS32(pad, indent);
            }

            k = 0;
            while (line[k] != 0) {
                text[outPos] = line[k];
                attr[outPos] = attrLine[k];
                k++;
                outPos++;
            }

            if (pad > 0) {
                k = 0;
                while (k < pad) {
                    text[outPos] = 32;
                    attr[outPos] = attrByte;
                    k++;
                    outPos++;
                }
            }

            row++;
            lineLen = 0;
            mode    = 0;
        }

        text[outPos] = 0;
    }

    if (textCopy != 0)
        MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_22, 1146L,
                                               textCopy, srcLen + 1);

    if (attrCopy != 0)
        MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_23, 1148L,
                                               attrCopy, srcLen);
}
