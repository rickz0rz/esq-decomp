;------------------------------------------------------------------------------
; Exception catcher: transmits faulting PC + a stack window over serial.
; Installed by _INSTALL_ADDR_ERR_HANDLER (call early in init + re-armed per VERTB).
;   vec 2 ($08) bus error, vec 3 ($0C) address error  -> _ADDR_ERR_HANDLER
;     group-0 long frame: SSW(+0) faultAddr(+2) IR(+6) SR(+8) PC(+10)
;   vec 4 ($10) illegal instruction                   -> _ILLEGAL_HANDLER
;     group-1/2 short frame: SR(+0) PC(+2)
; Emits over SERDAT ($DFF030), repeatedly (host: nc 127.0.0.1 1234):
;   P<pc> F<fault> U<usp0><usp4> H<handler> Q<usp> R<sr> I<ir> S<16 longs@USP-16>
; ir_save=$00004444 marks an illegal-instruction (vec 4) capture.
;------------------------------------------------------------------------------
    SECTION text,CODE

    XDEF    _INSTALL_ADDR_ERR_HANDLER
    XDEF    _ADDR_ERR_HANDLER
_INSTALL_ADDR_ERR_HANDLER:
    LEA     _ADDR_ERR_HANDLER(PC),A0
    MOVE.L  A0,($08).W                  ; vector 2 = bus error
    MOVE.L  A0,($0C).W                  ; vector 3 = address error
    LEA     _ILLEGAL_HANDLER(PC),A0
    MOVE.L  A0,($10).W                  ; vector 4 = illegal instruction
    LEA     _FLINE_HANDLER(PC),A0
    MOVE.L  A0,($2C).W                  ; vector 11 = F-line (8000 000B guru)
    RTS

_FLINE_HANDLER:
    MOVE.L  2(A7),D5                    ; PC (short frame +2)
    MOVEQ   #0,D6                       ; no fault address
    MOVE.W  0(A7),D0                    ; SR (short frame +0)
    EXT.L   D0
    MOVE.L  D0,sr_save
    MOVE.L  #$000B,ir_save              ; F-line (vec 11) marker
    BRA.S   _emit_setup

_ILLEGAL_HANDLER:
    MOVE.L  2(A7),D5                    ; PC (short frame +2)
    MOVEQ   #0,D6                       ; no fault address
    MOVE.W  0(A7),D0                    ; SR (short frame +0)
    EXT.L   D0
    MOVE.L  D0,sr_save
    MOVE.L  #$4444,ir_save              ; illegal-instruction marker
    BRA.S   _emit_setup

_ADDR_ERR_HANDLER:
    MOVE.L  10(A7),D5                   ; PC (group-0 frame +10)
    MOVE.L  2(A7),D6                    ; fault address (frame +2)
    MOVE.W  8(A7),D0                    ; SR (frame +8)
    EXT.L   D0
    MOVE.L  D0,sr_save
    MOVE.W  6(A7),D0                    ; IR (frame +6)
    EXT.L   D0
    MOVE.L  D0,ir_save

_emit_setup:
    MOVE.L  USP,A4
    MOVE.L  (A4),A2
    MOVE.L  4(A4),A3
    LEA     _ADDR_ERR_HANDLER(PC),A6    ; own load-base anchor
.loop:
    MOVEQ   #'P',D0
    BSR.W   .tx
    MOVE.L  D5,D1
    BSR.W   .txhex                      ; PC
    MOVEQ   #'F',D0
    BSR.W   .tx
    MOVE.L  D6,D1
    BSR.W   .txhex                      ; fault address
    MOVEQ   #'U',D0
    BSR.W   .tx
    MOVE.L  A2,D1
    BSR.W   .txhex                      ; USP[0]
    MOVE.L  A3,D1
    BSR.W   .txhex                      ; USP[4]
    MOVEQ   #'H',D0
    BSR.W   .tx
    MOVE.L  A6,D1
    BSR.W   .txhex                      ; handler addr
    MOVEQ   #'Q',D0
    BSR.W   .tx
    MOVE.L  A4,D1
    BSR.W   .txhex                      ; absolute USP
    MOVEQ   #'R',D0
    BSR.W   .tx
    MOVE.L  sr_save,D1
    BSR.W   .txhex                      ; SR
    MOVEQ   #'I',D0
    BSR.W   .tx
    MOVE.L  ir_save,D1
    BSR.W   .txhex                      ; IR (or 4444 = illegal)
    ; --- C: first user-stack long that lands in our code hunk (the C caller) ---
    ; our text is ~[A6-0x1000, A6+0x3B000] since A6 = _ADDR_ERR_HANDLER (runtime).
    MOVEQ   #'C',D0
    BSR.W   .tx
    MOVE.L  A6,A2
    SUBA.L  #$1000,A2                   ; A2 = text lower bound
    MOVE.L  A6,A3
    ADDA.L  #$3B000,A3                  ; A3 = text upper bound
    MOVE.L  A4,A1                       ; A1 = USP
    MOVE.W  #1023,D7                    ; scan up to 1024 user-stack longs
    MOVEQ   #0,D6                       ; count of matches emitted
.cscan:
    MOVE.L  (A1)+,D1
    CMP.L   A2,D1
    BCS.S   .cnext                      ; D1 < lower
    CMP.L   A3,D1
    BCC.S   .cnext                      ; D1 >= upper
    ; found a return address in our text -> emit it
    MOVEM.L D6/D7/A1,-(A7)
    BSR.W   .txhex
    MOVEQ   #' ',D0
    BSR.W   .tx
    MOVEM.L (A7)+,D6/D7/A1
    ADDQ.L  #1,D6
    CMPI.L  #4,D6                       ; emit up to 4 return addresses
    BEQ.S   .cdone
.cnext:
    DBRA    D7,.cscan
.cdone:
    MOVEQ   #'S',D0
    BSR.W   .tx
    MOVE.L  A4,A1
    LEA     -16(A1),A1
    MOVEQ   #15,D7
.sdmp:
    MOVE.L  (A1)+,D1
    MOVEM.L D7/A1,-(A7)
    BSR.W   .txhex
    MOVEQ   #' ',D0
    BSR.W   .tx
    MOVEM.L (A7)+,D7/A1
    DBRA    D7,.sdmp
    MOVEQ   #10,D0
    BSR.W   .tx
    BRA     .loop

.txhex:
    MOVEQ   #7,D3
    MOVE.L  D1,D2
.nib:
    ROL.L   #4,D2
    MOVE.L  D2,D0
    ANDI.L  #$0F,D0
    ADDI.B  #'0',D0
    CMPI.B  #'9',D0
    BLE.S   .dig
    ADDI.B  #7,D0
.dig:
    BSR.S   .tx
    DBRA    D3,.nib
    RTS

.tx:
    ANDI.W  #$FF,D0
    ORI.W   #$100,D0
    MOVE.W  D0,($DFF030)
    MOVE.L  #40000,D4
.txd:
    SUBQ.L  #1,D4
    BNE.S   .txd
    RTS

    SECTION data,DATA
sr_save:
    DC.L    0
ir_save:
    DC.L    0

    END
