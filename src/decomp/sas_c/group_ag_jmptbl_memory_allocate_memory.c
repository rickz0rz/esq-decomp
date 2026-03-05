typedef signed long LONG;

extern void *MEMORY_AllocateMemory(LONG byteSize, LONG attributes);

void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(LONG byteSize, LONG attributes)
{
    return MEMORY_AllocateMemory(byteSize, attributes);
}
