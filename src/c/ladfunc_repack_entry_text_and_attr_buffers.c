/* RESTORES: LADFUNC_RepackEntryTextAndAttrBuffers
 * MODULE:   modules/groups/a/w/ladfunc_p1.s
 * STATUS:   behavioural
 *
 * Converts a fixed-pitch 40-column entry -- text in one buffer, per-character
 * attributes in a parallel one -- into a packed stream where each line is
 * preceded by a marker byte and trailing blanks are trimmed. It rewrites BOTH
 * caller buffers in place, reading them from private copies it allocates first.
 *
 * THE COPIES ARE WHY IT WORKS. Output overwrites the input from index 0 while
 * the loop is still reading line i, so without the copies the function would
 * consume its own output. The two allocations are the only reason the in-place
 * rewrite is safe, and a failure of either skips the whole conversion -- the
 * buffers are left untouched rather than half-converted.
 *
 * THE TWO ALLOCATIONS ARE DIFFERENT SIZES: the text copy gets strlen+1, the
 * attribute copy gets strlen. The attributes have no terminator, so the shorter
 * size is correct, and both frees pass the size they allocated.
 *
 * THE MARKER ENCODES WHICH EDGES ARE BLANK, and it is chosen before any
 * trimming:
 *
 *   25  the line starts with a non-blank    -> trim the RIGHT edge only
 *   26  it starts blank but ends non-blank  -> trim the LEFT edge only
 *   24  both edges are blank                -> trim BOTH, symmetrically
 *
 * A blank for this purpose means a space AND a matching attribute byte. A run
 * of spaces whose attributes differ is not trimmed, which is what stops a
 * colour change at the margin being lost.
 *
 * THE SYMMETRIC CASE IS BOUNDED AT 20, NOT 40 -- it trims at most half the line
 * from each side, so the two scans cannot cross. The one-sided cases are
 * bounded at 40. That difference is in the original and is easy to normalise
 * away by accident.
 *
 * THE ATTRIBUTE PAD USES THE LAST REAL ATTRIBUTE, not a constant: when the line
 * is shorter than 40 the text is padded with spaces and the attributes are
 * padded by REPEATING `attrLine[len - 1]`. On a zero-length line that indexes
 * element -1. The original does the same -- it reads the byte at -92(A5) with
 * the length as displacement, which is one before the array -- so the C keeps
 * it rather than adding a guard.
 *
 * THE MARKER AND THE FILL BYTE ARE WRITTEN AT THE SAME OUTPUT INDEX, one into
 * each buffer, before the increment. So the attribute stream gets the trim
 * fill where the text stream gets the marker; they stay in step.
 *
 * MEM_Move TAKES (source, destination, count) here -- the original pushes the
 * moved-from pointer last, so it is the first argument. Reading it as
 * (dst, src) reverses every trim.
 *
 * A _Return LABEL MEANS THE REFERENCE STOPS EARLY. The epilogue is branched to
 * from the allocation-failure path, so 8 bytes of MOVEM/UNLK/RTS sit outside
 * the reference; corrected, it is 796.
 *
 * 788 ref vs 800 got, 26 differing regions -- 4 bytes over the corrected 796.
 * Both allocations with their distinct sizes and line numbers, the two copies,
 * the 40-column extract with its explicit terminator, both pad loops including
 * the index -1 read, the three-way marker choice, all three trim scans with
 * their differing bounds and their attribute-equality tests, all four MEM_Move
 * calls with their 40-2j and 40-j counts, the marker-and-fill store pair, the
 * packed copy loop and both frees match in kind and size.
 *
 * SHORTINT WAS MEASURED AND REJECTED: 812 bytes against 800, with the same
 * region count. The three-way marker test looks like the chained-subtract
 * dispatch that wants it -- `SUBI.W #24` / `SUBQ.W #1` / `SUBQ.W #1` -- but the
 * loop counters here are longs in the original, and narrowing them costs more
 * than the dispatch saves. Third counter-example in this set.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ff94 ... 2b40ff9c   LINK.W A5,#-108 / MOVE.L D0,-100(A5)
 *   got:     the scan index kept in a register
 *   summary: the frame class, and small here -- 4 bytes over the corrected
 *            reference, because both compilers must spill the two 40-byte
 *            working buffers and most of the body addresses them by
 *            displacement either way.
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
extern void  STRING_CopyPadNul(char *dst, char *src, long n);
extern void  MEM_Move(char *src, char *dst, long n);

extern long ED_TextLimit;
extern char Global_STR_LADFUNC_C_24[];
extern char Global_STR_LADFUNC_C_25[];
extern char Global_STR_LADFUNC_C_26[];
extern char Global_STR_LADFUNC_C_27[];

void LADFUNC_RepackEntryTextAndAttrBuffers(char *text, char *attr)
{
    char *textCopy;
    char *attrCopy;
    char  line[41];
    char  attrLine[40];
    char  marker;
    char  fill;
    long  srcLen;
    long  outPos;
    long  len;
    long  i;
    long  j;
    long  k;

    srcLen = strlen(text);

    textCopy = MEMORY_AllocateMemory(Global_STR_LADFUNC_C_24,
                                                    1214L, srcLen + 1,
                                                    MEMF_PUBLIC | MEMF_CLEAR);

    attrCopy = MEMORY_AllocateMemory(Global_STR_LADFUNC_C_25,
                                                    1215L, srcLen,
                                                    MEMF_PUBLIC | MEMF_CLEAR);

    if (textCopy != 0 && attrCopy != 0) {

        strcpy(textCopy, text);
        memcpy(attrCopy, attr, srcLen);

        outPos = 0;

        for (i = 0; i < ED_TextLimit; i++) {

            STRING_CopyPadNul(line, textCopy + i * 40, 40L);
            line[40] = 0;

            len = strlen(line);

            memcpy(attrLine, attrCopy + i * 40, len);

            if (len < 40) {

                for (k = len; k < 40; k++)
                    line[k] = 32;

                fill = attrLine[len - 1];
                for (k = len; k < 40; k++)
                    attrLine[k] = fill;
            }

            if (line[0] != 32)
                marker = 25;
            else if (line[39] != 32)
                marker = 26;
            else
                marker = 24;

            switch ((short)marker) {

            case 24:
                fill = attrLine[0];
                j    = 0;
                while (j < 20 && line[j] == 32 && line[39 - j] == 32
                       && attrLine[j] == fill && attrLine[39 - j] == fill)
                    j++;

                if (j > 0) {
                    line[40 - j] = 0;
                    MEM_Move(line + j, line, 40 - j - j + 1);
                    MEM_Move(attrLine + j, attrLine,
                                             40 - j - j);
                }
                break;

            case 25:
                fill = attrLine[39];
                j    = 0;
                while (j < 40 && line[39 - j] == 32
                       && attrLine[39 - j] == fill)
                    j++;

                if (j > 0)
                    line[40 - j] = 0;
                break;

            case 26:
                fill = attrLine[0];
                j    = 0;
                while (j < 40 && line[j] == 32 && attrLine[j] == fill)
                    j++;

                if (j > 0) {
                    MEM_Move(line + j, line, 40 - j + 1);
                    MEM_Move(attrLine + j, attrLine, 40 - j);
                }
                break;
            }

            text[outPos] = marker;
            attr[outPos] = fill;
            outPos++;

            for (j = 0; line[j] != 0; j++) {
                text[outPos] = line[j];
                attr[outPos] = attrLine[j];
                outPos++;
            }
        }

        text[outPos] = 0;
    }

    if (textCopy != 0)
        MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_26, 1322L,
                                               textCopy, srcLen + 1);

    if (attrCopy != 0)
        MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_27, 1324L,
                                               attrCopy, srcLen);
}
