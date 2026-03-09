typedef signed long LONG;
typedef signed short WORD;
typedef signed char BYTE;
typedef unsigned char UBYTE;

extern LONG LOCAVAIL_FilterStep;
extern LONG LOCAVAIL_FilterPrevClassId;
extern LONG ESQIFF_GAdsBrushListCount;
extern WORD WDISP_HighlightActive;
extern UBYTE ED_DiagVinModeChar;
extern UBYTE ED_DiagGraphModeChar;
extern UBYTE LOCAVAIL_STR_YYLLZ_FilterGateCheck[];

extern char *GROUP_AS_JMPTBL_STR_FindCharPtr(const char *text, LONG ch);
extern UBYTE GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask(void);
extern LONG LOCAVAIL_MapFilterTokenCharToClass(UBYTE token);
extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);

void LOCAVAIL_ComputeFilterOffsetForEntry(const BYTE *text, void *statePtr)
{
    UBYTE *state;
    UBYTE *node;
    UBYTE *payload;
    LONG selectedNodeIndex;
    LONG selectedPayloadIndex;
    LONG textIndex;

    state = (UBYTE *)statePtr;
    selectedNodeIndex = -1;
    payload = (UBYTE *)0;
    selectedPayloadIndex = -1;

    if (LOCAVAIL_FilterStep != 0) {
        *(LONG *)(state + 8) = selectedNodeIndex;
        *(LONG *)(state + 12) = selectedPayloadIndex;
        return;
    }

    if (LOCAVAIL_FilterPrevClassId != -1) {
        *(LONG *)(state + 8) = selectedNodeIndex;
        *(LONG *)(state + 12) = selectedPayloadIndex;
        return;
    }

    textIndex = 0;
    while (*text != 0) {
        LONG mappedClass;
        LONG nodeIndex;
        UBYTE *matchedNode;

        mappedClass = LOCAVAIL_MapFilterTokenCharToClass((UBYTE)*text);
        matchedNode = (UBYTE *)0;
        nodeIndex = 0;

        while (mappedClass != 0 && nodeIndex < *(LONG *)(state + 2)) {
            node = *(UBYTE **)(state + 20) + NEWGRID_JMPTBL_MATH_Mulu32(nodeIndex, 10);
            if ((LONG)node[0] == (textIndex + 1)) {
                payload = *(UBYTE **)(node + 6);
                matchedNode = node;
                break;
            }
            ++nodeIndex;
        }

        if (mappedClass != 0 && matchedNode != (UBYTE *)0) {
            mappedClass -= 1;
            if (mappedClass < (LONG)*(WORD *)(matchedNode + 4) && payload[mappedClass] != 0) {
                if (selectedNodeIndex == -1 && selectedPayloadIndex == -1) {
                    selectedNodeIndex = nodeIndex;
                    selectedPayloadIndex = mappedClass;
                    break;
                }
            }
        }

        ++textIndex;
        ++text;
    }

    if (selectedNodeIndex != -1 && selectedPayloadIndex != -1) {
        LONG gateClass;

        node = *(UBYTE **)(state + 20) + NEWGRID_JMPTBL_MATH_Mulu32(selectedNodeIndex, 10);
        payload = *(UBYTE **)(node + 6);
        gateClass = (LONG)payload[selectedPayloadIndex] - 1;

        switch (gateClass) {
        case 0:
            if (GROUP_AS_JMPTBL_STR_FindCharPtr((const char *)LOCAVAIL_STR_YYLLZ_FilterGateCheck,
                                                (LONG)ED_DiagVinModeChar) == (char *)0 ||
                GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask() == 0) {
                selectedNodeIndex = -1;
                selectedPayloadIndex = -1;
            }
            break;
        case 1:
            if (ED_DiagGraphModeChar == 'N' || ESQIFF_GAdsBrushListCount == 0) {
                selectedNodeIndex = -1;
                selectedPayloadIndex = -1;
            }
            break;
        case 2:
            if (WDISP_HighlightActive == 0) {
                selectedNodeIndex = -1;
                selectedPayloadIndex = -1;
            }
            break;
        case 3:
        default:
            selectedNodeIndex = -1;
            selectedPayloadIndex = -1;
            break;
        }
    }

    *(LONG *)(state + 8) = selectedNodeIndex;
    *(LONG *)(state + 12) = selectedPayloadIndex;
}
