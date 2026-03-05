BEGIN {
    has_entry = 0
    has_inc = 0
    has_transfer = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    line = trim($0)
    if (line == "") next

    if (ENTRY_PREFIX != "" && index(line, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(line, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (line ~ /^ADDQ\.B #\$?1,D[0-7]$/) has_inc = 1
    if (TARGET_PREFIX != "" && line ~ /^(BSR|BRA|JMP)(\.[A-Z]+)? / && index(line, TARGET_PREFIX) > 0) has_transfer = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_INC=" has_inc
    print "HAS_TRANSFER=" has_transfer
}
