BEGIN {
    has_entry = 0
    has_mask_30 = 0
    has_mask_20 = 0
    has_mask_40 = 0
    has_get_banner_call = 0
    has_refresh_ref = 0
    has_queue_store = 0
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

    if (u ~ /^GCOMMAND_MAPKEYCODETOPRESET:/) has_entry = 1
    if (u ~ /^ANDI\.[BW] #\$30,D[0-7]$/) has_mask_30 = 1
    if (u ~ /^ANDI\.[BW] #\$20,D[0-7]$/) has_mask_20 = 1
    if (u ~ /^ANDI\.[BW] #\$40,D[0-7]$/) has_mask_40 = 1
    if (index(u, "GCOMMAND_GETBANNERCHAR") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) has_get_banner_call = 1
    if (index(u, "CONFIG_REFRESHINTERVALSECONDS") > 0) has_refresh_ref = 1
    if ((index(u, "ESQPARS2_BANNERQUEUEBUFFER") > 0 || u ~ /^MOVE\.B D[0-7],\(A[0-7]\)$/ || u ~ /^MOVE\.B D[0-7],\$0\(A[0-7],D[0-7]\.W\)$/) && u ~ /^MOVE\.B /) has_queue_store = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MASK_30=" has_mask_30
    print "HAS_MASK_20=" has_mask_20
    print "HAS_MASK_40=" has_mask_40
    print "HAS_GET_BANNER_CALL=" has_get_banner_call
    print "HAS_REFRESH_REF=" has_refresh_ref
    print "HAS_QUEUE_STORE=" has_queue_store
    print "HAS_RETURN=" has_return
}
