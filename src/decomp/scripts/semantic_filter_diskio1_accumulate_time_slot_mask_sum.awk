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
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)

    if (uline ~ /^DISKIO1_ACCUMULATETIMESLOTMASKSUM:/) has_entry = 1
    if (uline ~ /^CMP\.L D0,D6$/) has_cmp = 1
    if (uline ~ /^MOVE\.B 28\(A3,D6\.L\),D0$/) has_load = 1
    if (uline ~ /^ADD\.L D0,D5$/) has_add = 1
    if (uline ~ /^ADDQ\.L #1,D6$/) has_inc = 1
    if (uline ~ /^BRA\.[SW] DISKIO1_ACCUMULATETIMESLOTMASKSUM$/) has_loop = 1
    if (uline ~ /^BGE\.[SW] DISKIO1_APPENDTIMESLOTMASKNONEIFALLBITSSET$/ || uline ~ /^JMP DISKIO1_APPENDTIMESLOTMASKNONEIFALLBITSSET$/) has_exit = 1
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
