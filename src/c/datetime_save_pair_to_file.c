/* RESTORES: DATETIME_SavePairToFile
 * MODULE:   modules/groups/a/j/disptext2_p2_p1.s
 * STATUS:   behavioural
 *
 * Writes a date pair to the default .dat path as two tagged records, and
 * answers whether it got that far.
 *
 * NOTE THE ORDER: the SECOND member is written under the "G2" tag and the
 * FIRST under "G3". The original pushes 4(A3) for the first record and (A3)
 * for the second, so the file order is the reverse of the struct order. Any
 * restoration that writes them in declaration order produces a file that reads
 * back with the two dates swapped, and nothing in a byte comparison would
 * catch it.
 *
 * 0x3EE is MODE_NEWFILE (1006), the AmigaDOS open mode that truncates.
 *
 * Both tag strings are written with an explicit length of 4, not with strlen.
 *
 * The three guards -- the pair pointer and both of its members -- all jump to
 * the same `return 0`, as does the open failing.
 *
 * 116 ref vs 116 got, and the structure backs the size rather than the size
 * standing alone. Every instruction agrees in kind, order and size: the three
 * guards, the PEA $3ee open mode, both PEA 4 lengths, both tag-string PEAs,
 * all four MOVE.L into the reused argument slot (2eab0004 / 2e93 / 2e87), the
 * two format calls, the close, the LEA 32(A7),A7 and the MOVEQ #1 / MOVEQ #0
 * result pair. Two items differ and neither costs a byte.
 *
 * SASC-MISMATCH: a3-vs-a5-register-allocation
 *   ref:     266f000c 200b 4a93 4aab0004 2eab0004 2e93   the pair record in A3
 *   got:     2a6f000c 200d 4a95 4aad0004 2ead0004 2e95   the same against A5
 *   summary: same instructions, same sizes, one register apart.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause".
 *   retest:  a compiler that reserves A5; the same doc gives the probe.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   ref:     4ebaafa0 / 4ebab0ce / 4ebab0b4 / 4ebaafee   JSR (d16,PC)
 *   got:     61000000 x4                                 BSR.W
 *   summary: same size, same displacement, same semantics, different opcode.
 *            The two format-stream calls are BSR.W in the original as well
 *            (6100fdf8 / 6100fde0) and those agree in kind.
 *   scope:   every cross-unit restoration; AGENTS.md carries the count.
 *            docs/compiler-version.md, "Call encoding depends on the
 *            callee's translation unit".
 *   retest:  a compiler that emits JSR (d16,PC) for a call to an extern.
 */
#include "esq-dos.h"

struct DateTimePair {
    char *first;                /* +0 */
    char *second;               /* +4 */
};

extern BPTR DISKIO_OpenFileWithBuffer(char *path, long mode);
extern long DISKIO_WriteBufferedBytes(BPTR fh, char *src, long len);
extern void DATETIME_FormatPairToStream(BPTR fh, char *rec);
extern void DISKIO_CloseBufferedFileAndFlush(BPTR fh);

extern char *DST_DefaultDatPathPtr;
extern char  DST_STR_G2_COLON[];
extern char  DST_STR_G3_COLON[];

long DATETIME_SavePairToFile(struct DateTimePair *p)
{
    BPTR fh;

    if (p == 0 || p->first == 0 || p->second == 0)
        return 0;

    fh = DISKIO_OpenFileWithBuffer(DST_DefaultDatPathPtr, 0x3eeL);
    if (fh == 0)
        return 0;

    DISKIO_WriteBufferedBytes(fh, DST_STR_G2_COLON, 4L);
    DATETIME_FormatPairToStream(fh, p->second);

    DISKIO_WriteBufferedBytes(fh, DST_STR_G3_COLON, 4L);
    DATETIME_FormatPairToStream(fh, p->first);

    DISKIO_CloseBufferedFileAndFlush(fh);
    return 1;
}
