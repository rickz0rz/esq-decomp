#include "esq_types.h"

/*
 * Target 699 GCC trial function.
 * Resolve brush label aliases and update active script brush selections.
 */
extern u8 BRUSH_LabelScratch[];
extern void *ESQIFF_BrushIniListHead;
extern void *BRUSH_SelectedNode;
extern void *BRUSH_ScriptPrimarySelection;
extern void *BRUSH_ScriptSecondarySelection;
extern u8 BRUSH_STR_ALIAS_CODE_00[];
extern u8 BRUSH_STR_ALIAS_CODE_11[];
extern u8 BRUSH_STR_ALIAS_CODE_DT[];
extern u8 BRUSH_STR_FALLBACK_DITHER[];

s32 GROUP_AA_JMPTBL_STRING_CompareN(const void *lhs, const void *rhs, s32 n) __attribute__((noinline));
void GROUP_AG_JMPTBL_STRING_CopyPadNul(void *dst, const void *src, s32 n) __attribute__((noinline));
void *BRUSH_FindBrushByPredicate(void *key, void *list_head_ptr) __attribute__((noinline));

void BRUSH_SelectBrushByLabel(const u8 *label) __attribute__((noinline, used));

void BRUSH_SelectBrushByLabel(const u8 *label)
{
    void *cur;
    u8 code[3];
    const u8 *src;
    u8 *dst;

    src = label;
    dst = BRUSH_LabelScratch;
    do {
        *dst++ = *src;
    } while (*src++ != 0);

    cur = ESQIFF_BrushIniListHead;
    BRUSH_SelectedNode = 0;

    if (GROUP_AA_JMPTBL_STRING_CompareN(label, BRUSH_STR_ALIAS_CODE_00, 2) == 0 ||
        GROUP_AA_JMPTBL_STRING_CompareN(label, BRUSH_STR_ALIAS_CODE_11, 2) == 0) {
        GROUP_AG_JMPTBL_STRING_CopyPadNul(code, BRUSH_STR_ALIAS_CODE_DT, 2);
    } else {
        GROUP_AG_JMPTBL_STRING_CopyPadNul(code, label, 2);
    }
    code[2] = 0;

    while (cur != 0) {
        u8 *node = (u8 *)cur;
        if (GROUP_AA_JMPTBL_STRING_CompareN(node + 0x21, code, 2) == 0) {
            BRUSH_SelectedNode = cur;
        }
        cur = *(void **)(node + 368);
    }

    if (BRUSH_SelectedNode == 0) {
        BRUSH_SelectedNode = BRUSH_FindBrushByPredicate(BRUSH_STR_FALLBACK_DITHER, &ESQIFF_BrushIniListHead);
    }

    BRUSH_ScriptPrimarySelection = BRUSH_SelectedNode;
    BRUSH_ScriptSecondarySelection = BRUSH_SelectedNode;
}
