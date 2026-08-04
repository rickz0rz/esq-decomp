/* RESTORES: _DISKIO1_DumpProgramSourceRecordFull
 * MODULE:   modules/groups/a/g/diskio1.s
 * STATUS:   behavioural
 *
 * Writes the long form of one program-source record through the scratch-buffer
 * formatter. It prints the record header and the attribute flags, then expands
 * the time-slot mask and the blackout mask into lists of clock labels, then
 * dumps the default COI information block. It is a diagnostic and returns
 * nothing.
 *
 * THIS ROUTINE HAS NO CALLER, and that is the reason it was the last block in
 * the module to get a name. The disassembly marked it "Unreachable Code?" and
 * left the entry point unlabelled, so the 24 branch targets inside it read as 24
 * separate functions -- 20 of them sat in the worklist as `falls-through` or
 * `live-register-on-entry` and none of them is a function at all. A search over
 * src/modules and src/data finds no reference to any of the 25 labels. The only
 * live entry to this family is _DISKIO1_DumpProgramSourceRecordVerbose, which is
 * a different module.
 *
 * The label `_DISKIO1_DumpProgramSourceRecordFull` is new. It emits no bytes,
 * both gates stay green across it, and it replaces 20 phantom worklist entries
 * with one real one.
 *
 * THE TWO MASK LOOPS TEST THE BIT IN OPPOSITE DIRECTIONS, and this is the one
 * thing in the routine that is easy to get backwards. ESQ_TestBit1Based returns
 * -1 when the bit IS set. The time-slot loop reads
 * `ADDQ.L #1,D0 / BEQ skip`, so it prints the slot when the bit is CLEAR. The
 * blackout loop reads `ADDQ.L #1,D0 / BNE skip`, so it prints the slot when the
 * bit is SET. The two loops are otherwise identical.
 *
 * THE TWO EMPTY-MASK TESTS ALSO RUN IN OPPOSITE ORDER. The time-slot mask tests
 * the all-bits-set sum 0x5FA first and the zero sum second; the blackout mask
 * tests zero first and 0x5FA second. Each mask names its own pair of strings.
 *
 * BIT 0 OF THE ATTRIBUTE BYTE IS NOT A BIT TEST. The byte is compared against
 * the literal 1, so "NONE" prints only when the whole byte is exactly 1. Every
 * other flag is a proper BTST. This matches
 * diskio1_dump_program_source_record_verbose.c, which carries the same note.
 *
 * THE WORD AT +46 IS ZERO-EXTENDED AND THE WORD AT COI+36 IS SIGN-EXTENDED. The
 * record field uses `MOVEQ #0` then `MOVE.W`; the exception count uses `MOVE.W`
 * then `EXT.L`. They are declared `unsigned short` and `short` for that reason.
 *
 * THE FIELD AT +46 IS PRINTED BETWEEN +40 AND +41, the same out-of-order
 * argument list the verbose twin has.
 *
 * SASC-MISMATCH: stack-argument-reuse
 *   ref:     LEA 32(A7),A7 after six calls   one pop for six argument lists
 *   got:     ADDQ.W #4,A7 / LEA 8(A7),A7     6.51 balances after every call
 *   summary: the original leaves each formatter call's arguments on the stack
 *            and overwrites the slots in place with MOVE.L D0,(A7), then pops
 *            the whole area once. 6.51 emits a push and a matching pop per call.
 *            Same arguments reach the formatter in the same order either way.
 *   tried:   this is the same divergence recorded in the verbose twin, which
 *            has no frame at all and pops with one LEA 72(A7),A7.
 *   scope:   every multi-call diagnostic dumper in DISKIO1 and DISKIO2.
 *   retest:  a compiler that keeps an outgoing-argument area alive across calls
 *            rather than balancing per call.
 *
 * SASC-MISMATCH: cross-unit-call-encoding
 *   ref:     4eba  JSR (d16,PC)
 *   got:     6100  BSR.W
 *   summary: the original encodes a call to another translation unit as
 *            JSR (d16,PC); 6.51 emits BSR.W for every call whoever the callee
 *            is. Same size, same displacement, same effect.
 *   scope:   program-wide, and the reason no cross-unit target is exact.
 *   retest:  a compiler that picks the encoding per callee.
 */

struct DiskioCoi;

