BEGIN {
    has_entry = 0
    has_rts = 0
    has_add12 = 0
    has_cmp30 = 0
    has_double = 0
    has_lookup = 0
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

    if ((l ~ /#\$?C/ || l ~ /#12/) && (l ~ /^ADD\.W / || l ~ /^MOVEQ(\.L)? / || l ~ /^CMP\.W /)) has_add12 = 1
    if ((l ~ /#\$?1E/ || l ~ /#30/) && l ~ /^CMP\.W /) has_cmp30 = 1
    if (l ~ /^ADD\.W D[0-7],D[0-7]$/ || l ~ /^ADD\.W D[0-7],D0$/) has_double = 1
    if (index(l, "CLOCK_HALFHOURSLOTLOOKUP") > 0) has_lookup = 1

    if (l ~ /^(JMP|JSR|BSR)(\.[A-Z]+)? /) {
        if (index(l, "_XCOVF") == 0) has_call = 1
    }
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_RTS=" has_rts
    print "HAS_ADD12=" has_add12
    print "HAS_CMP30=" has_cmp30
    print "HAS_DOUBLE=" has_double
    print "HAS_LOOKUP=" has_lookup
    print "HAS_CALL=" has_call
}
