typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

#define MEMF_PUBLIC 0x00000001L
#define MEMF_CLEAR  0x00010000L

extern UBYTE WDISP_CharClassTable[];
extern UBYTE LOCAVAIL_TAG_FV[];
extern const char Global_STR_LOCAVAIL_C_6[];

extern char *GROUP_AS_JMPTBL_STR_FindCharPtr(const char *text, LONG ch);
extern LONG NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(const char *text);
extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern void *NEWGRID_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);
extern void LOCAVAIL_ResetFilterStateStruct(void *state);
extern LONG LOCAVAIL_AllocNodeArraysForState(void *state);
extern void LOCAVAIL_FreeResourceChain(void *state);
extern void LOCAVAIL_CopyFilterStateStructRetainRefs(void *dst_state, const void *src_state);

LONG LOCAVAIL_ParseFilterStateFromBuffer(const UBYTE *buffer, void *statePtr)
{
    UBYTE *state;
    UBYTE scratchState[24];
    char parseBuf[6];
    LONG success;
    LONG nodeCount;
    LONG nodeIndex;

    state = (UBYTE *)statePtr;
    success = 1;
    LOCAVAIL_ResetFilterStateStruct(scratchState);

    scratchState[0] = *buffer++;
    parseBuf[0] = (char)*buffer++;
    if ((WDISP_CharClassTable[(UBYTE)parseBuf[0]] & 0x02U) != 0) {
        parseBuf[0] = (char)((UBYTE)parseBuf[0] - 32);
    }

    if (GROUP_AS_JMPTBL_STR_FindCharPtr((const char *)LOCAVAIL_TAG_FV, (LONG)(UBYTE)parseBuf[0]) != (char *)0) {
        scratchState[6] = (UBYTE)parseBuf[0];

        parseBuf[0] = (char)*buffer++;
        parseBuf[1] = (char)*buffer++;
        parseBuf[2] = '\0';
        nodeCount = NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(parseBuf);
        *(LONG *)(scratchState + 2) = nodeCount;

        if (LOCAVAIL_AllocNodeArraysForState(scratchState) != 0) {
            nodeIndex = 0;
            while (success != 0 && nodeIndex < nodeCount) {
                UBYTE *node;
                LONG payloadIndex;
                LONG payloadLen;

                if (*buffer++ != 18) {
                    success = 0;
                    break;
                }

                node = *(UBYTE **)(scratchState + 20) + NEWGRID_JMPTBL_MATH_Mulu32(nodeIndex, 10);

                parseBuf[0] = (char)*buffer++;
                parseBuf[1] = (char)*buffer++;
                parseBuf[2] = '\0';
                node[0] = (UBYTE)NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(parseBuf);
                if (node[0] == 0 || node[0] >= 100) {
                    success = 0;
                    break;
                }

                parseBuf[0] = (char)*buffer++;
                parseBuf[1] = (char)*buffer++;
                parseBuf[2] = (char)*buffer++;
                parseBuf[3] = (char)*buffer++;
                parseBuf[4] = '\0';
                *(unsigned short *)(node + 2) =
                    (unsigned short)NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(parseBuf);
                if (*(signed short *)(node + 2) <= 0 || *(unsigned short *)(node + 2) >= 0x0E11U) {
                    success = 0;
                    break;
                }

                parseBuf[0] = (char)*buffer++;
                parseBuf[1] = (char)*buffer++;
                parseBuf[2] = '\0';
                *(unsigned short *)(node + 4) =
                    (unsigned short)NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(parseBuf);
                payloadLen = (LONG)*(unsigned short *)(node + 4);
                if (*(signed short *)(node + 4) <= 0 || payloadLen >= 100) {
                    success = 0;
                    break;
                }

                *(UBYTE **)(node + 6) = (UBYTE *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(
                    Global_STR_LOCAVAIL_C_6, 341, payloadLen, MEMF_PUBLIC + MEMF_CLEAR);
                if (*(UBYTE **)(node + 6) == (UBYTE *)0) {
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

                    payload = *(UBYTE **)(node + 6) + payloadIndex;
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
        LOCAVAIL_CopyFilterStateStructRetainRefs(state, scratchState);
    } else {
        LOCAVAIL_FreeResourceChain(scratchState);
    }

    return success;
}
