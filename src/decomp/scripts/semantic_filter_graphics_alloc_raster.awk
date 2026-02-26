BEGIN {
    has_width_arg = 0
    has_height_arg = 0
    has_graphics_ref = 0
    has_alloc_call = 0
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

    if (u ~ /MOVE\.L .*D[0-7],D0/ || u ~ /MOVE\.L .*\(A7\),D0/ || u ~ /MOVE\.L .*\(SP\),D0/ || u ~ /^MOVE\.L \([0-9]+,(A7|SP)\),-\((A7|SP)\)$/) has_width_arg = 1
    if (u ~ /MOVE\.L .*D[0-7],D1/ || u ~ /MOVE\.L .*\(A7\),D1/ || u ~ /MOVE\.L .*\(SP\),D1/ || u ~ /^MOVE\.L \([0-9]+,(A7|SP)\),-\((A7|SP)\)$/) has_height_arg = 1
    if (u ~ /GLOBAL_REF_GRAPHICS_LIBRARY/ || u ~ /GRAPHICS_LVO_ALLOC_RASTER/) has_graphics_ref = 1
    if (u ~ /JSR .*LVOALLOCRASTER/ || u ~ /JSR .*GRAPHICS_LVO_ALLOC_RASTER/ || u ~ /JSR \(A[0-7]\)/) has_alloc_call = 1
    if (has_alloc_call) has_graphics_ref = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_WIDTH_ARG=" has_width_arg
    print "HAS_HEIGHT_ARG=" has_height_arg
    print "HAS_GRAPHICS_REF=" has_graphics_ref
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_RTS=" has_rts
}
