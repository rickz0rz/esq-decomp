#include <exec/types.h>
typedef struct LOCAVAIL_NodeRecord {
    UBYTE tokenIndex0;
    UBYTE pad1;
    UWORD duration2;
    UWORD payloadSize4;
    UBYTE *payload6;
} LOCAVAIL_NodeRecord;

typedef struct LOCAVAIL_FilterState {
    UBYTE mode0;
    UBYTE pad1;
    LONG nodeCount2;
    UBYTE modeChar6;
    UBYTE pad7;
    LONG field8;
    LONG field12;
    UBYTE pad16[4];
    LOCAVAIL_NodeRecord *nodeTable20;
} LOCAVAIL_FilterState;

extern LONG MODE_NEWFILE;
extern const char LOCAVAIL_TAG_UVGTI[];
extern const char LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Save[];
extern const char LOCAVAIL_STR_LA_VER_1_COLON_CURDAY[];
extern const char LOCAVAIL_STR_LA_VER_1_COLON_NXTDAY[];

extern LONG GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(const char *path, LONG mode);
extern LONG GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(LONG handle);
extern LONG GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(LONG handle, const void *buf, LONG len);
extern void GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(LONG handle, LONG value);
extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);

LONG LOCAVAIL_SaveAvailabilityDataFile(void *primaryStatePtr, void *secondaryStatePtr)
{
    LOCAVAIL_FilterState *state;
    LOCAVAIL_FilterState *secondaryState;
    LONG fileHandle;
    LONG result;
    char encodeMap[6];
    char outBuf[128];

    encodeMap[0] = LOCAVAIL_TAG_UVGTI[0];
    encodeMap[1] = LOCAVAIL_TAG_UVGTI[1];
    encodeMap[2] = LOCAVAIL_TAG_UVGTI[2];
    encodeMap[3] = LOCAVAIL_TAG_UVGTI[3];
    encodeMap[4] = LOCAVAIL_TAG_UVGTI[4];
    encodeMap[5] = LOCAVAIL_TAG_UVGTI[5];

    result = 1;
    fileHandle = GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(
        LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Save,
        MODE_NEWFILE);
    if (fileHandle == 0) {
        return 0;
    }

    state = (LOCAVAIL_FilterState *)primaryStatePtr;
    secondaryState = (LOCAVAIL_FilterState *)secondaryStatePtr;
    {
        const char *header = LOCAVAIL_STR_LA_VER_1_COLON_CURDAY;

        for (;;) {
            const char *scan;
            LONG nodeIndex;

            scan = header;
            while (*scan != 0) {
                ++scan;
            }
            GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(
                fileHandle, header, (LONG)(scan - header) + 1);

            GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(fileHandle, (LONG)state->mode0);
            GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(fileHandle, state->nodeCount2);

            outBuf[0] = (char)state->modeChar6;
            outBuf[1] = '\0';
            scan = outBuf;
            while (*scan != 0) {
                ++scan;
            }
            GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(
                fileHandle, outBuf, (LONG)(scan - outBuf) + 1);

            nodeIndex = 0;
            while (nodeIndex < state->nodeCount2) {
                LOCAVAIL_NodeRecord *node;
                LONG payloadIndex;
                LONG payloadLen;

                node = state->nodeTable20 + nodeIndex;
                GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(fileHandle, (LONG)node->tokenIndex0);
                GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(fileHandle, (LONG)node->duration2);
                GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(fileHandle, (LONG)node->payloadSize4);

                payloadLen = (LONG)node->payloadSize4;
                payloadIndex = 0;
                while (payloadIndex < payloadLen) {
                    UBYTE cls;

                    cls = node->payload6[payloadIndex];
                    if (cls < 5) {
                        outBuf[payloadIndex] = encodeMap[cls];
                    } else {
                        outBuf[payloadIndex] = encodeMap[0];
                    }
                    ++payloadIndex;
                }
                outBuf[payloadIndex] = '\0';

                scan = outBuf;
                while (*scan != 0) {
                    ++scan;
                }
                GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(
                    fileHandle, outBuf, (LONG)(scan - outBuf) + 1);

                ++nodeIndex;
            }

            state = secondaryState;
            secondaryState = (LOCAVAIL_FilterState *)0;
            header = LOCAVAIL_STR_LA_VER_1_COLON_NXTDAY;
            if (state == (LOCAVAIL_FilterState *)0) {
                break;
            }
        }
    }

    GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(fileHandle);
    return result;
}
