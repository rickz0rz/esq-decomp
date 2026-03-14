#include <exec/types.h>
extern WORD CTASKS_IffTaskState;
extern void *AbsExecBase;

extern LONG ESQIFF_LogoBrushListHead;
extern LONG ESQIFF_LogoBrushListCount;
extern LONG ESQIFF_GAdsBrushListHead;
extern LONG ESQIFF_GAdsBrushListCount;
extern LONG WDISP_WeatherStatusBrushListHead;

extern void BRUSH_PopulateBrushList(void *descriptorList, void **outHeadPtr);
extern void *BRUSH_AppendBrushNode(void *head, void *node);
extern void _LVOForbid(void *execBase);
extern void _LVOPermit(void *execBase);

void GCOMMAND_SaveBrushResult(UBYTE *workPtr)
{
    const LONG NEWLIST_EMPTY = 0;
    const LONG WORK_TASKSTATE_OFFSET = 190;
    const WORD TASKSTATE_LOGO = 4;
    const WORD TASKSTATE_GADS = 5;
    const WORD TASKSTATE_WEATHER = 6;
    const LONG COUNTER_STEP = 1;
    void *newList;

    newList = (void *)NEWLIST_EMPTY;
    CTASKS_IffTaskState = (WORD)workPtr[WORK_TASKSTATE_OFFSET];

    BRUSH_PopulateBrushList(workPtr, &newList);

    if (CTASKS_IffTaskState == TASKSTATE_LOGO && newList != (void *)NEWLIST_EMPTY) {
        _LVOForbid(AbsExecBase);
        ESQIFF_LogoBrushListHead = (LONG)BRUSH_AppendBrushNode((void *)ESQIFF_LogoBrushListHead, newList);
        ESQIFF_LogoBrushListCount += COUNTER_STEP;
        _LVOPermit(AbsExecBase);
        return;
    }

    if (CTASKS_IffTaskState == TASKSTATE_GADS && newList != (void *)NEWLIST_EMPTY) {
        _LVOForbid(AbsExecBase);
        ESQIFF_GAdsBrushListHead = (LONG)BRUSH_AppendBrushNode((void *)ESQIFF_GAdsBrushListHead, newList);
        ESQIFF_GAdsBrushListCount += COUNTER_STEP;
        _LVOPermit(AbsExecBase);
        return;
    }

    if (CTASKS_IffTaskState == TASKSTATE_WEATHER && newList != (void *)NEWLIST_EMPTY) {
        _LVOForbid(AbsExecBase);
        WDISP_WeatherStatusBrushListHead = (LONG)newList;
        _LVOPermit(AbsExecBase);
    }
}
