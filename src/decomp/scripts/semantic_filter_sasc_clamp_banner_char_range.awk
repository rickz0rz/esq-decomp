BEGIN {
    has_entry = 0
    has_rts = 0
    has_consts = 0
    has_wrap48 = 0
    has_store_start = 0
    has_store_end = 0
    has_call = 0
}

function up(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = up($0)
    if (l == "") next

    if (ENTRY != "" && l == toupper(ENTRY) ":") has_entry = 1
    if (l == "RTS") has_rts = 1

    if ((l ~ /#65/ || l ~ /#\$41/) && (l ~ /#67/ || l ~ /#\$43/) && (l ~ /#69/ || l ~ /#\$45/) && (l ~ /#73/ || l ~ /#\$49/)) has_consts = 1
    if ((l ~ /#48/ || l ~ /#\$30/) && (l ~ /^ADD\.W / || l ~ /^SUB\.W / || l ~ /^CMP\.W /)) has_wrap48 = 1
    if (index(l, "WDISP_BANNERCHARRANGESTART") > 0) has_store_start = 1
    if (index(l, "WDISP_BANNERCHARRANGEEND") > 0) has_store_end = 1

    if (l ~ /^(JMP|JSR|BSR)(\.[A-Z]+)? /) {
        if (index(l, "_XCOVF") == 0) has_call = 1
    }
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_RTS=" has_rts
    print "HAS_CONSTS=" has_consts
    print "HAS_WRAP48=" has_wrap48
    print "HAS_STORE_START=" has_store_start
    print "HAS_STORE_END=" has_store_end
    print "HAS_CALL=" has_call
}
