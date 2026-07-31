/* RESTORES: FLIB_AppendClockStampedLogEntry
 * MODULE:   modules/groups/a/r/flib.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a7-frame
 *   ref:     4e55ff7c48e70110266d00084ab900005f2c66f8700123c000005f2c30390000b4d80c4027106f0c42b900005f2c70006000013e204b4a1866fc538891cb2e087064be406f062e00422b0063303900009aaa48c072644eba6f08303900009aac48c02f41000872644eba6ef6303900009aae48c02f41000c72644eba6ee44a7900009ab4670841f900005f48600641f900005f4c2f082f012f2f00142f2f0014487900005f30486dff894eba4a864fef00180647000e487900005f50486dff894eba01702e8b486dff894eba0166487900005f52486dff894eba01584fef001430390000b4d82200d24733c10000b4d848c15281487800012f01487800ad487900005f564eba6e844fef001032390000b4d82b40fffcb247670e207900006d28224012d866fc600420404210486dff892f2dfffc4eba00fc2eb900006d282f2dfffc4ebacaa623c000006d2830390000b4d848c052802e802f2dfffc487800c6487900005f5e4eba6e0a42b900005f2c
 *   got:     9efc008048e701342a6f00944ab90000000066f8700123c0000000003039000000000c4027106f0c42b900000000700060000132204d4a1866fc538891cd2e087064be406f063e00422d0063303900000000670845f900000000600645f90000000030390000000048c072646100000030390000000048c02f41001072646100000030390000000048c02f4100147264610000002f0a2f012f2f001c2f2f001c487900000000486f002d610000000647000e487900000000486f0035610000002e8d486f003961000000487900000000486f0041610000003039000000003200d24733c10000000048c15281487800012f01487800ad4879000000006100000026404fef003c303900000000b047670e207900000000224b12d866fc60024213486f00192f0b610000002eb9000000002f0b6100000023c00000000030390000000048c052802e802f0b487800c64879000000006100000042b9000000004fef001870004cdf2c80defc00804e754e71
 *   summary: 368 got vs 368 ref, size-exact. The reference stops at FLIB_AppendClockStampedLogEntry_Return, so the two streams agree over the whole extracted body. The divergence is the frame register: LINK.W A5,#-132 with negative A5 displacements against SUBA.W with A7 displacements. The spin on the append lock, the 0x2710 size cap, the 100-character truncation with its NUL at offset 99, the three modulo-100 clock divides through the helper, the am/pm tag choice, the six-argument timestamp SPrintf, the three appends, the allocate/copy/replace/deallocate sequence and the lock release all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

#define MEMF_PUBLIC 1L

extern long  ESQPARS2_LogAppendSpinlock;
extern short FLIB_LogEntryByteCount;
extern short CLOCK_CacheHour;
extern short CLOCK_CacheMinuteOrSecond;
extern short Global_REF_CLOCKDATA_STRUCT;
extern short CLOCK_CacheAmPmFlag;
extern char *NEWGRID2_ErrorLogEntryPtr;
extern char  ESQPARS2_LogTagPm[];
extern char  ESQPARS2_LogTagAm[];
extern char  ESQPARS2_LogTimestampFmt[];
extern char  ESQPARS2_LogFieldTab[];
extern char  ESQPARS2_LogLineTerminator[];
extern char  Global_STR_FLIB_C_1[];
extern char  Global_STR_FLIB_C_2[];

extern long __asm NEWGRID_JMPTBL_MATH_DivS32(register __d0 long a,
                        register __d1 long b);
extern void  GROUP_AW_JMPTBL_WDISP_SPrintf(char *buf, char *fmt, long h, long m,
                                           long s, char *tag);
extern void  GROUP_AR_JMPTBL_STRING_AppendAtNull(char *dst, char *src);
extern char *NEWGRID_JMPTBL_MEMORY_AllocateMemory(char *who, long line,
                                                  long size, long flags);
extern void  NEWGRID_JMPTBL_MEMORY_DeallocateMemory(char *who, long line,
                                                    char *ptr, long size);
extern char *ESQPARS_ReplaceOwnedString(char *src, char *owned);

long FLIB_AppendClockStampedLogEntry(char *text)
{
    char  line[119];
    char *buf;
    short len;
    char *tag;

    while (ESQPARS2_LogAppendSpinlock != 0)
        ;
    ESQPARS2_LogAppendSpinlock = 1;

    if (FLIB_LogEntryByteCount > 0x2710) {
        ESQPARS2_LogAppendSpinlock = 0;
        return 0;
    }

    len = strlen(text);
    if (len > 100) {
        len = 100;
        text[99] = 0;
    }

    tag = CLOCK_CacheAmPmFlag != 0 ? ESQPARS2_LogTagPm : ESQPARS2_LogTagAm;
    GROUP_AW_JMPTBL_WDISP_SPrintf(line, ESQPARS2_LogTimestampFmt,
        CLOCK_CacheHour % 100, CLOCK_CacheMinuteOrSecond % 100,
        Global_REF_CLOCKDATA_STRUCT % 100, tag);

    len += 14;
    GROUP_AR_JMPTBL_STRING_AppendAtNull(line, ESQPARS2_LogFieldTab);
    GROUP_AR_JMPTBL_STRING_AppendAtNull(line, text);
    GROUP_AR_JMPTBL_STRING_AppendAtNull(line, ESQPARS2_LogLineTerminator);

    FLIB_LogEntryByteCount = FLIB_LogEntryByteCount + len;

    buf = NEWGRID_JMPTBL_MEMORY_AllocateMemory(Global_STR_FLIB_C_1, 173,
              (long)FLIB_LogEntryByteCount + 1, MEMF_PUBLIC);

    if (FLIB_LogEntryByteCount != len)
        strcpy(buf, NEWGRID2_ErrorLogEntryPtr);
    else
        buf[0] = 0;

    GROUP_AR_JMPTBL_STRING_AppendAtNull(buf, line);
    NEWGRID2_ErrorLogEntryPtr = ESQPARS_ReplaceOwnedString(buf,
                                    NEWGRID2_ErrorLogEntryPtr);
    NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_FLIB_C_2, 198, buf,
                                           (long)FLIB_LogEntryByteCount + 1);
    ESQPARS2_LogAppendSpinlock = 0;
    return 0;
}
