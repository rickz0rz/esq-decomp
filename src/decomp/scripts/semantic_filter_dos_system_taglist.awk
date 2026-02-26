BEGIN {
    has_dos_base = 0
    has_d1_flow = 0
    has_d2_flow = 0
    has_systemtag_call = 0
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

    if (u ~ /GLOBAL_REF_DOS_LIBRARY_2/ || u ~ /^MOVEA\.L .*A6$/) has_dos_base = 1
    if (u ~ /D1/ || u ~ /MOVEM\.L .*D1/) has_d1_flow = 1
    if (u ~ /D2/ || u ~ /MOVEM\.L .*D2/) has_d2_flow = 1
    if (u ~ /JSR .*LVOSYSTEMTAGLIST/) has_systemtag_call = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_DOS_BASE=" has_dos_base
    print "HAS_D1_FLOW=" has_d1_flow
    print "HAS_D2_FLOW=" has_d2_flow
    print "HAS_SYSTEMTAG_CALL=" has_systemtag_call
    print "HAS_RTS=" has_rts
}
