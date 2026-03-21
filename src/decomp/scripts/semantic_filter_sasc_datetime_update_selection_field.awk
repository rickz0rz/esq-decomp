BEGIN {
    saw_null_guard = 0
    saw_build_from_globals = 0
    saw_classify_call = 0
    saw_selection_read = 0
    saw_selection_write = 0
    saw_changed_true = 0
    saw_return = 0
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

    if (u ~ /MOVEA?\.L 8\(A5\),A3/ || u ~ /MOVE\.L A[35],D0/ || u ~ /TST\.L .*A[0-7]/ || u ~ /CMP\.L #0,/) saw_null_guard = 1
    if (u ~ /DATETIME_BUILDFROMGLOBALS/) saw_build_from_globals = 1
    if (u ~ /DATETIME_CLASSIFYVALUEINRANGE/) saw_classify_call = 1
    if (u ~ /16\(A3\)/ || u ~ /MOVE\.W \(A0\),D1/) saw_selection_read = 1
    if (u ~ /MOVE\.W .*16\(A3\)/ || u ~ /MOVE\.W D0,\(A0\)/) saw_selection_write = 1
    if (u ~ /MOVEQ(\.L)? #(\$)?1,D[056]/ || u ~ /MOVE\.L #(\$)?1,/) saw_changed_true = 1
    if (u ~ /^RTS$/) saw_return = 1
}

END {
    print "HAS_NULL_GUARD=" saw_null_guard
    print "HAS_BUILD_FROM_GLOBALS=" saw_build_from_globals
    print "HAS_CLASSIFY_CALL=" saw_classify_call
    print "HAS_SELECTION_READ=" saw_selection_read
    print "HAS_SELECTION_WRITE=" saw_selection_write
    print "HAS_CHANGED_TRUE=" saw_changed_true
    print "HAS_RTS=" saw_return
}
