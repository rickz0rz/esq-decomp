/* RESTORES: DISPTEXT_InitBuffers
 * MODULE:   modules/groups/a/i/disptext_p1.s
 * STATUS:   behavioural
 *
 * Allocates the two 1000-byte display buffers, once. The pending flag is a
 * REQUEST, not a done-marker: the body runs when it is non-zero and clears it
 * on the way through, which is the same sense newgrid2_ensure_buffers_allocated.c
 * uses.
 *
 * The text-buffer pointer is cleared before the line tables are reset, and the
 * flag is cleared before either allocation, so a failure part-way through does
 * not leave the request set.
 *
 * The original stores the first result into its global BETWEEN the two calls
 * (23c0 at 0xb05c, before the second JSR) and reuses the argument area for the
 * second call rather than re-pushing. Both fall out of the source below.
 *
 * 90 ref vs 90 got, and here the structure backs the size up. Every
 * instruction agrees in kind, order and size for the first 44 bytes -- the
 * pending test, the two CLR.L stores, the reset call, both 0x00010001 flag
 * words, both PEA 1000, both line numbers (320, 321), the argument-area reuse
 * (2ebc00010001) and the single LEA 28(A7),A7. Two items differ.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   ref:     4ebadcda / 4ebadcbc     JSR (d16,PC)
 *   got:     61000000 / 61000000     BSR.W
 *   summary: same size, same displacement, same semantics, different opcode.
 *   scope:   every cross-unit restoration; AGENTS.md carries the count.
 *            docs/compiler-version.md, "Call encoding depends on the
 *            callee's translation unit".
 *   retest:  a compiler that emits JSR (d16,PC) for a call to an extern.
 *
 * SASC-MISMATCH: store-before-stack-cleanup
 *   ref:     the first result is stored between the two calls, the second AFTER
 *            the LEA 28(A7),A7 cleanup
 *   got:     each result is stored immediately on return, cleanup last
 *   summary: 6.51 keeps neither result live across anything; the original holds
 *            the second in D0 across its stack cleanup. Same two stores, same
 *            destinations, different placement. Same class as
 *            newgrid2_ensure_buffers_allocated.c, where forcing the order with
 *            a temporary made things worse.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <exec/memory.h>

extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(char *who, long line,
                                                   long size, long flags);
extern void  DISPLIB_ResetLineTables(void);

extern long  DISPTEXT_InitBuffersPending;
extern void *DISPTEXT_TextBufferPtr;
extern void *Global_REF_1000_BYTES_ALLOCATED_1;
extern void *Global_REF_1000_BYTES_ALLOCATED_2;
extern char  Global_STR_DISPTEXT_C_2[];
extern char  Global_STR_DISPTEXT_C_3[];

void DISPTEXT_InitBuffers(void)
{
    if (DISPTEXT_InitBuffersPending == 0)
        return;

    DISPTEXT_TextBufferPtr = 0;
    DISPLIB_ResetLineTables();
    DISPTEXT_InitBuffersPending = 0;

    Global_REF_1000_BYTES_ALLOCATED_1 = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_DISPTEXT_C_2, 320L, 1000L, MEMF_PUBLIC | MEMF_CLEAR);
    Global_REF_1000_BYTES_ALLOCATED_2 = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_DISPTEXT_C_3, 321L, 1000L, MEMF_PUBLIC | MEMF_CLEAR);
}
