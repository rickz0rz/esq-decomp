BEGIN {
    has_entry = 0
    has_jmp = 0
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
    if (uline ~ /^ESQFUNC_JMPTBL_TEXTDISP_TICKDISPLAYSTATE:/) has_entry = 1
    if (uline ~ /JMP TEXTDISP_TICKDISPLAYSTATE/) has_jmp = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_JMP=" has_jmp
}
