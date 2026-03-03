BEGIN { label=0; ciab=0; bit3=0; one=0; rts=0 }
/^SCRIPT_ReadHandshakeBit3Flag:$/ { label=1 }
/CIAB_PRA/ { ciab=1 }
/BTST #3|#3|#\$08/ { bit3=1 }
/#1([^0-9]|$)|MOVEQ #1/ { one=1 }
/^RTS$/ { rts=1 }
END {
    if (label) print "HAS_LABEL"
    if (ciab) print "HAS_CIAB_READ"
    if (bit3) print "HAS_BIT3_TEST"
    if (one) print "HAS_CONST_1"
    if (rts) print "HAS_RTS"
}
