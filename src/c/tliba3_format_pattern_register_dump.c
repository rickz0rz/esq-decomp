/* RESTORES: TLIBA3_FormatPatternRegisterDump
 * MODULE:   modules/groups/b/a/tliba3_p4.s
 * STATUS:   behavioural
 *
 * Prints one view mode's copper register block as 21 diagnostic lines. The
 * second argument is a 38-word register image, read as pairs: a hardware
 * register number and its value.
 *
 * Three shapes appear. Most lines print the pair plus the value again. DIWSTOP
 * prints the value plus 0x100. The five bitplane pointer pairs print a PTH line
 * with two fields and a PTL line whose third field is the two halves joined,
 * (pth << 16) | ptl.
 *
 * READ THIS BEFORE JUDGING THE SIZE. tools/refbytes.py extracts label to label
 * and the next label in tliba3_p4.s is well past this function's RTS -- the
 * module holds two further unlabelled routines, one of them marked dead code.
 * The raw reference is 866 bytes and the FUNCTION is 728: its epilogue,
 * 4cdf0c0c/4e75, ends at byte 728 of the extract. This file emits 728, the
 * SAME SIZE as the function. See AGENTS.md rule 1 -- equal size is not proof of
 * fidelity, and the 69 regions here are counted against the 866-byte extract,
 * so they are inflated by the misalignment as well.
 *
 * SASC-MISMATCH: extract-overruns-the-function
 *   ref:     4cdf0c0c4e75               the epilogue, at byte 728 of an
 *                                       866-byte extract
 *   got:     728 bytes total            the whole function
 *   summary: same size as the function. The remaining 138 bytes of the extract
 *            are two other routines.
 *   scope:   the same trap as src/c/wdisp_handle_weather_status_command.c.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern void FORMAT_RawDoFmtWithScratchBuffer(char *fmt, ...);

extern short TLIBA1_DiagDiwOffset;
extern short TLIBA1_DiagDdfOffset;
extern short TLIBA1_DiagBplcon1Value;

extern char TLIBA1_FMT_PCT_S_COLON_DIWOFFSET_PCT_04LX_DDFOF[];
extern char TLIBA1_FMT_DIWSTRT_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern char TLIBA1_FMT_DIWSTOP_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern char TLIBA1_FMT_DDFSTRT_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern char TLIBA1_FMT_DDFSTOP_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern char TLIBA1_FMT_BPL1MOD_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern char TLIBA1_FMT_BPL2MOD_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern char TLIBA1_FMT_BPLCON0_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern char TLIBA1_FMT_BPLCON1_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern char TLIBA1_FMT_BPLCON2_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern char TLIBA1_FMT_BPL1PTH_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern char TLIBA1_FMT_BPL1PTL_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern char TLIBA1_FMT_BPL2PTH_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern char TLIBA1_FMT_BPL2PTL_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern char TLIBA1_FMT_BPL3PTH_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern char TLIBA1_FMT_BPL3PTL_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern char TLIBA1_FMT_BPL4PTH_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern char TLIBA1_FMT_BPL4PTL_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern char TLIBA1_FMT_BPL5PTH_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern char TLIBA1_FMT_BPL5PTL_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern char TLIBA1_STR_PatternDumpSeparatorNewline[];

void TLIBA3_FormatPatternRegisterDump(char *name, unsigned short *r)
{
    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_PCT_S_COLON_DIWOFFSET_PCT_04LX_DDFOF, name,
        (long)TLIBA1_DiagDiwOffset, (long)TLIBA1_DiagDdfOffset,
        (long)TLIBA1_DiagBplcon1Value);

    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_DIWSTRT_COLON_0X_PCT_04LX_0X_PCT_04L,
        (long)r[0], (long)r[1], (long)r[1]);
    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_DIWSTOP_COLON_0X_PCT_04LX_0X_PCT_04L,
        (long)r[2], (long)r[3], (long)r[3] + 0x100);
    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_DDFSTRT_COLON_0X_PCT_04LX_0X_PCT_04L,
        (long)r[4], (long)r[5], (long)r[5]);
    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_DDFSTOP_COLON_0X_PCT_04LX_0X_PCT_04L,
        (long)r[6], (long)r[7], (long)r[7]);
    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_BPL1MOD_COLON_0X_PCT_04LX_0X_PCT_04L,
        (long)r[8], (long)r[9], (long)r[9]);
    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_BPL2MOD_COLON_0X_PCT_04LX_0X_PCT_04L,
        (long)r[10], (long)r[11], (long)r[11]);
    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_BPLCON0_COLON_0X_PCT_04LX_0X_PCT_04L,
        (long)r[12], (long)r[13], (long)r[13]);
    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_BPLCON1_COLON_0X_PCT_04LX_0X_PCT_04L,
        (long)r[14], (long)r[15], (long)r[15]);
    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_BPLCON2_COLON_0X_PCT_04LX_0X_PCT_04L,
        (long)r[16], (long)r[17], (long)r[17]);

    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_BPL1PTH_COLON_0X_PCT_04LX_0X_PCT_04L,
        (long)r[18], (long)r[19]);
    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_BPL1PTL_COLON_0X_PCT_04LX_0X_PCT_04L,
        (long)r[20], (long)r[21], ((long)r[19] << 16) | (long)r[21]);
    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_BPL2PTH_COLON_0X_PCT_04LX_0X_PCT_04L,
        (long)r[22], (long)r[23]);
    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_BPL2PTL_COLON_0X_PCT_04LX_0X_PCT_04L,
        (long)r[24], (long)r[25], ((long)r[23] << 16) | (long)r[25]);
    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_BPL3PTH_COLON_0X_PCT_04LX_0X_PCT_04L,
        (long)r[26], (long)r[27]);
    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_BPL3PTL_COLON_0X_PCT_04LX_0X_PCT_04L,
        (long)r[28], (long)r[29], ((long)r[27] << 16) | (long)r[29]);
    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_BPL4PTH_COLON_0X_PCT_04LX_0X_PCT_04L,
        (long)r[30], (long)r[31]);
    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_BPL4PTL_COLON_0X_PCT_04LX_0X_PCT_04L,
        (long)r[32], (long)r[33], ((long)r[31] << 16) | (long)r[33]);
    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_BPL5PTH_COLON_0X_PCT_04LX_0X_PCT_04L,
        (long)r[34], (long)r[35]);
    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_BPL5PTL_COLON_0X_PCT_04LX_0X_PCT_04L,
        (long)r[36], (long)r[37], ((long)r[35] << 16) | (long)r[37]);

    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_STR_PatternDumpSeparatorNewline);
}
