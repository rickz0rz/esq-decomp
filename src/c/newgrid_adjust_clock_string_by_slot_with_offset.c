/* RESTORES: NEWGRID_AdjustClockStringBySlotWithOffset
 * MODULE:   modules/groups/b/a/newgrid_p2_p0.s
 * STATUS:   behavioural
 *
 * Byte-for-byte the same routine as newgrid_adjust_clock_string_by_slot.c
 * except for the final call, which goes to the with-offset slot lookup. The
 * two originals differ in exactly that one displacement and nothing else --
 * compare the extracts at 0x20B2A and 0x20B80, which agree instruction for
 * instruction up to the closing BSR.
 *
 * The rewind is 60 * (CLOCK_FormatVariantCode % 30) seconds and takes the
 * REMAINDER from MATH_DivS32's D1, not its quotient. See the sibling file for
 * the full reading of that sequence.
 *
 * 86 ref vs 92 got -- identical numbers to the sibling, and the emitted bytes
 * are identical to it as well, since the only difference between the two
 * functions is which extern the closing call names. The two divergences are
 * therefore the same two: the 32-bit constant multiply strength-reduced inline
 * (+2, docs/compiler-version.md "Arithmetic: three more classes") and the
 * frame class (+4, "A5 is a reserved frame pointer"). Both are written up in
 * newgrid_adjust_clock_string_by_slot.c; they are not repeated here because a
 * second copy would rot independently.
 */
#include <string.h>

extern long NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds(char *rec);
extern void NEWGRID_JMPTBL_DATETIME_SecondsToStruct(long secs, char *rec);
/* Takes the clock record as a struct, not as bytes. See the guarded forward
 * declaration in newgrid_adjust_clock_string_by_slot.c for why the guard is
 * needed rather than a bare tag declaration. */
#ifndef NEWGRIDCLOCKDATA_DEFINED
struct NewGridClockData;
#endif
extern long NEWGRID_ComputeDaySlotFromClockWithOffset(struct NewGridClockData *rec);
extern unsigned char CLOCK_FormatVariantCode;

long NEWGRID_AdjustClockStringBySlotWithOffset(char *clock)
{
    char tmp[22];
    long secs;

    memcpy(tmp, clock, 22);
    secs = NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds(tmp);
    secs -= 60 * (((long)CLOCK_FormatVariantCode - ((long)CLOCK_FormatVariantCode / 30) * 30));
    NEWGRID_JMPTBL_DATETIME_SecondsToStruct(secs, tmp);

    return NEWGRID_ComputeDaySlotFromClockWithOffset(
        (struct NewGridClockData *)tmp);
}
