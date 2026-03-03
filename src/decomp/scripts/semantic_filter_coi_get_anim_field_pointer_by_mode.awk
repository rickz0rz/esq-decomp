BEGIN {
    has_label = 0
    has_link = 0
    has_save = 0
    has_null_guard = 0
    has_scan_loop = 0
    has_switch = 0
    has_table = 0
    has_case0 = 0
    has_case7 = 0
    has_default = 0
    has_return_branch = 0
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

    if (uline ~ /^COI_GETANIMFIELDPOINTERBYMODE:/) has_label = 1
    if (index(uline, "LINK.W A5,#-20") > 0) has_link = 1
    if (index(uline, "MOVEM.L D4-D7/A3,-(A7)") > 0) has_save = 1
    if (index(uline, "COI_GETANIMFIELDPOINTERBYMODE_RETURN") > 0) has_null_guard = 1
    if (uline ~ /^\.LAB_034A:/) has_scan_loop = 1
    if (index(uline, "JMP .LAB_034D+2(PC,D0.W)") > 0) has_switch = 1
    if (uline ~ /^\.LAB_034D:/) has_table = 1
    if (uline ~ /^\.LAB_034D_000E:/) has_case0 = 1
    if (uline ~ /^\.LAB_034D_00B8:/) has_case7 = 1
    if (uline ~ /^\.LAB_0355:/) has_default = 1
    if (index(uline, "BRA.W COI_GETANIMFIELDPOINTERBYMODE_RETURN") > 0) has_return_branch = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SAVE=" has_save
    print "HAS_NULL_GUARD=" has_null_guard
    print "HAS_SCAN_LOOP=" has_scan_loop
    print "HAS_SWITCH=" has_switch
    print "HAS_TABLE=" has_table
    print "HAS_CASE0=" has_case0
    print "HAS_CASE7=" has_case7
    print "HAS_DEFAULT=" has_default
    print "HAS_RETURN_BRANCH=" has_return_branch
}
