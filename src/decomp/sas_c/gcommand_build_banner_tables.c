#include <exec/types.h>
extern void *AbsExecBase;
extern UBYTE Global_REF_696_400_BITMAP[];
extern UBYTE ESQ_CopperListBannerA[];
extern UBYTE ESQ_CopperListBannerB[];

extern LONG GCOMMAND_BannerPhaseIndexCurrent;
extern LONG GCOMMAND_BannerRowByteOffsetResetValue;
extern LONG GCOMMAND_BannerRowByteOffsetCurrent;
extern LONG GCOMMAND_BannerRowByteOffsetPrevious;
extern LONG GCOMMAND_BannerRowIndexPrevious;
extern LONG GCOMMAND_BannerRowIndexCurrent;
extern LONG ESQSHARED4_InterleaveCopyTailOffsetReset;
extern LONG ESQSHARED4_InterleaveCopyTailOffsetCurrent;

extern WORD GCOMMAND_BannerQueueSlotPrevious;
extern WORD GCOMMAND_BannerQueueSlotCurrent;
extern WORD ED2_HighlightTickEnabledFlag;
extern WORD ESQPARS2_ReadModeFlags;

extern void _LVODisable(void *execBase);
extern void _LVOEnable(void *execBase);
extern void GCOMMAND_ResetPresetWorkTables(void);
extern void GCOMMAND_ClearBannerQueue(void);
extern UBYTE *GCOMMAND_CopyImageDataToBitmap(
    UBYTE *bitmapPtr,
    UBYTE *tablePtr,
    LONG length,
    LONG baseOffset,
    UBYTE *srcBytePtr,
    UWORD argWord0,
    UBYTE argByte0);

void GCOMMAND_BuildBannerTables(UBYTE arg0, UWORD arg1, UBYTE arg2)
{
    UBYTE firstByte;

    firstByte = arg0;
    _LVODisable(AbsExecBase);

    GCOMMAND_ResetPresetWorkTables();

    GCOMMAND_BannerPhaseIndexCurrent = 0;
    GCOMMAND_BannerRowByteOffsetPrevious = 0;
    GCOMMAND_BannerRowByteOffsetCurrent = GCOMMAND_BannerRowByteOffsetResetValue;
    ESQSHARED4_InterleaveCopyTailOffsetCurrent = ESQSHARED4_InterleaveCopyTailOffsetReset;
    GCOMMAND_BannerQueueSlotPrevious = 97;
    GCOMMAND_BannerQueueSlotCurrent = 96;
    GCOMMAND_BannerRowIndexPrevious = 84;
    GCOMMAND_BannerRowIndexCurrent = 85;

    GCOMMAND_CopyImageDataToBitmap(
        Global_REF_696_400_BITMAP,
        ESQ_CopperListBannerA,
        2992,
        GCOMMAND_BannerRowByteOffsetCurrent,
        &firstByte,
        arg1,
        arg2);

    firstByte = arg0;
    GCOMMAND_CopyImageDataToBitmap(
        Global_REF_696_400_BITMAP,
        ESQ_CopperListBannerB,
        3080,
        GCOMMAND_BannerRowByteOffsetCurrent + 88,
        &firstByte,
        arg1,
        arg2);

    GCOMMAND_ClearBannerQueue();
    ED2_HighlightTickEnabledFlag = 1;
    ESQPARS2_ReadModeFlags = 0x100;
    _LVOEnable(AbsExecBase);
}
