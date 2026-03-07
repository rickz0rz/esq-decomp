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
    const LONG PHASE_WRAP = 98;
    const LONG ROWBYTE_STEP = 176;
    const LONG INTERLEAVE_STEP = 32;
    const WORD QUEUE_WRAP = 0x61;
    const WORD ONE = 1;
    const WORD ZERO = 0;
    LONG *interleaveOffsets = &ESQSHARED4_InterleaveCopyBaseOffset;

    if (GCOMMAND_BannerRebuildPendingFlag != 0) {
        GCOMMAND_RebuildBannerTablesFromBounds();
    }

    GCOMMAND_BannerPhaseIndexCurrent += ONE;
    GCOMMAND_BannerRowByteOffsetPrevious = GCOMMAND_BannerRowByteOffsetCurrent;

    if (GCOMMAND_BannerPhaseIndexCurrent == PHASE_WRAP) {
        GCOMMAND_BannerPhaseIndexCurrent = ZERO;
        GCOMMAND_BannerRowByteOffsetCurrent = GCOMMAND_BannerRowByteOffsetResetValue;
        interleaveOffsets[1] = interleaveOffsets[2];
    } else {
        GCOMMAND_BannerRowByteOffsetCurrent += ROWBYTE_STEP;
        interleaveOffsets[1] += INTERLEAVE_STEP;
    }

    {
        WORD cur = GCOMMAND_BannerQueueSlotCurrent;
        GCOMMAND_BannerQueueSlotPrevious = cur;
        cur = (WORD)(cur - ONE);
        GCOMMAND_BannerQueueSlotCurrent = cur;
        if (cur < ZERO) {
            GCOMMAND_BannerQueueSlotCurrent = QUEUE_WRAP;
        }
    }

    GCOMMAND_BannerRowIndexPrevious = GCOMMAND_BannerRowIndexCurrent;
    GCOMMAND_BannerRowIndexCurrent += ONE;
    if (GCOMMAND_BannerRowIndexCurrent == PHASE_WRAP) {
        GCOMMAND_BannerRowIndexCurrent = ZERO;
    }

    GCOMMAND_ServiceHighlightMessages();
}
