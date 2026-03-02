BEGIN {
    label=0; div_call=0; c12=0; flag18=0; plus12=0; write_month=0; ret=0
}

/^DATETIME_AdjustMonthIndex:$/ { label=1 }
/GROUP_AG_JMPTBL_MATH_DivS32|DATETIME_ModByDivS32Helper/ { div_call=1 }
/#12|12\.w/ { c12=1 }
/[(]18,[aA][0-7][)]|18\([aA][0-7]\)/ { flag18=1 }
/^ADD\.L[[:space:]]+[dD][0-7],[dD][0-7]$|^ADD\.L[[:space:]]+#12,[dD][0-7]$|^ADDQ\.L[[:space:]]+#12,[dD][0-7]$/ { plus12=1 }
/^MOVE\.W[[:space:]]+[dD][0-7],8\([aA][0-7]\)$|^MOVE\.W[[:space:]]+[dD][0-7],\([0-9]+,[aA][0-7]\)$/ { write_month=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (div_call) print "HAS_DIV_CALL"
    if (c12) print "HAS_CONST_12"
    if (flag18) print "HAS_FLAG18_TEST"
    if (plus12) print "HAS_OPTIONAL_PLUS12"
    if (write_month) print "HAS_MONTH_WRITEBACK"
    if (ret) print "HAS_RTS"
}
