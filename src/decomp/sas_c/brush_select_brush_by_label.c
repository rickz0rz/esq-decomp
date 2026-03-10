typedef unsigned char UBYTE;
typedef long LONG;
typedef unsigned long ULONG;

enum {
    BRUSH_NULL_BYTE = 0,
    BRUSH_LABEL_COMPARE_LEN = 2,
    BRUSH_CODE_BUFFER_LEN = 3,
    BRUSH_NODE_LABEL_OFFSET = 0x21,
    BRUSH_NODE_NEXT_OFFSET = 368
};

extern char BRUSH_LabelScratch[];
extern void *ESQIFF_BrushIniListHead;
extern void *BRUSH_SelectedNode;
extern void *BRUSH_ScriptPrimarySelection;
extern void *BRUSH_ScriptSecondarySelection;
extern const char BRUSH_STR_ALIAS_CODE_00[];
extern const char BRUSH_STR_ALIAS_CODE_11[];
extern const char BRUSH_STR_ALIAS_CODE_DT[];
extern const char BRUSH_STR_FALLBACK_DITHER[];

LONG GROUP_AA_JMPTBL_STRING_CompareN(const void *lhs, const void *rhs, LONG n);
char *GROUP_AG_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, ULONG n);
void *BRUSH_FindBrushByPredicate(const void *key, void *list_head_ptr);

typedef struct BRUSH_Node {
    UBYTE pad0[BRUSH_NODE_LABEL_OFFSET];
    char label[BRUSH_NODE_NEXT_OFFSET - BRUSH_NODE_LABEL_OFFSET];
    struct BRUSH_Node *next;
} BRUSH_Node;

void BRUSH_SelectBrushByLabel(const char *brushLabel)
{
    BRUSH_Node *nodeCursor;
    char aliasCode[BRUSH_CODE_BUFFER_LEN];
    const char *labelCursor;
    char *scratchCursor;

    labelCursor = brushLabel;
    scratchCursor = BRUSH_LabelScratch;
    do {
        *scratchCursor++ = *labelCursor;
    } while (*labelCursor++ != BRUSH_NULL_BYTE);

    nodeCursor = (BRUSH_Node *)ESQIFF_BrushIniListHead;
    BRUSH_SelectedNode = (void *)BRUSH_NULL_BYTE;

    if (GROUP_AA_JMPTBL_STRING_CompareN(brushLabel, BRUSH_STR_ALIAS_CODE_00, BRUSH_LABEL_COMPARE_LEN) ==
            0 ||
        GROUP_AA_JMPTBL_STRING_CompareN(brushLabel, BRUSH_STR_ALIAS_CODE_11, BRUSH_LABEL_COMPARE_LEN) ==
            0) {
        GROUP_AG_JMPTBL_STRING_CopyPadNul(aliasCode, BRUSH_STR_ALIAS_CODE_DT, BRUSH_LABEL_COMPARE_LEN);
    } else {
        GROUP_AG_JMPTBL_STRING_CopyPadNul(aliasCode, brushLabel, BRUSH_LABEL_COMPARE_LEN);
    }
    aliasCode[2] = BRUSH_NULL_BYTE;

    while (nodeCursor != (BRUSH_Node *)BRUSH_NULL_BYTE) {
        if (GROUP_AA_JMPTBL_STRING_CompareN(nodeCursor->label, aliasCode, BRUSH_LABEL_COMPARE_LEN) ==
            0) {
            BRUSH_SelectedNode = (void *)nodeCursor;
        }
        nodeCursor = nodeCursor->next;
    }

    if (BRUSH_SelectedNode == (void *)BRUSH_NULL_BYTE) {
        BRUSH_SelectedNode = BRUSH_FindBrushByPredicate(BRUSH_STR_FALLBACK_DITHER, &ESQIFF_BrushIniListHead);
    }

    BRUSH_ScriptPrimarySelection = BRUSH_SelectedNode;
    BRUSH_ScriptSecondarySelection = BRUSH_SelectedNode;
}
