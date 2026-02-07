;------------------------------------------------------------------------------
; FUNC: PARSEINI_WriteErrorLogEntry   (Write error log entryuncertain)
; ARGS:
;   (none)
; RET:
;   D0: -1 on failure, 0 on success
; CLOBBERS:
;   D0/D7
; CALLS:
;   SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer, SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes, SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush
; READS:
;   DATA_NEWGRID2_BSS_LONG_2049, DATA_WDISP_BSS_LONG_233A, DATA_CLOCK_CONST_BYTE_1B5E
; WRITES:
;   Err log file on disk
; DESC:
;   Opens df0:err.log (MODE_NEWFILE), writes two entries via SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes and closes.
; NOTES:
;   Returns -1 when logging is disabled or open fails.
;------------------------------------------------------------------------------
PARSEINI_WriteErrorLogEntry:
    MOVE.L  D7,-(A7)

    TST.L   DATA_NEWGRID2_BSS_LONG_2049
    BNE.S   .logging_enabled

    MOVEQ   #-1,D0
    BRA.S   .return

.logging_enabled:
    PEA     MODE_NEWFILE.W
    PEA     Global_STR_DF0_ERR_LOG
    JSR     SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BNE.S   .log_opened

    MOVEQ   #-1,D0
    BRA.S   .return

.log_opened:
    MOVE.W  DATA_WDISP_BSS_LONG_233A,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  DATA_NEWGRID2_BSS_LONG_2049,-(A7)
    MOVE.L  D7,-(A7)
    JSR     SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    PEA     1.W
    PEA     DATA_CLOCK_CONST_BYTE_1B5E
    MOVE.L  D7,-(A7)
    JSR     SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    MOVE.L  D7,(A7)
    JSR     SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(PC)

    LEA     24(A7),A7

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_ComputeHTCMaxValues   (Compute H/T delta maxuncertain)
; ARGS:
;   (none)
; RET:
;   D0: max delta (updated)
; CLOBBERS:
;   D0/D7
; CALLS:
;   none
; READS:
;   Global_WORD_H_VALUE, Global_WORD_T_VALUE, Global_WORD_MAX_VALUE
; WRITES:
;   Global_WORD_MAX_VALUE
; DESC:
;   Computes (H - T) modulo 64000, updating the stored max when larger.
; NOTES:
;   Wrap logic suggests a circular counter.
;------------------------------------------------------------------------------
PARSEINI_ComputeHTCMaxValues:
    MOVE.L  D7,-(A7)

    MOVEQ   #0,D0
    MOVE.W  Global_WORD_H_VALUE,D0
    MOVEQ   #0,D1
    MOVE.W  Global_WORD_T_VALUE,D1
    SUB.L   D1,D0
    MOVE.L  D0,D7
    TST.L   D7
    BPL.S   .replaceMaxValue

    ADDI.L  #64000,D7

.replaceMaxValue:
    MOVEQ   #0,D0
    MOVE.W  Global_WORD_MAX_VALUE,D0
    CMP.L   D7,D0
    BGE.S   .return

    MOVE.L  D7,D0
    MOVE.W  D0,Global_WORD_MAX_VALUE

