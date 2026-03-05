BEGIN {
    has_entry = 0
    has_selected = 0
    has_fallback = 0
    has_cmp_100 = 0
    has_return = 0
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
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^SCRIPT_GETBANNERCHARORFALLBACK:/ || u ~ /^SCRIPT_GETBANNERCHARORFALLBAC[A-Z0-9_]*:/) has_entry = 1
    if (n ~ /TEXTDISPBANNERCHARSELECTED/ || n ~ /TEXTDISPBANNERCHARSELECTE/) has_selected = 1
    if (n ~ /TEXTDISPBANNERCHARFALLBACK/ || n ~ /TEXTDISPBANNERCHARFALLBAC/) has_fallback = 1
    if (u ~ /#100/ || u ~ /[^0-9]100[^0-9]/ || u ~ /\$64/) has_cmp_100 = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SELECTED=" has_selected
    print "HAS_FALLBACK=" has_fallback
    print "HAS_CMP_100=" has_cmp_100
    print "HAS_RETURN=" has_return
}
