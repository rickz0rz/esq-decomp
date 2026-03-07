BEGIN {
    has_entry=0
    has_link=0
    has_grid_service=0
    has_logo_index_store=0
    has_gads_index_store=0
    has_comma_flag=0
    has_process_comma=0
    has_terminate=0
    has_unlk=0
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
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^ESQIFF_READNEXTEXTERNALASSETPATHENTRY:/ || u ~ /^ESQIFF_READNEXTEXTERNALASSETPATHENTR[A-Z0-9_]*:/ || u ~ /^ESQIFF_READNEXTEXTERNALASSETPATH[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^LINK\.W A5,#-16$/ || n ~ /LINKWA516/ || n ~ /SUBQW8A7/) has_link = 1
    if (n ~ /ESQDISPPROCESSGRIDMESSAGESIFIDLE/ || n ~ /ESQDISPPROCESSGRIDMESSAGESIFIDL/) has_grid_service = 1
    if (n ~ /MOVEWD6ESQIFFLOGOLISTLINEINDEX/ || n ~ /ESQIFFLOGOLISTLINEINDEX/) has_logo_index_store = 1
    if (n ~ /MOVEWD6ESQIFFGADSLISTLINEINDEX/ || n ~ /ESQIFFGADSLISTLINEINDEX/) has_gads_index_store = 1
    if (n ~ /MOVEW1ESQIFFEXTERNALASSETPATHCOMMAFLAG/ || n ~ /MOVEW1ESQIFFEXTERNALASSETPATHCOMM/ || n ~ /ESQIFFEXTERNALASSETPATHCOMMAFLA/) has_comma_flag = 1
    if (u ~ /MOVEQ #44,D0/ || u ~ /#\$2C/ || n ~ /CMPBD0D5/) has_process_comma = 1
    if (u ~ /^CLR\.B \(A3\)$/ || u ~ /^CLR\.B \(A5\)$/ || n ~ /CLRB\(A3\)/ || n ~ /CLRB\(A5\)/) has_terminate = 1
    if (u ~ /^UNLK A5$/ || n ~ /UNLKA5/ || n ~ /ADDQW8A7/) has_unlk = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LINK=" has_link
    print "HAS_GRID_SERVICE=" has_grid_service
    print "HAS_LOGO_INDEX_STORE=" has_logo_index_store
    print "HAS_GADS_INDEX_STORE=" has_gads_index_store
    print "HAS_COMMA_FLAG=" has_comma_flag
    print "HAS_PROCESS_COMMA=" has_process_comma
    print "HAS_TERMINATE=" has_terminate
    print "HAS_UNLK=" has_unlk
    print "HAS_RTS=" has_rts
}
