BEGIN {
    label=0; call=0; zero=0; ret=0
}

/^TLIBA2_ResolveEntryWindowWithDefaultRange:$/ { label=1 }
/TLIBA2_ResolveEntryWindowAndSlotCount/ { call=1 }
/CLR\.L|MOVE\.L[[:space:]]+#0,/ { zero=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (call) print "HAS_RESOLVE_CALL"
    if (zero) print "HAS_ZERO_DEFAULT_ARGS"
    if (ret) print "HAS_RTS"
}
