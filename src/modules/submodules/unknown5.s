    XDEF    STRING_AppendN
    XDEF    STRING_CompareN
    XDEF    STRING_CompareNoCase
    XDEF    STRING_CompareNoCaseN
    XDEF    STRING_CopyPadNul

;------------------------------------------------------------------------------
; FUNC: STRING_CompareNoCaseN   (Case-insensitive compare up to length.)
; ARGS:
;   stack +28: A3 = string A
;   stack +32: A2 = string B
;   stack +36: D7 = max length
; RET:
;   D0: 0 if equal, <0 / >0 if different
; CLOBBERS:
;   D0-D7/A2-A3
; CALLS:
;   STRING_ToUpperChar
; DESC:
;   Compares strings case-insensitively up to D7 bytes or NUL.
;------------------------------------------------------------------------------
STRING_CompareNoCaseN:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A2-A3,-(A7)

    MOVEA.L 28(A7),A3
    MOVEA.L 32(A7),A2
    MOVE.L  36(A7),D7

.compare_loop:
    TST.L   D7
    BEQ.S   .compare_tail

    TST.B   (A3)
    BEQ.S   .compare_tail

    TST.B   (A2)
    BEQ.S   .compare_tail

    MOVEQ   #0,D0
    MOVE.B  (A3)+,D0
    MOVE.L  D0,-(A7)
    JSR     STRING_ToUpperChar(PC)

    MOVEQ   #0,D1
    MOVE.B  (A2)+,D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,20(A7)
    JSR     STRING_ToUpperChar(PC)

    ADDQ.W  #4,A7
    MOVE.L  16(A7),D1
    SUB.L   D0,D1
    MOVE.L  D1,D6
    TST.L   D6
    BEQ.S   .next_char

    MOVE.L  D6,D0
    BRA.S   .return

.next_char:
    SUBQ.L  #1,D7
    BRA.S   .compare_loop

.compare_tail:
    TST.L   D7
    BEQ.S   .equal

    TST.B   (A3)
    BEQ.S   .a_ended

    MOVEQ   #1,D0

    BRA.S   .return

.a_ended:
    TST.B   (A2)
    BEQ.S   .equal

    MOVEQ   #-1,D0
    BRA.S   .return

.equal:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: STRING_CopyPadNul   (Copy string with NUL padding up to length.)
; ARGS:
;   stack +4: A0 = destination
;   stack +8: A1 = source
;   stack +12: D0 = max length
; RET:
;   D0: destination pointer
; CLOBBERS:
;   D0-D1/A0-A1
; DESC:
;   Copies bytes until NUL or length, then pads remaining with NULs.
;------------------------------------------------------------------------------
STRING_CopyPadNul:
    MOVEA.L 8(A7),A1
    MOVEA.L 4(A7),A0
    MOVE.L  12(A7),D0
    MOVE.L  A0,D1
    BRA.S   .lab_1957

.copy_loop:
    MOVE.B  (A1)+,(A0)+
    BEQ.S   .pad_nuls

.lab_1957:
    SUBQ.L  #1,D0
    BCC.S   .copy_loop

    BRA.S   .return

.pad_loop:
    CLR.B   (A0)+

.pad_nuls:
    SUBQ.L  #1,D0
    BCC.S   .pad_loop

.return:
    MOVE.L  D1,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: STRING_CompareN   (Byte-wise compare up to length.)
; ARGS:
;   stack +4: A3 = string A
;   stack +8: A2 = string B
;   stack +12: D7 = max length
; RET:
;   D0: 0 if equal, <0 / >0 if different
; CLOBBERS:
;   D0-D7/A2-A3
; DESC:
;   Compares strings byte-wise up to D7 bytes or NUL.
;------------------------------------------------------------------------------
STRING_CompareN:
    MOVEM.L D6-D7/A2-A3,-(A7)

    SetOffsetForStack 4

    MOVEA.L .stackOffsetBytes+4(A7),A3
    MOVEA.L .stackOffsetBytes+8(A7),A2
    MOVE.L  .stackOffsetBytes+12(A7),D7

