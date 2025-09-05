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