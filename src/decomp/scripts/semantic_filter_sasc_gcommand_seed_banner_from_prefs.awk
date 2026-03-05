BEGIN {
    has_entry = 0
    has_build_call = 0
    has_config_ref = 0
    has_table_a = 0
    has_table_b = 0
    has_head_store = 0
    has_d9_store = 0
    has_fffe_store = 0
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

    if (u ~ /^GCOMMAND_SEEDBANNERFROMPREFS:/) has_entry = 1
    if (index(u, "GCOMMAND_BUILDBANNERTABLES") > 0 && (u ~ /^BSR\./ || u ~ /^JSR /)) has_build_call = 1
    if (index(u, "CONFIG_BANNERCOPPERHEADBYTE") > 0) has_config_ref = 1
    if (index(u, "ESQ_COPPERLISTBANNERA") > 0) has_table_a = 1
    if (index(u, "ESQ_COPPERLISTBANNERB") > 0) has_table_b = 1
    if (u ~ /^MOVE\.B D[0-7],\(A[0-7]\)$/ || u ~ /^MOVE\.B .*\(A[0-7]\)$/) has_head_store = 1
    if (u ~ /^MOVE\.B #\$D9,1\(A[0-7]\)$/ || u ~ /^MOVEQ(\.L)? #\-39,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$D9,D[0-7]$/ || u ~ /^MOVE\.B D[0-7],ESQ_COPPERLISTBANNER[AB]\+\$1\(A4\)$/) has_d9_store = 1
    if (u ~ /^MOVE\.W #\$FFFE,2\(A[0-7]\)$/ || u ~ /^MOVEQ(\.L)? #\-2,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$FE,D[0-7]$/ || u ~ /^MOVE\.W D[0-7],ESQ_COPPERLISTBANNER[AB]\+\$2\(A4\)$/) has_fffe_store = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_BUILD_CALL=" has_build_call
    print "HAS_CONFIG_REF=" has_config_ref
    print "HAS_TABLE_A=" has_table_a
    print "HAS_TABLE_B=" has_table_b
    print "HAS_HEAD_STORE=" has_head_store
    print "HAS_D9_STORE=" has_d9_store
    print "HAS_FFFE_STORE=" has_fffe_store
    print "HAS_RETURN=" has_return
}
