    XDEF    HANDLE_OpenFromModeString

;!======
;------------------------------------------------------------------------------
; FUNC: HANDLE_OpenFromModeString   (Parse mode string, open/prepare handle.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: A2 on success, 0 on failure
; CLOBBERS:
;   A0/A2/A3/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   UNKNOWN36_FinalizeRequest, HANDLE_OpenEntryWithFlags
; READS:
;   Global_DefaultHandleFlags, mode-string bytes via A3,
;   Struct_PreallocHandleNode__OpenFlags(A2)
; WRITES:
;   Struct_PreallocHandleNode__BufferBase/BufferCursor/ReadRemaining/
;   WriteRemaining/BufferCapacity/HandleIndex/OpenFlags(A2)
; DESC:
;   Parses a mode string (r/w/a with optional b/+), builds flags, calls HANDLE_OpenEntryWithFlags,
;   then initializes the handle/struct on success.
; NOTES:
;   Booleanize pattern: SEQ/NEG/EXT. Returns 0 on failure.
;   OpenFlags(+24) long carries overlaid mode/state bytes at +26/+27.
;   Global_DefaultHandleFlags static seed is `$00008000` in current image.
;------------------------------------------------------------------------------
HANDLE_OpenFromModeString:
    LINK.W  A5,#-16
    MOVEM.L D4-D7/A2-A3,-(A7)

    MOVEA.L 52(A7),A3
    MOVEA.L 56(A7),A2

    TST.L   Struct_PreallocHandleNode__OpenFlags(A2)
    BEQ.S   .after_finalize

    MOVE.L  A2,-(A7)
    JSR     UNKNOWN36_FinalizeRequest(PC)

    ADDQ.W  #4,A7

.after_finalize:
    MOVE.L  Global_DefaultHandleFlags(A4),D5
    MOVEQ   #1,D7
    MOVEQ   #0,D0
    MOVE.B  0(A3,D7.L),D0
    CMPI.W  #$62,D0
    BEQ.S   .set_binary_flag

    CMPI.W  #$61,D0
    BNE.S   .check_plus

    MOVEQ   #0,D5
    BRA.S   .bump_mode_index

.set_binary_flag:
    MOVE.L  #$8000,D5

.bump_mode_index:
    ADDQ.L  #1,D7

.check_plus:
    MOVEQ   #43,D1
    CMP.B   0(A3,D7.L),D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D4
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    CMPI.W  #$77,D0
    BEQ.W   .mode_write

    CMPI.W  #$72,D0
    BEQ.S   .mode_read

    CMPI.W  #$61,D0
    BNE.W   .mode_invalid

    PEA     12.W
    MOVE.L  #$8102,-(A7)
    MOVE.L  8(A5),-(A7)
    JSR     HANDLE_OpenEntryWithFlags(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D6
    MOVEQ   #-1,D0
    CMP.L   D0,D6
    BNE.S   .mode_append_ok

    MOVEQ   #0,D0
    BRA.W   .return

.mode_append_ok:
    TST.L   D4
    BEQ.S   .append_no_plus

    MOVEQ   #64,D0
    ADD.L   D0,D0
    BRA.S   .append_set_handle_flags

.append_no_plus:
    MOVEQ   #2,D0

.append_set_handle_flags:
    MOVE.L  D0,D7
    ORI.W   #$4000,D7
    BRA.W   .init_handle_fields

.mode_read:
    TST.L   D4
    BEQ.S   .read_no_plus

    MOVEQ   #2,D0
    BRA.S   .read_set_flags

.read_no_plus:
    MOVEQ   #0,D0

.read_set_flags:
    ORI.W   #$8000,D0
    PEA     12.W
    MOVE.L  D0,-(A7)
    MOVE.L  8(A5),-(A7)
    JSR     HANDLE_OpenEntryWithFlags(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D6
    MOVEQ   #-1,D0
    CMP.L   D0,D6
    BNE.S   .read_open_ok

    MOVEQ   #0,D0
    BRA.W   .return

.read_open_ok:
    TST.L   D4
    BEQ.S   .read_no_plus_flags

    MOVEQ   #64,D0
    ADD.L   D0,D0
    BRA.S   .read_set_handle_flags

.read_no_plus_flags:
    MOVEQ   #1,D0

.read_set_handle_flags:
    MOVE.L  D0,D7
    BRA.S   .init_handle_fields

.mode_write:
    TST.L   D4
    BEQ.S   .write_no_plus

    MOVEQ   #2,D0
    BRA.S   .write_set_flags

.write_no_plus:
    MOVEQ   #1,D0

.write_set_flags:
    ORI.W   #$8000,D0
    ORI.W   #$100,D0
    ORI.W   #$200,D0
    PEA     12.W
    MOVE.L  D0,-(A7)
    MOVE.L  8(A5),-(A7)
    JSR     HANDLE_OpenEntryWithFlags(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D6
    MOVEQ   #-1,D0
    CMP.L   D0,D6
    BNE.S   .write_open_ok

    MOVEQ   #0,D0
    BRA.S   .return

.write_open_ok:
    TST.L   D4
    BEQ.S   .write_no_plus_flags

    MOVEQ   #64,D0
    ADD.L   D0,D0
    BRA.S   .write_set_handle_flags

.write_no_plus_flags:
    MOVEQ   #2,D0

.write_set_handle_flags:
    MOVE.L  D0,D7
    BRA.S   .init_handle_fields

.mode_invalid:
    MOVEQ   #0,D0
    BRA.S   .return

.init_handle_fields:
    SUBA.L  A0,A0
    MOVE.L  A0,Struct_PreallocHandleNode__BufferBase(A2)
    MOVEQ   #0,D0
    MOVE.L  D0,Struct_PreallocHandleNode__BufferCapacity(A2)
    MOVE.L  D6,Struct_PreallocHandleNode__HandleIndex(A2)
    MOVE.L  Struct_PreallocHandleNode__BufferBase(A2),Struct_PreallocHandleNode__BufferCursor(A2)
    MOVE.L  D0,Struct_PreallocHandleNode__WriteRemaining(A2)
    MOVE.L  D0,Struct_PreallocHandleNode__ReadRemaining(A2)
    TST.L   D5
    BNE.S   .have_default_flags

    MOVE.L  #$8000,D0

.have_default_flags:
    MOVE.L  D7,D1
    OR.L    D0,D1
    MOVE.L  D1,Struct_PreallocHandleNode__OpenFlags(A2)
    MOVE.L  A2,D0

.return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
