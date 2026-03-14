#include <exec/types.h>
#define CUSTOM_BASE 0x00DFF000UL
#define CUSTOM_INTREQ_OFFSET 0x009C
#define INTREQ_SETCLR 0x0100

extern void ESQ_CaptureCtrlBit4Stream(void);
extern void ESQ_CaptureCtrlBit3Stream(void);
extern const char ESQ_STR_B[];

void ESQ_PollCtrlInput(void)
{
    const UBYTE *statusPacket;

    ESQ_CaptureCtrlBit4Stream();

    statusPacket = (const UBYTE *)ESQ_STR_B;
    if (statusPacket[18] == 'N') {
        ESQ_CaptureCtrlBit3Stream();
    }

    *(volatile UWORD *)(CUSTOM_BASE + CUSTOM_INTREQ_OFFSET) = INTREQ_SETCLR;
}
