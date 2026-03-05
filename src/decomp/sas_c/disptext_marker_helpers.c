typedef signed long LONG;

extern LONG DISPTEXT_ControlMarkerWidthPx;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers(void);
extern LONG _LVOTextLength(void);

void DISPTEXT_ComputeMarkerWidths(void *rp, LONG a, LONG b)
{
    char m0;
    char m1;
    char m2;
    char m3;
    LONG w1;
    LONG w2;

    GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers(a, b, &m3, &m2, &m1, &m0);

    if (m0 != 0) {
        w1 = _LVOTextLength(rp, &m0, 1);
    } else {
        w1 = 0;
    }

    if (m2 != 0) {
        w2 = _LVOTextLength(rp, &m2, 1);
    } else {
        w2 = 0;
    }

    DISPTEXT_ControlMarkerWidthPx = w1 + w2;
}
