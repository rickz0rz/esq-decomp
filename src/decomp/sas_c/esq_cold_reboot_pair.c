extern void *AbsExecBase;
extern void _LVOColdReboot(void *execBase);
extern long _LVOSupervisor(void *execBase, void *entry);
extern void ESQ_SupervisorColdReboot(void);

void ESQ_ColdRebootViaSupervisor(void)
{
    _LVOSupervisor(AbsExecBase, (void *)ESQ_SupervisorColdReboot);
}

void ESQ_ColdReboot(void)
{
    unsigned short version = *(unsigned short *)((unsigned char *)AbsExecBase + 20);
    if (version < 0x24u) {
        ESQ_ColdRebootViaSupervisor();
        return;
    }
    _LVOColdReboot(AbsExecBase);
}
