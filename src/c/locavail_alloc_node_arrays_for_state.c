/* RESTORES: LOCAVAIL_AllocNodeArraysForState
 * MODULE:   modules/groups/a/y/locavail_p1.s
 * STATUS:   behavioural
 *
 * Allocates the two node arrays a locavail state needs, and answers whether
 * both came back.
 *
 * The state record is PACKED: the count is a long at offset 2 (MOVE.L 2(A3),D0
 * twice), which lands there because SAS/C aligns a long to 2 bytes on the
 * 68000. The two result pointers are at +16 and +20.
 *
 * The count guard is a signed long range, strictly inside 0 and 100
 * (TST.L / BLE, then MOVEQ #100 / CMP.L / BGE).
 *
 * The first allocation is a fixed 4 bytes at source line 218; the second is
 * count * 10 at line 229, and the multiply goes through the 32-bit helper.
 *
 * The first array's head longword is cleared explicitly after the allocation
 * even though MEMF_CLEAR already zeroed it -- the original emits
 * MOVEA.L D0,A0 / CLR.L (A0), so it is reproduced rather than optimised away.
 *
 * 116 ref vs 120 got. Both MEMF words, the PEA 4, both line numbers (218,
 * 229), both LEA 16(A7),A7 cleanups, the MOVEA.L D0,A0 / CLR.L (A0) head clear
 * and both result stores match exactly.
 *
 * SASC-MISMATCH: mul32-helper-vs-inline
 *   ref:     720a 4eba0e14        MOVEQ #10,D1 / JSR MATH_Mulu32(PC)  (6 bytes)
 *   got:     2200 e581 d280 d281  MOVE.L D0,D1 / ASL.L #2,D1 / ADD.L D0,D1 /
 *                                 ADD.L D1,D1                         (8 bytes)
 *   summary: the count * 10 goes to the 32-bit multiply helper in the original
 *            and is strength-reduced inline by 6.51 -- 10 = (4 + 1) * 2, which
 *            is what the chain computes. Same product, 2 bytes more, and the
 *            remaining 2 are object alignment padding.
 *   scope:   program-wide. docs/compiler-version.md, "Arithmetic: three more
 *            classes".
 *   retest:  a compiler that emits a helper call for a 32-bit constant multiply.
 */
#include <exec/memory.h>

struct LocavailState {
    char  pad0[2];
    long  count;                /* +2, 2-byte aligned */
    char  pad6[10];
    void *nodes;                /* +16 */
    void *data;                 /* +20 */
};

extern void *MEMORY_AllocateMemory(char *who, long line,
                                                  long size, long flags);
extern char Global_STR_LOCAVAIL_C_4[];
extern char Global_STR_LOCAVAIL_C_5[];

long LOCAVAIL_AllocNodeArraysForState(struct LocavailState *s)
{
    long r = 0;

    if (s->count > 0 && s->count < 100) {
        s->nodes = MEMORY_AllocateMemory(
            Global_STR_LOCAVAIL_C_4, 218L, 4L, MEMF_PUBLIC | MEMF_CLEAR);

        if (s->nodes != 0) {
            *(long *)s->nodes = 0;

            s->data = MEMORY_AllocateMemory(
                Global_STR_LOCAVAIL_C_5, 229L, s->count * 10,
                MEMF_PUBLIC | MEMF_CLEAR);

            if (s->data != 0)
                r = 1;
        }
    }
    return r;
}
