    XDEF    ESQ_CheckAvailableFastMemory


;------------------------------------------------------------------------------
; FUNC: ESQ_CheckAvailableFastMemory
; ARGS:
;   (none)
; RET:
;   D0: available fast memory bytes
; CLOBBERS:
;   D0-D1/A6
; CALLS:
;   _LVOAvailMem
; READS:
;   AbsExecBase
; WRITES:
;   HAS_REQUESTED_FAST_MEMORY
; DESC:
;   Checks available fast memory and sets HAS_REQUESTED_FAST_MEMORY if below
;   the desired threshold.
; NOTES:
;   - Threshold is .desiredMemory (600,000 bytes).
;------------------------------------------------------------------------------
; If the system has at least 600,000 bytes of fast memory, keep HAS_REQUESTED_FAST_MEMORY set to 0.
; Otherwise, set it to 1.
ESQ_CheckAvailableFastMemory:

.desiredMemory  = 600000

    MOVEQ   #2,D1                           ; Set 2 to D1...
    MOVEA.L AbsExecBase,A6                  ; Check the available memory for type 2 (fast memory) in D1, and
    JSR     _LVOAvailMem(A6)                ; store the result in D0.

    CMPI.L  #(.desiredMemory),D0            ; See if we have more than 600,000 bytes of available memory
    BGE.S   .done                           ; If we have equal to or more than our target, jump to .skipFastMemorySet

    MOVE.W  #1,HAS_REQUESTED_FAST_MEMORY    ; Set HAS_REQUESTED_FAST_MEMORY to 0x0001 (it's 0x0000 by default)

.done:
    RTS

;!======
