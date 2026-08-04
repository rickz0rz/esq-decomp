/* RESTORES: _ESQIFF2_ReadRbfBytesToBuffer
 * MODULE:   modules/groups/a/o/esqiff2_p2.s  (with _ESQIFF2_ReadRbfBytesWithXor)
 * STATUS:   behavioural
 *
 * Reads `count` bytes off the RBF serial line into `buf`, servicing the display
 * between bytes, and returns the buffer pointer advanced past the last byte
 * written. The caller uses the return value to append the next record, so
 * dropping it would break every reader in ESQIFF2.
 *
 * THE COUNT IS A WORD IN A LONG SLOT. The original reads `MOVE.W 30(A7),D7`
 * where the argument slot begins at 28(A7), so it takes the LOW WORD of a
 * four-byte slot -- the ordinary way an assembly caller passes a short. It is
 * declared `short` for that reason, and the parameter that follows it in the
 * sibling is still read from its own 4-byte slot. Do NOT compile this file with
 * SHORTINT: that would make the slot two bytes wide and every later argument
 * would arrive at the wrong offset. See AGENTS.md, "SHORTINT CHANGES THE CALLING
 * CONVENTION".
 *
 * THE LOOP COUNTER IS SIGNED. `CMP.W D7,D6` with `BGE` is a signed word compare,
 * so a negative count reads zero bytes rather than looping four billion times.
 *
 * THE POINTER IS ADVANCED BEFORE THE CALL, NOT AFTER. The original copies A3 to
 * A0, bumps A3, spills A0 to its one stack local, calls, and stores through the
 * reloaded A0. That ordering exists because the callee clobbers A0; it is not
 * observable, so `*buf++ = ...` expresses it.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   ref:     4eba  JSR (d16,PC)
 *   got:     6100  BSR.W
 *   summary: 6.51 emits BSR.W for every call whoever the callee is. Same size,
 *            same displacement, same effect.
 *   scope:   program-wide.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55fffc ... 4e5d      LINK.W A5,#-4 / UNLK
 *   got:     no frame pointer; the spill slot is addressed off A7
 *   summary: the frame class. A5 is a reserved frame pointer for 6.51 and the
 *            original's one-longword local does not need one.
 *   scope:   program-wide. docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against another SAS/C.
 */

extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern long SCRIPT_ReadNextRbfByte(void);

char *ESQIFF2_ReadRbfBytesToBuffer(char *buf, short count)
{
    register short i;

    for (i = 0; i < count; i++) {
        ESQFUNC_WaitForClockChangeAndServiceUi();
        *buf++ = (char)SCRIPT_ReadNextRbfByte();
    }

    return buf;
}
