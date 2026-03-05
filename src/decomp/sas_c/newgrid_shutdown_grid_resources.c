typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern void *NEWGRID_MainRastPortPtr;
extern WORD NEWGRID_GridResourcesInitializedFlag;
extern UBYTE Global_STR_NEWGRID_C_3;

extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(UBYTE *tagName, LONG line, void *ptr, LONG bytes);
extern void NEWGRID2_FreeBuffersIfAllocated(void);
extern void NEWGRID_JMPTBL_DISPTEXT_FreeBuffers(void);
extern void NEWGRID_ResetShowtimeBuckets(void);

void NEWGRID_ShutdownGridResources(void)
{
    if (NEWGRID_MainRastPortPtr != 0) {
        NEWGRID_JMPTBL_MEMORY_DeallocateMemory(&Global_STR_NEWGRID_C_3, 148, NEWGRID_MainRastPortPtr, 100);
    }

    NEWGRID2_FreeBuffersIfAllocated();
    NEWGRID_JMPTBL_DISPTEXT_FreeBuffers();
    NEWGRID_GridResourcesInitializedFlag = 0;
    NEWGRID_ResetShowtimeBuckets();
}
