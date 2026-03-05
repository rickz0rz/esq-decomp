BEGIN {
    has_label = 0
    has_guard = 0
    has_scan_loop = 0
    has_mode_switch = 0
    has_found_gate = 0
    has_default_clear = 0
    has_return_move = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^COI_GETANIMFIELDPOINTERBYMODE[A-Z0-9_]*:/) has_label = 1
    if (u ~ /COI_GETANIMFIELDPOINTERBYMODE_RETURN/ || u ~ /TST.L 48\(A3\)/ || u ~ /BEQ\.[BWS]?/) has_guard = 1
    if (u ~ /CMP.W 36\(A0\),D5/ || u ~ /ADDQ.W #1,D5/ || u ~ /BRA\.[BWS]? .*034A/ || u ~ /__COI_GETANIMFIELDPOINTERBYMODE__/) has_scan_loop = 1
    if (u ~ /JMP .*LAB_034D/ || u ~ /DC.W .*LAB_034D/ || u ~ /__SWITCH_COI_GETANIMFIELDPOINTERBYMODE/ || u ~ /CMPI.W #8,D0/ || u ~ /CMP.W #8,D0/ || u ~ /CMPI.L #\$8,D0/) has_mode_switch = 1
    if (u ~ /TST.W D4/ || u ~ /MOVEQ #1,D4/ || u ~ /CMP.W .*D7/) has_found_gate = 1
    if (u ~ /CLR.L -16\(A5\)/ || u ~ /CLR.L \$18\(A7\)/ || u ~ /MOVEQ #0,D0/ || u ~ /MOVE.L D0,-16\(A5\)/) has_default_clear = 1
    if (u ~ /MOVE.L -16\(A5\),D0/ || u ~ /MOVE.L \$18\(A7\),D0/ || u ~ /MOVE.L D[0-7],D0/) has_return_move = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_GUARD=" has_guard
    print "HAS_SCAN_LOOP=" has_scan_loop
    print "HAS_MODE_SWITCH=" has_mode_switch
    print "HAS_FOUND_GATE=" has_found_gate
    print "HAS_DEFAULT_CLEAR=" has_default_clear
    print "HAS_RETURN_MOVE=" has_return_move
}