struct DiskioFullRec {
    unsigned char  etid;              /* +0  printed as %ld and as %02lx */
    char           chanNum[11];         /* +1  */
    char           source[7];           /* +12 */
    char           callLetters[8];      /* +19 */
    unsigned char  flags;               /* +27 */
    unsigned char  tslt[6];             /* +28 time-slot mask */
    unsigned char  blk[6];              /* +34 blackout mask */
    unsigned char  flag1;               /* +40 */
    unsigned char  b41;                 /* +41 */
    unsigned char  b42;                 /* +42 */
    char           bg[3];               /* +43 */
    unsigned short flag2;               /* +46 printed between +40 and +41 */
    struct DiskioCoi *coi;              /* +48 */
};

struct DiskioCoi {
    char  pad0[4];                      /* +0  */
    char *city;                         /* +4  */
    char *order;                        /* +8  */
    char *price;                        /* +12 */
    char *tele;                         /* +16 */
    char *event;                        /* +20 */
    char  pad24[12];                    /* +24 */
    short exceptionCount;               /* +36 sign-extended */
    char *exceptionBlock;               /* +38 */
};

extern void FORMAT_RawDoFmtWithScratchBuffer(char *fmt, ...);
extern long ESQ_TestBit1Based(unsigned char *base, long bit);

extern char **Global_REF_STR_CLOCK_FORMAT;

extern char DISKIO_FMT_CHANNEL_LINE_UP_PCT_LD[];
extern char DISKIO_FMT_ETID_PCT_LD_PCT_02LX[];
extern char DISKIO_FMT_CHAN_NUM_PCT_S[];
extern char DISKIO_FMT_SOURCE_PCT_S[];
extern char DISKIO_FMT_CALL_LET_PCT_S[];
extern char DISKIO_FMT_ATTR_PCT_02LX[];
extern char DISKIO_STR_NONE_CompactSourceAttrFlags[];
extern char DISKIO_STR_HILITE_SRC_CompactSourceAttrFlags[];
extern char DISKIO_STR_SUM_SRC_CompactSourceAttrFlags[];
extern char DISKIO_STR_VIDEO_TAG_DISABLE_CompactSourceAttrFlags[];
extern char DISKIO_STR_PPV_SRC_CompactSourceAttrFlags[];
extern char DISKIO_STR_DITTO_CompactSourceAttrFlags[];
extern char DISKIO_STR_ALTHILITESRC_CompactSourceAttrFlags[];
extern char DISKIO_STR_0X80[];
extern char DISKIO_STR_AttrFlagsCloseParenNewline_A[];
extern char DISKIO_FMT_TSLT_MASK_PCT_02LX_PCT_02LX_PCT_02LX[];
extern char DISKIO_STR_NONE_TimeSlotMaskAllSet[];
extern char Global_STR_OFF_AIR_2[];
extern char DISKIO_STR_TimeSlotListOpenParen[];
extern char DISKIO_FMT_PCT_S_TimeSlotMaskEntry[];
extern char DISKIO_STR_TimeSlotListCloseParenNewline[];
extern char DISKIO_FMT_BLKOUT_MASK_PCT_02LX_PCT_02LX_PCT_02[];
extern char DISKIO_STR_NONE_BlackoutMaskEmpty[];
extern char DISKIO_STR_BLACKED_OUT[];
extern char DISKIO_STR_BlackoutListOpenParen[];
extern char DISKIO_FMT_PCT_S_BlackoutMaskEntry[];
extern char DISKIO_STR_BlackoutListCloseParenNewline[];
extern char DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_DefaultCoiDump[];
extern char DISKIO_FMT_COI_DASH_PTR_PCT_08LX[];
extern char DISKIO_STR_DEF_COI_INFORMATION_FOLLOWS_COLON[];
extern char DISKIO_STR_DEF_DEFAULT[];
extern char DISKIO_FMT_DEF_CITY_PCT_08LX_STAR_DEF_CITY[];
extern char DISKIO_FMT_DEF_ORDER_PCT_08LX_STAR_DEF_ORDER[];
extern char DISKIO_FMT_DEF_PRICE_PCT_08LX_STAR_DEF_PRICE[];
extern char DISKIO_FMT_DEF_TELE_PCT_08LX_STAR_DEF_TELE[];
extern char DISKIO_FMT_DEF_EVENT_PCT_08LX_STAR_DEF_EVENT[];
extern char DISKIO_FMT_EXCEPTION_COUNT_IS_PCT_LD[];
extern char DISKIO_FMT_EXCEPTION_BLOCK_PCT_08LX[];

