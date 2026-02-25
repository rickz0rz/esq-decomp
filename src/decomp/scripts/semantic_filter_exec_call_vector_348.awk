BEGIN {
    has_prologue = 0
    has_arg_loads = 0
    has_lvo_call = 0
    has_epilogue = 0
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

    if (u ~ /^MOVEM\.L D2-D3\/A2-A3\/A6,-\((A7|SP)\)$/ || u ~ /^MOVEM\.L A6\/A[0-3]\/D[0-3],-\((A7|SP)\)$/) has_prologue = 1
    if (u ~ /^MOVEA?\.L [0-9]+\((A7|SP)\),A[0-3]$/ || u ~ /^MOVE\.L [0-9]+\((A7|SP)\),D[0-3]$/) has_arg_loads = 1
    if (u ~ /JSR .*LVOFREETRAP/) has_lvo_call = 1
    if (u ~ /^MOVEM\.L \((A7|SP)\)\+,D2-D3\/A2-A3\/A6$/ || u ~ /^MOVEM\.L \((A7|SP)\)\+,A6\/A[0-3]\/D[0-3]$/) has_epilogue = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_PROLOGUE=" has_prologue
    print "HAS_ARG_LOADS=" has_arg_loads
    print "HAS_LVO_CALL=" has_lvo_call
    print "HAS_EPILOGUE=" has_epilogue
    print "HAS_RTS=" has_rts
}
