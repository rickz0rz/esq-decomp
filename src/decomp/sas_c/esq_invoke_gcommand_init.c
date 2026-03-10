typedef signed long LONG;

extern LONG GCOMMAND_ProcessCtrlCommand(char *cmdPtr);

void ESQ_InvokeGcommandInit(void *cmdPtr, void *unusedA1)
{
    (void)unusedA1;
    GCOMMAND_ProcessCtrlCommand((char *)cmdPtr);
}
