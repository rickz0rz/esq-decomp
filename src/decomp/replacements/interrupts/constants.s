;------------------------------------------------------------------------------
; DECOMP TARGETS interrupt constants include mirror
; SOURCE: interrupts/constants.s
; PURPOSE:
;   Direct hybrid replacement mirror for the interrupt bit constants include.
;   This keeps the hybrid replacement map exhaustive across the scoped
;   `src/interrupts/` tree without changing any behavior.
;------------------------------------------------------------------------------

; See: https://d0.se/include/hardware/intbits.i
INTB_VERTB      = 5
INTB_AUD1       = 8
INTB_RBF        = 11
