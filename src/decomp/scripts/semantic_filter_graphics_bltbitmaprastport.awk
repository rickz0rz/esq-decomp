BEGIN {
    l=0; lib=0; lvo=0; movem=0; a0a1=0; d0d6=0; rts=0
}

/^GRAPHICS_BltBitMapRastPort:$/ { l=1 }
/Global_GraphicsLibraryBase_A4/ { lib=1 }
/LVOBltBitMapRastPort/ { lvo=1 }
/MOVEM\.L.*D2-D6\/A6/ { movem=1 }
/MOVEA\.L.*A0|MOVEA\.L.*A1/ { a0a1=1 }
/MOVEM\.L.*D0-D1|MOVEM\.L.*D2-D6/ { d0d6=1 }
/^RTS$/ { rts=1 }

END {
    if (l) print "HAS_LABEL"
    if (lib) print "HAS_GRAPHICS_BASE"
    if (lvo) print "HAS_BLT_CALL"
    if (movem) print "HAS_SAVE_RESTORE"
    if (a0a1) print "HAS_A0_A1_LOAD"
    if (d0d6) print "HAS_DREG_LOADS"
    if (rts) print "HAS_RTS"
}
