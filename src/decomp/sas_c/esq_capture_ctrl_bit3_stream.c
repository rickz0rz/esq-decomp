typedef unsigned char UBYTE;
typedef signed char BYTE;
typedef unsigned short UWORD;
typedef short WORD;

extern WORD CTRL_Bit3CapturePhase;
extern WORD CTRL_Bit3CaptureDelayCounter;
extern WORD CTRL_Bit3SampleSlotIndex;
extern BYTE CTRL_Bit3SampleScratch[];
extern UBYTE CTRL_SampleEntryScratch[];
extern WORD CTRL_SampleEntryCount;

extern WORD GET_BIT_3_OF_CIAB_PRA_INTO_D1(void);
extern void ESQ_StoreCtrlSampleEntry(void);

void ESQ_CaptureCtrlBit3Stream(void)
{
    WORD d0;
    WORD d1;

    if (CTRL_Bit3CapturePhase == 0) {
        d1 = GET_BIT_3_OF_CIAB_PRA_INTO_D1();
        if ((BYTE)d1 >= 0) {
            return;
        }

        CTRL_Bit3CapturePhase += 1;
        CTRL_Bit3CaptureDelayCounter = 4;
        CTRL_Bit3SampleSlotIndex = 0;
        return;
    }

    d0 = (WORD)(CTRL_Bit3CapturePhase + 1);
    CTRL_Bit3CapturePhase = d0;
    d1 = CTRL_Bit3CaptureDelayCounter;
    if (d1 > d0) {
        return;
    }

    if (d0 <= 4) {
        d1 = GET_BIT_3_OF_CIAB_PRA_INTO_D1();
        if ((BYTE)d1 >= 0) {
            CTRL_Bit3CaptureDelayCounter = 0;
            CTRL_Bit3SampleSlotIndex = 0;
            CTRL_Bit3CapturePhase = 0;
            return;
        }

        CTRL_Bit3CaptureDelayCounter = 14;
        for (d0 = 7; d0 >= 0; --d0) {
            CTRL_Bit3SampleScratch[(UWORD)d0] = 0;
        }
        return;
    }

    if (d0 < 94) {
        d1 = GET_BIT_3_OF_CIAB_PRA_INTO_D1();
        CTRL_Bit3SampleScratch[(UWORD)CTRL_Bit3SampleSlotIndex] = (BYTE)d1;
        CTRL_Bit3SampleSlotIndex = (WORD)(CTRL_Bit3SampleSlotIndex + 1);
        CTRL_Bit3CaptureDelayCounter = (WORD)(CTRL_Bit3CaptureDelayCounter + 10);
        return;
    }

    d1 = GET_BIT_3_OF_CIAB_PRA_INTO_D1();
    if ((BYTE)d1 < 0) {
        CTRL_Bit3CaptureDelayCounter = 0;
        CTRL_Bit3SampleSlotIndex = 0;
        CTRL_Bit3CapturePhase = 0;
        return;
    }

    {
        WORD bit;
        UBYTE assembled;

        assembled = 0;
        bit = (WORD)(CTRL_Bit3SampleSlotIndex - 1);

        while (bit >= 0) {
            if (CTRL_Bit3SampleScratch[(UWORD)bit] >= 0) {
                assembled = (UBYTE)(assembled | (UBYTE)(1U << (UWORD)bit));
            } else {
                assembled = (UBYTE)(assembled & (UBYTE)~(UBYTE)(1U << (UWORD)bit));
            }
            --bit;
        }

        d1 = CTRL_SampleEntryCount;
        CTRL_SampleEntryScratch[(UWORD)d1] = assembled;

        if (assembled == 0) {
            ESQ_StoreCtrlSampleEntry();
            d1 = 0;
        } else {
            d1 = (WORD)(d1 + 1);
            if (d1 >= 5) {
                CTRL_SampleEntryScratch[(UWORD)(d1 - 1)] = 0;
                ESQ_StoreCtrlSampleEntry();
                d1 = 0;
            }
        }

        CTRL_SampleEntryCount = d1;
    }

    CTRL_Bit3CaptureDelayCounter = 0;
    CTRL_Bit3SampleSlotIndex = 0;
    CTRL_Bit3CapturePhase = 0;
}
