#include <exec/types.h>

/* Core MEMORY_Allocate/DeallocateMemory are 2-arg (size,flags)/(ptr,size); the
   4-arg (file,line,...) call ABI is bridged here by forwarding only args 3/4. */
extern void MEMORY_DeallocateMemory(void *ptr, LONG bytes);
extern LONG DISKIO_WriteBufferedBytes(LONG handle, const void *buffer, LONG len);
extern LONG DISKIO_CloseBufferedFileAndFlush(LONG handle);
extern void *MEMORY_AllocateMemory(LONG bytes, LONG flags);
extern LONG DISKIO_OpenFileWithBuffer(const char *path, LONG mode);

void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(const void *tagName, LONG line, void *ptr, LONG bytes){(void)tagName;(void)line;MEMORY_DeallocateMemory(ptr, bytes);}
LONG SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(LONG handle, const void *buffer, LONG len){return DISKIO_WriteBufferedBytes(handle, buffer, len);}
LONG SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(LONG handle){return DISKIO_CloseBufferedFileAndFlush(handle);}
void *SCRIPT_JMPTBL_MEMORY_AllocateMemory(const void *tagName, LONG line, LONG bytes, LONG flags){(void)tagName;(void)line;return MEMORY_AllocateMemory(bytes, flags);}
LONG SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer(const char *path, LONG mode){return DISKIO_OpenFileWithBuffer(path, mode);}
