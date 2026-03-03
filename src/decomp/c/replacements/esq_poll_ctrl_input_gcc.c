#include <stdint.h>

extern void ESQ_CaptureCtrlBit4Stream(void);
extern void ESQ_CaptureCtrlBit3Stream(void);
extern uint8_t ESQ_STR_B[];

void ESQ_PollCtrlInput(void) {
    volatile uint16_t *const custom16 = (volatile uint16_t *)0x00DFF000UL;

    ESQ_CaptureCtrlBit4Stream();
    if (ESQ_STR_B[18] == 'N') {
        ESQ_CaptureCtrlBit3Stream();
    }

    /* INTREQ */
    custom16[0x009C / 2] = 0x0100;
}

