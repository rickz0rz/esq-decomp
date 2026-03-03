BEGIN { label=0; andff=0; serdat=0; shadow=0; rts=0 }
/^SCRIPT_WriteCtrlShadowToSerdat:$/ { label=1 }
/ANDI\.W #\$ff|#255/ { andff=1 }
/SERDAT/ { serdat=1 }
/SCRIPT_SerialShadowWord/ { shadow=1 }
/^RTS$/ { rts=1 }
END {
    if (label) print "HAS_LABEL"
    if (andff) print "HAS_MASK_FF"
    if (serdat) print "HAS_SERDAT_WRITE"
    if (shadow) print "HAS_SHADOW_WRITE"
    if (rts) print "HAS_RTS"
}
