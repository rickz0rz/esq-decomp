typedef signed long LONG;

extern LONG Global_REF_LONG_FILE_SCRATCH;
extern void GROUP_AZ_JMPTBL_ESQ_ColdReboot(void);

LONG LOCAVAIL2_DisplayAlertDelayAndReboot(void)
{
    volatile LONG *scratchRef;
    LONG i;

    scratchRef = &Global_REF_LONG_FILE_SCRATCH;
    (void)scratchRef;

    i = 0;
    while (i < 0xF4240) {
        i += 1;
    }

    GROUP_AZ_JMPTBL_ESQ_ColdReboot();
    return 0;
}
