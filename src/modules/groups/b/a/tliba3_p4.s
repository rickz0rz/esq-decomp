    XDEF    TLIBA3_FormatPatternRegisterDump


;------------------------------------------------------------------------------
; FUNC: TLIBA3_FormatPatternRegisterDump   (TLIBA3_FormatPatternRegisterDump)
; ARGS:
;   stack +76: arg_1 (via 80(A5))
;   stack +80: arg_2 (via 84(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A7/D0/D1/D2/D3/D7
; CALLS:
;   FORMAT_RawDoFmtWithScratchBuffer, TLIBA3_FormatPatternRegisterDump, _MATH_Mulu32, _WDISP_SPrintf
; READS:
;   Global_STR_VM_ARRAY_1, Global_STR_VM_ARRAY_2, _TLIBA1_CurrentViewModeIndex, TLIBA1_DiagDiwOffset, TLIBA1_DiagDdfOffset, TLIBA1_DiagBplcon1Value, TLIBA1_FMT_PCT_S_COLON_DIWOFFSET_PCT_04LX_DDFOF, TLIBA1_FMT_DIWSTRT_COLON_0X_PCT_04LX_0X_PCT_04L, TLIBA1_FMT_DIWSTOP_COLON_0X_PCT_04LX_0X_PCT_04L, TLIBA1_FMT_DDFSTRT_COLON_0X_PCT_04LX_0X_PCT_04L, TLIBA1_FMT_DDFSTOP_COLON_0X_PCT_04LX_0X_PCT_04L, TLIBA1_FMT_BPL1MOD_COLON_0X_PCT_04LX_0X_PCT_04L, TLIBA1_FMT_BPL2MOD_COLON_0X_PCT_04LX_0X_PCT_04L, TLIBA1_FMT_BPLCON0_COLON_0X_PCT_04LX_0X_PCT_04L, TLIBA1_FMT_BPLCON1_COLON_0X_PCT_04LX_0X_PCT_04L, TLIBA1_FMT_BPLCON2_COLON_0X_PCT_04LX_0X_PCT_04L, TLIBA1_FMT_BPL1PTH_COLON_0X_PCT_04LX_0X_PCT_04L, TLIBA1_FMT_BPL1PTL_COLON_0X_PCT_04LX_0X_PCT_04L, TLIBA1_FMT_BPL2PTH_COLON_0X_PCT_04LX_0X_PCT_04L, TLIBA1_FMT_BPL2PTL_COLON_0X_PCT_04LX_0X_PCT_04L, TLIBA1_FMT_BPL3PTH_COLON_0X_PCT_04LX_0X_PCT_04L, TLIBA1_FMT_BPL3PTL_COLON_0X_PCT_04LX_0X_PCT_04L, TLIBA1_FMT_BPL4PTH_COLON_0X_PCT_04LX_0X_PCT_04L, TLIBA1_FMT_BPL4PTL_COLON_0X_PCT_04LX_0X_PCT_04L, TLIBA1_FMT_BPL5PTH_COLON_0X_PCT_04LX_0X_PCT_04L, TLIBA1_FMT_BPL5PTL_COLON_0X_PCT_04LX_0X_PCT_04L, TLIBA1_STR_PatternDumpSeparatorNewline, TLIBA1_STR_PatternDumpLoopNewline, TLIBA3_VmArrayPatternTable
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
TLIBA3_FormatPatternRegisterDump:
    MOVEM.L D2-D3/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2
    MOVE.W  TLIBA1_DiagDiwOffset,D0
    EXT.L   D0
    MOVE.W  TLIBA1_DiagDdfOffset,D1
    EXT.L   D1
    MOVE.W  TLIBA1_DiagBplcon1Value,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    PEA     TLIBA1_FMT_PCT_S_COLON_DIWOFFSET_PCT_04LX_DDFOF
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  (A2),D0
    MOVEQ   #0,D1
    MOVE.W  2(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     TLIBA1_FMT_DIWSTRT_COLON_0X_PCT_04LX_0X_PCT_04L
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  4(A2),D0
    MOVEQ   #0,D1
    MOVE.W  6(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    ADDI.L  #$100,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     TLIBA1_FMT_DIWSTOP_COLON_0X_PCT_04LX_0X_PCT_04L
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  8(A2),D0
    MOVEQ   #0,D1
    MOVE.W  10(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     TLIBA1_FMT_DDFSTRT_COLON_0X_PCT_04LX_0X_PCT_04L
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  12(A2),D0
    MOVEQ   #0,D1
    MOVE.W  14(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     TLIBA1_FMT_DDFSTOP_COLON_0X_PCT_04LX_0X_PCT_04L
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     68(A7),A7
    MOVEQ   #0,D0
    MOVE.W  16(A2),D0
    MOVEQ   #0,D1
    MOVE.W  18(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     TLIBA1_FMT_BPL1MOD_COLON_0X_PCT_04LX_0X_PCT_04L
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  20(A2),D0
    MOVEQ   #0,D1
    MOVE.W  22(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     TLIBA1_FMT_BPL2MOD_COLON_0X_PCT_04LX_0X_PCT_04L
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  24(A2),D0
    MOVEQ   #0,D1
    MOVE.W  26(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     TLIBA1_FMT_BPLCON0_COLON_0X_PCT_04LX_0X_PCT_04L
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  28(A2),D0
    MOVEQ   #0,D1
    MOVE.W  30(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     TLIBA1_FMT_BPLCON1_COLON_0X_PCT_04LX_0X_PCT_04L
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  32(A2),D0
    MOVEQ   #0,D1
    MOVE.W  34(A2),D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     TLIBA1_FMT_BPLCON2_COLON_0X_PCT_04LX_0X_PCT_04L
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  36(A2),D0
    MOVEQ   #0,D1
    MOVE.W  38(A2),D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     TLIBA1_FMT_BPL1PTH_COLON_0X_PCT_04LX_0X_PCT_04L
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     72(A7),A7
    MOVEQ   #0,D0
    MOVE.W  40(A2),D0
    MOVEQ   #0,D1
    MOVE.W  42(A2),D1
    MOVEQ   #0,D2
    MOVE.W  38(A2),D2
    SWAP    D2
    CLR.W   D2
    MOVEQ   #0,D3
    MOVE.W  D1,D3
    OR.L    D3,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     TLIBA1_FMT_BPL1PTL_COLON_0X_PCT_04LX_0X_PCT_04L
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  44(A2),D0
    MOVEQ   #0,D1
    MOVE.W  46(A2),D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     TLIBA1_FMT_BPL2PTH_COLON_0X_PCT_04LX_0X_PCT_04L
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  48(A2),D0
    MOVEQ   #0,D1
    MOVE.W  50(A2),D1
    MOVEQ   #0,D2
    MOVE.W  46(A2),D2
    SWAP    D2
    CLR.W   D2
    MOVEQ   #0,D3
    MOVE.W  D1,D3
    OR.L    D3,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     TLIBA1_FMT_BPL2PTL_COLON_0X_PCT_04LX_0X_PCT_04L
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  52(A2),D0
    MOVEQ   #0,D1
    MOVE.W  54(A2),D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     TLIBA1_FMT_BPL3PTH_COLON_0X_PCT_04LX_0X_PCT_04L
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  56(A2),D0
    MOVEQ   #0,D1
    MOVE.W  58(A2),D1
    MOVEQ   #0,D2
    MOVE.W  54(A2),D2
    SWAP    D2
    CLR.W   D2
    MOVEQ   #0,D3
    MOVE.W  D1,D3
    OR.L    D3,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     TLIBA1_FMT_BPL3PTL_COLON_0X_PCT_04LX_0X_PCT_04L
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  60(A2),D0
    MOVEQ   #0,D1
    MOVE.W  62(A2),D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     TLIBA1_FMT_BPL4PTH_COLON_0X_PCT_04LX_0X_PCT_04L
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  64(A2),D0
    MOVEQ   #0,D1
    MOVE.W  66(A2),D1
    MOVEQ   #0,D2
    MOVE.W  62(A2),D2
    SWAP    D2
    CLR.W   D2
    MOVEQ   #0,D3
    MOVE.W  D1,D3
    OR.L    D3,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     TLIBA1_FMT_BPL4PTL_COLON_0X_PCT_04LX_0X_PCT_04L
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     76(A7),A7
    MOVEQ   #0,D0
    MOVE.W  68(A2),D0
    MOVEQ   #0,D1
    MOVE.W  70(A2),D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     TLIBA1_FMT_BPL5PTH_COLON_0X_PCT_04LX_0X_PCT_04L
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVEQ   #0,D0
    MOVE.W  72(A2),D0
    MOVEQ   #0,D1
    MOVE.W  74(A2),D1
    MOVEQ   #0,D2
    MOVE.W  70(A2),D2
    SWAP    D2
    CLR.W   D2
    MOVEQ   #0,D3
    MOVE.W  D1,D3
    OR.L    D3,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     TLIBA1_FMT_BPL5PTL_COLON_0X_PCT_04LX_0X_PCT_04L
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    PEA     TLIBA1_STR_PatternDumpSeparatorNewline
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     28(A7),A7
    MOVEM.L (A7)+,D2-D3/A2-A3
    RTS

;!======

    LINK.W  A5,#-80

    MOVE.L  _TLIBA1_CurrentViewModeIndex,-(A7)
    PEA     Global_STR_VM_ARRAY_1
    PEA     -80(A5)
    JSR     _WDISP_SPrintf(PC)

    MOVE.L  _TLIBA1_CurrentViewModeIndex,D0
    MOVEQ   #76,D1
    JSR     _MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayPatternTable,A0
    ADDA.L  D0,A0
    MOVE.L  A0,(A7)
    PEA     -80(A5)
    BSR.W   TLIBA3_FormatPatternRegisterDump

    UNLK    A5
    RTS

;!======

    ; Dead code.
    LINK.W  A5,#-84
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.lab_1851:              ; maybe this is the entry point and it's getting removed by a few bytes?
    MOVEQ   #9,D0       ; or is this just being calculated weirdly?
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,-(A7)
    PEA     Global_STR_VM_ARRAY_2
    PEA     -84(A5)
    JSR     _WDISP_SPrintf(PC)

    MOVE.L  D7,D0
    MOVEQ   #76,D1
    JSR     _MATH_Mulu32(PC)

    LEA     TLIBA3_VmArrayPatternTable,A0
    ADDA.L  D0,A0
    MOVE.L  A0,(A7)
    PEA     -84(A5)
    BSR.W   TLIBA3_FormatPatternRegisterDump

    PEA     TLIBA1_STR_PatternDumpLoopNewline
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .lab_1851

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======