typedef signed long LONG;

extern LONG GCOMMAND_ProcessCtrlCommand(char *cmdPtr);

void ESQ_InvokeGcommandInit(void *cmdPtr)
{
    GCOMMAND_ProcessCtrlCommand((char *)cmdPtr);
}
