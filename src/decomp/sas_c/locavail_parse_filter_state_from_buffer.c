#include <exec/types.h>
#define MEMF_PUBLIC 0x00000001L
#define MEMF_CLEAR  0x00010000L

extern const UBYTE WDISP_CharClassTable[];
extern const char LOCAVAIL_TAG_FV[];
extern const char Global_STR_LOCAVAIL_C_6[];

extern char *GROUP_AS_JMPTBL_STR_FindCharPtr(const char *text, LONG ch);
extern LONG PARSE_ReadSignedLongSkipClass3_Alt(const char *text);
extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern void *NEWGRID_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);
extern void LOCAVAIL_ResetFilterStateStruct(void *state);
extern LONG LOCAVAIL_AllocNodeArraysForState(void *state);
extern void LOCAVAIL_FreeResourceChain(void *state);
extern void LOCAVAIL_CopyFilterStateStructRetainRefs(void *dst_state, const void *src_state);

typedef struct LOCAVAIL_NodeRecord {
    UBYTE tokenIndex;
    UBYTE pad1;
    UWORD duration;
    UWORD payloadSize;
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
    ULONG *sharedRef;
    LOCAVAIL_NodeRecord *nodeTable;
} LOCAVAIL_FilterState;

LONG LOCAVAIL_ParseFilterStateFromBuffer(const UBYTE *buffer, void *statePtr)
{
    LOCAVAIL_FilterState *state;
    LOCAVAIL_FilterState scratchState;
    char parseBuf[6];
    LONG success;
    LONG nodeCount;
    LONG nodeIndex;

    state = (LOCAVAIL_FilterState *)statePtr;
    success = 1;
    LOCAVAIL_ResetFilterStateStruct(&scratchState);

    scratchState.groupCode = *buffer++;
    parseBuf[0] = (char)*buffer++;
    if ((WDISP_CharClassTable[(UBYTE)parseBuf[0]] & 0x02U) != 0) {
        parseBuf[0] = (char)((UBYTE)parseBuf[0] - 32);
    }

    if (GROUP_AS_JMPTBL_STR_FindCharPtr(LOCAVAIL_TAG_FV, (LONG)(UBYTE)parseBuf[0]) != (char *)0) {
        scratchState.modeChar = (UBYTE)parseBuf[0];

        parseBuf[0] = (char)*buffer++;
        parseBuf[1] = (char)*buffer++;
        parseBuf[2] = '\0';
        nodeCount = PARSE_ReadSignedLongSkipClass3_Alt(parseBuf);
        scratchState.nodeCount = nodeCount;

        if (LOCAVAIL_AllocNodeArraysForState(&scratchState) != 0) {
            nodeIndex = 0;
            while (success != 0 && nodeIndex < nodeCount) {
                LOCAVAIL_NodeRecord *node;
                LONG payloadIndex;
                LONG payloadLen;

                if (*buffer++ != 18) {
                    success = 0;
                    break;
                }

                node = &scratchState.nodeTable[NEWGRID_JMPTBL_MATH_Mulu32(nodeIndex, 1)];

                parseBuf[0] = (char)*buffer++;
                parseBuf[1] = (char)*buffer++;
                parseBuf[2] = '\0';
                node->tokenIndex = (UBYTE)PARSE_ReadSignedLongSkipClass3_Alt(parseBuf);
                if (node->tokenIndex == 0 || node->tokenIndex >= 100) {
                    success = 0;
                    break;
                }

                parseBuf[0] = (char)*buffer++;
                parseBuf[1] = (char)*buffer++;
                parseBuf[2] = (char)*buffer++;
                parseBuf[3] = (char)*buffer++;
                parseBuf[4] = '\0';
                node->duration = (UWORD)PARSE_ReadSignedLongSkipClass3_Alt(parseBuf);
                if ((LONG)(short)node->duration <= 0 || node->duration >= 0x0E11U) {
                    success = 0;
                    break;
                }

                parseBuf[0] = (char)*buffer++;
                parseBuf[1] = (char)*buffer++;
                parseBuf[2] = '\0';
                node->payloadSize = (UWORD)PARSE_ReadSignedLongSkipClass3_Alt(parseBuf);
                payloadLen = (LONG)node->payloadSize;
                if ((LONG)(short)node->payloadSize <= 0 || payloadLen >= 100) {
                    success = 0;
                    break;
                }

                node->payload = (UBYTE *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(
                    Global_STR_LOCAVAIL_C_6, 341, payloadLen, MEMF_PUBLIC + MEMF_CLEAR);
                if (node->payload == (UBYTE *)0) {
                    success = 0;
                    break;
                }

                payloadIndex = 0;
                while (success != 0 && payloadIndex < payloadLen) {
                    UBYTE c;
                    UBYTE normalized;
                    UBYTE *payload;

                    c = *buffer++;
                    normalized = c;
                    if ((WDISP_CharClassTable[c] & 0x02U) != 0) {
                        normalized = (UBYTE)(normalized - 32);
                    }

                    payload = node->payload + payloadIndex;
                    switch (normalized) {
                    case '0':
                    case 'L':
                    case 'U':
                        *payload = 0;
                        break;
                    case 'V':
                        *payload = 1;
                        break;
                    case 'G':
                        *payload = 2;
                        break;
                    case 'T':
                        *payload = 3;
                        break;
                    case 'I':
                        *payload = 4;
                        break;
                    default:
                        *payload = 0;
                        success = 0;
                        break;
                    }

                    ++payloadIndex;
                }

                ++nodeIndex;
            }
        } else if (nodeCount != 0) {
            success = 0;
        }
    } else {
        success = 0;
    }

    if (success != 0) {
        LOCAVAIL_FreeResourceChain(state);
        LOCAVAIL_CopyFilterStateStructRetainRefs(state, &scratchState);
    } else {
        LOCAVAIL_FreeResourceChain(&scratchState);
    }

    return success;
}
