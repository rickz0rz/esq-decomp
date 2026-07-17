;------------------------------------------------------------------------------
; Return-slot canaries for CLEANUP_ProcessAlerts localization (robust version).
; The SAS/C compiler DEFERS pushed-arg cleanup, so A7 is not a fixed offset from
; ProcessAlerts's return slot at every canary call site. Instead, CANARY_0 (the
; first probe, called before any arg pushes so A7 = entry-8 reliably; its own BSR
; makes A7 = entry-12) records the ABSOLUTE address of ProcessAlerts's return
; slot (A7+12) into g_ra_slot. Every later canary reads *g_ra_slot directly, so
; it is immune to A7 drift. If the slot holds a corrupted (small) value, the
; canary floods its digit forever over SERDAT so host capture identifies which
; callee (the one just before that canary) overwrote the return address.
;------------------------------------------------------------------------------
    SECTION text,CODE

    XDEF    _CANARY_0
    XDEF    _CANARY_1
    XDEF    _CANARY_2
    XDEF    _CANARY_3
    XDEF    _CANARY_4
    XDEF    _CANARY_5
    XDEF    _CANARY_6
    XDEF    _CANARY_7
    XDEF    _CANARY_8
    XDEF    _CANARY_9

; VALUE-CHECK canaries: CANARY_0 records the ABSOLUTE address of ProcessAlerts's
; return slot (A7+12 at its first-call site, before any arg push). Each later
; canary reads *g_ra_slot directly (immune to A7 drift) and floods its digit if
; the slot no longer holds a normal code address (>=0x100000). The flooding digit
; identifies the callee just before it as the one that overwrote the return slot.
_CANARY_0:
    LEA     12(A7),A0                   ; &(ProcessAlerts return slot)
    MOVE.L  A0,g_ra_slot
    RTS
_CANARY_1:
    MOVEQ   #'1',D1
    BRA.S   _canary_check
_CANARY_2:
    MOVEQ   #'2',D1
    BRA.S   _canary_check
_CANARY_3:
    MOVEQ   #'3',D1
    BRA.S   _canary_check
_CANARY_4:
    MOVEQ   #'4',D1
    BRA.S   _canary_check
_CANARY_5:
    MOVEQ   #'5',D1
    BRA.S   _canary_check
_CANARY_6:
    MOVEQ   #'6',D1
    BRA.S   _canary_check
_CANARY_7:
    MOVEQ   #'7',D1
    BRA.S   _canary_check
_CANARY_8:
    MOVEQ   #'8',D1
    BRA.S   _canary_check
_CANARY_9:
    MOVEQ   #'9',D1
    BRA.S   _canary_check

_canary_check:
    MOVEA.L g_ra_slot,A0
    MOVE.L  (A0),D0                     ; current return-slot value
    CMP.L   #$00100000,D0
    BCC.S   .ok                         ; normal code address -> not corrupted
    ANDI.W  #$FF,D1
    ORI.W   #$100,D1
.flood:
    MOVE.W  D1,($DFF030)
    MOVE.L  #40000,D2
.d:
    SUBQ.L  #1,D2
    BNE.S   .d
    BRA.S   .flood
.ok:
    RTS

; void DBG_HEX32(long v)  -- emit 'X'<8 hex nibbles><space> over SERDAT.
    XDEF    _DBG_HEX32
_DBG_HEX32:
    MOVE.L  4(A7),D1                    ; arg v
    MOVEQ   #'X',D0
    BSR.S   _dh_tx
    MOVEQ   #7,D3
    MOVE.L  D1,D2
_dh_nib:
    ROL.L   #4,D2
    MOVE.L  D2,D0
    ANDI.L  #$0F,D0
    ADDI.B  #'0',D0
    CMPI.B  #'9',D0
    BLE.S   _dh_dig
    ADDI.B  #7,D0
_dh_dig:
    BSR.S   _dh_tx
    DBRA    D3,_dh_nib
    MOVEQ   #' ',D0
    BSR.S   _dh_tx
    RTS
_dh_tx:
    ANDI.W  #$FF,D0
    ORI.W   #$100,D0
    MOVE.W  D0,($DFF030)
    MOVE.L  #40000,D4
_dh_d:
    SUBQ.L  #1,D4
    BNE.S   _dh_d
    RTS

    SECTION data,DATA
g_ra_slot:
    DC.L    0

    END
