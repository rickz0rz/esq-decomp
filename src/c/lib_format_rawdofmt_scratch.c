/* RESTORES: _FORMAT_RawDoFmtWithScratchBuffer, _UNKNOWN2A_Stub0
 * MODULE:   modules/submodules/unknown2a.s
 * STATUS:   behavioural
 *
 * Formats into the shared scratch buffer and pushes the result out of the
 * parallel port. This is ESQ's debug-trace printf.
 *
 * THE SAME V-FORM SHAPE AS WDISP_SPrintf, AND FOR THE SAME REASON. The original
 * computes an argument pointer and hands it to a worker that takes one:
 *
 *     LEA     12(A5),A0                    ; past fmt at 8(A5) -- this is va_start
 *     MOVE.L  A0,-(A7)                     ; args pointer
 *     MOVE.L  8(A5),-(A7)                  ; fmt
 *     PEA     _FORMAT_ScratchBuffer        ; buffer
 *     JSR     _FORMAT_FormatToBuffer2(PC)  ; the worker that takes a pointer
 *     PEA     _FORMAT_ScratchBuffer
 *     JSR     _PARALLEL_RawDoFmtStackArgs(PC)
 *
 * `FORMAT_FormatToBuffer2` is to this what `WDISP_FormatWithCallback` is to
 * sprintf. So the jump-table thunks in front of this function are written by
 * `jmptbl_to_c.py` as `va_list` wrappers over the v-form below. SAS/C's
 * `va_list` on the 68000 IS that pointer -- `va_start` compiles to
 * `LEA d16(A7),An` -- so nothing is copied. See AGENTS.md, "A VARIADIC TARGET
 * NEEDS A V-FORM".
 *
 * `FORMAT_VRawDoFmtWithScratchBuffer` IS A NEW SYMBOL. The original has only the
 * variadic entry. It exists so the thunks can be C, and it costs one call.
 *
 * THE MODULE'S TWO UNLABELLED BLOCKS ARE DEAD AND ARE NOT REPRODUCED.
 * `unknown2a.s` holds four blocks of code and only two labels:
 *
 *   1. an unlabelled copy of RawDoFmtWithScratchBuffer, at the TOP of the module
 *   2. _FORMAT_RawDoFmtWithScratchBuffer itself
 *   3. an unlabelled variant that also appends to DF1:debug.log
 *   4. _UNKNOWN2A_Stub0, a bare RTS
 *
 * Blocks 1 and 3 carry no label, so nothing can call them, and neither can be
 * reached by fall-through: the module before this one in `src/Prevue.asm` is
 * `submodules/unknown.s`, which ends `JMP` / `RTS` / `DC.W 0`, and block 2 ends
 * in RTS. Both were checked rather than assumed -- AGENTS.md records that an
 * unlabelled block absorbed into its neighbour is a recurring trap here, so the
 * reachability was established in the link order, not by eye.
 *
 * Dropping them removes about 130 bytes the original carries and never executes.
 * If a future disassembly pass gives either block a label, this file must gain
 * the corresponding function before it can stay linked.
 *
 * SASC-MISMATCH: deferred-stack-cleanup
 *   ref:     both calls push their arguments and NEITHER pops; the `UNLK A5`
 *            at the end reclaims all sixteen bytes at once
 *   got:     each call builds and pops its own block
 *   summary: same arguments reach both callees. The original saves the pops by
 *            letting the frame unwind do the work.
 *   scope:   several sites in the program.
 *   retest:  a compiler that defers argument-stack cleanup to the epilogue.
 */
#include <stdarg.h>

extern char FORMAT_ScratchBuffer[];

extern void FORMAT_FormatToBuffer2(char *buf, char *fmt, void *args);
extern void PARALLEL_RawDoFmtStackArgs(char *buf);

/* The argument-pointer form. Every variadic entry, including each jump-table
 * thunk, is a thin wrapper over this. */
void FORMAT_VRawDoFmtWithScratchBuffer(char *fmt, void *args)
{
    FORMAT_FormatToBuffer2(FORMAT_ScratchBuffer, fmt, args);
    PARALLEL_RawDoFmtStackArgs(FORMAT_ScratchBuffer);
}

void FORMAT_RawDoFmtWithScratchBuffer(char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    FORMAT_VRawDoFmtWithScratchBuffer(fmt, (void *)ap);
    va_end(ap);
}

/* A bare RTS in the original. It is reached through a jump table, so the symbol
 * has to exist even though it does nothing. */
void UNKNOWN2A_Stub0(void)
{
}
