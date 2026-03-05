typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern void ESQ_CaptureCtrlBit4Stream(void);
extern void ESQ_CaptureCtrlBit3Stream(void);
extern UBYTE ESQ_STR_B[];

void ESQ_PollCtrlInput(void)
{
    volatile UWORD *custom16;

    ESQ_CaptureCtrlBit4Stream();

    if (ESQ_STR_B[18] == 'N') {
        ESQ_CaptureCtrlBit3Stream();
    }

    custom16 = (volatile UWORD *)0x00DFF000UL;
    custom16[0x009C / 2] = 0x0100;
}
