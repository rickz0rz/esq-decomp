typedef signed long LONG;

extern LONG PARALLEL_CheckReadyStub(void);

LONG PARALLEL_CheckReadyStub(void)
{
    return -1;
}

LONG PARALLEL_CheckReady(void)
{
    return PARALLEL_CheckReadyStub();
}

void PARALLEL_WaitReady(void)
{
    while (PARALLEL_CheckReady() < 0) {
    }
}
