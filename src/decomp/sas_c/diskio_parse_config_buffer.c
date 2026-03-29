#include <exec/types.h>

extern UBYTE CONFIG_RefreshIntervalMinutes;
extern UBYTE CTASKS_STR_C;
extern UBYTE CONFIG_NicheModeCycleBudget_Y;
extern UBYTE CONFIG_NicheModeCycleBudget_Static;
extern UBYTE CONFIG_SerializedNumericSlot05;
extern UBYTE CONFIG_NewgridWindowSpanHalfHoursPrimary;
extern UBYTE CTASKS_STR_G;
extern UBYTE CONFIG_SerializedFlagSlot08_DefaultN;
extern UBYTE CTASKS_STR_A;
extern UBYTE CTASKS_STR_E;
extern UBYTE CONFIG_SerializedNumericSlot10;
extern UBYTE CONFIG_NicheModeCycleBudget_Custom;
extern UBYTE CONFIG_NewgridSelectionCode34PrimaryEnabledFlag;
extern UBYTE CONFIG_NewgridSelectionCode35EnabledFlag;
extern UBYTE CONFIG_SerializedFlagSlot15_DefaultN;
extern UBYTE CONFIG_NewgridSelectionCode34AltEnabledFlag;
extern UBYTE CONFIG_NewgridSelectionCode32EnabledFlag;
extern UBYTE CONFIG_RuntimeMode12BannerJumpEnabledFlag;
extern UBYTE CTASKS_STR_L;
extern UBYTE CONFIG_SerializedNumericSlot19;
extern UBYTE CONFIG_SerializedNumericSlot20;
extern UBYTE CONFIG_ModeCycleEnabledFlag;
extern UBYTE CONFIG_NewgridPlaceholderBevelFlag;
extern UBYTE CONFIG_NewgridSelectionCode48_49EnabledFlag;
extern UBYTE CONFIG_SerializedNumericSlot25;
extern UBYTE CONFIG_SerializedNumericSlot26;
extern UBYTE CONFIG_NewgridWindowSpanHalfHoursAlt;
extern LONG CONFIG_TimeWindowMinutes;
extern LONG CONFIG_ModeCycleGateDuration;
extern UBYTE CONFIG_NewgridSelectionCode16EnabledFlag;
extern UBYTE Global_REF_STR_USE_24_HR_CLOCK;
extern UBYTE CONFIG_ParseiniLogoScanEnabledFlag;
extern UWORD CONFIG_BannerCopperHeadByte;
extern UBYTE Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES;
extern UBYTE ED_DiagTextModeChar;
extern UBYTE CONFIG_EnsurePc1GfxAssignedFlag;
extern UBYTE CONFIG_MsnRuntimeModeSelectorChar_LRBN;
extern UBYTE CONFIG_LRBN_FlagChar;
extern UBYTE CONFIG_MSN_FlagChar;
extern UBYTE CTASKS_STR_1;
extern LONG CONFIG_RefreshIntervalSeconds;

extern const UBYTE WDISP_CharClassTable[];
extern const char DISKIO_TAG_NRLS[];
extern const char DISKIO_TAG_LRBN[];
extern const char DISKIO_TAG_MSN[];
extern const char *Global_JMPTBL_HALF_HOURS_12_HR_FMT[];
extern const char *Global_JMPTBL_HALF_HOURS_24_HR_FMT[];
extern const char **Global_REF_STR_CLOCK_FORMAT;

extern LONG GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(const char *text);
extern void GROUP_AG_JMPTBL_ESQFUNC_UpdateRefreshModeState(LONG unusedSuspendFlag, LONG request);
extern LONG GROUP_AG_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern char *GROUP_AI_JMPTBL_STR_FindCharPtr(const char *text, LONG ch);
extern void BRUSH_SelectBrushByLabel(const char *label);
extern void DISKIO_EnsurePc1MountedAndGfxAssigned(void);
extern WORD GROUP_AG_JMPTBL_SCRIPT_BeginBannerCharTransition(LONG targetChar, LONG speedMs);

