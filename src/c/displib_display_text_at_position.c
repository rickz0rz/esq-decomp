/* RESTORES: _DISPLIB_DisplayTextAtPosition
 * MODULE:   modules/groups/a/i/displib.s
 * STATUS:   behavioural
 *
 * Move the rastport's pen and draw a NUL-terminated string, doing nothing at all
 * if the pointer is null. The length is measured by the inlined scan loop
 * (TST.B (A0)+ / BNE, then SUBQ.L #1,A0 / SUBA.L A2,A0), which is exactly what
 * strlen() inlines to -- AGENTS.md, "strlen(s) / strcmp(a,b): both inline to the
 * original's scan loops; no library call is involved".
 *
 * The length goes to a stack local (MOVE.L A0,16(A7), the LINK.W A5,#-4 slot)
 * before the Text() call rather than straight into D0, so it is written here as
 * its own statement.
 *
 * LIBRARY BASE: esq-graphics-leaf.h, the NON-volatile base -- every call is a
 * library call. See esq-graphics-leaf.h; tools/a6_audit.py enforces it.
 *
 * 68 bytes against 78 -- UNDER, not over, and all ten bytes are the A5 frame
 * class. The strlen scan loop, the null test, Move and Text all reproduce
 * exactly.
 *
 * SASC-MISMATCH: a5-frame-pointer
 *   ref:     4e55fffc  LINK.W A5,#-4     ... 2f480010  MOVE.L A0,16(A7)
 *                                            202f0010  MOVE.L 16(A7),D0
 *            4e5d      UNLK A5
 *   got:     (no frame)                  ... 2a08      MOVE.L A0,D5
 *                                            2005      MOVE.L D5,D0
 *   summary: the original builds a frame for one local and spills the measured
 *            length into it; 6.51 needs no frame and keeps the length in D5.
 *            That is -8 on the prologue/epilogue and -2 on each of the two
 *            accesses. Writing the length as its own statement (which the
 *            original's spill says it was) does not force the frame -- SAS/C
 *            allocates a register for it regardless.
 *   tried:   nothing source-side. Taking the local's address would force a frame
 *            but is exactly the distortion the project forbids.
 *   scope:   whole-program -- 364 LINK.W A5 frames in the original, 0 MOVEM
 *            masks containing A5.
 *   retest:  a compiler that reserves A5 as the frame pointer.
 */

#include "esq-graphics-leaf.h"
#include <string.h>

void DISPLIB_DisplayTextAtPosition(struct RastPort *rp, long x, long y, char *s)
{
    long len;

    if (s) {
        Move(rp, x, y);
        len = strlen(s);
        Text(rp, s, len);
    }
}
