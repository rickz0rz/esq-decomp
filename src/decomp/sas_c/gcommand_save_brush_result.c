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
    LONG newList;

    newList = 0;
    CTASKS_IffTaskState = (WORD)workPtr[190];

    GROUP_AU_JMPTBL_BRUSH_PopulateBrushList(workPtr, &newList);

    if (CTASKS_IffTaskState == 4 && newList != 0) {
        _LVOForbid(AbsExecBase);
        ESQIFF_LogoBrushListHead = GROUP_AU_JMPTBL_BRUSH_AppendBrushNode(ESQIFF_LogoBrushListHead, newList);
        ESQIFF_LogoBrushListCount += 1;
        _LVOPermit(AbsExecBase);
        return;
    }

    if (CTASKS_IffTaskState == 5 && newList != 0) {
        _LVOForbid(AbsExecBase);
        ESQIFF_GAdsBrushListHead = GROUP_AU_JMPTBL_BRUSH_AppendBrushNode(ESQIFF_GAdsBrushListHead, newList);
        ESQIFF_GAdsBrushListCount += 1;
        _LVOPermit(AbsExecBase);
        return;
    }

    if (CTASKS_IffTaskState == 6 && newList != 0) {
        _LVOForbid(AbsExecBase);
        WDISP_WeatherStatusBrushListHead = newList;
        _LVOPermit(AbsExecBase);
    }
}
