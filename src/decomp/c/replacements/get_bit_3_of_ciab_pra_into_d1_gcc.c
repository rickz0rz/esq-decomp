#include <stdint.h>

void GET_BIT_3_OF_CIAB_PRA_INTO_D1(void) {
    register int32_t d1 asm("d1");

    d1 = *(volatile uint8_t *)0xBFE001UL;
    d1 = ((d1 & 8) == 0) ? -1 : 0;

    __asm__ volatile("" : "+d"(d1));
}

