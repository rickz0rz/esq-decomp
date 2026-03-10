typedef signed long LONG;

extern void ESQ_MoveCopperEntryTowardStart(LONG dst_index, LONG src_index);
extern void MEMORY_DeallocateMemory(void *ptr, LONG size);
extern void DISKIO_ForceUiRefreshIfIdle(void);
extern void *BRUSH_CloneBrushRecord(void *srcRec);

void ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(LONG dst_index, LONG src_index){ESQ_MoveCopperEntryTowardStart(dst_index, src_index);}
void ESQIFF_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG size){MEMORY_DeallocateMemory(ptr, size);}
void ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle(void){DISKIO_ForceUiRefreshIfIdle();}
void *ESQIFF_JMPTBL_BRUSH_CloneBrushRecord(void *srcRec){return BRUSH_CloneBrushRecord(srcRec);}
