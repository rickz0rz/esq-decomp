BEGIN {
    label=0; invalid=0; one_const=0; shift=0; zero_ret=0; rts=0
    lower_direct=0; upper_direct=0; bounded_idiom=0
}

/^BRUSH_PlaneMaskForIndex:$/ { label=1 }
/\.(planemask_invalid_index|L[0-9]+):/ { invalid=1 }

# Direct source form: (index <= 0) / (index >= 9)
/^TST\.L[[:space:]]+[dD][0-7]$/ { lower_direct=1 }
/^CMP\.L[[:space:]]+#?9,[dD][0-7]$|^CMPI\.L[[:space:]]+#?9,[dD][0-7]$/ { upper_direct=1 }
/^MOVEQ[[:space:]]+#9,[dD]0$/ { upper_direct=1 }

# GCC compact form: (index - 1) <= 7
/^SUBQ\.L[[:space:]]+#1,[dD]0$/ { bounded_idiom=1 }
/^MOVEQ[[:space:]]+#7,[dD][0-7]$/ { bounded_idiom=1 }

/^MOVEQ[[:space:]]+#1,[dD]0$|^MOVE\.L[[:space:]]+#1,[dD]0$/ { one_const=1 }
/^ASL\.L[[:space:]]+[dD][0-7],[dD]0$|^LSL\.L[[:space:]]+[dD][0-7],[dD]0$/ { shift=1 }
/^MOVEQ[[:space:]]+#0,[dD]0$|^CLR\.L[[:space:]]+[dD]0$/ { zero_ret=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if ((lower_direct && upper_direct) || bounded_idiom) print "HAS_RANGE_GUARD"
    if (one_const) print "HAS_ONE_SEED"
    if (shift) print "HAS_SHIFT_TO_MASK"
    if (invalid) print "HAS_INVALID_PATH"
    if (zero_ret) print "HAS_ZERO_RETURN"
    if (rts) print "HAS_RTS"
}
