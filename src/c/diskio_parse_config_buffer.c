/* RESTORES: DISKIO_ParseConfigBuffer
 * MODULE:   modules/groups/a/g/diskio_p5_diskio_parseconfigbuffer.s
 * STATUS:   behavioural
 *
 * Unpacks the saved configuration record, byte by byte, into about forty globals.
 * 2022 bytes and almost no branching structure: it is one long sequence of
 * "if the record is long enough, take the next byte; otherwise leave the default".
 *
 * The FIRST NINE FIELDS ARE UNGUARDED -- the record is assumed to be at least
 * nine bytes -- and so is field 10, CTASKS_STR_E, which sits between two guarded
 * fields. That asymmetry is in the original and is not a transcription slip.
 *
 * Each guard is `pos < len - 1`, not `pos < len`, so the LAST byte of the record
 * is never consumed by a single-byte field. Two-digit fields copy into a
 * three-byte scratch and hand it to the numeric parser rather than doing the
 * arithmetic inline.
 *
 * The validated character fields fall back to different defaults and the defaults
 * are NOT uniform -- 'Y' for six of them, 'N' for six others, 'A' for CTASKS_STR_A
 * and 'L' for CTASKS_STR_L. They are transcribed one at a time from the register
 * the original happens to be holding at each site (`MOVE.B D0` vs `MOVE.B D2`),
 * because there is no rule to derive them from.
 *
 * THE COLOUR-PALETTE COUNT CAN ONLY EVER BE 8. The original tests the parsed digit
 * with `BLT` and then `BLE` against 8 and writes 8 on either failure, so every
 * value except 8 is replaced by 8. It is written here as two comparisons rather
 * than one, because that is what the original emits.
 *
 * THE LRBN FLAG IS WRITTEN THREE TIMES IN ONE PATH. When the parsed value is not
 * 'Y' the original stores 'Y', runs a banner-character transition, then stores
 * 'N'. The transition presumably reads the flag. Collapsing those stores would
 * change what the callee sees.
 *
 * `toupper` is open-coded twice against WDISP_CharClassTable bit 1, same idiom as
 * script_handle_brush_command.c.
 *
 * SASC-MISMATCH: register-argument-multiply
 *   ref:     723c 4eba....           MOVEQ #60,D1 / JSR MATH_Mulu32
 *   got:     the multiply inline
 *   summary: the closing seconds-per-interval conversion calls MATH_Mulu32 with
 *            both operands already in D0/D1. Written as `* 60`.
 *   scope:   program-wide wherever MATH_Mulu32 appears.
 *   retest:  a compiler whose multiply helper IS this routine.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba....                JSR (d16,PC)
 *   got:     61000000                BSR.W
 *   summary: same size, different opcode; costs nothing.
 *   scope:   the whole cross-unit bucket.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55fff8 ... 4e5d       LINK.W A5,#-8 / UNLK A5
 *   got:     A7-relative locals
 *   scope:   program-wide; docs/compiler-version.md.
 *   retest:  a compiler that reserves A5.
 *
 * SASC-MISMATCH: unattributed-body-delta
 *   summary: 2144 against 2022, +122 over 69 regions -- 6.0%, about three bytes
 *            per guarded block. NOT itemised, and recorded as a known-unknown per
 *            AGENTS.md rule 3.
 *            With forty near-identical guarded blocks, a per-hunk itemisation
 *            would be forty copies of the same register-allocation difference and
 *            would say nothing the total does not.
 *   retest:  itemise again on a compiler that reserves A5.
 */
#include <exec/types.h>

extern unsigned char WDISP_CharClassTable[];

