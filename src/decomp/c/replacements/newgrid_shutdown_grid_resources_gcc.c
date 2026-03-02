#include "esq_types.h"

extern void *NEWGRID_MainRastPortPtr;
extern s16 NEWGRID_GridResourcesInitializedFlag;
extern const char Global_STR_NEWGRID_C_3[];

void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *tag, s32 line, void *ptr, u32 bytes) __attribute__((noinline));
void NEWGRID2_FreeBuffersIfAllocated(void) __attribute__((noinline));
void NEWGRID_JMPTBL_DISPTEXT_FreeBuffers(void) __attribute__((noinline));
void NEWGRID_ResetShowtimeBuckets(void) __attribute__((noinline));

void NEWGRID_ShutdownGridResources(void) __attribute__((noinline, used));

void NEWGRID_ShutdownGridResources(void)
{
    if (NEWGRID_MainRastPortPtr != (void *)0) {
        NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_NEWGRID_C_3, 148, NEWGRID_MainRastPortPtr, 100);
    }

    NEWGRID2_FreeBuffersIfAllocated();
    NEWGRID_JMPTBL_DISPTEXT_FreeBuffers();
    NEWGRID_GridResourcesInitializedFlag = 0;
    NEWGRID_ResetShowtimeBuckets();
}
