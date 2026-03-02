BEGIN {
    label=0; nul_scan=0; dec=0; cmp=0; base_cmp=0; ret=0
}

/^TLIBA2_FindLastCharInString:$/ { label=1 }
/TST\.B|CMP\.B/ { nul_scan=1 }
/SUBQ\.L[[:space:]]+#1/ { dec=1 }
/CMP\.B/ { cmp=1 }
/CMPA\.L|CMP\.L/ { base_cmp=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (nul_scan) print "HAS_NUL_SCAN"
    if (dec) print "HAS_BACKWARD_STEP"
    if (cmp) print "HAS_CHAR_COMPARE"
    if (base_cmp) print "HAS_BASE_BOUND_CHECK"
    if (ret) print "HAS_RTS"
}
