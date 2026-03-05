extern void MEMORY_DeallocateMemory(void);
extern void DISKIO_WriteBufferedBytes(void);
extern void DISKIO_CloseBufferedFileAndFlush(void);
extern void MEMORY_AllocateMemory(void);
extern void DISKIO_OpenFileWithBuffer(void);

void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(void){MEMORY_DeallocateMemory();}
void SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(void){DISKIO_WriteBufferedBytes();}
void SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(void){DISKIO_CloseBufferedFileAndFlush();}
void SCRIPT_JMPTBL_MEMORY_AllocateMemory(void){MEMORY_AllocateMemory();}
void SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer(void){DISKIO_OpenFileWithBuffer();}
