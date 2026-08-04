/* RESTORES: DISKIO_WriteDecimalField
 * MODULE:   modules/groups/a/g/diskio_p1.s
 * STATUS:   behavioural
 *
 * Formats one long as decimal into a stack buffer and writes it, terminator
 * included, through the buffered writer.
 *
 * Two details are taken straight from the listing rather than guessed:
 *
 *  - The length passed on is strlen(buf) + 1, so the NUL goes to the file.
 *    The original computes it with the inline scan strlen inlines to
 *    (A1 = A0 / TST.B (A1)+ / SUBQ / SUBA.L A0,A1), then ADDQ.L #1,D0.
 *  - The original does NOT clean the stack after the SPrintf call. It writes
 *    the length over the top argument slot (MOVE.L D0,(A7)) and pushes two
 *    more, reusing SPrintf's argument area for WriteBufferedBytes. That is
 *    SAS/C's own argument-area reuse and needs nothing from the source.
 *
 * 70 ref vs 76 got, and the inline strlen matches the original VERBATIM
 * (22484a1966fc538993c8200952802e802f082f07, twenty bytes). The whole delta is
 * the frame class below.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55fff4 ... 2e2d0008 2c2d000c ... 4ced00c0ffec 4e5d
 *            LINK.W A5,#-12 / args at 8(A5),12(A5) / MOVEM from -20(A5) / UNLK
 *   got:     9efc000c ... 2c2f001c 2e2f0018 ... 4fef0014 4cdf00c0 defc000c
 *            SUBA.W #12,A7 / args at 28(A7),24(A7) / LEA 20(A7),A7 / ADDA.W
 *   summary: the original builds an A5 frame, so it can leave the SPrintf
 *            argument area on the stack and drop the whole thing with UNLK.
 *            6.51 keeps no frame pointer, so it pops the arguments explicitly
 *            (LEA 20(A7),A7) and then undoes its own SUBA. Same semantics; the
 *            explicit cleanup is what costs the 6 bytes.
 *   tried:   nothing from the source side, and the option list rules the switch
 *            out rather than leaving it open -- the full sc option set was
 *            extracted (strings sc | grep -E '^[A-Z][A-Za-z]{3,24}$') and it
 *            contains no frame-pointer control of any kind.
 *   scope:   program-wide, and the same root cause as the A3/A5 class: the
 *            original reserves A5 for a frame, so it always has one to spill
 *            into. docs/compiler-version.md, "The A3/A5 divergence has a single
 *            root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-dos.h"
#include <string.h>

extern void WDISP_SPrintf(char *dst, char *fmt, long a);
extern long DISKIO_WriteBufferedBytes(BPTR fh, char *src, long len);
extern char Global_STR_PERCENT_LD[];

void DISKIO_WriteDecimalField(BPTR fh, long value)
{
    char buf[10];

    WDISP_SPrintf(buf, Global_STR_PERCENT_LD, value);
    DISKIO_WriteBufferedBytes(fh, buf, (long)strlen(buf) + 1);
}