.compare_loop:
    TST.L   D7
    BEQ.S   .compare_tail

    TST.B   (A3)
    BEQ.S   .compare_tail

    TST.B   (A2)
    BEQ.S   .compare_tail

    MOVEQ   #0,D0
    MOVE.B  (A3)+,D0
    MOVEQ   #0,D1
    MOVE.B  (A2)+,D1
    SUB.L   D1,D0
    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .next_char

    MOVE.L  D6,D0
    BRA.S   .return

.next_char:
    SUBQ.L  #1,D7
    BRA.S   .compare_loop

.compare_tail:
    TST.L   D7
    BEQ.S   .equal

    TST.B   (A3)
    BEQ.S   .a_ended

    MOVEQ   #1,D0
    BRA.S   .return

.a_ended:
    TST.B   (A2)
    BEQ.S   .equal

    MOVEQ   #-1,D0
    BRA.S   .return

.equal:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: STRING_AppendN   (Append up to N bytes of src to dst.)
; ARGS:
;   stack +4: A3 = destination string
;   stack +8: A2 = source string
;   stack +12: D7 = max bytes to append
; RET:
;   D0: destination pointer
; CLOBBERS:
;   D0-D7/A0-A3
; DESC:
;   Finds end of destination, then appends up to D7 bytes of source and NUL.
; NOTES:
;   Does not verify available space in destination.
;------------------------------------------------------------------------------
STRING_AppendN:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A2-A3,-(A7)

    SetOffsetForStackAfterLink 8,4

    MOVEA.L .stackOffsetBytes+4(A7),A3
    MOVEA.L .stackOffsetBytes+8(A7),A2
    MOVE.L  .stackOffsetBytes+12(A7),D7
    MOVEA.L A2,A0

.find_end_src:
    TST.B   (A0)+
    BNE.S   .find_end_src

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D6
    MOVEA.L A3,A0

.find_end_dst:
    TST.B   (A0)+
    BNE.S   .find_end_dst

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D0
    MOVEA.L A3,A1
    ADDA.L  D0,A1
    MOVE.L  A1,-8(A5)
    CMP.L   D7,D6
    BLS.S   .use_src_len

    MOVE.L  D7,D6

.use_src_len:
    MOVE.L  D6,D0
    MOVEA.L A2,A0
    BRA.S   .copy_loop

.copy_next:
    MOVE.B  (A0)+,(A1)+

.copy_loop:
    SUBQ.L  #1,D0
    BCC.S   .copy_next

    MOVEA.L -8(A5),A0
    CLR.B   0(A0,D6.L)
    MOVE.L  A3,D0

    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: STRING_CompareNoCase   (Case-insensitive compare.)
; ARGS:
;   stack +4: A0 = string A
;   stack +8: A1 = string B
; RET:
;   D0: 0 if equal, <0 / >0 if different
; CLOBBERS:
;   D0-D1/A0-A1
; DESC:
;   Compares strings case-insensitively until NUL or mismatch.
;------------------------------------------------------------------------------
STRING_CompareNoCase:
    MOVEA.L 4(A7),A0
    MOVEA.L 8(A7),A1
    MOVEQ   #0,D0
    MOVEQ   #0,D1

.compare_loop:
    MOVE.B  (A0)+,D0
    MOVE.B  (A1)+,D1
    CMPI.B  #'a',D0
    BLT.S   .toupper_a_done

    CMPI.B  #'z',D0
    BGT.S   .toupper_a_done

    SUBI.B  #$20,D0

.toupper_a_done:
    CMPI.B  #'a',D1
    BLT.S   .toupper_b_done

    CMPI.B  #'z',D1
    BGT.S   .toupper_b_done

    SUBI.B  #$20,D1

.toupper_b_done:
    SUB.L   D1,D0
    BNE.S   .return

    TST.B   D1
    BNE.S   .compare_loop

.return:
    RTS

;!======

    ; Alignment
    ALIGN_WORD
