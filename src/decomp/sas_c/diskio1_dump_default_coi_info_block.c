typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef signed long LONG;
typedef signed short WORD;

enum {
    DISKIO_NULL = 0,
    DEFAULT_COI_TRAILING_RESERVED_BYTES = 12,
    SOURCE_HEADER_RESERVED_BYTES = 40,
    BACKGROUND_TEXT_BYTES = 3
};

struct DiskioDefaultCoiInfo {
    ULONG owner_or_link;
    const char *city;
    const char *order;
    const char *price;
    const char *tele;
    const char *event;
    UBYTE trailing_reserved[DEFAULT_COI_TRAILING_RESERVED_BYTES];
    WORD exceptionCount;
    void *exceptionBlock;
};

struct DiskioProgramSourceRecord {
    UBYTE header_reserved[SOURCE_HEADER_RESERVED_BYTES];
    UBYTE sourceFlagsByte;
    UBYTE backgroundColor0;
    UBYTE backgroundColor1;
    char backgroundText[BACKGROUND_TEXT_BYTES];
    UWORD sourceFlagsWord;
    struct DiskioDefaultCoiInfo *defaultCoi;
};

extern LONG FORMAT_RawDoFmtWithScratchBuffer(char *fmt, ...);

extern const char DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_DefaultCoiDump[];
extern const char DISKIO_FMT_COI_DASH_PTR_PCT_08LX[];
extern const char DISKIO_STR_DEF_COI_INFORMATION_FOLLOWS_COLON[];
extern const char DISKIO_STR_DEF_DEFAULT[];
extern const char DISKIO_FMT_DEF_CITY_PCT_08LX_STAR_DEF_CITY[];
extern const char DISKIO_FMT_DEF_ORDER_PCT_08LX_STAR_DEF_ORDER[];
extern const char DISKIO_FMT_DEF_PRICE_PCT_08LX_STAR_DEF_PRICE[];
extern const char DISKIO_FMT_DEF_TELE_PCT_08LX_STAR_DEF_TELE[];
extern const char DISKIO_FMT_DEF_EVENT_PCT_08LX_STAR_DEF_EVENT[];
extern const char DISKIO_FMT_EXCEPTION_COUNT_IS_PCT_LD[];
extern const char DISKIO_FMT_EXCEPTION_BLOCK_PCT_08LX[];

volatile struct DiskioProgramSourceRecord *gDiskio1CurrentSourceRecord;

void DISKIO1_DumpDefaultCoiInfoBlock(void)
{
    const struct DiskioProgramSourceRecord *rec = gDiskio1CurrentSourceRecord;
    const struct DiskioDefaultCoiInfo *coi = rec->defaultCoi;

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_DefaultCoiDump,
        (ULONG)rec->sourceFlagsByte,
        (ULONG)rec->sourceFlagsWord,
        (ULONG)rec->backgroundColor0,
        (ULONG)rec->backgroundColor1,
        rec->backgroundText);
    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_COI_DASH_PTR_PCT_08LX,
        coi);

    if (coi == (const struct DiskioDefaultCoiInfo *)DISKIO_NULL) {
        return;
    }

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_STR_DEF_COI_INFORMATION_FOLLOWS_COLON);
    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_STR_DEF_DEFAULT,
        coi);
    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_DEF_CITY_PCT_08LX_STAR_DEF_CITY,
        coi->city,
        coi->city);
    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_DEF_ORDER_PCT_08LX_STAR_DEF_ORDER,
        coi->order,
        coi->order);
    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_DEF_PRICE_PCT_08LX_STAR_DEF_PRICE,
        coi->price,
        coi->price);
    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_DEF_TELE_PCT_08LX_STAR_DEF_TELE,
        coi->tele,
        coi->tele);
    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_DEF_EVENT_PCT_08LX_STAR_DEF_EVENT,
        coi->event,
        coi->event);
    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_EXCEPTION_COUNT_IS_PCT_LD,
        (long)coi->exceptionCount);
    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_EXCEPTION_BLOCK_PCT_08LX,
        coi->exceptionBlock);
}
