BEGIN {
    has_entry = 0
    has_write_mode = 0
    has_write_flag = 0
    has_reset = 0
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

    if (u ~ /^SCRIPT_SETCTRLCONTEXTMODE:/) has_entry = 1
    if (u ~ /MOVE\.W .*\(A3\)/ || u ~ /MOVE\.W .*\(A0\)/) has_write_mode = 1
    if (u ~ /#1,2\(A3\)/ || u ~ /#1,2\(A0\)/ || u ~ /#\$1,\$2\(A3\)/ || u ~ /#\$1,\$2\(A0\)/ || index(u, "#$1,(A0)") > 0 || index(u, "#$1,(A3)") > 0) has_write_flag = 1
    if (index(u, "SCRIPT_RESETCTRLCONTEXT") > 0 || index(u, "SCRIPT_RESETCTRLCONTEX") > 0) has_reset = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_WRITE_MODE=" has_write_mode
    print "HAS_WRITE_FLAG=" has_write_flag
    print "HAS_RESET=" has_reset
    print "HAS_RETURN=" has_return
}
