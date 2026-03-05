typedef signed long LONG;
typedef signed short WORD;

extern WORD GCOMMAND_BannerRebuildPendingFlag;

extern LONG GCOMMAND_BannerPhaseIndexCurrent;
extern LONG GCOMMAND_BannerRowByteOffsetResetValue;
extern LONG GCOMMAND_BannerRowByteOffsetCurrent;
extern LONG GCOMMAND_BannerRowByteOffsetPrevious;
extern LONG ESQSHARED4_InterleaveCopyBaseOffset;

extern WORD GCOMMAND_BannerQueueSlotPrevious;
extern WORD GCOMMAND_BannerQueueSlotCurrent;

extern LONG GCOMMAND_BannerRowIndexPrevious;
extern LONG GCOMMAND_BannerRowIndexCurrent;

extern void GCOMMAND_RebuildBannerTablesFromBounds(void);
extern void GCOMMAND_ServiceHighlightMessages(void);

void GCOMMAND_TickHighlightState(void)
{
    LONG *interleaveOffsets = &ESQSHARED4_InterleaveCopyBaseOffset;

    if (GCOMMAND_BannerRebuildPendingFlag != 0) {
        GCOMMAND_RebuildBannerTablesFromBounds();
    }

    GCOMMAND_BannerPhaseIndexCurrent += 1;
    GCOMMAND_BannerRowByteOffsetPrevious = GCOMMAND_BannerRowByteOffsetCurrent;

    if (GCOMMAND_BannerPhaseIndexCurrent == 98) {
        GCOMMAND_BannerPhaseIndexCurrent = 0;
        GCOMMAND_BannerRowByteOffsetCurrent = GCOMMAND_BannerRowByteOffsetResetValue;
        interleaveOffsets[1] = interleaveOffsets[2];
    } else {
        GCOMMAND_BannerRowByteOffsetCurrent += 176;
        interleaveOffsets[1] += 32;
    }

    {
        WORD cur = GCOMMAND_BannerQueueSlotCurrent;
        GCOMMAND_BannerQueueSlotPrevious = cur;
        cur = (WORD)(cur - 1);
        GCOMMAND_BannerQueueSlotCurrent = cur;
        if (cur < 0) {
            GCOMMAND_BannerQueueSlotCurrent = 0x61;
        }
    }

    GCOMMAND_BannerRowIndexPrevious = GCOMMAND_BannerRowIndexCurrent;
    GCOMMAND_BannerRowIndexCurrent += 1;
    if (GCOMMAND_BannerRowIndexCurrent == 98) {
        GCOMMAND_BannerRowIndexCurrent = 0;
    }

    GCOMMAND_ServiceHighlightMessages();
}
