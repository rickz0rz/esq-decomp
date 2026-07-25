    XDEF    _ESQ_CheckCompatibleVideoChip

;------------------------------------------------------------------------------
; FUNC: _ESQ_CheckCompatibleVideoChip
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D6-D7
; CALLS:
;   (none)
; READS:
;   VPOSR
; WRITES:
;   _IS_COMPATIBLE_VIDEO_CHIP
; DESC:
;   Checks VPOSR chip ID against a whitelist; sets _IS_COMPATIBLE_VIDEO_CHIP if
;   the current chip does not match the known IDs.
; NOTES:
;   - Whitelist: $30, $20, $33 (see chip table below).
;------------------------------------------------------------------------------
; Chip table here:
; (1) 30 = 8372 (Fat-hr) (agnushr),thru rev4, NTSC
; (2) 20 = 8372 (Fat-hr) (agnushr),thru rev4, PAL
; (3) 33 = 8374 (Alice) rev 3 thru rev 4, NTSC
_ESQ_CheckCompatibleVideoChip:
    MOVEM.L D6-D7,-(A7)

    MOVE.W  VPOSR,D7                    ; $DFF004 = http://amiga-dev.wikidot.com/hardware:vposr
    MOVE.L  D7,D6                       ; Copy VPOSR value into D6
    ANDI.W  #$7f00,D6                   ; Logical AND D6 with $7F00 (01111111 00000000) and store back into D6
    CMPI.W  #$3000,D6                   ; Compare it with high byte of $3000 (00110000 00000000) aka $30 to see if we're chip 1
    BEQ.S   .done                       ; If equal, jump to .return

    CMPI.W  #$2000,D6                   ; Compare it with high byte of $2000 (00110000 00000000) aka $20 to see if we're chip 2
    BEQ.S   .done                       ; If equal, jump to .return

    CMPI.W  #$3300,D6                   ; Compare it with high byte of $3300 (00110011 00000000) aka $33 to see if we're chip 3
    BEQ.S   .done                       ; If equal, jump to .return

    MOVE.W  #1,_IS_COMPATIBLE_VIDEO_CHIP ; Set $0001 (true) into _IS_COMPATIBLE_VIDEO_CHIP

.done:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======
