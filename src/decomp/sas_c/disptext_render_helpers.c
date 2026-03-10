typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef signed short WORD;
typedef signed long LONG;

extern LONG DISPTEXT_ControlMarkerXOffsetPx;
extern LONG DISPTEXT_LineWidthPx;
extern WORD DISPTEXT_CurrentLineIndex;
extern WORD DISPTEXT_TargetLineIndex;
extern char *DISPTEXT_LinePtrTable[];
extern WORD DISPTEXT_LineLengthTable[];
extern LONG DISPTEXT_LinePenTable[];
extern WORD DISPTEXT_ControlMarkersEnabledFlag;
extern UBYTE DISPTEXT_InsetNibbleSecondary;
extern UBYTE DISPTEXT_InsetNibblePrimary;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void DISPTEXT_FinalizeLineTable(void);
extern LONG _LVOSetAPen(void *gfxBase, char *rp, LONG pen);
extern LONG _LVOSetDrMd(void *gfxBase, char *rp, LONG drawMode);
extern LONG _LVOMove(void *gfxBase, char *rp, LONG x, LONG y);
extern void _LVOText(void *gfxBase, char *rp, const char *text, LONG count);
extern char *GROUP_AI_JMPTBL_STR_FindCharPtr(const char *text, LONG ch);
extern void GROUP_AI_JMPTBL_TLIBA1_DrawTextWithInsetSegments(
    char *rp,
    LONG x,
    LONG y,
    LONG insetSecondary,
    LONG insetPrimary,
    const char *text);

void DISPTEXT_RenderCurrentLine(char *rp, LONG x, LONG y)
{
    LONG idx;
    char *linePtr;
    LONG lineLen;
    UBYTE savedByte;

    DISPTEXT_FinalizeLineTable();
    DISPTEXT_ControlMarkerXOffsetPx = 0;

    if (DISPTEXT_LineWidthPx <= 0) {
        return;
    }

    idx = (LONG)(UWORD)DISPTEXT_CurrentLineIndex;
    if (idx >= (LONG)(UWORD)DISPTEXT_TargetLineIndex) {
        return;
    }

    linePtr = DISPTEXT_LinePtrTable[idx];
    if (linePtr == (char *)0) {
        return;
    }

    lineLen = (LONG)(UWORD)DISPTEXT_LineLengthTable[idx];
    if (lineLen <= 0) {
        return;
    }

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, DISPTEXT_LinePenTable[idx]);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rp, 0);

    savedByte = (UBYTE)linePtr[lineLen];
    linePtr[lineLen] = 0;

    if (DISPTEXT_ControlMarkersEnabledFlag != 0 &&
        GROUP_AI_JMPTBL_STR_FindCharPtr(linePtr, 19) != (char *)0 &&
        GROUP_AI_JMPTBL_STR_FindCharPtr(linePtr, 20) != (char *)0) {
        GROUP_AI_JMPTBL_TLIBA1_DrawTextWithInsetSegments(
            rp,
            x,
            y,
            (LONG)DISPTEXT_InsetNibbleSecondary,
            (LONG)DISPTEXT_InsetNibblePrimary,
            linePtr);
        DISPTEXT_ControlMarkerXOffsetPx = 4;
    } else {
        _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, x, y);
        _LVOText(Global_REF_GRAPHICS_LIBRARY, rp, linePtr, lineLen);
    }

    linePtr[lineLen] = (char)savedByte;
    DISPTEXT_CurrentLineIndex = (WORD)((UWORD)DISPTEXT_CurrentLineIndex + 1);
}
