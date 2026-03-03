BEGIN {
    has_entry = 0
    has_gate = 0
    has_call = 0
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
    uline = toupper(line)

    if (uline ~ /^ESQFUNC_SERVICEUITICKIFRUNNING:/) has_entry = 1
    if (uline ~ /^TST\.W ESQ_MAINLOOPUITICKENABLEDFLAG$/) has_gate = 1
    if (uline ~ /^BSR\.W ESQFUNC_PROCESSUIFRAMETICK$/) has_call = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_GATE=" has_gate
    print "HAS_CALL=" has_call
    print "HAS_RETURN=" has_return
}
