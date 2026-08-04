/* RESTORES: _DISPTEXT_LayoutAndAppendToBuffer
 * MODULE:   modules/groups/a/i/disptext_p2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: word-index-zero-extension
 *   ref:     4e55feec48e72730266d0008246d000c4ab900008150660001c23039000080ce3239000080ccb041640001b072003200d28141f9000080d02248d3c14a51673874003400e58243f90000807cd3c2d1c1700030102f49001c224b206f001c20502c79000028584eaeffca223900008148240194802e0260062e39000081483039000080ce7202b04164069eb90000814c20790000815a421070003039000080ced08043f9000080d0d3c04a516772224b41f900001b9870012c79000028584eaeffca2c00be866f2841f900001b9a22790000815a12d866fc9e8670003039000080ced08041f9000080d0d1c05250603070003039000080cee58041f9000080f8d1c02f106100f8c4584f3039000080ce3239000080ccb04164062e3900008148200a6700009e4a12670000983039000080ce3239000080ccb041640000862f07486dfef42f0a2f0b6100f9a2244041edfef422484a1966fc538993c82a092e882f390000815a4eba03a24fef001470003039000080ced08041f9000080d0d1c0700030102200d28530812e39000081483039000080ce7202b04164069eb90000814c220a6700ff7a72003200e58141f9000080f8d1c12f106100f810584f6000ff6020790000815a4a10670e2f086100f84a42976100fa8c584f220a57c04400488048c04cdf0ce44e5d4e75
 *   got:     9efc011448e72716266f01382a6f01344ab9000000006610303900000000323900000000b041650e220b57c04400488048c0600001f63039000000004840424048402200d28141f9000000002248d3c14a51673e4840424048402400e58243f900000000d3c2d1c1700030102f490020224d206f002020502c79000000004eaeffca48c0223900000000240194802e0260062e39000000003039000000007202b04164069eb90000000020790000000042103039000000004840424048402400d48241f900000000d1c24a506700008a224d41f9000000002c790000000070014eaeffca3c0048c6be866f3641f90000000022790000000012d866fc9e863039000000004840424048402200d28141f9000000002248d3c1d1c132105241328160363039000000004840424048402200e58141f900000000d1c12f1061000000584f303900000000323900000000b04164062e3900000000200b670000aa4a13670000a4303900000000323900000000b041640000922f07486f00282f0b2f0d61000000264041ef003422484a1966fc538993c82a092e882f3900000000610000004fef00143039000000004840424048402200d28141f9000000002248d3c1d1c172003210d28532812e39000000003039000000007202b04164069eb900000000220b6700ff724840424048402200e58141f900000000d1c12f1061000000584f6000ff5420790000000010104a00670e2f0861000000429761000000584f220b57c04400488048c04cdf68e4defc01144e75
 *   summary: 564 got vs 492 ref. The original holds the line index in a data register and zero-extends it with MOVEQ #0 / MOVE.W before each of the seven table lookups; 6.51 reloads the global and widens in place with SWAP / CLR.W / SWAP, four bytes more each time, and reloads the scratch-buffer global rather than keeping it in an address register. Folding the two entry guards into one condition was worth 16 bytes, because the SEQ/NEG.B/EXT.W/EXT.L booleanise of the return value is otherwise emitted three times. The prefix-width budget with its commit-and-advance fallback, the build-and-append loop, the running length accumulation, the control-marker width subtraction on the first two lines and the closing flush match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include <string.h>
#include "esq-graphics.h"

extern long  DISPTEXT_LineTableLockFlag;
extern long  DISPTEXT_LineWidthPx;
extern long  DISPTEXT_ControlMarkerWidthPx;
extern unsigned short DISPTEXT_CurrentLineIndex;
extern unsigned short DISPTEXT_TargetLineIndex;
extern unsigned short DISPTEXT_LineLengthTable[];
extern char *DISPTEXT_LinePtrTable[];
extern long  DISPTEXT_LinePenTable[];
extern char *Global_REF_1000_BYTES_ALLOCATED_2;
extern char  DISPTEXT_STR_SINGLE_SPACE_PREFIX_2[];
extern char  DISPTEXT_STR_SINGLE_SPACE_COPY_PREFIX[];

extern void  DISPLIB_CommitCurrentLinePenAndAdvance(long pen);
extern char *DISPTEXT_BuildLineWithWidth(struct RastPort *rp, char *src,
                                         char *buf, long width);
extern void  STRING_AppendAtNull(char *dst, char *src);
extern void  DISPTEXT_AppendToBuffer(char *text);
extern void  DISPTEXT_BuildLinePointerTable(long mode);

long DISPTEXT_LayoutAndAppendToBuffer(struct RastPort *rp, char *src)
{
    char scratch[268];
    long width;
    long prefix;
    long len;

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

    *Global_REF_1000_BYTES_ALLOCATED_2 = 0;

    if (DISPTEXT_LineLengthTable[DISPTEXT_CurrentLineIndex] != 0) {
        prefix = TextLength(rp, DISPTEXT_STR_SINGLE_SPACE_PREFIX_2, 1);
        if (width > prefix) {
            strcpy(Global_REF_1000_BYTES_ALLOCATED_2,
                   DISPTEXT_STR_SINGLE_SPACE_COPY_PREFIX);
            width -= prefix;
            DISPTEXT_LineLengthTable[DISPTEXT_CurrentLineIndex] =
                DISPTEXT_LineLengthTable[DISPTEXT_CurrentLineIndex] + 1;
        } else {
            DISPLIB_CommitCurrentLinePenAndAdvance(
                DISPTEXT_LinePenTable[DISPTEXT_CurrentLineIndex]);
            if (DISPTEXT_CurrentLineIndex < DISPTEXT_TargetLineIndex)
                width = DISPTEXT_LineWidthPx;
        }
    }

    while (src != 0 && *src != 0
           && DISPTEXT_CurrentLineIndex < DISPTEXT_TargetLineIndex) {
        src = DISPTEXT_BuildLineWithWidth(rp, src, scratch, width);
        len = strlen(scratch);
        STRING_AppendAtNull(Global_REF_1000_BYTES_ALLOCATED_2,
                                            scratch);
        DISPTEXT_LineLengthTable[DISPTEXT_CurrentLineIndex] =
            DISPTEXT_LineLengthTable[DISPTEXT_CurrentLineIndex] + len;

        width = DISPTEXT_LineWidthPx;
        if (DISPTEXT_CurrentLineIndex < 2)
            width -= DISPTEXT_ControlMarkerWidthPx;

        if (src != 0)
            DISPLIB_CommitCurrentLinePenAndAdvance(
                DISPTEXT_LinePenTable[DISPTEXT_CurrentLineIndex]);
    }

    if (*Global_REF_1000_BYTES_ALLOCATED_2 != 0) {
        DISPTEXT_AppendToBuffer(Global_REF_1000_BYTES_ALLOCATED_2);
        DISPTEXT_BuildLinePointerTable(0);
    }

    return src == 0;
}
