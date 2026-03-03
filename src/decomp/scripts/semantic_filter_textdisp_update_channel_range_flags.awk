BEGIN {
    has_label = 0
    has_source_mode = 0
    has_range = 0
    has_daymask = 0
    has_find_match = 0
    has_fallback = 0
    has_restore = 0
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

    if (uline ~ /^TEXTDISP_UPDATECHANNELRANGEFLAGS:/) has_label = 1
    if (uline ~ /TEXTDISP_CHANNELSOURCEMODE/) has_source_mode = 1
    if (uline ~ /CMP.W D0,D7/ && uline ~ /#67/ || uline ~ /#72/ || uline ~ /#77/) has_range = 1
    if (uline ~ /CLOCK_CURRENTDAYOFWEEKINDEX/ && uline ~ /ASL.L D0,D2/) has_daymask = 1
    if (uline ~ /BSR.W TEXTDISP_FINDENTRYMATCHINDEX/) has_find_match = 1
    if (uline ~ /^\.FALLBACK_DEFAULTS:/ || uline ~ /TEXTDISP_BANNERCHARSELECTED/) has_fallback = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D2\/D7/) has_restore = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_SOURCE_MODE=" has_source_mode
    print "HAS_RANGE=" has_range
    print "HAS_DAYMASK=" has_daymask
    print "HAS_FIND_MATCH=" has_find_match
    print "HAS_FALLBACK=" has_fallback
    print "HAS_RESTORE=" has_restore
}
