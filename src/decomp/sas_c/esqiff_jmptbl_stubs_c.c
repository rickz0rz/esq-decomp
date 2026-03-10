typedef signed long LONG;

extern void ESQ_MoveCopperEntryTowardStart(LONG dst_index, LONG src_index);
extern void MEMORY_DeallocateMemory(void);
extern void DISKIO_ForceUiRefreshIfIdle(void);
extern void *BRUSH_CloneBrushRecord(void *srcRec);

void ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(LONG dst_index, LONG src_index){ESQ_MoveCopperEntryTowardStart(dst_index, src_index);}
void ESQIFF_JMPTBL_MEMORY_DeallocateMemory(void){MEMORY_DeallocateMemory();}
void ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle(void){DISKIO_ForceUiRefreshIfIdle();}
void *ESQIFF_JMPTBL_BRUSH_CloneBrushRecord(void *srcRec){return BRUSH_CloneBrushRecord(srcRec);}