void DISKIO1_DumpProgramSourceRecordFull(struct DiskioFullRec *rec, long num)
{
    struct DiskioCoi *coi;
    long sum, i;
    unsigned char slot;

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_CHANNEL_LINE_UP_PCT_LD, num);

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_ETID_PCT_LD_PCT_02LX, (long)rec->etid, (long)rec->etid);

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_CHAN_NUM_PCT_S, rec->chanNum);

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_SOURCE_PCT_S, rec->source);

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_CALL_LET_PCT_S, rec->callLetters);

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_ATTR_PCT_02LX, (long)rec->flags);

    /* Bit 0 is a whole-byte comparison, not a bit test. */
    if (rec->flags == 1)
        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_NONE_CompactSourceAttrFlags);

    if (rec->flags & 2)
        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_HILITE_SRC_CompactSourceAttrFlags);

    if (rec->flags & 4)
        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_SUM_SRC_CompactSourceAttrFlags);

    if (rec->flags & 8)
        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_VIDEO_TAG_DISABLE_CompactSourceAttrFlags);

    if (rec->flags & 0x10)
        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_PPV_SRC_CompactSourceAttrFlags);

    if (rec->flags & 0x20)
        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_DITTO_CompactSourceAttrFlags);

    if (rec->flags & 0x40)
        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_ALTHILITESRC_CompactSourceAttrFlags);

    if (rec->flags & 0x80)
        FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_0X80);

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_STR_AttrFlagsCloseParenNewline_A);

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_TSLT_MASK_PCT_02LX_PCT_02LX_PCT_02LX, (long)rec->tslt[0],
        (long)rec->tslt[1], (long)rec->tslt[2], (long)rec->tslt[3],
        (long)rec->tslt[4], (long)rec->tslt[5]);

    sum = 0;
    for (i = 0; i < 6; i++)
        sum += (long)rec->tslt[i];

    if (sum == 0x5fa) {
        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_NONE_TimeSlotMaskAllSet);
    } else if (sum == 0) {
        FORMAT_RawDoFmtWithScratchBuffer(Global_STR_OFF_AIR_2);
    } else {
        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_TimeSlotListOpenParen);

        /* Prints the slot when the bit is CLEAR. */
        for (slot = 1; slot < 49; slot++)
            if (ESQ_TestBit1Based(rec->tslt, (long)slot) != -1)
                FORMAT_RawDoFmtWithScratchBuffer(
                    DISKIO_FMT_PCT_S_TimeSlotMaskEntry,
                    Global_REF_STR_CLOCK_FORMAT[slot]);

        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_TimeSlotListCloseParenNewline);
    }

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_BLKOUT_MASK_PCT_02LX_PCT_02LX_PCT_02, (long)rec->blk[0],
        (long)rec->blk[1], (long)rec->blk[2], (long)rec->blk[3],
        (long)rec->blk[4], (long)rec->blk[5]);

    sum = 0;
    for (i = 0; i < 6; i++)
        sum += (long)rec->blk[i];

    if (sum == 0) {
        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_NONE_BlackoutMaskEmpty);
    } else if (sum == 0x5fa) {
        FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_BLACKED_OUT);
    } else {
        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_BlackoutListOpenParen);

        /* Prints the slot when the bit is SET -- the opposite of the loop above. */
        for (slot = 1; slot < 49; slot++)
            if (ESQ_TestBit1Based(rec->blk, (long)slot) == -1)
                FORMAT_RawDoFmtWithScratchBuffer(
                    DISKIO_FMT_PCT_S_BlackoutMaskEntry,
                    Global_REF_STR_CLOCK_FORMAT[slot]);

        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_BlackoutListCloseParenNewline);
    }

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_DefaultCoiDump,
        (long)rec->flag1, (long)rec->flag2, (long)rec->b41, (long)rec->b42,
        rec->bg);

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_COI_DASH_PTR_PCT_08LX, rec->coi);

    if (rec->coi == 0)
        return;

    coi = rec->coi;

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_STR_DEF_COI_INFORMATION_FOLLOWS_COLON);

    FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_DEF_DEFAULT, coi);

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_DEF_CITY_PCT_08LX_STAR_DEF_CITY, coi->city, coi->city);

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_DEF_ORDER_PCT_08LX_STAR_DEF_ORDER, coi->order, coi->order);

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_DEF_PRICE_PCT_08LX_STAR_DEF_PRICE, coi->price, coi->price);

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_DEF_TELE_PCT_08LX_STAR_DEF_TELE, coi->tele, coi->tele);

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_DEF_EVENT_PCT_08LX_STAR_DEF_EVENT, coi->event, coi->event);

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_EXCEPTION_COUNT_IS_PCT_LD, (long)coi->exceptionCount);

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_EXCEPTION_BLOCK_PCT_08LX, coi->exceptionBlock);
}
