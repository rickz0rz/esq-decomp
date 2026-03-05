BEGIN {
    has_entry = 0
    has_store_shadow = 0
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

    if (ENTRY != "" && uline == toupper(ENTRY) ":") has_entry = 1
    if (ENTRY_REGEX != "" && uline ~ toupper(ENTRY_REGEX)) has_entry = 1
    if (uline ~ /ESQ_BANNERCHARINDEXSHADOW2273/) has_store_shadow = 1
    if (uline == "RTS") has_rts = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_STORE_SHADOW=" has_store_shadow
    print "HAS_RTS=" has_rts
}
