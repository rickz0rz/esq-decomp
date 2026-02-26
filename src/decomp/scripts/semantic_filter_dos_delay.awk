BEGIN {
    has_lib_ref = 0
    has_d1_flow = 0
    has_delay_call = 0
    has_rts = 0
}

function trim(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /GLOBAL_REF_DOS_LIBRARY_2/ || u ~ /MOVEA\.L .*A6/) has_lib_ref = 1
    if (u ~ /\bD1\b/) has_d1_flow = 1
    if (u ~ /JSR .*LVODELAY/) has_delay_call = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_LIB_REF=" has_lib_ref
    print "HAS_D1_FLOW=" has_d1_flow
    print "HAS_DELAY_CALL=" has_delay_call
    print "HAS_RTS=" has_rts
}
