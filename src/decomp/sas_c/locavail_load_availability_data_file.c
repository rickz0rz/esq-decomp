typedef signed long LONG;
typedef unsigned long ULONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

#define MEMF_PUBLIC 0x00000001L
#define MEMF_CLEAR  0x00010000L
#define WORKBUF_ERROR ((UBYTE *)0xFFFF)

extern LONG Global_REF_LONG_FILE_SCRATCH;
extern UBYTE *Global_PTR_WORK_BUFFER;
extern UBYTE TEXTDISP_PrimaryGroupCode;
extern UBYTE TEXTDISP_SecondaryGroupCode;

extern const char Global_STR_LOCAVAIL_C_7[];
extern const char Global_STR_LOCAVAIL_C_8[];
extern const char LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Load[];
extern UBYTE LOCAVAIL_STR_LA_VER[];

extern LONG GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(const char *path);
extern UBYTE *GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(void);
extern LONG GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(void);
extern LONG GROUP_AY_JMPTBL_STRING_CompareNoCaseN(const char *a, const char *b, LONG n);
extern void LOCAVAIL_ResetFilterStateStruct(void *state);
extern void LOCAVAIL_CopyFilterStateStructRetainRefs(void *dst_state, const void *src_state);
extern LONG LOCAVAIL_AllocNodeArraysForState(void *state);
extern void LOCAVAIL_FreeResourceChain(void *state);
extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern void *NEWGRID_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);

LONG LOCAVAIL_LoadAvailabilityDataFile(void *primaryStatePtr, void *secondaryStatePtr)
{
    UBYTE *primaryState;
    UBYTE *secondaryState;
    UBYTE scratchState[24];
    UBYTE *section;
    LONG success;
    LONG fileLen;
    UBYTE *fileBuf;

    primaryState = (UBYTE *)primaryStatePtr;
    secondaryState = (UBYTE *)secondaryStatePtr;
    success = 1;
    fileBuf = (UBYTE *)0;
    fileLen = 0;

    if (GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Load) == -1) {
        if (primaryState[0] != TEXTDISP_PrimaryGroupCode) {
            LOCAVAIL_FreeResourceChain(primaryState);
            primaryState[0] = TEXTDISP_PrimaryGroupCode;
        }
        if (secondaryState[0] != TEXTDISP_SecondaryGroupCode) {
            LOCAVAIL_FreeResourceChain(secondaryState);
            secondaryState[0] = TEXTDISP_SecondaryGroupCode;
        }
        return 0;
    }

    LOCAVAIL_FreeResourceChain(primaryState);
    primaryState[0] = TEXTDISP_PrimaryGroupCode;
    LOCAVAIL_FreeResourceChain(secondaryState);
    secondaryState[0] = TEXTDISP_SecondaryGroupCode;

    fileLen = Global_REF_LONG_FILE_SCRATCH;
    fileBuf = Global_PTR_WORK_BUFFER;
    section = GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer();
    if (section == WORKBUF_ERROR) {
        section = (UBYTE *)0;
    }

    while (success != 0 &&
           section != (UBYTE *)0 &&
           GROUP_AY_JMPTBL_STRING_CompareNoCaseN((const char *)section, (const char *)LOCAVAIL_STR_LA_VER, 6) == 0) {
        LONG nodeCount;
        LONG nodeIndex;

        LOCAVAIL_ResetFilterStateStruct(scratchState);
        scratchState[0] = (UBYTE)GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer();
        nodeCount = GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer();
        *(LONG *)(scratchState + 2) = nodeCount;
        section = GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer();
        scratchState[6] = *section;

        if (LOCAVAIL_AllocNodeArraysForState(scratchState) == 0) {
            if (nodeCount != 0) {
                success = 0;
            }
        } else {
            nodeIndex = 0;
            while (success != 0 && nodeIndex < nodeCount) {
                UBYTE *node;
                LONG payloadLen;
                UBYTE *encoded;
                LONG payloadIndex;

                node = *(UBYTE **)(scratchState + 20) + NEWGRID_JMPTBL_MATH_Mulu32(nodeIndex, 10);

                node[0] = (UBYTE)GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer();
                if (node[0] == 0 || node[0] >= 100) {
                    success = 0;
                    break;
                }

                *(UWORD *)(node + 2) = (UWORD)GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer();
                if (*(WORD *)(node + 2) <= 0 || *(UWORD *)(node + 2) >= 0x0E11U) {
                    success = 0;
                    break;
                }

                *(UWORD *)(node + 4) = (UWORD)GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer();
                payloadLen = (LONG)*(UWORD *)(node + 4);
                if (*(WORD *)(node + 4) <= 0 || payloadLen >= 100) {
                    success = 0;
                    break;
                }

                *(UBYTE **)(node + 6) = (UBYTE *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(
                    Global_STR_LOCAVAIL_C_7, 786, payloadLen, MEMF_PUBLIC + MEMF_CLEAR);
                if (*(UBYTE **)(node + 6) == (UBYTE *)0) {
                    success = 0;
                    break;
                }

                encoded = GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer();
                if (encoded == WORKBUF_ERROR) {
                    success = 0;
                    break;
                }

                payloadIndex = 0;
                while (success != 0 && payloadIndex < payloadLen) {
                    UBYTE *payload;

                    payload = *(UBYTE **)(node + 6) + payloadIndex;
                    switch (*encoded++) {
                    case 'G':
                        *payload = 2;
                        break;
                    case 'I':
                        *payload = 4;
                        break;
                    case 'T':
                        *payload = 3;
                        break;
                    case 'U':
                        *payload = 0;
                        break;
                    case 'V':
                        *payload = 1;
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
        }

        if (success != 0) {
            if (scratchState[0] == TEXTDISP_PrimaryGroupCode) {
                LOCAVAIL_CopyFilterStateStructRetainRefs(primaryState, scratchState);
            } else if (scratchState[0] == TEXTDISP_SecondaryGroupCode) {
                LOCAVAIL_CopyFilterStateStructRetainRefs(secondaryState, scratchState);
            } else {
                LOCAVAIL_FreeResourceChain(scratchState);
            }
        } else {
            LOCAVAIL_FreeResourceChain(scratchState);
        }

        section = GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer();
        if (section == WORKBUF_ERROR) {
            section = (UBYTE *)0;
        }
    }

    NEWGRID_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_LOCAVAIL_C_8, 897, fileBuf, fileLen + 1);
    return success;
}
