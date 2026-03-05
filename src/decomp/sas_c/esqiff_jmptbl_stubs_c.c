extern void ESQ_MoveCopperEntryTowardStart(void);
extern void MEMORY_DeallocateMemory(void);
extern void DISKIO_ForceUiRefreshIfIdle(void);
extern void BRUSH_CloneBrushRecord(void);

void ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(void){ESQ_MoveCopperEntryTowardStart();}
void ESQIFF_JMPTBL_MEMORY_DeallocateMemory(void){MEMORY_DeallocateMemory();}
void ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle(void){DISKIO_ForceUiRefreshIfIdle();}
void ESQIFF_JMPTBL_BRUSH_CloneBrushRecord(void){BRUSH_CloneBrushRecord();}
