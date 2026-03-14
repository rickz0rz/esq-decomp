#include <exec/types.h>
enum {
    LOCAVAIL2_REBOOT_DELAY_SPIN_COUNT = 0xF4240
};

extern LONG Global_REF_LONG_FILE_SCRATCH;
extern void GROUP_AZ_JMPTBL_ESQ_ColdReboot(void);

LONG LOCAVAIL2_DisplayAlertDelayAndReboot(void)
{
    volatile LONG *scratchRef;
    LONG i;

    scratchRef = &Global_REF_LONG_FILE_SCRATCH;
    (void)scratchRef;

    i = 0;
    while (i < LOCAVAIL2_REBOOT_DELAY_SPIN_COUNT) {
        i += 1;
    }

    GROUP_AZ_JMPTBL_ESQ_ColdReboot();
    return 0;
}
