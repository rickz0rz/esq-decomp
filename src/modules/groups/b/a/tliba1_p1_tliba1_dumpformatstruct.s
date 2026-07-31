    XDEF    _TLIBA1_DumpFormatStruct


;------------------------------------------------------------------------------
; FUNC: _TLIBA1_DumpFormatStruct   (Debug dump of one TLFormat record)
; DESC:
;   The disassembly gave this block no label, so refbytes.py read it as the tail
;   of _TLIBA1_FormatClockFormatEntry and reported that function as 524 bytes
;   instead of 388. The label is byte-neutral and needs no XDEF -- nothing
;   outside the module refers to it.
;------------------------------------------------------------------------------
_TLIBA1_DumpFormatStruct:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,-(A7)
    PEA     _TLIBA1_FMT_STRUCT_TLFORMAT_0X_PCT_X
    JSR     _FORMAT_RawDoFmtWithScratchBuffer(PC)

    PEA     _TLIBA1_STR_TLFormatStructOpenBraceLine
    JSR     _FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.W  (A3),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     _TLIBA1_FMT_TLF_COLOR_PCT_D
    JSR     _FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.W  2(A3),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     _TLIBA1_FMT_TLF_OFFSET_PCT_D
    JSR     _FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.W  4(A3),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     _TLIBA1_FMT_TLF_FONTSEL_PCT_D
    JSR     _FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     _TLIBA1_FMT_TLF_ALIGN_PCT_D
    JSR     _FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.W  8(A3),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     _TLIBA1_FMT_TLF_PREGAP_PCT_D
    JSR     _FORMAT_RawDoFmtWithScratchBuffer(PC)

    PEA     _TLIBA1_STR_TLFormatStructCloseBraceLine
    JSR     _FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     36(A7),A7
    MOVEA.L (A7)+,A3
    RTS

;!======