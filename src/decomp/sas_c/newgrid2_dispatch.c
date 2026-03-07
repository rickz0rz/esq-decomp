typedef signed long LONG;

extern LONG NEWGRID2_DispatchGridOperation(LONG a0, LONG a1, LONG a2, LONG a3);

void NEWGRID2_DispatchOperationDefault(void)
{
    NEWGRID2_DispatchGridOperation(0, 0, 0, 0);
}
