typedef signed long LONG;

extern void MEMORY_DeallocateMemory(void *memoryBlock, LONG byteSize);

void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(void *memoryBlock, LONG byteSize)
{
    MEMORY_DeallocateMemory(memoryBlock, byteSize);
}
