typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID2_Context {
    UBYTE pad0[32];
    LONG selectedState;
    UBYTE pad1[24];
    UBYTE rastPort[1];
} NEWGRID2_Context;

typedef struct NEWGRID2_StateEntry {
    char *entryPtr;
    char *auxPtr;
    UBYTE pad0[12];
    WORD rowSlot;
} NEWGRID2_StateEntry;

extern LONG NEWGRID_RenderStateLatch;
extern WORD NEWGRID_PrimeTimeLayoutEnable;
extern const char Global_STR_NEWGRID2_C_1[];
extern const char Global_STR_NEWGRID2_C_2[];

extern void *SCRIPT_JMPTBL_MEMORY_AllocateMemory(const char *tagName, LONG line, LONG size, LONG flags);
extern void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(const char *tagName, LONG line, void *ptr, LONG bytes);

extern void NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(LONG x, LONG height, LONG pen);
extern LONG NEWGRID_TestPrimeTimeWindow(LONG rowSlot, const void *entryHead);
extern void NEWGRID_DrawGridEntry(
    char *layoutCtx,
    char *entryPtr,
    char *auxPtr,
    UWORD rowSlot,
    UWORD style,
    LONG enableMarkers,
    LONG mode
);
extern void NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(LONG index);
extern LONG NEWGRID_AppendShowtimesForRow(char *gridCtx, char *entryCtx, char *scratch, LONG keyValue);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(char *layoutCtx, const char *scratch);
extern LONG NEWGRID_DrawGridFrameVariant4(char *gridCtx);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(LONG layoutMode);

LONG NEWGRID2_ProcessGridState(char *gridCtx, char *entryCtx, LONG keyValue)
{
    NEWGRID2_Context *grid = (NEWGRID2_Context *)gridCtx;
    NEWGRID2_StateEntry *entry = (NEWGRID2_StateEntry *)entryCtx;
    char *scratch = 0;
    WORD rowSlot;

    if (grid == 0) {
        NEWGRID_RenderStateLatch = 4;
        return NEWGRID_RenderStateLatch;
    }

    switch (NEWGRID_RenderStateLatch) {
        case 4:
            if (entry->entryPtr == 0) {
                return NEWGRID_RenderStateLatch;
            }
            if (entry->auxPtr == 0) {
                return NEWGRID_RenderStateLatch;
            }

            NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(612, 20, 1);
            rowSlot = entry->rowSlot;
            if (rowSlot > 48) {
                rowSlot = (WORD)(rowSlot - 0x30);
            }

            if (NEWGRID_PrimeTimeLayoutEnable != 0 &&
                NEWGRID_TestPrimeTimeWindow((LONG)rowSlot, entry->entryPtr) == 0) {
                NEWGRID_DrawGridEntry(
                    grid->rastPort,
                    entry->entryPtr,
                    entry->auxPtr,
                    (UWORD)rowSlot,
                    1,
                    1,
                    3
                );
            } else {
                NEWGRID_DrawGridEntry(
                    grid->rastPort,
                    entry->entryPtr,
                    entry->auxPtr,
                    (UWORD)rowSlot,
                    3,
                    1,
                    3
                );
            }

            scratch = SCRIPT_JMPTBL_MEMORY_AllocateMemory(
                Global_STR_NEWGRID2_C_1, 3947, 2000, 0x10001
            );
            if (scratch != 0) {
                NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex(3);
                NEWGRID_AppendShowtimesForRow(gridCtx, (char *)entry, scratch, keyValue);
                NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(grid->rastPort, scratch);
                SCRIPT_JMPTBL_MEMORY_DeallocateMemory(Global_STR_NEWGRID2_C_2, 3953, scratch, 2000);
            }

            if (NEWGRID_DrawGridFrameVariant4(gridCtx) != 0) {
                NEWGRID_RenderStateLatch = 4;
            } else {
                NEWGRID_RenderStateLatch = 5;
            }
            grid->selectedState = NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(2);
            break;

        case 5:
            if (NEWGRID_DrawGridFrameVariant4(gridCtx) != 0) {
                NEWGRID_RenderStateLatch = 4;
            } else {
                NEWGRID_RenderStateLatch = 5;
            }
            grid->selectedState = -1;
            break;

        default:
            NEWGRID_RenderStateLatch = 4;
            break;
    }

    return NEWGRID_RenderStateLatch;
}
