BEGIN {
    has_topaz = 0
    has_desired_mem = 0
    has_close = 0
    has_forbid = 0
    has_alloc = 0
    has_free = 0
    has_permit = 0
    has_open = 0
    has_const_1 = 0
    has_terminal = 0
}

function trim(s,    t) {
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
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (n ~ /GLOBALHANDLETOPAZFONT/) has_topaz = 1
    if (n ~ /DESIREDMEMORYAVAILABILITY/) has_desired_mem = 1
    if (n ~ /LVOCLOSEFONT/) has_close = 1
    if (n ~ /LVOFORBID/) has_forbid = 1
    if (n ~ /LVOALLOCMEM/) has_alloc = 1
    if (n ~ /LVOFREEMEM/) has_free = 1
    if (n ~ /LVOPERMIT/) has_permit = 1
    if (n ~ /LVOOPENDISKFONT/) has_open = 1
    if (u ~ /[^0-9]1[^0-9]/ || u ~ /^1$/) has_const_1 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_TOPAZ=" has_topaz
    print "HAS_DESIRED_MEM=" has_desired_mem
    print "HAS_CLOSE=" has_close
    print "HAS_FORBID=" has_forbid
    print "HAS_ALLOC=" has_alloc
    print "HAS_FREE=" has_free
    print "HAS_PERMIT=" has_permit
    print "HAS_OPEN=" has_open
    print "HAS_CONST_1=" has_const_1
    print "HAS_TERMINAL=" has_terminal
}
