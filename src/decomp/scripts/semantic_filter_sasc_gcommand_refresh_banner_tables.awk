BEGIN {
    has_entry = 0
    has_row_current_ref = 0
    has_phase_ref = 0
    has_build_call = 0
    has_row_plus_88 = 0
    has_snapshot0 = 0
    has_snapshot1 = 0
    has_snapshot2 = 0
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

    if (u ~ /^GCOMMAND_REFRESHBANNERTABLES:/) has_entry = 1
    if (index(u, "GCOMMAND_BANNERROWBYTEOFFSETCURRENT") > 0 || index(u, "GCOMMAND_BANNERROWBYTEOFFSETCURR") > 0) has_row_current_ref = 1
    if (index(u, "GCOMMAND_BANNERPHASEINDEXCURRENT") > 0) has_phase_ref = 1
    if (index(u, "GCOMMAND_BUILDBANNERROW") > 0 && (u ~ /^BSR(\.[A-Z]+)? / || u ~ /^JSR /)) has_build_call = 1
    if (u ~ /^MOVEQ(\.L)? #\$58,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #88,D[0-7]$/) has_row_plus_88 = 1
    if (index(u, "ESQPARS2_BANNERSNAPSHOTPLANE0DSTPTR") > 0 || index(u, "ESQPARS2_BANNERSNAPSHOTPLANE0DST") > 0) has_snapshot0 = 1
    if (index(u, "ESQPARS2_BANNERSNAPSHOTPLANE1DSTPTR") > 0 || index(u, "ESQPARS2_BANNERSNAPSHOTPLANE1DST") > 0) has_snapshot1 = 1
    if (index(u, "ESQPARS2_BANNERSNAPSHOTPLANE2DSTPTR") > 0 || index(u, "ESQPARS2_BANNERSNAPSHOTPLANE2DST") > 0) has_snapshot2 = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ROW_CURRENT_REF=" has_row_current_ref
    print "HAS_PHASE_REF=" has_phase_ref
    print "HAS_BUILD_CALL=" has_build_call
    print "HAS_ROW_PLUS_88=" has_row_plus_88
    print "HAS_SNAPSHOT0=" has_snapshot0
    print "HAS_SNAPSHOT1=" has_snapshot1
    print "HAS_SNAPSHOT2=" has_snapshot2
    print "HAS_RETURN=" has_return
}
