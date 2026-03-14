#include <exec/types.h>
extern LONG DISPTEXT_InitBuffersPending;
extern char *DISPTEXT_TextBufferPtr;
extern char *Global_REF_1000_BYTES_ALLOCATED_1;
extern char *Global_REF_1000_BYTES_ALLOCATED_2;
extern const char Global_STR_DISPTEXT_C_2[];
extern const char Global_STR_DISPTEXT_C_3[];
extern const char Global_STR_DISPTEXT_C_4[];
extern const char Global_STR_DISPTEXT_C_5[];

extern void DISPLIB_ResetLineTables(void);
extern void DISPLIB_ResetTextBufferAndLineTables(void);
extern char *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const char *tagName, LONG line, LONG size, LONG flags);
extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *tagName, LONG line, char *memoryBlock, LONG byteSize);

void DISPTEXT_InitBuffers(void)
{
    if (DISPTEXT_InitBuffersPending == 0) {
        return;
    }

    DISPTEXT_TextBufferPtr = 0;
    DISPLIB_ResetLineTables();
    DISPTEXT_InitBuffersPending = 0;

    Global_REF_1000_BYTES_ALLOCATED_1 = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_DISPTEXT_C_2,
        320,
        1000,
        (LONG)0x00010001UL);

    Global_REF_1000_BYTES_ALLOCATED_2 = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_DISPTEXT_C_3,
        321,
        1000,
        (LONG)0x00010001UL);
}

void DISPTEXT_FreeBuffers(void)
{
    DISPLIB_ResetTextBufferAndLineTables();

    if (Global_REF_1000_BYTES_ALLOCATED_1 != 0) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_DISPTEXT_C_4,
            338,
            Global_REF_1000_BYTES_ALLOCATED_1,
            1000);
        Global_REF_1000_BYTES_ALLOCATED_1 = 0;
    }

    if (Global_REF_1000_BYTES_ALLOCATED_2 != 0) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_DISPTEXT_C_5,
            343,
            Global_REF_1000_BYTES_ALLOCATED_2,
            1000);
        Global_REF_1000_BYTES_ALLOCATED_2 = 0;
    }
}
