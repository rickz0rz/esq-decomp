BEGIN {
    has_label = 0
    has_global = 0
    has_copy_loop = 0
    has_terminator_store = 0
    has_rts = 0
}

/^ESQPROTO_CopyLabelToGlobal:$/ {
    has_label = 1
}

/WDISP_StatusListMatchPattern/ {
    has_global = 1
}

/MOVE\.B[[:space:]]+\(([Aa]0)\)\+,\(([Aa]1)\)\+/ {
    has_copy_loop = 1
}

/CLR\.B/ {
    has_terminator_store = 1
}

/^RTS$/ {
    has_rts = 1
}

END {
    if (has_label) print "HAS_LABEL"
    if (has_global) print "HAS_GLOBAL_DST"
    if (has_copy_loop) print "HAS_COPY_LOOP"
    if (has_terminator_store) print "HAS_TERMINATOR_STORE"
    if (has_rts) print "HAS_RTS"
}
