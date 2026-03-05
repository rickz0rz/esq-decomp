typedef unsigned char UBYTE;
typedef signed char BYTE;
typedef unsigned short UWORD;
typedef short WORD;

extern WORD CTRL_Bit4CapturePhase;
extern WORD CTRL_Bit4CaptureDelayCounter;
extern WORD CTRL_Bit4SampleSlotIndex;
extern BYTE CTRL_Bit4SampleScratch[];
extern UBYTE CTRL_BUFFER[];
extern WORD CTRL_H;
extern WORD CTRL_HPreviousSample;
extern WORD CTRL_BufferedByteCount;
extern WORD CTRL_HDeltaMax;

extern WORD GET_BIT_4_OF_CIAB_PRA_INTO_D1(void);

void ESQ_CaptureCtrlBit4Stream(void)
{
    WORD d0;
    WORD d1;

    if (CTRL_Bit4CapturePhase == 0) {
        d1 = GET_BIT_4_OF_CIAB_PRA_INTO_D1();
        if ((BYTE)d1 >= 0) {
            return;
        }

        CTRL_Bit4CapturePhase += 1;
        CTRL_Bit4CaptureDelayCounter = 4;
        CTRL_Bit4SampleSlotIndex = 0;
        return;
    }

    d0 = (WORD)(CTRL_Bit4CapturePhase + 1);
    CTRL_Bit4CapturePhase = d0;
    d1 = CTRL_Bit4CaptureDelayCounter;
    if (d1 > d0) {
        return;
    }

    if (d0 <= 4) {
        d1 = GET_BIT_4_OF_CIAB_PRA_INTO_D1();
        if ((BYTE)d1 >= 0) {
            CTRL_Bit4CaptureDelayCounter = 0;
            CTRL_Bit4SampleSlotIndex = 0;
            CTRL_Bit4CapturePhase = 0;
            return;
        }

        CTRL_Bit4CaptureDelayCounter = 14;
        for (d0 = 7; d0 >= 0; --d0) {
            CTRL_Bit4SampleScratch[(UWORD)d0] = 0;
        }
        return;
    }

    if (d0 < 94) {
        d1 = GET_BIT_4_OF_CIAB_PRA_INTO_D1();
        CTRL_Bit4SampleScratch[(UWORD)CTRL_Bit4SampleSlotIndex] = (BYTE)d1;
        CTRL_Bit4SampleSlotIndex = (WORD)(CTRL_Bit4SampleSlotIndex + 1);
        CTRL_Bit4CaptureDelayCounter = (WORD)(CTRL_Bit4CaptureDelayCounter + 10);
        return;
    }

    d1 = GET_BIT_4_OF_CIAB_PRA_INTO_D1();
    if ((BYTE)d1 < 0) {
        CTRL_Bit4CaptureDelayCounter = 0;
        CTRL_Bit4SampleSlotIndex = 0;
        CTRL_Bit4CapturePhase = 0;
        return;
    }

    {
        WORD bit;
        UBYTE assembled;

        assembled = 0;
        bit = (WORD)(CTRL_Bit4SampleSlotIndex - 1);

        while (bit >= 0) {
            if (CTRL_Bit4SampleScratch[(UWORD)bit] >= 0) {
                assembled = (UBYTE)(assembled | (UBYTE)(1U << (UWORD)bit));
            } else {
                assembled = (UBYTE)(assembled & (UBYTE)~(UBYTE)(1U << (UWORD)bit));
            }
            --bit;
        }

        d1 = CTRL_H;
        CTRL_BUFFER[(UWORD)d1] = assembled;
        d1 = (WORD)(d1 + 1);
        if (d1 == (WORD)0x01F4) {
            d1 = 0;
        }

        CTRL_H = d1;
        d0 = (WORD)(d1 - CTRL_HPreviousSample);
        if (d0 < 0) {
            d0 = (WORD)(d0 + (WORD)0x01F4);
        }

        CTRL_BufferedByteCount = d0;
        if (d0 >= CTRL_HDeltaMax) {
            CTRL_HDeltaMax = d0;
        }
    }

    CTRL_Bit4CaptureDelayCounter = 0;
    CTRL_Bit4SampleSlotIndex = 0;
    CTRL_Bit4CapturePhase = 0;
}
