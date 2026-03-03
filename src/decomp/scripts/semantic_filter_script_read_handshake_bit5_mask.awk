BEGIN { label=0; ciab=0; m20=0; andop=0; rts=0 }
/^SCRIPT_ReadHandshakeBit5Mask:$/ { label=1 }
/CIAB_PRA/ { ciab=1 }
/#32|#\$20/ { m20=1 }
/AND\.L|ANDI\.W/ { andop=1 }
/^RTS$/ { rts=1 }
END {
    if (label) print "HAS_LABEL"
    if (ciab) print "HAS_CIAB_READ"
    if (m20) print "HAS_MASK_20"
    if (andop) print "HAS_AND_OP"
    if (rts) print "HAS_RTS"
}
