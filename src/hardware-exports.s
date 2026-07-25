; Export selected hardware-register equates so C restorations can reference them
; as ordinary externs. Without this a C file must write
; `*(volatile UWORD *)0xDFF004`, which SAS/C compiles to MOVEA.L #imm,An +
; MOVE.W (An),Dn rather than the absolute-addressed MOVE.W (xxx).L,Dn the stock
; binary uses -- an unavoidable 2-byte divergence on every hardware access.
;
; These are absolute equates, so exporting them emits no bytes and the linker
; patches the value directly with no relocation. Included exactly once from
; src/Prevue.asm: an XDEF in the shared prelude would be defined by every unit
; and collide at link time.
    XDEF    VPOSR
    XDEF    CIAB_PRA
