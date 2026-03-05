BEGIN {
    has_entry = 0
    has_cmp = 0
    has_load = 0
    has_add = 0
    has_inc = 0
    has_loop = 0
    has_exit = 0
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

    if (line ~ /^CMP\.L /) has_cmp = 1
    if (line ~ /^MOVE\.B /) has_load = 1
    if (line ~ /^ADD\.L /) has_add = 1
    if (line ~ /^ADDQ\.L #\$?1,/) has_inc = 1
    if (line ~ /^BRA\.[A-Z]+ /) has_loop = 1
    if (TARGET_PREFIX != "" && line ~ /^(BGE|BCC|BSR|JMP)(\.[A-Z]+)? / && index(line, TARGET_PREFIX) > 0) has_exit = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CMP=" has_cmp
    print "HAS_LOAD=" has_load
    print "HAS_ADD=" has_add
    print "HAS_INC=" has_inc
    print "HAS_LOOP=" has_loop
    print "HAS_EXIT=" has_exit
}
