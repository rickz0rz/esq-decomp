BEGIN {
    has_label = 0
    has_write_call = 0
    has_close_all_call = 0
    has_next_traversal = 0
    has_state_gates = 0
    has_pending_calc = 0
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

    if (u ~ /^BUFFER_FLUSHALLANDCLOSEWITHCODE:/) has_label = 1
    if (u ~ /DOS_WRITEBYINDEX/) has_write_call = 1
    if (u ~ /HANDLE_CLOSEALLANDRETURNWITHCODE/) has_close_all_call = 1
    if (u ~ /STRUCT_PREALLOCHANDLENODE__NEXT/ || u ~ /\$(20|32|1C)\((A[0-7]|A0)\)/ || u ~ /^MOVEA?\.L \(A[0-7]\),A[0-7]$/ || u ~ /^MOVE\.L \$1C\(A[0-7]\),A[0-7]$/) has_next_traversal = 1
    if (u ~ /STATEFLAGS/ || u ~ /^BTST #/ || u ~ /^AND\.B #\$?6,/ || u ~ /^CMP\.B #\$?2,/) has_state_gates = 1
    if (u ~ /BUFFERCURSOR|BUFFERBASE|HANDLEINDEX/ || u ~ /^\$?4\((A[0-7]|A0)\)/ || u ~ /^\$?14\((A[0-7]|A0)\)/ || u ~ /SUB\.L .*D[0-7]/) has_pending_calc = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_WRITE_CALL=" has_write_call
    print "HAS_CLOSE_ALL_CALL=" has_close_all_call
    print "HAS_NEXT_TRAVERSAL=" has_next_traversal
    print "HAS_STATE_GATES=" has_state_gates
    print "HAS_PENDING_CALC=" has_pending_calc
    print "HAS_RTS=" has_rts
}
