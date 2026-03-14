#include <exec/types.h>
typedef struct GCOMMAND_CtrlPacket {
    UBYTE pad0[4];
    UBYTE type4;
} GCOMMAND_CtrlPacket;

typedef struct GCOMMAND_StateRingEntry {
    UBYTE raw[5];
} GCOMMAND_StateRingEntry;

extern GCOMMAND_StateRingEntry ED_StateRingTable[];
extern LONG ED_StateRingWriteIndex;
extern WORD GCOMMAND_DriveProbeRequestedFlag;

extern LONG GROUP_AV_JMPTBL_EXEC_CallVector_48(const void *a0, void *a1, LONG d1, void *a2);

LONG GCOMMAND_ProcessCtrlCommand(const GCOMMAND_CtrlPacket *cmdPtr)
{
    UBYTE type;
    type = cmdPtr->type4;

    if (type == 1) {
        LONG rc;
        GCOMMAND_StateRingEntry *entry =
            &ED_StateRingTable[ED_StateRingWriteIndex];
        rc = GROUP_AV_JMPTBL_EXEC_CallVector_48(cmdPtr, entry, 5, 0);
        if (rc > 0) {
            if (rc == -1) {
                return 0;
            }

            ED_StateRingWriteIndex += 1;
            if (ED_StateRingWriteIndex >= 20) {
                ED_StateRingWriteIndex = 0;
            }
        }
    } else if (type == 16) {
        GCOMMAND_DriveProbeRequestedFlag = 1;
    } else if (type == 15) {
        GCOMMAND_DriveProbeRequestedFlag = 1;
    }

    return 0;
}
