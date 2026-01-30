;!======
;------------------------------------------------------------------------------
; FUNC: ??   (Dead code: LAB_1A3A/LAB_1AE8 wrapper??)
; ARGS:
;   stack +8: ?? (arg for LAB_1A3A)
;   stack +12: ?? (arg for LAB_1A3A)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/A0 ??
; CALLS:
;   LAB_1A3A, LAB_1AE8
; READS:
;   LAB_2381
; WRITES:
;   LAB_2381
; DESC:
;   Dead code wrapper that formats/updates LAB_2381 and then calls LAB_1AE8.
; NOTES:
;   Entry label not present in source.
;------------------------------------------------------------------------------
    ; Dead code.
    LINK.W  A5,#-4

    LEA     12(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  8(A5),-(A7)
    PEA     LAB_2381
    MOVE.L  A0,-4(A5)
    JSR     LAB_1A3A(PC)

    PEA     LAB_2381
    JSR     LAB_1AE8(PC)

    UNLK    A5
    RTS

;!======

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_1906   (LAB_1A3A/LAB_1AE8 wrapper)
; ARGS:
;   stack +8: ?? (arg for LAB_1A3A)
;   stack +12: ?? (arg for LAB_1A3A)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/A0 ??
; CALLS:
;   LAB_1A3A, LAB_1AE8
; READS:
;   LAB_2381
; WRITES:
;   LAB_2381
; DESC:
;   Wrapper that formats/updates LAB_2381 and then calls LAB_1AE8.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_1906:
    LINK.W  A5,#-4
    LEA     12(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  8(A5),-(A7)
    PEA     LAB_2381
    MOVE.L  A0,-4(A5)
    JSR     LAB_1A3A(PC)

    PEA     LAB_2381
    JSR     LAB_1AE8(PC)

    UNLK    A5
    RTS

;!======

;!======
;------------------------------------------------------------------------------
; FUNC: ??   (Dead code: open log file and write LAB_2381??)
; ARGS:
;   stack +8: ?? (arg for LAB_1A3A)
;   stack +12: ?? (arg for LAB_1A3A)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/A0 ??
; CALLS:
;   LAB_1AB2, LAB_1A3A, LAB_19C3, LAB_1AB9
; READS:
;   GLOB_STR_A_PLUS, GLOB_STR_DF1_DEBUG_LOG, LAB_2381
; WRITES:
;   LAB_2381
; DESC:
;   Dead code that opens a debug log, formats LAB_2381, writes it, and closes.
; NOTES:
;   Entry label not present in source.
;------------------------------------------------------------------------------
    ; Dead code.
    LINK.W  A5,#-8

    PEA     GLOB_STR_A_PLUS
    PEA     GLOB_STR_DF1_DEBUG_LOG
    JSR     LAB_1AB2(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    BEQ.S   .LAB_1907

    LEA     12(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  8(A5),-(A7)
    PEA     LAB_2381
    MOVE.L  A0,-4(A5)
    JSR     LAB_1A3A(PC)

    PEA     LAB_2381
    MOVE.L  -8(A5),-(A7)
    JSR     LAB_19C3(PC)

    MOVE.L  -8(A5),(A7)
    JSR     LAB_1AB9(PC)

    LEA     20(A7),A7

.LAB_1907:
    UNLK    A5
    RTS

;!======

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_1908   (Stub)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   none
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Empty stub.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_1908:
    RTS