static LONG parse_two_digits(const char *buffer, ULONG offset)
{
    char text[3];

    text[0] = buffer[offset];
    text[1] = buffer[offset + 1];
    text[2] = '\0';

    return GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(text);
}

static LONG parse_three_digits(const char *buffer, ULONG offset)
{
    char text[4];

    text[0] = buffer[offset];
    text[1] = buffer[offset + 1];
    text[2] = buffer[offset + 2];
    text[3] = '\0';

    return GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(text);
}

static UBYTE parse_ascii_digit(UBYTE ch)
{
    return (UBYTE)((BYTE)(ch - '0'));
}

static UBYTE normalize_yes_no(UBYTE ch, UBYTE fallback)
{
    if (ch == 'Y' || ch == 'N') {
        return ch;
    }

    return fallback;
}

static UBYTE normalize_digit_0_to_9_or_zero(UBYTE ch)
{
    UBYTE value;

    value = parse_ascii_digit(ch);
    if ((BYTE)value < 0 || value > 9) {
        return 0;
    }

    return value;
}

static UBYTE normalize_case_if_lower(UBYTE ch)
{
    if ((WDISP_CharClassTable[ch] & 0x02U) != 0) {
        return (UBYTE)(ch - 32);
    }

    return ch;
}

static BOOL has_guarded_config_byte(ULONG index, ULONG size)
{
    return ((LONG)index < ((LONG)size - 1));
}

