/* RESTORES: BRUSH_AllocBrushNode
 * MODULE:   modules/groups/a/a/brush_p3.s
 * STATUS:   behavioural
 *
 * Allocates a 238-byte brush node, copies the name into it, sets the initial
 * field values, and links it onto the tail the caller passes.
 *
 * The node size (238) and the link offset (234) agree: the next pointer is the
 * last longword of the record.
 *
 * BRUSH_LastAllocatedNode is not a cache, it is the RESULT. The original stores
 * the allocation into it, tests it, reloads it to work through, and returns the
 * GLOBAL rather than the register -- so a failed allocation returns whatever the
 * global holds, which is the null it was just given. The comment in the
 * disassembly calls it "expose allocation for cleanup/error handlers", and that
 * is why it is written through here rather than kept in a local.
 *
 * The name copy is MOVE.B (A0)+,(A1)+ / BNE, which is what strcpy inlines to.
 *
 * The two zeroed longwords at +222 and +226 come from ONE register (MOVEQ #0
 * then two stores), so they are written as a chained assignment; +222 is stored
 * first, which fixes the order.
 *
 * The tail link is guarded but the node's own next pointer is cleared either
 * way -- the CLR.L is the fall-through target of the guard, not part of it.
 *
 * 108 ref vs 108 got, and the structure backs the size. Every instruction
 * agrees in kind, order and size: the MEMF word, the PEA 238 / PEA 1352 / name
 * string, the LEA 16(A7),A7 cleanup, the global store and test, the inline
 * strcpy (204b 2240 12d8 66fc), the MOVEQ #1 to +194, the CLR.B at +190, the
 * chained zero of +222 and +226, the tail guard and both next-pointer stores.
 * Two items differ and neither costs a byte.
 *
 * SASC-MISMATCH: a3-vs-a5-register-allocation
 *   ref:     48e70030 246f0010 2079 2140 4228 200a 2548   A2/A3 pair
 *   got:     48e70034 2a6f0010 2479 2540 422a 220b 274a   A2/A4/A5
 *   summary: the node and tail pointers land in a different register pair.
 *            Same instructions, same sizes.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause".
 *   retest:  a compiler that reserves A5; the same doc gives the probe.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   ref:     4eba650c        JSR (d16,PC)
 *   got:     61000000        BSR.W
 *   summary: same size, same displacement, same semantics, different opcode.
 *   scope:   every cross-unit restoration; AGENTS.md carries the count.
 *            docs/compiler-version.md, "Call encoding depends on the
 *            callee's translation unit".
 *   retest:  a compiler that emits JSR (d16,PC) for a call to an extern.
 */
#include <exec/memory.h>
#include <string.h>

struct BrushNode {
    char  name[190];            /* +0   */
    char  flag190;              /* +190 */
    char  pad191[3];
    long  field194;             /* +194 */
    char  pad198[24];
    long  field222;             /* +222 */
    long  field226;             /* +226 */
    char  pad230[4];
    struct BrushNode *next;     /* +234, last longword of the 238 */
};

extern void *MEMORY_AllocateMemory(char *who, long line,
                                                   long size, long flags);
extern struct BrushNode *BRUSH_LastAllocatedNode;

void *BRUSH_AllocBrushNode(char *name, struct BrushNode *tail)
{
    struct BrushNode *n;

    BRUSH_LastAllocatedNode = MEMORY_AllocateMemory(
        "BRUSH.c", 1352L, 238L, MEMF_PUBLIC | MEMF_CLEAR);

    if (BRUSH_LastAllocatedNode != 0) {
        strcpy(BRUSH_LastAllocatedNode->name, name);

        n = BRUSH_LastAllocatedNode;
        n->field194 = 1;
        n->flag190  = 0;
        n->field226 = n->field222 = 0;

        if (tail != 0)
            tail->next = n;
        n->next = 0;
    }

    return BRUSH_LastAllocatedNode;
}
