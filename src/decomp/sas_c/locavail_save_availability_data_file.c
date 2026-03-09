typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern LONG MODE_NEWFILE;
extern UBYTE LOCAVAIL_TAG_UVGTI[];
extern const char LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Save[];
extern const char LOCAVAIL_STR_LA_VER_1_COLON_CURDAY[];
extern const char LOCAVAIL_STR_LA_VER_1_COLON_NXTDAY[];

extern LONG GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(const char *path, LONG mode);
extern void GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(LONG handle);
extern void GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(LONG handle, const void *buf, LONG len);
extern void GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(LONG handle, LONG value);
extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);

LONG LOCAVAIL_SaveAvailabilityDataFile(void *primaryStatePtr, void *secondaryStatePtr)
{
    UBYTE *state;
    UBYTE *secondaryState;
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

    state = (UBYTE *)primaryStatePtr;
    secondaryState = (UBYTE *)secondaryStatePtr;
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

            GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(fileHandle, (LONG)state[0]);
            GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(fileHandle, *(LONG *)(state + 2));

            outBuf[0] = (char)state[6];
            outBuf[1] = '\0';
            scan = outBuf;
            while (*scan != 0) {
                ++scan;
            }
            GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(
                fileHandle, outBuf, (LONG)(scan - outBuf) + 1);

            nodeIndex = 0;
            while (nodeIndex < *(LONG *)(state + 2)) {
                UBYTE *node;
                LONG payloadIndex;
                LONG payloadLen;

                node = *(UBYTE **)(state + 20) + NEWGRID_JMPTBL_MATH_Mulu32(nodeIndex, 10);
                GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(fileHandle, (LONG)node[0]);
                GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(fileHandle, (LONG)*(UWORD *)(node + 2));
                GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(fileHandle, (LONG)*(UWORD *)(node + 4));

                payloadLen = (LONG)*(UWORD *)(node + 4);
                payloadIndex = 0;
                while (payloadIndex < payloadLen) {
                    UBYTE cls;

                    cls = *(*(UBYTE **)(node + 6) + payloadIndex);
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
            secondaryState = (UBYTE *)0;
            header = LOCAVAIL_STR_LA_VER_1_COLON_NXTDAY;
            if (state == (UBYTE *)0) {
                break;
            }
        }
    }

    GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(fileHandle);
    return result;
}
