/* RESTORES: ESQSHARED_CompressClosedCaptionedTag
 * MODULE:   modules/groups/a/p/esqshared_p2.s
 * STATUS:   behavioural
 *
 * Finds "CLOSED CAPTIONED" in a title, writes a single '|' (0x7c) over the
 * first character, and slides the rest of the string down over the remaining
 * three characters of the match. The net effect is that the tag collapses to
 * one character.
 *
 * The move is a CopyMem of strlen(src) + 1 bytes, so the terminator travels
 * with it. Source and destination overlap and the original does not care: it
 * copies FORWARD over a region that moves left, which is safe in that
 * direction.
 *
 * The three-character skip is a literal LEA 3(A0),A1 in the original, not a
 * strlen of the tag.
 *
 * 84 ref vs 68 got. The restoration is SMALLER, and every one of the 16 bytes
 * is the frame class -- there is no missing work.
 *
 * The inline strlen matches the original's scan instruction for instruction
 * (TST.B (An)+ / BNE / SUBQ / SUBA / ADDQ), one address register apart.
 *
 * SASC-MISMATCH: link-frame-spill-vs-register
 *   ref:     4e55fffc ... 2b40fffc ... 2b48fffc 2049 226dfffc ... 4e5d
 *            LINK.W A5,#-4 / MOVE.L D0,-4(A5) / MOVE.L A0,-4(A5) /
 *            MOVEA.L -4(A5),A1 / UNLK
 *   got:     2640 ... 224b            MOVEA.L D0,A3 / MOVEA.L A3,A1
 *   summary: the original keeps the match pointer in a STACK SLOT and writes it
 *            back twice, reloading it for the CopyMem argument. 6.51 keeps the
 *            same value in an address register throughout, so the frame, the
 *            two stores and the reload all disappear. Same pointer, same two
 *            CopyMem arguments. This is the local-variable side of the reserved
 *            A5 property: a compiler with a frame has somewhere to spill, and
 *            it uses it.
 *   tried:   nothing from the source side. Forcing the spill would mean writing
 *            C designed to defeat the register allocator, which is a distortion
 *            the ESQ_EXACT arm exists for and is not justified here -- the
 *            function is cross-unit and so capped at behavioural anyway.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-exec.h"
#include <string.h>

extern char *GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(char *hay, char *needle);
extern char  Global_STR_CLOSED_CAPTIONED[];

void ESQSHARED_CompressClosedCaptionedTag(char *s)
{
    char *p;

    p = GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(s, Global_STR_CLOSED_CAPTIONED);
    if (p != 0) {
        *p++ = '|';
        CopyMem(p + 3, p, (long)strlen(p + 3) + 1);
    }
}
