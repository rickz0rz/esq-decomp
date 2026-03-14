#include <exec/types.h>
void ESQ_SupervisorColdReboot(void)
{
    volatile ULONG *p;
    ULONG base;
    void (*target)(void);

    p = (volatile ULONG *)0x01000000UL;
    base = 0x01000000UL - *(volatile ULONG *)((volatile unsigned char *)p - 20);
    target = *(void (**)(void))(base + 4UL);
    target = (void (*)(void))((unsigned char *)target - 2);

    target();
}
