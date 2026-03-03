BEGIN {
    has_entry = 0
    has_pea = 0
    has_call = 0
    has_stack_fix = 0
    has_rts = 0
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

    if (uline ~ /^ESQDISP_REFRESHSTATUSINDICATORSFROMCURRENTMASK:/) has_entry = 1
    if (uline ~ /PEA -1\.W/) has_pea = 1
    if (uline ~ /ESQDISP_APPLYSTATUSMASKTOINDICATORS/) has_call = 1
    if (uline ~ /ADDQ\.W #4,A7/) has_stack_fix = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PEA=" has_pea
    print "HAS_CALL=" has_call
    print "HAS_STACK_FIX=" has_stack_fix
    print "HAS_RTS=" has_rts
}
