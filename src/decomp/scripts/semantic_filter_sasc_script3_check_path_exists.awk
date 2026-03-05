BEGIN {
    has_entry = 0
    has_lock = 0
    has_unlock = 0
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

    if (u ~ /^SCRIPT_CHECKPATHEXISTS:/) has_entry = 1
    if (index(u, "_LVOLOCK") > 0) has_lock = 1
    if (index(u, "_LVOUNLOCK") > 0) has_unlock = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOCK=" has_lock
    print "HAS_UNLOCK=" has_unlock
    print "HAS_RETURN=" has_return
}
