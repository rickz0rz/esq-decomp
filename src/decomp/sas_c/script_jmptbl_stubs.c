#include <exec/types.h>
extern void MEMORY_DeallocateMemory(const void *tagName, LONG line, void *ptr, LONG bytes);
extern LONG DISKIO_WriteBufferedBytes(LONG handle, const void *buffer, LONG len);
extern LONG DISKIO_CloseBufferedFileAndFlush(LONG handle);
extern void *MEMORY_AllocateMemory(const void *tagName, LONG line, LONG bytes, LONG flags);
extern LONG DISKIO_OpenFileWithBuffer(const char *path, LONG mode);

void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(const void *tagName, LONG line, void *ptr, LONG bytes){MEMORY_DeallocateMemory(tagName, line, ptr, bytes);}
LONG SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(LONG handle, const void *buffer, LONG len){return DISKIO_WriteBufferedBytes(handle, buffer, len);}
LONG SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(LONG handle){return DISKIO_CloseBufferedFileAndFlush(handle);}
void *SCRIPT_JMPTBL_MEMORY_AllocateMemory(const void *tagName, LONG line, LONG bytes, LONG flags){return MEMORY_AllocateMemory(tagName, line, bytes, flags);}
LONG SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer(const char *path, LONG mode){return DISKIO_OpenFileWithBuffer(path, mode);}
