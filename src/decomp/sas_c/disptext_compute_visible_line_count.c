typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef signed short WORD;
typedef signed long LONG;

extern WORD DISPTEXT_TargetLineIndex;
extern WORD NEWGRID_RowHeightPx;
extern WORD DISPTEXT_ControlMarkersEnabledFlag;
extern char *DISPTEXT_TextBufferPtrTable[];

extern void DISPTEXT_FinalizeLineTable(void);
extern LONG GROUP_AG_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern char *GROUP_AI_JMPTBL_STR_FindCharPtr(const char *s, LONG ch);

LONG DISPTEXT_ComputeVisibleLineCount(LONG maxLines)
{
    LONG lineCount;
    LONG pixelCount;
    LONG visibleCount;
    char *line;

    DISPTEXT_FinalizeLineTable();

    lineCount = (LONG)(UWORD)DISPTEXT_TargetLineIndex;
    if (lineCount >= maxLines) {
        lineCount = maxLines;
    }

    pixelCount = GROUP_AG_JMPTBL_MATH_Mulu32(lineCount, (LONG)(UWORD)NEWGRID_RowHeightPx);
    if (pixelCount < 0) {
        pixelCount += 3;
    }
    visibleCount = pixelCount >> 2;

    if (lineCount == 1) {
        visibleCount += 2;
    }

    if (DISPTEXT_ControlMarkersEnabledFlag == 0) {
        return visibleCount;
    }

    line = DISPTEXT_TextBufferPtrTable[(UWORD)DISPTEXT_TargetLineIndex];
    if (line == 0) {
        return visibleCount;
    }

    if (GROUP_AI_JMPTBL_STR_FindCharPtr(line, 19) == 0) {
        return visibleCount;
    }

    if (GROUP_AI_JMPTBL_STR_FindCharPtr(line, 20) == 0) {
        return visibleCount;
    }

    return visibleCount + 2;
}
