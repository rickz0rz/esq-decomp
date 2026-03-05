BEGIN {
    has_entry = 0
    has_sprintf = 0
    has_scan_loop = 0
    has_write_call = 0
    has_unlk = 0
    has_pop_regs = 0
    has_pop_stack = 0
    has_rts = 0
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

    if (l ~ /^DISKIO_WRITEDECIMALFIELD:/) has_entry = 1
    if (index(l, "GROUP_AE_JMPTBL_WDISP_SPRINTF") > 0) has_sprintf = 1
    if (l ~ /^TST\.B \([AD][0-7]\)\+$/ || l ~ /^TST\.B \([AD][0-7]\)$/) has_scan_loop = 1
    if (index(l, "DISKIO_WRITEBUFFEREDBYTES") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_write_call = 1
    if (l ~ /^UNLK A5$/) has_unlk = 1
    if (l ~ /^MOVEM\.L \(A7\)\+,D6\/D7\/A5$/ || l ~ /^MOVEM\.L \(A7\)\+,D6-D7\/A5$/) has_pop_regs = 1
    if (l ~ /^ADD\.W #\$?[0-9A-F]+,A7$/ || l ~ /^LEA \$[0-9A-F]+\(A7\),A7$/) has_pop_stack = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    if (has_unlk == 0 && has_pop_regs == 1 && has_pop_stack == 1) has_unlk = 1

    print "HAS_ENTRY=" has_entry
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_SCAN_LOOP=" has_scan_loop
    print "HAS_WRITECALL=" has_write_call
    print "HAS_UNLK=" has_unlk
    print "HAS_RTS=" has_rts
}
