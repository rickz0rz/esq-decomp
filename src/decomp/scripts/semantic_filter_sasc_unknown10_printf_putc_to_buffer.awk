BEGIN {
    h_entry = 0
    h_save = 0
    h_inc = 0
    h_store_char = 0
    h_store_ptr = 0
    h_restore = 0
    h_rts = 0
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

    if (u ~ /^UNKNOWN10_PRINTFPUTCTOBUFFER:$/) h_entry = 1
    if (u ~ /^MOVE\.L D7,-\(A7\)$/ || u ~ /^MOVEM\.L D7,-\(A7\)$/ || u ~ /^MOVEM\.L D7\/A5,-\(A7\)$/) h_save = 1
    if (u ~ /^ADDQ\.L #\$?1,GLOBAL_PRINTFBYTECOUNT\(A4\)$/ || u ~ /^ADD\.L #\$?1,GLOBAL_PRINTFBYTECOUNT\(A4\)$/) h_inc = 1
    if (u ~ /^MOVE\.B D0,\(A0\)\+$/ || u ~ /^MOVE\.B D[0-7],\(A0\)\+$/ || u ~ /^MOVE\.B D[0-7],\(A5\)\+$/ || u ~ /^MOVE\.B D[0-7],\(A0\)$/) h_store_char = 1
    if (u ~ /^MOVE\.L A0,GLOBAL_PRINTFBUFFERPTR\(A4\)$/ || u ~ /^MOVE\.L A5,GLOBAL_PRINTFBUFFERPTR\(A4\)$/ || u ~ /^ADDQ\.L #\$?1,GLOBAL_PRINTFBUFFERPTR\(A4\)$/ || u ~ /^ADD\.L #\$?1,GLOBAL_PRINTFBUFFERPTR\(A4\)$/) h_store_ptr = 1
    if (u ~ /^MOVE\.L \(A7\)\+,D7$/ || u ~ /^MOVEM\.L \(A7\)\+,D7$/ || u ~ /^MOVEM\.L \(A7\)\+,D7\/A5$/) h_restore = 1
    if (u ~ /^RTS$/) h_rts = 1
}

END {
    print "HAS_ENTRY=" h_entry
    print "HAS_SAVE_REG=" h_save
    print "HAS_COUNTER_INC=" h_inc
    print "HAS_STORE_CHAR=" h_store_char
    print "HAS_STORE_PTR=" h_store_ptr
    print "HAS_RESTORE_REG=" h_restore
    print "HAS_RTS=" h_rts
}
