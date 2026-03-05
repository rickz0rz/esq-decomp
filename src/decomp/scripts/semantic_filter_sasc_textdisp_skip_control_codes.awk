BEGIN {
    has_entry = 0
    has_null_guard = 0
    has_prefix_40 = 0
    has_charclass = 0
    has_btst3 = 0
    has_inc = 0
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

    if (u ~ /^TEXTDISP_SKIPCONTROLCODES:/ || u ~ /^TEXTDISP_SKIPCONTROLCOD[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /TST\.L/ || u ~ /CMP\.L/ || u ~ /MOVE\.L A[0-7],D0/) has_null_guard = 1
    if (u ~ /#40/ || index(u, "#$28") > 0) has_prefix_40 = 1
    if (index(u, "WDISP_CHARCLASSTABLE") > 0) has_charclass = 1
    if (index(u, "BTST #3") > 0 || index(u, "BTST #$3") > 0) has_btst3 = 1
    if (u ~ /ADDQ\.L #1/ || index(u, "ADDQ.L #$1") > 0) has_inc = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_NULL_GUARD=" has_null_guard
    print "HAS_PREFIX_40=" has_prefix_40
    print "HAS_CHARCLASS=" has_charclass
    print "HAS_BTST3=" has_btst3
    print "HAS_INC=" has_inc
    print "HAS_RETURN=" has_return
}
