BEGIN {
    has_entry = 0
    has_ptr_src = 0
    has_lo_targets = 0
    has_hi_targets = 0
    has_call_clear = 0
    has_rts = 0
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
    uline = toupper(line)

    if (uline ~ /^ESQSHARED4_BINDANDCLEARBANNERWORKRASTER:/ || uline ~ /^ESQSHARED4_BINDANDCLEARBANNERW[A-Z0-9_]*:/) has_entry = 1
    if (index(uline, "WDISP_BANNERWORKRASTERPTR") > 0 || index(uline, "WDISP_BANNERWORKRASTER") > 0) has_ptr_src = 1
    if (index(uline, "ESQ_BANNERWORKRASTERPTRA_LOWORD") > 0 || index(uline, "ESQ_BANNERWORKRASTERPTRMIRRORA_LOWORD") > 0 || index(uline, "ESQ_COPPERBANNERRASTERPOINTERLISTA") > 0 || index(uline, "ESQ_BANNERWORKRASTERPTRB_LOWORD") > 0 || index(uline, "ESQ_BANNERWORKRASTERPTRMIRRORB_LOWORD") > 0 || index(uline, "ESQ_COPPERBANNERRASTERPOINTERLISTB") > 0 || index(uline, "ESQ_BANNERWORKRASTERPTRA_LO") > 0 || index(uline, "ESQ_BANNERWORKRASTERPTRB_LO") > 0) has_lo_targets = 1
    if (index(uline, "ESQ_BANNERWORKRASTERPTRA_HIWORD") > 0 || index(uline, "ESQ_BANNERWORKRASTERPTRMIRRORA_HIWORD") > 0 || index(uline, "ESQ_BANNERWORKRASTERPTRTAILA_HIWORD") > 0 || index(uline, "ESQ_BANNERWORKRASTERPTRB_HIWORD") > 0 || index(uline, "ESQ_BANNERWORKRASTERPTRMIRRORB_HIWORD") > 0 || index(uline, "ESQ_BANNERWORKRASTERPTRTAILB_HIWORD") > 0 || index(uline, "ESQ_BANNERWORKRASTERPTRA_HI") > 0 || index(uline, "ESQ_BANNERWORKRASTERPTRB_HI") > 0 || uline ~ /^SWAP D[0-7]$/) has_hi_targets = 1
    if (index(uline, "ESQSHARED4_CLEARBANNERWORKRASTERWITHONES") > 0 || index(uline, "CLEARBANNERWORKRASTER") > 0) has_call_clear = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PTR_SRC=" has_ptr_src
    print "HAS_LO_TARGETS=" has_lo_targets
    print "HAS_HI_TARGETS=" has_hi_targets
    print "HAS_CALL_CLEAR=" has_call_clear
    print "HAS_RTS=" has_rts
}
