BEGIN {
    label=0; compat=0; c7f00=0; c3000=0; c2000=0; c3300=0; flag=0; ret=0
}

/^ESQ_CheckCompatibleVideoChip:$/ { label=1 }
/VPOSR|dff004|14675972/ { compat=1 }
/#\$7f00|#32512|32512\.[Ww]/ { c7f00=1 }
/#\$3000|#12288|12288\.[Ww]|#\$6f00|#28416|28416\.[Ww]/ { c3000=1 }
/#\$2000|#8192|8192\.[Ww]/ { c2000=1 }
/#\$3300|#13056|13056\.[Ww]/ { c3300=1 }
/IS_COMPATIBLE_VIDEO_CHIP/ { flag=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (compat) print "HAS_VPOSR_READ"
    if (c7f00) print "HAS_MASK_7F00"
    if (c3000) print "HAS_CONST_3000"
    if (c2000) print "HAS_CONST_2000"
    if (c3300) print "HAS_CONST_3300"
    if (flag) print "HAS_COMPAT_FLAG_REF"
    if (ret) print "HAS_RTS"
}
