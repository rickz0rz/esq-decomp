BEGIN {
    label=0; normalize=0; d4=0; d100=0; d400=0; ret0=0; ret1=0; rts=0
}

/^DATETIME_IsLeapYear:$/ { label=1 }
/#\$76c|#1900/ { normalize=1 }
/#4([^0-9]|$)|[[:space:]]4\.w$/ { d4=1 }
/#100([^0-9]|$)|[[:space:]]100\.w$/ { d100=1 }
/#400([^0-9]|$)|[[:space:]]400\.w$/ { d400=1 }
/^MOVEQ[[:space:]]+#0,[dD]0$|^CLR\.L[[:space:]]+[dD]0$/ { ret0=1 }
/^MOVEQ[[:space:]]+#1,[dD]0$/ { ret1=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (normalize) print "HAS_1900_NORMALIZE"
    if (d4) print "HAS_DIV_BY_4_TEST"
    if (d100) print "HAS_DIV_BY_100_TEST"
    if (d400) print "HAS_DIV_BY_400_TEST"
    if (ret0) print "HAS_RET_0"
    if (ret1) print "HAS_RET_1"
    if (rts) print "HAS_RTS"
}
