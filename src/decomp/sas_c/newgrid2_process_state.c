typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern LONG NEWGRID_RenderStateLatch;
extern WORD NEWGRID_PrimeTimeLayoutEnable;
extern UBYTE Global_STR_NEWGRID2_C_1;
extern UBYTE Global_STR_NEWGRID2_C_2;

extern void *SCRIPT_JMPTBL_MEMORY_AllocateMemory(UBYTE *tagName, LONG line, LONG size, LONG flags);
extern void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(UBYTE *tagName, LONG line, void *ptr, LONG bytes);

extern void NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(LONG x, LONG height, LONG pen);
extern LONG NEWGRID_TestPrimeTimeWindow(LONG rowSlot, void *entryHead);
extern LONG NEWGRID_DrawGridEntry(
    void *layoutCtx,
    void *entryPtr,
    void *auxPtr,
    LONG rowSlot,
    LONG style,
    LONG enableMarkers,
    LONG mode
);
extern void NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(LONG index);
extern LONG NEWGRID_AppendShowtimesForRow(void *gridCtx, void *entryCtx, void *scratch, LONG keyValue);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(void *layoutCtx, void *scratch);
extern LONG NEWGRID_DrawGridFrameVariant4(void *gridCtx);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(LONG layoutMode);

LONG NEWGRID2_ProcessGridState(void *gridCtx, void *entryCtx, LONG keyValue)
{
    UBYTE *grid = (UBYTE *)gridCtx;
    UBYTE *entry = (UBYTE *)entryCtx;
    void *scratch = 0;
    WORD rowSlot;

    if (grid == 0) {
        NEWGRID_RenderStateLatch = 4;
        return NEWGRID_RenderStateLatch;
    }

    switch (NEWGRID_RenderStateLatch) {
        case 4:
            if (*(void **)(entry + 0) == 0) {
                return NEWGRID_RenderStateLatch;
            }
            if (*(void **)(entry + 4) == 0) {
                return NEWGRID_RenderStateLatch;
            }

            NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(612, 20, 1);
            rowSlot = *(WORD *)(entry + 20);
            if (rowSlot > 48) {
                rowSlot = (WORD)(rowSlot - 0x30);
            }

            if (NEWGRID_PrimeTimeLayoutEnable != 0 &&
                NEWGRID_TestPrimeTimeWindow((LONG)rowSlot, *(void **)(entry + 0)) == 0) {
                NEWGRID_DrawGridEntry(
                    grid + 60,
                    *(void **)(entry + 0),
                    *(void **)(entry + 4),
                    (LONG)rowSlot,
                    1,
                    1,
                    3
                );
            } else {
                NEWGRID_DrawGridEntry(
                    grid + 60,
                    *(void **)(entry + 0),
                    *(void **)(entry + 4),
                    (LONG)rowSlot,
                    3,
                    1,
                    3
                );
            }

            scratch = SCRIPT_JMPTBL_MEMORY_AllocateMemory(
                &Global_STR_NEWGRID2_C_1, 3947, 2000, 0x10001
            );
            if (scratch != 0) {
                NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(3);
                NEWGRID_AppendShowtimesForRow(grid, entry, scratch, keyValue);
                NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(grid + 60, scratch);
                SCRIPT_JMPTBL_MEMORY_DeallocateMemory(&Global_STR_NEWGRID2_C_2, 3953, scratch, 2000);
            }

            if (NEWGRID_DrawGridFrameVariant4(grid) != 0) {
                NEWGRID_RenderStateLatch = 4;
            } else {
                NEWGRID_RenderStateLatch = 5;
            }
            *(LONG *)(grid + 32) = NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(2);
            break;

        case 5:
            if (NEWGRID_DrawGridFrameVariant4(grid) != 0) {
                NEWGRID_RenderStateLatch = 4;
            } else {
                NEWGRID_RenderStateLatch = 5;
            }
            *(LONG *)(grid + 32) = -1;
            break;

        default:
            NEWGRID_RenderStateLatch = 4;
            break;
    }

    return NEWGRID_RenderStateLatch;
}
