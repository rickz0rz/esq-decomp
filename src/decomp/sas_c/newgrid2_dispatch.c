typedef signed long LONG;
typedef signed short WORD;

extern LONG NEWGRID2_DispatchGridOperation(LONG operationId, char *gridCtx, WORD rowIndex, WORD selector);

void NEWGRID2_DispatchOperationDefault(void)
{
    NEWGRID2_DispatchGridOperation(0, 0, 0, 0);
}
