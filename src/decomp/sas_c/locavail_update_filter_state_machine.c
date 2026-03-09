typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern LONG LOCAVAIL_FilterModeFlag;
extern LONG LOCAVAIL_FilterStep;
extern LONG LOCAVAIL_FilterClassId;
extern LONG LOCAVAIL_FilterPrevClassId;
extern WORD LOCAVAIL_FilterWindowHalfSpan;
extern WORD LOCAVAIL_FilterCooldownTicks;
extern LONG ESQIFF_GAdsBrushListCount;
extern WORD WDISP_HighlightActive;
extern UBYTE ED_DiagVinModeChar;
extern UBYTE ED_DiagGraphModeChar;
extern UBYTE LOCAVAIL_STR_YYLLZ_FilterStateUpdate[];

extern char *GROUP_AS_JMPTBL_STR_FindCharPtr(const char *text, LONG ch);
extern UBYTE GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask(void);
extern void LOCAVAIL_ResetFilterCursorState(void *statePtr);
extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);

void LOCAVAIL_UpdateFilterStateMachine(void *ctxPtr, void *statePtr)
{
    UBYTE *ctx;
    UBYTE *state;
    UBYTE *node;
    LONG indexA;
    LONG indexB;
    LONG value;

    ctx = (UBYTE *)ctxPtr;
    state = (UBYTE *)statePtr;
    node = (UBYTE *)0;

    if (LOCAVAIL_FilterModeFlag != 1) {
        return;
    }

    if (LOCAVAIL_FilterStep == 0 && LOCAVAIL_FilterClassId == -1) {
        indexA = *(LONG *)(state + 8);
        if (indexA == -1) {
            return;
        }

        indexB = *(LONG *)(state + 12);
        if (indexB == -1) {
            return;
        }

        if (indexA >= 0 && indexA < *(LONG *)(state + 2)) {
            node = *(UBYTE **)(state + 20) + NEWGRID_JMPTBL_MATH_Mulu32(indexA, 10);
        }

        if (node == (UBYTE *)0) {
            return;
        }

        if (indexB < 0 || indexB >= (LONG)*(WORD *)(node + 4)) {
            return;
        }

        value = (LONG)node[6 + indexB];
        LOCAVAIL_FilterClassId = value;
        LOCAVAIL_FilterStep = 1;
        LOCAVAIL_FilterPrevClassId = -1;

        switch (value) {
        case 1:
            if (GROUP_AS_JMPTBL_STR_FindCharPtr((const char *)LOCAVAIL_STR_YYLLZ_FilterStateUpdate, (LONG)ED_DiagVinModeChar) != (char *)0 &&
                GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask() != 0) {
                *(LONG *)(ctx + 20) = 10;
                return;
            }
            LOCAVAIL_ResetFilterCursorState(state);
            return;
        case 2:
            if (ED_DiagGraphModeChar != 'N' && ESQIFF_GAdsBrushListCount != 0) {
                return;
            }
            LOCAVAIL_ResetFilterCursorState(state);
            return;
        case 3:
            if (WDISP_HighlightActive != 0) {
                return;
            }
            LOCAVAIL_ResetFilterCursorState(state);
            return;
        default:
            LOCAVAIL_ResetFilterCursorState(state);
            return;
        }
    }

    if (LOCAVAIL_FilterStep == 1 && LOCAVAIL_FilterClassId != -1) {
        indexA = *(LONG *)(state + 8);
        indexB = *(LONG *)(state + 12);

        if (indexA != -1 && indexB != -1) {
            if (indexA >= 0 && indexA < *(LONG *)(state + 2)) {
                node = *(UBYTE **)(state + 20) + NEWGRID_JMPTBL_MATH_Mulu32(indexA, 10);
            }

            if (node != (UBYTE *)0 &&
                indexB >= 0 &&
                indexB < (LONG)*(WORD *)(node + 4) &&
                *(LONG *)(ctx + 20) < 16) {
                switch (*(LONG *)(ctx + 20)) {
                case 1:
                case 2:
                case 3:
                case 5:
                case 6:
                case 7:
                case 8:
                    LOCAVAIL_FilterCooldownTicks = (WORD)(*(WORD *)(node + 2) - 5);
                    LOCAVAIL_FilterWindowHalfSpan = *(WORD *)(node + 2);
                    *(LONG *)(state + 8) = -1;
                    *(LONG *)(state + 12) = -1;
                    LOCAVAIL_FilterStep = 2;
                    if (LOCAVAIL_FilterClassId == 2 || LOCAVAIL_FilterClassId == 3) {
                        *(LONG *)(ctx + 20) = 4;
                    }
                    return;
                case 4:
                    *(LONG *)(ctx + 20) = 0;
                    return;
                }
                return;
            }
        }
    }

    if (LOCAVAIL_FilterStep == 2 &&
        LOCAVAIL_FilterClassId != -1 &&
        *(LONG *)(state + 8) == -1 &&
        *(LONG *)(state + 12) == -1) {
        *(LONG *)(ctx + 20) = 0;
        return;
    }

    if ((LOCAVAIL_FilterStep == 3 || LOCAVAIL_FilterStep == 4) &&
        LOCAVAIL_FilterClassId != -1 &&
        *(LONG *)(state + 8) == -1 &&
        *(LONG *)(state + 12) == -1) {
        if (*(LONG *)(ctx + 20) < 16) {
            switch (*(LONG *)(ctx + 20)) {
            case 1:
            case 2:
            case 3:
            case 5:
            case 6:
            case 7:
            case 8:
                if (LOCAVAIL_FilterClassId == 1) {
                    *(WORD *)(ctx + 24) = 3;
                }
                LOCAVAIL_FilterClassId = -1;
                LOCAVAIL_FilterStep = 0;
                LOCAVAIL_FilterWindowHalfSpan = -1;
                return;
            case 4:
                *(LONG *)(ctx + 20) = 0;
                return;
            }
            return;
        }
    }

    LOCAVAIL_ResetFilterCursorState(state);
}
