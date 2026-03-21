function norm(s, t) {
    t = toupper(s)
    sub(/;.*/, "", t)
    gsub(/^[ \t]+|[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return t
}

{
    line = norm($0)
    if (line == "") next

    if (line ~ /^LOCAVAIL_COMPUTEFILTEROFFSETFORENTRY:/ || line ~ /^LOCAVAIL_COMPUTEFILTEROFFSETFORE[A-Z0-9_]*:/) has_entry = 1
    if (line ~ /LOCAVAIL_MAPFILTERTOKENCHARTOCLA/) has_map_class = 1
    if (line ~ /LOCAVAIL_FILTERSTEP/) has_filter_step = 1
    if (line ~ /LOCAVAIL_FILTERPREVCLASSID/) has_prev_class = 1
    if (line ~ /GROUP_AS_JMPTBL_STR_FINDCHARPTR/ || line ~ /STR_FINDCHARPTR/) has_find_char = 1
    if (line ~ /SCRIPT_READHANDSHAKEBIT5MASK/ || line ~ /READCIABBIT5MASK/) has_handshake = 1
    if (line ~ /ED_DIAGGRAPHMODECHAR/ || line ~ /ESQIFF_GADSBRUSHLISTCOUNT/) has_graph_gate = 1
    if (line ~ /WDISP_HIGHLIGHTACTIVE/) has_highlight_gate = 1
    if (line ~ /SELECTEDNODE/ || line ~ /SELECTEDPAYLOAD/ || line ~ /8\(A[0-6]\)/ || line ~ /12\(A[0-6]\)/) has_result_store = 1
    if (line == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MAP_CLASS=" has_map_class
    print "HAS_FILTER_STEP=" has_filter_step
    print "HAS_PREV_CLASS=" has_prev_class
    print "HAS_FIND_CHAR=" has_find_char
    print "HAS_HANDSHAKE=" has_handshake
    print "HAS_GRAPH_GATE=" has_graph_gate
    print "HAS_HIGHLIGHT_GATE=" has_highlight_gate
    print "HAS_RESULT_STORE=" has_result_store
    print "HAS_RETURN=" has_return
}
