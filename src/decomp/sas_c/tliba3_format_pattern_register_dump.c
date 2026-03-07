typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;

extern UWORD TLIBA1_DiagDiwOffset;
extern UWORD TLIBA1_DiagDdfOffset;
extern UWORD TLIBA1_DiagBplcon1Value;

extern const char TLIBA1_FMT_PCT_S_COLON_DIWOFFSET_PCT_04LX_DDFOF[];
extern const char TLIBA1_FMT_DIWSTRT_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern const char TLIBA1_FMT_DIWSTOP_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern const char TLIBA1_FMT_DDFSTRT_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern const char TLIBA1_FMT_DDFSTOP_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern const char TLIBA1_FMT_BPL1MOD_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern const char TLIBA1_FMT_BPL2MOD_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern const char TLIBA1_FMT_BPLCON0_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern const char TLIBA1_FMT_BPLCON1_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern const char TLIBA1_FMT_BPLCON2_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern const char TLIBA1_FMT_BPL1PTH_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern const char TLIBA1_FMT_BPL1PTL_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern const char TLIBA1_FMT_BPL2PTH_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern const char TLIBA1_FMT_BPL2PTL_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern const char TLIBA1_FMT_BPL3PTH_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern const char TLIBA1_FMT_BPL3PTL_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern const char TLIBA1_FMT_BPL4PTH_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern const char TLIBA1_FMT_BPL4PTL_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern const char TLIBA1_FMT_BPL5PTH_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern const char TLIBA1_FMT_BPL5PTL_COLON_0X_PCT_04LX_0X_PCT_04L[];
extern const char TLIBA1_STR_PatternDumpSeparatorNewline[];

extern void FORMAT_RawDoFmtWithScratchBuffer(const char *fmt, ...);

static ULONG join_ptr_words(UWORD hi, UWORD lo)
{
    return ((ULONG)hi << 16) | (ULONG)lo;
}

void TLIBA3_FormatPatternRegisterDump(const char *title, const UWORD *regs)
{
    FORMAT_RawDoFmtWithScratchBuffer(
        TLIBA1_FMT_PCT_S_COLON_DIWOFFSET_PCT_04LX_DDFOF,
        title,
        (ULONG)TLIBA1_DiagDiwOffset,
        (ULONG)TLIBA1_DiagDdfOffset,
        (ULONG)TLIBA1_DiagBplcon1Value);

    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_DIWSTRT_COLON_0X_PCT_04LX_0X_PCT_04L, (ULONG)regs[0], (ULONG)regs[1], (ULONG)regs[1]);
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_DIWSTOP_COLON_0X_PCT_04LX_0X_PCT_04L, (ULONG)regs[2], (ULONG)regs[3], (ULONG)regs[3] + 0x100UL);
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_DDFSTRT_COLON_0X_PCT_04LX_0X_PCT_04L, (ULONG)regs[4], (ULONG)regs[5], (ULONG)regs[5]);
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_DDFSTOP_COLON_0X_PCT_04LX_0X_PCT_04L, (ULONG)regs[6], (ULONG)regs[7], (ULONG)regs[7]);

    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_BPL1MOD_COLON_0X_PCT_04LX_0X_PCT_04L, (ULONG)regs[8], (ULONG)regs[9], (ULONG)regs[9]);
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_BPL2MOD_COLON_0X_PCT_04LX_0X_PCT_04L, (ULONG)regs[10], (ULONG)regs[11], (ULONG)regs[11]);
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_BPLCON0_COLON_0X_PCT_04LX_0X_PCT_04L, (ULONG)regs[12], (ULONG)regs[13], (ULONG)regs[13]);
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_BPLCON1_COLON_0X_PCT_04LX_0X_PCT_04L, (ULONG)regs[14], (ULONG)regs[15], (ULONG)regs[15]);
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_BPLCON2_COLON_0X_PCT_04LX_0X_PCT_04L, (ULONG)regs[16], (ULONG)regs[17], (ULONG)regs[17]);

    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_BPL1PTH_COLON_0X_PCT_04LX_0X_PCT_04L, (ULONG)regs[18], (ULONG)regs[19]);
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_BPL1PTL_COLON_0X_PCT_04LX_0X_PCT_04L, (ULONG)regs[20], (ULONG)regs[21], join_ptr_words(regs[19], regs[21]));
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_BPL2PTH_COLON_0X_PCT_04LX_0X_PCT_04L, (ULONG)regs[22], (ULONG)regs[23]);
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_BPL2PTL_COLON_0X_PCT_04LX_0X_PCT_04L, (ULONG)regs[24], (ULONG)regs[25], join_ptr_words(regs[23], regs[25]));
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_BPL3PTH_COLON_0X_PCT_04LX_0X_PCT_04L, (ULONG)regs[26], (ULONG)regs[27]);
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_BPL3PTL_COLON_0X_PCT_04LX_0X_PCT_04L, (ULONG)regs[28], (ULONG)regs[29], join_ptr_words(regs[27], regs[29]));
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_BPL4PTH_COLON_0X_PCT_04LX_0X_PCT_04L, (ULONG)regs[30], (ULONG)regs[31]);
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_BPL4PTL_COLON_0X_PCT_04LX_0X_PCT_04L, (ULONG)regs[32], (ULONG)regs[33], join_ptr_words(regs[31], regs[33]));
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_BPL5PTH_COLON_0X_PCT_04LX_0X_PCT_04L, (ULONG)regs[34], (ULONG)regs[35]);
    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_FMT_BPL5PTL_COLON_0X_PCT_04LX_0X_PCT_04L, (ULONG)regs[36], (ULONG)regs[37], join_ptr_words(regs[35], regs[37]));

    FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_STR_PatternDumpSeparatorNewline);
}
