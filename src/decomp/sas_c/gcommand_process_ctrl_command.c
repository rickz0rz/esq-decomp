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

extern UBYTE ED_StateRingTable[];
extern LONG ED_StateRingWriteIndex;
extern WORD GCOMMAND_DriveProbeRequestedFlag;

extern LONG GROUP_AV_JMPTBL_EXEC_CallVector_48(void *a0, void *a1, LONG d1, void *a2);

LONG GCOMMAND_ProcessCtrlCommand(const UBYTE *cmdPtr)
{
    const UBYTE COMMAND_STATE_RING = 1;
    const UBYTE COMMAND_PROBE_DRIVE_A = 15;
    const UBYTE COMMAND_PROBE_DRIVE_B = 16;
    const LONG STATE_RING_ENTRY_SIZE = 5;
    const LONG STATE_RING_ENTRY_COUNT = 20;
    LONG rc;
    UBYTE type;
    const GCOMMAND_CtrlPacket *cmdView;

    if (cmdPtr == 0) {
        return 0;
    }

    cmdView = (const GCOMMAND_CtrlPacket *)cmdPtr;
    type = cmdView->type4;

    if (type == COMMAND_STATE_RING) {
        GCOMMAND_StateRingEntry *entry =
            (GCOMMAND_StateRingEntry *)&ED_StateRingTable[ED_StateRingWriteIndex * STATE_RING_ENTRY_SIZE];
        rc = GROUP_AV_JMPTBL_EXEC_CallVector_48((void *)cmdPtr, entry, STATE_RING_ENTRY_SIZE, 0);
        if (rc > 0 && rc != -1) {
            ED_StateRingWriteIndex += 1;
            if (ED_StateRingWriteIndex >= STATE_RING_ENTRY_COUNT) {
                ED_StateRingWriteIndex = 0;
            }
        }
    } else if (type == COMMAND_PROBE_DRIVE_B || type == COMMAND_PROBE_DRIVE_A) {
        GCOMMAND_DriveProbeRequestedFlag = 1;
    }

    return 0;
}
