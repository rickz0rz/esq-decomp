#include <exec/types.h>
extern void *BRUSH_AppendBrushNode(void *head, void *node);
extern void BRUSH_PopulateBrushList(void *descriptorList, void **outHeadPtr);

LONG GROUP_AU_JMPTBL_BRUSH_AppendBrushNode(LONG head, LONG newNode)
{
    return (LONG)BRUSH_AppendBrushNode((void *)head, (void *)newNode);
}

void GROUP_AU_JMPTBL_BRUSH_PopulateBrushList(void *ctx, LONG *outList)
{
    BRUSH_PopulateBrushList(ctx, (void **)outList);
}
