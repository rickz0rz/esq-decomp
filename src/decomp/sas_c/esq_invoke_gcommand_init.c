typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG GCOMMAND_ProcessCtrlCommand(const UBYTE *cmdPtr);

void ESQ_InvokeGcommandInit(const void *cmdPtr, void *unusedA1)
{
    (void)unusedA1;
    GCOMMAND_ProcessCtrlCommand((const UBYTE *)cmdPtr);
}