extern unsigned char CONFIG_RefreshIntervalMinutes;
extern long  CONFIG_RefreshIntervalSeconds;
extern unsigned char CTASKS_STR_C;
extern unsigned char CTASKS_STR_A;
extern unsigned char CTASKS_STR_E;
extern unsigned char CTASKS_STR_G;
extern unsigned char CTASKS_STR_L;
extern unsigned char CTASKS_STR_1;
extern char  CONFIG_NicheModeCycleBudget_Y;
extern char  CONFIG_NicheModeCycleBudget_Static;
extern char  CONFIG_NicheModeCycleBudget_Custom;
extern char  CONFIG_SerializedNumericSlot05;
extern char  CONFIG_NewgridWindowSpanHalfHoursPrimary;
extern char  CONFIG_NewgridWindowSpanHalfHoursAlt;
extern unsigned char CONFIG_SerializedFlagSlot08_DefaultN;
extern char  CONFIG_SerializedNumericSlot10;
extern unsigned char CONFIG_NewgridSelectionCode34PrimaryEnabledFlag;
extern unsigned char CONFIG_NewgridSelectionCode35EnabledFlag;
extern unsigned char CONFIG_SerializedFlagSlot15_DefaultN;
extern unsigned char CONFIG_NewgridSelectionCode34AltEnabledFlag;
extern unsigned char CONFIG_NewgridSelectionCode32EnabledFlag;
extern unsigned char CONFIG_RuntimeMode12BannerJumpEnabledFlag;
extern char  CONFIG_SerializedNumericSlot19;
extern char  CONFIG_SerializedNumericSlot20;
extern char  CONFIG_SerializedNumericSlot25;
extern char  CONFIG_SerializedNumericSlot26;
extern unsigned char CONFIG_ModeCycleEnabledFlag;
extern unsigned char CONFIG_NewgridPlaceholderBevelFlag;
extern unsigned char CONFIG_NewgridSelectionCode48_49EnabledFlag;
extern unsigned char CONFIG_NewgridSelectionCode16EnabledFlag;
extern unsigned char CONFIG_ParseiniLogoScanEnabledFlag;
extern unsigned char CONFIG_EnsurePc1GfxAssignedFlag;
extern unsigned char CONFIG_MsnRuntimeModeSelectorChar_LRBN;
extern unsigned char CONFIG_LRBN_FlagChar;
extern unsigned char CONFIG_MSN_FlagChar;
extern long  CONFIG_TimeWindowMinutes;
extern long  CONFIG_ModeCycleGateDuration;
extern short CONFIG_BannerCopperHeadByte;
extern unsigned char ED_DiagTextModeChar;
extern char  Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES;
extern unsigned char Global_REF_STR_USE_24_HR_CLOCK;
extern void *Global_REF_STR_CLOCK_FORMAT;
extern void *Global_JMPTBL_HALF_HOURS_24_HR_FMT;
extern void *Global_JMPTBL_HALF_HOURS_12_HR_FMT;
extern char  DISKIO_TAG_NRLS[];
extern char  DISKIO_TAG_LRBN[];
extern char  DISKIO_TAG_MSN[];

extern long  PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern char *STR_FindCharPtr(char *s, long c);
extern void  BRUSH_SelectBrushByLabel(char *label);
extern void  DISKIO_EnsurePc1MountedAndGfxAssigned(void);
extern void  SCRIPT_BeginBannerCharTransition(long code,
                                                              long flag);
extern void  ESQFUNC_UpdateRefreshModeState(long a, long b);

