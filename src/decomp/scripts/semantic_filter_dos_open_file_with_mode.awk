BEGIN {
    has_name_arg = 0
    has_mode_arg = 0
    has_dos_ref = 0
    has_open_call = 0
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

    if (u ~ /MOVE\.L .*A[0-7],D1/ || u ~ /MOVE\.L .*\(A7\),D1/ || u ~ /MOVE\.L .*\(SP\),D1/ || u ~ /^MOVE\.L \([0-9]+,(A7|SP)\),-\((A7|SP)\)$/) has_name_arg = 1
    if (u ~ /MOVE\.L .*D[0-7],D2/ || u ~ /MOVE\.L .*\(A7\),D2/ || u ~ /MOVE\.L .*\(SP\),D2/ || u ~ /^MOVE\.L \([0-9]+,(A7|SP)\),-\((A7|SP)\)$/) has_mode_arg = 1
    if (u ~ /GLOBAL_REF_DOS_LIBRARY_2/ || u ~ /MOVEA?\.L .*A6/ || u ~ /DOS_LVO_OPEN/) has_dos_ref = 1
    if (u ~ /JSR .*LVOOPEN/ || u ~ /JSR .*DOS_LVO_OPEN/ || u ~ /JSR \(A[0-7]\)/) has_open_call = 1
    if (has_open_call) has_dos_ref = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_NAME_ARG=" has_name_arg
    print "HAS_MODE_ARG=" has_mode_arg
    print "HAS_DOS_REF=" has_dos_ref
    print "HAS_OPEN_CALL=" has_open_call
    print "HAS_RTS=" has_rts
}
