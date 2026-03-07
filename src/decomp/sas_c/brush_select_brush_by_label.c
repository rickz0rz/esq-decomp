typedef unsigned char UBYTE;
typedef long LONG;

enum {
    BRUSH_NULL_BYTE = 0,
    BRUSH_COMPARE_EQUAL = 0,
    BRUSH_LABEL_COMPARE_LEN = 2,
    BRUSH_CODE_BUFFER_LEN = 3,
    BRUSH_CODE_TERMINATOR_INDEX = 2,
    BRUSH_NODE_LABEL_OFFSET = 0x21,
    BRUSH_NODE_NEXT_OFFSET = 368
};

extern UBYTE BRUSH_LabelScratch[];
extern void *ESQIFF_BrushIniListHead;
extern void *BRUSH_SelectedNode;
extern void *BRUSH_ScriptPrimarySelection;
extern void *BRUSH_ScriptSecondarySelection;
extern const UBYTE BRUSH_STR_ALIAS_CODE_00[];
extern const UBYTE BRUSH_STR_ALIAS_CODE_11[];
extern const UBYTE BRUSH_STR_ALIAS_CODE_DT[];
extern const UBYTE BRUSH_STR_FALLBACK_DITHER[];

LONG GROUP_AA_JMPTBL_STRING_CompareN(const void *lhs, const void *rhs, LONG n);
void GROUP_AG_JMPTBL_STRING_CopyPadNul(void *dst, const void *src, LONG n);
void *BRUSH_FindBrushByPredicate(void *key, void *list_head_ptr);

void BRUSH_SelectBrushByLabel(const UBYTE *brushLabel)
{
    void *nodeCursor;
    UBYTE aliasCode[BRUSH_CODE_BUFFER_LEN];
    const UBYTE *labelCursor;
    UBYTE *scratchCursor;

    labelCursor = brushLabel;
    scratchCursor = BRUSH_LabelScratch;
    do {
        *scratchCursor++ = *labelCursor;
    } while (*labelCursor++ != (UBYTE)BRUSH_NULL_BYTE);

    nodeCursor = ESQIFF_BrushIniListHead;
    BRUSH_SelectedNode = (void *)BRUSH_NULL_BYTE;

    if (GROUP_AA_JMPTBL_STRING_CompareN(brushLabel, BRUSH_STR_ALIAS_CODE_00, BRUSH_LABEL_COMPARE_LEN) ==
            BRUSH_COMPARE_EQUAL ||
        GROUP_AA_JMPTBL_STRING_CompareN(brushLabel, BRUSH_STR_ALIAS_CODE_11, BRUSH_LABEL_COMPARE_LEN) ==
            BRUSH_COMPARE_EQUAL) {
        GROUP_AG_JMPTBL_STRING_CopyPadNul(aliasCode, BRUSH_STR_ALIAS_CODE_DT, BRUSH_LABEL_COMPARE_LEN);
    } else {
        GROUP_AG_JMPTBL_STRING_CopyPadNul(aliasCode, brushLabel, BRUSH_LABEL_COMPARE_LEN);
    }
    aliasCode[BRUSH_CODE_TERMINATOR_INDEX] = BRUSH_NULL_BYTE;

    while (nodeCursor != (void *)BRUSH_NULL_BYTE) {
        UBYTE *node;

        node = (UBYTE *)nodeCursor;
        if (GROUP_AA_JMPTBL_STRING_CompareN(node + BRUSH_NODE_LABEL_OFFSET, aliasCode, BRUSH_LABEL_COMPARE_LEN) ==
            BRUSH_COMPARE_EQUAL) {
            BRUSH_SelectedNode = nodeCursor;
        }
        nodeCursor = *(void **)(node + BRUSH_NODE_NEXT_OFFSET);
    }

    if (BRUSH_SelectedNode == (void *)BRUSH_NULL_BYTE) {
        BRUSH_SelectedNode = BRUSH_FindBrushByPredicate(BRUSH_STR_FALLBACK_DITHER, &ESQIFF_BrushIniListHead);
    }

    BRUSH_ScriptPrimarySelection = BRUSH_SelectedNode;
    BRUSH_ScriptSecondarySelection = BRUSH_SelectedNode;
}
