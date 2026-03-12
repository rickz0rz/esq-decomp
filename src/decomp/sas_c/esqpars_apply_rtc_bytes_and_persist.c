typedef signed char BYTE;
typedef signed short WORD;
typedef signed long LONG;

extern WORD ESQPARS2_ReadModeFlags;

extern void ESQDISP_NormalizeClockAndRedrawBanner(void *clock_data);
extern void PARSEINI_WriteRtcFromGlobals(void);

void ESQPARS_ApplyRtcBytesAndPersist(BYTE *src)
{
    WORD clock_data[8];
    WORD saved_mode;

    clock_data[0] = (WORD)src[0];
    clock_data[1] = (WORD)src[1];
    clock_data[2] = (WORD)src[2];
    clock_data[3] = (WORD)((LONG)(WORD)src[3] + 1900L);
    clock_data[4] = (WORD)src[4];
    clock_data[5] = (WORD)src[5];
    clock_data[6] = (WORD)src[6];
    clock_data[7] = (WORD)src[7];

    ESQDISP_NormalizeClockAndRedrawBanner(clock_data);

    saved_mode = ESQPARS2_ReadModeFlags;
    ESQPARS2_ReadModeFlags = 256;
    PARSEINI_WriteRtcFromGlobals();
    ESQPARS2_ReadModeFlags = saved_mode;
}
