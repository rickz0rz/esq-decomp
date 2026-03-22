#include "tliba3_view_mode_types.h"

typedef struct TLIBA3_PatternWordPair {
    UWORD reg;
    UWORD value;
} TLIBA3_PatternWordPair;

typedef struct TLIBA3_PatternEntry {
    TLIBA3_PatternWordPair pair[19];
} TLIBA3_PatternEntry;

enum {
    VM_PATTERN_COUNT = 10,
    VM_BASE_DDF = 40
};

extern UBYTE TLIBA3_VmArrayPatternTable[];
extern UBYTE TLIBA3_VmArrayRuntimeTable[];
extern WORD TLIBA1_PatternTableInitGuard;

extern LONG MATH_DivS32(LONG left, LONG right);
extern LONG MATH_Mulu32(LONG left, LONG right);
extern void TLIBA3_InitRuntimeEntries(void);

void TLIBA3_InitPatternTable(void)
{
    static const UWORD regWords[19] = {
        0x008e, 0x0090, 0x0092, 0x0094, 0x0108, 0x010a, 0x0100, 0x0102, 0x0104,
        0x00e0, 0x00e2, 0x00e4, 0x00e6, 0x00e8, 0x00ea, 0x00ec, 0x00ee, 0x00f0, 0x00f2
    };
    LONG viewModeIndex;

    TLIBA1_PatternTableInitGuard = 1;
    TLIBA3_InitRuntimeEntries();

    for (viewModeIndex = 0; viewModeIndex < VM_PATTERN_COUNT; ++viewModeIndex) {
        TLIBA3_PatternEntry *pattern;
        TLIBA3_ViewModeRuntimeEntry *runtime;
        LONG xValue;
        LONG halfX;
        LONG xDiv16;
        LONG xRemainder;
        LONG xHalfRemainderScaled;
        LONG baseDdfStart;
        LONG ddfWidthDivisor;
        LONG diwWidthDivisor;
        LONG horizontalStop;
        LONG moduloValue;
        LONG ddfModulo;
        LONG bitplaneSpanBytes;
        ULONG planeValue;
        LONG i;

        pattern = (TLIBA3_PatternEntry *)(TLIBA3_VmArrayPatternTable + MATH_Mulu32(viewModeIndex, TLIBA3_VM_PATTERN_STRIDE));
        runtime = (TLIBA3_ViewModeRuntimeEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewModeIndex, TLIBA3_VM_RUNTIME_STRIDE));

        for (i = 0; i < 19; ++i) {
            pattern->pair[i].reg = regWords[i];
        }

        xValue = (LONG)(WORD)runtime->x6;
        halfX = xValue / 2;
        xDiv16 = MATH_DivS32(xValue, 16);
        xRemainder = (LONG)((WORD)xValue % 16);

        if (xRemainder != 0) {
            xHalfRemainderScaled = (xRemainder / 2) * 17;
        } else {
            xHalfRemainderScaled = 0;
        }

        baseDdfStart = VM_BASE_DDF + xDiv16;
        pattern->pair[2].value = (UWORD)baseDdfStart;

        ddfWidthDivisor = (runtime->flags0 & 0x8000U) ? 4 : 2;
        pattern->pair[3].value = (UWORD)(baseDdfStart + MATH_DivS32((LONG)(UWORD)runtime->width2, ddfWidthDivisor));

        diwWidthDivisor = (runtime->flags0 & 0x8000U) ? 2 : 1;
        horizontalStop = ((97 + halfX + MATH_DivS32((LONG)(UWORD)runtime->width2, diwWidthDivisor)) & 0xff) + 0xff00;

        pattern->pair[0].value = (UWORD)(((97 + halfX) & 0xff) + 0x1700);
        pattern->pair[1].value = (UWORD)horizontalStop;

        if (runtime->flags0 & 0x0004U) {
            bitplaneSpanBytes = (((LONG)(UWORD)runtime->width2 + 15) >> 3) & 0xfffe;
        } else {
            bitplaneSpanBytes = 0;
        }

        if (viewModeIndex != 0) {
            if ((runtime->flags0 & 0x8004U) == 0x8004U || (runtime->flags0 & 0x8000U)) {
                bitplaneSpanBytes -= 4;
            } else {
                bitplaneSpanBytes -= 2;
            }
        }

        pattern->pair[4].value = (UWORD)bitplaneSpanBytes;
        pattern->pair[5].value = (UWORD)bitplaneSpanBytes;

        moduloValue = (LONG)((WORD)runtime->flags0);
        ddfModulo = xHalfRemainderScaled;

        pattern->pair[6].value = (UWORD)moduloValue;
        pattern->pair[7].value = (UWORD)ddfModulo;
        pattern->pair[8].value = 0x0024;

        planeValue = runtime->planePtr118;
        pattern->pair[9].value = (UWORD)(planeValue >> 16);
        pattern->pair[10].value = (UWORD)planeValue;

        planeValue = runtime->planePtr122;
        pattern->pair[11].value = (UWORD)(planeValue >> 16);
        pattern->pair[12].value = (UWORD)planeValue;

        planeValue = runtime->planePtr126;
        pattern->pair[13].value = (UWORD)(planeValue >> 16);
        pattern->pair[14].value = (UWORD)planeValue;

        planeValue = runtime->planePtr130;
        pattern->pair[15].value = (UWORD)(planeValue >> 16);
        pattern->pair[16].value = (UWORD)planeValue;

        planeValue = runtime->planePtr134;
        pattern->pair[17].value = (UWORD)(planeValue >> 16);
        pattern->pair[18].value = (UWORD)planeValue;
    }
}
