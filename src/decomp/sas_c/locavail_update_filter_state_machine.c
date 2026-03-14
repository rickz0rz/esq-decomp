#include <exec/types.h>
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
extern const char LOCAVAIL_STR_YYLLZ_FilterStateUpdate[];

extern char *GROUP_AS_JMPTBL_STR_FindCharPtr(const char *text, LONG ch);
extern UBYTE SCRIPT_ReadHandshakeBit5Mask(void);
extern void LOCAVAIL_ResetFilterCursorState(void *statePtr);
extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);

typedef struct LOCAVAIL_NodeRecord {
    UBYTE tokenIndex;
    UBYTE pad1;
    WORD duration;
    WORD payloadSize;
    UBYTE *payload;
} LOCAVAIL_NodeRecord;

typedef struct LOCAVAIL_FilterState {
    UBYTE groupCode;
    UBYTE pad1;
    LONG nodeCount;
    UBYTE modeChar;
    UBYTE pad7;
    LONG selectedNodeIndex;
    LONG selectedPayloadIndex;
    void *sharedRef;
    LOCAVAIL_NodeRecord *nodeTable;
} LOCAVAIL_FilterState;

typedef struct LOCAVAIL_FilterContext {
    UBYTE pad0[20];
    LONG mode20;
    WORD value24;
} LOCAVAIL_FilterContext;

void LOCAVAIL_UpdateFilterStateMachine(void *ctxPtr, void *statePtr)
{
    LOCAVAIL_FilterContext *ctx;
    LOCAVAIL_FilterState *state;
    LOCAVAIL_NodeRecord *node;
    LONG indexA;
    LONG indexB;
    LONG value;

    ctx = (LOCAVAIL_FilterContext *)ctxPtr;
    state = (LOCAVAIL_FilterState *)statePtr;
    node = (LOCAVAIL_NodeRecord *)0;

    if (LOCAVAIL_FilterModeFlag != 1) {
        return;
    }

    if (LOCAVAIL_FilterStep == 0 && LOCAVAIL_FilterClassId == -1) {
        indexA = state->selectedNodeIndex;
        if (indexA == -1) {
            return;
        }

        indexB = state->selectedPayloadIndex;
        if (indexB == -1) {
            return;
        }

        if (indexA >= 0 && indexA < state->nodeCount) {
            node = &state->nodeTable[NEWGRID_JMPTBL_MATH_Mulu32(indexA, 1)];
        }

        if (node == (LOCAVAIL_NodeRecord *)0) {
            return;
        }

        if (indexB < 0 || indexB >= (LONG)node->payloadSize) {
            return;
        }

        value = (LONG)node->payload[indexB];
        LOCAVAIL_FilterClassId = value;
        LOCAVAIL_FilterStep = 1;
        LOCAVAIL_FilterPrevClassId = -1;

        switch (value) {
        case 1:
            if (GROUP_AS_JMPTBL_STR_FindCharPtr(LOCAVAIL_STR_YYLLZ_FilterStateUpdate, (LONG)ED_DiagVinModeChar) != (char *)0 &&
                SCRIPT_ReadHandshakeBit5Mask() != 0) {
                ctx->mode20 = 10;
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
        indexA = state->selectedNodeIndex;
        indexB = state->selectedPayloadIndex;

        if (indexA != -1 && indexB != -1) {
            if (indexA >= 0 && indexA < state->nodeCount) {
                node = &state->nodeTable[NEWGRID_JMPTBL_MATH_Mulu32(indexA, 1)];
            }

            if (node != (LOCAVAIL_NodeRecord *)0 &&
                indexB >= 0 &&
                indexB < (LONG)node->payloadSize &&
                ctx->mode20 < 16) {
                switch (ctx->mode20) {
                case 1:
                case 2:
                case 3:
                case 5:
                case 6:
                case 7:
                case 8:
                    LOCAVAIL_FilterCooldownTicks = (WORD)(node->duration - 5);
                    LOCAVAIL_FilterWindowHalfSpan = node->duration;
                    state->selectedNodeIndex = -1;
                    state->selectedPayloadIndex = -1;
                    LOCAVAIL_FilterStep = 2;
                    if (LOCAVAIL_FilterClassId == 2 || LOCAVAIL_FilterClassId == 3) {
                        ctx->mode20 = 4;
                    }
                    return;
                case 4:
                    ctx->mode20 = 0;
                    return;
                }
                return;
            }
        }
    }

    if (LOCAVAIL_FilterStep == 2 &&
        LOCAVAIL_FilterClassId != -1 &&
        state->selectedNodeIndex == -1 &&
        state->selectedPayloadIndex == -1) {
        ctx->mode20 = 0;
        return;
    }

    if ((LOCAVAIL_FilterStep == 3 || LOCAVAIL_FilterStep == 4) &&
        LOCAVAIL_FilterClassId != -1 &&
        state->selectedNodeIndex == -1 &&
        state->selectedPayloadIndex == -1) {
        if (ctx->mode20 < 16) {
            switch (ctx->mode20) {
            case 1:
            case 2:
            case 3:
            case 5:
            case 6:
            case 7:
            case 8:
                if (LOCAVAIL_FilterClassId == 1) {
                    ctx->value24 = 3;
                }
                LOCAVAIL_FilterClassId = -1;
                LOCAVAIL_FilterStep = 0;
                LOCAVAIL_FilterWindowHalfSpan = -1;
                return;
            case 4:
                ctx->mode20 = 0;
                return;
            }
            return;
        }
    }

    LOCAVAIL_ResetFilterCursorState(state);
}
