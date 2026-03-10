typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct GCOMMAND_CtrlPacket {
    UBYTE pad0[4];
    UBYTE type4;
} GCOMMAND_CtrlPacket;

extern LONG GCOMMAND_ProcessCtrlCommand(const UBYTE *cmdPtr);

void ESQ_InvokeGcommandInit(const GCOMMAND_CtrlPacket *cmdPtr, void *unusedA1)
{
    (void)unusedA1;
    GCOMMAND_ProcessCtrlCommand((const UBYTE *)cmdPtr);
}
