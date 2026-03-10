typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

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
    const UBYTE COMMAND_STATE_RING = 1;
    const UBYTE COMMAND_PROBE_DRIVE_A = 15;
    const UBYTE COMMAND_PROBE_DRIVE_B = 16;
    const LONG STATE_RING_ENTRY_SIZE = 5;
    const LONG STATE_RING_ENTRY_COUNT = 20;
    const LONG STATE_RING_INDEX_RESET = 0;
    const LONG RESULT_DONE = 0;
    const WORD DRIVE_PROBE_REQUESTED = 1;
    const LONG EXEC_COMPARE_REJECT = -1;
    LONG rc;
    UBYTE type;
    if (cmdPtr == 0) {
        return RESULT_DONE;
    }

    type = cmdPtr->type4;

    if (type == COMMAND_STATE_RING) {
        GCOMMAND_StateRingEntry *entry =
            &ED_StateRingTable[ED_StateRingWriteIndex];
        rc = GROUP_AV_JMPTBL_EXEC_CallVector_48(cmdPtr, entry, STATE_RING_ENTRY_SIZE, 0);
        if (rc > 0 && rc != EXEC_COMPARE_REJECT) {
            ED_StateRingWriteIndex += 1;
            if (ED_StateRingWriteIndex >= STATE_RING_ENTRY_COUNT) {
                ED_StateRingWriteIndex = STATE_RING_INDEX_RESET;
            }
        }
    } else if (type == COMMAND_PROBE_DRIVE_B || type == COMMAND_PROBE_DRIVE_A) {
        GCOMMAND_DriveProbeRequestedFlag = DRIVE_PROBE_REQUESTED;
    }

    return RESULT_DONE;
}
