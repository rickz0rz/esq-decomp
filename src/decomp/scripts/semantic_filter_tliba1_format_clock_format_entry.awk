BEGIN {
    label=0; has_sprintf=0; append=0; c200=0; c65=0; c32=0; c4=0; ret=0
}

/^TLIBA1_FormatClockFormatEntry:$/ { label=1 }
/WDISP_SPrintf/ { has_sprintf=1 }
/STRING_AppendAtNull/ { append=1 }
/#\$200|#512|#511|#510/ { c200=1 }
/#\$41|#65/ { c65=1 }
/#\$20|#32|#-32/ { c32=1 }
/#\$04|#4([^0-9]|$)/ { c4=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (has_sprintf) print "HAS_SPRINTF_CALL"
    if (append) print "HAS_APPEND_CALL"
    if (c200) print "HAS_CONST_200"
    if (c65) print "HAS_CONST_65"
    if (c32) print "HAS_CONST_32"
    if (c4) print "HAS_CONST_4"
    if (ret) print "HAS_RTS"
}
