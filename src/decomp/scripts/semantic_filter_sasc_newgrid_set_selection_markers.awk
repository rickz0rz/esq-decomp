BEGIN {
    has_entry=0
    has_primary_8081=0
    has_primary_8283=0
    has_primary_clear=0
    has_secondary_8889=0
    has_secondary_8a8b=0
    has_secondary_clear=0
    has_rts=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)

    if (u ~ /^NEWGRID_SETSELECTIONMARKERS:/ || u ~ /^NEWGRID_SETSELECTIONMAR[A-Z0-9_]*:/) has_entry=1
    if (u ~ /#\$80/ || u ~ /#128([^0-9]|$)/) has_primary_8081=1
    if (u ~ /#\$81/ || u ~ /#129([^0-9]|$)/) has_primary_8081=1
    if (u ~ /#\$82/ || u ~ /#130([^0-9]|$)/) has_primary_8283=1
    if (u ~ /#\$83/ || u ~ /#131([^0-9]|$)/) has_primary_8283=1
    if (u ~ /^CLR\.B \(A5\)$/ || u ~ /^CLR\.B \(A3\)$/ || u ~ /^MOVE\.B D0,\(A3\)$/ || u ~ /^MOVE\.B D0,\(A2\)$/) has_primary_clear=1
    if (u ~ /#\$88/ || u ~ /#136([^0-9]|$)/) has_secondary_8889=1
    if (u ~ /#\$89/ || u ~ /#137([^0-9]|$)/) has_secondary_8889=1
    if (u ~ /#\$8A/ || u ~ /#138([^0-9]|$)/) has_secondary_8a8b=1
    if (u ~ /#\$8B/ || u ~ /#139([^0-9]|$)/) has_secondary_8a8b=1
    if (u ~ /^CLR\.B \(A2\)$/ || u ~ /^CLR\.B \(A0\)$/ || u ~ /^MOVE\.B D0,\(A0\)$/) has_secondary_clear=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_PRIMARY_8081="has_primary_8081
    print "HAS_PRIMARY_8283="has_primary_8283
    print "HAS_PRIMARY_CLEAR="has_primary_clear
    print "HAS_SECONDARY_8889="has_secondary_8889
    print "HAS_SECONDARY_8A8B="has_secondary_8a8b
    print "HAS_SECONDARY_CLEAR="has_secondary_clear
    print "HAS_RTS="has_rts
}
