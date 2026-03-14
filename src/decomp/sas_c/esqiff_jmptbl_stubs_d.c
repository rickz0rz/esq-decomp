#include <exec/types.h>
extern void ESQ_MoveCopperEntryTowardEnd(LONG src_index, LONG dst_index);
extern void *BRUSH_FindBrushByPredicate(void *searchKey, void *listHeadPtr);
extern void BRUSH_FreeBrushList(void **headPtr, LONG freeAll);
extern void *BRUSH_FindType3Brush(void *listHeadPtr);

void ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(LONG src_index, LONG dst_index){ESQ_MoveCopperEntryTowardEnd(src_index, dst_index);}
void *ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate(void *searchKey, void *listHeadPtr){return BRUSH_FindBrushByPredicate(searchKey, listHeadPtr);}
void ESQIFF_JMPTBL_BRUSH_FreeBrushList(void **headPtr, LONG freeAll){BRUSH_FreeBrushList(headPtr, freeAll);}
void *ESQIFF_JMPTBL_BRUSH_FindType3Brush(void *listHeadPtr){return BRUSH_FindType3Brush(listHeadPtr);}