void DISKIO_ParseConfigBuffer(char *buffer, ULONG size)
{
    ULONG index;
    UBYTE value;
    UBYTE nextValue;

    index = 0;

    CONFIG_RefreshIntervalMinutes = parse_ascii_digit((UBYTE)buffer[index++]);
    CTASKS_STR_C = (UBYTE)buffer[index++];
    CONFIG_NicheModeCycleBudget_Y = parse_ascii_digit((UBYTE)buffer[index++]);
    CONFIG_NicheModeCycleBudget_Static = parse_ascii_digit((UBYTE)buffer[index++]);
    CONFIG_SerializedNumericSlot05 = (UBYTE)parse_two_digits(buffer, index);
    index += 2;
    CONFIG_NewgridWindowSpanHalfHoursPrimary = (UBYTE)parse_two_digits(buffer, index);
    index += 2;
    CTASKS_STR_G = (UBYTE)buffer[index++];

    if (has_guarded_config_byte(index, size)) {
        CONFIG_SerializedFlagSlot08_DefaultN = (UBYTE)buffer[index++];
    } else {
        CONFIG_SerializedFlagSlot08_DefaultN = 'N';
    }

    if (has_guarded_config_byte(index, size)) {
        CTASKS_STR_A = (UBYTE)buffer[index++];
    } else {
        CTASKS_STR_A = 'A';
    }

    CTASKS_STR_E = (UBYTE)buffer[index++];

    if (has_guarded_config_byte(index, size)) {
        CONFIG_SerializedNumericSlot10 =
            normalize_digit_0_to_9_or_zero((UBYTE)buffer[index++]);
    }

    if (has_guarded_config_byte(index, size)) {
        CONFIG_NicheModeCycleBudget_Custom =
            normalize_digit_0_to_9_or_zero((UBYTE)buffer[index++]);
    }

    if (has_guarded_config_byte(index, size)) {
        CONFIG_NewgridSelectionCode34PrimaryEnabledFlag =
            normalize_yes_no((UBYTE)buffer[index++], 'Y');
    }

    if (has_guarded_config_byte(index, size)) {
        CONFIG_NewgridSelectionCode35EnabledFlag =
            normalize_yes_no((UBYTE)buffer[index++], 'Y');
    }

    if (has_guarded_config_byte(index, size)) {
        CONFIG_SerializedFlagSlot15_DefaultN =
            normalize_yes_no((UBYTE)buffer[index++], 'N');
    }

    if (has_guarded_config_byte(index, size)) {
        CONFIG_NewgridSelectionCode34AltEnabledFlag =
            normalize_yes_no((UBYTE)buffer[index++], 'N');
    }

    if (has_guarded_config_byte(index, size)) {
        CONFIG_NewgridSelectionCode32EnabledFlag =
            normalize_yes_no((UBYTE)buffer[index++], 'Y');
    }

    if (has_guarded_config_byte(index, size)) {
        CONFIG_RuntimeMode12BannerJumpEnabledFlag =
            normalize_yes_no((UBYTE)buffer[index++], 'N');
    }

    if (has_guarded_config_byte(index, size)) {
        CTASKS_STR_L = (UBYTE)buffer[index++];
        if (CTASKS_STR_L != 'L' && CTASKS_STR_L != 'S' && CTASKS_STR_L != 'V') {
            CTASKS_STR_L = 'L';
        }
    }

    if (has_guarded_config_byte(index, size)) {
        CONFIG_SerializedNumericSlot19 = (UBYTE)parse_two_digits(buffer, index);
        index += 2;
    }

    if (has_guarded_config_byte(index, size)) {
        CONFIG_SerializedNumericSlot20 = (UBYTE)parse_two_digits(buffer, index);
        index += 2;
    }

    if (has_guarded_config_byte(index, size)) {
        CONFIG_ModeCycleEnabledFlag =
            normalize_yes_no((UBYTE)buffer[index++], 'Y');
    }

    if (has_guarded_config_byte(index, size)) {
        CONFIG_NewgridPlaceholderBevelFlag =
            normalize_yes_no((UBYTE)buffer[index++], 'Y');
    }

    if (has_guarded_config_byte(index, size)) {
        CONFIG_NewgridSelectionCode48_49EnabledFlag =
            normalize_yes_no((UBYTE)buffer[index++], 'N');
    }

    if (has_guarded_config_byte(index, size)) {
        CONFIG_SerializedNumericSlot25 = (UBYTE)parse_two_digits(buffer, index);
        index += 2;
    }

    if (has_guarded_config_byte(index, size)) {
        CONFIG_SerializedNumericSlot26 = (UBYTE)parse_two_digits(buffer, index);
        index += 2;
    }

    if (has_guarded_config_byte(index, size)) {
        CONFIG_NewgridWindowSpanHalfHoursAlt = (UBYTE)parse_two_digits(buffer, index);
        index += 2;
    }

    if (has_guarded_config_byte(index, size)) {
        CONFIG_TimeWindowMinutes = parse_three_digits(buffer, index);
        index += 3;
    }

    if (has_guarded_config_byte(index, size)) {
        CONFIG_ModeCycleGateDuration = (LONG)parse_ascii_digit((UBYTE)buffer[index++]);
        if (CONFIG_ModeCycleGateDuration < 1 || CONFIG_ModeCycleGateDuration > 9) {
            CONFIG_ModeCycleGateDuration = 1;
        }
    }

    if (has_guarded_config_byte(index, size)) {
        BRUSH_SelectBrushByLabel(&buffer[index]);
        index += 2;
    }

    if (has_guarded_config_byte(index, size)) {
        CONFIG_NewgridSelectionCode16EnabledFlag =
            normalize_yes_no((UBYTE)buffer[index++], 'Y');
    }

    if (has_guarded_config_byte(index, size)) {
        Global_REF_STR_USE_24_HR_CLOCK =
            normalize_yes_no((UBYTE)buffer[index++], 'N');

        if (Global_REF_STR_USE_24_HR_CLOCK == 'Y') {
            Global_REF_STR_CLOCK_FORMAT = Global_JMPTBL_HALF_HOURS_24_HR_FMT;
        } else {
            Global_REF_STR_CLOCK_FORMAT = Global_JMPTBL_HALF_HOURS_12_HR_FMT;
        }
    }

    if (has_guarded_config_byte(index, size)) {
        CONFIG_ParseiniLogoScanEnabledFlag =
            normalize_yes_no((UBYTE)buffer[index++], 'Y');
    }

    if (has_guarded_config_byte(index, size)) {
        value = normalize_case_if_lower((UBYTE)buffer[index++]);

        if (value == 'F') {
            CONFIG_BannerCopperHeadByte = 128;
            index += 1;
        } else if (value == 'C') {
            CONFIG_BannerCopperHeadByte = (UWORD)(UBYTE)buffer[index++];
        } else {
            CONFIG_BannerCopperHeadByte = 0x008E;
            index += 1;
        }

        if (CONFIG_BannerCopperHeadByte < 128 || CONFIG_BannerCopperHeadByte > 220) {
            CONFIG_BannerCopperHeadByte = 0x008E;
        }
    }

    if (has_guarded_config_byte(index, size)) {
        Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES =
            parse_ascii_digit((UBYTE)buffer[index++]);
        if (Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES != 8) {
            Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES = 8;
        }
    }

    if (has_guarded_config_byte(index, size)) {
        value = normalize_case_if_lower((UBYTE)buffer[index++]);
        ED_DiagTextModeChar = value;
        if (GROUP_AI_JMPTBL_STR_FindCharPtr(DISKIO_TAG_NRLS, (LONG)value) == 0 ||
            ED_DiagTextModeChar == 0) {
            ED_DiagTextModeChar = 'N';
        }
    }

    if (has_guarded_config_byte(index, size)) {
        CONFIG_EnsurePc1GfxAssignedFlag =
            normalize_yes_no((UBYTE)buffer[index++], 'N');
    }

    if (CONFIG_EnsurePc1GfxAssignedFlag == 'Y') {
        DISKIO_EnsurePc1MountedAndGfxAssigned();
    }

    if (has_guarded_config_byte(index, size)) {
        value = (UBYTE)buffer[index++];
        CONFIG_MsnRuntimeModeSelectorChar_LRBN = value;
        if (GROUP_AI_JMPTBL_STR_FindCharPtr(DISKIO_TAG_LRBN, (LONG)value) == 0 ||
            CONFIG_MsnRuntimeModeSelectorChar_LRBN == 0) {
            CONFIG_MsnRuntimeModeSelectorChar_LRBN = 'N';
        }
    }

    if (has_guarded_config_byte(index, size)) {
        value = normalize_yes_no((UBYTE)buffer[index++], 'Y');
        CONFIG_LRBN_FlagChar = value;
        if (CONFIG_LRBN_FlagChar != 'Y') {
            CONFIG_LRBN_FlagChar = 'Y';
            GROUP_AG_JMPTBL_SCRIPT_BeginBannerCharTransition(
                (LONG)CONFIG_BannerCopperHeadByte,
                0);
            CONFIG_LRBN_FlagChar = 'N';
        }
    }

    if (has_guarded_config_byte(index, size)) {
        value = (UBYTE)buffer[index++];
        CONFIG_MSN_FlagChar = value;
        if (GROUP_AI_JMPTBL_STR_FindCharPtr(DISKIO_TAG_MSN, (LONG)value) == 0) {
            CONFIG_MSN_FlagChar = 'N';
        }
    }

    if (has_guarded_config_byte(index, size)) {
        nextValue = (UBYTE)buffer[index++];
        CTASKS_STR_1 = nextValue;
        if (nextValue != '1' && nextValue != '2') {
            CTASKS_STR_1 = '1';
        }
    }

    GROUP_AG_JMPTBL_ESQFUNC_UpdateRefreshModeState(
        0,
        (LONG)(UBYTE)CONFIG_RefreshIntervalMinutes);

    CONFIG_RefreshIntervalSeconds =
        GROUP_AG_JMPTBL_MATH_Mulu32((LONG)(UBYTE)CONFIG_RefreshIntervalMinutes, 60);
}
