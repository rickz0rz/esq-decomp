BEGIN {
    has_entry = 0
    has_flag = 0
    has_width_lrbn = 0
    has_width_banner = 0
    has_copy_short = 0
    has_copy_long = 0
    has_terminator_9 = 0
    has_terminator_199 = 0
    has_return = 0
    saw_copy_call = 0
    saw_len_9 = 0
    saw_len_199 = 0
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

    if (u ~ /^TEXTDISP_SETENTRYTEXTFIELDS:/ || u ~ /^TEXTDISP_SETENTRYTEXTFIELD[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "CONFIG_LRBN_FLAGCHAR") > 0) has_flag = 1
    if (index(u, "TEXTDISP_LRBNENTRYWIDTHPX") > 0) has_width_lrbn = 1
    if (index(u, "CONFIG_BANNERCOPPERHEADBYTE") > 0) has_width_banner = 1
    if (index(u, "STRING_COPYPADNUL") > 0) saw_copy_call = 1
    if (index(u, "($9).W") > 0 || index(u, "9.W") > 0 || index(u, "#9") > 0 || index(u, "#$9") > 0) saw_len_9 = 1
    if (index(u, "($C7).W") > 0 || index(u, "199.W") > 0 || index(u, "#199") > 0 || index(u, "#$C7") > 0) saw_len_199 = 1
    if ((index(u, "9(A0)") > 0 || index(u, "$9(A0)") > 0 || index(u, "$9(A5)") > 0) && (index(u, "MOVE.B") > 0 || index(u, "CLR.B") > 0)) has_terminator_9 = 1
    if ((index(u, "199(A0)") > 0 || index(u, "$C7(A0)") > 0 || index(u, "$D1(A5)") > 0) && (index(u, "MOVE.B") > 0 || index(u, "CLR.B") > 0)) has_terminator_199 = 1
    if (u == "RTS") has_return = 1
}

END {
    if (saw_copy_call && saw_len_9) has_copy_short = 1
    if (saw_copy_call && saw_len_199) has_copy_long = 1
    print "HAS_ENTRY=" has_entry
    print "HAS_FLAG=" has_flag
    print "HAS_WIDTH_LRBN=" has_width_lrbn
    print "HAS_WIDTH_BANNER=" has_width_banner
    print "HAS_COPY_SHORT=" has_copy_short
    print "HAS_COPY_LONG=" has_copy_long
    print "HAS_TERMINATOR_9=" has_terminator_9
    print "HAS_TERMINATOR_199=" has_terminator_199
    print "HAS_RETURN=" has_return
}
