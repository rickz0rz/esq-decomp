#include <exec/types.h>

/* Original MEMORY_AllocateMemory is a 4-arg debug allocator (file, line, size,
   flags) reading size/flags at args 3/4; the restored core was simplified to
   (size, flags). This wrapper preserves the 4-arg call ABI every caller uses and
   forwards size/flags to the 2-arg core. */
extern void *MEMORY_AllocateMemory(LONG byteSize, LONG attributes);

void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *file, LONG line,
                                            LONG byteSize, LONG attributes)
{
    (void)file; (void)line;
    return MEMORY_AllocateMemory(byteSize, attributes);
}
