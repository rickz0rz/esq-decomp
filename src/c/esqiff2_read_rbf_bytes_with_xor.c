/* RESTORES: _ESQIFF2_ReadRbfBytesWithXor
 * MODULE:   modules/groups/a/o/esqiff2_p2.s  (with _ESQIFF2_ReadRbfBytesToBuffer)
 * STATUS:   behavioural
 *
 * The same read loop as _ESQIFF2_ReadRbfBytesToBuffer, and additionally folds
 * every byte read into a running checksum byte. It returns the buffer pointer
 * advanced past the last byte written.
 *
 * THE CHECKSUM IS ONE BYTE AND IS NOT ADVANCED. The original is
 * `EOR.B D0,(A2)` -- it XORs into the SAME byte on every iteration, while the
 * destination pointer A3 walks forward. Writing `*xorAcc++ ^= b` would be the
 * natural mistake and would scribble over `count` bytes of the caller's memory.
 *
 * IT IS ALSO NOT SEEDED HERE. The caller sets the accumulator before the call
 * and reads it after, which is why the parameter is a pointer rather than a
 * return value.
 *
 * THIS SIBLING HAS NO FRAME. It keeps the destination in A3 across the call, so
 * it needs no spill slot, where _ESQIFF2_ReadRbfBytesToBuffer opens
 * `LINK.W A5,#-4` for one. That is the only structural difference between the
 * two.
 *
 * THE COUNT IS AGAIN THE LOW WORD OF A FOUR-BYTE SLOT (`MOVE.W 26(A7),D7`, slot
 * at 24), and the pointer AFTER it is read from its own slot at 28(A7). That is
 * exactly the layout SHORTINT would break, so this file must not be compiled
 * with it.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   ref:     4eba  JSR (d16,PC)
 *   got:     6100  BSR.W
 *   summary: 6.51 emits BSR.W for every call whoever the callee is.
 *   scope:   program-wide.
 *   retest:  a compiler that picks the encoding per callee.
 */

extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern long SCRIPT_ReadNextRbfByte(void);

char *ESQIFF2_ReadRbfBytesWithXor(char *buf, short count, char *xorAcc)
{
    register short i;
    char b;

    for (i = 0; i < count; i++) {
        ESQFUNC_WaitForClockChangeAndServiceUi();
        b = (char)SCRIPT_ReadNextRbfByte();
        *buf++ = b;
        *xorAcc ^= b;           /* one byte, never advanced */
    }

    return buf;
}
