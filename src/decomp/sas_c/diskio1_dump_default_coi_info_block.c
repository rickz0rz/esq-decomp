typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef signed short WORD;

struct DiskioDefaultCoiInfo {
    ULONG reserved0;
    const char *city;
    const char *order;
    const char *price;
    const char *tele;
    const char *event;
    UBYTE reserved24[12];
    WORD exceptionCount;
    void *exceptionBlock;
};

struct DiskioProgramSourceRecord {
    UBYTE reserved0[40];
    UBYTE flag1;
    UBYTE bg0;
    UBYTE bg1;
    char bgText[3];
    UWORD flag2;
    struct DiskioDefaultCoiInfo *defaultCoi;
};

extern void GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(const char *fmt, ...);

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
    const struct DiskioDefaultCoiInfo *coi;

    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_DefaultCoiDump,
        (ULONG)rec->flag1,
        (ULONG)rec->flag2,
        (ULONG)rec->bg0,
        (ULONG)rec->bg1,
        rec->bgText);
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_COI_DASH_PTR_PCT_08LX,
        rec->defaultCoi);

    if (rec->defaultCoi == 0) {
        return;
    }

    coi = rec->defaultCoi;
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_STR_DEF_COI_INFORMATION_FOLLOWS_COLON);
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_STR_DEF_DEFAULT,
        coi);
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_DEF_CITY_PCT_08LX_STAR_DEF_CITY,
        coi->city,
        coi->city);
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_DEF_ORDER_PCT_08LX_STAR_DEF_ORDER,
        coi->order,
        coi->order);
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_DEF_PRICE_PCT_08LX_STAR_DEF_PRICE,
        coi->price,
        coi->price);
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_DEF_TELE_PCT_08LX_STAR_DEF_TELE,
        coi->tele,
        coi->tele);
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_DEF_EVENT_PCT_08LX_STAR_DEF_EVENT,
        coi->event,
        coi->event);
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_EXCEPTION_COUNT_IS_PCT_LD,
        (long)coi->exceptionCount);
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_EXCEPTION_BLOCK_PCT_08LX,
        coi->exceptionBlock);
}
