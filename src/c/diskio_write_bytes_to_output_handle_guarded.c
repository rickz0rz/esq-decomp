/* RESTORES: _DISKIO_WriteBytesToOutputHandleGuarded
 * MODULE:   modules/groups/a/g/diskio_p4.s
 * STATUS:   behavioural
 *
 * Write n bytes to the module's output handle with the parser's read-mode flags
 * temporarily forced to 0x100, restoring them afterwards whether the write
 * succeeded or not. Returns 0 on a full write and -1 on a short one.
 *
 * The length is a SHORT: the original reads it with MOVE.W 30(A7),D7, the low
 * word of the longword argument slot, and sign-extends it (EXT.L) for Write's
 * length parameter. Declaring it long reads the wrong four bytes.
 *
 * LIBRARY BASE: esq-dos.h, the volatile base -- correct here with nothing to
 * weigh up, because the original reloads Global_REF_DOS_LIBRARY_2 for its one
 * call anyway. (Contrast the graphics leaf header; see esq-graphics-leaf.h.)
 *
 * 82 bytes against 84 (84 in the object, the last 2 being longword padding), and
 * the only real divergence is a DEAD INSTRUCTION IN THE ORIGINAL.
 *
 * Declaring the result `short` is load-bearing: the original compares it to the
 * length with CMP.W, so with a long result SAS/C emitted MOVE.W/EXT.L/CMP.L
 * instead and the function came out at 88.
 *
 * SASC-MISMATCH: redundant-compare-in-original
 *   ref:     bc47  CMP.W D7,D6   <- result computed, then discarded
 *            ...   restore flags
 *            bc47  CMP.W D7,D6   <- computed again, then branched on
 *   got:     ...   restore flags
 *            bc47  CMP.W D7,D6   (once)
 *   summary: -2. The original emits the comparison TWICE, once before restoring
 *            the read-mode flags and once after, and only the second one is used.
 *            The first is dead. This is not something to reproduce: forcing a
 *            discarded compare would mean writing a statement whose only purpose
 *            is to be thrown away, which is the distortion the project forbids
 *            (and unlike the dead-block case in parseini_load_weather_strings.c,
 *            there is no `if (zero)` idiom that produces a stray CMP).
 *   tried:   short vs long result (84 vs 88). Nothing produces the extra compare.
 *   scope:   unknown -- this is the first instance recorded. If more turn up it
 *            suggests the original's compiler evaluated the condition eagerly
 *            before a sequence point and re-evaluated after.
 *   retest:  a compiler that emits the comparison twice here.
 */

#include "esq-dos.h"

extern unsigned short ESQPARS2_ReadModeFlags;
extern unsigned short DISKIO_SavedReadModeFlags;
extern long DISKIO_WriteFileHandle;

long DISKIO_WriteBytesToOutputHandleGuarded(void *buf, short n)
{
    short written;

    DISKIO_SavedReadModeFlags = ESQPARS2_ReadModeFlags;
    ESQPARS2_ReadModeFlags = 0x100;

    written = (short)Write(DISKIO_WriteFileHandle, buf, (long)n);

    ESQPARS2_ReadModeFlags = DISKIO_SavedReadModeFlags;

    if (written == n)
        return 0;
    return -1;
}
