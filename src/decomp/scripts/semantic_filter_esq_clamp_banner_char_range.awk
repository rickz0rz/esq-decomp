BEGIN {
    has_65 = 0
    has_67 = 0
    has_69 = 0
    has_73 = 0
    has_48 = 0
    has_sub1_guard = 0
    has_wrap_add = 0
    has_wrap_sub = 0
    has_store_start = 0
    has_store_end = 0
    has_rts = 0
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

    if (u ~ /#65,D[0-7]/ || u ~ /#\$?41,D[0-7]/ || u ~ /#-65,D[0-7]/) has_65 = 1
    if (u ~ /#67,D[0-7]/ || u ~ /#\$?43,D[0-7]/ || u ~ /#1,D[0-7]/) has_67 = 1
    if (u ~ /#69,D[0-7]/ || u ~ /#\$?45,D[0-7]/) has_69 = 1
    if (u ~ /#73,D[0-7]/ || u ~ /#\$?49,D[0-7]/ || u ~ /#8,D[0-7]/) has_73 = 1
    if (u ~ /#48,D[0-7]/ || u ~ /#\$?30,D[0-7]/) has_48 = 1

    if (u ~ /#1,D[0-7]/ || u ~ /CMPI?\.[BWL] #1,D[0-7]/) has_sub1_guard = 1
    if (u ~ /ADD\.[BWL] D[0-7],D[0-7]/ || u ~ /ADDI?\.[BWL] #48,D[0-7]/ || u ~ /ADDQ\.[BWL] #1,D[0-7]/) has_wrap_add = 1
    if (u ~ /SUB\.[BWL] D[0-7],D[0-7]/ || u ~ /SUBI?\.[BWL] #48,D[0-7]/) has_wrap_sub = 1

    if (u ~ /WDISP_BANNERCHARRANGESTART/) has_store_start = 1
    if (u ~ /WDISP_BANNERCHARRANGEEND/) has_store_end = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_65=" has_65
    print "HAS_67=" has_67
    print "HAS_69=" has_69
    print "HAS_73=" has_73
    print "HAS_48=" has_48
    print "HAS_SUB1_GUARD=" has_sub1_guard
    print "HAS_WRAP_ADD=" has_wrap_add
    print "HAS_WRAP_SUB=" has_wrap_sub
    print "HAS_STORE_START=" has_store_start
    print "HAS_STORE_END=" has_store_end
    print "HAS_RTS=" has_rts
}
