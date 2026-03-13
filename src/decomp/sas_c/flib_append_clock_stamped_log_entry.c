typedef unsigned char UBYTE;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef signed long LONG;
typedef unsigned long ULONG;

#define MEMF_PUBLIC 1

extern LONG ESQPARS2_LogAppendSpinlock;
extern UWORD FLIB_LogEntryByteCount;
extern WORD CLOCK_CacheHour;
extern WORD CLOCK_CacheMinuteOrSecond;
extern WORD CLOCK_CacheAmPmFlag;
extern WORD Global_REF_CLOCKDATA_STRUCT;
extern const char ESQPARS2_LogTimestampFmt[];
extern const char ESQPARS2_LogTagPm[];
extern const char ESQPARS2_LogTagAm[];
extern const char ESQPARS2_LogFieldTab[];
extern const char ESQPARS2_LogLineTerminator[];
extern char *NEWGRID2_ErrorLogEntryPtr;
extern const char Global_STR_FLIB_C_1[];
extern const char Global_STR_FLIB_C_2[];

extern LONG MATH_DivS32(LONG value, LONG divisor);
extern LONG WDISP_SPrintf(char *dst, const char *fmt, ...);
extern char *STRING_AppendAtNull(char *dst, const char *src);
extern void *MEMORY_AllocateMemory(ULONG size, ULONG flags);
extern void MEMORY_DeallocateMemory(void *ptr, ULONG size);
extern char *ESQPARS_ReplaceOwnedString(const char *new_src, char *old_owned);

LONG FLIB_AppendClockStampedLogEntry(char *entry_text)
{
    LONG msg_len = 0;
    LONG hour2;
    LONG min2;
    LONG date2;
    const char *ampm_tag;
    char scratch[120];
    UWORD prior_total;
    UWORD new_total;
    char *tmp;

    while (ESQPARS2_LogAppendSpinlock != 0) {
    }

    ESQPARS2_LogAppendSpinlock = 1;

    if (FLIB_LogEntryByteCount > 0x2710) {
        ESQPARS2_LogAppendSpinlock = 0;
        return 0;
    }

    while (entry_text[msg_len] != '\0') {
        ++msg_len;
    }

    if (msg_len > 100) {
        msg_len = 100;
        entry_text[99] = '\0';
    }

    hour2 = MATH_DivS32((LONG)CLOCK_CacheHour, 100);
    min2 = MATH_DivS32((LONG)CLOCK_CacheMinuteOrSecond, 100);
    date2 = MATH_DivS32((LONG)Global_REF_CLOCKDATA_STRUCT, 100);
    ampm_tag = (CLOCK_CacheAmPmFlag != 0) ? ESQPARS2_LogTagPm : ESQPARS2_LogTagAm;

    WDISP_SPrintf(scratch, ESQPARS2_LogTimestampFmt, hour2, min2, date2, ampm_tag);
    msg_len += 14;

    STRING_AppendAtNull(scratch, ESQPARS2_LogFieldTab);
    STRING_AppendAtNull(scratch, entry_text);
    STRING_AppendAtNull(scratch, ESQPARS2_LogLineTerminator);

    prior_total = FLIB_LogEntryByteCount;
    new_total = (UWORD)(prior_total + (UWORD)msg_len);
    FLIB_LogEntryByteCount = new_total;

    tmp = (char *)MEMORY_AllocateMemory((ULONG)new_total + 1, MEMF_PUBLIC);

    if (prior_total != (UWORD)msg_len) {
        char *src = NEWGRID2_ErrorLogEntryPtr;
        char *dst = tmp;
        if (src != (char *)0 && dst != (char *)0) {
            do {
                *dst++ = *src;
            } while (*src++ != '\0');
        }
    } else if (tmp != (char *)0) {
        tmp[0] = '\0';
    }

    STRING_AppendAtNull(tmp, scratch);

    NEWGRID2_ErrorLogEntryPtr = ESQPARS_ReplaceOwnedString(tmp, NEWGRID2_ErrorLogEntryPtr);

    MEMORY_DeallocateMemory(tmp, (ULONG)FLIB_LogEntryByteCount + 1);

    ESQPARS2_LogAppendSpinlock = 0;
    return 0;
}
