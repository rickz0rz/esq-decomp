BEGIN {
    label=0; cmp11=0; flag18=0; div12=0; swap=0; write8=0; zero_check=0; write12=0; rts=0
}

/^DATETIME_NormalizeMonthRange:$/ { label=1 }
/#11|11\.w/ { cmp11=1 }
/18\([aA][0-7]\)|\(18,[aA][0-7]\)/ { flag18=1 }
/#12|12\.w|DIVS|DATETIME_RemS16Div12/ { div12=1 }
/^SWAP[[:space:]]+[dD][0-7]$|DATETIME_RemS16Div12/ { swap=1 }
/8\([aA][0-7]\)|\(8,[aA][0-7]\)/ { write8=1 }
/^TST\.W[[:space:]]+[dD][0-7]$|^JEQ |^BEQ\./ { zero_check=1 }
/^MOVE\.W[[:space:]]+[dD][0-7],8\([aA][0-7]\)$|^MOVE\.W[[:space:]]+#12,8\([aA][0-7]\)$|^MOVE\.W[[:space:]]+#12,\(8,[aA][0-7]\)$/ { write12=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (cmp11) print "HAS_GT11_TEST"
    if (flag18) print "HAS_FLAG18_WRITE"
    if (div12) print "HAS_DIV12"
    if (swap) print "HAS_SWAP_REMAINDER"
    if (write8) print "HAS_MONTH_WRITE"
    if (zero_check) print "HAS_ZERO_REMAINDER_CHECK"
    if (write12) print "HAS_WRITE12_ON_ZERO"
    if (rts) print "HAS_RTS"
}
