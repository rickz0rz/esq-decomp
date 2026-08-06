/* RESTORES: _HANDLE_CloseAllAndReturnWithCode, UNKNOWN32_JMPTBL_ESQ_ReturnWithStackCode
 * MODULE:   modules/submodules/unknown32.s
 * STATUS:   behavioural
 *
 * SAS/C library code: the last thing the program does. It closes every open
 * handle from the top of the table down, then leaves through
 * ESQ_ReturnWithStackCode, which restores the saved stack pointer and returns to
 * the shell. It does not come back.
 *
 * THE TABLE IS WALKED BACKWARDS, from count-1 to 0. Order matters for a program
 * that opened a log last and wants it closed first.
 *
 * THE FLAG TEST HERE IS NARROWER THAN THE ONE IN HANDLE_GetEntryByIndex, and
 * that is not a transcription slip. This function loads the flags longword and
 * tests it with `TST.B`, which looks at bits 0..7 only, where
 * HANDLE_GetEntryByIndex uses `TST.L` on the same field. So an entry whose flags
 * are set only in the upper three bytes counts as OPEN there and as FREE here.
 * `(flags & 0xff)` reproduces it. Widening it would close entries the original
 * leaves alone.
 *
 * BIT 4 STILL MEANS "DO NOT CLOSE" -- the borrowed standard streams -- exactly as
 * in HANDLE_CloseByIndex.
 *
 * THE INDEX IS A SIGNED WORD. `TST.W D6 / BMI` ends the loop and `SUBQ.W #1,D6`
 * steps it, with `EXT.L` before each use, so a handle count above 32767 would
 * wrap. It cannot in this program; `short` says what the original says.
 *
 * THE SECOND FUNCTION IS THE MODULE'S JUMP THUNK. Its target,
 * ESQ_ReturnWithStackCode, stays in assembly: it restores A7 from a global,
 * which no C function can do. The thunk forwards its argument, which is the exit
 * code -- dropping it would return an arbitrary value to the shell.
 *
 * SASC-MISMATCH: tail-jump
 *   ref:     JMP ESQ_ReturnWithStackCode
 *   got:     BSR.W then RTS
 *   summary: SAS/C emits no tail jump. The extra frame is never unwound, because
 *            the callee does not return.
 *   scope:   every jump table in the program.
 *   retest:  a compiler that turns a call in return position into a jump.
 */
#include "esq-neardata.h"

#ifndef ESQ_HANDLEENTRY_DEFINED
#define ESQ_HANDLEENTRY_DEFINED
/* src/structs.s: Struct_HandleEntry_Size = 8, Struct_HandleEntry__Flags = 0. */
struct HandleEntry {
    long  flags;        /* +0 */
    long  fh;           /* +4, the DOS file handle */
};
#endif

extern void DOS_CloseWithSignalCheck(long fh);
extern void ESQ_ReturnWithStackCode(long code);

void HANDLE_CloseAllAndReturnWithCode(long code)
{
    struct HandleEntry *table = (struct HandleEntry *)Global_HandleTableBase_A4_ADDR;
    short i;

    for (i = (short)(Global_HandleTableCount_A4 - 1); i >= 0; i--) {
        long flags = table[i].flags;

        if ((flags & 0xff) == 0)        /* TST.B: the low byte only */
            continue;
        if (flags & 0x10)               /* borrowed: do not close */
            continue;

        DOS_CloseWithSignalCheck(table[i].fh);
    }

    ESQ_ReturnWithStackCode(code);
}
