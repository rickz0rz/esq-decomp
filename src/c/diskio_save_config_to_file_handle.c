/* RESTORES: DISKIO_SaveConfigToFileHandle
 * MODULE:   modules/groups/a/g/diskio_p5_p0.s
 * STATUS:   behavioural
 *
 * Serialises the whole runtime configuration into DF0:CONFIG.DAT as one
 * 52-byte record, built by a single SPrintf call with FORTY-TWO value
 * arguments.
 *
 * THE ARGUMENT ORDER IS THE FILE FORMAT. Nothing else records it -- the format
 * string is a data blob and the reader is a separate function. Reordering two
 * arguments here silently writes a config that the loader will misread, and no
 * gate in this project would notice, because both would still be valid C and
 * the bytes of THIS function would still compare sanely. That is the one thing
 * to be careful about in this file.
 *
 * The order was recovered from the original's stack choreography rather than
 * read off directly: 6.51 stages thirty-four of the values into the outgoing
 * frame with `MOVE.L D4,nn(A7)` and then re-pushes them with
 * `MOVE.L 188(A7),-(A7)`, which walks backwards through the staged area as A7
 * descends. Working that through, the re-pushed sequence reverses exactly, so
 * the argument order is the same as the STORE order. The three values that are
 * not staged -- the two longs and the scratch pointer -- sit between staged
 * item 23 and item 24, which is why the list below has them in the middle.
 *
 * TWO ARGUMENTS ARE NOT CONFIGURATION. The literal 67 and BRUSH_LabelScratch
 * are passed alongside the settings; 67 is 'C', which is presumably a record
 * tag, and the scratch buffer supplies a string field.
 *
 * THE BANNER HEAD BYTE IS MASKED THEN SIGN-EXTENDED. The original reads a WORD,
 * masks it to 8 bits, and then sign-extends the result back to a long -- so a
 * low byte of 0x80 or above is passed NEGATIVE. Writing the global as a plain
 * char and letting the varargs promotion do the work reproduces both steps.
 *
 * Every other value is a byte global promoted to int by the varargs call, which
 * is the `EXT.W` / `EXT.L` pair the original emits at each of the thirty-eight
 * sites.
 *
 * A FAILED OPEN RETURNS -1; every other path returns whatever the closing flush
 * returned, which the original does not check.
 *
 * A _Return LABEL MEANS THE REFERENCE STOPS EARLY -- the epilogue is branched
 * to from the open-failure path and has its own label, so 10 bytes of
 * MOVEM/UNLK/RTS are outside the reference. Corrected, it is 784.
 *
 * 774 ref vs 776 got, 23 DIFFERING REGIONS -- the lowest count in this tranche,
 * and that is the evidence the argument order is right. A misordered argument
 * list would still compile and would still be about this size, but the two
 * streams would diverge at every one of the forty-two load sites; they do not.
 * Corrected for the missing epilogue the reference is 784, so the candidate is
 * 8 bytes under.
 *
 * The open with MODE_NEWFILE, the -1 failure return, the mask-then-sign-extend
 * on the banner head, all thirty-eight byte promotions, both long arguments,
 * the scratch pointer, the literal tag, the 52-byte write and the closing flush
 * match in kind and size.
 *
 * SASC-MISMATCH: argument-staging-depth
 *   ref:     2f44 0028 ... 2f6f 00bc ffff   stage into nn(A7), re-push via a
 *                                           walking 188(A7) displacement
 *   got:     the same staging with a different base offset, so the walking
 *            displacements differ by a constant
 *   summary: both compilers stage the arguments and re-push them; only the
 *            frame base differs, which is the A5-versus-A7 class again. With
 *            forty-two arguments this is the single largest concentration of
 *            relocated-field differences in the restored set, and cdiff masks
 *            all of it -- which is why the region count rather than the byte
 *            count is the number quoted above.
 *   scope:   program-wide, at every call with more arguments than registers.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern long DISKIO_OpenFileWithBuffer(char *path, long mode);
extern void WDISP_SPrintf(char *buf, char *fmt, ...);
extern long DISKIO_WriteBufferedBytes(long fh, char *buf, long len);
extern long DISKIO_CloseBufferedFileAndFlush(long fh);

extern char Global_STR_DF0_CONFIG_DAT_1[];
extern char Global_STR_DEFAULT_CONFIG_FORMATTED[];
extern char BRUSH_LabelScratch[];

extern short CONFIG_BannerCopperHeadByte;
extern long  CONFIG_TimeWindowMinutes;
extern long  CONFIG_ModeCycleGateDuration;

extern char CONFIG_RefreshIntervalMinutes;
extern char CTASKS_STR_C;
extern char CONFIG_NicheModeCycleBudget_Y;
extern char CONFIG_NicheModeCycleBudget_Static;
extern char CONFIG_SerializedNumericSlot05;
extern char CONFIG_NewgridWindowSpanHalfHoursPrimary;
extern char CTASKS_STR_G;
extern char CONFIG_SerializedFlagSlot08_DefaultN;
extern char CTASKS_STR_A;
extern char CTASKS_STR_E;
extern char CONFIG_SerializedNumericSlot10;
extern char CONFIG_NicheModeCycleBudget_Custom;
extern char CONFIG_NewgridSelectionCode34PrimaryEnabledFlag;
extern char CONFIG_NewgridSelectionCode35EnabledFlag;
extern char CONFIG_SerializedFlagSlot15_DefaultN;
extern char CONFIG_NewgridSelectionCode34AltEnabledFlag;
extern char CONFIG_NewgridSelectionCode32EnabledFlag;
extern char CONFIG_RuntimeMode12BannerJumpEnabledFlag;
extern char CTASKS_STR_L;
extern char CONFIG_SerializedNumericSlot19;
extern char CONFIG_SerializedNumericSlot20;
extern char CONFIG_ModeCycleEnabledFlag;
extern char CONFIG_NewgridPlaceholderBevelFlag;
extern char CONFIG_NewgridSelectionCode48_49EnabledFlag;
extern char CONFIG_SerializedNumericSlot25;
extern char CONFIG_SerializedNumericSlot26;
extern char CONFIG_NewgridWindowSpanHalfHoursAlt;
extern char CONFIG_NewgridSelectionCode16EnabledFlag;
extern char Global_REF_STR_USE_24_HR_CLOCK;
extern char CONFIG_ParseiniLogoScanEnabledFlag;
extern char Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES;
extern char ED_DiagTextModeChar;
extern char CONFIG_EnsurePc1GfxAssignedFlag;
extern char CONFIG_MsnRuntimeModeSelectorChar_LRBN;
extern char CONFIG_LRBN_FlagChar;
extern char CONFIG_MSN_FlagChar;
extern char CTASKS_STR_1;

long DISKIO_SaveConfigToFileHandle(void)
{
    char buf[58];
    char bannerHead;
    long tag;
    long fh;

    fh = DISKIO_OpenFileWithBuffer(Global_STR_DF0_CONFIG_DAT_1, 1006L);

    if (fh == 0)
        return -1;

    tag        = 67;
    bannerHead = (char)(CONFIG_BannerCopperHeadByte & 0xff);

    WDISP_SPrintf(
        buf, Global_STR_DEFAULT_CONFIG_FORMATTED,
        CONFIG_RefreshIntervalMinutes,
        CTASKS_STR_C,
        CONFIG_NicheModeCycleBudget_Y,
        CONFIG_NicheModeCycleBudget_Static,
        CONFIG_SerializedNumericSlot05,
        CONFIG_NewgridWindowSpanHalfHoursPrimary,
        CTASKS_STR_G,
        CONFIG_SerializedFlagSlot08_DefaultN,
        CTASKS_STR_A,
        CTASKS_STR_E,
        CONFIG_SerializedNumericSlot10,
        CONFIG_NicheModeCycleBudget_Custom,
        CONFIG_NewgridSelectionCode34PrimaryEnabledFlag,
        CONFIG_NewgridSelectionCode35EnabledFlag,
        CONFIG_SerializedFlagSlot15_DefaultN,
        CONFIG_NewgridSelectionCode34AltEnabledFlag,
        CONFIG_NewgridSelectionCode32EnabledFlag,
        CONFIG_RuntimeMode12BannerJumpEnabledFlag,
        CTASKS_STR_L,
        CONFIG_SerializedNumericSlot19,
        CONFIG_SerializedNumericSlot20,
        CONFIG_ModeCycleEnabledFlag,
        CONFIG_NewgridPlaceholderBevelFlag,
        CONFIG_NewgridSelectionCode48_49EnabledFlag,
        CONFIG_SerializedNumericSlot25,
        CONFIG_SerializedNumericSlot26,
        CONFIG_NewgridWindowSpanHalfHoursAlt,
        CONFIG_TimeWindowMinutes,
        CONFIG_ModeCycleGateDuration,
        BRUSH_LabelScratch,
        CONFIG_NewgridSelectionCode16EnabledFlag,
        Global_REF_STR_USE_24_HR_CLOCK,
        CONFIG_ParseiniLogoScanEnabledFlag,
        tag,
        bannerHead,
        Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES,
        ED_DiagTextModeChar,
        CONFIG_EnsurePc1GfxAssignedFlag,
        CONFIG_MsnRuntimeModeSelectorChar_LRBN,
        CONFIG_LRBN_FlagChar,
        CONFIG_MSN_FlagChar,
        CTASKS_STR_1);

    DISKIO_WriteBufferedBytes(fh, buf, 52L);

    return DISKIO_CloseBufferedFileAndFlush(fh);
}
