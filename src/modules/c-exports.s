; Guards for hardware addresses that C restorations reach as externs.
;
; A C file must reach a hardware register as an ordinary extern: writing
; *(volatile UWORD *)0xDFF004 makes SAS/C emit MOVEA.L #imm,An + MOVE.W (An),Dn
; instead of the absolute MOVE.W (xxx).L,Dn the stock binary uses.
;
; The symbols cannot be exported from here: vasm silently drops XDEF of an
; absolute equate, producing an object with no external-definition hunk at all
; (verified -- the object contained only an empty CODE hunk). So build-split.sh
; defines them at link time with `vlink -D _VPOSR=0xDFF004` instead.
;
; These asserts exist so the two cannot drift apart. If an address changes in
; hardware-addresses.s, the build fails here rather than silently linking a C
; restoration against a stale constant.
;
; Emits no bytes. Included exactly once from src/Prevue.asm.

    assert  VPOSR==$DFF004,"VPOSR moved; update the -D flags in build-split.sh"
    assert  CIAB_PRA==$BFD000,"CIAB_PRA moved; update mkabsdefs args in build-split.sh"
    assert  SERDAT==$DFF030,"SERDAT moved; update mkabsdefs args in build-split.sh"
    assert  COP1LCH==$DFF080,"COP1LCH moved; update mkabsdefs args in build-split.sh"
    assert  CIAA_PRB==$BFE101,"CIAA_PRB moved; update mkabsdefs args in build-split.sh"
    assert  CIAA_DDRB==$BFE301,"CIAA_DDRB moved; update mkabsdefs args in build-split.sh"
