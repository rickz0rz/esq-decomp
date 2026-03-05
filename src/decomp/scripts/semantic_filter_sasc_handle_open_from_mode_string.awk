BEGIN {
    has_label = 0
    has_finalize_call = 0
    has_open_call = 0
    has_default_flags = 0
    has_plus_check = 0
    has_mode_a = 0
    has_mode_r = 0
    has_mode_w = 0
    has_init_fields = 0
    has_openflags_build = 0
    has_return_node = 0
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

    if (u ~ /^HANDLE_OPENFROMMODESTRING:/) has_label = 1
    if (u ~ /UNKNOWN36_FINALIZEREQUEST/) has_finalize_call = 1
    if (u ~ /HANDLE_OPENENTRYWITHFLAGS/) has_open_call = 1
    if (u ~ /GLOBAL_DEFAULTHANDLEFLAGS/ || u ~ /#\$?8000/) has_default_flags = 1
    if (u ~ /#\$?2B/ || u ~ /SEQ D[0-7]/ || u ~ /NEG\.B D[0-7]/ || u ~ /EXT\.(W|L) D[0-7]/) has_plus_check = 1

    if (u ~ /#\$?61/ || u ~ /\'A\'/) has_mode_a = 1
    if (u ~ /#\$?72/ || u ~ /\'R\'/) has_mode_r = 1
    if (u ~ /#\$?77/ || u ~ /\'W\'/) has_mode_w = 1

    if (u ~ /BUFFERBASE|BUFFERCURSOR|READREMAINING|WRITEREMAINING|BUFFERCAPACITY|HANDLEINDEX|OPENFLAGS/) has_init_fields = 1
    if (u ~ /\$(8|C|10|14|18|1C|20)\(A[0-7]\)/) has_init_fields = 1

    if (u ~ /#\$?4000/ || u ~ /#\$?8102/ || u ~ /#\$?8000/ || u ~ /#\$?100/ || u ~ /#\$?200/ || u ~ /^OR(\.L|I\.W|I\.L)? /) has_openflags_build = 1
    if (u ~ /^MOVE\.L A[0-7],D0$/ || u ~ /^MOVEA?\.L A[0-7],D0$/) has_return_node = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_FINALIZE_CALL=" has_finalize_call
    print "HAS_OPEN_CALL=" has_open_call
    print "HAS_DEFAULT_FLAGS=" has_default_flags
    print "HAS_PLUS_CHECK=" has_plus_check
    print "HAS_MODE_A=" has_mode_a
    print "HAS_MODE_R=" has_mode_r
    print "HAS_MODE_W=" has_mode_w
    print "HAS_INIT_FIELDS=" has_init_fields
    print "HAS_OPENFLAGS_BUILD=" has_openflags_build
    print "HAS_RETURN_NODE=" has_return_node
    print "HAS_RTS=" has_rts
}
