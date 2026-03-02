BEGIN {
    label=0; c88=0; c49=0; c55=0; c48=0; neg1=0; zero=0; ret=0
}

/^TLIBA1_ParseStyleCodeChar:$/ { label=1 }
/#\$58|#88/ { c88=1 }
/#\$31|#49|#-49/ { c49=1 }
/#\$37|#55|#6([^0-9]|$)/ { c55=1 }
/#\$30|#48|#-48/ { c48=1 }
/#-1|#\$ff/ { neg1=1 }
/#0([^0-9]|$)/ { zero=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (c88) print "HAS_CONST_88"
    if (c49) print "HAS_CONST_49"
    if (c55) print "HAS_CONST_55"
    if (c48) print "HAS_CONST_48"
    if (neg1) print "HAS_NEG1"
    if (zero) print "HAS_ZERO"
    if (ret) print "HAS_RTS"
}
