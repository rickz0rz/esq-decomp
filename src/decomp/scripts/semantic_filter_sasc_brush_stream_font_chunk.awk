BEGIN {
    has_entry = 0
    has_state_store = 0
    has_read_call = 0
    has_chunk_2048 = 0
    has_remaining_update = 0
    has_fail_minus1 = 0
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

    if (ENTRY != "" && u == toupper(ENTRY) ":") has_entry = 1
    if (ENTRY_REGEX != "" && u ~ toupper(ENTRY_REGEX)) has_entry = 1

    if (u ~ /186\(/ || u ~ /\(186,/ || u ~ /#\$BA/ || u ~ /#186/ || u ~ /\$BA\([AD][0-7]\)/) has_state_store = 1
    if (u ~ /LVOREAD/ || u ~ /_LVOREAD/) has_read_call = 1
    if (u ~ /#2048|#\$800|\(\$800\)\.W/) has_chunk_2048 = 1
    if (u ~ /SUBI\.L[[:space:]]*#2048/ || u ~ /SUBI\.L[[:space:]]*#\$800/ || u ~ /ADDA\.[WL][[:space:]]*#2048/ || u ~ /ADDA\.[WL][[:space:]]*#\$800/ || u ~ /ADD\.L[[:space:]]*#2048/ || u ~ /ADD\.L[[:space:]]*#\$800/ || u ~ /ADD\.L[[:space:]]*#-2048/ || u ~ /SUB\.L #\$800/) has_remaining_update = 1
    if (u ~ /MOVEQ[[:space:]]*#-1,D0/ || u ~ /MOVEQ(\.L)? #\$FFFFFFFF,D0/ || u ~ /MOVEQ(\.L)? #\$FF,D0/) has_fail_minus1 = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_STATE_STORE_OFFSET_186=" has_state_store
    print "HAS_READ_CALL=" has_read_call
    print "HAS_CHUNK_2048=" has_chunk_2048
    print "HAS_REMAINING_UPDATES=" has_remaining_update
    print "HAS_FAIL_MINUS1=" has_fail_minus1
    print "HAS_RTS=" has_rts
}
