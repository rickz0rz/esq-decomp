#include <stdint.h>

extern int32_t ESQ_TryRomWriteTest(void);

int32_t ESQ_SupervisorColdReboot(void) {
    register uint8_t *a0 asm("a0");
    volatile uint16_t *rom;
    uint16_t original;

    a0 = (uint8_t *)0x01000000UL;
    a0 -= *(int32_t *)(a0 - 20);
    a0 = *(uint8_t **)(a0 + 4);
    a0 -= 2;

    __asm__ volatile("reset");
    __asm__ volatile("jmp (%a0)");

    rom = (volatile uint16_t *)0x00FBFFFCUL;
    original = *rom;
    *rom = 0x55AA;
    if (*rom != 0x55AA) {
        return ESQ_TryRomWriteTest();
    }

    *rom = 0xAA55;
    if (*rom != 0xAA55) {
        return ESQ_TryRomWriteTest();
    }

    *rom = original;
    return 0;
}

