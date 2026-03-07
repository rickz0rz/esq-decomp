typedef unsigned char UBYTE;
typedef long LONG;

enum {
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

void BRUSH_SelectBrushByLabel(const UBYTE *label)
{
    void *cur;
    UBYTE code[3];
    const UBYTE *src;
    UBYTE *dst;

    src = label;
    dst = BRUSH_LabelScratch;
    do {
        *dst++ = *src;
    } while (*src++ != (UBYTE)0);

    cur = ESQIFF_BrushIniListHead;
    BRUSH_SelectedNode = (void *)0;

    if (GROUP_AA_JMPTBL_STRING_CompareN(label, BRUSH_STR_ALIAS_CODE_00, 2) == 0 ||
        GROUP_AA_JMPTBL_STRING_CompareN(label, BRUSH_STR_ALIAS_CODE_11, 2) == 0) {
        GROUP_AG_JMPTBL_STRING_CopyPadNul(code, BRUSH_STR_ALIAS_CODE_DT, 2);
    } else {
        GROUP_AG_JMPTBL_STRING_CopyPadNul(code, label, 2);
    }
    code[2] = 0;

    while (cur != (void *)0) {
        UBYTE *node;

        node = (UBYTE *)cur;
        if (GROUP_AA_JMPTBL_STRING_CompareN(node + BRUSH_NODE_LABEL_OFFSET, code, 2) == 0) {
            BRUSH_SelectedNode = cur;
        }
        cur = *(void **)(node + BRUSH_NODE_NEXT_OFFSET);
    }

    if (BRUSH_SelectedNode == (void *)0) {
        BRUSH_SelectedNode = BRUSH_FindBrushByPredicate(BRUSH_STR_FALLBACK_DITHER, &ESQIFF_BrushIniListHead);
    }

    BRUSH_ScriptPrimarySelection = BRUSH_SelectedNode;
    BRUSH_ScriptSecondarySelection = BRUSH_SelectedNode;
}
