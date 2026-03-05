typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef short WORD;

extern unsigned char Global_PTR_AUD1_DMA;
extern WORD CTRL_Bit4CaptureDelayCounter;
extern WORD CTRL_Bit4CapturePhase;
extern WORD CTRL_SampleEntryCount;

void ESQ_InitAudio1Dma(void)
{
    volatile UWORD *custom16;
    volatile ULONG *custom32;

    custom16 = (volatile UWORD *)0x00DFF000UL;
    custom32 = (volatile ULONG *)0x00DFF000UL;

    custom32[0x0B0 / 4] = (ULONG)&Global_PTR_AUD1_DMA;
    custom16[0x0B4 / 2] = 1;
    custom16[0x0B8 / 2] = 0;
    custom16[0x0B6 / 2] = 0x065B;
    custom16[0x0096 / 2] = 0x8202;

    CTRL_Bit4CaptureDelayCounter = 0;
    CTRL_Bit4CapturePhase = 0;
    CTRL_SampleEntryCount = 0;
}
