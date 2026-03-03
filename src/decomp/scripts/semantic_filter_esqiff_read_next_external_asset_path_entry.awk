BEGIN {
    has_entry = 0
    has_link = 0
    has_grid_service = 0
    has_logo_index_store = 0
    has_gads_index_store = 0
    has_comma_flag = 0
    has_process_comma = 0
    has_terminate = 0
    has_unlk = 0
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

    if (uline ~ /^ESQIFF_READNEXTEXTERNALASSETPATHENTRY:/) has_entry = 1
    if (uline ~ /^LINK\.W A5,#-16$/) has_link = 1
    if (uline ~ /ESQDISP_PROCESSGRIDMESSAGESIFIDLE/) has_grid_service = 1
    if (uline ~ /^MOVE\.W D6,ESQIFF_LOGOLISTLINEINDEX$/) has_logo_index_store = 1
    if (uline ~ /^MOVE\.W D6,ESQIFF_GADSLISTLINEINDEX$/) has_gads_index_store = 1
    if (uline ~ /^MOVE\.W #1,ESQIFF_EXTERNALASSETPATHCOMMAFLAG$/) has_comma_flag = 1
    if (uline ~ /^MOVEQ #44,D0$/) has_process_comma = 1
    if (uline ~ /^CLR\.B \(A3\)$/) has_terminate = 1
    if (uline ~ /^UNLK A5$/) has_unlk = 1
    if (uline ~ /^RTS$/) has_rts = 1
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
