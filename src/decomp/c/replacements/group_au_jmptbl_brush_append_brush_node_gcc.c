#include "esq_types.h"

/*
 * Target 194 GCC trial function.
 * Jump-table stub forwarding to BRUSH_AppendBrushNode.
 */
void BRUSH_AppendBrushNode(void) __attribute__((noinline));

void GROUP_AU_JMPTBL_BRUSH_AppendBrushNode(void) __attribute__((noinline, used));

void GROUP_AU_JMPTBL_BRUSH_AppendBrushNode(void)
{
    BRUSH_AppendBrushNode();
}
