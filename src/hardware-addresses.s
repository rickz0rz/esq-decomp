; 8520 CIA
; https://amigadev.elowar.com/read/ADCD_2.1/Hardware_Manual_guide/node012E.html
;; CIA (b) serial/parallel port (used for CTS/DSR bit-banging for CTRL)
;; bit 4 = CTS
;; bit 3 = DSR
CIAB_PRA           = $BFD000
;; CIA (a) parallel port (possibly used for genlock comms?)
CIAA_PRB           = $BFE101
;; port direction for PRB_CIAA
;; 0 = input
;; 1 = output
CIAA_DDRB          = $BFE301

; AGA Agnus (controller port I/O)
; http://amigadev.elowar.com/read/ADCD_2.1/Hardware_Manual_guide/node017E.html
; http://amiga-dev.wikidot.com/information:hardware#:~:text=Hardware%20Access-,OCS%20/%20ECS%20/%20AGA,-As%20described%20in

;; Blitter destination data register
BLTDDAT            = $DFF000

;; Read light pen position
VPOSR              = $DFF004

;; Serial port data and stop bits write
SERDAT             = $DFF030

;; Coprocessor first location register (high 5 bits) (old-3 bits)
COP1LCH            = $DFF080

;; Interrupt enable bits (clear or set bits)
INTENA             = $DFF09A

;; http://amiga-dev.wikidot.com/hardware:diwstrt
DIWSTRT            = $DFF08E

;; http://amiga-dev.wikidot.com/hardware:diwstop
DIWSTOP            = $DFF090

;; http://amiga-dev.wikidot.com/hardware:ddfstrt
DDFSTRT            = $DFF092
DDFSTRT_WIDE       = $30

;; http://amiga-dev.wikidot.com/hardware:ddfstop
DDFSTOP            = $DFF094
DDFSTOP_WIDE       = $D8

DMACON             = $DFF096

;; http://amiga-dev.wikidot.com/hardware:intreqr
INTREQ             = $DFF09C

;; http://amiga-dev.wikidot.com/hardware:audxlch
AUD1LCH            = $DFF0B0
;; http://amiga-dev.wikidot.com/hardware:audxlen
AUD1LEN            = $DFF0B4
;; http://amiga-dev.wikidot.com/hardware:audxper
AUD1PER            = $DFF0B6
;; http://amiga-dev.wikidot.com/hardware:audxvol
AUD1VOL            = $DFF0B8

;; http://amiga-dev.wikidot.com/hardware:bplxmod
BPL1MOD            = $DFF108

;; http://amiga-dev.wikidot.com/hardware:bplxmod
BPL2MOD            = $DFF10A
