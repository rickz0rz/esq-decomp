    XDEF    _HANDLE_OpenEntryWithFlags


;------------------------------------------------------------------------------
; FUNC: _HANDLE_OpenEntryWithFlags   (Allocate/open entry in handle table.)
; ARGS:
;   stack +10: arg_1 (via 14(A5))
;   stack +12: arg_2 (via 16(A5))
;   stack +14: arg_3 (via 18(A5))
;   stack +15: arg_4 (via 19(A5))
; RET:
;   D0: slot/index on success, -1 on failure
; CLOBBERS:
;   A0/A2/A3/A4/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   _DOS_OpenWithErrorState, _DOS_OpenNewFileIfMissing, _DOS_DeleteAndRecreateFile, _DOS_CloseWithSignalCheck
; READS:
;   Global_HandleTableCount(A4), Global_HandleTableBase(A4) (table), Global_HandleTableFlags(A4) (flags), Global_AppErrorCode(A4)
; WRITES:
;   Global_AppErrorCode(A4), Global_DosIoErr(A4), (A2), 4(A2)
; DESC:
;   Finds a free entry in the handle table, validates mode bits, and performs
;   setup/open work via helper calls; stores entry data on success.
; NOTES:
;   Uses SEQ/NEG/EXT booleanization in callers; sets error code in Global_AppErrorCode(A4).
;------------------------------------------------------------------------------
_HANDLE_OpenEntryWithFlags:
    LINK.W  A5,#-26
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 58(A7),A3
    MOVE.L  62(A7),D7

    CLR.B   -1(A5)
    CLR.L   Global_DosIoErr(A4)
    MOVE.L  Global_AppErrorCode(A4),-14(A5)
    MOVEQ   #3,D5

.find_free_slot:
    CMP.L   Global_HandleTableCount(A4),D5
    BGE.S   .have_slot_index

    MOVE.L  D5,D0
    ASL.L   #3,D0
    LEA     Global_HandleTableBase(A4),A0
    TST.L   Struct_HandleEntry__Flags(A0,D0.L)
    BEQ.S   .have_slot_index

    ADDQ.L  #1,D5
    BRA.S   .find_free_slot

.have_slot_index:
    MOVE.L  Global_HandleTableCount(A4),D0
    CMP.L   D5,D0
    BNE.S   .init_slot

    ; Set 24 in the AppErrorCode and return -1
    MOVEQ   #24,D0
    MOVE.L  D0,Global_AppErrorCode(A4)
    MOVEQ   #-1,D0
    BRA.W   .return

.init_slot:
    MOVE.L  D5,D0
    ASL.L   #3,D0
    LEA     Global_HandleTableBase(A4),A0
    ADDA.L  D0,A0
    MOVEA.L A0,A2
    TST.L   16(A5)
    BEQ.S   .set_errcode_default

    BTST    #2,19(A5)
    BEQ.S   .set_errcode_alt

.set_errcode_default:
    MOVE.L  #$3ec,-18(A5)
    BRA.S   .normalize_flags

.set_errcode_alt:
    MOVE.L  #$3ee,-18(A5)

.normalize_flags:
    MOVE.L  #$8000,D0
    AND.L   Global_HandleTableFlags(A4),D0
    EOR.L   D0,D7
    BTST    #3,D7
    BEQ.S   .normalize_access_bits

    MOVE.L  D7,D0
    ANDI.W  #$fffc,D0
    MOVE.L  D0,D7
    ORI.W   #2,D7

.normalize_access_bits:
    MOVE.L  D7,D0
    MOVEQ   #3,D1
    AND.L   D1,D0
    CMPI.L  #$2,D0
    BEQ.S   .access_ok

    CMPI.L  #$1,D0
    BEQ.S   .access_ok

    TST.L   D0
    BNE.S   .access_invalid

.access_ok:
    MOVE.L  D7,D6
    ADDQ.L  #1,D6
    BRA.S   .open_by_mode

.access_invalid:
    MOVEQ   #22,D0
    MOVE.L  D0,Global_AppErrorCode(A4)
    MOVEQ   #-1,D0
    BRA.W   .return

.open_by_mode:
    MOVE.L  D7,D0
    ANDI.L  #$300,D0
    BEQ.W   .simple_open

    BTST    #10,D7
    BEQ.S   .open_mode_bit10

    MOVE.B  #$1,-1(A5)
    MOVE.L  -18(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _DOS_OpenNewFileIfMissing(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D4
    BRA.S   .post_open_adjust

.open_mode_bit10:
    BTST    #9,D7
    BNE.S   .open_mode_bit9

    PEA     1005.W
    MOVE.L  A3,-(A7)
    JSR     _DOS_OpenWithErrorState(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D4
    TST.L   D4
    BPL.S   .open_mode_bit9

    BSET    #9,D7

.open_mode_bit9:
    BTST    #9,D7
    BEQ.S   .post_open_adjust

    MOVE.B  #$1,-1(A5)
    MOVE.L  -14(A5),Global_AppErrorCode(A4)
    MOVE.L  -18(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _DOS_DeleteAndRecreateFile(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D4

.post_open_adjust:
    TST.B   -1(A5)
    BEQ.S   .check_ioerr

    MOVE.L  D7,D0
    MOVEQ   #120,D1
    ADD.L   D1,D1
    AND.L   D1,D0
    TST.L   D0
    BEQ.S   .check_ioerr

    TST.L   D4
    BMI.S   .check_ioerr

    MOVE.L  D4,-(A7)
    JSR     _DOS_CloseWithSignalCheck(PC)

    PEA     1005.W
    MOVE.L  A3,-(A7)
    JSR     _DOS_OpenWithErrorState(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D4
    BRA.S   .check_ioerr

.simple_open:
    PEA     1005.W
    MOVE.L  A3,-(A7)
    JSR     _DOS_OpenWithErrorState(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D4

.check_ioerr:
    TST.L   Global_DosIoErr(A4)
    BEQ.S   .store_entry

    MOVEQ   #-1,D0
    BRA.S   .return

.store_entry:
    MOVE.L  D6,(A2)
    MOVE.L  D4,4(A2)
    MOVE.L  D5,D0

.return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======