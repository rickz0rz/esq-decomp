typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern WORD CTASKS_IffTaskState;
extern void *AbsExecBase;

extern LONG ESQIFF_LogoBrushListHead;
extern LONG ESQIFF_LogoBrushListCount;
extern LONG ESQIFF_GAdsBrushListHead;
extern LONG ESQIFF_GAdsBrushListCount;
extern LONG WDISP_WeatherStatusBrushListHead;

extern void GROUP_AU_JMPTBL_BRUSH_PopulateBrushList(void *ctx, LONG *outList);
extern LONG GROUP_AU_JMPTBL_BRUSH_AppendBrushNode(LONG head, LONG newNode);
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
    LONG newList;

    newList = NEWLIST_EMPTY;
    CTASKS_IffTaskState = (WORD)workPtr[WORK_TASKSTATE_OFFSET];

    GROUP_AU_JMPTBL_BRUSH_PopulateBrushList(workPtr, &newList);

    if (CTASKS_IffTaskState == TASKSTATE_LOGO && newList != NEWLIST_EMPTY) {
        _LVOForbid(AbsExecBase);
        ESQIFF_LogoBrushListHead = GROUP_AU_JMPTBL_BRUSH_AppendBrushNode(ESQIFF_LogoBrushListHead, newList);
        ESQIFF_LogoBrushListCount += COUNTER_STEP;
        _LVOPermit(AbsExecBase);
        return;
    }

    if (CTASKS_IffTaskState == TASKSTATE_GADS && newList != NEWLIST_EMPTY) {
        _LVOForbid(AbsExecBase);
        ESQIFF_GAdsBrushListHead = GROUP_AU_JMPTBL_BRUSH_AppendBrushNode(ESQIFF_GAdsBrushListHead, newList);
        ESQIFF_GAdsBrushListCount += COUNTER_STEP;
        _LVOPermit(AbsExecBase);
        return;
    }

    if (CTASKS_IffTaskState == TASKSTATE_WEATHER && newList != NEWLIST_EMPTY) {
        _LVOForbid(AbsExecBase);
        WDISP_WeatherStatusBrushListHead = newList;
        _LVOPermit(AbsExecBase);
    }
}
