BEGIN {
    has_entry = 0
    has_vposr_read = 0
    has_mask = 0
    has_chip_checks = 0
    has_flag_set = 0
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
    if (l ~ /VPOSR/ || l ~ /DFF004/) has_vposr_read = 1
    if (l ~ /ANDI\.W #\$7F00/ || l ~ /#\$7F00/) has_mask = 1
    if (l ~ /#\$3000/ || l ~ /#\$2000/ || l ~ /#\$3300/) has_chip_checks = 1
    if (l ~ /IS_COMPATIBLE_VIDEO_CHIP/) has_flag_set = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_VPOSR_READ=" has_vposr_read
    print "HAS_MASK=" has_mask
    print "HAS_CHIP_CHECKS=" has_chip_checks
    print "HAS_FLAG_SET=" has_flag_set
    print "HAS_RETURN=" has_return
}
