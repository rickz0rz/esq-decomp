typedef long LONG;

extern void *PARSEINI_ParsedDescriptorListHead;
extern void *BRUSH_SelectedNode;
extern void *ESQFUNC_FallbackType3BrushNode;
extern void *ESQIFF_BrushIniListHead;

extern const char Global_STR_DF0_BRUSH_INI_2[];
extern const char ESQIFF_TAG_DT[];
extern const char ESQIFF_TAG_DITHER[];

extern void DISKIO_ForceUiRefreshIfIdle(void);
extern void BRUSH_FreeBrushList(void **headPtr, LONG freeAll);
extern LONG PARSEINI_ParseIniBufferAndDispatch(const char *path);
extern void BRUSH_PopulateBrushList(void *descriptorList, void **outHeadPtr);
extern void BRUSH_SelectBrushByLabel(const char *brushLabel);
extern void *BRUSH_FindBrushByPredicate(void *searchKey, void *listHeadPtr);
extern void *BRUSH_FindType3Brush(void *listHeadPtr);
extern void DISKIO_ResetCtrlInputStateIfIdle(void);

void ESQIFF_HandleBrushIniReloadHotkey(LONG hotkey)
{
    if ((char)hotkey != 'a') {
        return;
    }

    DISKIO_ForceUiRefreshIfIdle();
    BRUSH_FreeBrushList(&ESQIFF_BrushIniListHead, 0);
    PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_BRUSH_INI_2);
    BRUSH_PopulateBrushList(PARSEINI_ParsedDescriptorListHead, &ESQIFF_BrushIniListHead);
    BRUSH_SelectBrushByLabel(ESQIFF_TAG_DT);

    if (BRUSH_SelectedNode == (void *)0) {
        BRUSH_SelectedNode = BRUSH_FindBrushByPredicate((void *)ESQIFF_TAG_DITHER, &ESQIFF_BrushIniListHead);
    }

    ESQFUNC_FallbackType3BrushNode = BRUSH_FindType3Brush(&ESQIFF_BrushIniListHead);
    DISKIO_ResetCtrlInputStateIfIdle();
}