void DISKIO_ParseConfigBuffer(char *buf, long len)
{
    char  digits[4];
    short pos;
    char  v;
    unsigned char c;
    unsigned char upper;
    long  n;

    pos = 0;
    CONFIG_RefreshIntervalMinutes = buf[pos++] - 48;
    CTASKS_STR_C = buf[pos++];
    CONFIG_NicheModeCycleBudget_Y = buf[pos++] - 48;
    CONFIG_NicheModeCycleBudget_Static = buf[pos++] - 48;

    digits[0] = buf[pos++];
    digits[1] = buf[pos++];
    digits[2] = 0;
    CONFIG_SerializedNumericSlot05 =
        (char)PARSE_ReadSignedLongSkipClass3_Alt(digits);

    digits[0] = buf[pos++];
    digits[1] = buf[pos++];
    digits[2] = 0;
    CONFIG_NewgridWindowSpanHalfHoursPrimary =
        (char)PARSE_ReadSignedLongSkipClass3_Alt(digits);

    CTASKS_STR_G = buf[pos++];

    if ((long)pos < len - 1)
        CONFIG_SerializedFlagSlot08_DefaultN = buf[pos++];
    else
        CONFIG_SerializedFlagSlot08_DefaultN = 78;

    if ((long)pos < len - 1)
        CTASKS_STR_A = buf[pos++];
    else
        CTASKS_STR_A = 'A';

    CTASKS_STR_E = buf[pos++];

    if ((long)pos < len - 1) {
        v = buf[pos++] - 48;
        CONFIG_SerializedNumericSlot10 = v;
        if (v < 0 || v > 9)
            CONFIG_SerializedNumericSlot10 = 0;
    }

    if ((long)pos < len - 1) {
        v = buf[pos++] - 48;
        CONFIG_NicheModeCycleBudget_Custom = v;
        if (v < 0 || v > 9)
            CONFIG_NicheModeCycleBudget_Custom = 0;
    }

    if ((long)pos < len - 1) {
        c = buf[pos++];
        CONFIG_NewgridSelectionCode34PrimaryEnabledFlag = c;
        if (c != 89 && c != 78)
            CONFIG_NewgridSelectionCode34PrimaryEnabledFlag = 89;
    }

    if ((long)pos < len - 1) {
        c = buf[pos++];
        CONFIG_NewgridSelectionCode35EnabledFlag = c;
        if (c != 89 && c != 78)
            CONFIG_NewgridSelectionCode35EnabledFlag = 89;
    }

    if ((long)pos < len - 1) {
        c = buf[pos++];
        CONFIG_SerializedFlagSlot15_DefaultN = c;
        if (c != 89 && c != 78)
            CONFIG_SerializedFlagSlot15_DefaultN = 78;
    }

    if ((long)pos < len - 1) {
        c = buf[pos++];
        CONFIG_NewgridSelectionCode34AltEnabledFlag = c;
        if (c != 89 && c != 78)
            CONFIG_NewgridSelectionCode34AltEnabledFlag = 78;
    }

    if ((long)pos < len - 1) {
        c = buf[pos++];
        CONFIG_NewgridSelectionCode32EnabledFlag = c;
        if (c != 89 && c != 78)
            CONFIG_NewgridSelectionCode32EnabledFlag = 89;
    }

    if ((long)pos < len - 1) {
        c = buf[pos++];
        CONFIG_RuntimeMode12BannerJumpEnabledFlag = c;
        if (c != 89 && c != 78)
            CONFIG_RuntimeMode12BannerJumpEnabledFlag = 78;
    }

    if ((long)pos < len - 1) {
        c = buf[pos++];
        CTASKS_STR_L = c;
        if (c != 76 && c != 83 && c != 86)
            CTASKS_STR_L = 76;
    }

    if ((long)pos < len - 1) {
        digits[0] = buf[pos++];
        digits[1] = buf[pos++];
        digits[2] = 0;
        CONFIG_SerializedNumericSlot19 =
            (char)PARSE_ReadSignedLongSkipClass3_Alt(digits);
    }

    if ((long)pos < len - 1) {
        digits[0] = buf[pos++];
        digits[1] = buf[pos++];
        digits[2] = 0;
        CONFIG_SerializedNumericSlot20 =
            (char)PARSE_ReadSignedLongSkipClass3_Alt(digits);
    }

    if ((long)pos < len - 1) {
        c = buf[pos++];
        CONFIG_ModeCycleEnabledFlag = c;
        if (c != 89 && c != 78)
            CONFIG_ModeCycleEnabledFlag = 89;
    }

    if ((long)pos < len - 1) {
        c = buf[pos++];
        CONFIG_NewgridPlaceholderBevelFlag = c;
        if (c != 89 && c != 78)
            CONFIG_NewgridPlaceholderBevelFlag = 89;
    }

    if ((long)pos < len - 1) {
        c = buf[pos++];
        CONFIG_NewgridSelectionCode48_49EnabledFlag = c;
        if (c != 89 && c != 78)
            CONFIG_NewgridSelectionCode48_49EnabledFlag = 78;
    }

    if ((long)pos < len - 1) {
        digits[0] = buf[pos++];
        digits[1] = buf[pos++];
        digits[2] = 0;
        CONFIG_SerializedNumericSlot25 =
            (char)PARSE_ReadSignedLongSkipClass3_Alt(digits);
    }

    if ((long)pos < len - 1) {
        digits[0] = buf[pos++];
        digits[1] = buf[pos++];
        digits[2] = 0;
        CONFIG_SerializedNumericSlot26 =
            (char)PARSE_ReadSignedLongSkipClass3_Alt(digits);
    }

    if ((long)pos < len - 1) {
        digits[0] = buf[pos++];
        digits[1] = buf[pos++];
        digits[2] = 0;
        CONFIG_NewgridWindowSpanHalfHoursAlt =
            (char)PARSE_ReadSignedLongSkipClass3_Alt(digits);
    }

    if ((long)pos < len - 1) {
        digits[0] = buf[pos++];
        digits[1] = buf[pos++];
        digits[2] = buf[pos++];
        digits[3] = 0;
        CONFIG_TimeWindowMinutes =
            PARSE_ReadSignedLongSkipClass3_Alt(digits);
    }

    if ((long)pos < len - 1) {
        n = (long)(unsigned char)buf[pos++] - 48;
        CONFIG_ModeCycleGateDuration = n;
        if (n < 0 || n > 9)
            CONFIG_ModeCycleGateDuration = 1;
    }

    if ((long)pos < len - 1) {
        digits[0] = buf[pos++];
        digits[1] = buf[pos++];
        digits[2] = 0;
        BRUSH_SelectBrushByLabel(digits);
    }

    if ((long)pos < len - 1) {
        c = buf[pos++];
        CONFIG_NewgridSelectionCode16EnabledFlag = c;
        if (c != 89 && c != 78)
            CONFIG_NewgridSelectionCode16EnabledFlag = 89;
    }

    if ((long)pos < len - 1) {
        c = buf[pos++];
        Global_REF_STR_USE_24_HR_CLOCK = c;
        if (c != 89 && c != 78)
            Global_REF_STR_USE_24_HR_CLOCK = 78;
        if (Global_REF_STR_USE_24_HR_CLOCK == 'Y')
            Global_REF_STR_CLOCK_FORMAT = &Global_JMPTBL_HALF_HOURS_24_HR_FMT;
        else
            Global_REF_STR_CLOCK_FORMAT = &Global_JMPTBL_HALF_HOURS_12_HR_FMT;
    }

    if ((long)pos < len - 1) {
        c = buf[pos++];
        CONFIG_ParseiniLogoScanEnabledFlag = c;
        if (c != 89 && c != 78)
            CONFIG_ParseiniLogoScanEnabledFlag = 89;
    }

    if ((long)pos < len - 1) {
        c = buf[pos++];
        upper = (WDISP_CharClassTable[c] & 2) ? (unsigned char)(c - 32) : c;
        if (upper == 67) {
            CONFIG_BannerCopperHeadByte = (unsigned char)buf[pos++];
        } else if (upper == 70) {
            CONFIG_BannerCopperHeadByte = 128;
            pos++;
        } else {
            CONFIG_BannerCopperHeadByte = 0x8e;
            pos++;
        }
        if ((unsigned short)CONFIG_BannerCopperHeadByte < 128 ||
            (unsigned short)CONFIG_BannerCopperHeadByte > 220)
            CONFIG_BannerCopperHeadByte = 0x8e;
    }

    if ((long)pos < len - 1) {
        v = buf[pos++] - 48;
        Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES = v;
        if (v < 8)
            Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES = 8;
        else if (v > 8)
            Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES = 8;
    }

    if ((long)pos < len - 1) {
        c = buf[pos++];
        upper = (WDISP_CharClassTable[c] & 2) ? (unsigned char)(c - 32) : c;
        ED_DiagTextModeChar = upper;
        if (STR_FindCharPtr(DISKIO_TAG_NRLS,
                                           (long)(char)ED_DiagTextModeChar) == 0)
            ED_DiagTextModeChar = 78;
        else if (ED_DiagTextModeChar == 0)
            ED_DiagTextModeChar = 78;
    }

    if ((long)pos < len - 1) {
        c = buf[pos++];
        CONFIG_EnsurePc1GfxAssignedFlag = c;
        if (c != 89 && c != 78)
            CONFIG_EnsurePc1GfxAssignedFlag = 78;
    }

    if (CONFIG_EnsurePc1GfxAssignedFlag == 'Y')
        DISKIO_EnsurePc1MountedAndGfxAssigned();

    if ((long)pos < len - 1) {
        c = buf[pos++];
        CONFIG_MsnRuntimeModeSelectorChar_LRBN = c;
        if (STR_FindCharPtr(
                DISKIO_TAG_LRBN,
                (long)(short)(char)CONFIG_MsnRuntimeModeSelectorChar_LRBN) == 0)
            CONFIG_MsnRuntimeModeSelectorChar_LRBN = 78;
        else if (CONFIG_MsnRuntimeModeSelectorChar_LRBN == 0)
            CONFIG_MsnRuntimeModeSelectorChar_LRBN = 78;
    }

    if ((long)pos < len - 1) {
        c = buf[pos++];
        CONFIG_LRBN_FlagChar = c;
        if (c != 89 && c != 78)
            CONFIG_LRBN_FlagChar = 89;
        /* Three stores in one path: the transition reads the flag. */
        if (CONFIG_LRBN_FlagChar != 'Y') {
            CONFIG_LRBN_FlagChar = 89;
            SCRIPT_BeginBannerCharTransition(
                (long)CONFIG_BannerCopperHeadByte, 0L);
            CONFIG_LRBN_FlagChar = 'N';
        }
    }

    if ((long)pos < len - 1) {
        c = buf[pos++];
        CONFIG_MSN_FlagChar = c;
        if (STR_FindCharPtr(
                DISKIO_TAG_MSN,
                (long)(short)(char)CONFIG_MSN_FlagChar) == 0)
            CONFIG_MSN_FlagChar = 'N';
    }

    if ((long)pos < len - 1) {
        c = buf[pos++];
        CTASKS_STR_1 = c;
        if (c != 49 && c != 50)
            CTASKS_STR_1 = 49;
    }

    ESQFUNC_UpdateRefreshModeState(
        0L, (long)(char)CONFIG_RefreshIntervalMinutes);
    CONFIG_RefreshIntervalSeconds =
        (long)(char)CONFIG_RefreshIntervalMinutes * 60;
}
