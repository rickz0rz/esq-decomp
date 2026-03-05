BEGIN {
    has_entry = 0
    has_context = 0
    has_set_mode = 0
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

    if (u ~ /^SCRIPT_INITCTRLCONTEXT:/) has_entry = 1
    if (index(u, "SCRIPT_CTRL_CONTEXT") > 0) has_context = 1
    if (index(u, "SCRIPT_SETCTRLCONTEXTMODE") > 0 || index(u, "SCRIPT_SETCTRLCONTEXTM") > 0) has_set_mode = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CONTEXT=" has_context
    print "HAS_SET_MODE=" has_set_mode
    print "HAS_RETURN=" has_return
}
