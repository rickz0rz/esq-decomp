typedef unsigned short UWORD;
typedef unsigned char UBYTE;

enum {
    CUSTOM_BASE = 0x00DFF000UL,
    CUSTOM_INTREQ_OFFSET = 0x009C,
    INTREQ_SETCLR = 0x0100
};

extern void ESQ_CaptureCtrlBit4Stream(void);
extern void ESQ_CaptureCtrlBit3Stream(void);
extern const UBYTE ESQ_STR_B[];

void ESQ_PollCtrlInput(void)
{
    volatile UWORD *custom16;

    ESQ_CaptureCtrlBit4Stream();

    if (ESQ_STR_B[18] == 'N') {
        ESQ_CaptureCtrlBit3Stream();
    }

    custom16 = (volatile UWORD *)CUSTOM_BASE;
    custom16[CUSTOM_INTREQ_OFFSET / 2] = INTREQ_SETCLR;
}
