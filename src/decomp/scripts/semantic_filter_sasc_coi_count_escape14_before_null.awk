BEGIN {
    has_label = 0
    has_loop = 0
    has_load = 0
    has_escape_cmp = 0
    has_escape_inc = 0
    has_return_move = 0
    has_restore = 0
    has_rts = 0
}
function trim(s, t){ t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t }
{
    line = trim($0); if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^COI_COUNTESCAPE14BEFORENULL:/) has_label = 1
    if (u ~ /^\.SCAN_LOOP:/ || u ~ /BRA\.B .*__2/ || u ~ /BGE|BEQ|BNE/) has_loop = 1
    if (u ~ /MOVE.B 0\(A3,D6.W\),D0/ || u ~ /MOVE.B \(A[0-7]\),D0/ || u ~ /MOVE.B \$0\(A[0-7],D[0-7]\.L\),D[0-7]/) has_load = 1
    if (u ~ /SUBI.W #20,D0/ || u ~ /SUBI.W #\$14,D0/ || u ~ /CMPI.W #\$14,D0/ || u ~ /MOVEQ.L #\$EC,D[0-7]/ || u ~ /ADD.L D[0-7],D[0-7]/) has_escape_cmp = 1
    if (u ~ /ADDQ.W #1,D4/ || u ~ /ADDQ.L #\$1,D[0-7]/) has_escape_inc = 1
    if (u ~ /MOVE.L D4,D0/ || u ~ /MOVE.L D[0-7],D0/) has_return_move = 1
    if (u ~ /^MOVEM.L \(A7\)\+,D[0-7]/) has_restore = 1
    if (u == "RTS") has_rts = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_LOOP=" has_loop
    print "HAS_LOAD=" has_load
    print "HAS_ESCAPE_CMP=" has_escape_cmp
    print "HAS_ESCAPE_INC=" has_escape_inc
    print "HAS_RETURN_MOVE=" has_return_move
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