.return:
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_MonitorClockChange   (Track clock delta / debounceuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D2/D7
; CALLS:
;   SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh
; READS:
;   Global_WORD_H_VALUE, Global_WORD_T_VALUE, Global_REF_CLOCKDATA_STRUCT,
;   DATA_PARSEINI_BSS_WORD_20A3-20A8
; WRITES:
;   DATA_PARSEINI_BSS_WORD_20A3-20A8
; DESC:
;   Detects changes between H and T values, compares to stored clockdata seconds,
;   and updates counters/flags, occasionally queuing an action via SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh.
; NOTES:
;   Uses a 3-count threshold before clearing DATA_PARSEINI_BSS_WORD_20A5.
;------------------------------------------------------------------------------
PARSEINI_MonitorClockChange:
    MOVEM.L D2/D7,-(A7)

    MOVEQ   #0,D7       ; Prefill D7 with 0x00000000
    MOVE.W  Global_WORD_H_VALUE,D0     ; Not sure what these two bytes are but they're stored into D0 and D1
    MOVE.W  Global_WORD_T_VALUE,D1
    CMP.W   D1,D0       ; Compare D1 and D0 (D1 - D0)
    SNE     D2          ; If the zero flag is set (they're equal), D2 is 0xFF else 0x00
    NEG.B   D2          ; negate the above. now, zero flag is 0x00 else 0xFF
    EXT.W   D2          ; extend most significant byte D2 to a word... so now D2 is either 0x0000 or 0xFFFF
    EXT.L   D2          ; then again sign extend D2 to a longword (0x00000000 or 0xFFFFFFFF)
    MOVE.L  D2,D7       ; Move D2 into D7
    TST.W   D7          ; Test D7 against 0
    BEQ.S   .check_clockdata_update   ; If D7 is now 0, jump to .check_clockdata_update

    MOVE.W  Global_REF_CLOCKDATA_STRUCT,DATA_PARSEINI_BSS_WORD_20A3  ; Get the first word of the clockdata struct, which is seconds
    MOVEQ   #1,D0               ; Move 1 into D0
    CMP.W   DATA_PARSEINI_BSS_WORD_20A5,D0         ; Compare DATA_PARSEINI_BSS_WORD_20A5 - D0 (1)
    BEQ.S   .return             ; If DATA_PARSEINI_BSS_WORD_20A5 was 1, then return

    MOVEQ   #1,D1           ; Push 1 into D1
    MOVE.L  D1,-(A7)        ; Push D1 onto the stack
    MOVE.L  D1,-(A7)        ; Push it again onto the stack
    MOVE.W  D0,DATA_PARSEINI_BSS_WORD_20A5     ; Push the least 2 sig bytes in D0 into DATA_PARSEINI_BSS_WORD_20A5
    JSR     SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)    ; JSR

    ADDQ.W  #8,A7           ; Add 8 to whatever value is in the stack (the stack pointer) clearing the last two values in the stack (D1 x2).
    BRA.S   .return

.check_clockdata_update:
    TST.W   DATA_PARSEINI_BSS_WORD_20A5
    BEQ.S   .return

    MOVE.W  Global_REF_CLOCKDATA_STRUCT,D0
    MOVE.W  DATA_PARSEINI_BSS_WORD_20A3,D1
    CMP.W   D0,D1
    BEQ.S   .return

    ADDQ.W  #1,DATA_PARSEINI_BSS_WORD_20A4
    MOVE.W  D0,DATA_PARSEINI_BSS_WORD_20A3
    CMPI.W  #3,DATA_PARSEINI_BSS_WORD_20A4
    BLT.S   .return

    CLR.W   DATA_PARSEINI_BSS_WORD_20A5
    CLR.L   -(A7)
    PEA     1.W
    JSR     SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D2/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_UpdateCtrlHDeltaMax   (UpdateCtrlHDeltaMaxuncertain)
; ARGS:
;   (none)
; RET:
;   D0: current delta (non-negative, wrapped)
; CLOBBERS:
;   D0/D7
; CALLS:
;   (none)
; READS:
;   CTRL_H, CTRL_HPreviousSample, CTRL_HDeltaMax
; WRITES:
;   CTRL_HDeltaMax
; DESC:
;   Computes CTRL_H - CTRL_HPreviousSample (wrapped by +500 if negative) and updates the
;   recorded max delta when the new value exceeds the previous max.
; NOTES:
;   Wrap size 500 suggests a ring buffer or modulo counter.
;------------------------------------------------------------------------------
PARSEINI_UpdateCtrlHDeltaMax:
    MOVE.L  D7,-(A7)

    MOVEQ   #0,D0
    MOVE.W  CTRL_H,D0
    MOVEQ   #0,D1
    MOVE.W  CTRL_HPreviousSample,D1
    SUB.L   D1,D0
    MOVE.L  D0,D7
    TST.L   D7
    BPL.S   .delta_ok

    ADDI.L  #500,D7

.delta_ok:
    MOVEQ   #0,D0
    MOVE.W  CTRL_HDeltaMax,D0
    CMP.L   D7,D0
    BGE.S   .return_status

    MOVE.L  D7,D0
    MOVE.W  D0,CTRL_HDeltaMax

.return_status:
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSEINI_CheckCtrlHChange
; ARGS:
;   (none)
; RET:
;   D0: boolean (nonzero when change detected and action taken)
; CLOBBERS:
;   D0-D2/D7
; CALLS:
;   SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh
; READS:
;   CTRL_H, CTRL_HPreviousSample, DATA_WDISP_BSS_WORD_2266, DATA_PARSEINI_BSS_WORD_20A6-20A8, DATA_PARSEINI_BSS_WORD_20A5
; WRITES:
;   DATA_PARSEINI_BSS_WORD_20A6-20A8
; DESC:
;   Compares current CTRL_H to previous value, optionally triggers SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh when
;   changes are detected and control flags permit.
; NOTES:
;   Uses DATA_WDISP_BSS_WORD_2266 as gate; resets DATA_PARSEINI_BSS_WORD_20A5 when no change.
;------------------------------------------------------------------------------
PARSEINI_CheckCtrlHChange:
    MOVEM.L D2/D7,-(A7)

    MOVEQ   #0,D7
    MOVE.W  CTRL_H,D0
    MOVE.W  CTRL_HPreviousSample,D1
    CMP.W   D1,D0
    SNE     D2
    NEG.B   D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,D7
    TST.W   D7
    BEQ.S   .no_change_or_gate_closed

    TST.W   DATA_WDISP_BSS_WORD_2266
    BEQ.S   .no_change_or_gate_closed

    MOVE.W  Global_REF_CLOCKDATA_STRUCT,DATA_PARSEINI_BSS_WORD_20A6
    CLR.W   DATA_PARSEINI_BSS_WORD_20A7
    MOVEQ   #1,D0
    CMP.W   DATA_PARSEINI_BSS_WORD_20A8,D0
    BEQ.S   .return

    PEA     1.W
    PEA     16.W
    MOVE.W  D0,DATA_PARSEINI_BSS_WORD_20A8
    JSR     SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7
    BRA.S   .return

.no_change_or_gate_closed:
    TST.W   DATA_PARSEINI_BSS_WORD_20A8
    BEQ.S   .return

    MOVE.W  Global_REF_CLOCKDATA_STRUCT,D0
    MOVE.W  DATA_PARSEINI_BSS_WORD_20A6,D1
    CMP.W   D0,D1
    BEQ.S   .return

    MOVE.W  D0,DATA_PARSEINI_BSS_WORD_20A6
    TST.W   DATA_WDISP_BSS_WORD_2266
    BEQ.S   .clear_ctrlh_pending

    ADDQ.W  #1,DATA_PARSEINI_BSS_WORD_20A7
    CMPI.W  #3,DATA_PARSEINI_BSS_WORD_20A7
    BLT.S   .return

.clear_ctrlh_pending:
    CLR.W   DATA_PARSEINI_BSS_WORD_20A8
    CLR.L   -(A7)
    PEA     16.W
    JSR     SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D2/D7
    RTS
