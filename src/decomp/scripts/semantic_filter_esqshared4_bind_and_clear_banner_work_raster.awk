BEGIN {
    has_base_ptr_read = 0
    has_lo_a = 0
    has_lo_ma = 0
    has_lo_list_a = 0
    has_lo_b = 0
    has_lo_mb = 0
    has_lo_list_b = 0
    has_hi_a = 0
    has_hi_ma = 0
    has_hi_tail_a = 0
    has_hi_b = 0
    has_hi_mb = 0
    has_hi_tail_b = 0
    has_clear_call = 0
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

    if (u ~ /WDISP_BANNERWORKRASTERPTR/) has_base_ptr_read = 1

    if (u ~ /ESQ_BANNERWORKRASTERPTRA_LOWORD/) has_lo_a = 1
    if (u ~ /ESQ_BANNERWORKRASTERPTRMIRRORA_LOWORD/) has_lo_ma = 1
    if (u ~ /ESQ_COPPERBANNERRASTERPOINTERLISTA/) has_lo_list_a = 1
    if (u ~ /ESQ_BANNERWORKRASTERPTRB_LOWORD/) has_lo_b = 1
    if (u ~ /ESQ_BANNERWORKRASTERPTRMIRRORB_LOWORD/) has_lo_mb = 1
    if (u ~ /ESQ_COPPERBANNERRASTERPOINTERLISTB/) has_lo_list_b = 1

    if (u ~ /ESQ_BANNERWORKRASTERPTRA_HIWORD/) has_hi_a = 1
    if (u ~ /ESQ_BANNERWORKRASTERPTRMIRRORA_HIWORD/) has_hi_ma = 1
    if (u ~ /ESQ_BANNERWORKRASTERPTRTAILA_HIWORD/) has_hi_tail_a = 1
    if (u ~ /ESQ_BANNERWORKRASTERPTRB_HIWORD/) has_hi_b = 1
    if (u ~ /ESQ_BANNERWORKRASTERPTRMIRRORB_HIWORD/) has_hi_mb = 1
    if (u ~ /ESQ_BANNERWORKRASTERPTRTAILB_HIWORD/) has_hi_tail_b = 1

    if (u ~ /ESQSHARED4_CLEARBANNERWORKRASTERWITHONES/) has_clear_call = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_BASE_PTR_READ=" has_base_ptr_read
    print "HAS_LO_A=" has_lo_a
    print "HAS_LO_MA=" has_lo_ma
    print "HAS_LO_LIST_A=" has_lo_list_a
    print "HAS_LO_B=" has_lo_b
    print "HAS_LO_MB=" has_lo_mb
    print "HAS_LO_LIST_B=" has_lo_list_b
    print "HAS_HI_A=" has_hi_a
    print "HAS_HI_MA=" has_hi_ma
    print "HAS_HI_TAIL_A=" has_hi_tail_a
    print "HAS_HI_B=" has_hi_b
    print "HAS_HI_MB=" has_hi_mb
    print "HAS_HI_TAIL_B=" has_hi_tail_b
    print "HAS_CLEAR_CALL=" has_clear_call
    print "HAS_RTS=" has_rts
}
