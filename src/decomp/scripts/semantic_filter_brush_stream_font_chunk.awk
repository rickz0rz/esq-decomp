BEGIN {
    label = 0
    has_state_store = 0
    has_read_call = 0
    has_chunk_2048 = 0
    has_remaining_update = 0
    has_fail_minus1 = 0
    has_return = 0
}

/^BRUSH_StreamFontChunk:$/ { label = 1 }

{
    line = toupper($0)

    if (line ~ /186\(/ || line ~ /\(186,/ || line ~ /#\$BA/ || line ~ /#186/) has_state_store = 1
    if (line ~ /LVOREAD/) has_read_call = 1
    if (line ~ /#2048|#\$800/) has_chunk_2048 = 1
    if (line ~ /SUBI\.L[[:space:]]*#2048/ || line ~ /ADDA\.W[[:space:]]*#2048/ || line ~ /ADD\.L[[:space:]]*#2048/ || line ~ /ADD\.L[[:space:]]*#-2048/) has_remaining_update = 1
    if (line ~ /MOVEQ[[:space:]]*#-1,D0/) has_fail_minus1 = 1
    if (line ~ /^RTS$/) has_return = 1
}

END {
    if (label) print "HAS_LABEL"
    if (has_state_store) print "HAS_STATE_STORE_OFFSET_186"
    if (has_read_call) print "HAS_READ_CALL"
    if (has_chunk_2048) print "HAS_CHUNK_2048"
    if (has_remaining_update) print "HAS_REMAINING_UPDATES"
    if (has_fail_minus1) print "HAS_FAIL_MINUS1"
    if (has_return) print "HAS_RTS"
}
