BEGIN {
    has_entry = 0
    has_raster_ref = 0
    has_template_words = 0
    has_build_block_call = 0
    has_build_row_call = 0
    has_tail_sentinel = 0
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

    if (u ~ /^GCOMMAND_COPYIMAGEDATATOBITMAP:/ || u ~ /^GCOMMAND_COPYIMAGEDATATOBIT[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "WDISP_BANNERWORKRASTERPTR") > 0) has_raster_ref = 1
    if (u ~ /^MOVE\.W #\$9306,/ || u ~ /^MOVE\.W #\$E0,/ || u ~ /^MOVE\.W #\$E2,/ || u ~ /^MOVE\.W #\$E4,/ || u ~ /^MOVE\.W #\$E6,/ || u ~ /^MOVE\.W #\$E8,/ || u ~ /^MOVE\.W #\$EA,/) has_template_words = 1
    if (index(u, "GCOMMAND_BUILDBANNERBLOCK") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) has_build_block_call = 1
    if (index(u, "GCOMMAND_BUILDBANNERROW") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) has_build_row_call = 1
    if (u ~ /^MOVE\.B #\$80,3916\(A[0-7]\)$/ || u ~ /^MOVE\.B #\$80,\$F4C\(A[0-7]\)$/ || u ~ /^MOVE\.W #\$80FE,3918\(A[0-7]\)$/ || u ~ /^MOVE\.W #\$80FE,\(A[0-7]\)$/ || u ~ /^MOVE\.B #\$FF,3936\(A[0-7]\)$/ || u ~ /^MOVE\.B #\$FF,3937\(A[0-7]\)$/ || u ~ /^MOVE\.W #\$FFFE,\(A[0-7]\)$/) has_tail_sentinel = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_RASTER_REF=" has_raster_ref
    print "HAS_TEMPLATE_WORDS=" has_template_words
    print "HAS_BUILD_BLOCK_CALL=" has_build_block_call
    print "HAS_BUILD_ROW_CALL=" has_build_row_call
    print "HAS_TAIL_SENTINEL=" has_tail_sentinel
    print "HAS_RETURN=" has_return
}
