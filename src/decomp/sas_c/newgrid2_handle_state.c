typedef signed long LONG;
typedef signed short WORD;

typedef struct NEWGRID2_SelectionWindow {
    void *entry;
    void *aux;
    LONG index;
    LONG start;
    LONG end;
    WORD row;
    WORD initialRow;
    WORD rowLimit;
} NEWGRID2_SelectionWindow;

extern LONG NEWGRID2_DispatchStateIndex;
extern LONG NEWGRID2_CachedModeIndex;
extern LONG NEWGRID2_ShowtimesSelectionContextPtr;

extern LONG NEWGRID2_ProcessGridState(char *gridCtx, const void *selectionCtxPtr, LONG modeSel);
extern void NEWGRID_InitSelectionWindowAlt(NEWGRID2_SelectionWindow *selectionCtxPtr, WORD rowIndex, LONG modeSel);
extern LONG NEWGRID_UpdateSelectionFromInputAlt(LONG stateIndex, NEWGRID2_SelectionWindow *selectionCtxPtr, LONG modeSel);
extern void NEWGRID_DrawShowtimesPrompt(char *gridCtx, LONG selectionCtx, LONG modeSel);
extern LONG NEWGRID_TestModeFlagActive(LONG modeSel);
extern LONG NEWGRID_ValidateSelectionCode(char *gridCtx, LONG limit);
extern LONG NEWGRID_GetGridModeIndex(void);
extern LONG NEWGRID_ComputeColumnIndex(char *gridCtx);
extern void NEWGRID_ClearMarkersIfSelectable(LONG modeSel, LONG rowIndex);

LONG NEWGRID2_HandleGridState(char *gridCtx, WORD rowIndex, LONG modeSel)
{
    LONG d5 = 0;
    LONG d0;

    if (gridCtx == 0) {
        if (NEWGRID2_DispatchStateIndex == 5) {
            NEWGRID2_ProcessGridState(gridCtx, (char *)&NEWGRID2_ShowtimesSelectionContextPtr, modeSel);
        }
        NEWGRID2_DispatchStateIndex = 0;
        goto return_state;
    }

    switch (NEWGRID2_DispatchStateIndex) {
        case 0:
            NEWGRID_InitSelectionWindowAlt((NEWGRID2_SelectionWindow *)&NEWGRID2_ShowtimesSelectionContextPtr, rowIndex, modeSel);
            /* fallthrough */
        case 1:
            d0 = NEWGRID_UpdateSelectionFromInputAlt(
                NEWGRID2_DispatchStateIndex,
                (NEWGRID2_SelectionWindow *)&NEWGRID2_ShowtimesSelectionContextPtr,
                modeSel
            );
            if (d0 == 0) {
                NEWGRID2_DispatchStateIndex = 0;
                goto return_state;
            }
            NEWGRID_DrawShowtimesPrompt(gridCtx, NEWGRID2_ShowtimesSelectionContextPtr, modeSel);
            NEWGRID2_DispatchStateIndex = 3;
            NEWGRID2_CachedModeIndex = 0;
            goto return_state;
        case 3:
        case 4:
            NEWGRID_UpdateSelectionFromInputAlt(
                NEWGRID2_DispatchStateIndex,
                (NEWGRID2_SelectionWindow *)&NEWGRID2_ShowtimesSelectionContextPtr,
                modeSel
            );
            d5 = NEWGRID_TestModeFlagActive(modeSel);
            /* fallthrough */
        case 5:
            if (NEWGRID2_ShowtimesSelectionContextPtr == 0) {
                NEWGRID2_DispatchStateIndex = 1;
                goto return_state;
            }
            NEWGRID2_DispatchStateIndex = NEWGRID2_ProcessGridState(
                gridCtx, (char *)&NEWGRID2_ShowtimesSelectionContextPtr, modeSel
            );
            d0 = NEWGRID_TestModeFlagActive(modeSel);
            if (d0 == 0) {
                goto return_state;
            }
            if (d5 != 0) {
                if (NEWGRID2_CachedModeIndex < 1) {
                    NEWGRID_ValidateSelectionCode(gridCtx, 50);
                    NEWGRID2_CachedModeIndex = NEWGRID_GetGridModeIndex();
                }
                NEWGRID2_CachedModeIndex -= NEWGRID_ComputeColumnIndex(gridCtx);
            }
            goto return_state;
        case 2:
        default:
            NEWGRID2_DispatchStateIndex = 0;
            break;
    }

return_state:
    if (NEWGRID2_DispatchStateIndex == 0) {
        NEWGRID_ClearMarkersIfSelectable(modeSel, (LONG)rowIndex);
    }
    return NEWGRID2_DispatchStateIndex;
}
