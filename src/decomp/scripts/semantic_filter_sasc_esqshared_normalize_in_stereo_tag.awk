BEGIN {
    has_entry = 0
    has_find_substring = 0
    has_marker_write = 0
    has_flag_gate = 0
    has_class_trim_loop = 0
    has_skip_class3_call = 0
    has_copy_mem = 0
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

    if (u ~ /^ESQSHARED_NORMALIZEINSTEREOTAG:/ || u ~ /^ESQSHARED_NORMALIZEINSTEREOT[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "FINDSUBSTRINGCASEFOLD") > 0 || index(u, "FINDSUBSTRINGCASE") > 0 || index(u, "FINDSUBSTRIN") > 0) has_find_substring = 1
    if (u ~ /^MOVE\.B #\$91,\(A[0-7]\)$/ || u ~ /^MOVE\.B #145,\(A[0-7]\)$/) has_marker_write = 1
    if (u ~ /^BTST #\$7,D[0-7]$/ || u ~ /^BTST #7,D[0-7]$/) has_flag_gate = 1
    if (index(u, "WDISP_CHARCLASSTABLE") > 0 || u ~ /^BTST #\$3,\(A[0-7]\)$/ || u ~ /^BTST #3,\(A[0-7]\)$/) has_class_trim_loop = 1
    if (index(u, "SKIPCLASS3CHARS") > 0 || index(u, "SKIPCLASS3") > 0) has_skip_class3_call = 1
    if (index(u, "COPYMEM") > 0) has_copy_mem = 1
    if (u ~ /^BRA\.[SWB] ESQSHARED_NORMALIZEINSTEREOTAG_RETURN$/ || u ~ /^BEQ\.[SWB] ESQSHARED_NORMALIZEINSTEREOTAG_RETURN$/ || u ~ /^JMP ESQSHARED_NORMALIZEINSTEREOTAG_RETURN$/ || u ~ /^BEQ\.[SWB] ___ESQSHARED_NORMALIZEINSTEREOT/ || u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FIND_SUBSTRING=" has_find_substring
    print "HAS_MARKER_WRITE=" has_marker_write
    print "HAS_FLAG_GATE=" has_flag_gate
    print "HAS_CLASS_TRIM_LOOP=" has_class_trim_loop
    print "HAS_SKIP_CLASS3_CALL=" has_skip_class3_call
    print "HAS_COPY_MEM=" has_copy_mem
    print "HAS_RETURN=" has_return
}
