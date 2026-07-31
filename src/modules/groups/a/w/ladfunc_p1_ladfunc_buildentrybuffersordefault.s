    XDEF    _LADFUNC_BuildEntryBuffersOrDefault


;------------------------------------------------------------------------------
; FUNC: _LADFUNC_BuildEntryBuffersOrDefault   (Build entry buffers or defaultsuncertain)
; ARGS:
;   (none observed)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A2/A3/A6/A7/D0/D1/D6/D7
; CALLS:
;   _NEWGRID_JMPTBL_MATH_Mulu32, _LADFUNC_ComposePackedPenByte, _LADFUNC_ReflowEntryBuffers
; READS:
;   _LADFUNC_EntryPtrTable, _ED_TextLimit
; WRITES:
;   outText/outAttr buffers
; DESC:
;   Copies entry text/attrs if present; otherwise fills defaults and reflows.
; NOTES:
;   Uses packed nibble from _LADFUNC_ComposePackedPenByte for default attribute fill.
;------------------------------------------------------------------------------
_LADFUNC_BuildEntryBuffersOrDefault:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A2-A3/A6,-(A7)
    MOVE.L  32(A7),D7
    MOVEA.L 36(A7),A3
    MOVEA.L 40(A7),A2
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    TST.L   6(A1)
    BNE.S   .copy_existing_buffers

    MOVE.L  _ED_TextLimit,D0
    MOVEQ   #40,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #32,D1
    MOVEA.L A3,A0
    BRA.S   .fill_text_next

.fill_text_loop:
    MOVE.B  D1,(A0)+

.fill_text_next:
    SUBQ.L  #1,D0
    BCC.S   .fill_text_loop

    MOVE.L  _ED_TextLimit,D0
    MOVEQ   #40,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    CLR.B   0(A3,D0.L)
    PEA     1.W
    PEA     2.W
    BSR.W   _LADFUNC_ComposePackedPenByte

    ADDQ.W  #8,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  _ED_TextLimit,D0
    MOVE.L  D1,20(A7)
    MOVEQ   #40,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  20(A7),D1
    MOVEA.L A2,A0
    BRA.S   .fill_attr_next

.fill_attr_loop:
    MOVE.B  D1,(A0)+

.fill_attr_next:
    SUBQ.L  #1,D0
    BCC.S   .fill_attr_loop

    BRA.S   .return

.copy_existing_buffers:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L 6(A1),A0
    MOVEA.L A3,A6

.copy_text_loop:
    MOVE.B  (A0)+,(A6)+
    BNE.S   .copy_text_loop

    MOVEA.L A3,A0

.scan_text_end:
    TST.B   (A0)+
    BNE.S   .scan_text_end

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D6
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  D6,D0
    MOVEA.L 10(A1),A0
    MOVEA.L A2,A6
    BRA.S   .copy_attr_next2

.copy_attr_loop2:
    MOVE.B  (A0)+,(A6)+

.copy_attr_next2:
    SUBQ.L  #1,D0
    BCC.S   .copy_attr_loop2

    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _LADFUNC_ReflowEntryBuffers

    ADDQ.W  #8,A7

.return:
    MOVEM.L (A7)+,D6-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======