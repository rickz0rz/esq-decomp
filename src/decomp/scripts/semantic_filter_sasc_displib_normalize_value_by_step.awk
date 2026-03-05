BEGIN {
    has_entry = 0
    has_lower_loop = 0
    has_add_step = 0
    has_upper_loop = 0
    has_sub_step = 0
    has_return = 0
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

    if (l ~ /CMP\.W D6,D7/ || l ~ /CMP\.W .*D7/ || l ~ /BLT|BGE/) has_lower_loop = 1
    if (l ~ /ADD\.W D5,D7/ || l ~ /ADDQ\.W/) has_add_step = 1
    if (l ~ /CMP\.W D5,D7/ || l ~ /CMP\.W .*D5/ || l ~ /BLE|BGT/) has_upper_loop = 1
    if (l ~ /SUB\.W D5,D7/ || l ~ /SUBQ\.W/) has_sub_step = 1
    if (l ~ /^MOVE\.L D7,D0$/ || l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOWER_LOOP=" has_lower_loop
    print "HAS_ADD_STEP=" has_add_step
    print "HAS_UPPER_LOOP=" has_upper_loop
    print "HAS_SUB_STEP=" has_sub_step
    print "HAS_RETURN=" has_return
}
