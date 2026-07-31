/* RESTORES: DISPTEXT_LayoutSourceToLines
 * MODULE:   modules/groups/a/i/disptext_p2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: word-index-zero-extension
 *   ref:     4e55feec48e72730266d0008246d000c7e004ab900008150660001183039000080ce3239000080ccb0416400010672003200d28141f9000080d02248d3c14a51673874003400e58243f90000807cd3c2d1c1700030102f49001c224b206f001c20502c79000028584eaeffca223900008148240194802c0260062c39000081483039000080ce7202b04164069cb90000814c74003400d48241f9000080d0d1c24a50673c224b41f900001b9670012c79000028584eaeffca2a00bc856f049c85601e528770003039000080ced08772003239000080ccb0816c062c3900008148200a674e4a12674a70003039000080ced08772003239000080ccb0816c342f06486dfef42f0a2f0b6100fb264fef001024402c39000081483039000080ce7202b04164069cb90000814c200a67b2528760ae220a57c04400488048c04cdf0ce44e5d4e75
 *   got:     9efc011448e72716266f01382a6f01347e004ab9000000006610303900000000323900000000b041650e220b57c04400488048c0600001263039000000004840424048402200d28141f9000000002248d3c14a51673e4840424048402400e58243f900000000d3c2d1c1700030102f490020224d206f002020502c79000000004eaeffca48c0223900000000240194802c0260062c39000000003039000000007202b04164069cb9000000004840424048402400d48241f900000000d1c24a50673e224d41f9000000002c790000000070014eaeffca3a0048c5bc856f049c85601e52877000303900000000d0877200323900000000b0816c062c3900000000200b674e4a13674a7000303900000000d0877200323900000000b0816c342f06486f00282f0b2f0d6100000026404fef00102c39000000003039000000007202b04164069cb900000000200b67b2528760ae220b57c04400488048c04cdf68e4defc01144e754e71
 *   summary: 360 got vs 324 ref. The original zero-extends the line index with MOVEQ #0 / MOVE.W from a register it already holds; 6.51 reloads the global and widens in place with SWAP / CLR.W / SWAP, four bytes more at five sites. Folding the two entry guards into one condition was worth 20 bytes on its own -- written as separate early returns, the SEQ/NEG.B/EXT.W/EXT.L booleanise of the return value is emitted three times instead of once. Both TextLength measurements, the control-marker width subtraction on the first two lines, the single-space prefix budget and the build loop match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include "esq-graphics.h"

extern long  DISPTEXT_LineTableLockFlag;
extern long  DISPTEXT_LineWidthPx;
extern long  DISPTEXT_ControlMarkerWidthPx;
extern unsigned short DISPTEXT_CurrentLineIndex;
extern unsigned short DISPTEXT_TargetLineIndex;
extern unsigned short DISPTEXT_LineLengthTable[];
extern char *DISPTEXT_LinePtrTable[];
extern char  DISPTEXT_STR_SINGLE_SPACE_PREFIX_1[];

extern char *DISPTEXT_BuildLineWithWidth(struct RastPort *rp, char *src,
                                         char *buf, long width);

long DISPTEXT_LayoutSourceToLines(struct RastPort *rp, char *src)
{
    char buf[268];
    long count;
    long width;
    long prefix;

    count = 0;
    if (DISPTEXT_LineTableLockFlag != 0
        || DISPTEXT_CurrentLineIndex >= DISPTEXT_TargetLineIndex)
        return src == 0;

    if (DISPTEXT_LineLengthTable[DISPTEXT_CurrentLineIndex] != 0)
        width = DISPTEXT_LineWidthPx
              - TextLength(rp, DISPTEXT_LinePtrTable[DISPTEXT_CurrentLineIndex],
                           DISPTEXT_LineLengthTable[DISPTEXT_CurrentLineIndex]);
    else
        width = DISPTEXT_LineWidthPx;

    if (DISPTEXT_CurrentLineIndex < 2)
        width -= DISPTEXT_ControlMarkerWidthPx;

    if (DISPTEXT_LineLengthTable[DISPTEXT_CurrentLineIndex] != 0) {
        prefix = TextLength(rp, DISPTEXT_STR_SINGLE_SPACE_PREFIX_1, 1);
        if (width > prefix) {
            width -= prefix;
        } else {
            count++;
            if (DISPTEXT_CurrentLineIndex + count < DISPTEXT_TargetLineIndex)
                width = DISPTEXT_LineWidthPx;
        }
    }

    while (src != 0 && *src != 0
           && DISPTEXT_CurrentLineIndex + count < DISPTEXT_TargetLineIndex) {
        src = DISPTEXT_BuildLineWithWidth(rp, src, buf, width);
        width = DISPTEXT_LineWidthPx;
        if (DISPTEXT_CurrentLineIndex < 2)
            width -= DISPTEXT_ControlMarkerWidthPx;
        if (src != 0)
            count++;
    }
    return src == 0;
}
