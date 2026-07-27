/* RESTORES: GCOMMAND_SaveBrushResult
 * MODULE:   modules/groups/a/u/gcommand4.s
 * STATUS:   behavioural
 *
 * 204 bytes in the original, 200 emitted, 16 differing regions.
 *
 * Reproduces: the task state taken from byte 190 of the descriptor, the populate
 * call receiving the node slot by address, the three state branches each
 * bracketed by Forbid/Permit, the two list appends that write the returned head
 * back and bump a counter, and the state-6 case that simply stores the node.
 *
 * The branch structure is worth getting right and is easy to get subtly wrong.
 * The null-node test does NOT skip to the end -- it falls through to the NEXT
 * state check. So the shape is
 *
 *     if (state == 4 && node)      { ... }
 *     else if (state == 5 && node) { ... }
 *     else if (state == 6 && node) { ... }
 *
 * and not a state dispatch with a shared null guard hoisted above it. With the
 * guard hoisted the code is equivalent only because the state cannot match two
 * values at once; written as the original has it, the equivalence is not being
 * relied on.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fffc                   LINK.W A5,#-4
 *   got:     594f                       SUBQ.W #4,A7
 *   summary: The A5-frame class. The node slot must stay addressable because it
 *            is passed by address, so both compilers keep it on the stack -- only
 *            the base register differs.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the three cross-unit calls.
 */
#include "esq-exec.h"

extern void  GROUP_AU_JMPTBL_BRUSH_PopulateBrushList(unsigned char *desc, void **out);
extern void *GROUP_AU_JMPTBL_BRUSH_AppendBrushNode(void *head, void *node);
extern short CTASKS_IffTaskState;
extern void *ESQIFF_LogoBrushListHead;
extern long  ESQIFF_LogoBrushListCount;
extern void *ESQIFF_GAdsBrushListHead;
extern long  ESQIFF_GAdsBrushListCount;
extern void *WDISP_WeatherStatusBrushListHead;

void GCOMMAND_SaveBrushResult(unsigned char *desc)
{
    void *node;

    node = 0;
    CTASKS_IffTaskState = desc[190];
    GROUP_AU_JMPTBL_BRUSH_PopulateBrushList(desc, &node);

    if (CTASKS_IffTaskState == 4 && node) {
        Forbid();
        ESQIFF_LogoBrushListHead =
            GROUP_AU_JMPTBL_BRUSH_AppendBrushNode(ESQIFF_LogoBrushListHead, node);
        ESQIFF_LogoBrushListCount++;
        Permit();
    } else if (CTASKS_IffTaskState == 5 && node) {
        Forbid();
        ESQIFF_GAdsBrushListHead =
            GROUP_AU_JMPTBL_BRUSH_AppendBrushNode(ESQIFF_GAdsBrushListHead, node);
        ESQIFF_GAdsBrushListCount++;
        Permit();
    } else if (CTASKS_IffTaskState == 6 && node) {
        Forbid();
        WDISP_WeatherStatusBrushListHead = node;
        Permit();
    }
}
