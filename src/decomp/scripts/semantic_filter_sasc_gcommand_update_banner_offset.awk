BEGIN {
    has_entry = 0
    has_zero_guard = 0
    has_prev_save = 0
    has_delta_apply = 0
    has_wrap_hi = 0
    has_wrap_lo = 0
    has_update_calls = 0
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

    if (u ~ /^GCOMMAND_UPDATEBANNEROFFSET:/) has_entry = 1
    if (u ~ /^TST\.[BW] D[0-7]$/ || u ~ /^BEQ\.[A-Z]+ /) has_zero_guard = 1
    if (index(u, "GCOMMAND_BANNERROWINDEXCURRENT") > 0 && index(u, "GCOMMAND_BANNERROWINDEXPREVIOUS") > 0) has_prev_save = 1
    if (u ~ /^SUB\.[LW] D[0-7],GCOMMAND_BANNERROWINDEXCURRENT/ || u ~ /^SUB\.[LW] D[0-7],GCOMMAND_BANNERROWINDEXCURRENT\(A4\)$/) has_delta_apply = 1
    if (u ~ /^MOVEQ(\.L)? #\$62,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #98,D[0-7]$/ || u ~ /^SUB\.[LW] D[0-7],GCOMMAND_BANNERROWINDEXCURRENT/) has_wrap_hi = 1
    if (u ~ /^ADD\.[LW] D[0-7],GCOMMAND_BANNERROWINDEXCURRENT/ || u ~ /^ADD\.[LW] D[0-7],GCOMMAND_BANNERROWINDEXCURRENT\(A4\)$/) has_wrap_lo = 1
    if (index(u, "GCOMMAND_UPDATEBANNERROWPOINTERS") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) has_update_calls = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ZERO_GUARD=" has_zero_guard
    print "HAS_PREV_SAVE=" has_prev_save
    print "HAS_DELTA_APPLY=" has_delta_apply
    print "HAS_WRAP_HI=" has_wrap_hi
    print "HAS_WRAP_LO=" has_wrap_lo
    print "HAS_UPDATE_CALLS=" has_update_calls
    print "HAS_RETURN=" has_return
}
