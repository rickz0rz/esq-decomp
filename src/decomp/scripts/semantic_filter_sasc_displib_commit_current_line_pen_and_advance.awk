BEGIN {
    has_entry = 0
    has_read_idx = 0
    has_probe_len = 0
    has_advance = 0
    has_target_cmp = 0
    has_store_pen = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next

    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1
    if (l ~ /DISPLIB_COMMITCURRENTLINEPENANDA/) has_entry = 1

    if (l ~ /CURRENTLINEINDEX/ && l ~ /MOVE\.W/) has_read_idx = 1
    if ((l ~ /LINELENGTHTABLE/ && (l ~ /TST\.W/ || l ~ /CMP\.W/)) || l ~ /^TST\.W \$0\(A0,D0\.L\)$/ || l ~ /^TST\.W \(A0\)$/) has_probe_len = 1
    if (l ~ /ADDQ\.W #\$?1,D1/ || l ~ /ADDQ\.W #\$?1,D0/ || (l ~ /CURRENTLINEINDEX/ && l ~ /MOVE\.W D1/)) has_advance = 1
    if (l ~ /TARGETLINEINDEX/ || l ~ /^CMP\.W D0,D6$/ || l ~ /^CMP\.W D1,D0$/) has_target_cmp = 1
    if (l ~ /LINEPENTABLE/ || l ~ /^MOVE\.L D7,\$0\(A0,D0\.L\)$/ || l ~ /^MOVE\.L D7,\(A0\)$/) has_store_pen = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_READ_IDX=" has_read_idx
    print "HAS_PROBE_LEN=" has_probe_len
    print "HAS_ADVANCE=" has_advance
    print "HAS_TARGET_CMP=" has_target_cmp
    print "HAS_STORE_PEN=" has_store_pen
}
