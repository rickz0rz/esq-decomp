BEGIN {
    has_entry=0
    has_call=0
    zero_immediates=0
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
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^NEWGRID2_DISPATCHOPERATIONDEFAULT:/ || u ~ /^NEWGRID2_DISPATCHOPERATIONDEFA[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRID2DISPATCHGRIDOPERATION/) has_call=1
    if (u ~ /#\$?0([^0-9A-F]|$)/ || u ~ /MOVEQ(\.L)? #\$?0,D[0-7]/ || u ~ /^CLR\.L /) zero_immediates++
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_DISPATCH_CALL="has_call
    print "ZERO_SETUP_HINT="(zero_immediates > 0 ? 1 : 0)
    print "HAS_RTS="has_rts
}
