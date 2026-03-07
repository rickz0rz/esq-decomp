typedef unsigned char UBYTE;
typedef long LONG;

enum {
    DISKIO1_MASK_INDEX_STEP = 1,
    DISKIO1_MASK_BYTE_COUNT = 6,
    DISKIO1_MASK_VALUE_END_INDEX = 49,
    DISKIO1_TESTBIT_CLEAR = -1
};

extern LONG ESQ_TestBit1Based(const UBYTE *maskBytes, LONG oneBasedBitIndex);
extern void GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(const char *fmt, ...);
extern void DISKIO1_AppendTimeSlotMaskValueTerminator(void);
extern void DISKIO1_AppendBlackoutMaskValueTerminator(void);

extern const char *Global_REF_STR_CLOCK_FORMAT[];
extern const char DISKIO_FMT_PCT_S_TimeSlotMaskEntry[];
extern const char DISKIO_FMT_PCT_S_BlackoutMaskEntry[];

volatile UBYTE gDiskio1MaskValueBitIndex;
volatile UBYTE gDiskio1TimeSlotMaskBytes[DISKIO1_MASK_BYTE_COUNT];
volatile UBYTE gDiskio1BlackoutMaskBytes[DISKIO1_MASK_BYTE_COUNT];

void DISKIO1_AppendTimeSlotMaskSelectedTimes(void)
{
    while (gDiskio1MaskValueBitIndex < DISKIO1_MASK_VALUE_END_INDEX) {
        LONG testResult = ESQ_TestBit1Based(
            (const UBYTE *)gDiskio1TimeSlotMaskBytes,
            (LONG)gDiskio1MaskValueBitIndex);

        if (testResult != DISKIO1_TESTBIT_CLEAR) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_FMT_PCT_S_TimeSlotMaskEntry,
                Global_REF_STR_CLOCK_FORMAT[(LONG)gDiskio1MaskValueBitIndex]);
        }
        gDiskio1MaskValueBitIndex += DISKIO1_MASK_INDEX_STEP;
    }

    DISKIO1_AppendTimeSlotMaskValueTerminator();
}

void DISKIO1_AppendBlackoutMaskSelectedTimes(void)
{
    while (gDiskio1MaskValueBitIndex < DISKIO1_MASK_VALUE_END_INDEX) {
        LONG testResult = ESQ_TestBit1Based(
            (const UBYTE *)gDiskio1BlackoutMaskBytes,
            (LONG)gDiskio1MaskValueBitIndex);

        if (testResult == DISKIO1_TESTBIT_CLEAR) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_FMT_PCT_S_BlackoutMaskEntry,
                Global_REF_STR_CLOCK_FORMAT[(LONG)gDiskio1MaskValueBitIndex]);
        }
        gDiskio1MaskValueBitIndex += DISKIO1_MASK_INDEX_STEP;
    }

    DISKIO1_AppendBlackoutMaskValueTerminator();
}
