BEGIN {
    has_entry = 0
    has_null_guard = 0
    has_mode_3 = 0
    has_neg1_long = 0
    has_neg1_word = 0
    has_clear_byte = 0
    has_return = 0
}

function trim(s, t) {
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

    if (u ~ /^TEXTDISP_RESETSELECTIONSTATE:/ || u ~ /^TEXTDISP_RESETSELECTIONSTA[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /BEQ/ || u ~ /TST\.L/ || u ~ /MOVE\.L A[0-7],D0/) has_null_guard = 1
    if (u ~ /#3/ || index(u, "#$3") > 0) has_mode_3 = 1
    if (u ~ /#-1/ || index(u, "#$FFFFFFFF") > 0) has_neg1_long = 1
    if (u ~ /MOVE\.W #\(-1\)/ || u ~ /MOVE\.W #\$FFFF/) has_neg1_word = 1
    if (u ~ /CLR\.B/ || (u ~ /MOVE\.B/ && (u ~ /#0/ || index(u, "#$0") > 0))) has_clear_byte = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_NULL_GUARD=" has_null_guard
    print "HAS_MODE_3=" has_mode_3
    print "HAS_NEG1_LONG=" has_neg1_long
    print "HAS_NEG1_WORD=" has_neg1_word
    print "HAS_CLEAR_BYTE=" has_clear_byte
    print "HAS_RETURN=" has_return
}
