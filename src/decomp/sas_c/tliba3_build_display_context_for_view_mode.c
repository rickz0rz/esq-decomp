#include "tliba3_view_mode_types.h"

enum {
    VM_PATTERN_WORD_COUNT = 38,
    VM_PLANE_PTR_PAIR_COUNT = 5
};

enum {
    VM_DDFSTRT_WORD = 5,
    VM_DDFSTOP_WORD = 7,
    VM_BPLCON0_WORD = 13,
    VM_PLANE_PTR_BASE_WORD = 19
};

extern UBYTE TLIBA3_VmArrayPatternTable[];
extern UBYTE TLIBA3_VmArrayRuntimeTable[];
extern UWORD ESQ_CopperEffectTemplateRowsSet0[];
extern UWORD ESQ_CopperEffectTemplateRowsSet1[];
extern WORD TLIBA1_PatternTableInitGuard;
extern LONG TLIBA1_CurrentViewModeIndex;

extern LONG MATH_Mulu32(LONG left, LONG right);
extern void TLIBA3_InitPatternTable(void);
extern void TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag(void);

static LONG TLIBA3_ComputeAlignedWidth(UWORD width)
{
    return ((((LONG)width) + 15) >> 3) & (LONG)0xfffe;
}

static void TLIBA3_AdjustPatternPlanePointers(UWORD *patternWords, LONG offset)
{
    LONG i;

    for (i = 0; i < VM_PLANE_PTR_PAIR_COUNT; ++i) {
        UWORD *pairWords = patternWords + VM_PLANE_PTR_BASE_WORD + (i * 4);
        LONG planePtr;

        planePtr = (((LONG)pairWords[0]) << 16) | (LONG)pairWords[2];
        planePtr += offset;

        pairWords[0] = (UWORD)(((ULONG)planePtr) >> 16);
        pairWords[2] = (UWORD)planePtr;
    }
}

LONG TLIBA3_BuildDisplayContextForViewMode(LONG viewMode, LONG unusedArg1, LONG highlightMode)
{
    UWORD basePattern[VM_PATTERN_WORD_COUNT];
    UWORD templateSet0[VM_PATTERN_WORD_COUNT];
    UWORD templateSet1[VM_PATTERN_WORD_COUNT];
    TLIBA3_ViewModeRuntimeEntry *runtime;
    LONG runtimeOffset;
    LONG patternOffset;
    LONG templateSet0PlaneOffset;
    LONG templateSet1PlaneOffset;
    LONG i;

    (void)unusedArg1;

    TLIBA1_CurrentViewModeIndex = viewMode;
    if (TLIBA1_PatternTableInitGuard == 0) {
        TLIBA3_InitPatternTable();
    }

    patternOffset = MATH_Mulu32(viewMode, TLIBA3_VM_PATTERN_STRIDE);
    for (i = 0; i < VM_PATTERN_WORD_COUNT; ++i) {
        basePattern[i] = ((UWORD *)(TLIBA3_VmArrayPatternTable + patternOffset))[i];
    }

    runtimeOffset = MATH_Mulu32(viewMode, TLIBA3_VM_RUNTIME_STRIDE);
    runtime = (TLIBA3_ViewModeRuntimeEntry *)(TLIBA3_VmArrayRuntimeTable + runtimeOffset);

    if ((runtime->flags0 & 0x8004U) == 0x8004U) {
        templateSet1PlaneOffset = TLIBA3_ComputeAlignedWidth(runtime->width2) - 2;
        templateSet0PlaneOffset = -2;
    } else if ((runtime->flags0 & 0x8000U) != 0) {
        templateSet1PlaneOffset = -2;
        templateSet0PlaneOffset = -2;
    } else if ((runtime->flags0 & 0x0004U) != 0) {
        templateSet1PlaneOffset = TLIBA3_ComputeAlignedWidth(runtime->width2);
        templateSet0PlaneOffset = 0;
    } else {
        templateSet1PlaneOffset = 0;
        templateSet0PlaneOffset = 0;
    }

    if (viewMode == 0) {
        templateSet0PlaneOffset = 0;
        basePattern[VM_DDFSTRT_WORD] += 4;
        basePattern[VM_DDFSTOP_WORD] -= 4;
        templateSet1PlaneOffset = TLIBA3_ComputeAlignedWidth(runtime->width2);
    }

    if (highlightMode != -1) {
        basePattern[VM_BPLCON0_WORD] =
            (UWORD)((runtime->flags0 & 0x8fffU) | ((((UWORD)highlightMode) << 12) & 0x7000U));
    }

    for (i = 0; i < VM_PATTERN_WORD_COUNT; ++i) {
        templateSet0[i] = basePattern[i];
        templateSet1[i] = basePattern[i];
    }

    TLIBA3_AdjustPatternPlanePointers(templateSet0, templateSet0PlaneOffset);
    TLIBA3_AdjustPatternPlanePointers(templateSet1, templateSet1PlaneOffset);

    for (i = 0; i < VM_PATTERN_WORD_COUNT; ++i) {
        ESQ_CopperEffectTemplateRowsSet0[i] = templateSet0[i];
        ESQ_CopperEffectTemplateRowsSet1[i] = templateSet1[i];
    }

    TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag();
    return (LONG)runtime;
}
