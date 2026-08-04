/* RESTORES: _DISKIO1_DumpProgramSourceRecordVerbose
 * MODULE:   modules/groups/a/g/diskio1.s
 * STATUS:   behavioural
 *
 * Writes a human-readable dump of one program-source record through the
 * scratch-buffer formatter. It is a diagnostic and has no return value.
 *
 * THE ATTRIBUTE FLAGS ARE TESTED AS BITS EXCEPT THE FIRST. Bit 0 is not tested
 * with BTST at all -- the byte is compared against the literal 1, so "NONE"
 * prints only when the WHOLE byte is exactly 1, not when bit 0 is set alongside
 * others. Every other flag is a proper bit test. Writing the first as `& 1`
 * makes "NONE" appear next to the flags it is meant to exclude.
 *
 * The eight flag strings are appended one after another with no separator
 * logic, so a record with several flags prints them run together between the
 * opening "ATTR" and the closing parenthesis.
 *
 * EVERY BYTE FIELD IS ZERO-EXTENDED, and the word at +46 is too -- the original
 * uses `MOVEQ #0` followed by a sized MOVE at all fifteen sites, so nothing is
 * sign-extended even though the fields are declared as characters.
 *
 * THE FIELD AT +46 IS PRINTED BETWEEN +40 AND +41. The format takes them in the
 * order 40, 46, 41, 42, then the string at +43 -- so the word is read out of
 * sequence relative to the record layout. That is the format string's order and
 * changing it would misalign the output against the reader.
 *
 * The two six-byte masks are printed by the same shape of call with different
 * format strings, one for the time-slot mask at +28 and one for the blackout
 * mask at +34.
 *
 * THE FUNCTION HAS NO FRAME. It never uses A5 and pops its whole argument area
 * with one `LEA 72(A7),A7` at the end, so the fifteen formatter calls all leave
 * their arguments on the stack. 6.51 balances per call instead.
 *
 * THIS RESTORATION EXPOSED AN UNLABELLED FUNCTION, and the discovery is worth
 * more than the restoration. It first measured 416 bytes against a 754-byte
 * reference -- 45% short, which no codegen divergence explains. The cause was
 * the case AGENTS.md describes under "...and not every function has a label":
 * a SECOND verbose dump followed this one with no label of its own, and
 * refbytes.py extracts label-to-label, so the reference was two functions
 * concatenated.
 *
 * That function is now labelled `DISKIO1_DumpProgramInfoRecordVerbose` in
 * modules/groups/a/g/diskio1.s. Adding the label is byte-neutral -- test-hash.sh
 * still passes -- and it corrects two numbers at once: this entry drops from
 * 754 bytes to its true 416, and the 338-byte function beneath it becomes its
 * own worklist entry. It is screened as `falls-through` (it ends with a branch
 * to the shared _Return rather than an RTS), so it is correctly NOT a
 * restoration candidate.
 *
 * The lesson generalises: a restoration that lands far UNDER its reference with
 * no structural disagreement is a signal to check the reference, not the C.
 *
 * 416 ref vs 416 got against the corrected reference, 26 differing regions.
 * All fifteen formatter calls in order, the exact-1 test on the first flag and
 * the seven bit tests after it, all fifteen zero-extensions, both six-argument
 * mask dumps and the out-of-order +46 field match in kind and size.
 */
struct DiskioRec {
    unsigned char b0;                   /* +0  */
    char          name[11];             /* +1  */
    char          chan[7];              /* +12 */
    char          source[8];            /* +19 */
    unsigned char flags;                /* +27 */
    unsigned char tslt[6];              /* +28 */
    unsigned char blk[6];               /* +34 */
    unsigned char b40;                  /* +40 */
    unsigned char b41;                  /* +41 */
    unsigned char b42;                  /* +42 */
    char          tail[3];              /* +43 */
    unsigned short w46;                 /* +46 */
};

extern void FORMAT_RawDoFmtWithScratchBuffer(char *fmt, ...);

extern char DISKIO_FMT_CHANNEL_LINE_UP_PCT_D[];
extern char DISKIO_FMT_ETID_PCT_D_CHAN_NUM_PCT_S_SOURCE_PCT[];
extern char DISKIO_STR_ATTR[];
extern char DISKIO_STR_NONE_VerboseSourceAttrFlags[];
extern char DISKIO_STR_HILITE_SRC_VerboseSourceAttrFlags[];
extern char DISKIO_STR_SUM_SRC_VerboseSourceAttrFlags[];
extern char DISKIO_STR_VIDEO_TAG_DISABLE_VerboseSourceAttrFlags[];
extern char DISKIO_STR_PPV_SRC_VerboseSourceAttrFlags[];
extern char DISKIO_STR_DITTO_VerboseSourceAttrFlags[];
extern char DISKIO_STR_ALTHILITESRC_VerboseSourceAttrFlags[];
extern char DISKIO_STR_STEREO[];
extern char DISKIO_STR_ProgramAttrCloseParenNewline[];
extern char DISKIO_FMT_TSLT_MASK_PCT_02X_PCT_02X_PCT_02X_PC[];
extern char DISKIO_FMT_BLKOUT_MASK_PCT_02X_PCT_02X_PCT_02X_[];
extern char DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_VerboseSourceRecord[];

void DISKIO1_DumpProgramSourceRecordVerbose(struct DiskioRec *rec, long num)
{
    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_CHANNEL_LINE_UP_PCT_D, num);

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_ETID_PCT_D_CHAN_NUM_PCT_S_SOURCE_PCT, (long)rec->b0,
        rec->name, rec->chan, rec->source);

    FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_ATTR);

    if (rec->flags == 1)
        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_NONE_VerboseSourceAttrFlags);

    if (rec->flags & 2)
        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_HILITE_SRC_VerboseSourceAttrFlags);

    if (rec->flags & 4)
        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_SUM_SRC_VerboseSourceAttrFlags);

    if (rec->flags & 8)
        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_VIDEO_TAG_DISABLE_VerboseSourceAttrFlags);

    if (rec->flags & 0x10)
        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_PPV_SRC_VerboseSourceAttrFlags);

    if (rec->flags & 0x20)
        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_DITTO_VerboseSourceAttrFlags);

    if (rec->flags & 0x40)
        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_ALTHILITESRC_VerboseSourceAttrFlags);

    if (rec->flags & 0x80)
        FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_STEREO);

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_STR_ProgramAttrCloseParenNewline);

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_TSLT_MASK_PCT_02X_PCT_02X_PCT_02X_PC, (long)rec->tslt[0],
        (long)rec->tslt[1], (long)rec->tslt[2], (long)rec->tslt[3],
        (long)rec->tslt[4], (long)rec->tslt[5]);

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_BLKOUT_MASK_PCT_02X_PCT_02X_PCT_02X_, (long)rec->blk[0],
        (long)rec->blk[1], (long)rec->blk[2], (long)rec->blk[3],
        (long)rec->blk[4], (long)rec->blk[5]);

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_VerboseSourceRecord,
        (long)rec->b40, (long)rec->w46, (long)rec->b41, (long)rec->b42,
        rec->tail);
}
