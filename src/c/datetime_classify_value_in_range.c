/* RESTORES: _DATETIME_ClassifyValueInRange
 * MODULE:   modules/groups/a/j/disptext2_p1.s
 * STATUS:   behavioural
 *
 * Tests whether a value falls inside the window [low, high) held in a selection
 * record. It returns 1 or 0.
 *
 * The window may be INVERTED. When low is above high, the range is the one that
 * wraps, such as a time window across midnight. The answer is then negated. A
 * value between the two bounds is OUTSIDE such a window. A value on either side
 * of them is inside it. Equal bounds make an empty window and return 0.
 *
 * The original builds a flag byte rather than testing the two conditions
 * directly. Bit 4 records that the bounds were swapped. Bits 0 and 1 record
 * where the value fell. A switch then covers the six reachable combinations.
 * Two independent tests let the compiler collapse the whole function to a
 * compare and an exclusive-or. The flag byte and the switch stay here to hold
 * the shape of the original.
 *
 * The `flags |= 0` statements are no-ops, and that is deliberate. They were
 * written to produce the read-and-write-back of the flag byte at -11(A5), which
 * a plain assignment does not. They also name the case that was taken.
 *
 * 212 bytes against 180.
 *
 * SASC-MISMATCH: switch-becomes-jump-table
 *   ref:     4a40 6718 5340 6718 5340 6718 0440000e 6716 ...
 *            TST.W / SUBQ.W / SUBI.W #14 -- a chained subtract, each test
 *            consuming the running difference
 *   got:     4efb0006 followed by a 19-entry word table of 004e fillers
 *   summary: the six reachable flag values are 0, 1, 2, 16, 17 and 18, so a
 *            dense table needs 19 slots. 13 of them are the default. The
 *            compiler of the original chose the chain. 6.51 chooses the table,
 *            and that is the whole 32 bytes.
 *   tried:   SHORTINT, which changes nothing here. The table is chosen before
 *            the width is. An explicit if/else chain over the same six constants
 *            lands at 188 bytes. It emits independent CMP.B compares rather than
 *            the chained subtract, so it is NOT closer to the original in shape,
 *            only in size. The switch stays for that reason.
 *   scope:   any switch whose case values are sparse enough to need filler.
 *   retest:  a compiler that costs the table against the chain and picks the
 *            chain at this density.
 *
 * SASC-MISMATCH: flag-byte-kept-in-register
 *   ref:     1b40fff5 / 08ed0004fff5   flag byte lives at -11(A5); BSET writes
 *                                      memory
 *   got:     7c00 / 08c60004           flag byte lives in D6
 *   summary: the `flags |= 0` statements were written to reproduce the
 *            read-and-write-back of the memory byte. They do not. 6.51 never
 *            puts the byte in memory, so the round trip has no memory to go
 *            through. They stay because they name the case that was taken.
 *   tried:   the |= 0 form, which is the only legal C spelling of the no-op.
 *   scope:   this function.
 *   retest:  a compiler that keeps a small local flag in a frame slot.
 */
struct DtSel { char pad[8]; long low; long high; short value; };

#define CLS_ORDERED 0x00
#define CLS_SWAPPED 0x10
#define CLS_BELOW   0x00
#define CLS_INSIDE  0x01
#define CLS_ABOVE   0x02

long DATETIME_ClassifyValueInRange(struct DtSel *s, long value)
{
    unsigned char flags;
    long low, high, lo, hi, result;

    flags = 0;
    if (s == 0)
        return 0;

    hi = s->high;
    lo = s->low;
    if (lo < hi) {
        flags |= CLS_ORDERED;
        low = lo;
        high = hi;
    } else if (lo > hi) {
        flags |= CLS_SWAPPED;
        low = hi;
        high = lo;
    } else
        return 0;

    if (value < low)
        flags |= CLS_BELOW;
    else if (value < high)
        flags |= CLS_INSIDE;
    else
        flags |= CLS_ABOVE;

    switch (flags) {
    case CLS_ORDERED | CLS_BELOW:  result = 0; break;
    case CLS_ORDERED | CLS_INSIDE: result = 1; break;
    case CLS_ORDERED | CLS_ABOVE:  result = 0; break;
    case CLS_SWAPPED | CLS_BELOW:  result = 1; break;
    case CLS_SWAPPED | CLS_INSIDE: result = 0; break;
    case CLS_SWAPPED | CLS_ABOVE:  result = 1; break;
    default:                       result = 0; break;
    }
    return result;
}
