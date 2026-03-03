#include <stdint.h>

extern uint8_t Global_PTR_AUD1_DMA;
extern int16_t CTRL_Bit4CaptureDelayCounter;
extern int16_t CTRL_Bit4CapturePhase;
extern int16_t CTRL_SampleEntryCount;

void ESQ_InitAudio1Dma(void) {
    volatile uint16_t *const custom16 = (volatile uint16_t *)0x00DFF000UL;
    volatile uint32_t *const custom32 = (volatile uint32_t *)0x00DFF000UL;

    /* AUD1LCH/LCL */
    custom32[0x0B0 / 4] = (uint32_t)(uintptr_t)&Global_PTR_AUD1_DMA;
    /* AUD1LEN */
    custom16[0x0B4 / 2] = 1;
    /* AUD1VOL */
    custom16[0x0B8 / 2] = 0;
    /* AUD1PER */
    custom16[0x0B6 / 2] = 0x065B;
    /* DMACON */
    custom16[0x0096 / 2] = 0x8202;

    CTRL_Bit4CaptureDelayCounter = 0;
    CTRL_Bit4CapturePhase = 0;
    CTRL_SampleEntryCount = 0;
}

